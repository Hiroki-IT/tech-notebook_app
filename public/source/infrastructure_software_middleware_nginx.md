# Nginx

## 01. Tips

### コマンドリファレンス

#### ・nginx

参考：https://httpd.apache.org/docs/trunk/ja/programs/apachectl.html

<br>

### よく使うコマンド

#### ・起動／停止

```shell
$ sudo systemctl start nginx
$ sudo systemctl stop nginx
```

#### ・設定ファイルのバリデーション

```shell
$ sudo service nginx configtest

# もしくはこちら
$ sudo nginx -t
```

#### ・設定ファイルの反映と安全な再起動

```shell
$ sudo systemctl reload nginx
```

#### ・読み込まれた設定ファイルと設定値の一覧

読み込まれている全ての設定ファイル（```include```ディレクティブの対象も含む）の内容を展開して表示する．

```shell
$ sudo nginx -T
```

<br>

## 02. Nginxの用途

### Webサーバのミドルウェアとして

#### ・PHP-FPMとの組み合わせ

静的ファイルのリクエストが送信されてきた場合，Nginxはそのままレスポンスを返信する．動的ファイルのリクエストが送信されてきた場合，Nginxは，FastCGIプロトコルを介して，PHP-FPMにリクエストをリダイレクトする．

![NginxとPHP-FPMの組み合わせ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/NginxとPHP-FPMの組み合わせ.png)

**＊実装例＊**

 ```shell
# 設定ファイルのバリデーション
$ php-fpm -t
 ```

**＊実装例＊**

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    listen      80;
    server_name example.com;
    root        /var/www/example/public;
    index       index.php index.html;

    include /etc/nginx/default/xxx.conf;

    #『/』で始まる全てのリクエストの場合
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    #--------------------------------------------------
    # FastCGIを用いたAppサーバへの転送，受信
    # OSによって，fastcgi_paramsファイルの必要な設定が異なる
    #--------------------------------------------------
    location ~ \.php$ {
        # リダイレクト先のTCPソケット
        fastcgi_pass   127.0.0.1:9000;
        # もしくは，Unixソケット
        # fastcgi_pass unix:/run/php-fpm/www.sock;
        
        # リダイレクト先のURL（rootディレクティブ値+パスパラメータ）
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;

        # 設定ファイルからデフォルト値を読み込む
        include        fastcgi_params;
    }
}
```

#### ・fastcgi_paramsファイルについて 

nginx.confファイルによって読み込まれる```/etc/nginx/fastcgi_params```ファイルは，PHP-FPMに関する変数が定義されたファイルである．OSやそのバージョンによっては，変数のデフォルト値が書き換えられていることがある．実際にサーバ内に接続し，上書き設定が必要なものと不要なものを判断する必要がある．以下は，Debian 10のデフォルト値である．

**＊実装例＊**

```nginx
#--------------------------------------
# FastCGIを用いたAppサーバへの転送，受信
# OSによって，fastcgi_paramsファイルの必要な設定が異なる
#--------------------------------------
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REQUEST_SCHEME     $scheme;
fastcgi_param  HTTPS              $https if_not_empty;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

# PHPだけで必要な設定
fastcgi_param  REDIRECT_STATUS    200;
```

#### ・www.confファイルについて

php.iniファイルによって読み込まれる```/etc/php-fpm.d/www.conf```ファイルは，PHP-FPMに関する設定が定義されたファイルである．php.iniよりも優先されるので，設定項目が重複している場合は，こちらを変更する．

**＊実装例＊**

```ini
[www]

# プロセスのユーザ名，グループ名
user = nginx
group = nginx

# Unixソケットのパス
listen = /run/php-fpm/www.sock

# PHP-FPMと組み合わせるミドルウェアを指定（apacheと組み合わせることも可能）
listen.owner = nginx
listen.group = nginx

# コメントアウト推奨 
;listen.acl_users = apache,nginx

# TCPソケットのIPアドレス
listen.allowed_clients = 127.0.0.1

pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35

# ログファイルの場所
slowlog = /var/log/php-fpm/www-slow.log
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on

# セッションの保存方法．ここではredisのキーとして保存（デフォルト値はfiles）
php_value[session.save_handler] = redis
# セッションの保存場所（デフォルト値は，/var/lib/php/session）
php_value[session.save_path]    = "tcp://xxxxx.r9ecnn.ng.0001.apne1.cache.amazonaws.com:6379"

# 
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
```

<br>

### ロードバランサ－のミドルウェアとして

HTTPプロトコルで受信したリクエストを，HTTPSプロトコルに変換して転送する．

**＊実装例＊**

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 80;
    return 301 https://$host$request_uri;
}

#-------------------------------------
# HTTPSリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 443 ssl http2;
    index index.php index.html;

    #-------------------------------------
    # SSL
    #-------------------------------------
    ssl on;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    add_header Strict-Transport-Security "max-age=86400";

    location / {
        proxy_pass http://app1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Port $remote_port;
    }
}
```

<br>

### リバースProxyのミドルウェアとして

前提として，ロードバランサ－から転送されたHTTPリクエストを受信するとする．静的コンテンツのリクエストは，リバースProxy（Nginx）でレスポンスを返信する．Webサーバは，必ずリバースProxyを経由して，動的リクエストを受信する．

**＊実装例＊**

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 80;
    return 301 https://$host$request_uri;
    
    #-------------------------------------
    # 静的ファイルであればNginxでレスポンス
    #-------------------------------------
    location ~ ^/(images|javascript|js|css|flash|media|static)/ {
        root /var/www/example/static;
        expires 30d;
    }

    #-------------------------------------
    # 動的ファイルであればWebサーバに転送
    #-------------------------------------
    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

<br>

## 03-01. Mainモジュール

### ディレクティブ

#### ・```user```

本設定ファイルの実行ユーザとグループを設定する．グループ名を入力しなかった場合，ユーザ名と同じものが自動的に設定される．

```nginx
user  www www;
```

#### ・```worker_processes```

```nginx
worker_processes  5;
```

#### ・```error_log```

```nginx
error_log  logs/error.log;
```

#### ・```pid``` 

```nginx
pid  logs/nginx.pid;
```

#### ・```worker_rlimit_nofile```

```nginx
worker_rlimit_nofile  8192;
```

<br>

## 03-02. Configurationモジュール

### ディレクティブ

#### ・```include```

共通化された設定ファイルを読み込む．アスタリスクによるワイルドカードに対応している．

```nginx
include /etc/nginx/conf.d/*.conf;
```

<br>

### 設定ファイルの種類

#### ・```/etc/nginx/conf.d/*.conf```ファイル

デフォルトの設定が定義されているいくつかのファイル．基本的には読み込むようにする．ただし，nginx.confファイルの設定が上書きされてしまわないかを注意する．

```nginx
include /etc/nginx/conf.d/*.conf;
```

#### ・```/etc/nginx/mime.types```ファイル

リクエストのContent-TypeのMIMEタイプとファイル拡張子の間の対応関係が定義されているファイル．

```nginx
include /etc/nginx/mime.types;
```

#### ・```/usr/share/nginx/modules/*.conf```ファイル

モジュールの読み込み処理が定義されているファイル．

```nginx
include  /usr/share/nginx/modules/*.conf;
```

例えば，```mod-http-image-filter.conf```ファイルの内容は以下の通り．

```nginx
load_module "/usr/lib64/nginx/modules/ngx_http_image_filter_module.so";
```

<br>

## 03-03. Eventsモジュール

### ブロック

#### ・```events```ブロック

**＊実装例＊**

```nginx
events {
  worker_connections  1024;
}
```

<br>

### ディレクティブ

#### ・```worker_connections```

workerプロセスが同時に処理可能なコネクションの最大数を設定する．

```nginx
worker_connections  1024;
```

<br>

## 03-04. HTTPCoreモジュール

### ブロック

#### ・```http```ブロック

全てのWebサーバに共通する処理を設定する．

```nginx
http {
    server_tokens      off;
    include            /etc/nginx/mime.types;
    default_type       application/octet-stream;
    log_format         main  "$remote_addr - $remote_user [$time_local] "$request" "
                             "$status $body_bytes_sent "$http_referer" "
                             ""$http_user_agent" "$http_x_forwarded_for"";
    access_log         /var/log/nginx/access.log  main;
    sendfile           on;
    tcp_nopush         on;
    keepalive_timeout  65;
    default_type       application/octet-stream;
    include            /etc/nginx/mime.types;
    include            /etc/nginx/conf.d/*.conf;
        
    server {
        # ～ 省略 ～
    }
}
```

#### ・```server```ブロック

個別のWebサーバの処理を設定する．

```nginx
server {
    listen      80;
    server_name example.com;
    root        /var/www/example;
    index       index.php index.html;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass  unix:/run/php-fpm/www.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include       fastcgi_params;
    }
}
```

#### ・```location```ブロック

個別のWebサーバにおける特定のURLの処理を設定する．

**＊実装例＊**

各設定の優先順位に沿った以下の順番で実装した方が良い．

```nginx
# 1. ドキュメントルートを指定したリクエストの場合
location = / {

}

# 2. 『/images/』で始まるリクエストの場合
location ^~ /images/ {

}

# 3と4. 末尾が、『gif，jpg，jpegの形式』 のリクエストの場合
# バックスラッシュでドットをエスケープし，任意の文字ではなく『ドット文字』として認識できるようにする．
location ~* \.(gif|jpg|jpeg)$ {

}

# 5-1. 『/docs/』で始まる全てのリクエストの場合
location /docs/ {

}

# 5-2. 『/』で始まる全てのリクエストの場合
location / {
    # 『/.aaa.html』を探し，『/.aaa.html/』もなければ，『/index.html』で200レスポンス
    # 全てがない場合，404レスポンス．
    try_files $uri $uri/ /index.html =404;
}
```

ルートの一致条件は，以下の通りである．

| 優先順位 | prefix | ルートの一致条件                         | ルートの具体例                                               |
| :------: | :----: | ---------------------------------------- | ------------------------------------------------------------ |
|    1     |   =    | 指定したルートに一致する場合．           | ```http://example.com/```                                    |
|    2     |   ^~   | 指定したルートで始まる場合．             | ```http://example.com/images/aaa.gif```                      |
|    3     |   ~    | 正規表現（大文字・小文字を区別する）．   | ```http://example.com/images/AAA.jpg```                      |
|    4     |   ~*   | 正規表現（大文字・小文字を区別しない）． | ```http://example.com/images/aaa.jpg```                      |
|    5     |  なし  | 指定したルートで始まる場合．             | ・```http://example.com/aaa.html```<br>・```http://example.com/docs/aaa.html``` |

#### ・リダイレクトとリライトの違い

リダイレクトでは，リクエストされたURLをサーバ側で新しいURLに書き換え，リクエストを再送信する．そのため，クライアント側は新しいURLで改めてリクエストを送信することになる．一方で，リライトでは，リクエストされたURLをサーバ側で新しいURLに書き換え，そのURLでレンダリングを行う．そのため，クライアント側は古いURLのままリクエストを送信することになる．その他の違いについては，以下を参考にせよ．

参考：https://blogs.iis.net/owscott/url-rewrite-vs-redirect-what-s-the-difference

<br>

### ディレクティブ

#### ・```add_header```

レスポンスヘッダーを設定する．

```nginx
# Referrer-Policyヘッダーに値を設定する
add_header Referrer-Policy "no-referrer-when-downgrade";
```

#### ・```default_type```

Content-Typeが，mime.typesファイルにないMIME typeであった場合に，適用するMIME type．

```nginx
# application/octet-stream：任意のMIME type（指定なし）と見なして送信
default_type application/octet-stream
```

#### ・```listen```

開放するポート```80```を設定する．

```nginx
listen 80;
```

開放するポート```443```を設定する．

```nginx
listen 443 ssl;
```

#### ・```sendfile```

クライアントへのレスポンス時に，ファイル送信のためにLinuxのsendfileシステムコールを使用するかどうかを設定する．ファイル返信処理をOS内で行うため，処理が速くなる．使用しない場合，Nginxがレスポンス時に自身でファイル返信処理を行う．

```nginx
sendfile on;
```

#### ・```server_name```

パブリックIPアドレスに紐づくドメイン名を設定する．

```nginx
server_name example.com;
```

パブリックIPアドレスを直接記述してもよい．

```nginx
server_name 192.168.0.0;
```

#### ・```ssl```

NginxでHTTPSプロトコルを受信する場合，sslプロトコルを有効にする必要がある．

```nginx
ssl on;
```

#### ・```ssl_certificate```

PEM証明書のパスを設定する．

```nginx
ssl_certificate /etc/nginx/ssl/server.crt;
```

#### ・```ssl_certificate_key```

PEM秘密鍵のパスを設定する．

```nginx
ssl_certificate_key /etc/nginx/ssl/server.key;
```

#### ・```tcp_nopush```

上述のLinuxの```sendfile```システムコールを使用する場合に，適用できる．クライアントへのレスポンス時，ヘッダーとファイルを，一つのパケットにまとめて返信するかどうかを設定する．

```nginx
tcp_nopush on;
```

<br>

### ヘルスチェックの受信

#### ・nginxによるレスポンス

Webサーバのみヘルスチェックを受信する．ヘルスチェック用の```server```ブロックで，```gif```ファイルのレスポンスを返信するように```location```ブロックを定義する．Nginxでアクセスログを出力する必要はないため，```location```ブロックでは```access_log```を無効化する．

**＊実装例＊**

```nginx
server {
    listen 80      default_server;
    listen [::]:80 default_server;
    root           /var/www/example;
    index          index.php index.html;

    location /healthcheck {
        empty_gif;
        access_log off;
        break;
    }
}
```

#### ・アプリケーションによるレスポンス

Webサーバとアプリケーションの両方でヘルスチェックを受信する．アプリケーション側に```200```ステータスのレスポンスを返信するエンドポイントを実装したうえで，ヘルスチェック用の```server```ブロックで，アプリケーションにルーティングするように```location```ブロックを定義する．Nginxでアクセスログを出力する必要はないため，```location```ブロックでは```access_log```を無効化する．

**＊実装例＊**

```nginx
server {
    listen 80      default_server;
    listen [::]:80 default_server;
    root           /var/www/example;
    index          index.php index.html;

    location /healthcheck {
        try_files $uri $uri/ /index.php?$query_string;
        access_log off;
    }
}
```

<br>

### ```upstream```ブロック

**＊実装例＊**

```nginx
upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
}
```
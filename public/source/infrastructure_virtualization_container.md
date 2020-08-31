

# コンテナ

## 01. Dockerによるコンテナの構築

### Dockerの操作

#### ・Dockerクライアント

Dockerクライアントは，接続によって，Dockerデーモンを操作できる．

#### ・Dockerデーモン

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![Dockerの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerの仕組み.png)



## 02. コンテナに接続するまでの手順

### 手順の流れ

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerfileの作成からコンテナ構築までの手順.png)

1. Docker Hubから，ベースとなるイメージをインストールする．
2. Dockerfileがイメージレイヤーからなるイメージをビルド．
3. コマンドによって，イメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，構築されたコンテナを起動．
5. コマンドによって，起動中のコンテナに接続．



## 02-02. イメージのインストール

### ベースとなるイメージ（ベースイメージ）のインストール

#### ・Docker Hubとは

イメージは，実行OSによらずに一貫してビルドできるため，配布できる．Docker Hubには，カスタマイズする上でのベースとなるイメージが提供されている．

#### ・ベースイメージの種類

| イメージ   | 特徴                                                         | 相性の良いシステム例 |
| ---------------- | ------------------------------------------------------------ | -------------------- |
| **scratch**      | 以下の通り，何も持っていない<br>・OS：無<br>・パッケージ：無<br>・パッケージマネージャ：無 | ？                   |
| **BusyBox**      | ・OS：Linux（※ディストリビューションではない）<br>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：無 | 組み込みシステム     |
| **Alpine Linux** | ・OS：Linux（※ディストリビューションではない）<br/>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：Apk | ？                   |

#### ・ベースイメージをインストール

```bash
# レジストリ側に保管されているイメージを検索
$ docker search {イメージ名}
```
```bash
# レジストリ側のイメージをクライアント側にインストール
$ docker pull {イメージ名}
```
```bash
# ホストOSにインストールされたイメージを確認
$ docker images
```

#### ・イメージを削除するコマンド

```bash
# コンテナに使用されていないイメージを一括で削除
$ docker image prune
```
```bash
# タグ名のないイメージのみを全て削除
$ docker rmi --force $(sudo docker images --filter "dangling=true" --all --quiet)
```



## 02-03. イメージのビルド

### コマンド

#### ・イメージのビルド

```bash
# キャッシュ無しで，指定のDockerfileを基に，イメージをビルド
# 失敗したときは削除する
$ docker build --file Dockerfile --tag tech-notebook:latest --force-rm=true --no-cache .
```

#### ・Docker Hubに登録

```bash
# コンテナからイメージを作成
$ docker commit -a {作成者名} {コンテナ名} {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}
```
```bash
# ホストOSで作成したイメージをレジストリ側にアップロード
$ docker push {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}
```



### イメージレイヤーの積み重ね

#### ・Dockerfileの仕組み

![イメージレイヤーからなるイメージのビルド](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/イメージのビルド.png)

任意のイメージをベースとして，新しいイメージをビルドするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．


#### ・Dockerfileの記述方法

任意のイメージをベースとして，新しいイメージをビルドするためには，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

**【実装例】**

NginxのイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，文字列形式，JSON形式がある．ここでは，JSON形式で記述する．

```dockerfile
# ベースのイメージ（CentOS）を，コンテナにインストール
FROM centos:8

# ubuntu上に，nginxをインストール
RUN yum update -y \
   && yum install -y \
　　    nginx

# ホストOSの設定ファイルを，コンテナ側の指定ディレクトリにコピー
COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

# nginxをデーモン起動
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# 処理は発生しない．アプリケーションのポート番号80（HTTP）をドキュメンテーションとして記載
EXPOSE 80
```

| 命令                 | 処理                                                         |
| -------------------- | ------------------------------------------------------------ |
| **```FROM```**       | ベースのイメージを，コンテナにインストール.            |
| **```RUN```**        | ベースイメージ上に，ソフトウェアをインストール.              |
| **```COPY```**       | ・ホストOSのファイルをイメージレイヤー化し，コンテナの指定ディレクトリにコピー.<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```CMD```**        | イメージレイヤーをデーモン起動.                              |
| **```VOLUME```**     | Volumeマウントを行う．```COPY```とは異なり，ビルド後のコードの変更が反映される．Docker Composeで記述した方が良い． |
| **```EXPOSE```**     | 処理は発生しない．アプリケーションのポート番号をドキュメンテーションとして記載する． |
| **```ENTRYPOINT```** | 指定されたスクリプトを実行し，終了するとコンテナを停止する．常駐スクリプトのために用いる． |
| **```ENV```**        | OS上のコマンド処理で扱える変数を定義する．Dockerfileの命令では扱えない．```ARG```との違いの具体例については下記． |
| **```ARG```**        | Dockerfikeの命令で扱える変数を定義する．OS上のコマンド処理では扱えない．```ENV```との違いの具体例については下記． |
| **```ADD```**     | ・ホストOSのファイルを，コンテナの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う．<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```WORKDIR```** | 絶対パスによる指定で，現在のディレクトリを変更.              |

#### ・ENVとARGの違い

一つ目に，```ENV```が使えて，```ARG```が使えない例．

```dockerfile
# ENVは，OS上のコマンド処理で扱える変数を定義
ARG PYTHON_VERSION="3.8.0"
RUN pyenv install ${PYTHON_VERSION}

# ARGは，OS上のコマンド処理では扱えない
ARG PYTHON_VERSION="3.8.0"
RUN pyenv install ${PYTHON_VERSION} # ===> 変数を展開できない
```

二つ目に，```ARG```が使えて，```ENV```が使えない例．

```dockerfile
# ARGは,Dockerfikeの命令で扱える変数を定義
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}

# ENVは，OS上のコマンド処理では扱えない
ENV OS_VERSION "8"
FROM centos:${OS_VERSION} # ===> 変数を展開できない
```

三つ目に，これらの違いによる可読性の悪さの対策として，```ENV```と```ARG```を組み合わせた例．

```dockerfile
# 最初に全て，ARGで定義
ARG CENTOS_VERSION="8"
ARG PYTHON_VERSION="3.8.0"

# 変数展開できる
FROM centos:${OS_VERSION}

# ARGを事前に宣言
ARG PYTHON_VERSION
# 必要に応じて，事前にENVに詰め替える．
ENV PYTHON_VERSION ${PYTHON_VERSION}

# 変数展開できる
RUN pyenv install ${PYTHON_VERSION}
```


#### ・Docker Hubに対する継続的インテグレーション

| 方法                  | 仕組み                                            |
| --------------------- | ------------------------------------------------- |
| GitHub Actions        | GitHubが，Docker Hubに対して，pushを行う．        |
| Circle CI             | GitHubが，Circle CIに対して，送信WebHookを行う．  |
| Docker Hub Auto Build | GitHubが，Docker Hubに対して，送信WebHookを行う． |

#### ・Dockerfileを使用するメリット

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．

![Dockerfileのメリット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerfileのメリット.png)

## 02-04 イメージの軽量化

### プロセス単位によるDockerfileの分割

これは，Dockerの原則である．アプリケーションを稼働させるには，最低限，Webサーバミドルウェア，アプリケーション，DBMSが必要である．これらを，個別のコンテナで稼働させ，ネットワークで接続するようにする．

![プロセス単位のコンテナ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/プロセス単位のコンテナ.png)



### キャッシュの削除

Unixユーティリティをインストールすると，キャッシュが残る．


```dockerfile
FROM centos:8

RUN dnf upgrade -y \
  && dnf install -y \
      curl \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf
```




### ```RUN```コマンドをまとめる

Dockerfileの各命令によって，イメージ レイヤーが一つ増えてしまうため，同じ命令に異なるパラメータを与える時は，これを一つにまとめてしまう方が良い．例えば，以下のような時，

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y isntall httpd
RUN yum -y install php
RUN yum -y install php-mbstring
RUN yum -y install php-pear
```

これは，以下のように一行でまとめられる．イメージレイヤーが少なくなり，イメージを軽量化することができる．

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install httpd php php-mbstring php-pear
```

さらに，これは以下のようにも書くことができる．

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install \
     httpd \
     php \
     php-mbstring \
     php-pear
```



### マルチステージビルド

#### ・マルチステージビルドとは

一つのDockerfile内に複数の独立したステージを定義する方法．以下の手順で作成する．

1. シングルステージビルドに成功するDockerfileを作成する．
2. ビルドによって生成されたバイナリファイルがどこに配置されるかを場所を調べる．
3. Dockerfileで，二つ目の```FROM```を宣言する．
4. 一つ目のステージで，バイナリファイルをコンパイルするだけで終わらせる．
5. 二つ目のステージで，Unixユーティリティをインストールする．また，バイナリファイルを一つ目のステージからコピーする．

#### ・コンパイルされたバイナリファイルを再利用

**【実装例】**

```dockerfile
# 中間イメージ
FROM golang:1.7.3 AS builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# 最終イメージ
FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"]  
```

#### ・実行環境別にステージを分ける

```dockerfile

```



### 可能な限りOSイメージをベースとしない

#### ・OSイメージをベースとした場合（悪い例）

OSベンダーが提供するベースイメージを使用すると，不要なバイナリファイルが含まれてしまう．原則として，一つのコンテナで一つのプロセスしか実行せず，OS全体のシステムは不要なため，OSイメージをベースとしないようにする．

**【実装例】**

```dockerfile
# CentOSイメージを，コンテナにインストール
FROM centos:8

# PHPをインストールするために，EPELとRemiリポジトリをインストールして有効化．
RUN dnf upgrade -y \
  && dnf install -y \
      https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
      https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
  && dnf module enable php:remi-${PHP_VERSION} \
  # フレームワークの要件のPHP拡張機能をインストール
  && dnf install -y \
      php \
      php-bcmath \
      php-ctype \
      php-fileinfo \
      php-json \
      php-mbstring \
      php-openssl \
      php-pdo \
      php-tokenizer \
      php-xml \
  && dnf clean all \
  && rm -Rf /var/cache/dnf

# DockerHubのComposerイメージからバイナリファイルを取得
COPY --from=composer /usr/bin/composer /usr/bin/composer
```

**【実装例】**

```dockerfile
# CentOSイメージを，コンテナにインストール
FROM centos:8

# nginxをインストール
RUN dnf upgrade -y \
　　&& dnf install -y \
　　   nginx \
　　   curl \
　　&& dnf clean all \
　　&& rm -Rf /var/cache/dnf

COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

EXPOSE 80
```

#### ・ミドルウェアイメージをベースとした場合（良い例）

代わりに，ミドルウェアベンダーが提供するベースイメージを使用するようにする．

```dockerfile
# Nginxイメージを，コンテナにインストール
FROM nginx:1.19

# NginxイメージがUbuntuベースなためにapt-getコマンド
RUN apt-get updatedocke -y \
  && apt-get install -y \
     curl \
  && apt-get clean

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf
```

#### ・言語イメージをベースとした場合

代わりに，言語ベンダーが提供するベースイメージを使用するようにする．

```dockerfile
# ここに実装例
```

#### ・alpineイメージをベースとした場合

```dockerfile
# ここに実装例
```



## 02-05. イメージ上でのコンテナレイヤーの生成，コンテナの構築

### コンテナレイヤーの生成

#### ・コンテナレイヤーとは

イメージレイヤーの上に積み重ねられる

![イメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/イメージ上へのコンテナレイヤーの積み重ね.png)

### コマンド

#### ・コンテナレイヤー生成，コンテナ構築

```bash
# コンテナレイヤーを生成し，コンテナを構築．起動はしない．
$ docker create {コンテナ名} {使用イメージ名}
```

#### ・構築に失敗した時のデバッグ

```bash
# 指定した行数だけ，ログを出力し続ける．
$ docker logs --follow=true --tail=500 {コンテナ名}
```

#### ・構築されたコンテナの起動

```start```コマンドでは，アタッチモードでしか起動できない．

```bash
# 停止中コンテナをアタッチモードで起動
$ docker start -i {停止中コンテナ名}
```

```run```コマンドでは，アタッチモードとデタッチモードを選ぶことができる．

```bash
# コンテナレイヤーを生成し，コンテナを構築，起動までを行う．

# アタッチモードによる起動．フォアグラウンドで起動する．
$ docker run -a -it --name {コンテナ名} {使用イメージ名} -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --net {ネットワーク名}

# デタッチドモードによる起動．バックグラウンドで起動する．
$ docker run -d -it --name {コンテナ名} {使用イメージ名} -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --net {ネットワーク名}
```

#### ・構築されたコンテナの停止／削除

```bash
# 起動中コンテナを停止
$ docker stop {起動中コンテナ名}
```
```bash
# 全てのコンテナを停止
$ docker stop $(docker ps --all --quiet)
```
```bash
# 停止中のコンテナのみを全て削除
$ docker container prune
```
```bash
# 起動中／停止中の全てコンテナを削除
$ docker rm --force $(docker ps --all --quiet)
```



### 起動モードの違い

#### ・アタッチモード起動

アタッチモードは，フォアグラウンド起動である．ターミナルにプロセスのログが表示されないため，同一ターミナルで他のコマンドを入力できる．

```bash
# -a：atattch mode
$ docker run -a -it --name {コンテナ名} {使用イメージ名} -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --net {ネットワーク名}
```

#### ・デタッチドモード起動

デタッチドモードは，バックグラウンド起動である．ターミナルにプロセスのログが表示され続けるため，同一ターミナルで他のコマンドを入力できない．プロセスのログを監視できるが，他のプロセスを入力するためには，そのターミナル上でコンテナを停止させる必要がある．


```bash
# -d；detached mode
$ docker run -d -it --name {コンテナ名} {使用イメージ名} -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --net {ネットワーク名}
```



## 02-06. 起動中のコンテナの操作

### コマンド

#### ・起動中のコンテナ情報を表示

```bash
# コンテナの起動と停止にかかわらず，IDなどを一覧で表示．
$ docker ps -a
```
```bash
# 起動中コンテナの全ての設定内容を表示
# grepとも組み合わせられる．
$ docker inspect {コンテナID}
$ docker inspect {コンテナID} | grep IPAddress
```

#### ・起動中のコンテナに接続

```bash
# デタッチドモードで起動中のコンテナに接続
$ docker attach {起動中コンテナ名}

# デタッチドモードで起動中のコンテナに接続
# i：interactive，t：tty
$ docker exec -it {起動中コンテナ名} /bin/bash
```

#### ・起動中のコンテナにホストOSのファイルをコピー

Dockerfileの```COPY```コマンドを使用してコンテナ内に配置しているファイルに関して，変更のたびにイメージをビルドを行うことは面倒のため，ホストOSからコンテナにコピーし，再読み込みを行う．

```bash
# ホストのファイルをコンテナにコピー
$ docker cp ./docker/www/nginx.conf {コンテナID}:/etc/nginx/nginx.conf

# コンテナに接続後に，nginxの設定ファイルを再読み込み．
$ docker exec -it {コンテナ名} bin/bash
$ nginx -s reload
```



### 接続コマンドの違い

#### ・attach

```bash
# デタッチドモードで起動
$ docker run -d -it -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --name {コンテナ名} {使用イメージ名}

# デタッチドモードのコンテナに接続
$ docker attach {起動中コンテナ名}

# PID=1で，1つの/bin/bashプロセスが稼働していることが確認できる
[root@de17f4edf7d0 app] ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  16152  3872 pts/0    Ss+  18:06   0:00 /bin/bash
root        33  0.0  0.1  45696  3732 pts/1    R+   18:22   0:00 ps aux

# コンテナとの接続を切断
[root@de17f4edf7d0 app] exit

# コンテナの状態を確認
$ docker container ps -a # ==> コンテナのSTATUSがEXITedになっている
```

#### ・exe

```bash
# デタッチドモードで起動
$ docker run -d -it -p {ホストポート}:{コンテナポート} -v {ホストDIR}:{コンテナDIR} --name {コンテナ名} {使用イメージ名} /bin/bash

# デタッチドモードのコンテナに接続
$ docker exec -it {起動中コンテナ名} /bin/bash

# PID=1,17で，2つの/bin/bashプロセスが稼働していることが確認できる
[root@de17f4edf7d0 app] ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  16152  3872 pts/0    Ss+  18:06   0:00 /bin/bash
root        17  0.0  0.1  16152  4032 pts/1    Ss   18:21   0:00 /bin/bash
root        34  0.0  0.1  45696  3732 pts/1    R+   18:22   0:00 ps aux

# コンテナとの接続を切断
[root@de17f4edf7d0 app] exit

# コンテナの状態を確認
$ docker container ps -a # ==> コンテナのSTATUSがUPになっている
```



## 03. コンテナ側に対するファイルのマウント方法

### ホストOSのマウント元のディレクトリの設定画面

以下の通り，ホストOSのマウント元のディレクトリにはいくつか選択肢がある．

![マウントされるホスト側のディレクトリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マウントされるホスト側のディレクトリ.png)



### Bindマウント

#### ・Bindマウントとは

ホストOSにある```/Users```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，非推奨である．



### Volumeマウント

#### ・```/Volumes```とは

ホストOSの```/Volumes```（```/var/lib/docker/volumes```）ディレクトリには，開発途中にコンテナ側で作成されたデータのうち，ホストOSに永続化したいデータが保存される．Data Volumeともいう．

#### ・Volumeマウントとは

ホストOSにある```/Volumes```（```/var/lib/docker/volumes```）ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，推奨である．Dockerfileまたはdocker-composeファイルに記述する方法があるが，後者が推奨である．

#### ・Data Volumeコンテナによる永続化データの提供

一旦，Data Volumeをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．そして，他のコンテナでDataVolumeを使用したい時は，Data Volumeコンテナとディレクトリを共有することによって，データを要求する．

### 一時ファイルシステムマウント






## 04. ホストとコンテナの間のネットワーク接続

### bridgeネットワーク

#### ・bridgeネットワークとは

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークの間を，仮想ブリッジを用いてbridge接続する．ほとんどの場合，この方法を用いる．

```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
ae25b9b7740b        bridge                  bridge              local
aeef782b227d        tech-notebook_default   bridge              local
```



![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

#### ・物理サーバへのリクエストメッセージがコンテナに届くまで

ホストOSの```8080```番ポートと，WWWコンテナの```80```番ポートのアプリケーションの間で，ポートフォワーディングを行う．これにより，```http://{ホストOSのプライベートIPアドレス（localhost）}:8080```にリクエストを送信すると，WWWコンテナのポート番号のアプリケーションに転送されるようになる．

| 順番  | リクエストメッセージの流れ | プライベートIPアドレス例       | アプリケーションのポート番号例 |
| :---: | :------------------------- | :----------------------------- | ------------------------------ |
| **4** | WWWコンテナ                | ```127.0.0.1```                | ```:80```                      |
|       | ↑                          |                                |                                |
| **3** | 仮想ネットワーク           | ```172.XX.XX.XX```             |                                |
|       | ↑                          |                                |                                |
| **2** | 仮想ブリッジ               |                                |                                |
|       | ↑                          |                                |                                |
| **1** | ホストOS                   | ```192.168.3.2```（localhost） | ```:8080```                    |



### noneネットワーク

#### ・noneネットワークとは

特定のコンテナを，ホストOSや他のコンテナとは，ネットワーク接続させない．


```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
7edf2be856d7        none                    null                local
```




### hostネットワーク

#### ・hostネットワークとは

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．

```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
ac017dda93d6        host                    host                local
```



### ネットワーク接続成否の確認方法

#### ・ホストOS ---> コンテナ

ホストOSから，自身のポート番号8080に対してリクエストメッセージを送信することによって，ホストOSとコンテナの間のネットワーク接続の成否を確認できる．

```bash
# ホストOSから，自身のポート番号8080に対してリクエスト
$ curl --fail http://{nginxに登録したドメイン名}:8080/
```

#### ・コンテナ内部 ---> アプリケーション

bridge接続を経由してコンテナに接続し，コンテナ内部からアプリケーションにリクエストメッセージを送信することによって，アプリケーションの成否を確認することができる．

```bash
# コンテナの中で，ポート番号80のアプリケーションに対してリクエスト
$ curl --fail http://{nginxに登録したドメイン名}:80/
```



## 05. プラグイン

### ボリュームプラグイン

#### ・NFSストレージ

NFSプラグインを使用することで，永続化データを```/var/lib/docker/volumes```ではなく，NFSストレージに保存する．

**【実装例】**

以下にdocker-composeを使用した場合を示す．docker-composeについては，コンテナオーケストレーションのノートを参照．

```yaml
version: '3.7'

services:
  app:
    build: # 省略
    ports: # 省略
    depends_on: # 省略
    volumes:
      - example:/data # 下方のオプションが適用される．
      
volumes:
  example:
    driver_opts: # NFSプラグインを使用し，NFSストレージに保存．
      type: "nfs"
      o: "addr=10.40.0.199,nolock,soft,rw"
      device: ":/nfs/example"
```

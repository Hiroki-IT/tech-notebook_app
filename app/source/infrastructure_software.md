# ソフトウェア

## 01. ソフトウェアとは

### ソフトウェアの種類

#### ・ユーザの操作が，ソフトウェアを介して，ハードウェアに伝わるまで

![ソフトウェアとハードウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ソフトウェアとハードウェア.png)

#### 1. 応用ソフトウェア

#### 2. ミドルウェア

#### 3. 基本ソフトウェア（広義のOS）

![基本ソフトウェアの構成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/基本ソフトウェアの構成.png)

#### 4. Firmware

#### 5. デバイスドライバ



## 02. 応用ソフトウェア

### 応用ソフトウェア（アプリケーション）の一覧

|                        | ネイティブアプリ | Webアプリとクラウドアプリ | ハイブリッドアプリ |
| :--------------------: | :--------------: | :-----------------------: | :----------------: |
| **利用可能な通信状況** |     On／Off      |            On             |      On／Off       |



### ネイティブアプリケーション

![ネイティブアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ネイティブアプリ.png)

端末のシステムによって稼働するアプリのこと．一度ダウンロードしてしまえば，インターネットに繋がっていなくとも，使用できる．

**【アプリ例】**

Office，BookLiveのアプリ版



### Webアプリケーションとクラウドアプリケーション

![Webアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Webアプリ.png)

#### ・Webアプリケーション

Webサーバ上でWebシステムをレンダリングすることによって稼働するアプリのこと．URLをWebサーバにリクエストすることで利用でき，随時，Webサーバとデータ通信を行う．全ての人が無料で利用できるものと，お金を払った人だけが利用できるものがある．

**【全ての人が無料で利用できるWebアプリ例】**

Googleアプリ，Amazon，BookLiveのブラウザ版

**【お金を払った人だけが特定のURLから利用できるWebアプリ例】**

サイボウズ

#### ・クラウドアプリケーション

Webサーバ上のシステムによって稼働するアプリのうち，クラウドサービスを提供するもののこと．

**【クラウドアプリ例】**

Google Drive，Dropbox



### ハイブリッドアプリケーション

![Webviewよるアプリパッケージ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Webviewよるアプリパッケージ.png)

![ハイブリッドアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ハイブリッドアプリ.png)

端末でWebviewを稼働させ，WebシステムのレンダリングなどをWebview上で行うアプリのこと．

**【アプリ例】**

クックパッド



## 03. ミドルウェア

### Webシステムを構成するサーバのミドルウェア

![Webサーバ，APサーバ，DBサーバ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Webサーバ，APサーバ，DBサーバ.png)

### Webサーバとしてのミドルウェア

詳しくは，Webシステムにおけるサーバを参照．

#### ・Apache

#### ・Nginx

#### ・Node.js



### APサーバとしてのミドルウェア

#### ・Apache内蔵

#### ・CGIプログラム：Common Gateway Interface

![CGIの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CGIの仕組み.png)

#### ・NGINX Unit



### DBMS

#### ・MySQL

#### ・MariaDB

※詳しくは，データベースのノートを参照せよ．



## 04. 基本ソフトウェア（広義のOS）

### 基本ソフトウェアの種類

#### ・Unix系OS

Unixを源流として派生したOS．現在では主に，Linux系統（緑色），BSD系統（黄色），SystemV系統（青色）の三つに分けられる．

※ちなみに，MacOSはBSD系統

![Unix系OSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Unix系OSの歴史.png)

#### ・WindowsOS

MS-DOSを源流として派生したOS．今では，全ての派生がWindows 10に集約された．

![WindowsOSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/WindowsOSの歴史.png)



### Unix \ Linux系統

現在，Linux系統のOSは，さらに3つの系統に分けられる．

#### ・RedHat系統

RedHat，CentOS，Fedora

#### ・Debian系統

Debian，Ubuntu，

#### ・Slackware系統

Slackware

![Linux distribution](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/LinuxDistribution.png)



## 04-02. 基本ソフトウェア \ サービスプログラム（ユーティリティ）

### サービスプログラム（ユーティリティ）の種類

#### ・Linuxの場合

よく使うものを記載する．

| シェル系 | ファイルシステム系 | プロセス管理系 | テキスト処理系 | ネットワーク系 | その他                   |
| :------- | ------------------ | -------------- | -------------- | -------------- | ------------------------ |
| echo     | cd                 | batch          | tail           | nslookup       | crontab                  |
| sleep    | ls                 | ps             | -              | curl           | grep                     |
| -        | cp                 | kill           | -              | netstat        | メタパッケージマネージャ |
| -        | find               | systemctl      | -              | route          | -                        |
| -        | mv                 | -              | -              | -              | -                        |
| -        | chmod              | -              | -              | -              | -                        |
| -        | rm                 | -              | -              | -              | -                        |
| -        | pwd                | -              | -              | -              | -                        |
| -        | chown              | -              | -              | -              | -                        |
| -        | cat                | -              | -              | -              | -                        |

#### ・Windowsの場合

よく使うものを記載する．

| システム系         | ストレージデバイス管理系 | ファイル管理系         | その他             |
| ------------------ | ------------------------ | ---------------------- | ------------------ |
| マネージャ         | デフラグメントツール     | ファイル圧縮プログラム | スクリーンセーバー |
| クリップボード     | アンインストーラー       | -                      | ファイアウォール   |
| レジストリクリーナ | -                        | -                      | -                  |
| アンチウイルス     | -                        | -                      | -                  |



### find

#### ・findとは

ファイルを検索するためのユーティリティ．アスタリスクを付けなくとも，自動的にワイルドカードが働く．

```bash
# ルートディレクトリ以下で， example という文字をもつファイルを全て検索．
$ find /* -type f |xargs grep "example"
```

```bash
# ルートディレクトリ以下で， example という文字をもち，ファイル名が .conf で終わるファイルを全て検索．
$ find /* -name "*.conf" -type f | xargs grep "example"
```



### chmod：change mode

#### ・chmodとは

ファイルの権限を変更するためのユーティリティ．よく使用されるパーミッションのパターンは次の通り．

```bash
# example.conf に「666」権限を付与
$ chmod 666 example.conf
```

#### ・よく使う権限

| 数字 | 権限      | 意味                                                         |
| ---- | :-------- | :----------------------------------------------------------- |
| 644  | rw-r--r-- | 通常のHTMLファイルなど．自分は読み込み，書き込みができるが，グループメンバや他人は読み込みしかできない． |
| 666  | rw-rw-rw- | CGIスクリプトが書き込むファイルなど．自分もグループメンバも他人も，読み込みと書き込みができる． |
| 755  | rwxr-xr-x | 通常のディレクトリ，コマンド，CGIスクリプトなど．誰でも読込みと実行はできるが，書き込みは自分だけ． |
| 777  | rwxrwxrwx | CGIスクリプトがファイルを作成するためのディレクトリなど．誰でもなんでもOK．セキュリティ上は少々危険． |



### systemctl：system control

#### ・systemctlとは

systemdを制御するためのユーティリティ．systemd

```bash
# サービスの自動起動設定を一覧で確認．
$ systemctl list-unit-files --type=service

crond.service           enabled  # enable：自動起動する
supervisord.service     disabled # disable：自動起動しない
systemd-reboot.service  static   # enable：他サービス依存
```
```bash
# サービスの自動起動を有効化．
$ systemctl enable crond.service

# サービスの自動起動を無効化．
$ systemctl disable crond.service
```

#### ・systemdとは：system daemon

Linuxの起動プロセスの一つである，initプロセス（PID 1）を制御するプログラム．詳しくは，追って学習する．



### crontab：command run on table

#### ・crontabとは

cronデーモンの動作が定義されたcrontabファイルを操作するためのユーティリティ．cron.dファイルは操作できない．

#### ・crontabファイルとcron.dファイルの違い

どちらもcronの動作を定義するファイルではあるが，crontabは，ユーザ毎に個別の動作を定義する場合に用いる．cron.dファイルはユーザ関係なく，また動作ごとに一つのファイルで定義する場合に用いる．

| ファイル/ディレクトリ名 | 利用者   | 主な用途                                               |
| ----------------------- | -------- | ------------------------------------------------------ |
| /var/spool/cron/*user*  | 全ユーザ | ユーザの自動タスク設定ファイル                         |
| /etc/crontab            | root     | 毎時，毎日，毎月，毎週の自動タスクのメイン設定ファイル |
| /etc/cron.hourly        | root     | 毎時実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.daily         | root     | 毎日実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.monthly       | root     | 毎月実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.weekly        | root     | 毎週実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.d             | root     | 上記以外の自動タスク設定ファイルを置くディレクトリ     |

**【実装例】**

あらかじめ，各ディレクトリにcronファイルを配置しておく．```run-parts```コマンドで，指定した時間に，ディレクトリ内のcronファイルを一括で実行する．

```
# 設定
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO="hasegawafeedshop@gmail.com"
LANG=ja_JP.UTF-8
LC_ALL=ja_JP.UTF-8
CONTENT_TYPE=text/plain; charset=UTF-8

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

# run-parts
1 * * * * root run-parts /etc/cron.hourly # 毎時・1分
5 2 * * * root run-parts /etc/cron.daily # 毎日・2時5分
20 2 * * 0 root run-parts /etc/cron.weekly # 毎週日曜日・2時20分
40 2 1 * * root run-parts /etc/cron.monthly # 毎月一日・2時40分
@reboot make clean html # cron起動時に一度だけ
```

**【実装例】**

crontabでまとめて制御せず，個別ファイルで制御する場合は，cron.dで制御する．

```
# 毎時・1分
1 * * * * root run-parts /etc/cron.hourly
```

```
# 毎日・2時5分
5 2 * * * root run-parts /etc/cron.daily
```

```
# 毎週日曜日・2時20分
20 2 * * 0 root run-parts /etc/cron.weekly
```

```
# 毎月一日・2時40分
40 2 1 * * root run-parts /etc/cron.monthly
```

```
# cron起動時に一度だけ
@reboot make clean html
```

#### ・crondとは

cronデーモンを起動するためのプログラム

```bash
# フォアグラウンドプロセスとしてcronを起動
$ crond -n
```

#### ・supervisorとの組み合わせ

ユーザーが，OS上のプロセスを制御できるようにするためのプログラム．

```bash
# インストール
$ pip3 install supervisor

# /etc/supervisor/supervisord.conf に設定ファイルを置いて起動．
$ /usr/local/bin/supervisord
```

以下に設定ファイルの例を示す．

**【実装例】**

```
[supervisord]
# 実行ユーザ
user=root
# フォアグラウンドで起動
nodaemon=true
# ログ
logfile=/var/log/supervisord.log
# Pid
pidfile=/var/tmp/supervisord.pid

[program:crond]
# 実行コマンド
command=/usr/sbin/crond -n
# プログラムの自動起動
autostart=true
# プログラム停止後の再起動
autorestart=true
# コマンドの実行ログ
stdout_logfile=/var/log/command.log
stderr_logfile=/var/log/command-error.log
# コマンドの実行ユーザ
user=root
# コマンドの実行ディレクトリ
directory=/var/www/tech-notebook
```



### マネージャの種類

#### ・ライブラリとパッケージの大まかな違い

![ライブラリ，パッケージ，モジュールの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ライブラリ，パッケージ，モジュールの違い.png)

#### ・ライブラリマネージャ

| ライブラリマネージャ名            | 対象プログラミング言語 |
| --------------------------------- | ---------------------- |
| composer.phar：Composer           | PHP                    |
| npm：Node Package Manager         | Node.js                |
| pip：Package Installer for Python | Python                 |
| maven：Apache Maven               | Java                   |
| gem：Ruby Gems                    | Ruby                   |

#### ・メタパッケージマネージャ

| メタパッケージマネージャ名                              | 対象OS       | 依存関係のインストール可否 |
| ------------------------------------------------------- | ------------ | -------------------------- |
| Rpm：Red Hat Package Manager                            | RedHat系     | ✕                          |
| Yum：Yellow dog Updater Modified<br/>DNF：Dandified Yum | RedHat系     | 〇                         |
| Apt：Advanced Packaging Tool                            | Debian系     | 〇                         |
| Apk：Alpine Linux package management                    | Alpine Linux | 〇                         |

#### ・言語バージョンマネージャ

| 言語バージョンマネージャ名 | 対象プログラミング言語 |
| -------------------------- | ---------------------- |
| phpenv                     | PHP                    |
| pyenv                      | Python                 |
| rbenv                      | Ruby                   |



## 04-03. 基本ソフトウェア \ 言語プロセッサ

### 言語プロセッサの例

#### ・アセンブラ

以降の説明を参照．

#### ・コンパイラ

以降の説明を参照．

#### ・インタプリタ

以降の説明を参照．



### コンパイラ型言語，インタプリタ型言語，JavaまたはJava仮想マシン型言語

プログラム言語のソースコードは，言語プロセッサによって機械語に変換された後，CPUによって読み込まれる．そして，ソースコードに書かれた様々な処理が実行される．

#### ・コンパイラとコンパイラ型言語

  コンパイラという言語プロセッサによって，コンパイラ方式で翻訳される言語．

#### ・インタプリタとインタプリタ型言語

  インタプリタという言語プロセッサによって，インタプリタ方式で翻訳される言語をインタプリタ型言語という．

#### ・JavaやJava仮想マシン型言語

  Java仮想マシンによって，中間言語方式で翻訳される．

![コンパイル型とインタプリタ型言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コンパイル型とインタプリタ型言語.jpg)



### コンパイラによるコンパイラ型言語の機械語翻訳（じ，こ，い，さい，せい，リンク，実行）

コードを，バイナリ形式のオブジェクトコードとして，まとめて機械語に翻訳した後，CPUに対して命令が実行される．

**【コンパイラ型言語の具体例】**

C#

![コンパイラ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コンパイラ言語.png)

#### ・コンパイラ方式によるコンパイラ型言語のビルド

  コンパイラ（C#）による翻訳では，ソースコードは機械語からなるオブジェクトコードに変換される．コンパイル後に，各オブジェクトコードはリンクされる．この一連のプロセスを『ビルド』という．

![ビルドとコンパイル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ビルドとコンパイル.jpg)

#### ・コンパイラ方式の機械語翻訳の流れ

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **Code optimization（コード最適化）**

   ソースコードの冗長な部分を削除または編集．機械語をより短くするこができる．

5. **Code generation（コード生成）**

   最適化されたコードをバイナリ形式のオブジェクトコードに変換．

6. **リンク**

   オブジェクトコードをリンクする．

7. **命令の実行**

   リンクされたオブジェクトコードを基に，命令が実行される．



### インタプリタによるインタプリタ型言語の機械語翻訳（じ，こ，い，実行）

コードを，一行ずつ機械語に変換し，順次，命令を実行する言語．

※Webサーバを仮想的に構築する時，PHPの言語プロセッサが同時に組み込まれるため，PHPのソースコードの変更はブラウザに反映される．しかし，JavaScriptの言語プロセッサは組み込まれない．そのため，JavaScriptのインタプリタは別に手動で起動する必要がある．

**【インタプリタ型言語の具体例】**

PHP，Ruby，JavaScript，Python

![インタプリタ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/インタプリタ言語.png)

#### ・インタプリタ方式の機械語翻訳の流れ

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．ソースコードから構造体を構築することを構文解析といい，htmlを構文解析してDOMツリーを構築する処理とは別物なので注意．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **命令の実行**

   意味解析の結果を基に，命令が実行される．

5. **１から４をコード行ごとに繰り返す**



### Java仮想マシンによるJavaまたはJava仮想マシン型言語の機械語翻訳

**【JVM型言語の具体例】**

Scala，Groovy，Kotlin

#### ・中間言語方式の機械語翻訳の流れ

1. JavaまたはJVM型言語のソースコードを，Javaバイトコードを含むクラスファイルに変換する．
2. JVM：Java Virtual Machine内で，インタプリタによって，クラスデータを機械語に翻訳する．
3. 結果的に，OS（制御プログラム？）に依存せずに，命令を実行できる．（C言語）

![Javaによる言語処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_1.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/矢印_80x82.jpg)

![Javaによる言語処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_2.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/矢印_80x82.jpg)

![Javaによる言語処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_3.png)

#### ・C言語とJavaのOSへの依存度比較

![CとJavaのOSへの依存度比較](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CとJavaのOSへの依存度比較.png)

- JVM言語

ソースコード

### プログラムの実行開始のエントリポイント

#### ・PHPの場合

動的型付け言語では，エントリポイントが指定プログラムの先頭行と決まっており，そこから枝分かれ状に処理が実行されていく．PHPでは，```index.php```がエントリポイントと決められている．その他のファイルにはエントリポイントは存在しない．

```PHP
use App\Kernel;
use Symfony\Component\ErrorHandler\Debug;
use Symfony\Component\HttpFoundation\Request;

// まず最初に，bootstrap.phpを読み込む．
require dirname(__DIR__).'/config/bootstrap.php';

if ($_SERVER['APP_DEBUG']) {
    umask(0000);

    Debug::enable();
}

if ($trustedProxies = $_SERVER['TRUSTED_PROXIES'] ?? $_ENV['TRUSTED_PROXIES'] ?? false) {
    Request::setTrustedProxies(explode(',', $trustedProxies), Request::HEADER_X_FORWARDED_ALL ^ Request::HEADER_X_FORWARDED_HOST);
}

if ($trustedHosts = $_SERVER['TRUSTED_HOSTS'] ?? $_ENV['TRUSTED_HOSTS'] ?? false) {
    Request::setTrustedHosts([$trustedHosts]);
}

$kernel = new Kernel($_SERVER['APP_ENV'], (bool) $_SERVER['APP_DEBUG']);
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
```

#### ・Javaの場合

静的型付け言語では，エントリポイントが決まっておらず，自身で定義する必要がある．Javaでは，```public static void main(String args[])```と定義した場所がエントリポイントになる．

```java
public class Age
{
		public static void main(String[] args)
		{
			// 定数を定義．
			final int age = 20;
			System.out.println("私の年齢は" + age);

			// 定数は再定義できないので，エラーになる．
			age = 31;
			System.out.println("…いや，本当の年齢は" + age);
		}
}
```



## 04-04. 基本ソフトウェア \ 制御プログラム（カーネル）

### 制御プログラム（カーネル）の例

  カーネル，マイクロカーネル，モノリシックカーネル



### ジョブ管理

クライアントは，マスタスケジュールに対して，ジョブを実行するための命令を与える．

![ジョブ管理とタスク管理の概要](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブ管理とタスク管理の概要.jpg)



### マスタスケジュラ，ジョブスケジュラ

ジョブとは，プロセスのセットのこと．マスタスケジュラは，ジョブスケジュラにジョブの実行を命令する．データをコンピュータに入力し，複数の処理が実行され，結果が出力されるまでの一連の処理のこと．『Task』と『Job』の定義は曖昧なので，『process』と『set of processes』を使うべきとのこと．

引用：https://stackoverflow.com/questions/3073948/job-task-and-process-whats-the-difference/31212568

複数のジョブ（プログラムやバッチ）の起動と終了を制御したり，ジョブの実行と終了を監視報告するソフトウェア．ややこしいことに，タスクスケジューラとも呼ぶ．

#### ・Reader

ジョブ待ち行列に登録

#### ・Initiator

ジョブステップに分解

#### ・Terminator

出力待ち行列に登録

#### ・Writer

優先度順に出力の処理フローを実行



### Initiatorによるジョブのジョブステップへの分解

Initiatorによって，ジョブはジョブステップに分解される．

![ジョブからジョブステップへの分解](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブからジョブステップへの分解.png)



### タスク管理

![ジョブステップからタスクの生成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブステップからタスクの生成.png)

タスクとは，スレッドに似たような，単一のプロセスのこと．Initiatorによるジョブステップから，タスク管理によって，タスクが生成される．タスクが生成されると実行可能状態になる．ディスパッチャによって実行可能状態から実行状態になる．

#### ・優先順方式

各タスクに優先度を設定し，優先度の高いタスクから順に，ディスパッチしていく方式．

#### ・到着順方式

待ち行列に登録されたタスクから順に，ディスパッチしていく方式．

![到着順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/到着順方式_1.png)

**【具体例】**

以下の様に，タスクがCPUに割り当てられていく．

![到着順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/到着順方式_2.png)

#### ・Round robin 方式

Round robinは，『総当たり』の意味．一定時間（タイムクウォンタム）ごとに，実行状態にあるタスクが強制的に待ち行列に登録される．交代するように，他のタスクがディスパッチされる．

![ラウンドロビン方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ラウンドロビン方式.png)

**【具体例】**

生成されたタスクの到着時刻と処理時間は以下のとおりである．強制的なディスパッチは，『20秒』ごとに起こるとする．

![優先順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/優先順方式_1.png)

1. タスクAが0秒に待ち行列へ登録される．
2. 20秒間，タスクAは実行状態へ割り当てられる．
3. 20秒時点で，タスクAは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクBは，実行可能状態から実行状態にディスパッチされる．
4. 40秒時点で，タスクCは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクAは，実行可能状態から実行状態にディスパッチされる．

![優先順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/優先順方式_2.png)



### 入出力管理

アプリケーションから低速な周辺機器へデータを出力する時，まず，CPUはスプーラにデータを出力する．Spoolerは，全てのデータをまとめて出力するのではなく，一時的に補助記憶装置（Spool）にためておきながら，少しずつ出力する（Spooling）．

![スプーリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/スプーリング.jpg)



## 05. デバイスドライバ



## 06. Firmware

システムソフトウェア（ミドルウェア ＋ 基本ソフトウェア）とハードウェアの間の段階にあるソフトウェア．ROMに組み込まれている．

### BIOS：Basic Input/Output System

![BIOS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/BIOS.jpg)



### UEFI：United Extensible Firmware Interface

Windows 8以降で採用されている新しいFirmware

![UEFIとセキュアブート](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/UEFIとセキュアブート.jpg)



## 07. OSS：Open Source Software

### OSSとは

以下の条件を満たすソフトウェアをOSSと呼ぶ．応用ソフトウェアから基本ソフトウェアまで，様々なものがある．

1. 利用者は，無償あるいは有償で自由に再配布できる．

2. 利用者は，ソースコードを入手できる．

3. 利用者は，コードを自由に変更できる．また，変更後に提供する場合，異なるライセンスを追加できる．

4. 差分情報の配布を認める場合には，同一性の保持を要求してもかまわない． ⇒ よくわからない

5. 提供者は，特定の個人やグループを差別できない．

6. 提供者は，特定の分野を差別できない．

7. 提供者は，全く同じOSSの再配布において，ライセンスを追加できない．

8. 提供者は，特定の製品でのみ有効なライセンスを追加できない．

9. 提供者は，他のソフトウェアを制限するライセンスを追加できない．

10. 提供者は，技術的に偏りのあるライセンスを追加できない．

    

### OSSの具体例

![OSS一覧](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/OSS一覧.png)

引用：https://openstandia.jp/oss_info/

#### ・OS

  CentOS，Linux，Unix，Ubuntu

#### ・データベース

  MySQL，MariaDB

#### ・プログラミング言語

  言うまでもない．

#### ・フレームワーク

  言うまでもない．

#### ・OR Mapper

  言うまでもない．

#### ・バージョン管理

  Git，Subversion

#### ・Webサーバ

  Apache

#### ・業務システム

  Redmine

#### ・インフラ構築

  Chef，Puppet

#### ・クラウド構築

  Docker
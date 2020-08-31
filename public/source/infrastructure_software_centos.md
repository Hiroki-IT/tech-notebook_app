# CentOSの構成

## 01. 基本ソフトウェア（広義のOS）

### 基本ソフトウェアの構成

![基本ソフトウェアの構成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/基本ソフトウェアの構成.png)



## 02. ユーティリティ

### ユーティリティの種類

#### ・Unixの場合

今回，以下に紹介するものをまとめる．

| ファイルシステム系 | プロセス管理系 | ネットワーク系 | テキスト処理系 | 環境変数系 | ハードウェア系 | ジョブスケジュール系 |
| ------------------ | -------------- | -------------- | -------------- | :--------- | -------------- | -------------------- |
| mkdir              | batch          | nslookup       | tail           | export     | df             | cron                 |
| ls                 | ps             | curl           | vim            | printenv   | free           | -                    |
| cp                 | kill           | netstat        | grep           | -          | -              | -                    |
| find               | systemctl      | route          | -              | -          | -              | -                    |
| chmod              | -              | -              | -              | -          | -              | -                    |
| rm                 | -              | -              | -              | -          | -              | -                    |
| chown              | -              | -              | -              | -          | -              | -                    |
| ln                 | -              | -              | -              | -          | -              | -                    |
| od                 | -              | -              | -              | -          | -              | -                    |

#### ・Windowsの場合

Windowsは，GUIでユーティリティを使用する．よく使うものを記載する．

| システム系         | ストレージデバイス管理系 | ファイル管理系         | その他             |
| ------------------ | ------------------------ | ---------------------- | ------------------ |
| マネージャ         | デフラグメントツール     | ファイル圧縮プログラム | スクリーンセーバー |
| クリップボード     | アンインストーラー       | -                      | ファイアウォール   |
| レジストリクリーナ | -                        | -                      | -                  |
| アンチウイルス     | -                        | -                      | -                  |



### ユーティリティのバイナリファイル

####  ・バイナリファイルの配置場所

| バイナリファイルのディレクトリ | バイナリファイルの種類                                       |
| ------------------------------ | ------------------------------------------------------------ |
| ```/bin```                     | Unixユーティリティのバイナリファイルの多く．                 |
| ```/usr/bin```                 | 管理ユーティリティによってインストールされるバイナリファイルの多く． |
| ```/usr/local/bin```           | Unix外のソフトウェアによってインストールされたバイナリファイル．最初は空になっている． |
| ```/sbin```                    | Unixユーティリティのバイナリファイルうち，```sudo```権限が必要なもの． |
| ```/usr/sbin```                | 管理ユーティリティによってインストールされたバイナリファイルのうち，```sudo```権限が必要なもの． |
| ```/usr/local/sbin```          | Unix外のソフトウェアによってインストールされたバイナリファイルのうち，```sudo```権限が必要なもの．最初は空になっている． |

``` bash
# バイナリファイルが全ての場所で見つからないエラー
$ which python3
which: no python3 in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)

# バイナリファイルの場所
$ which python3 
/usr/bin/python3
```



### パイプライン

#### ・```grep```との組み合わせ

「```|```」の縦棒記号のこと．コマンドの出力結果を表示せずに，次のコマンドの引数として渡す．例えば，```find```コマンドの出力結果を```grep```コマンドに渡し，フィルタリングを行う．

```bash
# find ---> grep
$ find /* -type f |xargs grep "{検索文字}"
```

#### ・```kill```との組み合わせ

フィルタリングしたものに対して，```kill```コマンドを行うような使い方もある．

```bash
# pgrep ---> kill
$ sudo pgrep -f {コマンド名} | sudo xargs kill -9
```



## 02-02. ファイルシステム系

### mkdir

#### ・よく使うオプション集

```bash
# 複数階層のディレクトリを作成
$ mkdir -p /{ディレクトリ名1}/{ディレクトリ名2}
```



### ls

#### ・よく使うオプション集

```bash
# 隠しファイルや隠しディレクトリも含めて，全ての詳細を表示．
$ ls -l -a
```



### cp

#### ・よく使うオプション集

```bash
# ディレクトリの属性情報も含めて，ディレクトリ構造とファイルを再帰的にコピー．
$ cp -Rp /{ディレクトリ名1}/{ディレクトリ名2} /{ディレクトリ名1}/{ディレクトリ名2}
```



### find

#### ・よく使うオプション集

ファイルを検索するためのユーティリティ．アスタリスクを付けなくとも，自動的にワイルドカードが働く．

```bash
# ルートディレクトリ以下で， example という文字をもつファイルを全て検索．
$ find /* -type f |xargs grep "{検索文字}"
```

```bash
# ルートディレクトリ以下で， example という文字をもち，ファイル名が .conf で終わるファイルを全て検索．
$ find /* -name "*.conf" -type f | xargs grep "{検索文字}"
```

```bash
# パーミッションエラーなどのログを破棄して検索．
$ find /* -type f |xargs grep "{検索文字}" 2> /dev/null
```



### chmod：change mode

#### ・よく使うオプション集

ファイルの権限を変更するためのユーティリティ．よく使用されるパーミッションのパターンは次の通り．

```bash
# example.conf に「666」権限を付与
$ chmod 666 example.conf
```

#### ・100番刻みの規則性

所有者以外に全権限が与えられない．

| 数字 | 所有者 | グループ | その他 | 特徴                   |
| :--: | :----- | :------- | :----- | ---------------------- |
| 500  | r-x    | ---      | ---    | 所有者以外に全権限なし |
| 600  | rw-    | ---      | ---    | 所有者以外に全権限なし |
| 700  | rwx    | ---      | ---    | 所有者以外に全権限なし |

#### ・111番刻みの規則性

全てのパターンで同じ権限になる．

| 数字 | 所有者 | グループ | その他 | 特徴                 |
| :--: | :----- | :------- | :----- | -------------------- |
| 555  | r-x    | r-x      | r-x    | 全てにWrite権限なし  |
| 666  | rw-    | rw-      | rw-    | 全てにExecut権限なし |
| 777  | rwx    | rwx      | rwx    | 全てに全権限あり     |

#### ・その他でよく使う番号

| 数字 | 所有者 | グループ | その他 | 特徴                               |
| :--: | :----- | :------- | :----- | ---------------------------------- |
| 644  | rw-    | r--      | r--    | 所有者以外にWrite，Execute権限なし |
| 755  | rwx    | r-x      | r-x    | 所有者以外にWrite権限なし          |



### ln，unlink

#### ・よく使うオプション集

```bash
# カレントディレクトリに，シンボリックリンクを作成．
$ ln -s {リンク先のファイル／ディレクトリまでのパス} {シンボリックリンク名} 
```

```bash
# カレントディレクトリのシンボリックリンクを削除．
$ unlink {シンボリックリンク名}
```



### rm

#### ・よく使うオプション集

```bash
# ディレクトリ自体と中のファイルを再帰的に削除．
$ rm -R {ディレクトリ名} 
```



### od：octal dump

#### ・よく使うオプション

```bash
# ファイルを8進数の機械語で出力
$ od {ファイル名}
```

```bash
# ファイルを16進数の機械語で出力
$ od -Ad -tx {ファイル名}
```





## 02-03. プロセス系

### ps： process status

#### ・よく使うオプション集

稼働しているプロセスの詳細情報を表示するためのユーティリティa．

```bash
# 稼働しているプロセスのうち，詳細情報に「xxx」を含むものを表示する．
$ ps aux | grep "{検索文字}"
```

指定したコマンドによるプロセスを全て削除する．

```bash
$ sudo pgrep -f {コマンド名} | sudo xargs kill -9
```



### systemctl：system control（旧service）

#### ・よく使うオプション集

デーモンを起動するsystemdを制御するためのユーティリティ．

```bash
# デーモンのUnitを一覧で確認．
$ systemctl list-unit-files --type=service

crond.service           enabled  # enable：自動起動する
supervisord.service     disabled # disable：自動起動しない
systemd-reboot.service  static   # enable：他サービス依存
```

```bash
# マシン起動時にデーモンが自動起動するように設定．
$ systemctl enable {プロセス名}
# 例：Cron，Apache
$ systemctl enable crond.service
$ systemctl enable httpd.service


# マシン起動時にデーモンが自動起動しないように設定．
$ systemctl disable {プロセス名}
# 例：Cron，Apache
$ systemctl disable crond.service
$ systemctl disable httpd.service
```

#### ・systemd：system daemon のUnitの種類

各デーモンを，```/usr/lib/systemd/system```や```/etc/systemd/system```下でUnit別に管理し，Unitごとに起動する．Unitは拡張子の違いで判別する．

| Unitの拡張子 | 意味                                       | デーモン例         |
| ------------ | ------------------------------------------ | ------------------ |
| mount        | ファイルのマウントに関するデーモン．       |                    |
| service      | プロセス起動停止に関するデーモン．         | httpd：http daemon |
| socket       | ソケットとプロセスの紐づけに関するデーモン |                    |



## 02-04. ジョブスケジュール系

### cron

#### ・よく使うオプション集

cronデーモンの動作が定義されたcrontabファイルを操作するためのユーティリティ．cron.dファイルは操作できない．

```bash
# crontab：command run on table
# 作成したcronファイルを登録する．
$ crontab {ファイルパス}
```

| ファイル名<br>ディレクトリ名 | 利用者 | 主な用途                                               |
| ---------------------------- | ------ | ------------------------------------------------------ |
| /etc/crontab                 | root   | 毎時，毎日，毎月，毎週の自動タスクのメイン設定ファイル |
| /etc/cron.hourly             | root   | 毎時実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.daily              | root   | 毎日実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.monthly            | root   | 毎月実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.weekly             | root   | 毎週実行される自動タスク設定ファイルを置くディレクトリ |


**【実装例】**

1. あらかじめ，各ディレクトリにcronファイルを配置しておく．
2. cronとして登録するファイルを作成する．```run-parts```コマンドで，指定した時間に，各cronディレクトリ内のcronファイルを一括で実行するように記述しておく．

```bash
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

```bash
# 毎時・1分
1 * * * * root run-parts /etc/cron.hourly
```

```bash
# 毎日・2時5分
5 2 * * * root run-parts /etc/cron.daily
```

```bash
# 毎週日曜日・2時20分
20 2 * * 0 root run-parts /etc/cron.weekly
```

```bash
# 毎月一日・2時40分
40 2 1 * * root run-parts /etc/cron.monthly
```

```bash
# cron起動時に一度だけ
@reboot make clean html
```

3. このファイルをcrontabコマンドで登録する．cronファイルの実体はないことと，変更した場合は登録し直さなければいけないことに注意する．

```bash
$ crontab {ファイルパス}
```

4. 登録されている処理を確認する．

```bash
$ crontab -l
```

5. ログに表示されているかを確認．

```bash
$ cd /var/log
$ tail -f cron
```


#### ・cron.dファイル

複数のcronファイルで全ての一つのディレクトリで管理する場合に用いる．

| ディレクトリ名 | 利用者 | 主な用途                                           |
| -------------- | ------ | -------------------------------------------------- |
| /etc/cron.d    | root   | 上記以外の自動タスク設定ファイルを置くディレクトリ |

#### ・crondによるプロセス操作

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
```
```bash
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



## 02-05. テキスト処理系

### vim：Vi Imitaion，Vi Improved  

#### ・よく使うオプション集

```bash
# vim上でファイルを開く
$ vim {ファイル名}
```



## 02-06. 環境変数系


### export

#### ・よく使うオプション集

```bash
# 環状変数として，指定したバイナリファイル（bin）のあるディレクトリへの絶対パスを登録．
# バイナリファイルを入力すると，絶対パス
$ export PATH=$PATH:{シェルスクリプトへのあるディレクトリへの絶対パス}
```



### printenv

#### ・よく使うオプション集

```bash
# 全ての環境変数を表示．
$ printenv
```



## 02-07. ハードウェア系

### df

#### ・よく使うオプション集

```bash
# ストレージの使用状況を確認
# h：--human-readable
$ df -h --total
```



### free

#### ・よく使うオプション集

```bash
# 物理メモリ，スワップ領域，の使用状況を確認
# h：--human-readable
$ free -h --total
```



### mkswap，swapon，swapoff

#### ・スワッピング方式

物理メモリのアドレス空間管理の方法の一つ．ハードウェアのノートを参照．

![スワッピング方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スワッピング方式.png)

#### ・よく使うオプション集

```bash
# 指定したディレクトリをスワップ領域として使用
$ mkswap /swap_volume
```
```bash
# スワップ領域を有効化
# 優先度のプログラムが，メモリからディレクトリに，一時的に退避されるようになる
$ swapon /swap_volume
```
```bash
# スワップ領域の使用状況を確認
$ swapon -s
```
```bash
# スワップ領域を無効化
$ swapoff /swap_volume
```



##  03. 管理ユーティリティ

### 管理ユーティリティの種類

#### ・管理ユーティリティの対象

様々なレベルを対象にした管理ユーティリティがある．

![ライブラリ，パッケージ，モジュールの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ライブラリ，パッケージ，モジュールの違い.png)

#### ・ライブラリ管理ユーティリティ

| ユーティリティ名                  | 対象プログラミング言語 |
| --------------------------------- | ---------------------- |
| composer.phar：Composer           | PHP                    |
| npm：Node Package Manager         | Node.js                |
| pip：Package Installer for Python | Python                 |
| maven：Apache Maven               | Java                   |
| gem：Ruby Gems                    | Ruby                   |

#### ・パッケージ管理ユーティリティ

| ユーティリティ名                                        | 対象OS       | 依存関係のインストール可否 |
| ------------------------------------------------------- | ------------ | -------------------------- |
| Rpm：Red Hat Package Manager                            | RedHat系     | ✕                          |
| Yum：Yellow dog Updater Modified<br/>DNF：Dandified Yum | RedHat系     | 〇                         |
| Apt：Advanced Packaging Tool                            | Debian系     | 〇                         |
| Apk：Alpine Linux package management                    | Alpine Linux | 〇                         |

#### ・言語バージョン管理ユーティリティ

| ユーティリティ名 | 対象プログラミング言語 |
| ---------------- | ---------------------- |
| phpenv           | PHP                    |
| pyenv            | Python                 |
| rbenv            | Ruby                   |



## 03-02. ライブラリ管理ユーティリティ

### pip

#### ・よく使うオプション

```bash
# 指定したライブラリをインストール
# /usr/local 以下にインストール
$ pip install --user {ライブラリ名}
```
```bash
# requirements.txt を元にライブラリをインストール
$ pip install -r requirements.txt

# 指定したディレクトリにライブラリをインストール
pip install -r requirements.txt　--prefix=/usr/local
```

```bash
# pipでインストールされたパッケージを元に，requirement.txtを作成
$ pip freeze > requirements.txt
```

```bash
# pipでインストールしたパッケージ情報を表示
$ pip show sphinx

Name: Sphinx
Version: 3.2.1
Summary: Python documentation generator
Home-page: http://sphinx-doc.org/
Author: Georg Brandl
Author-email: georg@python.org
License: BSD
# インストール場所
Location: /usr/local/lib/python3.8/site-packages
# このパッケージの依存対象
Requires: sphinxcontrib-applehelp, imagesize, docutils, sphinxcontrib-serializinghtml, snowballstemmer, sphinxcontrib-htmlhelp, sphinxcontrib-devhelp, sphinxcontrib-jsmath, setuptools, packaging, Pygments, babel, alabaster, sphinxcontrib-qthelp, requests, Jinja2
# このパッケージを依存対象としているパッケージ
Required-by: sphinxcontrib.sqltable, sphinx-rtd-theme, recommonmark
```



## 03-03. パッケージ管理ユーティリティ

### rpm

#### ・よく使うオプション集

一度に複数のオプションを組み合わせて記述する．インストール時にパッケージ間の依存関係を解決できないので注意．

```bash
# パッケージをインストール
# -ivh：--install -v --hash 
$ rpm -ivh {パッケージ名}
```

```bash
# インストールされた全てのパッケージの中で，指定した文字を名前に含むものを表示．
# -qa：
$ rpm -qa | grep {検索文字}
```

```bash
# 指定したパッケージ名で，関連する全てのファイルの場所を表示．
# -ql：
$ rpm -ql {パッケージ名}
```

```bash
# 指定したパッケージ名で，インストール日などの情報を表示．
# -qi：
$ rpm -qi {パッケージ名}
```



### yum，dnf

#### ・よく使うオプション集

rpmと同様の使い方ができる．また，インストール時にパッケージ間の依存関係を解決できる．

```bash
# パッケージをインストール
$ yum install -y {パッケージ名}

# 再インストールする時は，reinstallとすること
$ yum reinstall -y {パッケージ名}
```

```bash
# インストールされた全てのパッケージの中で，指定した文字を名前に含むものを表示．
$ yum list | grep {検索文字}
```

#### ・EPELリポジトリ，Remiリポジトリ

CentOS公式リポジトリはパッケージのバージョンが古いことがある．そこで，```--enablerepo```オプションを使用すると，CentOS公式リポジトリではなく，最新バージョンを扱う外部リポジトリ（EPEL，Remi）から，パッケージをインストールできる．外部リポジトリ間で依存関係にあるため，両方のリポジトリをインストールする必要がある．

1. CentOSのEPELリポジトリをインストール．インストール時の設定ファイルは，/etc/yu.repos.d/* に配置される．

```bash
# CentOS7系の場合
$ yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# CentOS8系の場合
$ dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# こちらでもよい
$ yum install -y epel-release でもよい
```
2. CentOSのRemiリポジトリをインストール．RemiバージョンはCentOSバージョンを要確認．インストール時の設定ファイルは，```/etc/yu.repos.d/*```に配置される．

```bash
# CentOS7系の場合
$ yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# CentOS8系の場合
$ dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

4. 設定ファイルへは，インストール先のリンクなどが自動的に書き込まれる．

```
[epel]
name=Extra Packages for Enterprise Linux 6 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 6 - $basearch - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch/debug
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-6&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 6 - $basearch - Source
#baseurl=http://download.fedoraproject.org/pub/epel/6/SRPMS
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-6&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1
```

5. Remiリポジトリの有効化オプションを永続的に使用できるようにする．

```bash
# CentOS7の場合
$ yum install -y yum-utils
# 永続的に有効化
$ yum-config-manager --enable remi-php74


# CentOS8の場合（dnf moduleコマンドを使用）
$ dnf module enable php:remi-php74
```

6. remiリポジトリを指定して，php，php-mbstring，php-mcryptをインストールする．Remiリポジトリを経由してインストールしたソフトウェアは```/opt/remi/*```に配置される．

```bash
# CentOS7の場合
# 一時的に有効化できるオプションを利用して，明示的にremiを指定
$ yum install --enablerepo=remi,remi-php74 -y php php-mbstring php-mcrypt


# CentOS8の場合
# リポジトリの認識に失敗することがあるのでオプションなし
$ dnf install -y php php-mbstring php-mcrypt
```

7. 再インストールする時は，reinstallとすること．

```bash
# CentOS7の場合
# 一時的に有効化できるオプションを利用して，明示的にremiを指定
$ yum reinstall --enablerepo=remi,remi-php74 -y php php-mbstring php-mcrypt


# CentOS8の場合
# リポジトリの認識に失敗することがあるのでオプションなし
$ dnf reinstall -y php php-mbstring php-mcrypt
```



## 03-04. 言語バージョン管理ユーティリティ

### pyenv

#### ・よく使うオプション集

```bash
# pythonのインストールディレクトリを確認
$ pyenv which python
/.pyenv/versions/3.8.0/bin/python
```



## 04.  言語プロセッサ

### 言語プロセッサの例

#### ・アセンブラ

以降の説明を参照．

#### ・コンパイラ

以降の説明を参照．

#### ・インタプリタ

以降の説明を参照．



### 言語の種類

プログラム言語のソースコードは，言語プロセッサによって機械語に変換された後，CPUによって読み込まれる．そして，ソースコードに書かれた様々な処理が実行される．

#### ・コンパイラ型言語

C#など．コンパイラという言語プロセッサによって，コンパイラ方式で翻訳される言語．

#### ・インタプリタ型言語

PHP，Ruby，JavaScript，Python，など．インタプリタという言語プロセッサによって，インタプリタ方式で翻訳される言語をインタプリタ型言語という．

#### ・Java仮想マシン型言語

Scala，Groovy，Kotlin，など．Java仮想マシンによって，中間言語方式で翻訳される．

![コンパイル型とインタプリタ型言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/コンパイル型とインタプリタ型言語.jpg)



### 実行のエントリポイント

#### ・PHPの場合

動的型付け言語では，エントリポイントが指定プログラムの先頭行と決まっており，そこから枝分かれ状に処理が実行されていく．PHPでは，```index.php```がエントリポイントと決められている．その他のファイルにはエントリポイントは存在しない．

```PHP
<?php
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



## 04-02. コンパイラ型言語の機械語翻訳

### コンパイラ方式

#### ・機械語翻訳と実行のタイミング

コードを，バイナリ形式のオブジェクトコードとして，まとめて機械語に翻訳した後，CPUに対して命令が実行される．

![コンパイラ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/コンパイラ言語.png)

#### ・ビルド（コンパイル＋リンク）

コンパイルによって，ソースコードは機械語からなるオブジェクトコードに変換される．その後，各オブジェクトコードはリンクされ．exeファイルとなる．この一連のプロセスを『ビルド』という．

![ビルドとコンパイル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ビルドとコンパイル.jpg)

#### ・仕組み（じ，こ，い，さい，せい，リンク，実行）

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/構文規則と説明.png)

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
   
   

### makeによるビルド

#### 1. パッケージをインストール

```bash
# パッケージを公式からインストールと解答
$ wget {パッケージのリンク}
$ tar {パッケージのフォルダ名}

# ビルド用ディレクトリの作成．
$ mkdir build
$ cd build
```

#### 2. ビルドのルールを定義

configureファイルを元に，ルールが定義されたMakefileを作成する．

```bash
# configureへのパスに注意．
$ ../configure --prefix="{ソースコードのインストール先のパス}"
```

#### 3. ビルド （コンパイル＋リンク）

パッケージのソースコードからexeファイルをビルドする．

```bash
# -j で使用するコア数を宣言し，処理の速度を上げられる．
$ make -j4
```

任意で，exeファイルのテストを行える．

```bash
$ make check
```

#### 4. exeファイルの実行

生成されたソースコードのファイルを，指定したディレクトリにコピー．

```bash
# installと命令するが，実際はコピー．sudoを付ける．
$ sudo make install
```

元となったソースコードやオブジェクトコードを削除．

```bash
$ make clean
```



## 04-03. インタプリタ型言語の機械語翻訳

### インタプリタ方式

#### ・機械語翻訳と実行のタイミング

コードを，一行ずつ機械語に変換し，その都度，CPUに対して命令が実行される．

![インタプリタ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インタプリタ言語.png)

コマンドラインでそのまま入力し，機械語翻訳と実行を行うことができる．

```bash
#===========
# PHPの場合
#===========

# PHPなので，処理終わりにセミコロンが必要
$ php -r '{何らかの処理}'

# Hello Worldを出力
$ php -r 'echo "Hello World";'

# phpinfoを出力
$ php -r 'phpinfo();'

# （おまけ）phpinfoの出力をテキストファイルに保存
$ php -r 'phpinfo();' > phpinfo.txt
```

```bash
# php.iniの読み込み状況を出力
$ php --ini
```

#### ・仕組み（じ，こ，い，実行）

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．ソースコードから構造体を構築することを構文解析といい，htmlを構文解析してDOMツリーを構築する処理とは別物なので注意．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **命令の実行**

   意味解析の結果を基に，命令が実行される．

5. **１から４をコード行ごとに繰り返す**

#### ・補足：JSの機械語翻訳について

Webサーバを仮想的に構築する時，PHPの言語プロセッサが同時に組み込まれるため，PHPのソースコードの変更はブラウザに反映される．しかし，JavaScriptの言語プロセッサは組み込まれない．そのため，JavaScriptのインタプリタは別に手動で起動する必要がある．



## 04-04. Java仮想マシン型言語の機械語翻訳

### 中間言語方式

#### ・中間言語方式の機械語翻訳の流れ

1. JavaまたはJVM型言語のソースコードを，Javaバイトコードを含むクラスファイルに変換する．
2. JVM：Java Virtual Machine内で，インタプリタによって，クラスデータを機械語に翻訳する．
3. 結果的に，OS（制御プログラム？）に依存せずに，命令を実行できる．（C言語）

![Javaによる言語処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_1.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![Javaによる言語処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_2.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![Javaによる言語処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_3.png)

#### ・C言語とJavaのOSへの依存度比較

![CとJavaのOSへの依存度比較](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CとJavaのOSへの依存度比較.png)

- JVM言語

ソースコード



## 05. 制御プログラム（カーネル）

### 制御プログラム（カーネル）の例

  カーネル，マイクロカーネル，モノリシックカーネル



### ジョブ管理

クライアントは，マスタスケジュールに対して，ジョブを実行するための命令を与える．

![ジョブ管理とタスク管理の概要](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブ管理とタスク管理の概要.jpg)



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

![ジョブからジョブステップへの分解](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブからジョブステップへの分解.png)



### タスク管理

![ジョブステップからタスクの生成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブステップからタスクの生成.png)

タスクとは，スレッドに似たような，単一のプロセスのこと．Initiatorによるジョブステップから，タスク管理によって，タスクが生成される．タスクが生成されると実行可能状態になる．ディスパッチャによって実行可能状態から実行状態になる．

#### ・優先順方式

各タスクに優先度を設定し，優先度の高いタスクから順に，ディスパッチしていく方式．

#### ・到着順方式

待ち行列に登録されたタスクから順に，ディスパッチしていく方式．

![到着順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/到着順方式_1.png)

**【具体例】**

以下の様に，タスクがCPUに割り当てられていく．

![到着順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/到着順方式_2.png)

#### ・Round robin 方式

Round robinは，『総当たり』の意味．一定時間（タイムクウォンタム）ごとに，実行状態にあるタスクが強制的に待ち行列に登録される．交代するように，他のタスクがディスパッチされる．

![ラウンドロビン方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ラウンドロビン方式.png)

**【具体例】**

生成されたタスクの到着時刻と処理時間は以下のとおりである．強制的なディスパッチは，『20秒』ごとに起こるとする．

![優先順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/優先順方式_1.png)

1. タスクAが0秒に待ち行列へ登録される．
2. 20秒間，タスクAは実行状態へ割り当てられる．
3. 20秒時点で，タスクAは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクBは，実行可能状態から実行状態にディスパッチされる．
4. 40秒時点で，タスクCは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクAは，実行可能状態から実行状態にディスパッチされる．

![優先順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/優先順方式_2.png)



### 入出力管理

アプリケーションから低速な周辺機器へデータを出力する時，まず，CPUはスプーラにデータを出力する．Spoolerは，全てのデータをまとめて出力するのではなく，一時的に補助記憶装置（Spool）にためておきながら，少しずつ出力する（Spooling）．

![スプーリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スプーリング.jpg)

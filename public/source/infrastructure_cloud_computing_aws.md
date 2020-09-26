# Amazon Web Service

## 01. コンピューティング

### EC2

#### ・EC2とは

クラウドサーバとしては働く．注意点があるものだけまとめる．

| 設定項目                  | 意味                                                         |
| ------------------------- | ------------------------------------------------------------ |
| AMI：Amazonマシンイメージ | OSを選択する．<br>※ ベンダー公式のものを選択すること．（例：CentOSのAMI一覧 https://wiki.centos.org/Cloud/AWS） |
| インスタンスの詳細設定    | EC2インスタンスの設定．<br>・インスタンス自動割り当てパブリックにて，EC2に動的パブリックIPを割り当てる．EC2インスタンス構築後に有効にできない．<br>・終了保護は必ず有効にすること． |
| ストレージの追加          | EBSボリュームを設定する．<br>※ 一般的なアプリケーションであれば，20～30GiBでよい．踏み台サーバの場合，最低限で良いため，OSの下限までサイズを下げる．（例：CentOSの下限は10GiB） |
| キーペア                  | EC2の秘密鍵に対応した公開鍵をインストールできる．<br>※ キーペアに割り当てられるフィンガープリント値を調べることで，公開鍵と秘密鍵の対応関係を調べることができる． |

#### ・静的／動的パブリックIPアドレス

| 設定項目                         | 機能                                            |
| -------------------------------- | ----------------------------------------------- |
| 自動割り当てパブリックIPアドレス | 動的なIPアドレスで，EC2の再構築後に変化する．   |
| Elastic IPアドレス               | 静的なIPアドレスで，EC2の再構築後も保持される． |

#### ・キーペアのフィンガープリント値

ローカルに置かれている秘密鍵が，該当するEC2に置かれている公開鍵とペアなのかどうか，フィンガープリント値を照合して確認する方法

```bash
$ openssl pkcs8 -in {秘密鍵}.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
```

#### ・EC2へのSSH接続

クライアントのSSHプロトコルもつパケットは，まずインターネットを経由して，インターネットゲートウェイを通過する．その後，Route53，ALBを経由せず，そのままEC2へ向かう．

![SSHポートフォワード](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SSHポートフォワード.png)



### Lambda

#### ・Lambdaとは

Lambdaを軸に他のFaaSと連携させることによって，ユーザ側は関数プログラムを作成しさえすれば，これを実行することができる．この方法を，『サーバレスアーキテクチャ』という．

![サーバレスアーキテクチャとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/サーバレスアーキテクチャとは.png)



## 01-02. コンピューティングに付随する設定

### Region，Availability Zone

#### ・Regionとは

2016年1月6日時点では，以下のRegionに物理サーバのデータセンターがある．

![AWSリージョンマップ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AWSリージョンマップ.PNG)

#### ・Availability Zoneとは

Regionは，さらに，各データセンターは物理的に独立したAvailability Zoneというロケーションから構成されている．例えば，東京Regionには，3つのAvailability Zoneがある．AZの中に，VPC subnetを作ることができ，そこにEC2を構築できる．



### Security Group（＝ パケットフィルタリング型ファイアウォール）

#### ・Security Groupとは

アプリケーションのクラウドパケットフィルタリング型ファイアウォールとして働く．インバウンド通信（プライベートネットワーク向き通信）では，プロトコルや受信元IPアドレスを設定でき，アウトバウンド通信（グローバルネットワーク向き通信）では，プロトコルや送信先プロトコルを設定できる．

#### ・パケットフィルタリング型ファイアウォールとは（セキュリティのノートを参照せよ）

パケットのヘッダ情報に記載された送信元IPアドレスやポート番号などによって，パケットを許可するべきかどうかを決定する．速度を重視する場合はこちら．ファイアウォールとWebサーバの間には，NATルータやNAPTルータが設置されている．これらによる送信元プライベートIPアドレスから送信元グローバルIPアドレスへの変換についても参照せよ．

![パケットフィルタリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パケットフィルタリング.gif)



## 02. コンテナ｜ECS x Fargate

![NatGatewayを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateからECRECSへのアウトバウンド通信.png)

### ECS：Elastc Cotainer Service

#### ・ECSとは

コンテナを管理する環境．VPCの外に存在している．ECS，EKS，Fargate，EC2の対応関係は以下の通り．

| Control Plane（コンテナ管理環境） | Data Plane（コンテナ実行環境） |
| --------------------------------- | ------------------------------ |
| ECS                               | Fargate，EC2                   |
| EKS                               | Fargate，EC2                   |

#### ・クラスター

![ECSクラスター](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ECSクラスター.png)



### サービス

#### ・サービスとは

タスク定義に基づいたタスクを，どのように自動的に配置するかを設定できる，タスク定義一つに対して，サービスを一つ定義する．

| 設定項目       | 内容                                                         |
| -------------- | ------------------------------------------------------------ |
| タスクの数     | タスクの構築数をいくつに維持するかを設定．<br>※ タスクが何らかの原因で停止した場合，空いているAWSサービスを使用して，タスクが自動的に補填される． |
| デプロイメント | ローリングアップデート，Blue/Greenデプロイがある．           |

#### ・ローリングアップデート

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. ローリングアップデートによって，タスク定義を基に，新しいタスクがリリースされる．

#### ・CodeDeployを使用したBlue/Greenデプロイ

![Blue-Greenデプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Blue-Greenデプロイ.jpeg)

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. CodeDeployによって，タスク定義を基に，現行の本番環境（Prodブルー）のタスクとは別に，テスト環境（Testグリーン）が構築される．ロードバランサーの接続先を本番環境（Prodブルー）のターゲットグルーップ（Primaryターゲットグループ）から，テスト環境（Testグリーン）のターゲットグループに切り替える．テスト環境（Testグリーン）で問題なければ，これを新しい本番環境としてリリースする．



### タスク，タスク定義

![タスクとタスク定義](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/タスクとタスク定義.png)

#### ・タスクとは

タスク（コンテナの集合）をどのような設定値（```json```形式ファイル）に基づいて構築するかを設定できる．タスク定義は，バージョンを示す「リビジョンナンバー」で番号づけされる．

#### ・割り当てられるプライベートIPアドレス

タスクごとに異なるプライベートIPが割り当てられる．このIPアドレスに対して，ALBはルーティングを行う．

#### ・ネットワークモード

| 設定項目 | 相当するDockerのネットワーク機能                             |
| -------- | ------------------------------------------------------------ |
| bridge   | bridgeネットワーク                                           |
| host     | hostネットワーク                                             |
| awsvpc   | awsの独自ネットワーク機能．<br/>※ タスクはElastic Network Interfaceと紐づけられ，PrimaryプライベートIPアドレスを割り当てられる． |

#### ・タスクサイズ


| 設定項目     | 内容                                     |
| ------------ | ---------------------------------------- |
| タスクメモリ | タスク当たりのコンテナの合計メモリ使用量 |
| タスクCPU    | タスク当たりのコンテナの合計CPU使用量    |

#### ・コンテナ定義

タスク内のコンテナ一つに対して，環境を設定する．

| 設定項目         | 対応するdockerコマンドオプション             | 内容                                                         |
| ---------------- | -------------------------------------------- | ------------------------------------------------------------ |
| メモリ制限       | ```--memory```<br>```--memory-reservation``` | プロセスが使用できるメモリの閾値を設定．                     |
| ポートマッピング | ```--publish```                              | ホストマシンとFargateのアプリケーションのポート番号をマッピングし，ポートフォワーディングを行う． |
| ヘルスチェック   | ```--health-cmd```                           | ホストマシンからFargateに対して，```curl```コマンドによるリクエストを送信し，レスポンス内容を確認． |
| 間隔             | ```--health-interval```                      | ヘルスチェックの間隔を設定．                                 |
| 再試行           | ```--health-retries```                       | ヘルスチェックを成功と見なす回数を設定．                     |
| CPUユニット数    | ```--cpus```                                 | 仮想cpu数                                                    |
| ホスト名         | ```--hostname```                             | コンテナにホスト名を設定．                                   |
| DNSサーバ        | ```--dns```                                  | コンテナが名前解決に使用するDNSサーバのIPアドレスを設定      |
| マウントポイント |                                              |                                                              |
| ボリュームソース | ```--volumes-from```                         | Volumeマウントを行う．                                       |
| ulimit           | Linuxコマンドの<br>```--ulimit```に相当      |                                                              |
| 制約             |                                              | タスク（コンテナの集合）の配置の割り振り方を設定．<br>・Spread：タスクを各場所にバランスよく配置<br>・Binpack：タスクを一つの場所にできるだけ多く配置． |



### Fargate

#### ・割り当てられるパブリックIPアドレス，FargateのIPアドレス問題

FargateにパブリックIPアドレスを持たせたい場合，Elastic IPアドレスの設定項目がなく，動的パブリックIPアドレスしか設定できない（Fargateの再構築後に変化する）．アウトバウンド通信の先にある外部サービスが，セキュリティ上で静的なIPアドレスを要求する場合，アウトバウンド通信（グローバルネットワーク向き通信）時に送信元パケットに付加されるIPアドレスが動的になり，リクエストができなくなってしまう．

![NatGatewayを介したFargateから外部サービスへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateから外部サービスへのアウトバウンド通信.png)

そこで，Fargateのアウトバウンド通信が，Elastic IPアドレスを持つNAT Gatewayを経由するようにする（Fargateは，パブリックサブネットとプライベートサブネットのどちらに置いても良い）．これによって，Nat GatewayのElastic IPアドレスが送信元パケットに付加されるため，Fargateの送信元IPアドレスを見かけ上静的に扱うことができるようになる．

#### ・ECRに対するDockerイメージのプル

FargateからECRに対するDockerイメージのプルは，アウトバウンド通信（グローバルネットワーク向き通信）である．以下の通り，NAT Gatewayを設置したとする．この場合，ECSやECRとのアウトバウンド通信がNAT Gatewayを通過するため，高額料金を請求されてしまう．

![NatGatewayを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateからECRECSへのアウトバウンド通信.png)

そこで，一つの方法として，PrivateLinkを介して，ECRやECSとのアウトバウンド通信を行う設計方法がある．

![PrivateLinkを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/PrivateLinkを介したFargateからECRECSへのアウトバウンド通信.png)

### ECR

#### ・タグの変性／不変性



## 03. ストレージ

### EBS：Elastic Block Storage

#### ・EBSとは

クラウド内蔵ストレージとして働く．

#### ・ストレージの種類とボリュームタイプ

| ストレージの種類 | ボリューム名            |
| ---------------- | ----------------------- |
| SSD              | 汎用SSD                 |
| SSD              | プロビジョンド IOPS SSD |
| HDD              | スループット最適化 HDD  |
| HDD              | Cold HDD                |



### S3：Simple Storage Service

#### ・S3とは

クラウド外付けストレージとして働く．Amazon S3に保存するCSSファイルや画像ファイルを管理できる．



### EFS：Elastic File System

![EFSのファイル共有機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/EFSのファイル共有機能.png)

#### ・EFSとは

EC2インスタンス間でファイルを共有する．アプリケーションのあるディレクトリをマウントターゲットに設定し，ソースコードそのものを共有してもよい．

| 設定項目                 | 意味                                                         |
| ------------------------ | ------------------------------------------------------------ |
| ファイルシステム         | EFSに関する設定                                              |
| ネットワークアクセス     | マウントターゲットを設置するサブネット，セキュリティグループを設定<br>※ セキュリティグループは，基本的に，マウントターゲットにアクセスするAWSサービスと同じ |
| ファイルシステムポリシー | AWSサービスがEFSを利用する時のポリシーを設定．               |

#### ・マウント

DNS経由で，EFSマウントヘルパーを使用した場合を示す．

```bash
$ mount -t {ファイルシステムタイプ} -o tls {ファイルシステムID}:/ {マウントポイント}
```

```bash
# Amazon EFSで，マウントポイントを登録
$ mount -t efs -o tls fs-xxxxx:/ /var/www/app

# マウントポイントを解除
$ umount /var/www/app

# dfコマンドでマウントしているディレクトリを確認できる
```



## 04. データベース

### Amazon RDS：Amazon Relational Database Service

#### ・Amazon RDSとは

| 設定項目             | 意味                                                         |
| -------------------- | ------------------------------------------------------------ |
| エンジンのオプション | データベースエンジンの種類を設定                             |
| エディション         | Amazon Auroraを選んだ場合の互換性を設定                      |
| DBクラスター識別子   | クラスター名を設定．<br/>※ インスタンス名は，最初に設定できず，RDSの構築後に設定できる． |
| マスタユーザ名       | データベースのrootユーザを設定                               |
| マスターパスワード   | データベースのrootユーザのパスワードを設定                   |
| 最初のデータベース名 | RDBに自動的に構築されるデータベース名を設定                  |
| パラメータグループ   | グローバルパラメータを設定．<br>※ 新しくパラメータグループを作成し，タイムゾーンをAsia/Tokyoに変更すること |
| ログのエクスポート   | 必ず，全てのログを選択すること．                             |

#### ・データベースエンジン，RDB，DBMSの対応関係

Amazon RDSでは，データベースエンジン，RDB，DBMSを選べる．

| データベースエンジンの種類 | RDBの種類              | DBMSの種類        |
| -------------------------- | ---------------------- | ----------------- |
| Amazon Aurora              | Amazon Aurora          | MySQL／PostgreSQL |
| MariaDB                    | MariaDBデータベース    | MariaDB           |
| MySQL                      | MySQLデータベース      | MySQL             |
| PostgreSQL                 | PostgreSQLデータベース | PostgreSQL        |

#### ・Amazon RDSのセキュリティグループ

コンピューティングからのインバウンド通信のみを許可するように，これらのプライベートIPアドレス（```n.n.n.n/32```）を設定する．

#### ・データベースクラスターのエンドポイント

![RDSエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/RDSエンドポイント.png)

インスタンス群に対して，以下のエンドポイントが提供される．

```
# 読み出し／書き込みインスタンス群のエンドポイント
xxxxx-cluster.cluster-abcde12345.ap-northeast-1.rds.amazonaws.com
```

```
# 読み出しオンリーインスタンス群のエンドポイント
xxxxx-cluster.cluster-ro-abcde12345.ap-northeast-1.rds.amazonaws.com
```

読み出しオンリーエンドポイントに対して，READ以外の処理を行うと，以下の通り，エラーとなる．


```sql
/* SQL Error (1290): The MySQL server is running with the --read-only option so it cannot execute this statement */
```

#### ・データベースインスタンスの種類

|                    | 読み出し／書き込みインスタンス                               | 読み出しオンリーインスタンス                                 |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **別名**           | プライマリインスタンス                                       | リードレプリカインスタンス                                   |
| **CRUD制限**       | 制限なし．ユーザ権限に依存する．                             | ユーザ権限の権限に関係なく，READしか実行できない．           |
| **エンドポイント** | 各インスタンスに，リージョンのイニシャルに合わせたエンヂポイントが割り振られる． | 各インスタンスに，リージョンのイニシャルに合わせたエンヂポイントが割り振られる． |



### ElastiCache

#### ・ElastiCacheとは

アプリケーションの代わりに，セッション，クエリキャッシュ，を管理する．RedisとMemcachedがある．

| Redis  | Memcached |
| ------ | --------- |
| 要学習 | 要学習    |
| 要学習 | 要学習    |
| 要学習 | 要学習    |

#### ・コマンド

```bash
# Redis接続コマンド
$ redis-cli -c -h {Redisのホスト名} -p 6379
```

```bash
# Redis接続中の状態
# 全てのキーを表示
redis xxxxx:6379> keys *
```

```bash
# Redis接続中の状態
# キーを指定して，対応する値を表示
redis xxxxx:6379> type {キー名}
```

```bash
# Redis接続中の状態
# Redisが受け取ったコマンドをフォアグラウンドで表示
redis xxxxx:6379> monitor
```

#### ・セッション管理機能

![ElastiCacheのセッション管理機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ElastiCacheのセッション管理機能.png)

EC2インスタンスの冗長化時，これらの間で共通のセッションを使用できるように，セッションを管理する．

#### ・クエリキャッシュ管理機能

![ElastiCacheのクエリキャッシュ管理機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ElastiCacheのクエリキャッシュ管理機能.png)

1. SQLの実行結果を管理する．最初，EC2インスタンスからRDSにSQLが実行される時，SQLの実行結果を保存しておく．

```mysql
# アプリケーションがSQLを実行する
SELECT * FROM users;
```

```　bash
# ElastiCacheには，SQLの実行結果がまだ保存されていない
*** no cache ***
{"id"=>"1", "name"=>"alice"}
{"id"=>"2", "name"=>"bob"}
{"id"=>"3", "name"=>"charles"}
{"id"=>"4", "name"=>"donny"}
{"id"=>"5", "name"=>"elie"}
{"id"=>"6", "name"=>"fabian"}
{"id"=>"7", "name"=>"gabriel"}
{"id"=>"8", "name"=>"harold"}
{"id"=>"9", "name"=>"Ignatius"}
{"id"=>"10", "name"=>"jonny"}
```

2. 以降，同じSQLが実行された時には，RDSの代わりにデータをアプリケーションに渡す．

```mysql
# アプリケーションが１番と同じSQLを実行する
SELECT * FROM users;
```


```bash
# ElastiCacheには，SQLの実行結果が既に保存されている
*** cache hit ***
{"id"=>"1", "name"=>"alice"}
{"id"=>"2", "name"=>"bob"}
{"id"=>"3", "name"=>"charles"}
{"id"=>"4", "name"=>"donny"}
{"id"=>"5", "name"=>"elie"}
{"id"=>"6", "name"=>"fabian"}
{"id"=>"7", "name"=>"gabriel"}
{"id"=>"8", "name"=>"harold"}
{"id"=>"9", "name"=>"Ignatius"}
{"id"=>"10", "name"=>"jonny"}
```



## 05. ネットワーキング，コンテンツデリバリー



### API Gateway

![APIGatewayの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/APIGatewayの仕組み.png)

#### ・API Gatewayとは

API Gatewayは，メソッドリクエスト，統合リクエスト，統合レスポンス，メソッドレスポンス，から構成される．

#### 1. Method Request

クライアントからリクエストメッセージを受信．また，リクエストメッセージからデータを抽出．（※ メッセージについては，アプリケーション層の説明を参照せよ）

#### 2. Integration Request（統合リクエスト）

データを編集し，指定のAWSサービスにこれを送信．

#### 3. Integration Response（統合レスポンス）

指定のAWSサービスからデータを受信し，これを編集．

#### 4. Method Response

HTTPステータスを追加．また，データをレスポンスメッセージとして，クライアントに送信．



### CloudFront

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudFrontによるリクエストの振り分け.png)

#### ・CloudFrontとは

クラウドProxyサーバとして働く．リクエストを受け付ける．オリジンサーバ（コンテンツ提供元）をS3とした場合，動的コンテンツへのリクエストをEC2に振り分ける．また，静的コンテンツへのリクエストをキャッシュし，その上でAmazon S3へ振り分ける．次回以降の静的コンテンツのリンクエストは，CloudFrontがレンスポンスを行う．

| 設定項目                 | 意味                                                     |
| ------------------------ | -------------------------------------------------------- |
| General                  |                                                          |
| Origin and Origin Groups | リソースを提供するAWSサービスを設定                      |
| Behavior                 | オリジンにリクエストが行われた時のCloudFrontの挙動を設定 |
| ErrorPage                |                                                          |
| Restriction              |                                                          |
| Invalidation             | CloudFrontに保存されているキャッシュを削除できる．       |

#### ・General

| 設定項目         | 意味                                                         |
| ---------------- | ------------------------------------------------------------ |
| Price Class      | 使用するエッジロケーションを設定．<br>※ Asiaが含まれているものを選択． |
| AWS WAF          | CloudFrontに紐づけるWAFを設定．                              |
| CNAME            | CloudFrontのデフォルトドメイン名（```xxxxx.cloudfront.net.```）に紐づけるRoute53レコード名を設定．<br>※ 複数のレコード名を設定できる． |
| Standard Logging | CloudFrontのアクセスログをS3に生成するかどうかを設定．       |

#### ・Origin and Origin Groups

| 設定項目               | 意味                                                         |
| ---------------------- | ------------------------------------------------------------ |
| Origin Type            | CloudFrontを経由してリソースを提供するAWSサービスを設定．    |
| Origin Access Identity | CloudFrontに，他のAWSサービスへのアクセス権限を設定．アクセスを受け入れるAWSサービス側では，アクセスポリシーでID番号を使う |

#### ・Behavior

| 設定項目                       | 意味                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| Precedence                     | 処理の優先順位．<br>※ デフォルトパスは，必ず最後に検証する． |
| Path Pattern                   | Behaviorを行うファイルパスを設定．                           |
| Origin or Origin Group         | Behaviorを行うOriginを設定．                                 |
| Viewer Protocol Policy         | HTTP／HTTPSのどちらを受信するか，またどのように変換して転送するかを設定<br>※ ```HTTP and HTTPS```：両方受信し，そのまま転送<br>※ ```Redirect HTTP to HTTPS```：両方受信し，HTTPSで転送<br/>※ ```HTTPS Only```：HTTPSのみ受信し，HTTPSで転送 |
| Allowed HTTP Methods           | リクエストのHTTPメソッドのうち，オリジンへの転送を許可するものを設定 |
| Whitelist Header               | リクエストのヘッダーに含まれるデータのうち，オリジンへの転送を許可するものを設定．<br/>※ レスポンスのヘッダーに含まれる「```X-Cache:```」が「```Hit from cloudfront```」，「```Miss from cloudfront```」のどちらで，キャッシュの使用の有無を判断できる．<br>※ ```Accept-xxxxx```：アプリケーションにレスポンスして欲しいデータの種類（データ型など）を指定．<br>※ ```CloudFront-Is-xxxxx-Viewer```：ユーザーエージェントのBool値が格納されている． |
| Object Caching                 | CloudFrontにキャッシュを保存しておく秒数を設定．<br>※ TTLを設定するために，カスタマイズを選ぶこと． |
| TTL                            | CloudFrontにキャッシュを保存しておく秒数を詳細に設定．<br>※ Min，Max，Default，の全てを0秒とすると，キャッシュを無効化できる． |
| Farward Cookies                | オリジンへの転送を許可するCookie情報をWhitelistで設定．<br>※ リクエストのヘッダーに含まれるCookie情報の値が変動していると，CloudFrontに保存されたキャッシュがHITしない．CloudFrontはCookie情報もキャッシュ対象として扱うため，変化しやすいCookie情報はWhitelistで許可しないようにする．（例：GoogleAnalyticsのCookie情報は変化しやすい） |
| Compress Objects Automatically |                                                              |

#### ・Invalidation

CloudFrontに保存してあるキャッシュを削除できる．全てのファイルのキャッシュを削除したい場合は「```/*```」，特定のファイルのキャッシュを削除したい場合は「```/{ファイルへのパス}```」，を指定する．



### Route53

#### ・Route53とは

クラウドDNSサーバーとして働く．リクエストされた完全修飾ドメイン名とEC2のグローバルIPアドレスをマッピングしている．

| 設定項目       | 意味                                                         |
| -------------- | ------------------------------------------------------------ |
| ホストゾーン   | ドメイン名を設定．                                           |
| レコードセット | 名前解決時のルーティング方法を設定．<br>※ サブドメイン名を扱うことも可能． |

#### ・CloudFrontへのルーティング

CloudFrontにルーティングする場合，CloudFrontのCNAMEをレコード名とすると，CloudFrontのデフォルトドメイン名（```xxxxx.cloudfront.net.```）が，入力フォームに表示されるようになる．


#### ・レコードタイプの設定値の違い

| レコードタイプ |                                                              |
| -------------- | ------------------------------------------------------------ |
| A              | リクエストを転送したいAWSサービスの，IPv4アドレスまたはDNS名を設定． |
| AAAA           | リクエストを転送したいAWSサービスの，IPv6アドレスまたはDNS名を設定． |
| CNAME          | リクエストを転送したい任意のサーバのドメイン名を設定．<br>※ 転送先はAWSサービスでなくともよい． |
| MX             | リクエストを転送したいメールサーバのドメイン名を設定．       |
| TXT            | リクエストを転送したいサーバのドメイン名に関連付けられた文字列を設定． |
#### ・レコードタイプの名前解決方法の違い

![URLと電子メールの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/URLと電子メールの構造.png)

| レコードタイプ | 名前解決方法（1） |      |      （2）       |      |     （3）      |
| -------------- | :-------------------: | :--: | :--------------: | :--: | :------------: |
| A              |  完全修飾ドメイン名   |  →   |  パブリックIPv4  |  →   |       -        |
| AAAA           |  完全修飾ドメイン名   |  →   |  パブリックIPv6  |  →   |       -        |
| CNAME          |  完全修飾ドメイン名   |  →   | （リダイレクト） |  →   | パブリックIPv4 |

#### ・Route53を含む多数のDNSサーバによって名前解決される仕組み

（1）完全修飾ドメイン名に対応するIPアドレスのレスポンス

![Route53の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Route53の仕組み.png)

1. クライアントPCは，完全修飾ドメイン名を，フォワードProxyサーバにリクエスト．

2. フォワードProxyサーバは，完全修飾ドメイン名を，リバースProxyサーバに代理リクエスト．

3. リバースProxyサーバは，完全修飾ドメイン名を，DNSサーバに代理リクエスト．

4. Route53は，DNSサーバとして機能する．完全修飾ドメイン名にマッピングされるIPv4アドレスを取得し，リバースProxyサーバにレスポンス．

   |     完全修飾ドメイン名      |  ⇄   |     IPv4アドレス      |
   | :-------------------------: | :--: | :-------------------: |
   | ```http://www.kagoya.com``` |      | ```203.142.205.139``` |

5. リバースProxyサーバは，IPv4アドレスを，フォワードProxyサーバに代理レスポンス．（※ NATによるIPv4アドレスのネットワーク間変換が起こる）

6. フォワードProxyサーバは，IPv4アドレスを，クライアントPCに代理レスポンス．

（2）IPアドレスに対応するWebページのレスポンス

1. クライアントPCは，レスポンスされたIPv4アドレスを基に，Webページを，リバースProxyサーバにリクエスト．
2. リバースProxyサーバは，Webページを，Webサーバに代理リクエスト．
3. EC2は，Webページを，リバースProxyサーバにレスポンス．
4. リバースProxyサーバは，Webページを，クライアントPCに代理レスポンス．



## 05-02. ネットワーキング，コンテンツデリバリー｜ALB

### ALB：Application Load Balancing

![ALBの機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ALBの機能.png)

#### ・ALBとは

クラウドリバースプロキシサーバ，かつクラウドロードバランサーとして働く．リクエストを代理で受信し，インスタンスへのアクセスをバランスよく分配することによって，サーバへの負荷を緩和する．

| 設定項目           | 意味                                                         |
| ------------------ | ------------------------------------------------------------ |
| リスナー           | ALBに割り振るポート番号お，受信するプロトコルを設定する．リバースプロキシかつロードバランサ－として，これらの通信をターゲットグループにルーティングする． |
| ルール             | リクエストのルーティングのロジックを設定する．               |
| ターゲットグループ | ルーティング時に使用するプロトコルと，ルーティング先のアプリケーションに割り当てられたポート番号を指定する． |
| ヘルスチェック     | ターゲットグループに属するプロトコルとアプリケーションのポート番号を指定して，定期的にリクエストを送信する． |

#### ・ターゲットの指定方法

| ターゲットの指定方法 | 備考                                                         |
| -------------------- | ------------------------------------------------------------ |
| インスタンス         | ターゲットが，EC2でなければならない．                        |
| IPアドレス           | ターゲットのパブリックIPアドレスが，静的でなければならない． |
| Lambda               | ターゲットが，Lambdaでなければならない．                     |

#### ・アクセスログの出力方法

S3のブロックパブリックアクセスを全て無効にしたうえで，S3のバケットポリシーにして，ALBからS3へのログ書き込み権限を設定する．「```"AWS": "arn:aws:iam::582318560864:root"```」において，```582318560864```は，ALBアカウントIDと呼ばれ，リージョンごとに値が決まっている．

```yaml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::582318560864:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::{バケット名}/*"
        }
    ]
}
```



### Webサーバ，アプリケーションにおける対応

#### ・問題

ALBからEC2へのルーティングをHTTPプロトコルとした場合，アプリケーション側で，HTTPSプロトコルを用いた処理ができなくなる．そこで，クライアントからALBに対するリクエストのプロトコルがHTTPSだった場合に，Webサーバまたはアプリケーションにおいて，ルーティングのプロトコルをHTTPSと見なすように対処する．

![ALBからEC2へのリクエストのプロトコルをHTTPSと見なす](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ALBからEC2へのリクエストのプロトコルをHTTPSと見なす.png)

#### ・Webサーバにおける対処方法

ALBを経由したリクエストの場合，リクエストヘッダーに```X-Forwarded-Proto```が付与される．これには，ALBに対するリクエストのプロトコルの種類が．文字列で格納されている．これが「```https```」だった場合に，WebサーバへのリクエストをHTTPSであるとみなすように対処する．これにより，アプリケーションへのリクエストのプロトコルがHTTPSとなる（こちらを行った場合は，アプリケーション側の対応不要）．

**＊実装例＊**

```apacheconf
SetEnvIf X-Forwarded-Proto https HTTPS=on
```

#### ・アプリケーションにおける対処方法

ALBを経由したリクエストの場合，リクエストヘッダーに```HTTP_X_FORWARDED_PROTO```が付与される．これには，ALBに対するリクエストのプロトコルの種類が．文字列で格納されている．これが「```https```」だった場合に，アプリケーションへのリクエストをHTTPSであるとみなすように，```index.php```に追加実装を行う．

**＊実装例＊**


```php
<?php
// index.php
if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"])
    && $_SERVER["HTTP_X_FORWARDED_PROTO"] == 'https') {
    $_SERVER["HTTPS"] = 'on';
}
```



### その他の留意事項

#### ・割り当てられるプライベートIPアドレス範囲

ALBに割り当てられるIPアドレス範囲には，VPCのものが適用される．そのため，EC2のSecurity Groupでは，VPCのIPアドレス範囲を許可するように設定する必要がある．

#### ・ALBのセキュリティグループ

Route53から転送されるパブリックIPアドレスを受信できるようにしておく必要がある．パブリックネットワークに公開するWebサイトであれば，IPアドレスは全ての範囲（```0.0.0.0/0```と``` ::/0```）にする．社内向けのWebサイトであれば，社内のプライベートIPアドレスのみ（```n.n.n.n/32```）を許可するようにする．



## 05-03. ネットワーキング，コンテンツデリバリー｜VPC

### VPC：Virtual Private Cloud（＝プライベートネットワーク）

#### ・VPCが提供する仮想ネットワーク範囲とは

クラウドプライベートネットワークとして働く．プライベートIPアドレスが割り当てられた，VPCと呼ばれるプライベートネットワークを仮想的に構築することができる．異なるAvailability Zoneに渡ってEC2を立ち上げることによって，クラウドサーバをデュアル化することできる．

![VPCが提供できるネットワークの範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCが提供できるネットワークの範囲.png)



### Internet Gateway，NAT Gateway

![InternetGatewayとNATGateway](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/InternetGatewayとNATGateway.png)

#### ・Internet Gatewayとは

VPCの出入り口に設置され，グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT）の機能を持つ．一つのパブリックIPに対して，一つのEC2のプライベートIPを紐づけられる．詳しくは，別ノートのNAT（静的NAT）を参照せよ．

#### ・NAT Gatewayとは

NAPT（動的NAT）の機能を持つ．一つのパブリックIPに対して，複数のEC2のプライベートIPを紐づけられる．パブリックsubnetに置き，プライベートSubnetのEC2からのレスポンスを受け付ける．詳しくは，別ノートのNAPT（動的NAT）を参照せよ．

#### ・比較表


|              | Internet Gateway                                             | NAT Gateway        |
| :----------- | :----------------------------------------------------------- | :----------------- |
| **機能**     | グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT） | NAPT（動的NAT）    |
| **設置場所** | VPC上                                                        | パブリックsubnet内 |



### Route Table（= マッピングテーブル）

![ルートテーブル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ルートテーブル.png)

#### ・Route Tableとは

クラウドルータのマッピングテーブルとして働く．ルータについては，別ノートのNATとNAPTを参照せよ．

| Destination（プライベートIPの範囲） |                Target                 |
| :---------------------------------: | :-----------------------------------: |
|          ```xx.x.x.x/xx```          | Destinationの範囲内だった場合の送信先 |

#### ・具体例1

上の図中で，サブネット2にはルートテーブル1が関連づけられている．サブネット2内のEC2の送信先のプライベートIPアドレスが，```10.0.0.0/16```の範囲内にあれば，インバウンド通信と見なし，local（VPC内の他サブネット）を送信先に選び，範囲外にあれば通信を破棄する．

| Destination（プライベートIPアドレス範囲） |  Target  |
| :---------------------------------------: | :------: |
|             ```10.0.0.0/16```             |  local   |
|            指定範囲以外の場合             | 通信破棄 |

#### ・具体例2

上の図中で，サブネット3にはルートテーブル2が関連づけられている．サブネット3内のEC2の送信先のプライベートIPアドレスが，```10.0.0.0/16```の範囲内にあれば，インバウンド通信と見なし，local（VPC内の他サブネット）を送信先に選び，```0.0.0.0/0```（local以外の全IPアドレス）の範囲内にあれば，アウトバウンド通信と見なし，インターネットゲートウェイを送信先に選ぶ．

| Destination（プライベートIPアドレス範囲） |      Target      |
| :---------------------------------------: | :--------------: |
|             ```10.0.0.0/16```             |      local       |
|              ```0.0.0.0/0```              | Internet Gateway |





### ネットワークACL

![ネットワークACL](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ネットワークACL.png)

#### ・ネットワークACLとは

サブネットのクラウドパケットフィルタリング型ファイアウォールとして働く．ルートテーブルとサブネットの間に設置され，双方向のインバウンドルールとアウトバウンドルールを決定する．

#### ・ACLルール

ルールは上から順に適用される．例えば，インバウンドルールが以下だった場合，ルール100が最初に適用され，サブネットに対する，全IPアドレス（```0.0.0.0/0```）からのインバウンド通信を許可していることになる．

| ルール # | タイプ                | プロトコル | ポート範囲 / ICMP タイプ | ソース    | 許可 / 拒否 |
| -------- | --------------------- | ---------- | ------------------------ | --------- | ----------- |
| 100      | すべての トラフィック | すべて     | すべて                   | 0.0.0.0/0 | ALLOW       |
| *        | すべての トラフィック | すべて     | すべて                   | 0.0.0.0/0 | DENY        |



### VPC subnet

クラウドプライベートネットワークにおけるセグメントとして働く．

#### ・パブリックsubnetとは

非武装地帯に相当する．攻撃の影響が内部ネットワークに広がる可能性を防ぐために，外部から直接リクエストを受ける，

#### ・プライベートsubnetとは

内部ネットワークに相当する．外部から直接リクエストを受けずにレスポンスを返せるように，内のNATを経由させる必要がある．

![パブリックサブネットとプライベートサブネットの設計](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パブリックサブネットとプライベートサブネットの設計.png)

#### ・同一VPC内の各AWSサービスに割り当てる最低限のIPアドレス数

一つのVPC内には複数のSubnetが入る．そのため，SubnetのIPアドレス範囲は，Subnetの個数だけ狭めなければならない．また，VPCがもつIPアドレス範囲から，VPC内の各AWSサービスにIPアドレスを割り当てていかなければならない．VPC内でIPアドレスが枯渇しないように，　以下の手順で，割り当てを考える．

1. rfc1918 に準拠し，VPCに以下の範囲内でIPアドレスを割り当てる．

| IPアドレス                                | サブネットマスク（CIDR形式） | 範囲                 |
| ----------------------------------------- | ---------------------------- | -------------------- |
| ```10.0.0.0```  ~ ```10.255.255.255```    | ```/8```                     | ```10.0.0.0/8```     |
| ```172.16.0.0``` ~ ```172.31.255.255```   | ```/12```                    | ```172.16.0.0/12```  |
| ```192.168.0.0``` ~ ```192.168.255.255``` | ```/16```                    | ```192.168.0.0/16``` |

2. VPC内の各AWSサービスにIPアドレス範囲を割り当てる．

| AWSサービスの種類  | 最低限のIPアドレス数                    |
| ------------------ | --------------------------------------- |
| ALB                | ALB1つ当たり，8個                       |
| オートスケーリング | 水平スケーリング時のEC2最大数と同じ個数 |
| VPCエンドポイント  | VPCエンドポイント1つ当たり，1個         |
| ECS                | Elastic Network Interface 数と同じ個数  |
| Lambda             | Elastic Network Interface 数と同じ個数  |



### VPCエンドポイント（Private Link）

![VPCエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCエンドポイント.png)

#### ・VPCエンドポイントとは

NATとインターネットゲートウェイを経由せずにVPCの外側と通信できるため，NATの負荷を抑え，またより安全に通信できる．



### VPCピアリング接続

![VPCピアリング接続](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続.png)

#### ・VPCピアリング接続とは

異なるVPCにあるAWSのサービス間で，相互にデータ通信を行うことができる．

#### ・VPCピアリング接続ができない場合

| アカウント   | VPCのあるリージョン | VPC内のCIDRブロック    | 接続の可否 |
| ------------ | ------------------- | ---------------------- | ---------- |
| 同じ／異なる | 同じ／異なる        | 全て異なる             | **〇**     |
|              |                     | 同じものが一つでもある | ✕          |

VPC に複数の IPv4 CIDR ブロックがあり，一つでも 同じCIDR ブロックがある場合は、VPC ピアリング接続はできない．

![VPCピアリング接続不可の場合-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-1.png)

たとえ，IPv6が異なっていても，同様である．

![VPCピアリング接続不可の場合-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-2.png)



## 06. アプリケーションインテグレーション

### SQS：Simple Queue Service

![AmazonSQSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AmazonSQSとは.jpeg)

#### ・SQSとは

クラウドメッセージキューとして働く．異なるVPC間でも，メッセージキューを同期できる．クラウドサーバで生成されたメッセージは，一旦SQSに追加される．コマンドによってバッチが実行され，メッセージが取り出される．その後，例えば，バッチ処理によってメッセージからデータが取り出されてファイルが生成され，S3に保存されるような処理が続く．



#### ・SQSの種類

| 設定項目         | 意味 |
| ---------------- | ---- |
| スタンダード方式 |      |
| FIFO方式         |      |



### SNS：Simple Notification Service

![SNSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SNSとは.png)

#### ・SNSとは

パブリッシャーから発信されたメッセージをエンドポイントで受信し，サブスクライバーに転送するサービス．

| 設定項目           | 意味                                             |
| ------------------ | ------------------------------------------------ |
| トピック           | 複数のサブスクリプションをグループ化したもの．   |
| サブスクリプション | エンドポイントで受信するメッセージの種類を設定． |

#### ・サブスクリプション

| メッセージの種類 | 転送先                                                       |
| ---------------- | ------------------------------------------------------------ |
| HTTPS            | 任意のドメイン名<br>※ Chatbotのドメイン名は「```https://global.sns-api.chatbot.amazonaws.com```」 |
| Eメール          | 任意のメールアドレス                                         |
| JSON形式のメール | 任意のメールアドレス                                         |
| SQS              | SQS                                                          |
| Lambda           | Lambda                                                       |
| SMS              | SMS                                                          |



## 07. マネジメント，ガバナンス

### Auto Scaling

#### ・Auto Scalingとは

ユーザが指定した条件で，EC2の自動水平スケーリングを行うサービス．他のスケーリングについては，ネットワークのノートを参照．

| スケールアウト      | スケールイン        |
| ------------------- | ------------------- |
| ・起動するEC2の個数 | ・終了するEC2の条件 |

![Auto-scaling](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Auto-scaling.png)



### Chatbot

#### ・Chatbotとは

![ChatbotとSNSの連携](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ChatbotとSNSの連携.png)

SNSを経由して，CloudWatchからの通知をチャットアプリに転送するサービス．クライアントをSlackとした場合の設定を以下に示す．

| 設定項目        | 意味                                                      |
| --------------- | --------------------------------------------------------- |
| Slackチャンネル | 通知の転送先のSlackチャンネルを設定．                     |
| アクセス許可    | SNSを介して，CloudWatchにアクセスするためのロールを設定． |
| SNSトピック     | CloudWatchへのアクセス時経由する，SNSトピックを設定．     |



### CloudTrail

#### ・CloudTrailとは

IAMユーザによる操作や，ロールのアタッチの履歴を記録し，ログファイルとしてS3に転送する．CloudWatchと連携することもできる．

![CloudTrailとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudTrailとは.jpeg)



### CloudWatch

#### ・名前空間，メトリクス，ディメンション

![名前空間，メトリクス，ディメンション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/名前空間，メトリクス，ディメンション.png)


#### ・コマンド

```bash
# CloudWatchの状態を変更する．
aws cloudwatch set-alarm-state --alarm-name "Alarm名" --state-value ALARM --state-reason "アラーム文言"
```

#### ・CloudWatchLogsエージェント（CloudWatchエージェントではない）

**＊実装例＊**

confファイルを，EC2内の```etc```ディレクトリ下に設置する．

```
#############################
# /var/awslogs/awscli.conf
#############################

[plugins]
cwlogs = cwlogs
[default]
region = ap-northeast-1
```

OS，ミドルウェア，アプリケーション，の各層でログを収集するのがよい．

```
#############################
# /var/awslogs/awslogs.conf
#############################

# ------------------------------------------
# CentOS CloudWatch Logs
# ------------------------------------------
[/var/log/messages]

# タイムスタンプ（例）May 14 08:10:00
datetime_format = %b %d %H:%M:%S

# 収集したいログファイル．ここでは，CentOSのログを指定．
file = /var/log/messages

# 要勉強
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file

# AWS上で管理するロググループ名
log_group_name = /var/log/messages

# ------------------------------------------
# Nginx CloudWatch Logs
# ------------------------------------------


# ------------------------------------------
# Application CloudWatch Logs
# ------------------------------------------

```

以下のコマンドで起動する．

```bash
# CloudWatchエージェントの再起動
$ service awslogs stop
$ service awslogs start

# もしくは
# NOTE: restartだとCloudWatchに反映されない時がある．
$ service awslogs restart
```



####  ・CloudWatch Logsとは

クラウドログサーバとして働く．AWSの各種サービスで生成されたログファイルを収集できる．

#### ・CloudWatch Events

イベントやスケジュールを検知し，指定したアクションを行う．

| イベント例                | スケジュール例       |      | アクション例              |
| ------------------------- | -------------------- | ---- | ------------------------- |
| APIのコール               | Cron形式での日時指定 | ⇒    | Lambdaによる関数の実行    |
| AWSコンソールへのログイン |                      | ⇒    | SQSによるメッセージの格納 |
| インスタンスの状態変化    |                      | ⇒    | SNSによるメール通知       |
| ...                       | ...                  | ⇒    | ...                       |



## 08. 開発者用ツール

### CodeDeploy

#### ・CodeDeployとは

#### ・appspecファイル

デプロイの設定を行う．

```yaml
version: 0.0

Resources:
  - TargetService:
      # 使用するサービス
      Type: AWS::ECS::Service
      Properties:
        # 使用するタスク定義．<TASK_DEFINITION> とすると，自動補完してくれる．
        TaskDefinition: "<TASK_DEFINITION>"
        # 使用するロードバランサー
        LoadBalancerInfo:
          ContainerName: "xxx-container"
          ContainerPort: "80"
```

#### ・ライフサイクルイベント




## 09. カスタマーエンゲージメント

### SES：Simple Email Service

![SESとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SESとは.png)

#### ・SESとは

クラウドメールサーバとして働く．メール受信をトリガーとして，アクションを実行できる．

| 設定項目           | 意味                                                         |
| ------------------ | ------------------------------------------------------------ |
| Domain             | SESのドメイン名を設定．<br>※ 設定したドメイン名には，「```10 inbound-smtp.us-east-1.amazonaws.com```」というMXレコードタイプの値が紐づく． |
| Email Addresses    | 送信先として認証するメールアドレスを設定．設定するとAWSからメールが届くので，指定されたリンクをクリックする．<br>※ Sandboxモードの時だけ機能する． |
| Sending Statistics | SESで収集されたデータをメトリクスで確認できる．<br>※ ```Request Increased Sending Limits```のリンクにて，Sandboxモードの解除を申請できる． |
| SMTP Settings      | SMTP-AUTHの接続情報を確認できる．                            |
| Rule Sets          | メールの受信したトリガーとして実行するアクションを設定できる． |
| IP Address Filters |                                                              |

#### ・Sandboxモードの解除

SESはデフォルトではSandboxモードになっている．Sandboxモードでは以下の制限がかかっており．サポートセンターに解除申請が必要である．

| 制限     | 内容                                          |
| -------- | --------------------------------------------- |
| 送信制限 | SESで認証したメールアドレスのみに送信できる． |
| 受信制限 | 1日に200メールのみ受信できる．                |

#### ・SMTP認証

送信元となるアプリケーションとSESの間で，SMTP認証を行うには，認証情報を持つIAMユーザを作成する必要がある．SMTP認証の仕組みについては，別ノートを参照せよ．

#### ・Rule Sets

| 設定項目 | 意味                                                         |
| -------- | ------------------------------------------------------------ |
| Recipiet | 受信したメールアドレスで，何の宛先の時にこれを許可するかを設定． |
| Actions  | 受信を許可した後に，これをトリガーとして実行するアクションを設定． |



## 10. ビジネスアプリケーション

### WorkMail

#### ・WorkMailとは

AWSから提供されている．Gmail，サンダーバード，Yahooメールなどと同類のアプリケーション．

| 設定項目              | 意味                                                         |
| --------------------- | ------------------------------------------------------------ |
| Users                 | WorkMailで管理するユーザを設定．                             |
| Domains               | ユーザに割り当てるメールアドレスのドメイン名を設定．<br>※ ```@{組織名}.awsapps.com```をドメイン名としてもらえる．ドメイン名の検証が完了した独自ドメイン名を設定することもできる． |
| Access Controle rules | 受信するメール，受信を遮断するメール，の条件を設定．         |



## 11. 暗号化とPKI

### Certificate Manager

#### ・Certificate Managerとは

認証局であるATSによって認証されたSSLサーバ証明書を管理できるサービス．

| 自社の中間認証局名         | ルート認証局名 |
| -------------------------- | -------------- |
| ATS：Amazon Trust Services | Starfield社    |

| 設定項目   | 意味                                   |
| ---------- | -------------------------------------- |
| ドメイン名 | 認証をリクエストするドメイン名を設定． |
| 検証の方法 | DNS検証かEmail検証かを設定．           |

#### ・セキュリティポリシー

許可するプロトコルを定義したルールこと．SSL/TLSプロトコルを許可しており，対応できるバージョンが異なるため，ブラウザがそのバージョンのSSL/TLSプロトコルを使用できるかを認識しておく必要がある．

|                      | Policy-2016-08 | Policy-TLS-1-1 | Policy-TLS-1-2 |
| -------------------- | :------------: | :------------: | :------------: |
| **Protocol-TLSv1**   |       〇       |       ✕        |       ✕        |
| **Protocol-TLSv1.1** |       〇       |       〇       |       ✕        |
| **Protocol-TLSv1.2** |       〇       |       〇       |       〇       |

#### ・DNS検証

CNAMEレコードランダムトークンを用いて，ドメイン名の所有者であることを証明する方法．ACMによって生成されたCNAMEレコードランダムトークンが提供されるので，これをRoute53に設定しておけば，ACMがこれを検証し，証明書を発行してくれる．

#### ・SSLサーバ証明書の種類

DNS検証またはEメール検証によって，ドメイン名の所有者であることが証明されると，発行される．証明書は，PKIによる公開鍵検証に用いられる．

| 証明書の種類         | 意味                                             |
| -------------------- | ------------------------------------------------ |
| ワイルドカード証明書 | 証明するドメイン名にワイルドカードを用いたもの． |

#### ・SSLサーバ証明書の設置場所パターン

AWSの使用上，ACM証明書を設置できないサービスに対しては，外部の証明書を手に入れて設置する．HTTPSによるSSLプロトコルを受け付けるネットワークの最終地点のことを，SSLターミネーションという．

| パターン<br>（Route53には必ず設置）          | SSLターミネーション<br>（HTTPSの最終地点） |
| -------------------------------------------- | ------------------------------------------ |
| Route53 → ALB(+ACM証明書) → EC2              | ALB                                        |
| Route53 → ALB(+ACM証明書) → EC2(+外部証明書) | EC2                                        |
| Route53 → NLB → EC2(+外部証明書)             | EC2                                        |
| Route53 → EC2(+外部証明書)                   | EC2                                        |
| Route53 → CloudFront(+ACM証明書) → ALB → EC2 | CloudFront                                 |
| Route53 → CloudFront(+ACM証明書) → EC2       | CloudFront                                 |
| Route53 → CloudFront(+ACM証明書) → S3        | CloudFront                                 |
| Route53 → Lightsail(+ACM証明書)              | Lightsail                                  |



## 12. セキュリティ｜IAM：Identify and Access Management

### IAMポリシー，IAMステートメント

#### ・IAMポリシーとは

実行権限のあるアクションが定義されたIAMステートメントのセットを持つ，JSON型オブジェクトデータのこと．

#### ・IAMポリシーの種類

| IAMポリシーの種類    | 意味 |
| -------------------- | ---- |
| アクセス許可ポリシー |      |
| 信頼関係ポリシー     |      |

**＊具体例＊**

以下に，EC2の読み出しのみ権限（```AmazonEC2ReadOnlyAccess```）を付与できるポリシーを示す．このIAMポリシーには，他のAWSサービスに対する権限も含まれている．

```yaml
# AmazonEC2ReadOnlyAccess
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
```

####  ・IAMステートメントとは

実行権限のあるアクションを定義した，JSON型オブジェクトデータのこと．

**＊具体例＊**

以下に，```AmazonEC2ReadOnlyAccess```に含まれるIAMステートメントの一つを示す．```elasticloadbalancing:XXX```を用いて，ELBに対する実行権限を定義できる．ここでは，```Describe```の文字から始まるアクションの権限が与えられている．

```yaml
{
# ~~~ 省略 ~~~
    "Statement": [    
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
    ]
# ~~~ 省略 ~~~
}
```

以下に，```Describe```の文字から始まるアクションをいくつか示す．


| アクション名                | 権限                                                         | アクセスレベル |
| --------------------------- | ------------------------------------------------------------ | -------------- |
| ```DescribeLoadBalancers``` | 指定されたロードバランサーの説明を表示できる．               | 読み出し       |
| ```DescribeRules```         | 指定されたルール，または指定されたリスナーのルールの説明を表示できる． | 読み出し       |
| ```DescribeTargetGroups```  | 指定されたターゲットグループまたはすべてのターゲットグループの説明を表示できる． | 読み出し       |

#### ・ポリシータイプ

| ポリシータイプ      | 意味                               |
| ------------------- | ---------------------------------- |
| ユーザによる管理    | ユーザが新しく作成したポリシー     |
| AWSによる管理       | デフォルトで作成されているポリシー |
| AWS管理のジョブ機能 |                                    |



### IAMポリシーを付与できる対象

#### ・IAMユーザに対する付与

![IAMユーザにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMユーザにポリシーを付与.jpeg)

#### ・IAMグループに対する付与

![IAMグループにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMグループにポリシーを付与.jpeg)

#### ・IAMロールに対する付与

![IAMロールにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMロールにポリシーを付与.jpeg)



### ルートユーザ，IAMユーザ

#### ・ルートユーザとは

全ての権限をもったアカウントのこと．

#### ・IAMユーザとは

特定の権限をもったアカウントのこと．

### IAMグループ

#### ・IAMグループとは

IAMユーザをグループ化したもの．IAMグループごとにIAMロールを付与すれば，IAMユーザのIAMロールを管理しやすくなる．

![グループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループ.png)

### IAMロール

#### ・IAMロールとは

IAMポリシーのセットを持つ

#### ・IAMロールの種類

| IAMロールの種類                  | 意味                                        |
| -------------------------------- | ------------------------------------------- |
| サービスロール                   | AWSのサービスに対して付与するためのロール． |
| クロスアカウントのアクセスロール |                                             |
| プロバイダのアクセスロール       |                                             |

#### ・IAMロールを付与する方法

まず，IAMグループに対して，IAMロールを紐づける．そのIAMグループに対して，IAMロールを付与したいIAMユーザを追加していく．

![グループに所属するユーザにロールを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループに所属するユーザにロールを付与.png)


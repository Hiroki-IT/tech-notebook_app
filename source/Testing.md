# テストの手法

## 01-01. テスト全体の手順

1. テスティングフレームワークによる静的解析を行う．
2. テスティングフレームワークによるUnitテストとFunctionalテストを行う．
2. テスト仕様書に基づくUnitテスト，Integrationテスト，User Acceptanceテストを行う．
3. グラフによるテストの可視化



## 02-01. PHPStanによる静的解析

### CIツールによるPHPStanの自動実行



## 03-01.  PHPUnitによるUnit／Functionalテストの要素

### Phakeによるモックとスタブの定義

テストコードにおいては，クラスの一部または全体を，処理を持たないもの（モック）に置き換える．

#### ・```mock()```

クラス名（名前空間）を元に，モックを生成できる．

```PHP
// クラス名（名前空間）を引数として渡す．
$mock = Phake::mock(Example::class)
```

#### ・```verify()```

メソッドがn回以上コールされたかを検証できる．

```PHP
// モックを生成．
$mock = Phake::mock(Example::class)

// モックに対してスタブを作成．
\Phake::when($mock)
    ->method($param)
    ->thenReturn([]);

// メソッドがn回コールされたかを検証．
Phake::verify($mock, Phake::times($n))->method($param)
```



### テストの事前準備と後片付け

#### ・```setUp()```

モックなどを事前に準備するために用いられる．

```PHP
class ExampleUseCaseTest extends \PHPUnit_Framework_TestCase
{
    protected $exampleService
    
    protected function setUp()
    {
        $this->exampleService = Phake::mock(ExampleService::class);
    }
}
```

#### ・```tearDown()```

テスト時に，グローバル変数やDIコンテナにデータを格納する場合，後のテストでもそのデータが誤って使用されてしまう可能性がある．そのために，テストの後片付けを行う．

```PHP
class ExampleUseCaseTest extends \PHPUnit_Framework_TestCase
{
    protected $container
    
    // メソッドの中で，最初に自動実行される．
    protected function setUp()
    {
        // DIコンテナにデータを格納する．
        $this->container['option']
    }
    
    // メソッドの中で，最後に自動実行される．
    protected function tearDown()
    {
        // 次に，DIコンテナにデータを格納する．
        $this->container = null;
    }
}
```



### 実際値と期待値の比較

https://phpunit.readthedocs.io/ja/latest/assertions.html



## 03-02. PHPUnitによるUnit／Functionalテストの実装まとめ

### Unitテスト

クラスやメソッドが単体で処理が正しく動作するかをテストする．

```PHP
// ここに実装例
```



### Functionalテスト

リクエストされるControllerに対してリクエストを行い，レスポンスが行われるかをテストする．レスポンス期待値のデータセットを```@dataProvider```に定義し，データベースからレスポンスされた実際の値と一致するかでテストを行う．

#### ・レスポンスが成功するか（ステータスコードが```200```番台か）だけに焦点を当てる場合

```PHP
// ここに実装例
```

#### ・上記＋レスポンスされたデータが期待値と同じかにも焦点を当てる場合

この場合，データベースにテストデータを作成する必要がある．

```PHP
// ここに実装例
```



### CIツールによるPHPUnitの自動実行

1. テストクラスを実装したうえで，新機能を設計実装する．

2. リポジトリへPushすると，CIツールがGituHubからブランチの状態を取得する．

3. CIツールによって，テストサーバの仮想化，インタプリタ，PHPUnitなどが自動実行される．

4. 結果を通知することも可能．

**【自動化ツールアプリ例】**

Circle CI，Jenkins

![継続的インテグレーション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/継続的インテグレーション.png)



## 03-03. テスト仕様書に基づくUnit テスト

PHPUnitでのUnitテストとは意味合いが異なるので注意．

### ブラックボックステスト

実装内容は気にせず，入力に対して，適切な出力が行われているかをテストする．

![p492-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p492-1.jpg)



### ホワイトボックステスト

実装内容が適切かを確認しながら，入力に対して，適切な出力が行われているかをテストする．ホワイトボックステストには，以下の方法がある．何をテストするかに着目すれば，思い出しやすい．

![p492-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p492-2.jpg)

**【実装例】**

```
if (A = 1 && B = 1) {
　return X;
}
```

上記のif文におけるテストとして，以下の４つの方法が考えられる．基本的には，複数条件網羅が用いられる．

#### ・命令網羅（『全ての処理』が実行されるかをテスト）

![p494-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p494-1.png)

全ての命令が実行されるかをテスト（ここでは処理は1つ）．

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．

#### ・判定条件網羅（『全ての判定』が実行されるかをテスト）

![p494-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p494-2.png)

全ての判定が実行されるかをテスト（ここでは判定は```TRUE```か```FALSE```の2つ）．

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．

#### ・条件網羅（『各条件の取り得る全ての値』が実行されるかをテスト）

![p494-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p494-3.png)

各条件が，取り得る全ての値で実行されるかをテスト（ここでは，Aが0と1，Bが0と1になる組み合わせなので，2つ）

すなわち…

A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．

または，次の組み合わせでもよい．

A = 1，B = 1 の時，```return X``` が実行されること．
A = 0，B = 0 の時，```return X``` が実行されないこと．

#### ・複数条件網羅（『各条件が取り得る全ての値』，かつ『全ての組み合わせ』が実行されるかをテスト）

![p494-4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p494-4.png)

各条件が，取り得る全ての値で，かつ全ての組み合わせが実行されるかをテスト（ここでは4つ）

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．
A = 0，B = 0 の時，```return X``` が実行されないこと．

 

## 03-04. テスト仕様書に基づくIntegration テスト（結合テスト）

単体テストの次に行うテスト．複数のモジュールを繋げ，モジュール間のインターフェイスが適切に動いているかを検証．

![結合テスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p491-1.jpg)

### Top-down テスト

上位のモジュールから下位のモジュールに向かって，結合テストを行う場合，下位には Stub と呼ばれるダミーモジュールを作成する．

![トップダウンテスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/トップダウンテスト.jpg)



### Bottom-up テスト

下位のモジュールから上位のモジュールに向かって，結合テストを行う場合，上位には Driver と呼ばれるダミーモジュールを作成する．

![ボトムアップテスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ボトムアップテスト.jpg)



### Scenario テスト

実際の業務フローを参考にし，ユーザが操作する順にテストを行う．




## 04-01. テスト仕様書に基づくUser Acceptance テスト（総合テスト）

![p491-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p491-2.jpg)

結合テストの次に行うテスト．システム全体が適切に動いているかをテストする．



### Functional テスト

機能要件を満たせているかをテストする．PHPUnitでのFunctionalテストとは意味合いが異なるので注意．



### Perfomance テスト

![スループットとレスポンスタイム](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/スループットとレスポンスタイム.png)

非機能要件の一つである性能要件（スループット，レスポンスタイム，メモリのリソース量）を満たせているかをテストする．性能を評価する時，アクセス数を段階的に増加させて数回の性能テストを実施し，その結果を組み合わせてグラフ化する．例えば，性能目標を，⁠スループット：50件／秒⁠，⁠レスポンスタイム：3秒以内とする．今回のグラフでは，スループット：50件／秒の時のレスポンスタイムは2秒である．したがって，このシステムは性能目標を達成していることがわかる．

#### ・Throughput

  単位時間当たりに処理できる仕事数のこと．

#### ・Response time

  コンピュータが処理を終えるまでに要する時間のこと．



### Stress テスト



## 04-02. Regression テスト（退行テスト）

システムを変更した後，他のプログラムに悪影響を与えていないかを検証．

![p496](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p496.jpg)



## 05-01. グラフによるテストの可視化

### バグ管理図

プロジェクトの時，残存テスト数と不良摘出数（バグ発見数）を縦軸にとり，時間を横軸にとることで，バグ管理図を作成する．それぞれの曲線の状態から，プロジェクトの進捗状況を読み取ることができる．

![品質管理図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/品質管理図.jpg)

不良摘出実績線（信頼度成長曲線）は，プログラムの品質の状態を表し，S字型でないものはプログラムの品質が良くないことを表す．

![信頼度成長曲線の悪い例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/信頼度成長曲線の悪い例.jpg)



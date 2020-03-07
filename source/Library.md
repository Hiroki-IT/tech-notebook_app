

# ライブラリ

## 01-01. Doctrineライブラリ

### :pushpin: ```createQueryBuilder()```

データベース接続に関わる```getConnection()```を起点として，返り値から繰り返しメソッドを取得し，```fetchAll()```で，テーブルのクエリ名をキーとした連想配列が返される．

- **プレースホルダー**

プリペアードステートメントともいう．SQL中にパラメータを設定し，値をパラメータに渡した上で，SQLとして発行する方法．処理速度が速い．また，パラメータに誤ってSQLが渡されても，これを実行できなくなるため，SQLインジェクションの対策にもなる

**【実装例】**

```PHP
use Doctrine\DBAL\Connection;


class dogToyQuey(Value $toyType): Array
{
  // QueryBuilderインスタンスを作成する
  $queryBuilder = $this->createQueryBuilder();

  // SELECTを設定する
  $queryBuilder->select([
                  'dog_toy.type AS dog_toy_type',
                  'dog_toy.name AS dog_toy_name',
                  'dog_toy.number AS number',
                  'dog_toy.price AS dog_toy_price',
                  'dog_toy.color_value AS color_value'
                  ])

                  // FROMを設定する．
                  ->from('mst_dog_toy', 'dog_toy')

                  // WHEREを設定する．この時，値はプレースホルダーとしておく．
                  ->where('dog_toy.type = :type'))

                  // プレースホルダーに値を設定する．ここでは，引数で渡す『$toyType』とする．
                  ->setParameter('type', $toyType);


  // データベースから『$toyType』に相当するレコードを取得する．
  return $queryBuilder->getConnection()

                      // 設定したSQLとプレースホルダーを取得する．
                      ->executeQuery($queryBuilder->getSQL(),
                                      $queryBuilder->getParameters(),
                      )
    
                      // レコードを取得する．
                      ->fetchAll();

}
```





## 02-01. Carbonライブラリ

### :pushpin: Date型

厳密にはデータ型ではないが，便宜上，データ型とする．タイムスタンプとは，協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの．

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日時                 | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |



### :pushpin: ```instance()``` 

DateTimeインスタンスを引数として，Carbonインスタンスを作成する．

```PHP
$datetime = new \DateTime('2019-07-07 19:07:07');
$carbon = Carbon::instance($datetime);

echo $carbon;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```create()```

日時の文字列からCarbonインスタンスを作成する．

```PHP
$carbon = Carbon::create(2019, 07, 07, 19, 07, 07);

echo $carbon;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```createFromXXX()```

指定の文字列から，Carbonインスタンスを作成する．

```PHP
// 日時数字から，Carbonインスタンスを作成する．
$carbonFromeDate = Carbon::createFromDate(2019, 07, 07);

// 時間数字から，Carbonインスタンスを作成する．
$carbonFromTime = Carbon::createFromTime(19, 07, 07);

// 日付，時間，日時フォーマットから，Carbonインスタンスを作成する．
// 第一引数でフォーマットを指定する必要がある．
$carbonFromFormat = Carbon::createFromFormat('Y-m-d H:m:s', '2019-07-07 19:07:07');

// タイムスタンプフォーマットから，Carbonインスタンスを作成する．
$carbonFromTimestamp = Carbon::createFromTimestamp(1562494027);


echo $carbonFromeDate;
// 出力結果  
2019-07-07
  
echo $carbonFromTime;
// 出力結果  
19:07:07

echo $carbonFromFormat;
// 出力結果    
2019-07-07 19:07:07

echo $carbonFromTimestamp;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```parse()```

日付，時間，日時フォーマットから，Carbonインスタンスを作成する．

```PHP
// createFromFormat()とは異なり，フォーマットを指定する必要がない．
$carbon = Carbon::parse('2019-07-07 19:07:07')
```



## 03-01. Pinqライブラリ

SQLのSELECTやWHEREといった単語を用いて，```foreach()```のように，コレクションデータを走査できるライブラリ．



## 04-01. Guzzleライブラリ

通常、リクエストメッセージの送受信は，クライアントからサーバに対して，Postmanやcurl関数などを使用して行う。しかし、Guzzleライブラリを使えば、サーバから他サーバに対して，リクエストメッセージの送受信ができる。

### :pushpin: リクエストメッセージをGET送信

```PHP
$client = new Client();

// GET送信
$response = $client->request("GET", {アクセスしたいURL});
```

### :pushpin: レスポンスメッセージからボディを取得

```PHP
$client = new Client();

// POST送信
$response = $client->request("POST", {アクセスしたいURL});

// レスポンスメッセージからボディのみを取得
$body = json_decode($response->getBody(), true);
```



## 05-01. Respect/Validationライブラリ

リクエストされたデータが正しいかを，サーバサイド側で検証する．フロントエンドからリクエストされるデータに関しては，JavaScriptとPHPの両方によるバリデーションが必要である．

# データ構造

## 01. データ構造の実装方法

ハードウェアが処理を行う時に，データの集合を効率的に扱うためのデータ格納形式をデータ構造という．データ構造のPHPによる実装方法を以下に示す．

### Array型

同じデータ型のデータを並べたデータ格納様式のこと．

#### ・インデックス配列

番号キーごとに値が格納されたArray型のこと．

```shell
Array
(
  [0] => A
  [1] => B
  [2] => C
)
```

#### ・多次元配列

配列の中に配列をもつArray型のこと．配列の入れ子構造が２段の場合，『二次元配列』と呼ぶ．

```shell
( 
  [0] => Array
         (
            [0] => リンゴ
            [1] => イチゴ
            [2] => トマト
         )

  [1] => Array
         (
            [0] => メロン
            [1] => キュウリ
            [2] => ピーマン
         )
)
```

#### ・連想配列

キー名（赤，緑，黄，果物，野菜）ごとに値が格納されたArray型のこと．下の例は，二次元配列かつ連想配列である．

```shell
Array
(
    [赤] => Array
        (
            [果物] => リンゴ
            [果物] => イチゴ
            [野菜] => トマト
        )

    [緑] => Array
        (
            [果物] => メロン
            [野菜] => キュウリ
            [野菜] => ピーマン
        )
)
```

<br>

### LinkedList型

PHPで用いることはあまりないデータ格納様式．詳しくは，JavaにおけるLinkedList型を参照せよ．

#### ・PHPの```list```メソッドとは何なのか

PHPの```list```メソッドは，List型とは意味合いが異なる．配列の要素一つ一つを変数に格納したい場合，List型を使わなければ，冗長ではあるが，以下のように実装する必要がある．

**＊実装例＊**

```php
<?php
    
$array = array("あ", "い", "う");
$a = $array[0];
$i = $array[1];
$u = $array[2];

echo $a.$i.$u; // あいう
```

しかし，以下の様に，```list```メソッドを使うことによって，複数の変数への格納を一行で実装することができる．

**＊実装例＊**

```php
<?php
    
list($a, $i, $u) = array("あ", "い", "う");

echo $a.$i.$u; // あいう
```

<br>

### Queue型

![Queue1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Queue1.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

 

![Queue2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Queue2.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

 

![Queue3](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Queue3.gif)

PHPでは，```array_push```メソッドと```array_shift```メソッドを組み合わせることで実装できる．

**＊実装例＊**

```php
<?php
$array = array("Blue", "Green");

// 引数を，配列の最後に，要素として追加する．
array_push($array, "Red");
print_r($array);

// 出力結果

//	Array
//	(
//		[0] => Blue
//		[1] => Green
//		[2] => Red
//	)

// 配列の最初の要素を取り出す．
$theFirst= array_shift($array);
print_r($array);

// 出力結果

//	Array
//	(
//    [0] => Green
//    [1] => Red
//	)

// 取り出された値の確認
echo $theFirst; // Blue
```

#### ・メッセージQueue

送信側の好きなタイミングでファイル（メッセージ）をメッセージQueueに追加できる．また，受信側の好きなタイミングでメッセージを取り出すことができる．

![メッセージキュー](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/メッセージキュー.jpg)

<br>

### Stack型

PHPでは，```array_push```メソッドと```array_pop```メソッドで実装可能．

![Stack1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Stack1.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

 

![Stack2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Stack2.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

 

![Stack3](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Stack3.gif)

<br>

### Tree型

#### ・二分探索木

  各ノードにデータが格納されている．

![二分探索木](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/二分探索木1.gif)

#### ・ヒープ

  Priority Queueを実現するときに用いられる．各ノードにデータが格納されている．

![ヒープ1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ヒープ1.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

![ヒープ1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ヒープ2.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

![ヒープ2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ヒープ3.gif)

![矢印_80x82](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/矢印_80x82.jpg)

![. ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ヒープ4.gif)

<br>

## 01-02. Javaにおけるデータ構造の実装方法

データ構造のJavaによる実装方法を以下に示す．

### Array型

#### ・ArrayList

ArrayListクラスによって実装されるArray型．PHPのインデックス配列に相当する．

#### ・HashMap

HashMapクラスによって実装されるArray型．PHPの連想配列に相当する．

<br>

### LinkedList型

値をポインタによって順序通り並べたデータ格納形式のこと．

#### ・単方向List

![p555-1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p555-1.gif)

#### ・双方向List

![p555-2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p555-2.gif)

#### ・循環List

![p555-3](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p555-3.gif)

<br>

### Queue型

<br>

### Stack型

<br>

### Tree型

<br>

## 02. データ型

### スカラー型

#### ・int

#### ・float

#### ・string

#### ・boolean

|   T／F    | データの種類 | 説明                     |
| :-------: | ------------ | ------------------------ |
| **FALSE** | ```$var =``` | 何も格納されていない変数 |
|           | ```False```  | 文字としてのFalse        |
|           | ```0```      | 数字、文字列             |
|           | ```""```     | 空文字                   |
|           | array()      | 要素数が0個の配列        |
|           | NULL         | NULL値                   |
| **TRUE**  | 上記以外の値 |                          |

<br>

### 複合型


#### ・array

#### ・object

```php
<?php

class A 
{
    private $name = "Hiroki";
    
    public function HelloWorld()
    {
        return sprintf(
            "%s, %s",
            $this->name,
            "Hello World!"
            );
    }
}

$a = new A;

var_dump($a);

// object(A)#1 (1) {
//  ["name":"A":private]=>
//  string(6) "Hiroki"
//}

print_r($a);

// A Object
// (
//     [name:A:private] => Hiroki
// )
```

<br>

### その他のデータ型

#### ・null

#### ・date

厳密にはデータ型ではないが，便宜上，データ型とする．タイムスタンプとは，協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの．

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日付と時間           | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |

<br>

### キャスト演算子

#### ・```(string)```

```php
<?php
    
$var = 10; // $varはInt型．

// キャスト演算子でデータ型を変換
$var = (string) $var; // $varはString型
```

#### ・```(int)```

```php
<?php
    
$var = "1";

// Int型
$var = (int) $var;

// 1
```

#### ・```(bool)```

```php
<?php
    
$var = 1;

// Boolean型
$var = (bool) $var;

// true
```

#### ・```(float)```

```php
<?php
    
$var = "1.0";

// Float型
$var = (float) $var;

// 1.0
```

#### ・```(array)```

```php
<?php
    
// Array型
$var = (array) $var;
```

#### ・```(object)```

```php
<?php
    
// Object型
$var = (object) $var;
```

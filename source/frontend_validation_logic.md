# フロントエンド側の検証ロジック

## 01. 検証

### 検証ロジックの比較

〇：```TRUE```

✕：```FALSE```

|                     | ```typeof $var``` | ```if($var)``` |
| :------------------ | :---------------: | :------------: |
| **```null```**      |   ```object```    |       ✕        |
| **```0```**         |   ```number```    |       ✕        |
| **```1```**         |   ```number```    |     **〇**     |
| **```""```**        |   ```string```    |       ✕        |
| **```"あ"```**      |   ```string```    |     **〇**     |
| **```NaN```**       |   ```number```    |       ✕        |
| **```undefined```** |  ```undefined```  |       ✕        |

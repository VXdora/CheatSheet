# pandas

python で csv を扱いやすくするライブラリ

## ライブラリのインポート

```
import pandas as pd
```

## データ読み込み

- 以下で読み込み

  ```
  data = pd.read_csv('sample.csv')
  ```

- ヘッダ行が無いとき

  ```
  data = pd.read_csv('sample.csv', header=None)
  ```

- 任意の列名を指定

  ```
  data = pd.read_csv('sample.csv', names=['col1', 'col2', 'col3'])
  ```

- index(見出し列)があるとき

  ```
  data = pd.read_csv('sample.csv', index_col=0)
  ```

- 指定の行番号をスキップ

  ```
  data = pd.read_csv('sample.csv', skiprows=[0, 2])
  data = pd.read_csv('sample.csv', skiprows=lambda x: x not in [0, 2])

  # 末尾のn行スキップ
  data = pd.read_csv('sample.csv', skipfooter=1)

  # 先頭のn行のみ読み込み
  data = pd.read_csv('sample.csv', nrows=2)
  ```

- 空のデータフレームの作成
  ```
  df = pd.DataFrame()
  ```

## データ書き込み

```
data.to_csv('foo.csv', index=False)
```

## データ件数の確認

```
len(data)
```

## 特定列の取り出し

- 先頭の項目を取り出す
- デフォルトは 5 行

  ```
  d = data.head()

  # 先頭3行取り出し
  d = data.head(3)
  ```

- 末尾の項目を取り出す
- デフォルトは 5 行

  ```
  d = data.tail()

  # 末尾3行取り出し
  d = data.tail(3)
  ```

- 行番号指定
  ```
  d = data[3:6]
  ```

## データフレーム結合

- データフレームの結合

  ```
  joined_data = pd.concat([data1, data2])
  ```

  data は`pandas.core.frame.DataFrame`

  非破壊のため結果は戻り値として戻る

## データの除外

```
data.loc[data['index'] != 100]
```

上記の例では，data から`index`が 100 のデータを除外

## 統計情報

### 欠損値(null)の確認

```
data.isnull()
```

欠損値を各データごとに確認

### 合計を計算

- 列ごとに計算
  ```
  data.sum()
  ```
- 行ごとに計算
  ```
  data.sum(axis='columns')
  ```
- NaN 値を無視しない
  ```
  data.sum(skipna=False)
  ```
  このとき，欠損値(NaN)が 1 つでも含まれていると結果は NaN になる

### 列ごとの個数や合計値などの統計を取得

```
data.describe()
```

なお，取得できるデータは以下

- count: データの個数
- mean: 平均
- std: 標準偏差
- min: 最小値
- 25%: 1/4 分位数
- 50%: 中央値
- 75%: 3/4 分位数

agg で指定できる

```
data.agg(['sum', 'mean'])
```

## テーブル同士の結合

```
pd.merge(data1, data2, on='idx', how='left')
```

上記の例は`data1`と`data2`の共通のインデックスである`idx`で左結合．
`how`は`inner`, `left`, `right`, `outer`, `coss`から選べる．

SQL の`JOIN`と同様？

## 型の変換

```Python
# strへの変換
data['index'] = data['index'].astype(str)

# datetimeへの変換
data['index'] = pd.to_datetime(data['index']).dt.strftime('%Y%m')
```

## 集計

### groupby

```
data.groupby('index')
```

- `index`で集計
- 複数指定時は引数として`['index1', 'index2']`のように渡す

### ピボットテーブル

```Python
pd.pivot_table(
  data,                   # 集計対象データ
  index='row_name',       # 行名
  columns='column_name',  # 列名
  values='index',         # 集計を行うインデックス
  aggfunc='mean'          # 集計方法（mean: 平均値）
)
```

- aggfunc にセットできるのは，一次元配列に対してスカラー値を返す関数
  - len など
  - `def foo(args: list) -> int:`のような関数

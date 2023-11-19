# 文字列操作

## 文字列の定義
文字列の定義は`"`か`'`を使用．

`"`を使用した場合は文字列内に変数を埋め込める．

```PS
$x = 10
Write-Host "number..${x}"
```

## 文字列の結合
`+`を使用することで文字列を連結できる．
また，`[string]::Join`を使用することで，区切り文字をつけて連結できる．

```PS
$a = "abc"
$b = "def"
Write-Host ($a + $b)

$arr = "foo", "bar", "hoge"
Write-Host ([string]::Join("-", $arr))
```

## その他

| メソッド | 説明 | コマンド例 | 出力例 |
| -- | -- | -- | -- |
| str.Substring(i,d) | 文字列strの位置iからd文字分だけ文字を切り出す | "abcde".Substring(2,2) | "cd" |
| str.Replace(x,y) | 文字列strに含まれる文字列xをyに置き換える | "My name is XXXX".Replace("XXXX", "POCHI") | 	"My name is POCHI" |
| str.IndexOf(x) | 文字列strに含まれるxの位置を返す。ない場合は-1 | "abcdefg".IndexOf("cde") | 2 |
| str.Split(x) | 文字列strをxで分割した配列を返す | "My name is XXXX".Split( ) | 配列["My","name","is","XXXX"] |
| str.ToUpper() | 文字列strに含まれる小文字を大文字に変換 | "My name is XXXX".ToUpper() | "MY NAME IS XXXX" |
| str.ToLower() | 文字列strに含まれる大文字を小文字に変換 | "My name is XXXX".ToLower() | "my name is xxxx" |
| str.Trim() | 文字列strの前後の空白を削除する | " abc ".Trim() | "abc" |


## パス連結
`Join-Path -Path parent_path -ChildPath path`
```PS
$x = Join-Path -Path "D:\Powershell\data" -ChildPath "sample1.py"
$y = "D:\Powershell\data" + "sample1.py"
Write-Host $x   # D:\Powershell\data\sample1.py
Write-Host $y   # D:\Powershell\datasample1.py
```

## パスの抽出
```PS
$path = "D:\Powershell\data"

Split-Path -Path $path -Qualifier       # D:
Split-Path -Path $path -NoQualifier     # powershell\data
Split-Path -Path $path -Parent          # D:\powershell
Split-Path -Path $path -Leaf            # data
```
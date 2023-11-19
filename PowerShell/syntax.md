# PowerShell 基本文法

## 変数
変数は`$`をつけて使用．

`GetType()`を使用することで，変数の型を取得できる．


```PS
$a = 15       # 整数
$b = 0.5      # 小数
$c = "Hello"  # 文字列

Write-Host $a.GetType()     # System.Int32
Write-Host $b.GetType()     # System.Double
Write-Host $c.GetType()     # System.String
```

一般的なプロミング言語同様，変数同士の四則演算が可能．

```PS
Write-Host ($a * 4)
Write-Host ($b * 0.8)
```

なお，`文字列+x`は文字列同士の連結，`文字列*n`は文字列の繰り返しになる．


## 配列
配列の初期化はカンマ区切りで列挙．

連続した数値の場合は`..`を使用できる．

また，空の配列は`@()`を使用．

参照，代入は`[n]`を使う．

```PS
$s = "x", "y", "z"
$n = 1..10              # 1~10の配列
$e = @()                # 空の配列


# 要素の参照
Write-Host $n[3]

#要素の代入
$s[0] = "a"
```

### スライス
`,`区切りを使用すると複数個の要素を指定できる．
また，`..`を使用すると，連続で取得可．

```PS
$arr = 1..20
Write-Host $arr[1, 3, 5]        # 1, 3, 5番目の要素を取得
Write-Host $arr[1..5]           # 1番目から5番目までの要素を取得
```

### 要素の追加，配列の結合
`+演算子`で要素の追加，結合が可能．
```PS
$arr = 1..9
$arr += 10      # $arrは1~10
                # $arr = $arr + 10でもOK

$arr2 = 11..20
Write-Host ($arr + $arr2)   #要素の結合
```

### 要素の長さを取得
`.Length`を使用すると，配列の長さを取得できる．


## 条件分岐
条件分岐は`if ~ elseif ~ else`を使用．

比較演算子は，他のプログラミング言語と異なる．

| PS | 意味 | 他言語 |
| -- | -- | -- |
| -eq | 等しい | == |
| -ne | 等しくない | != |
| -gt | より大きい | > |
| -ge | 以上 | >= |
| -lt | より小さい | < |
| -le | 以下 | <= |

Ex.
```PS
$x = [int](Read-Host "数値を入力")
if ($x -gt 0) {
    Write-Host "この値は正です．"
}
else {
    Write-Host "この値は負です．"
}
```

### 論理演算子
| PS | 意味 | 他言語 |
| -- | -- | -- |
| A -and B | AかつB | A && B|
| A -or B | AまたはB | A \|\| B |
| -not A | Aでない | ~A |

### 特殊な条件判定
`$null`, `$true`, `$false`

### 文字列や配列が含まれるか
`Contains`を使用することで，含まれているか判定できる．

```PS
$arr = 1..10
$x = [int](Read-Host "Input Number...")
if ($a.Contains($x)) {
    Write-Host "Include"
}
```

## ループ
ループはforを使用．

```PS
for ($i = 0; $i -lt 10; $i++) {
    Write-Host $i
}
```

for文内では`break`，`continue`が使用できる．

### foreach
配列を回したいとき．

```PS
$arr = "foo", "bar", "hoge"
foreach ($s in $arr) {
    Write-Host $s
}
```

## 関数
```PS
function fn($arg1, $arg2, ...) {
    処理
    return ($a)     # 戻り値
}
```












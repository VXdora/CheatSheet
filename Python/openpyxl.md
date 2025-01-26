# openpyxl

python から Excel を操作するライブラリ

```Python
import openpyxl
```

## ワークブック操作

### ワークブックを開く(新規)

```Python
workbook = openpyxl.Workbook()
# 処理
workbook.close()
```

### ワークブックを開く(既存のファイルから)

```Python
workbook = openpyxl.load_workbook("ファイル名.xlsx")
# 処理
workbook.close()
```

### ワークブックを保存

```Python
workbook.save("ファイル名.xlsx")
```

## シート操作

### シート取得

```Python
sheet = workbook['シート名']
```

## セル操作

### セル参照

```Python
v = sheet.cell(1, 2).value
```

### セル代入

```Python
sheet.cell(1, 2).value = 'value'
```

### フォント変更

```Python
from openpyxl.styles import Font

sheet.cell(1, 2).font = Font(
    bold=True,          # 太字
    color='008080',     # 文字色
)
```

### 塗りつぶし

```Python
from openpyxl.styles import PatternFill

sheet.cell(1, 2).fill = PatternFill(
    patternType='solid',
    fgColor='008000',   # 背景色
)
```

## 列操作

### 列幅変更

```Python
# 英語での列指定
sheet.column_dimensions['A'].witdh = 20
```

## グラフ操作

### 折れ線グラフ生成

```Python
from openpyxl.chart import Reference, LineChart, Series

# グラフ対象範囲をセット
# 下記はA1～A23をグラフにする範囲
refy = Reference(sheet, min_col=1, min_row=1, max_col=1, max_row=23)

# 線を作成
# シリーズを線の数だけ追加
series = Series(refy, title="線1")

# 折れ線グラフの作成
chart = LineChart()
chart.title = "グラフタイトル"
chart.x_axis.title = "横軸の凡例"
chart.x_axis.title = "縦軸の凡例"
chart.height = 10   # グラフ領域の高さ
chart.width = 20    # グラフ領域の幅

# 線を追加
chart.series.append(series)

# セルA5を起点として，グラフを貼り付け
sheet.add_chart(chart, 'A5')
```

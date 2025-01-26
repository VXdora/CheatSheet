# ipywidgets

jupyter notebook 内でボタンやドロップダウンなどインタラクティブな操作ができる．

## ドロップダウン

```Python
from ipywidgets import Dropdown
from IPython.display import display, clear_output

# ドロップダウン変更時に実行する関数
# 設定された項目は"val['new']"で取得
def dropdown_changed_function(val):
    clear_output()
    display(dropdown)       # ドロップダウンの描画
    pick_data = data.loc[data['item'] == val['new']]
    display(pick_data.head())       # データの描画

# ドロップダウンの作成
# optionsにドロップダウンで選択する項目を入れる
dropdown = Dropdown(options=['item1', 'item2', 'item3'])
dropdown.observe(dropdown_changed_function, names='value')
display(dropdown)
```

## セレクトボックス

```Python
from ipywidgets import SelectMultiple
from IPython.display import display, clear_output

# ドロップダウン変更時に実行する関数
# 設定された項目は"val['new']"で取得
def select_changed_function(val):
    clear_output()
    display(select)       # ドロップダウンの描画

    pick_data = data.loc[data['item'] == val['new']]
    display(pick_data.head())       # データの描画

# ドロップダウンの作成
# optionsにドロップダウンで選択する項目を入れる
select = SelectMultiple(options=['item1', 'item2', 'item3'])
select.observe(select_changed_function, names='value')
display(select)
```

## スライドバー

```Python
from ipywidgets import IntSlider
from IPython.display import display, clear_output

# ドロップダウン変更時に実行する関数
# 設定された項目は"val['new']"で取得
def slider_changed_function(val):
    clear_output()
    display(slider)       # ドロップダウンの描画

    pick_data = data.loc[data['item'] == val['new']]
    display(pick_data.head())       # データの描画

# スライダーの作成
# valueは初期値，stepは刻み値
slider = IntSlider(value=50, min=0, max=100, step=10)
slider.observe(slider_changed_function, names='value')
display(slider)
```

## トグルボタン

```Python
from ipywidgets import ToggleButtons
from IPython.display import display, clear_output

# ドロップダウン変更時に実行する関数
# 設定された項目は"val['new']"で取得
def toggle_changed_function(val):
    clear_output()
    display(toggle)       # ドロップダウンの描画
    pick_data = data.loc[data['item'] == val['new']]
    display(pick_data.head())       # データの描画

# ドロップダウンの作成
# optionsにドロップダウンで選択する項目を入れる
toggle = ToggleButtons(options=['item1', 'item2', 'item3'])
toggle.observe(toggle_changed_function, names='value')
display(toggle)
```

## 日付指定

```Python
from ipywidgets import DatePicker
from IPython.display import display, clear_output
from datetime import datetime

# 日付型に変更
data.loc[:, 'date_data'] = pd.to_datetime(data['date_data']).dt.date

# ドロップダウン変更時に実行する関数
# 設定された項目は"val['new']"で取得
def date_changed_function(val):
    clear_output()
    display(date_picker)       # ドロップダウンの描画
    pick_data = data.loc[data['item'] == val['new']]
    display(pick_data.head())       # データの描画

# ドロップダウンの作成
# op_tionsにドロップダウンで選択する項目を入れる
date_picker = DatePicker(value=datetime.datetime(2000, 1, 1))
date_picker.observe(date_changed_function, names='value')
display(date_picker)
```

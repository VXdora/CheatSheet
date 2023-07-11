# CSS 使い方 初級編

最低限，これだけは覚えておきましょう．


## width

width は，要素の幅を指定します．
固定値は px，画面幅に応じて変更させたいなら%指定がおすすめ．

ex1. `width: 400px;`

ex2. `width: 40%;`

## height

height は，要素の高さを指定します．
固定値は px, 画面幅に応じて変更させたいなら vh 指定がおすすめ．
ただし，指定しなければ flex になるので，よほどのことがない限りは指定しないのが吉．

ex1. `height: 400px;`

ex2. `height: 100vh;`

## margin, padding

要素の余白を指定します．
margin は要素の外側の余白，padding は要素の内側の余白を指定します．

指定方法は，px と auto がおすすめ．

ex1. margin: auto;

ex2. padding: 5px;

なお，上下左右を指定して margin, padding する方法は，margin-top, padding-bottom, margin-left, padding-right を使いましょう．

## display

子要素を横並びにしたいときは，親要素に display: flex を使うのが吉．
table タグは割と自由がきかない．

ex1.

```HTML
<div style="display: flex;">
    <div class="contents"></div>
    <div class="contents"></div>
    <div class="contents"></div>
</div>
```

この例だと，スタイルはこのようになります．
```
+- div --------------------------------------------+
| +- contents ---+ +- contents --+ +- contents --+ |
| |              | |             | |             | |
| +--------------+ +-------------+ +-------------+ |
+--------------------------------------------------+
```

## flex-wrap

display: flex で指定した要素を回り込ませることができる．

flex-wrap: wrap; で指定．

## background-color

背景色の指定．

指定方法は，名前 or カラーコード．

ex1. background-color: red;

ex2. background-color: #0b5;

参考：[カラーコード](https://www.colordic.org/)

## color

文字色の変更．

色の指定方法は背景色の指定と同じ．

## font-size

フォントの大きさを変えられる．

指定方法は pt がおすすめ．

ex1. font-size: 15pt;


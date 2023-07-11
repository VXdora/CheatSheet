# CSS 使い方 中級編
これを覚えておくと，幅が広がる．

## position
position属性を指定すると，要素を好きな位置に設定することができる．
なお，位置を移動させるにはtop, left, right, bottom属性を使用する．

### static
`position: static`は特に何も指定しなかった時と同じ．

つまり，すべての要素のデフォルトはstatic

### relative
`pisition: relative`は初期位置はstaticと同じ．
そこから，topやleftで位置を変えられる．
要素分の隙間が空く．

### absolute
画面端からの指定．
要素分の隙間は空かない．

ex.
```CSS
/* div要素を画面端からx 15px, y5pxの場所に配置 */
div { position: absolute; top: 5px; left: 15px; }
```

### sticky
スクロールしてもくっついてくるやつ．


## border
要素の周りに線が引ける．

```CSS
/*  線で囲む  */
div { border: solid; }

/*  赤色の点線で囲む  */
div { border: dashed red; }

/*  細い線の二重線で囲む  */
div { border: thick double #32a1ce; }
```

線の種類は以下のようなものがある．
- none, hidden: なし，表示しない
- dotted
- dashed
- solid
- double
- groove
- ridge
- insert
- outset

以下border関連のCSS
- border-color: 線の色の変更ができる．
- border-size: 線の幅を変えられる．
これを使うことで，4辺別々の線を使用することができる．
```CSS
/* 上下 | 左右 */
div { border-style: dotted solid; }
/* 上 | 左右 | 下 */
div { border-style: dotted solid dashed; }
```
- border-style: 線のスタイルを変更できる．

### border-radius
border-radiusを使用すると，boxの角を丸めることができる．
```CSS
/* 全ての角を30pxずつ丸める */
div { border-radius: 30px; }

/* こんな使い方とか... */
div { border-radius: 25% 10%; }
div { border-radius: 10% 30% 50% 70%; }

/* 丸める部分を一定にしたくないとき? */
div { border-radius: 10% / 50%; }
div { border-radius: 50% 20% / 30% 40%; }
```


## box-shadow
要素に影をつけることができる．
指定方法は，影をつける要素に対して，ずらすx座標，ずらすy座標，ぼかす範囲，色の順番．

```CSS
/* 影をつける要素から xを+5px yを+5pxずらし5pxぼかして赤色の影を表示 */
div { box-shadow: 10px 5px 5px red; }

div { box-shadow: 60px -16px teal; }
```
[参考サイト](https://developer.mozilla.org/ja/docs/Web/CSS/box-shadow)

## overflow
要素をはみ出してしまったときに，はみだした部分をどうするかを指定できる．

- visible: はみだして表示
- hidden: はみだした部分は表示しない
- scroll: スクロールバーを表示

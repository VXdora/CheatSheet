# メディアクエリー
メディアクエリーを使用することで，モバイルやPCなど，媒体の幅に合わせてCSSを適用することができる．
ちなみに，こういったものをレスポンシブウェブデザインというとかなんとか．

## 準備
メディアクエリーを指定するには，head内にviewportを指定する必要がる．

```HTML
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    ...
</head>
```

## メディアクエリー
大きさは4段階に分けるのが吉？

- ～479px
- 480px～767px
- 768px～979px
- 980px～

## 適用方法
一応，適用方法は2つある．

サイトを色々見ると，直接埋め込むのが多い感じ？


### CSSに直接埋め込む
これが多いかも？
```CSS
@media screen and (min-width: 980px) { ... }
@media screen and (max-width: 979px) and (min-width: 768px) { ... }
@media screen and (max-width: 767px) and (min-width: 480px) { ... }
@media screen and (max-width: 479px) { ... }
```

### HTMLで読み込むCSSを制御
```HTML
<head>
    <link rel="stylesheet" media="screen and (min-width: 980px)" href="a.css">
    <link rel="stylesheet" media="screen and (max-width: 979px) and (min-width: 768px)" href="b.css">
    <link rel="stylesheet" media="screen and (max-width: 767px) and (min-width: 480px)" href="c.css">
    <link rel="stylesheet" media="screen and (max-width: 479px)" href="d.css">
</head>
```
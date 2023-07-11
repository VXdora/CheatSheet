# CSS tutorial

## CSSの適用方法

### head内にlinkタグでファイル分割（推奨）
head内にlinkタグで分割したCSSファイルを読み込むことができます．

index.html
```HTML
<head>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <p class="red_string">this is red string</p>
</body>
```

style.css
```css
p.red_string {
    color: red;
}
```

### タグに埋め込む
`style`属性を使用することで，タグ内に直接埋め込むことができます．

優先順位度が最も高いため，他の方法で書かれたCSSが上書きされます．

```HTML
<p style="color: red;">this is red string.</p>
```

### head内にstyleタグで埋め込む
headタグ内にstyleタグとして直接埋め込むことができます．
ただし，可読性は最悪．

```HTML
<head>
    <style>
        p.red_string {
            color: red;
        }
    </style>
</head>
<body>
    <p class="red_string">this is red string.</p>
</body>
```

## CSSの書き方（適用タグの指定）
以下のように指定できます．

- p { ... } ： pタグ全てにスタイルを適用
- p#A { ... } : pタグの id="A" を持つ要素にスタイルを適用
- p.A { ... } : pタグの class="A" を持つ要素にスタイルを適用
- div.wrapper > p.A { ... } : `<div id="wrapper">`の子要素の`<p class="A">`を持つ要素にスタイルを適用
- input[type="text"] { ... } : inputタグの type="text" 属性を持つ要素にスタイルを適用

## 疑似クラス
選択された要素の特定の状態を表す．

例えば，:hoverを使用すると，ポインターが当たっている要素に対して変更を変えることができる．

```HTML
<style>
    button.a {
        background-color: red;
    }
    button.a:hover {
        background-color: blue;
    }
</style>
...
<button class="a"> ポインターを合わせると青色になるボタン </button>
```

疑似クラスには以下のようなものがある．
- link: 訪問していないリンク
- visited: 訪問したことのあるリンク
- hover: ポインターを合わせたとき
- active: ユーザによってアクティブになっているとき
- focus: 要素にフォーカスがあるとき
- current, past, future: ???
- playing, puased: 再生可能メディアで，再生中・一時停止中
- autofill: inputで自動補完した場合
- enabled, disabled: UI要素が有効・無効のとき
- read-only, read-write: ユーザが変更不可・変更可能の要素
- checked: チェックボックス，ラジオボタン等がオンになってるとき
- blank: フォームが空のとき
- valid, invalid: 妥当であるかどうか ex. `<input type="email">`でメールとして正しいか？
- in-range, out-of-range: 範囲制限のある要素で許容範囲内・許容範囲外
- required, optional: フォーム要素が必須要素・省略可能

## CSSネスティング
CSSネスティングを利用することで，コードを簡潔に記述できる．
なお，対応しているブラウザは，
- Chrome: ver.112以上
- Edge: ver.112以上
- Safari: ver.16.5以上
- Firefox: ver.116以上
- Opera: ver.100以上

Ex.

```HTML
<style>
    div.wrapper {
        color: red;

        & p.blue {
            color: blue;
        }
    }
</style>
...
<div class="wrapper">
    this is red string
    <p class="blue">
        this is blue string
    </p>
</div>
```
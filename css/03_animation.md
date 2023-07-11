# CSS 使い方 上級編

## keyframe, animate
CSSでアニメーションができる．

まずは，アニメーションの定義．
アニメーションの定義にはkeyframesを使用．
0%から100%の範囲で，任意の値を指定して，状態を定義できる．

```CSS
@keyframes animation-sample {
    0%   { width:   0%; }
    100% { width: 100%; }
}
```

これを要素に対して適用する．

```CSS
div {
    animation-name: animation-sample;
    animation-duration: 2s;
    animation-iteration-count: infinite;
}
```

animation-nameはアニメーションを定義したアニメーション名を入れる．

animation-durationはアニメーションを実行する長さを入れる．

animation-iteration-countはアニメーションを実行する回数を入れる．
数字を入れるとその回数だけ，infiniteで無限に繰り返す．

その他，以下のプロパティがある．
- animation-timing-function: アニメーションの加速度を指定できる．
    - ease: 開始と終了をゆっくり変化
    - linear: 一定の速度
    - ease-in: 最初はゆっくり，だんだん速く
    - ease-out: 最初は速く，だんだん遅く
    - ease-in-out
    - step-start
    - step-end
- animation-direction: アニメーションの再生方向
- animation-fill-mode: アニメーション開始と終了時のスタイルの状態
- animation-play-state: アニメーションの再生・停止

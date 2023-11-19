# マウス関連

## 位置取得
1. Assemblyのロード
1. Windows.Formsを使用し，座標を取得

```PS
Add-Type -AssemblyName System.Windows.Forms

$x = [System.Windows.Forms.Cursor]::Position.X
$y = [System.Windows.Forms.Cursor]::Position.Y
Write-Host "マウスカーソルの座標は($x,$y)です。"
```

## クリック検知
1. Assemblyのロード
1. Windows.Formsを使用し，クリックの検知

```PS
Add-Type -AssemblyName System.Windows.Forms

$buttonPressed = [System.Windows.Forms.Control]::MouseButtons 

if ($buttonPressed -eq 'Left') {
    Write-Host "Mouse Click Detected"
}
```

- 右クリック：`Right`
- ホイールクリック：`Middle`


# キーボード関連

# mockito
クラス，メソッドのモック化が可能．

## mock / spy
モック化したオブジェクトに対してはmockかspyでインスタンス化．
二つの違いは実際に．インスタンス化するかどうか．

mockを利用するとインスタンス化しない．
処理を定義していないメソッドを実行すると空振りする．
spyは実際にインスタンス化されるため，処理を定義していないメソッドを実行すると元の処理が実行される．

ただし，finalやstaticは使用不可のため，その場合は後述．

## ふるまいの定義
whenやdoReturnを使用．
```Java
Mockito.when(モックインスタンス).メソッド(引数).thenReturn(返したい戻り値);
Mockito.doReturn(返したい戻り値).when(モックインスタンス).メソッド(引数);
```

## staticメソッドのモック化
staticメソッドのモック化では引数があるときとないときで異なる．
### 引数なし
mockStaticを使用し，try-exceptで囲む．
```Java
try(MockedStatic<StaticUtils> utilities = Mockito.mockStatic(StaticUtils.class)) {
    utilities.when(StaticUtils::name).thenReturn("TestName");
}
```

### 引数あり
上のやつに追加でwhen-thenReturnを使用．
```Java
try (MockedStatic<StaticUtils> utilities = Mockito.mockStatic(StaticUtils.class)) {
    utilities.when(() -> StaticUtils.method2(1, 2)).thenReturn(3);
}
```


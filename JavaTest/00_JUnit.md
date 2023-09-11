# JUnit

## Anotation
- @Test...テストするにはこのアノテーションをつける．
- @Before...各テストの前処理を行う．
- @After...各テストの後処理を行う．
- @Ingore...一時的に．テストを無視．

## 検証メソッド
### assertEquals
左が期待値で右が実測値...らしい．
```Java
@Test
public void test() {
    int sum = add(30, 70);
    assertEquals(100, sum);
}
```

### assertTrue
比較式やbooleanを返すメソッドで使用できる．
```Java
@Test
public void test() {
    int sum = add(30, 70);
    assertTrue(sum > 90);
}
```

### assertThat
左が実測値で右がhamcrest.Matcherを渡す．
```Java
@Test
public void test() {
    int sum = add(30, 70);
    assertThat(sum, is(100));
}
```
以下，Mathcerにある定義されているメソッド．
- is...同じ値であるか
- not
- nullValue...nullであるか
- notNullValue
- equalTo...同じ値であるか
- sameInstane(Object)...同じインスタンスか
- instanceOf(Object.class)...指定したクラスのインスタンスか
- containsString(String)...指定した文字列を含んでいるか
- startsWitn(String)/endsWith(String)...指定した文字列で開始/終了しているか
- equalToIngoringCase(String)...大文字小文字を区別せずに比較
- equalToIngoringWhiteSpace(String)...大文字・小文字・ブランク文字を無視して比較
- isEmptyString()...空文字であるか検証
- isEmptyOrNullString()...空文字またはnullであることを検証
- stringContainsInOrder(String, String, ...)...指定した順序で文字列が現れているか検証
- closeTo(float, float)...第一引数±第二引数の範囲内にあるか検証
- greaterThan(int)...指定した値より大きいか検証
- greaterThanOrEqualTo(int)...指定した値以上か検証
- lessThan(int)
- lessThanOrEqualTo(int)

[その他](https://qiita.com/opengl-8080/items/e57dab6e1fa5940850a3)


## 例外のテスト
@Testアノテーションにexpectedオプションをつける．
```Java
@Test(expected=IndexOutOfBoundsException.class)
public void test() {
    new ArrayList<Object>().get(1);
}
```
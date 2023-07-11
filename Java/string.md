# Javaの文字列操作

- [文字列を作成する](#文字列の作成)
- [数値を文字列に変換する](#数値-→-文字列)
- [文字列を数値に変換する](#文字列-→-数値)
- [文字列と文字列を比較する](#文字列の比較)
- [文字列の長さを取得する](#文字列の長さを取得)
- [文字列の文字の数(コードポイントの数)を取得する(String.codePointCount)](#)
- [文字列から指定したインデックスの文字を取得する(String.charAt)](#)
- [文字列から指定したインデックスのUnicodeコードポイントを取得する(String.codePointAt)](#)
- [部分文字列を取得する](#部分文字列の取得)
- [文字列の先頭と末尾から空白文字を取り除く](#空白文字の除去)
- [文字列に含まれる文字を大文字または小文字に変換する(String.toUpperCase、String.toLowerCase)](#)
- [文字列の最後に別の文字列を連結する(String.concat)](#)
- [文字列の一部を別の文字や文字列に置換する](#文字列の置き換え)
- [指定した区切り文字で複数の文字列を連結し新しい文字列を作成する(String.join)](#文字列の結合)
- [文字列の中で指定した文字または文字列が出現するインデックスを取得する(String.indexOf,String.lastIndexOf)](#文字の出現する場所)
- [文字列全体が正規表現パターンとマッチするか調べる(String.matches)](#)
- [文字列を正規表現パターンを使って分割する(String.split)](#)
- [文字列の中の正規表現パターンとマッチする部分を置換する(String.replaceFirst,String.replaceAll)](#)


## 文字列の作成
Javaの文字列クラスはString．
```Java
String msg = "hello";

char[] c = {'H', 'e', 'l', 'l', 'o'};
String msg = new String(c);
```

## 文字列 → 数値
文字列から数値への変換は，`parseInt`を使用．
例外として`NumberFormatException`を渡せる．

```Java
String numstr = "24";
int num = Integer.parseInt(numstr);
```

その他，Integer以外にも変換可能．
- `public static int parseInt(String s) throws NumberFormatException`
- `public static byte parseByte(String s) throws NumberFormatException`
- `public static short parseInt(String s) throws NumberFormatException`
- `public static long parseByte(String s) throws NumberFormatException`
- `public static float parseInt(String s) throws NumberFormatException`
- `public static double parseByte(String s) throws NumberFormatException`
- `public static boolean parseByte(String s)`

## 数値 → 文字列
### 「+」演算子を使って連結
「+」演算子を用いることで文字列にすることができる．
```Java
int num = 10;
String str = "" + num;
```

### 面倒くさい方法
数値から文字列への変換は`toString`を使用．
ただし，そのままでは利用できないため，ラッパー関数を使用する必要がある．

```Java
int num = 10;
Integer i = Integer.valueOf(num);
String str = i.toString();
```

## 文字列の比較
文字列の比較には`equals`もしくは`compareTo`を使用．

一致するか調べたいときは`equals`，大小の比較は`compareTo`．

なお，`compareTo`の比較方法は以下の通り．
1. 文字列の長さが同じで、すべてのインデックスの文字が同じ値だった場合は 0 を返す
1. 文字列の長さは異なるが、短い方の文字列全体が長い文字列の先頭部分と一致している場合は 対象の文字列.length() - 引数の文字列.length() を返す
1. 同じインデックスの文字が異なる値があった場合は 対象の文字列.charAt(k) - 引数の文字列.charAt(k) を返す

```Java
String a1 = 'aaa';
String a2 = 'aaa';
System.out.println(a1.equals(a2));   // true

String str1 = "AAAAAAAA";
String str2 = "AAAAAAAA";
String str3 = "AAA";
String str4 = "ABCD";
System.out.println(str1.compareTo(str2));  // 0
System.out.println(str1.compareTo(str3));  // 5
System.out.println(str1.compareTo(str4));  // -1
```

## 文字列の長さを取得
文字列の長さの取得は`length`を使用．

```Java
String msg = "hello";
System.out.println(msg.length());       // 5
```

## 部分文字列の取得
部分文字列の取得には`substring`を使用．

```
public String substring(int beginIndex, int endIndex)

パラメータ：
beginIndex - 開始インデックス(この値を含む)
endIndex - 終了インデックス(この値を含まない)

例外：
IndexOutOfBoundsException
```

```Java
String msg = "東京都港区赤坂";

System.out.println(msg.substring(3, 5));        // 港区
System.out.println(msg.substring(5, 7));        // 赤坂
```

## 空白文字の除去
空白文字の除去には2つ方法がある．

### trimメソッド
除去されるのは，先頭部分と末尾部分の空白文字．

`trim`メソッドは以下の文字を消去する．
- \u0009  水平タブ(\t)
- \u000A  改行(\n)
- \u000B  垂直タブ
- \u000C  改ページ(\f)
- \u000D  復帰(\r)
- \u001C
- \u001D
- \u001E
- \u001F
- \u0020  半角スペース

```Java
String msg = "  AB CD ";

System.out.println(msg.trim());  // AB CD
```

### stripメソッド
ぶっちゃけ上のtrimメソッドと変わらない．
こっちは日本語みたいな全角スペースもとってくれる．

```Java
String msg = "　AB CD　";

System.out.println("[" + msg.strip() + "]");  // [AB CD]
```

似たような奴に`stripLeading`と`stripTrailing`がいる．
先頭の空白だけ除去するか，ケツの空白だけを除去するか．

## 文字の置き換え
文字列の置換には`replace`メソッドを使用．

```Java
String str = "Herro Java";
System.out.println(str.replace('r', 'l'));  // Hello Java
```

文字列ごと置き換えも可能．
```Java
String str = "東京都港区";
System.out.println(str.replace("港区", "中央区"));  // 東京都中央区
```

## 文字列の結合
複数の文字列の結合には`join`メソッドを使用．

```
public static String join(CharSequence delimiter, CharSequence elements, ... )

パラメータ:
delimiter - 各要素を区切る区切り文字
elements - 結合する要素

戻り値:
delimiterで区切られたelementsからなる新しいString

例外:
NullPointerException - delimiterまたはelementsがnullである場合
```

```Java
String str = String.join("-", "Apple", "Grape", "Melon");
System.out.println(str);  // Apple-Grape-Melon
```

なお，リストでも可能．
```Java
import java.util.List;

List<String> strings = List.of("One", "Two", "Three");
String str = String.join(" * ", strings);
System.out.println(str);  // One * Two * Three
```

## 文字の出現する場所
文字が出現する場所は`indexOf`で取得．
なお，最初に見つかった位置が返る．

```Java
String str = "Hello World";
System.out.println(str.indexOf((int)'o'));  // 4
```

ある位置から走査するには，第二引数に検索開始位置のインデックスを入れる．
```Java
String str = "Hello World";
System.out.println(str.indexOf((int)'o', 5));  // 7
```

また，ケツから探したいなら`lastIndexOf`を使用．
```Java
String str = "Hello World";
System.out.println(str.lastIndexOf((int)'o'));  // 7

String str = "Hello World";
System.out.println(str.lastIndexOf((int)'o', 6));  // 4
```
# ArrayList(配列)

## 目次
- [ArrayListクラスの作成](#ArrayListの作成)
- [要素を追加](#要素の追加)
- [要素の数を取得](#要素数の取得)
- [要素に格納されているオブジェクトを取得](#オブジェクトの取得)
- [要素を置き換](#要素の置き換え)
- [要素を削除](#要素の削除)
- [要素を検索](#要素の検索)

## ArrayListの作成
ArrayListクラスの作成には，`new`を使用する．

```Java
ArrayList<String> list = new ArrayList<>();
```

なお，intやdoubleなどの基本データ型をリストにしたい場合は，ラッパークラスを使用．
| 基本データ型 | ラッパークラス |
| --- | --- |
| boolean | Boolean |
| char | Character |
| byte | Byte |
| short | Short |
| int | Integer |
| long | Long |
| float | Float |
| double | Double |

## 要素の追加
### 末尾への追加
要素の追加には`add`メソッドを使用．
```
public boolean add(E e)

パラメータ:
e - このリストに追加される要素

戻り値:
true (Collection.add(E)で指定されているとおり)
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");
```

### 位置を指定して追加
指定した位置に挿入したいなら，引数の1番目にインデックスを入れる．
```
public void add(int index, E element)

パラメータ:
index - 指定の要素が挿入される位置のインデックス
element - 挿入される要素

例外:
IndexOutOfBoundsException - インデックスが範囲外の場合(index < 0||index> size())
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

list.add(1, "Grapes");
```

## 要素数の取得
要素数の取得には`size`を使用．
```
public int size()

戻り値:
このリスト内の要素数
```

使用例：
```Java
List<String> list = new ArrayList<>();
System.out.println(list.size());  // 0

list.add("Apple");
list.add("Orange");
list.add("Lemon");

System.out.println(list.size());  // 3
```

## オブジェクトの取得
指定した要素のオブジェクトを取得するには`get`を使用．

```
public E get(int index)

パラメータ:
index - 返される要素のインデックス

戻り値:
このリスト内の指定された位置にある要素

例外:
IndexOutOfBoundsException - インデックスが範囲外の場合(index < 0||index>= size())
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

System.out.println(list.get(0));  // "Apple"
System.out.println(list.get(2));  // "Lemon"
```

### 拡張for文
以下のようにforを回すことも可能．
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

for(String s: list){
  System.out.println(s);
}
```

## 要素の置き換え
要素の置き換えには`set`を使用．

```
public E set(int index, E element)

パラメータ:
index - 置換される要素のインデックス
element - 指定された位置に格納される要素

戻り値:
指定された位置に以前あった要素

例外:
IndexOutOfBoundsException - インデックスが範囲外の場合(index < 0||index>= size())
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

list.set(1, "Grapes");
```


## 要素の削除
要素の削除には`remove`を使用．

### インデックスを指定して削除
```
public E remove(int index)

パラメータ:
index - 削除される要素のインデックス

戻り値:
リストから削除した要素

例外:
IndexOutOfBoundsException - インデックスが範囲外の場合(index < 0||index>= size())
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

list.remove(1);
```

### オブジェクトを指定して削除
```
public boolean remove(Object o)

パラメータ:
o - このリストから削除される要素(その要素が存在する場合)

戻り値:
指定された要素がこのリストに含まれていた場合はtrue
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

list.remove("Orange");
```

### 全ての要素の削除
全ての要素を削除するには`clear`を使用．

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");

list.clear();
```

## 要素の検索
要素を先頭から検索したいなら，`indexOf`，末尾から検索したいなら`lastIndexOf`を使用．

```
public int indexOf(Object o)

パラメータ:
o - 検索する要素

戻り値:
指定された要素がこのリスト内で最初に検出された位置のインデックス。その要素がこのリストにない場合は -1
```
```
public int lastIndexOf(Object o)

パラメータ:
o - 検索する要素

戻り値:
指定された要素がこのリスト内で最後に検出された位置のインデックス。その要素がこのリストにない場合は -1
```

使用例：
```Java
List<String> list = new ArrayList<>();

list.add("Apple");
list.add("Orange");
list.add("Lemon");
list.add("Orange");

System.out.println(list.indexOf("Orange"));  // 1
System.out.println(list.lastIndexOf("Orange"));  // 3
```


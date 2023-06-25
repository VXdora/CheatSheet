# urls.pyの設定
urls.pyはルーティングすることができます．

このチートシートではアプリケーションのurls.pyの設定に関してです．
プロジェクト全体のurls.pyの設定は[tutorial.md](django/00_tutorial.md)を参照のこと．

## 基本的な書き方
urls.pyは以下のようなファイルとなっています．

app/urls.py
```python
from django.urls import path
from . import views

app_name = '<app_name>'
urlpatterns = [
    path('<pathname>', views.<ViewClass>.as_view(), name='<name>'),
]
```

app\_nameは名前空間です．
テンプレートでurlを指定する際に，`{% url 'app_name:foo' %}`でルーティングすることができるので，
適切な名前で配置しましょう．
また，ここでのfooはpath内のnameにあたります．

pathnameはurlからアクセスるときに設定します．
例えば，domain.co.jp/app\_name/fooにアクセスしたいなら，pathnameはfooになります．

## GETの設定
urlに直接指定してクエリを渡すGETでは，以下のようなurls.pyになります．
```python
urlpatterns = [
    ...
    path('foo/<int:pk>/', ...),
]
```

これで，domain.co.jp/app\_name/foo/1/にアクセスすることができます．
なお，viewでこれらの値を取得するには，`self.kwargs['pk']`を用います．

### パラメータの種類
int以外にも以下のようなパラメータがあります．

- str: 文字列
- slug: 知らん
- uuid: UUIDの指定．詳しくはググって
- path: ファイルパスを指定できる
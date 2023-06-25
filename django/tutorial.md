# djangoの基本的な使い方
djangoはpythonでwebアプリを作成できるフレームワーク．

FlaskやBottleと比較すると，様々な機能を持っているため，使いこなせるには時間がかかる．

簡単なWebアプリを作りたいなら，おすすめしない．

## djangoのインストール
windowsとlinuxで違います．
windowsでは，
```bash
python -m pip install django
```
で入ります．

## プロジェクトの作成


```bash
bash$ mkdir <project-name>
bash$ cd <project-name>
bash$ django-admin startproject config .
```

これで，プロジェクト内にconfigフォルダが作成されます．
configフォルダでは，プロジェクト全体の設定を行います．

## アプリケーションの作成
djangoでは，機能ごとに分けたものをアプリケーションと呼びます．
アプリケーションは以下のコマンドで作成できます．
このとき，アプリケーションフォルダには基本的なファイルが生成されます．

アプリケーション作成のコマンド

```
bash$ python3 manage.py startapp <appname>
```


このままでは使用できないため，config/settings.pyに導入したアプリを記載する．
config/settings.py

```python
   INSTALLED_APPS = [
       ...
+      "<appname>.apps.PollsConfig",
       ...
   ]
```

## プロジェクト全体の設定
デフォルトだとテンプレートの置き場所がバラバラになるので，テンプレートを置く場所を固定しましょう．
ここでは，プロジェクトフォルダ直下のtemplatesフォルダをテンプレートの置き場所とします．

```
bash$ mkdir tempaltes
```

config/settings

```
+  import os
   TEMPLATES = [
       ...
       'DIRS': [
+          os.path.join(BASE_DIR, 'templates'),
       ]
   ]
```

### ALLOWED\_HOSTSに関して
ちなみに，このままだとローカルホスト内からしかつなげないため，ALLOWED\_HOSTSを適切に書き込みましょう．
デバッグ環境なら，

```
ALLOWED_HOSTS = ['*']
```

でいいんじゃない？

### DEBUGについて
この値がTrueだと，開発者用の画面が出てしまいます．
本番環境ではセキュリティの観点上，Falseにすること！

### STATISTICS
静的なファイル（cssやjavascriptなど）はSTATISTICSを設定しておく必要があります．
ここでは，staticフォルダをプロジェクト直下に配置します．

```
bash# mkdir static
```

次に以下のフォルダを変更してください．
config/settings.py

```
+  STATIC_URL = '/static/'

+  STATICFILES_DIRS = [
+      os.path.join(BASE_DIR, 'static/'),
+  ]
```

config/urls.py
```
   ...
+  from django.conf import settings
+  from django.conf.urls.static import static

   urlpatterns = [
       ...
+  ] + static(settings.STATIC_URL, document_root=settings.STATICFILES_DIRS)
```

### MEDIA
逆に動的なファイル（ユーザからのアップロード）などはMEDIAに配置します．
ここでは，mediaフォルダをプロジェクト直下に配置します．
```
bash$ mkdir media
```

次に以下のフォルダを変更してください．
config/settings.py
```
+  MEDIA_URL = '/media/'
+  MEDIA_ROOT = 'media/'
```

config/urls.py
```
   ...
+  from django.conf import settings
+  from django.conf.urls.static import static

   urlpatterns = [
       ...
+  ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```


## urls.py
configフォルダから各アプリケーション内のViewにアクセスすることができますが，やめましょう．
可読性が下がります．

configフォルダ内のurls.pyから各アプリケーションのurls.pyをincludeするようにしましょう．


config/urls.py
```
+  from django.urls import include
+  urlpatterns = [
+      path('path', include('<app_name>.urls')),
+  ]
```

app/urls.py
```
+ from django.urls import path
+ from . import views
+
+ urlpatterns = [
+     path('<pathname>', views.<ViewClass>.as_view(), name='<name>'),
+ ]
```

pathnameでurlからのアクセスができます．
domain.co.jp/fooでアクセスしたいならば，pathnameはfooにしましょう．

nameはテンプレートからurlを用いて簡単にルーティングをすることができるので，適切な名前で設定しましょう．
詳細は[urls.md](/cheatsheet/django/urls.md)を参照．

## Viewの設定
Viewは表示部の設定（バックエンド）ができます．
詳細はView用のファイルを参照．
ここでは基本的なものを書いていきます．
Viewはクラスベースと関数ベースのものがありますが，クラスベースのみで記載します．

### TemplateView
TemplateViewはクラスベースで表示部を担当します．
各アプリケーション内のviews.py（でなくてもいいけど）に書き足していきましょう．

\<app\>/views.py
```
+  from django.views.generic import TemplateView
+  class <ViewClassName>(TemplateView):
+      template_name = '<template_name>.html'
+
+      def get_context_data(self, **kwargs):
+          context = super().get_context_data(**kwargs)
+          context['foo'] = 'bar'        # contextに入れることで，HTMLに渡すことができます．
+          return context
```

## テンプレートの設定
テンプレートではフロントエンドのコードが書けます．
上記views.pyのtemplate\_name.htmlで指定されたテンプレートを表示できます．
詳しくは[template.md](/cheatsheet/django/template.md)を参照．

基本的には，ベースとなるHTMLを用意しておくと，記述するコードが減るので吉．

template/base.html
```html
<!DOCTYPE HTML>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>
      {% block title %}
      {% endblock %}
    </title>
  </head>
  <body>
    {% block content %}
    {% endblock %}
  </body>
</html>
```


template/\<template\_name\>.html
```html
{% extends "base.html" %}

{% block title %}
タイトルを書く
{% endblock %}

{% block content %}
内容を書く
{% endblock %}
```

## サーバを建てる
ここまでできたら，サーバが建てられるはずです．
以下のコマンドを用いてサーバを実行しましょう．

```
bash$ python manage.py runserver
```

デフォルトだと，localhost:8080にアクセスすれば見られるはずです．

LAN上に公開したいなら，
```
bash$ python manage.py runserver ipアドレス:ポート番号
```
で実行します．
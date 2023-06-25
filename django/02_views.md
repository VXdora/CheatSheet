# Views関連

djangoにおいてはバックエンドはこのViewの中で処理していきます．

関数ベースでも表示，コントロールできますが，可読性が下がるため，関数ベースorクラスベースのどちらかに統一しましょう．

なお，クラスベースのほうが様々な恩恵が得られるため，基本的にはクラスベースがおすすめ．

# はじめに
Views関連はすべて，django.views.genericに入っています．
インポートする際にはこれらをfromから読み込みましょう．

また，urls.pyに登録するときは，as_viewを用いましょう．
```python
from app.views.IndexView import IndexView

urlpatterns = [
    path('index', IndexView.as_view(), name='index'),
]
```

## Viewの種類
クラスベースのViewには以下のようなものがあります．
適切に使用していきましょう．

- [TemplateView](#TemplateView): 
画面に描画するView．
基本的にはここで，formによるgetやpost操作をするのはやめましょう．

- [RedirectView](#RedirectView): 
リダイレクトを前提としたView．
使い方としては，ここに飛ばして何か処理をして別なページに飛ばす...とか？

- [FormView](#FormView):
formを入力させたいときに使用するView.
基本的にはDBの変更を加えないものに対して使用する．

- [CreateView](#CreateView):
DBに新たにデータを加えたいときに使用するView.

- [DetailView](#DetailView):
モデル(データベース)の詳細を表示するためのView.
データベースのプライマリキーを指定して，その値と一致するモデルを取り出すことができます．

- [UpdateView](#UpdateView):
DBにすでにあるデータに対して更新を加えたいときに使用するView.

- [DeleteView](#DeleteView):
DBにすでにあるデータに対して削除したいときに使用するView.

- [ListView](#ListView):
モデルの全データを取得する機能が組み込まれたView.
リストとして表示したいときに使用しましょう．

## 共通する機能
すべてのViewで共通するメソッドがあります．
ここではよく使用する一部のものだけ記載します．
詳細は自分で調べてくれ．

### template_name
template_nameは表示したいテンプレートのファイル名を記載します．
ここに記載しないで表示するとTemplateDoesNotExistエラーが発生します．

```python
from django.views.generic import TemplateView

class MyTemplateView(TemplateView):
    template_name = "index.html"
```

### get_context_data
get_context_dataは値をテンプレートに渡すときに使用します．
引数は**kwargsだけでおｋ．
```python
class MyTemplateView(TemplateView):
    ...
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['msg'] = 'Hello, World!'
        return context
```
これでHTML側に渡せます．
HTML側で使用したいときは，
```HTML
<p>{{ msg }}</p>
```
としましょう．

なお，詳しくは[template](django/03_template.html)を参照．

### get
getはformからGETを使用されたときに使用しましょう．
get_context_dataと違い，renderを利用できます．
要求された値に応じてリダイレクト（404とか）が挟まるようならgetです．
しっかり使い分けていきましょう．

それ本当にgetを使用しないといけない？
get_context_dataではダメ？

```python
class MyTemplateView(TemplateView):
    ...
    def get(self, request, *args, **kwargs):
        # self.request.GETで辞書になっているので，
        # getを使用して受け取る
        name = self.request.GET.get('name')
        if name == '':
            return HttpResponseBadRequest(...)
        return super().get(request, **kwargs)
```

### post
postはHTMLでpostを指定した場合に実行されます．
しかし，postで処理をするより，FormViewやCreateViewがいいのではないでしょうか？
FormViewやCreateViewだと，エラー処理などもあるていど自動でやってくれます．
（つまり下の例だとNG）

それ本当にpostでなければいけないですか？

```python
class MyTemplateView(TemplateView):
    ...
    def post(self, request, *args, **kwargs):
        # 一応，POSTの内容はrequest.POSTで取得できます
        name = request.POST['name']
        return render(...)
```

### dispatch
特定のメソッド（GETとかPOSTとか）しか受け取りたくない場合に指定するらしい．

### @cached_property

# TemplateView
一番基本的なView．基本的にはtemplateを表示するだけ．
何かユーザからデータを受け取りたいなら，後述のFormViewやCreateViewを使用しましょう．

# RedirectView
リダイレクトをしたいときに使用するView．
リダイレクトするので，template_nameは不要．

## permanent (メンバ変数) : boolean
リダイレクトがパーマネントか？

Trueで301が返り，Falseで302が返る．
（あまりよく分かってない）

## url（メンバ変数） : string | None
リダイレクト先のURL．
Noneにすると410エラーを返す．

## pattern_name（メンバ変数） : string | None
## query_string（メンバ変数）: boolean
GETクエリ文字列をリダイレクト先にも渡すか？

Trueだと渡し，Falseだと渡さない．


## get_redirect_url(self, *args, **kwargs)
リダイレクトするurlを返します．
リダイレクト先が常に変化するような場合は，urlメンバでなくこちらを使用するといいでしょう．


# FormView
# CreateView
# DetailView
# UpdateView
# DeleteView
# ListView
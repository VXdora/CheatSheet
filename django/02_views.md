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
ユーザからの入力を受け付けたいときに使用する．
ただし，モデルと同様のデータを使用したいなら，後述のCreateViewやUpdateViewを使用．

## Formの作成
FormViewを使用するにあたり，まずはFormを作成する必要がある．
これを利用することで，自動的なHTMLへの配置，ある程度のバリデーションをしてくれる．

```python
from django import forms

class UserForm(forms.Form):
    name = forms.CharField(max_length=32, label='名前')
    age = forms.IntegerField(label='年齢')
```

このようなFormを作成することで，文字列のフィールドと数字のフィールドを用意することができる．

以下のようなフィールドがある．
- BooleanField
    - widget: type="checkbox"として生成．
- CharField
    - widget: type="text"として生成．
    - max_length, min_length：最大文字数，最小文字数を指定．
    - strip=True：空白で切り出すことができる．
    - empty_value: 
- ChoiceField
    - widget: type="select"で生成．単一回答のみ．

    ※example
    ```python
    from django import forms
    from django.db import models


    class FoodChoices(models.TextChoices):
        BREAD = 'bread', 'パン'
        RICE = 'rice', 'ご飯'
        FISH = 'fish', '魚'
        MEAT = 'meat', '肉'


    class FoodForm(forms.Form):
        food = forms.fields.ChoiceField(
            choices=FoodChoices.choices,
            required=True,
            label='食べ物',
            # widget=forms.widgets.Select,
        )
    ```
- DateField
    - widget: type="date"で生成．
    - input_formats: 好きな形に変換
- DateTimeField
    - widget: type="datetime-local"で生成．
    - input_formats: 好きな形に変換
- EmailField
    - widget: type="email"で生成．
    - max_length, min_lengthで文字数を指定できる．
- FileField
    - widget: type="file"で生成．
- FloatField
- GenericIPAddressField
- ImageField
    - widget: type="file"で生成．
    - Pillowを使用するため，PILをinstallしておきましょう．
- ImtegerField
    - widget: type="number"で生成．
    - max_value, min_valueで数の制限ができる．
- JSONField
    - widget: <textarea></textarea>で生成．
- MultipleChoiceField
    - widget: type="select"で生成．複数回答可．
- NullBooleanField
    - widget: type="???"で生成．
    - Yes/No/回答しないの3パターンなど．
- TimeField
- URLField
- ComboField



# CreateView
# DetailView
# UpdateView
# DeleteView
# ListView
# Views 関連

django においてはバックエンドはこの View の中で処理していきます．

関数ベースでも表示，コントロールできますが，可読性が下がるため，関数ベース or クラスベースのどちらかに統一しましょう．

なお，クラスベースのほうが様々な恩恵が得られるため，基本的にはクラスベースがおすすめ．

# はじめに

Views 関連はすべて，django.views.generic に入っています．
インポートする際にはこれらを from から読み込みましょう．

また，urls.py に登録するときは，as_view を用いましょう．

```python
from app.views.IndexView import IndexView

urlpatterns = [
    path('index', IndexView.as_view(), name='index'),
]
```

## View の種類

クラスベースの View には以下のようなものがあります．
適切に使用していきましょう．

- [TemplateView](#TemplateView):
  画面に描画する View．
  基本的にはここで，form による get や post 操作をするのはやめましょう．

- [RedirectView](#RedirectView):
  リダイレクトを前提とした View．
  使い方としては，ここに飛ばして何か処理をして別なページに飛ばす...とか？

- [FormView](#FormView):
  form を入力させたいときに使用する View.
  基本的には DB の変更を加えないものに対して使用する．

- [CreateView](#CreateView):
  DB に新たにデータを加えたいときに使用する View.

- [DetailView](#DetailView):
  モデル(データベース)の詳細を表示するための View.
  データベースのプライマリキーを指定して，その値と一致するモデルを取り出すことができます．

- [UpdateView](#UpdateView):
  DB にすでにあるデータに対して更新を加えたいときに使用する View.

- [DeleteView](#DeleteView):
  DB にすでにあるデータに対して削除したいときに使用する View.

- [ListView](#ListView):
  モデルの全データを取得する機能が組み込まれた View.
  リストとして表示したいときに使用しましょう．

## 共通する機能

すべての View で共通するメソッドがあります．
ここではよく使用する一部のものだけ記載します．
詳細は自分で調べてくれ．

### template_name

template_name は表示したいテンプレートのファイル名を記載します．
ここに記載しないで表示すると TemplateDoesNotExist エラーが発生します．

```python
from django.views.generic import TemplateView

class MyTemplateView(TemplateView):
    template_name = "index.html"
```

### get_context_data

get_context_data は値をテンプレートに渡すときに使用します．
引数は\*\*kwargs だけでおｋ．

```python
class MyTemplateView(TemplateView):
    ...
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['msg'] = 'Hello, World!'
        return context
```

これで HTML 側に渡せます．
HTML 側で使用したいときは，

```HTML
<p>{{ msg }}</p>
```

としましょう．

なお，詳しくは[template](django/03_template.html)を参照．

### get

get は form から GET を使用されたときに使用しましょう．
get_context_data と違い，render を利用できます．
要求された値に応じてリダイレクト（404 とか）が挟まるようなら get です．
しっかり使い分けていきましょう．

それ本当に get を使用しないといけない？
get_context_data ではダメ？

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

post は HTML で post を指定した場合に実行されます．
しかし，post で処理をするより，FormView や CreateView がいいのではないでしょうか？
FormView や CreateView だと，エラー処理などもあるていど自動でやってくれます．
（つまり下の例だと NG）

それ本当に post でなければいけないですか？

```python
class MyTemplateView(TemplateView):
    ...
    def post(self, request, *args, **kwargs):
        # 一応，POSTの内容はrequest.POSTで取得できます
        name = request.POST['name']
        return render(...)
```

### dispatch

特定のメソッド（GET とか POST とか）しか受け取りたくない場合に指定するらしい．

### @cached_property

# TemplateView

一番基本的な View．基本的には template を表示するだけ．
何かユーザからデータを受け取りたいなら，後述の FormView や CreateView を使用しましょう．

# RedirectView

リダイレクトをしたいときに使用する View．
リダイレクトするので，template_name は不要．

## permanent (メンバ変数) : boolean

リダイレクトがパーマネントか？

True で 301 が返り，False で 302 が返る．
（あまりよく分かってない）

## url（メンバ変数） : string | None

リダイレクト先の URL．
None にすると 410 エラーを返す．

## pattern_name（メンバ変数） : string | None

## query_string（メンバ変数）: boolean

GET クエリ文字列をリダイレクト先にも渡すか？

True だと渡し，False だと渡さない．

## get_redirect_url(self, \*args, \*\*kwargs)

リダイレクトする url を返します．
リダイレクト先が常に変化するような場合は，url メンバでなくこちらを使用するといいでしょう．

# FormView

ユーザからの入力を受け付けたいときに使用する．
ただし，モデルと同様のデータを使用したいなら，後述の CreateView や UpdateView を使用．

## Form の作成

FormView を使用するにあたり，まずは Form を作成する必要がある．
これを利用することで，自動的な HTML への配置，ある程度のバリデーションをしてくれる．

```python
from django import forms

class UserForm(forms.Form):
    name = forms.CharField(max_length=32, label='名前')
    age = forms.IntegerField(label='年齢')
```

このような Form を作成することで，文字列のフィールドと数字のフィールドを用意することができる．

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
  - max_length, min_length で文字数を指定できる．
- FileField
  - widget: type="file"で生成．
- FloatField
- GenericIPAddressField
- ImageField
  - widget: type="file"で生成．
  - Pillow を使用するため，PIL を install しておきましょう．
- ImtegerField
  - widget: type="number"で生成．
  - max_value, min_value で数の制限ができる．
- JSONField
  - widget: <textarea></textarea>で生成．
- MultipleChoiceField
  - widget: type="select"で生成．複数回答可．
- NullBooleanField
  - widget: type="???"で生成．
  - Yes/No/回答しないの 3 パターンなど．
- TimeField
- URLField
- ComboField

## FormView を継承

バックエンドでは FormView を継承したクラスを作成します．

```python
from django.views.generic import FormView
from app.forms import ExampleFormClass

class ExampleFormView(FormView):
    template_name = 'template.html'
    form_class = ExampleFormClass       # 作成したフォーム
    success_url = '/home'               # 処理に成功したときにリダイレクトするurl
```

form_class に作成したフォームを，success_url に処理に成功したときにリダイレクトするページを書きましょう．

### form_valid(self, form)

form で受け取ったデータを加工したいときには form_valid メソッドを用いましょう．
cleaned_data でサニタイズされたデータを受け取ることができます．

```python
class ExampleFormView(FormView):
    ...
    def form_valid(self, form):
        data = form.cleaned_data
        obj = ExampleModel(**data)
        obj.save()
        return super().form_valid(form)
```

### form_invalid(self, form)

form でバリデーションがうまくいかなかったときは，form_invalid に入ります．

エラーメッセージを HTML に表示させたいときはこのメソッドを利用しましょう．

```python
class ExampleFormView(FormView):
    ...
    def form_invalid(self, form):
        return super().form_invalid(form)
```

### get_form_kwargs(self, \*args, \*\*kwargs)

辞書型の値をフォームクラスへ送れます．

```python
class ExampleFormView(FormView):
    ...
    def get_form_kwargs(self, *args, **kwargs):
        kwgs = super().get_form_kwargs(*args, **kwargs)
        kwgs['user'] = 'Anonymous'
        return kwgs
```

## HTML での処理

特に設定しなければ，{{ form }}で受け取れます．
method は POST で，action は指定しなくても OK です．

```HTML
<form method="POST">
    {% csrf_token %}
    {{ form }}
    <button type="submit">送信</button>
</form>
```

ちなみに，{{ form }}では，以下のものが使えます．

- {{ form.as_p }}：それぞれのフォームを p タグで囲って加工
- {{ form.as_table }}：それぞれのフォームを tr タグで囲って加工．
  table タグで囲ってあげる必要があるので注意
- {{ form.as_ul }}

# CreateView

CreateView を使用する際には，以下の 3 つのメンバ変数を定義しましょう

```python
from django.views.generic.edit import CreateView
from app.models import ExampleModel

class ExampleCreateView(CreateView):
    template_name = ...
    form_class = ExampleModel
    success_url = 'index'
```

- template_name: テンプレートとなる html を指定
- form_class: 追加したいデータのクラスを指定
- success_url: 追加に成功した場合にリダイレクトする url（指定しなくてもよい）

## その他指定できるメソッド

### get_success_url(self)

動的にリダイレクト先を指定できます．

```python
class ExampleCreateView(CreateView):
    ...
    def get_success_url(self):
        return '/accounts/login'
```

### get_form_kwargs(self, \*args, \*\*kwargs)

フォームクラスへ値を渡せる．

詳細は FormView の get_form_kwargs を参照．

### form_valid, form_invalid

FormView の form_valid, form_invalid を参照．

## HTML

HTML では FormView と同様に{{ form }}で指定できます．
詳細は FormView の HTML での処理を参照．

# DetailView

# UpdateView

# DeleteView

# ListView

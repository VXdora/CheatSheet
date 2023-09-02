# Terraform
## terraformとは？
AWSやAzureなどのインフラ環境をコード化できる（いわゆるIaC）ツール．
プロバイダーにより提供されるAPIを通じてインフラを管理．

## インストール
### git
terraformはWindowsのTerminal上では使用不可のため，Git Bash等を使用する必要がある．

[ここ](https://gitforwindows.org/)からGitをダウンロードし，インストール．

### terraformのインストール
Gitがインストールできたらterraformをインストールする．
ただ，terraformはバージョンが複雑（バージョンが変わって大幅な変更などがある）ため，tfenvを利用したバージョン管理をしていく．

### tfenvのインストール
Git Bash上で以下の操作を行っていく．
```bash
cd ~
git clone https://github.com/tfutils/tfenv.git
```
続いて，これらを使えるように.bashrcに追加していく．
```bash
$ vi ~/.bashrc

# bashrcに以下を追加
export PATH=$PATH:/c/Users/(USER_NAME)/.packer/bin
```

### terraformのインストール
`tfenv list-remote`で利用できるterraformのバージョンが確認できる．

続いて`tfenv install <VERSION>`で指定したバージョンのインストールを行い，
`tfenv use <VERSION>`でそのバージョンをデフォルトで使用できるようになる．

バージョン確認には`terraform version`を使用．

↓コピー用↓
```bash
tfenv install 0.15.5
tfenv use 0.15.5
```

## 基本構文
terraform(HCL2)は以下のように記述される．
```HCL2
locals {
    ...
}

variable <VAR_NAME> {
    ...
}

terraform {
    ...
}

provider <PROVIDER_TYPE> {
    ...
}

resource <RESOURCE_TYPE> <RESOURCE_NAME> {
    ...
}

output "<OUTPUT_NAME>" {
    ...
}
```

なお，「#」以降はコメントとなる．

### localsブロック
localsブロックは外部から変更できないローカル変数を扱う．
この中で定義し，`${local.<NAME>}`で参照できる．

Ex.
```HCL2
locals {
    project = "TestProject"
    env     = "dev"
}

resource "aws_instance" "test" {
    ...
    tags = {
        Name = "${local.project}-${local.env}-ec2-1"
    }
    ...
}
```

### variableブロック
variableブロックは外部から変更可能な変数を扱う．
例えば，開発環境と商用環境で変数が異なる...とか．
参照時は`${var.<NAME>}`.
localと違い，1つ1つ定義していく．

Ex.
```HCL2
variable "project" {
    type    = string            # データ型
    default = "TestProject"     # デフォルト値
}

variable "env" {
    type    = string
    default = "dev"
}
resource "aws_instance" "test" {
    ...
    tags = {
        Name = "${var.project}-${var.env}-ec2-1"
    }
    ...
}
```

#### 使用できるデータ型
空いているところは気が向いたら書く．
- string...Unicode文字列.

- number...整数＆小数．

- bool...true / false.

- object...キーバリュー型.
```HCL2
variabe "obj_test" {
    type = object({
        name = string
        age = number
    })
    default = {
        name = "Alice"
        age = 18
    }
}

# 参照時
uname = var.obj_test.name
```

- tuple 
```HCL2
variable "tuple_test" {
    type = tuple([
        string, number
    ])
    default = ["Alice", 18]
}

# 参照時
uname = var.tuple_test[0]
```

- list 

- map 

- set

#### 外部参照方法
- 環境変数...`TF_VAR_<NAME>`で環境変数にあらかじめ登録．

- 変数ファイル...`terraform.tfvars`という名前のファイルに変数を書き込む．

- コマンド引数...コマンド引数で指定．
`-var <NAME>=<VALUE>`や`-var-file <FILENAME>`で指定．


なお，下に書いたものほど上書きされる．（下優先）


### terraformブロック
terraform全体の設定を行う．

### providerブロック
どこのproviderを使用するのか指定．
AzureなのかAWSなのか，とか．

以下指定できるやつ．
- profile...AWSやAzureにアクセスするためのプロファイル．
- region...デフォルトリージョンを指定．

### dataブロック
Terraformで管理していないリソースの取り込みを扱う．
EC2を手動で起動して，それを使用したい，とか．

### resourceブロック
Terraformで管理するリソースを記述していくブロック．

### output
外部から参照可能．

## ファイル構成について
**Windowsだと，`C:/Users/<UserName>`配下のディレクトリでないと動かない．**
また，サブディレクトリは反映されないため，プロジェクトのルートディレクトリに全て配置する必要がある．

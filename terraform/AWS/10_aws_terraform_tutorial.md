# Terraform (AWS)
こっちのフォルダはAWSのterraformドキュメント．

## AWS CLIのインストール
terraformでAWSを使用するにはAWS CLIのインストールが必要．
[ここ](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html)から，AWS CLIをインストール．

## IAMの作成
### CLI用のIAMの作成
AWS CLIで使用する，FullAccess権限を持つIAMを作成し，CLIに割り当てる．

AWS > IAMより，左パネル「ユーザー」をクリック．
「認証情報」タブから，画面中段「アクセスキーの作成」．
アクセスキーIDとシークレットアクセスキーを記憶．
**(1度しか表示できないので注意)**

以降，ターミナルより，
```
$ aws configure
AWS Access Key ID [None]: (先ほど記憶したアクセスキーID)
AWS Secret Access Key [None]: (先ほど記憶したシークレットアクセスキー)
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

### Terraform用のIAMの作成
AWS CLIで使用する，FullAccess権限を持つIAMを作成し，CLIに割り当てる．

AWS > IAMより，左パネル「ユーザー」から「ユーザを追加」．
ユーザ名は何でも．
「既存のポリシー」アタッチから「AdministratorAccess」を選択．
「ユーザーの作成」をクリックすると，アクセスキーIDとシークレットアクセスキーが表示されるので記憶．
**(1度しか表示できないので注意)**

以降，ターミナルより，
```
$ aws configure
AWS Access Key ID [None]: (先ほど記憶したアクセスキーID)
AWS Secret Access Key [None]: (先ほど記憶したシークレットアクセスキー)
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

### 認証情報について
登録した認証情報は，`Users/<UserName>/.aws/credentials`に作成される．
credentialsの中身は以下のような感じ．

```
[default]
aws_access_key_id = AKCIALSACE...
aws_secret_access_key = wJakCk5ijX...

[profile1]
aws_access_key_id = ACO4AIYJD8...
aws_secret_access_key = kv63Ki8xI7...
```

## ひな形
- main.tf
```HCL2
# ---------------------------------
# Terraform configuration
# ---------------------------------
terraform {
    required_version = ">=0.13"     # 0.13以上のバージョン
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}

# ---------------------------------
# Provider
# ---------------------------------
provider "aws" {
    profile = "terraform"       # Terraformのアクセス権限を持つIAMユーザを入力
    region = "ap-northeast-1"
}

# ---------------------------------
# Variables
# ---------------------------------
variable "project" {
    type = string
}

variable "env" {
    type = string
}
```

- terraform.tfvars
```HCL2
project = "Project_Name"
env = "dev"
```


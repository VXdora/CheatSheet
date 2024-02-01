# Terraformによる複数アカウントへの同時apply

## 目次
- [概要](#概要)
- [terraform用IAMユーザの作成](#iamユーザの作成)
- [アクセスキーの作成](#アクセスキーを作成)
- [aws cliの設定](#aws-cliからアクセスできるようにする)
- [terraformでのアカウント指定方法](#terraformでアカウント指定をする)

## 概要
このページではTerraformで一度のapplyで複数アカウントへリソースを展開する方法を記載．
ここでは，プロバイダーはAWSとする．
Azureも（たぶん）同じ．

流れとしては以下の通り．
- terraformで構築したいアカウントにterraform用のIAMユーザを作成
- 作成したユーザに対してCLIによるアクセス可能なアクセスキーを作成
- aws configureでcredentialsに登録する
- terraformでproviderから複数アカウントを指定する

## IAMユーザの作成
- terraformで構築したいアカウント**全て**にIAMユーザを作成する
- 許可を選択する
    - 基本的には「ポリシーを直接アタッチする」から，「AdministratorAccess」を実行すればよさそう

## アクセスキーを作成
- IAM > ユーザから，先ほど作成したIAMユーザを選択し，画面右側の「アクセスキーを作成」をクリック
- ユースケースとして「コマンドラインインターフェイス(CLI)」を選択
- 「アクセスキー」と「シークレットアクセスキー」が表示されるので，保存

## aws cliからアクセスできるようにする
- terraformからアクセスできるようにするには，aws cliの初期設定を行わないといけない
- awsコマンドが使える環境で以下を**アカウント分**設定
    ```
    aws configure --profile <プロファイル名>
    AWS Access Key ID [None]: <先ほど作成したアクセスキーを入力>
    AWS Secret Access Key [None]: <先ほど作成したシークレットアクセスキーを入力>
    Default region name [None]: ap-northeast-1     # 実行するリージョン
    Default output format [None]: json              # json or yaml ??
    ``` 
    - プロファイル名は何でもよいが，ここでのプロファイル名は使用するので，記憶しておくこと．
    なお，分からなくなっても，`~/.aws/`に配置されているので，見ようと思えば見られる．
        - `~/.aws/credentials`
            ```
            [account-dev]
            aws_access_key_id = ABCDEFGHIJKLMN
            aws_secret_access_key = kldjfAGAFlajfdl3243ADFa
            [account-prd]
            aws_access_key_id = ABCDEFGHIJKLMN
            aws_secret_access_key = kldjfAGAFlajfdl3243ADFa
            ```
        - `~/.aws/config`
            ```
            [profile account-dev]
            region = ap-northeast-1
            output = json
            [profile account-prd]
            region = ap-northeast-1
            output = json
            ```
<h3>ここでは，作成したアカウントを<span style="color: red">account-dev</span>と<span style="color: red">account-prd</span>とします．</h3>

## terraformでアカウント指定をする
- terraformでアカウントを指定するには，`provider`を複数記述
    ```HCL
    provider "aws" {
        alias = "dev"
        profile = "account-dev"
        region = "ap-northeast-1"
    }

    provider "aws" {
        alias = "prd"
        profile = "account-prd"
        region = "ap-northeast-1"
    }
    ```
- moduleを特定のアカウントだけ読み込ませたいなら，`module`ブロック内に`providers`を追記
    ```HCL
    module "dev_module" {
        source      = "../modules"
        env         = var.dev_env       # 変数の指定
        providers   = {
            aws = aws.dev               # aws.<providerのalias>で指定
        }
    }
    module "dev_module" {
        source      = "../modules"
        env         = var.prd_env
        providers   = {
            aws = aws.prd
        }
    }
    ```

## その他
- ロールによる方法もあるとかなんとか
# CodeBuild

## 概要

## ビルドプロジェクトの作成

### プロジェクトの設定
- プロジェクト名
- 追加設定
    - 説明
    - ビルドバッジ
    - 同時ビルド制限

### ソース
- プロジェクトを引っ張ってくるソースを選択
- ソースプロバイダとして5つ選べる
    - `CodeCommit`
        - `リポジトリ`, `ブランチ`などを指定
    - `S3`
        - `バケット`, `S3フォルダ`を指定
    - `GitHub`
        - `OAuth`もしくは`アクセストークン`での接続
        - その後，レポジトリのURLを選択

### 環境
- ビルドを実行する環境
1. マネージド型イメージ
    - 素の`EC2`や`Lambda`を使用してビルド
        - `Lambda`を使用すると速くなる
            - ただし，`バッチビルド`ができないなど，制約あり
    - OSは`Amazon Linux`か`Ubuntu`
1. カスタムイメージ
    - Dockerイメージ環境下でビルドが可能
    - マネージド型イメージに入っていないツールを利用する場合など
    - イメージレジストリは`ECR`か`その他のレポジトリ`
- ロールとして`S3FullAccess`権限を持たせる

### Buildspec
- ビルド時に実行するコマンドを記述したYAMLファイル
- 以下の2通り
1. buildspecファイルを使用
    - プロジェクトのルートディレクトリ配下に配置
    - ファイル名は`buildspec.yml`で固定
        - 一応変えられる
1. ビルドコマンドを直接記述

### アーティファクト
- 成果物の出力先を指定
- タイプは`アーティファクトなし`（テストorECRにプッシュ）か，`S3`を選択
    - `S3`を指定した場合は，バケット名やzipファイル名を選択できる

### ログ
- ログの出力先の設定

## 料金
- ビルド時間に応じて計算
- 以下の条件を満たすと無料になる
    - EC2: `general1.small` or `arm1.small`
    - Lambda: `lambda.arm.1GB` or `lambda.x86-64.1GB`
    - 6,000秒/月のビルド時間以内
    - これを超えると，インスタンスタイプによって異なる

## buildspecの書き方

- `version`
    - `0.1`も使用できるが，`0.2`が推奨
- `run-as`(オプション)
    - どのユーザで実行するか
    - 指定しなければルートユーザとして実行
- `env`: カスタム環境変数の情報を記述
    - `shell`
        - 使用するシェルの種類
        - Linuxなら，`bash` or `/bin/sh`
        - Windowsなら，`powershell.exe` or `cmd.exe`
    - `variables`
        - プレーンテキストで環境変数を定義
    - `parameter-store`
    - `secrets-manager`
        - `key: secret-id:json-key:version-stage:version-id`で使用
        - `key`を使用してビルド中に変数にアクセス
        - `secret-id`
        - `json-key`以降はオプション
    - `exported-variables`
    - `git-credential-helper`
- `proxy`(オプション): プロキシサーバでビルド実行する際に必要
    - `upload-artifacts`
    - `logs`
- `phases`: ビルドの各段階でCodeBuildが実行するコマンドを記述
    - `install` | `pre_build` | `build` | `post_build`の4つのフェーズが設定できる
    - 各フェーズ内では，`run-as`, `on-failure`, `runtime-versions`, `commands`, `finally`が記述できる
    - `run-as`
        - コマンドを実行するユーザを記述
        - グローバルでも設定されている場合，フェーズレベルのユーザ（こっち）優先
    - `on-failure`
        - ビルド中に障害が発生した場合に実行するアクション
            - `ABORT`: ビルドを中止
            - `CONTINUE`: 次のフェーズに進む
    - `commands`
        - 各フェーズ時に実行するコマンドを記述
    - `finally`
        - オプションのブロック
        - `commands`ブロックの実行後に実行
        - `commands`での実行に失敗した場合でも実行される
- `artifacts`
    - `CodeBuild`の出力先を指定する
    - `files`
        - ビルド環境でのビルド出力アーティファクトを含む場所
    - `name`
    - `discard-paths`
    - `base-directory`



#### buildspecの構文
```YAML
version: 0.2

run-as: Linux-user-name

env:
  shell: shell-tag
  variables:
    key: "value"
    key: "value"
  parameter-store:
    key: "value"
    key: "value"
  exported-variables:
    - variable
    - variable
  secrets-manager:
    key: secret-id:json-key:version-stage:version-id
  git-credential-helper: no | yes

proxy:
  upload-artifacts: no | yes
  logs: no | yes

batch:
  fast-fail: false | true
  # build-list:
  # build-matrix:
  # build-graph:
        
phases:
  install:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    runtime-versions:
      runtime: version
      runtime: version
    commands:
      - command
      - command
    finally:
      - command
      - command
    # steps:
  pre_build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
    # steps:
  build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
    # steps:
  post_build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
    # steps:
reports:
  report-group-name-or-arn:
    files:
      - location
      - location
    base-directory: location
    discard-paths: no | yes
    file-format: report-format
artifacts:
  files:
    - location
    - location
  name: artifact-name
  discard-paths: no | yes
  base-directory: location
  exclude-paths: excluded paths
  enable-symlinks: no | yes
  s3-prefix: prefix
  secondary-artifacts:
    artifactIdentifier:
      files:
        - location
        - location
      name: secondary-artifact-name
      discard-paths: no | yes
      base-directory: location
    artifactIdentifier:
      files:
        - location
        - location
      discard-paths: no | yes
      base-directory: location
cache:
  paths:
    - path
    - path
```

## 参考
- [buildspecの書き方](https://docs.aws.amazon.com/ja_jp/codebuild/latest/userguide/build-spec-ref.html)



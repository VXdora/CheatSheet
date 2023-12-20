# CodeCommit

## 概要
- コードを保存，共有
    - github的なやつ

## リポジトリの作成
- CodeCommitからリポジトリを作成できる
    - リポジトリ名
    - 説明
    - CodeGuru Reviewer
        - 機械学習によるコードレビューをしてくれる

## 料金（重要！）
- 5人/月なら無料で利用可能
    - 50GBのストレージ
    - 10000回のGitリクエスト
    - これを超えると0.001USD/Gitリクエストが発生する
- 追加のアクティブユーザごとに1.00USD/人月がかかる

## ファイルのプッシュ
### Cloud9経由
- コンソールから`git clone`するだけで使用可能
    - アドレスはCodeCommitのレポジトリ一覧から，`URLのクローン`でコピーされる

### ローカル経由(windows)
- sshアクセス
    1. AWS: 以下の権限をもつユーザを作成
        - `CodeCommitFullAccess`
        - `IAMReadOnlyAccess`
        - `IAMUserSSHKeys`
    1. AWS: 作成したIAMユーザに移動，`セキュリティ認証情報`から，`AWS CodeCommitのSSH公開キー`で`SSH公開キーのアップロード`を選択，`id_rsa.pub`(の中身)をアップロード
        - Local: 生成していないなら，`ssh-keygen`で秘密鍵，公開鍵を生成
    1. Local: `~/.ssh/config`ファイルを編集（無ければ追加）
        - 以下の内容を追記
        ```
        Host git-codecommit.*.amazonaws.com
            User APKAEIBAERJR2EXAMPLE
            IdentityFile ~/.ssh/codecommit_rsa
        ```
        - `User`の値は，`AWS CodeCommitのSSH公開キー`の`SSHキーID`を入力
        - `IdentityFile`の値は，生成した秘密鍵のファイルパス
    1. Local: SSH設定のテスト（やらなくてもOK）
        - `ssh git-codecommit.us-east-2.amazonaws.com`
    1. Local: `git clone`する
        - アドレスはCodeCommitのレポジトリ一覧から，`URLのクローン`(SSHを選択)でコピーされる

## 使い方
- 基本的にはGitと同様の仕様なので省略
    - プルリク，マージ，コミット，ブランチはGUIでの操作が可能

## マージ
- プルリクエストからマージが可能
- マージ戦略は3種類
    - 早送りマージ
    - スカッシュしてマージ
    - 3wayマージ


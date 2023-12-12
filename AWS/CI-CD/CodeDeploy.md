# CodeDeploy

## 概要
- `EC2`, `Lambda`, `ECS`へのデプロイ自動化
- ローリングデプロイによりダウンタイムが最小限に抑えられる
    - デプロイ方法は2種類
    - `In-Place`
        - アプリケーションをいったん止めて最新版を上書き
        - 古いバージョンでの稼働を防げる
    - `Blue/Green`
        - アプリケーションを新しい環境で新バージョンのテストを行い，テスト完了後，本番環境に移行
        - ELBが必要になる
- デプロイ履歴の参照が可能
    - ロールバック簡単

## 料金


## デプロイの作成
### アプリケーションを作成
- アプリケーション名
- デプロイするプラットフォーム
    - `EC2`
    - `Lambda`
    - `ECS`
- 作成したアプリケーションからデプロイグループが作成できる

### デプロイグループを作成
- デプロイグループ名
- サービスロール
    - `S3FullAccess`権限を付加しておく
- デプロイタイプ
    - インプレース
        - アプリケーションをいったん止めて最新版を上書き
    - Blue/Green
        - アプリケーションを新しい環境で新バージョンのテストを行い，テスト完了後，本番環境に移行
- 環境設定
    - デプロイするサービスを選択
    - インプレースなら`EC2 Auto Scaling`, `EC2`, `オンプレミスインスタンス`
- デプロイ設定
    - トラフィックの再ルーティング
    - デプロイ成功後，元のインスタンスを削除をするかしないか？


## appspec
- appspecを記述することでデプロイルールを決めることができる
    - どのファイルをどこに配置するか？


### EC2へのデプロイ
- `version`: `0.0`固定
- `os`
    - `linux`: Amazon Linux, Ubuntu Server, RHEL
    - `windows`: Windows Server
- `files`: インスタンスにコピーするファイル名を指定
    - *Install*イベント中に実行される
    - 以下のように記述
        ```YAML
        files:
          - source: sample.jar
            destination: /var/app
          - source: nginx.conf
            destination: /etc/nginx
        ```
- `permissions`: アクセス権限の付与

```YAML
version: 0.0
os: operating-system-name
files:
  source-destination-files-mappings
permissions:
  permissions-specifications
hooks:
  deployment-lifecycle-event-mappings
```

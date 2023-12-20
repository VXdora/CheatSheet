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
    - 起動時に何を実行するか？


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
    - `object`にはファイルパスを記述
    - `pattern`には正規表現で記述できる
        - `*.sh`で指定することで，`object`フォルダは以下のファイル全てに権限を付与することができる
    - `except`で上記ファイルから権限を付与したくないファイルを除外できる
        - `["test.php", "test2.php"]`のように記述
    - `owner`, `group`にはファイルを所持するユーザ，グループを指定
        - `ec2-user`とか`apache`とか
    - `mode`でアクセス権限を指定
        - `744`とか`655`とか
        - `chmod`に従う
    - `type`には権限を適用するオブジェクトのタイプを指定
        - `file`か`directory`
    - 以下のように記述
        ```YAML
       permissions:
          - object: object-specification
            pattern: pattern-specification
            except: exception-specification
            owner: owner-account-name
            group: group-name
            mode: mode-specification
            acls: 
              - acls-specification 
            context:
            user: user-specification
            type: type-specification
            range: range-specification
            type:
              - object-type

          - object: ...
        ```
- `hooks`: 各フェーズにおける命令を実行
    - 以下各フェーズの説明，どのデプロイに対応しているか
        | フェーズ名 | フェーズの説明 |
        | -- | -- |
        | ApplicationStop | 以前に正常にデプロイされたアプリケーションの停止時のフェーズ |
        | DownloadBundle | アプリケーションリビジョンファイルを一時フォルダの展開時のフェーズ |
        | BeforeInstall | ファイルの復号，現在のバージョンのバックアップの作成 |
        | Install | リビジョンファイルを一時的な場所から最終的な宛先へコピー |
        | AfterInstall | アプリケーションの設定やファイルのアクセス許可の変更などで利用できる |
        | ApplicationStart | |
        | ValidateService | |
        | BeforeBlockTraffic | |
        | BlockTraffic | |
        | AfterBlockTraffic | |
        | AllowTraffic | |
        | AfterAllowTraffic| |
    - `location`: 実行するスクリプトのパスを指定
    - `timeout`: タイムアウトする時間（秒）
    - `runas`: 実行するユーザ権限（省略可）
    - 以下のように記述
        ```YAML
        hooks:
          AfterInstall:
            - location: Scripts/RunResourceTests.sh
              timeout: 180
            - location: Scripts/PostDeploy.sh
              timeout: 180
        ```
        - この例だと，`AfterInstall`ステージ中に`Scripts/RunResourceTests.sh`スクリプトが実行される．
            - 180秒以上かかった場合はデプロイが失敗する
- 全体での記述例
    ```YAML
    version: 0.0
    os: operating-system-name
    files:
      - source: sample.jar
        destination: /var/app
    permissions:
      - object: /opt/app/bin
        pattern: "*.sh"
        owner: ec2-user
        group: ec2-user
        mode: 744
        type:
          - file
    hooks:
      AfterInstall:
        - location: Scripts/RunResourceTests.sh
          timeout: 180
    ```


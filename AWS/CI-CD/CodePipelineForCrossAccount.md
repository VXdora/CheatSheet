# クロスアカウントでのコードデプロイメモ

## 目次

## 概要

## KMSキーの作成
- S3を暗号化するためにKMSキーを作成
    - STEP1:
        - キーのタイプ: `対象`
        - キーの使用法: `暗号化および復号化`
    - STEP3:
        - キー管理者に本番環境のアカウントの追加
    - STEP4:
        - キー使用法アクセス許可の定義で本番環境のアカウントの追加
        - 別のAWSアカウントを追加し，開発環境のIDを入力


## アーティファクト用S3バケットの作成(本番環境)
- アーティファクトをやり取りするために，S3を使用する
- 作成したKMSを使用し，暗号化
- 開発アカウントから触れる必要があるため，バケットポリシーを記述する必要あり
    ```JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::<開発環境アカウントのID>:role/<開発環境アカウントのCodeCommitのロール>"
                },
                "Action": "s3:*",
                "Resource": [
                    "arn:aws:s3:::bucket",
                    "arn:aws:s3:::bucket/*"
                ]
            }
        ]
    }
    ```


## CodeBuildの作成(本番環境)
### IAMロールの作成
- CodeBuildにアタッチするサービスロール．
    - 以下のアクセス権限が必要．
        - ログを保存するためのCloudWatchへのアクセス権限
        - アーティファクトの取得・保存に必要なS3へのアクセス権限
        - その他，必要ならCodeDeploy, ECSなどへのアクセス権限
- 以下はCodeBuildに割り当てるロール
    ```JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:GetObjectVersion"
                ],
                "Resource": "*"
            }
        ]
    }
    ```
- また，信頼ポリシーは以下の通り
    ```JSON
    {
        "version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "codebuild.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

### CodeBuildの作成
- マネジメントコンソールからの作成は不可
- cloudshell経由で作成
- 以下のJSONを入力し，コマンドを入力
- `serviceRole`には先ほど作成したロールを，`encryptionKey`には作成したKMSキーのarnを入力
    ```JSON
    {
        "name": "foo",
        "description": "foo",
        "source": {
            "type": "CODEPIPELINE",
            "buildspec": "buildspec.yml"
        },
        "artifacts": {
            "type": "CODEPIPELINE"
        },
        "environment": {
            "type": "LINUX_CONTAINER",
            "image": "aws/codebuild/amazonlinux2-x86_64-standard:4.0",
            "computeType": "BUILD_GENERAL1_SMALL"
        },
        "serviceRole": "arn:aws:iam::<本番環境アカウントのID>:<CodeBuildのロール>",
        "encryptionKey": "arn:aws:kms:ap-northeast-1:<本番環境アカウントのID>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
    ```
- 以下コマンドをCloudShellから入力し，BuildProjectを作成
    ```Bash
    aws codebuild create-project -cli-input-json file://build.json
    ```


## CodePipelineの作成(本番環境)
### IAMロールの作成
- CodePipelineにアタッチするサービスロール．
    - 以下のアクセス権限が必要．
        - 開発環境のアカウントへのAssumeRole
        - アーティファクトの取得・保存に必要なS3へのアクセス権限
        - CodeBuildへのアクセス権限
        - その他，必要ならCodeDeploy, ECSなどへのアクセス権限
- 以下はCodePipelineに割り当てるロール
    ```JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Resource": "arn:aws:iam::<開発環境AWSアカウントのID>:role/*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:GetObjectVersion",
                    "s3:GetBucketVersioning"
                ],
                "Resource": "*",
            },
            {
                "Effect": "Allow",
                "Action": [
                    "codebuild:BatchGetBuilds",
                    "codebuild:StartBuild"
                ],
                "Resource": "*",
            }
        ]
    }
    ```
- また，信頼ポリシーは以下の通り
    ```JSON
    {
        "version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "codepipeline.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

### CodePipelineの作成
- こちらもCodeBuildと同様，マネジメントコンソールからの操作は不可
- jsonファイルを作成し，コマンド実行
    ```JSON
    {
        "roleArn": "arn:aws:iam::<本番環境アカウントのID>:role/<CodePipelineのロール>",
        "name": "foo",
        "artifactStore": {
            "type": "S3",
            "location": "<s3のバケット>",
            "encryptionKey": {
                "id": "arn:aws:kms:ap-northeast-1:<本番環境アカウントのID>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                "type": "KMS"
            }
        },
        "stages": [
            {
                "name": "Source",
                "actions": [
                    {
                        "inputArtifacts": [],
                        "name": "Source",
                        "actionTypeId": {
                            "category": "Source",
                            "owner": "AWS",
                            "version": "1",
                            "provider": "CodeCommit"
                        },
                        "outputArtifacts": [
                            {
                                "name": "SourceArtifact"
                            }
                        ],
                        "configuration": {
                            "PollForSourceChanges": "false",
                            "BranchName": "prd",
                            "RepositoryName": "<Repository-Name>"
                        },
                        "roleArn": "arn:aws:iam:<開発環境アカウントのID>:role/<開発環境アカウントのCodeCommitのロール>"
                    }
                ]
            },
            {
                "name": "Build",
                "actions": [
                    {
                        "name": "Build",
                        "inputArtifacts": [
                            {
                                "name": "SourceArtifact"
                            }
                        ],
                        "actionTypeId": {
                            "category": "Build",
                            "owner": "AWS",
                            "version": "1",
                            "provider": "CodeBuild"
                        },
                        "outputArtifacts": [
                            {
                                "name": "BuildArtifact"
                            }
                        ],
                        "configuration": {
                            "BatchEnabled": "true",
                            "CombineArtifacts": "true",
                            "ProjectName": "<CodeBuildのプロジェクト名>",
                            "PrimarySource": "<S3のバケット名>"
                        }
                    }
                ]
            },
        ]
    }
    ```
- 以下コマンド実行
    ```Bash
    aws codepipeline create-pipeline --cli-input-json file://pipeline.json
    ```

## CodeCommitのロール変更(開発環境)
- 開発環境のCodeCommitには本番用アカウントのKMSへのアクセス権限，s3へのアクセス権限が必要
- 割り当てるロール
    ```JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3*",
                "Resource": [
                    "arn:aws:s3:::<開発環境アカウントのs3バケット>",
                    "arn:aws:s3:::<本番環境アカウントのs3バケット>"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "kms:*",
                "Resource": [
                    "arn:aws:kms:ap-northeast-1:<開発環境アカウントのID>:key/*",
                    "arn:aws:kms:ap-northeast-1:<本番環境アカウントのID>:key/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "codecommit:*",
                "Resource": [
                    "arn:aws:codecommit:ap-northeast-1:<開発環境アカウントのID>:<リポジトリ>"
                ]
            }
        ]
    }
    ```
- 割り当てる信頼ポリシー
    ```JSON
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": [
                        "arn:aws:iam::<開発環境アカウントのID>:root",
                        "arn:aws:iam::<本番環境アカウントのID>:root"
                    ]
                }
            }
        ]
    }
    ```

## 検出，パイプライン起動の自動化
- パイプラインの変更の検出に`EventBridge`を使用
- 別アカウントに送信するために，`EventBridge Bus`を使用

### 本番環境側の設定
- イベントバスの設定
    - 開発環境からのイベントを受信する許可を設定
    - `EventBridge` > `イベントバス` > `default`から，`アクセス許可を管理`をクリック
    - 以下を入力
        ```JSON
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::<開発環境アカウントのID>:root"
                    },
                    "Action": "events:PutEvents",
                    "Resource": "arn:aws:events:ap-northeast-1:<本番環境アカウントのID>:event-bus/default"
                }
            ]
        }
        ```
- イベントルールの設定
    - イベントパターンは以下のとおり
        ```JSON
        {
            "account": ["<開発環境アカウントのID>"]
        }
        ```
    - ターゲットとして作成したパイプラインを設定

### 開発環境側の設定
- 割り当てるロールとして以下を作成
    - ロール
        ```JSON
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "events:PutEvents",
                    "Effect": "Allow",
                    "Resource": "arn:aws:events:ap-northeast-1:<本番環境アカウントのID>:event-bus/default"
                }
            ]
        }
        ```
    - 信頼ポリシー
        ```JSON
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "events.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
        ```
- ルールの作成
    - ルールタイプは`イベントパターンを持つルール`
    - イベントソースは`その他`, `カスタムパターン`
    - イベントパターンとして以下を入力
        ```JSON
        {
            "detail": {
                "event": ["referenceCreated", "referenceUpdated"],
                "referenceName": ["<検知したいブランチ名>"],
                "referenceType": ["branch"]
            },
            "detail-type": [ "CodeCommit Repository State Change" ],
            "resource": ["<CodeCommitのレポジトリ名>"],
            "source": ["aws.codecommit"]
        }
        ```
    - ターゲットは以下の通り
        - ターゲットタイプ: `EventBridgeイベントバス`, `別のアカウントまたはリージョンのイベントバス`
        - ターゲットとしてのイベントバス: `arn:aws:events:ap-northeast-1:<本番環境アカウントのID>:event-bus/default`
        - ロールは先ほど作成したものを割り当てる
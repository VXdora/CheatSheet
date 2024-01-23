# ECSへのCodeDeployメモ

## 概要
- ECSへのデプロイ方法は2つ
    - ローリングアップデート
    - Blue/Greenアップデート

## ローリングアップデート
- 一部のコンテナを順々にアップデート，徐々に更新していく
- CodeDeployの利用は不可
    - CodePipelineのデプロイで，直接ECSを選択してあげる必要がある
- デプロイ時に必要なファイルは，`imagedefinitions.json`のみ
    - buildspec.ymlの書き方は以下の通り．
        ```YAML
        version: 0.2

        phases:
        pre_build:
            commands:
            - aws --version
            - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
            - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
            - IMAGE_TAG=${COMMIT_HASH:=latest}
        build:
            commands:
            - docker build -t $REPOSITORY_URI:latest .
            - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
        post_build:
            commands:
            - docker push $REPOSITORY_URI:latest
            - docker push $REPOSITORY_URI:$IMAGE_TAG
            - printf '[{"name":"%s","imageUri":"%s"}]' $CONTAINER_NAME $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
        artifacts:
            files: 
            - imagedefinitions.json
        ```


## Blue/Greenデプロイ
- 稼働中のコンテナ群とは別にアップデート済みのコンテナ群を作成，ルーティングを切り替えることでデプロイ
- デプロイ時にはCodeDeployを利用する必要がある
- デプロイ時に必要なファイルは，`imageDetail.json`，`taskdef.json`，`appspec.yml`の3つ．
    - buildspec.ymlの書き方は以下の通り
        ```YAML
        version: 0.2
        phases:
        pre_build:
            commands:
            - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
            - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
            - IMAGE_TAG=${COMMIT_HASH:=latest}
        build:
            commands:
            - docker build -t $REPOSITORY_URI:latest .
            - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
        post_build:
            commands:
            - docker push $REPOSITORY_URI:$IMAGE_TAG
            - docker push $REPOSITORY_URI:latest
            - printf '{"ImageURI":"%s"}' $REPOSITORY_URI:$IMAGE_TAG > imageDetail.json
            - sed -i -e "s#<TASK_FAMILY>#$TASK_FAMILY#" taskdef.json
            - sed -i -e "s#<TASK_ROLE_ARN>#$TASK_ROLE_ARN#" taskdef.json
            - sed -i -e "s#<EXECUTION_ROLE_ARN>#$EXECUTION_ROLE_ARN#" taskdef.json
            - sed -i -e "s#<CONTAINER_NAME>#$CONTAINER_NAME#" taskdef.json
            - sed -i -e "s#<CONTAINER_NAME>#$CONTAINER_NAME#" appspec.yaml
        artifacts:
            files:
            - imageDetail.json
            - taskdef.json
            - appspec.yaml
        ```
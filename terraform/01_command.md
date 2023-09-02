# Terraformコマンド一覧
## terraform init
terraform関連の初期化コマンド．

## terraform fmt
記述されたコードを整形してくれる．

## terraform plan
どこが変更されたか，記述に問題ないか，などを確認．

## terraform apply
実際にクラウド上にインフラを構築する．
なお，`-auto-approve`を使用すると，`yes`を打たなくてすむ．

## terraform destroy
クラウドに構築された環境を一気に削除できる（便利）．
なお，`-auto-approve`を使用すると，`yes`を打たなくてすむ．


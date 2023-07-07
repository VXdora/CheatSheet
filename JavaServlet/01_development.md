# プロジェクトの作成

## プロジェクト新規作成
vscodeのコマンドパレット(Ctrl + Shift + P)から，「Maven: Create Maven Project」を選択し，「maven-archetype-webapp」を選択，1.4を選択．
適当にEnterを押し，yを押すとプロジェクトが生成される．

## コンパイル他
VScodeのEXPLORERパレットの下のほうにMAVENがあるので，そこを開くと，「<プロジェクト名> Maven Webapp」とある．

右クリック，「Run Maven Commands」から色々できる．

### compile
### package
このコマンドでwarファイルが作られる．
あとは，このwarファイルをtomcat\webappsに放り込めばtomcatでみられる．
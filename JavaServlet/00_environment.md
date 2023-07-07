# JavaServletでの環境構築(windows + vscode + xampp + tomcat + maven)
JavaServletをwindowsで動かす方法です．
eclipseは嫌いなので，vscode + mavenを用います．

## ツール
- OS: windows
- vscode
- xampp
- tomcat
- maven

## xamppのインストール
xamppはapacheディストリビューション．
MariaDB，PHP，Tomcatなどがデフォルトで入っている．

### インストール
[xampp](https://www.apachefriends.org/jp/index.html)からダウンロード．

### tomcatにパスを通す
Win+Sで「環境変数」と入力し，Enter．
環境変数から，システム環境変数に，
- 変数：CATALINA_HOME
- 値：C:\xampp\tomcat
を追加．

また，ユーザ環境変数に，
- 変数：Path
- 値：%CATALINA_HOME%\bin
を追加．

### tomcatの管理者を追加
C:\xampp\tomcat\conf\tomcat-users.xmlを編集．
`<tomcat-users></tomcat-users>`に以下を追加．

```xml
<role rolename="manager-gui">
<role username="admin" passwod="pass" roles="manage-gui" />
```

### tomcatの起動
C:\xampp\xampp-control.exeを開くと一番下にtomcatがあるので，「Start」を押すとtomcatが起動する．

また，Adminを押すと，tomcatのメインページが立ち上がる．
そこで，画面上部の緑塗りの欄の「ManagerApp」を押すとユーザ名とパスワードが聞かれるので，先ほど設定した，adminとpassで入れる．


## Java(JDK)の設定
### インストール
[jdk-20](https://www.oracle.com/jp/java/technologies/downloads/#jdk20-windows)
から「x64 installer」をダウンロードして，インストール．

### JDKにパスを通す
Win+Sで「環境変数」と入力し，Enter．
環境変数から，システム環境変数に，
- 変数：JAVA_HOME
- 値：C:\Program Files\Java\jdk-20
を追加．

また，ユーザ環境変数に，
- 変数：Path
- 値：%JAVA_HOME%\bin
を追加．

## mavenの設定
### インストール
[maven](https://maven.apache.org/download.cgi)から，Binary zip archive版をダウンロード．
C:\Program Files\apache-maven-3.9.3あたりにでも展開して放り込んでおく．

### mavenにパスを通す
Win+Sで「環境変数」と入力し，Enter．
ユーザ環境変数に，
- 変数：Path
- 値：C:\Program Files\apache-maven-3.9.3\bin
を追加．

## vscodeの設定
### 拡張機能のインストール
「Extension Pack for Java」を追加．


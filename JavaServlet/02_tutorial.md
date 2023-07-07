# tutorial
簡単なWebアプリを作るまで．

## pom.xmlの編集
controllerでjavax.servlet関連を使えるように設定する．
pom.xmlの`<dependencies>`直下に以下のコードを記述．

```xml
  <dependencies>
    ...
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>
    ...
  </dependencies>
```

## Controllerの作成
src/main直下に，java/com/example/servletを作成し，そこにMyServlet.javaを作成．
なお，ファイル名(MyServlet.java)とexampleは他の名前でもOK．

MyServlet.javaは以下の通り．
```Java
package com.tomcattest.servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

@WebServlet("/my-servlet/*")
public class MyServlet extends HttpServlet {
    public MyServlet() {
        super();
    }
    
    // getメソッドの設定
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    }
}
```

なお，使えるメソッドは以下の通り．
- protected void doGet(HttpServletRequest req, HttpServletResponse resp)
- protected void doPost(HttpServletRequest req, HttpServletResponse resp)
- protected void doPut(HttpServletRequest req, HttpServletResponse resp)
- protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
- protected void doHead(HttpServletRequest req, HttpServletResponse resp)
- protected void doTrace(HttpServletRequest req, HttpServletResponse resp)
- protected void doOptions(HttpServletRequest req, HttpServletResponse resp)


## ルーティングの設定
web.xmlに以下の記述を追加．
```xml
<web-app>
    ...
  <servlet>
    <servlet-name>MyServlet</servlet-name>
    <servlet-class>com.example.servlet.MyServlet</servlet-class>
  </servlet>

  <servlet-mapping>
    <servlet-name>MyServlet</servlet-name>
    <url-pattern>/my-servlet/*</url-pattern>
  </servlet-mapping>
    ...
</web-app>
```
<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-11-11
  Time: 오후 5:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Find Password</title>
    <link rel="stylesheet" href="../../../resources/css/findpw-form.css">
</head>
<body>
<div class="container">
  <h1>WORKUS</h1>
  <h2 class="main-subtitle">비밀번호 찾기</h2>

  <h3>본인인증</h3>

  <form action="" method="post">
    <div class="input__block">
      <input type="text" placeholder="사번을 입력해주세요" name="userNo" required />
    </div>
    <div class="input__block">
      <input type="text" placeholder="아이디를 입력해주세요" name="userId" required />
      <button type="button" class="google__btn">인증하기</button>
    </div>
  </form>

  <h3>임시비밀번호 발급</h3>

  <form action="" method="post">
    <div class="input__block">
      <input type="email" placeholder="임시비밀번호를 발급받을 이메일을 입력해주세요" name="email" required />
      <button type="button" class="google__btn">발급받기</button>
    </div>
  </form>
</div>
</body>
</html>

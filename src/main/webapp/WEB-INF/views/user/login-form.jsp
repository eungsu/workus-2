<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/tags.jsp" %>
<%@ include file="../common/common.jsp" %>
<html>
<head>
    <title>WorkUs Login Page</title>
    <link rel="stylesheet" href="../../../resources/css/login-form.css">
</head>
<body>
<div class="container">
    <!-- Heading -->
    <h1>WORKUS</h1>

    <c:choose>
        <c:when test="${param.error eq 'fail' }">
            <div class="alert alert-danger">
                아이디 혹은 비밀번호가 일치하지 않습니다.
            </div>
        </c:when>
        <c:when test="${param.error eq 'required' }">
            <div class="alert alert-danger">
                로그인 후 이용가능한 서비스를 요청하였습니다.
            </div>
        </c:when>
        <c:when test="${param.error eq 'expired' }">
            <div class="alert alert-danger">
                세션이 만료되었습니다. 다시 로그인 부탁드립니다.
            </div>
        </c:when>
        <c:when test="${param.error eq 'access-denied' }">
            <div class="alert alert-danger">
                접근권한이 필요한 서비스를 요청하였습니다.
            </div>
        </c:when>
    </c:choose>

    <!-- Links -->
    <ul class="links">
        <li>
            <a href="/login" id="signin">로그인</a>
        </li>
        <li>
            <a href="/signup" id="signup">회원가입</a>
        </li>
        <li>
            <a href="/findpw" id="reset">비밀번호 찾기</a>
        </li>
    </ul>

    <!-- Form -->
    <form action="/login" method="post" novalidate="novalidate" id="login">
        <!-- email input -->
        <div class="first-input input__block first-input__block">
            <input type="text" placeholder="ID를 입력해주세요" class="input" name="id" id="id" />
        </div>
        <!-- password input -->
        <div class="input__block">
            <input type="password" placeholder="비밀번호를 입력해주세요" class="input" name="password" id="password"   />
        </div>
        <!-- sign in button -->
        <button class="signin__btn" type="submit">
            로그인
        </button>
    </form>
</div>
</body>
<footer>
</footer>
</html>

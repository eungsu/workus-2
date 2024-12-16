<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <%@ include file="../common/common.jsp" %>
  <link rel="stylesheet" href="../../../resources/css/myinfo-form.css">
  <title>workus template</title>
</head>
<body>

<div id="divWrapper">
  <div id="divContents">
    <%@ include file="../common/header.jsp" %>
    <section class="verticalLayoutFixedSection">
      <%@ include file="../common/nav.jsp" %>
      <div class="lnb" style="position: fixed;">

        <!-- LNB 메뉴 -->
        <div class="lnb-menu">
          <!-- 직원정보 관리 시스템 -->
          <p class="listTitle">내 정보 수정</p>
          <label class="menu-label">
            <input class="checkbox-input" type="checkbox" id="division1">
            <a href="/user/myinfo">일반 정보 변경</a>
          </label>
          <label class="menu-label">
            <input class="checkbox-input" type="checkbox" checked="checked" id="division2">
            <a href="/user/changePw">비밀번호 변경</a>
          </label>
          <label class="menu-label">
            <input class="checkbox-input" type="checkbox" id="division3">
            <a href="/user/changePhone">연락처 변경</a>
          </label>
        </div>

      </div>
      <main>
        <!-- 비밀번호 변경이 성공했을 때만 성공 메세지를 보여준다. -->
        <c:if test="${not empty message}">
          <div class="alert alert-success">${message}</div>
        </c:if>

        <h3 class="title1">비밀번호 변경</h3>
        <div class="content">
          <!-- 파일 전송을 위한 multipart/form-data 처리 -->
          <form action="/user/changePw" method="post" id="form-modify-myinfo">
            <!-- 로그인한 유저의 사번을 form 제출 시마다 제출한다. -->
            <input type="hidden" name="no" value="${LOGIN_USERNO}">

            <div class="input__block">
              <input placeholder="비밀번호는 영문자, 숫자가 포함되어야 하며, 8 ~ 20자리만 입력가능합니다." id="user-pw" name="password" />
            </div>

            <div class="input__block">
              <input placeholder="비밀번호를 다시 입력해주세요" id="user-confirmpw" name="passwordConfirm" />
              <button type="button" class="google__btn password-check">비밀번호 확인</button>
            </div>

            <button class="signup__btn" type="submit">비밀번호 변경</button>

          </form>
        </div>
      </main>
    </section>
  </div>
</div>
<script>
  // 비밀번호 확인
  $('.password-check').click(function() {
    checkPassword = false;
    const userPw = $('input[name="password"]').val();
    const userConfirmPw = $('input[name="passwordConfirm"]').val();
    const pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d!@#$%^&*()_+={}:;"'<>,.?/~`-]{8,20}$/; // 비밀번호의 정규식 패턴

    if ((!pwPattern.test(userPw)) || (!pwPattern.test(userConfirmPw))) { // 패턴이 맞지 않으면
      alert("비밀번호는 영문자, 숫자, 특수문자가 포함되며 총 길이는 8자리 이상 20자리 이하입니다.");
      return;
    }

    if (userPw === userConfirmPw) { // 비밀번호와 비밀번호 확인이 같으면
      alert("비밀번호가 일치합니다.");
      checkPassword = true;
    } else {
      alert("비밀번호가 일치하지 않습니다.");
    }
  });

  // 비밀번호 또는 비밀번호 확인 입력값 변경 시 재검사
  $('#user-pw').on('input', function() {
    checkPassword = false;
  });

  $('#user-confirmpw').on('input', function() {
    checkPassword = false;
  });

  let checkPassword = false;

  // 폼 입력 시 검증
  $('#form-modify-myinfo').submit(function() {
    if (!checkPassword) {
      alert("비밀번호 확인이 완료되지 않았습니다.");
      return false;
    }
    return true;
  });
</script>
</body>
</html>
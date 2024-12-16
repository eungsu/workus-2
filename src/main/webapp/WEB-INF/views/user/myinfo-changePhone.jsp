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
            <input class="checkbox-input" type="checkbox" id="division2">
            <a href="/user/changePw">비밀번호 변경</a>
          </label>
          <label class="menu-label">
            <input class="checkbox-input" type="checkbox" checked="checked" id="division3">
            <a href="/user/changePhone">연락처 변경</a>
          </label>
        </div>

      </div>
      <main>
        <!-- 연락처 변경이 성공했을 때만, 보여주는 성공메시지 -->
        <c:if test="${not empty message}">
          <div class="alert alert-success">${message}</div>
        </c:if>

        <h3 class="title1">연락처 변경</h3>
        <div class="content">
          <!-- 파일 전송을 위한 multipart/form-data 처리 -->
          <form action="/user/changePhone" method="post" id="form-modify-myinfo">
            <!-- 로그인한 유저의 사번을 form 제출 시마다 제출한다. -->
            <input type="hidden" name="no" value="${LOGIN_USERNO}">

            <div class="input__block">
              <input placeholder="본인 명의의 휴대폰 번호를 숫자만 입력해주세요." id="user-phone" name="phone" />
            <button type="button" class="google__btn send-code">인증번호 전송</button>
            </div>

            <div class="input__block">
              <input type="hidden" value="" id="real_verification_code"/>
              <input type="text" id="input_verification_code" placeholder="인증번호를 입력해주세요"/>
              <button type="button" class="google__btn confirm-code">인증번호 확인</button>
            </div>

            <button class="signup__btn" type="submit">연락처 변경</button>

          </form>
        </div>
      </main>
    </section>
  </div>
</div>
<script>
  // 연락처 입력 및 휴대폰 인증 번호 전송
  $('.send-code').click(function(){
    const phoneNumber = $('input[name="phone"]').val();
    const phoneNumberPattern = /^01[0-1][0-9]{3,4}[0-9]{4}$/;

    // 휴대폰 번호가 패턴에 맞는지 검사한다.
    if(!phoneNumberPattern.test(phoneNumber)) {
      alert("올바른 휴대폰 번호를 입력해주세요.");
      return;
    }

    $.ajax({ // 인증 문자 보내기
      url: `/ajax/send-sms`,
      method: 'GET',
      data: { phoneNumber: phoneNumber },// GET 방식으로 전화번호 전달
      error: function(xhr, status, error) {
        alert("서버 오류가 발생했습니다. 다시 시도해 주세요.");
      },
      success: function(data) {
        if (data.success) {
          alert("인증번호가 전송되었습니다.");
          $('#real_verification_code').val(data.checkNum); // 여기서 hidden으로 설정한 곳에 값을 담는다.
        } else {
          alert("인증번호 전송에 실패했습니다. ");
        }
      }
    });

  });

  // 인증번호 검증
  $('.confirm-code').click(function() {
    checkCertificationCode = false;
    const realConfirmCode = $('#real_verification_code').val();
    const inputConfirmCode = $('#input_verification_code').val();

    if (realConfirmCode === "") {
      alert("인증을 진행해주세요.");
    } else {
      if (inputConfirmCode === "") {
        alert("인증번호를 입력해주세요.");
      } else {
        if (inputConfirmCode === realConfirmCode) {
          alert("인증번호가 일치합니다.");
          checkCertificationCode = true;
        } else {
          alert("인증번호가 일치하지 않습니다.");
        }
      }
    }
  });

  // 폼 입력 시 검증
  $('#form-modify-myinfo').submit(function() {
    if (!checkCertificationCode) {
      alert("휴대폰 인증이 필요합니다.");
      return false;
    }
  });
</script>
</body>
</html>
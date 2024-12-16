<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-11-11
  Time: 오후 2:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SignUp page</title>
    <link rel="stylesheet" href="../../../resources/css/signup-form.css">
</head>
<body>
<div class="container">
    <h1>WORKUS</h1>

    <h2>회원가입</h2>

    <form:form id="form-signup" action="/signup" method="post" modelAttribute="signupForm" >

        <div class="input__block">
            <form:input placeholder="회사 사번을 - 없이 입력해주세요" id="user-no" path="no" />
            <button type="button" class="google__btn user-check">사번확인</button>
        </div>

        <div class="input__block">
            <form:input placeholder="아이디는 영문자로 시작하고, 영문자나 숫자만 포함가능하며, 최대 18자입니다." id="user-id" path="id" />
            <button type="button" class="google__btn id-check">중복확인</button>
        </div>

        <div class="input__block">
            <form:password placeholder="비밀번호는 영문자, 숫자가 포함되어야 하며, 8 ~ 20자리만 입력가능합니다." id="user-pw" path="password" />
        </div>

        <div class="input__block">
            <form:password placeholder="비밀번호를 다시 입력해주세요" id="user-confirmpw" path="passwordConfirm" />
            <button type="button" class="google__btn password-check">비밀번호 확인</button>
        </div>

        <div class="input__block">
            <form:input placeholder="본인 명의의 휴대폰 번호를 숫자만 입력해주세요." id="user-phone" path="phone" />
            <button type="button" class="google__btn send-code">인증번호 전송</button>
        </div>

        <div class="input__block">
            <input type="hidden" value="" id="real_verification_code"/>
            <input type="text" id="input_verification_code" placeholder="인증번호를 입력해주세요"/>
            <button type="button" class="google__btn confirm-code">인증번호 확인</button>
        </div>

        <div class="input__block">
            <input type="text" placeholder="우편번호 찾기를 클릭해서 주소를 입력해주세요." name="postal_code" readonly="readonly" />
            <button type="button" class="google__btn" id="search-postcode">우편번호 찾기</button>
        </div>

        <div class="input__block">
            <form:input placeholder="주소" id="user-address" path="address" readonly="true"/>
        </div>

        <div class="input__block">
            <form:input placeholder="상세주소는 필수 입력값입니다." id="user-datail-address" path="detailAddress" />
        </div>

        <button class="signup__btn" type="submit">회원가입</button>

    </form:form>
</div>
<script>

    let checkNo = false;
    let checkId = false;
    let checkPassword = false;
    let checkCertificationCode = false;
    let checkAddress = false;

    $('#form-signup').submit(function() {
        if (!checkNo) {
            alert("사번확인이 완료되지 않았습니다.");
            return false;
        }
        if (!checkId) {
            alert("아이디 중복확인이 완료되지 않았습니다.");
            return false;
        }
        if (!checkPassword) {
            alert("비밀번호 확인이 완료되지 않았습니다.");
            return false;
        }
        if (!checkCertificationCode) {
            alert("휴대폰 인증이 필요합니다.");
            return false;
        }
        if (!checkAddress) {
            alert("우편번호를 통해 주소를 입력해주세요.");
            return false;
        }

        return true; // 다 통과했을 때만 회원가입을 Controller를 통해 진행
    });

    // 사번 확인
    $('.user-check').click(function() {
        checkNo = false;
        const userNo = $('input[name="no"]').val(); //

        if (isNaN(userNo) || userNo.trim() === "") { // 숫자가 아니거나 값이 비어있는지 확인
            alert("사번은 숫자만 입력 가능합니다.");
            return;
        }

        $.ajax({ // Ajax 요청 보내기
            url: `/ajax/user/check-no/` + userNo, // 사번을 URL에 추가
            method: 'GET', // GET 요청
            error: function(xhr, status, error) {
                alert("서버 오류가 발생했습니다. 다시 시도해 주세요.");
            },
            success: function(data) { // 응답 성공 시 실행
                if (data.data) {
                    alert("사번이 확인되었습니다.");
                    checkNo = true;
                } else {
                    alert("존재하지 않는 사번입니다.");
                }
            }
        });
    });

    // 사번 입력값 변경 시 다시 검사하도록 하기
    $('#user-no').on('input', function() { // input 필드에서 값이 바뀔 때마다
        checkNo = false;
    });

    // 아이디 확인
    $('.id-check').click(function() {
        checkId = false;
        const userId = $('input[name="id"]').val();
        const idPattern = /^[a-zA-Z][a-zA-Z0-9]{0,17}$/; // 아이디의 정규식 패턴

        if (!idPattern.test(userId)) { // 아이디가 패턴에 맞는지 확인
            alert("아이디는 영문자로 시작하고, 영문자나 숫자만 포함가능하며, 최대 18자입니다.");
            return;
        }

        $.ajax({ // Ajax 요청 보내기
            url: `/ajax/user/check-id/` + userId, // 아이디를 URL에 추가
            method: 'GET', // GET 요청
            error: function(xhr, status, error) {
                alert("서버 오류가 발생했습니다. 다시 시도해 주세요.");
            },
            success: function(data) {
                if (data.data) {
                    alert("이미 존재하는 아이디입니다.");
                } else {
                    alert("사용 가능한 아이디입니다.");
                    checkId = true;
                }
            }
        });
    });

    // 아이디 입력값 변경 시 다시 검사하도록 false
    $('#user-id').on('input', function() {
        checkId = false;
    });

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

    // 우편번호 검색 API 사용
    $(function() {
        $('#search-postcode').click(function (){
            new daum.Postcode({
                oncomplete: function(data) {
                    let address;
                    if (data.userSelectedType === 'R') { // 도로명 주소를 선택했을 때
                        address = data.roadAddress;
                    } else {
                        address = data.jibunAddress;
                    }

                    // 우편번호 입력필드와 기본주소 입력필드에 값을 입력하기
                    $('input[name=postal_code]').val(data.zonecode);
                    $('input[name=address]').val(address);

                    checkAddress = true;

                    // 상세주소 입력필드에 포커스 위치시키기
                    $('input[name=detailAddress]').focus();
                }
            }).open();
        });
    });
</script>
<!-- 다음 우편번호 검색 스크립트 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
</html>

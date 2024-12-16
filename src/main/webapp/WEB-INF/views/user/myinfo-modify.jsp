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
                        <input class="checkbox-input" type="checkbox" checked="checked" id="division1">
                        <a href="/user/myinfo">일반 정보 변경</a>
                    </label>
                    <label class="menu-label">
                        <input class="checkbox-input" type="checkbox" id="division2">
                        <a href="/user/changePw">비밀번호 변경</a>
                    </label>
                    <label class="menu-label">
                        <input class="checkbox-input" type="checkbox" id="division3">
                        <a href="/user/changePhone">연락처 변경</a>
                    </label>
                </div>

            </div>
            <main>
                <!-- 일반 정보 변경이 성공했을 때만, 보여주는 성공메시지 -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>

                <h3 class="title1">일반 정보 변경</h3>
                <div class="content">
                    <!-- 파일 전송을 위한 multipart/form-data 처리 -->
                    <form action="/user/myinfo" method="post" enctype="multipart/form-data" id="form-modify-myinfo">
                        <!-- 로그인한 유저의 사번을 form 제출 시마다 제출한다. -->
                        <input type="hidden" name="no" value="${LOGIN_USERNO}">
                        <div class="input__block" style="justify-content: center;">
                            <img src="/resources/repository/userprofile/${user.profileSrc}" alt="" class="profile-image" id="previewImage">
                            <input type="file" id="fileInput" class="file-input" name="image" accept="image/*">
                        </div>

                        <div class="input__block">
                            <textarea placeholder="자기소개를 입력해주세요" name="pr" >${user.pr}</textarea>
                        </div>

                        <div class="input__block">
                            <input type="text" placeholder="우편번호 찾기" name="postal_code" readonly="readonly" />
                            <button type="button" class="google__btn" id="search-postcode">우편번호 찾기</button>
                        </div>

                        <div class="input__block">
                            <input type="text" placeholder="주소" name="address" value="${user.address}"/>
                        </div>

                        <button class="signup__btn" type="submit">회원정보 수정</button>

                    </form>
                </div>
            </main>
        </section>
    </div>
</div>
<script>
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

                    // 주소 입력필드에 포커스 위치시키기
                    $('input[name=address]').focus();
                }
            }).open();
        });
    });
    // 프로필 사진 클릭 시 파일 선택창 열기
    $('.profile-image').click(function(e){ // 프로필 이미지를 클릭했을 때
        $('#fileInput').click(); // 파일 선택창이 열리도록 한다.
    });
    // 파일 선택창에서 파일 선택 시 이미지 미리보기
    $(document).ready(function() {
        $('#fileInput').on('change', function(event) { // 파일 입력창에 change 이벤트가 발생하면
            const file = event.target.files[0]; // 선택된 파일
            if (file) {
                const reader = new FileReader(); // FileReader 객체 생성
                reader.onload = function(e) {
                    $('#previewImage').attr('src', e.target.result); // 미리보기 이미지 설정
                }
                reader.readAsDataURL(file); // 파일을 Data URL 형태로 읽기
            }
        });
    });
</script>
<!-- 다음 우편번호 검색 스크립트 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
</html>
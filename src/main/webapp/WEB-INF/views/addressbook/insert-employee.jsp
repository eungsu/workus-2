<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="../common/tags.jsp" %>
<c:set var="menu" value="address-book"/>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <%@ include file="../common/common.jsp" %>
  <title>workus template</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="../../../resources/css/insertEmployee-form.css">
  <!-- 달력 UI용 flatpickr css -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
            <p class="listTitle">마이페이지</p>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" id="division1">
                <a href="/address-book/detail?no=${LOGIN_USERNO}">내 정보 보기</a>
            </label>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" id="division0">
                <a href="/user/myinfo">내 정보 수정</a>
            </label>

            <p class="listTitle">
                직원검색 시스템
            </p>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" id="division2">
                <a href="/address-book/list">직원 조회</a>
            </label>

            <p class="listTitle">
                인사관리 시스템
            </p>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" id="division3">
                <a href="/address-book/manage/list">직원 관리</a>
            </label>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" checked="checked" id="division4">
                <a href="/address-book/insert">직원 등록</a>
            </label>
        </div>

      </div>
      <main>

        <h3 class="title1">신규 직원 등록</h3>
        <p class="description">※ 우리 회사의 새로운 직원을 등록하세요 </p>
        <div class="content">

          <form id="form-insert-employee" enctype="multipart/form-data" action="/address-book/insert" method="post" >

            <div class="input__block" style="justify-content: center;">
                <label>프로필 사진</label>
                <img src="/resources/repository/userprofile/click.jpg" alt="" class="profile-image" id="previewImage"
                    style="width: 300px; height: 300px; border: 1px solid black; margin-left: 30px; margin-top: 20px; margin-bottom: 20px;">
                <input type="file" id="fileInput" class="file-input" name="image" accept="image/*">
            </div>

            <div class="input__block">
                <label>사번 발급</label>
                <input type="text" placeholder="회사 사번을 발급합니다." id="user-no" name="no" readonly/>
                <button type="button" class="google__btn user-check">사번발급</button>
            </div>

            <div class="input__block">
                <label>이름</label>
                <input type="text" placeholder="이름을 입력해주세요" id="user-name" name="name" />
            </div>

            <div class="input__block">
                <label>생년월일</label>
                <input type="date" placeholder="생년월일을 선택해주세요." id="user-birthDate" name="birthDate" />
            </div>

            <div class="input__block">
                <label>입사일</label>
                <input type="date" placeholder="입사일을 입력해주세요." id="user-hireDate" name="hireDate" />
            </div>

            <div class="input__block">
                <label>부서</label>
                <select class="filter-select" id="user-department" name="deptNo">
                      <option value="1001">인사팀</option>
                      <option value="1002">개발1팀</option>
                      <option value="1003">개발2팀</option>
                      <option value="1004">영업1팀</option>
                      <option value="1005">영업2팀</option>
                      <option value="1006">기술연구소</option>
                      <option value="1007">해외연구소</option>
                      <option value="1008">운영1팀</option>
                </select>
            </div>

            <div class="input__block">
                <label>직책</label>
                <select class="filter-select" id="user-position" name="positionNo">
                      <option value="11">사장</option>
                      <option value="12">부장</option>
                      <option value="13">과장</option>
                      <option value="14">대리</option>
                      <option value="15">사원</option>
                </select>
            </div>

            <div class="input__block">
                <label>권한</label>
                <input type="text" placeholder="권한은 부서/직급에 따라 부여됩니다." id="user-role" name="roleNo" readonly />
                <button type="button" class="google__btn role_check">권한 부여</button>
            </div>

            <div class="input__block">
                <label>연차 일수</label>
                <input type="text" placeholder="잔여 연차일수는 자동으로 계산됩니다" id="user-annual_leave" name="unusedAnnualLeave" readonly />
                <button type="button" class="google__btn annual_leave_check">연차 계산</button>
            </div>

            <button class="signup__btn" type="submit">신규 사원 등록</button>

          </form>
        </div>
      </main>
    </section>
  </div>
</div>
<!-- 달력 UI용 flatpickr js -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<!-- flatpickr 한글 커스텀용 js -->
<script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>
<script>
    // 폼 제출을 눌렀을 때 유효성 검사를 실시한다.
    $('#form-insert-employee').submit(function(event) {
        const fileInput = $('#fileInput');
        const no = $('#user-no').val();
        const name = $('#user-name').val();
        const birthDate = $('#user-birthDate').val();
        const hireDate = $('#user-hireDate').val();
        const dept = $('#user-department').val();
        const position = $('#user-position').val();
        const annualLeave = $('#user-annual_leave').val();
        const roleNo = $('#user-role').val();

        // 파일이 선택되지 않았다면
        if (fileInput[0].files.length === 0) {
            alert("프로필 사진을 선택해주세요."); // 경고 메세지
            return false;
        }

        // 사번을 입력하지 않았다면
        if (no === null || no === "") {
            alert("사번은 필수 입력값입니다. 사번 발급을 진행해주세요."); // 경고 메세지
            return false;
        }

        // 이름을 입력하지 않았으면
        if (name === null || name === "") {
            alert("이름은 필수 입력값입니다."); // 경고 메세지
             return false;
        }

        // 생년월일을 입력하지 않았으면
        if (birthDate === null || birthDate === "") {
            alert("생년월일은 필수 입력값입니다.");
            return false;
        }

        // 입사일을 입력하지 않았으면
        if (hireDate === null || hireDate === "") {
            alert("입사일은 필수 입력값입니다.")
            return false;
        }

        // 연차일수를 입력하지 않았으면
        if (annualLeave === null || annualLeave === "") {
            alert("연차 일수는 필수 입력값입니다.");
            return false;
        }

        // 권한을 체크하지 않았으면
        if (roleNo === null || roleNo === "") {
            alert("권한체크를 통해 권한을 입력해주세요.");
            return false;
        }

        // 모든 유효성 검증을 통과해야만 제출처리한다.
        return true;

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
    // 사번 발급 클릭 시
    $('.user-check').click(function() {
        $.ajax({ // ajax 요청 보내기
            url: '/ajax/user/get-sequence/userNo', // 다음에 들어갈 사번 시퀀스 요청
            method: 'GET', // GET 요청
            error: function(xhr, status, error) {
                alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
            },
            success: function(data) { // 응답 성공 시 실행
                if (data.data !== null) {
                    $('#user-no').val(data.data); // readonly 필드에 사번 대입
                    alert("사번이 발급되었습니다.");
                } else {
                    alert("조회에 실패했습니다.");
                }
            }
        })
    });
    // 기본 연차 개수 체크 시
    $('.annual_leave_check').click(function() {
        let positionNo = $('#user-position').val(); // 사용자가 입력한 직책 번호
        $.ajax({
            url: '/ajax/user/count-annualLeave/' + positionNo,
            method: 'GET',
            error: function(xhr, status, error) {
                alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
            },
            success: function(data) {
                if (data.data !== null) {
                    $('#user-annual_leave').val(data.data); // readonly 필드에 연차 수 대입
                    alert("직책의 기본 연차수가 입력됩니다.");
                } else {
                    alert("직책 기본 연차수 조회에 실패했습니다.");
                }
            }

        })
    });
    // 권한 부여 클릭 시 ( DB 조회 필요없음 )
    $('.role_check').click(function(){
        const dept = $('#user-department').val(); // 부서 번호
        const position = $('#user-position').val(); // 직책 번호

        if (Number(dept) === 1001 && Number(position) === 12) { // 인사팀이면서 부장이면
            alert("권한이 부여되었습니다.");
            $('#user-role').val(100); // role 입력 필드에 100
        } else if (Number(dept) === 1001 && Number(position) !== 12) { // 인사팀인데 부장이 아니면
            alert("권한이 부여되었습니다.");
            $('#user-role').val(200); // role 입력 필드에 200
        } else if ((Number(dept) !== 1001 && Number(position) === 12) || (Number(position) === 11) ) { // 인사팀은 아니면서 부장이거나 또는 사장이면
            alert("권한이 부여되었습니다.");
            $('#user-role').val(300); // role 입력 필드에 300
        } else {
            alert("권한이 부여되었습니다.");
            $('#user-role').val(400); // role 입력 필드에 400
        }
    });
    // 부서랑 직책 선택 시
    flatpickr("#user-birthDate", { // 생년월일에 한글 locale 적용
        locale: "ko"
    });

    flatpickr("#user-hireDate", { // 입사일에 한글 locale 적용
        locale: "ko"
    });
</script>
</body>
</html>
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
  <link rel="stylesheet" href="../../../resources/css/insertEmployee-form.css?v=1.0">
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
                <input class="checkbox-input" type="checkbox" checked="checked" id="division2">
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
                <input class="checkbox-input" type="checkbox" id="division4">
                <a href="/address-book/insert">직원 등록</a>
            </label>
        </div>

      </div>

      <main>
        <!-- 신규 회원 등록이 성공했을 때만 성공 메세지를 보여준다. -->
        <c:if test="${not empty insert}">
          <div class="alert alert-success">${insert}</div>
        </c:if>
        <h3 class="title1">직원 상세 정보</h3>
        <p class="description">※ 직원의 상세 정보를 확인해보세요. </p>

        <img loading="lazy" src="/resources/repository/userprofile/${user.profileSrc}" alt="${user.profileSrc}"
        style="width: 300px; height: 300px; border: 1px solid black; margin-left: 200px; margin-top: 20px; margin-bottom: 20px;"/>

        <div class="content">

            <div class="input__block">
                <label>사번</label>
                <input type="text" placeholder="정보가 없습니다." id="user-no" name="no" value="${user.no}"readonly/>
                <label>이름</label>
                <input type="text" placeholder="정보가 없습니다." id="user-name" name="name" value="${user.name}" readonly/>
            </div>

            <div class="input__block">
                <label>생년월일</label>
                <fmt:formatDate value="${user.birthday}" pattern="yyyy년 MM월 dd일" var="formattedBirthday" />
                <input type="text" placeholder="정보가 없습니다." id="user-birthdate" name="birthDate" value="${formattedBirthday}" readonly/>
                <label>입사일</label>
                <fmt:formatDate value="${user.hireDate}" pattern="yyyy년 MM월 dd일" var="formattedHireDate" />
                <input type="text" placeholder="정보가 없습니다." id="user-hireDate" name="hireDate" value="${formattedHireDate}" readonly/>
            </div>

            <div class="input__block">
                <label>부서</label>
                <input type="text" placeholder="정보가 없습니다." id="user-department" name="department" value="${user.deptName}" readonly/>
                <label>직책</label>
                <input type="text" placeholder="정보가 없습니다." id="user-position" name="position" value="${user.positionName}" readonly/>
            </div>

            <div class="input__block">
                <label>이메일</label>
                <input type="text" placeholder="정보가 없습니다." id="user-email" name="email" value="${user.email}" readonly />
                <label>재직 상태</label>
                <input type="text" placeholder="정보가 없습니다." id="user-status" name="status" value="${user.status == 'Y' ? '재직중' : (user.status == 'P' ? '휴직중' : (user.status == 'Q' ? '퇴직' : ''))}" readonly />
            </div>

            <div class="input__block">
                <!-- 휴직 중일 때만 휴직일이 보이도록 -->
                <c:if test="${user.status == 'P'}">
                    <label>휴직일</label>
                    <input type="text" placeholder="정보가 없습니다." id="user-leave-date" name="leaveDate" value="${user.leaveDate}" readonly />
                </c:if>
                <!-- 퇴직 상태일 때만 퇴직일이 보이도록 -->
                <c:if test="${user.status == 'Q'}">
                    <label>퇴직일</label>
                    <input type="text" placeholder="정보가 없습니다." id="user-quit-date" name="quitDate" value="${user.quitDate}" readonly />
                </c:if>
            </div>

            <div class="input__block">
                <label>연락처</label>
                <input type="text" placeholder="정보가 없습니다." id="user-phone" name="phone" value="${user.phone}" readonly />
                <label>잔여 연차</label>
                <input type="text" placeholder="정보가 없습니다." id="user-annual_leave" name="unusedAnnualLeave" value="${user.unusedAnnualLeave} 일" readonly />
            </div>

            <div class="input__block">
                <label>주소</label>
                <input type="text" placeholder="정보가 없습니다." id="user-address" name="address" value="${user.address}" style="width: 585px;" readonly/>
            </div>

            <div class="input__block">
                <label>자기소개</label>
                    <textarea id="user-pr" name="pr" rows="10" style="width: 585px; height:auto; padding-right: 10px;" readonly> ${user.pr != null ? user.pr : '정보가 없습니다.'}
                    </textarea>
            </div>

        </div>
      </main>
    </section>
  </div>
</div>
<script>
</script>
</body>
</html>
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
  <link rel="stylesheet" href="../../../resources/css/address-book.css">
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
                <input class="checkbox-input" type="checkbox" checked="checked" id="division3">
                <a href="/address-book/manage/list">직원 관리</a>
            </label>
            <label class="menu-label">
                <input class="checkbox-input" type="checkbox" id="division4">
                <a href="/address-book/insert">직원 등록</a>
            </label>
        </div>

      </div>
      <main>
        <h3 class="title1">인사관리 시스템</h3>
        <p class="description">※ 재직/ 휴직/ 퇴직 직원을 관리할 수 있습니다.</p>
        <p class="description">※ 직원명을 입력하지 않을 시, 해당 부서의 모든 직원이 검색됩니다.</p>
        <p class="description">※ 관리를 원하는 직원의 이름을 클릭해주세요.</p>
        <div class="content">
          <section class="member-search-container">
            <!-- 검색 바 -->
            <form id="form-search" method="get" action="/address-book/manage/list">
            <input type="hidden" name="page"/>
            <div class="search-bar-wrapper">
              <div class="search-input-wrapper" style="display: flex; align-items: center;">
                <i class="fas fa-search icon" style="margin-right: 10px;"></i> <!-- 돋보기 아이콘 -->
                <select class="filter-select" style="margin-right: 10px;" name="status">
                  <option value="all">모두</option>
                  <option value="Y" ${param.status eq 'Y' ? 'selected' : ''}>재직</option>
                  <option value="P" ${param.status eq 'P' ? 'selected' : ''}>휴직</option>
                  <option value="Q" ${param.status eq 'Q' ? 'selected' : ''}>퇴직</option>
                </select>
                <select class="filter-select" style="margin-right: 10px;" name="dept">
                  <option value="all">모두</option>
                  <option value="1001" ${param.dept eq '1001' ? 'selected' : ''}>인사팀</option>
                  <option value="1002" ${param.dept eq '1002' ? 'selected' : ''}>개발1팀</option>
                  <option value="1003" ${param.dept eq '1003' ? 'selected' : ''}>개발2팀</option>
                  <option value="1004" ${param.dept eq '1004' ? 'selected' : ''}>영업1팀</option>
                  <option value="1005" ${param.dept eq '1005' ? 'selected' : ''}>영업2팀</option>
                  <option value="1006" ${param.dept eq '1006' ? 'selected' : ''}>기술연구소</option>
                  <option value="1007" ${param.dept eq '1007' ? 'selected' : ''}>해외연구소</option>
                  <option value="1008" ${param.dept eq '1008' ? 'selected' : ''}>운영1팀</option>
                </select>
                <input type="text" class="search-input" placeholder="직원명" name="name" value="${param.name}"/>
              </div>
              <button class="search-button" type="button">
                <span class="button-text">검색</span>
              </button>
            </div>
            </form>

            <!-- 컨텐츠 불러오기 -->
            <c:choose>
              <c:when test="${empty userList}">
                <span class="search-result-info"><strong>조회된 사원이 없습니다.</strong></span>
              </c:when>
              <c:otherwise>
                <span class="search-result-info"><strong>총 ${paging.totalRows}명이 조회되었습니다.</strong></span>
                <!-- Testimonials 그리드 -->
                <div class="testimonial-grid">
                  <!-- 각 testimonial 카드 -->
                  <c:forEach var="user" items="${userList}">
                  <article class="testimonial-card">
                    <div class="avatar-block">
                      <!-- 사진 링크는 src에 적는다. -->
                      <!-- webapp까지는 알아서 찾아주니깐 /resources부터 적기 -->
                      <a href="/resources/repository/userprofile/${user.profileSrc}" target="_blank">
                        <img loading="lazy" src="/resources/repository/userprofile/${user.profileSrc}" class="avatar-image" alt="" />
                      </a>
                      <div class="info-block">
                        <h3 class="info-title"><a href="/address-book/modify?no=${user.no}">${user.name}</a></h3>
                        <p class="info-description">
                            ${user.deptName}&nbsp;${user.positionName}</p>
                        <p class="contact-info">Email: ${user.email}<br>연락처: ${user.phone}</p>
                        <p class="address-info">주소: ${user.address}</p>
                      </div>
                    </div>
                  </article>
                  </c:forEach>
                </div>

              </c:otherwise>

            </c:choose>

            <c:if test="${not empty userList}">
            <!-- data-page를 저장해둬야 조회해올 수 있다. -->
              <nav>
                <ul class="pagination justify-content-center">
                  <li class="page-item ${paging.first ? 'disabled' : ''}">
                    <a class="page-link"
                       href="list?page=${paging.prevPage }" data-page="${paging.prevPage }">이전</a>
                  </li>

                <c:forEach var="num" begin="${paging.beginPage }" end="${paging.endPage }">
                   <li class="page-item ${paging.page eq num ? 'active' : '' }">
                      <a class="page-link"
                         href="list?page=${num }" data-page="${num }">${num }</a>
                   </li>
                </c:forEach>

                   <li class="page-item ${paging.last ? 'disabled' : ''}">
                      <a class="page-link"
                         href="list?page=${paging.nextPage }" data-page="${paging.nextPage }">다음</a>
                   </li>
                 </ul>
              </nav>
            </c:if>
        </div>
      </main>
    </section>
  </div>
</div>
<script>
  // 페이지 링크 클릭 시
  $(".page-link").click(function(e) {
      e.preventDefault(); // 제출을 막는다.
      let page = $(this).attr("data-page"); // this는 현재 이벤트가 발생한 DOM 요소,  attr()은 속성 값 관리

      $("input[name=page]").val(page);

      $("#form-search").submit();
  })

  // 검색 버튼 클릭 시
  $(".search-button").click(function(e) {
    let form = $("#form-search"); // 검색 폼
    let page = $("input[name=page]"); // 현재 페이지

    page.val(1); // 클릭 시에 현재 페이지는 1로 돌아간다.
    form.submit(); // 제출
  })
</script>
</body>
</html>
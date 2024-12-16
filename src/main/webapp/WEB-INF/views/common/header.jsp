<%@ page pageEncoding="UTF-8"%>
<%@ include file="tags.jsp" %>
<%-- SSE --%>
<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_MANAGER')">
<script src="/resources/js/sse.js"></script>
</sec:authorize>
<header class="layout header">
    <a href="/home" class="logo">
        <span>WORKUS</span>
    </a>
    <ul class="globalMenu d-flex">
        <li class="d-flex align-items-center">
        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal.no" var="LOGIN_USERNO" scope="request"/>
            <sec:authentication property="principal.id" var="LOGIN_USERID" scope="request"/>
            <sec:authentication property="principal.name" var="LOGIN_USERNAME" scope="request"/>
        </sec:authorize>
            ${LOGIN_USERNAME} 님 환영합니다.
            <a href="/user/myinfo" class="mgl5">
                <span class="badge text-bg-success modify">수정</span>
            </a>
        </li>
        <li class="d-flex align-items-center">
            <a href="/logout" class="mgl">
                <span class="badge text-bg-danger logout">로그아웃</span>
            </a>
        </li>
    </ul>
    <div id="notificationToast" class="toast fixed-top align-items-center text-bg-secondary border-0" role="alert"
     aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          신규 결재 요청이 있습니다.
        </div>
        <button type="button" class="btn-close btn-close-white toastClose me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
</header>



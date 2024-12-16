<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <link rel="stylesheet" href="${s3}/resources/css/approval.css">
    <script src="${s3}/resources/js/approval.js"></script>
    <!-- Include the Quill library -->
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
    <c:set var="menuTitle" value="종결건"/>
    <title>workus ㅣ 결재 ${menuTitle}</title>
</head>
<body>
<div id="divWrapper">
    <div id="divContents">
        <c:set var="menu" value="approval"/>
        <%@ include file="/WEB-INF/views/common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="/WEB-INF/views/common/nav.jsp" %>
            <c:set var="lnb" value="myEndList"/>
            <div class="lnb">
                <ul class="list1">
                    <li class="${lnb eq 'signOff' ? 'on' : '' }"><a
                            href="${pageContext.request.contextPath}/approval/form-list">결재 요청하기</a></li>
                    <li class="${lnb eq 'myReqList' ? 'on' : '' }"><a
                            href="${pageContext.request.contextPath}/approval/my/reqList">요청 내역</a></li>
                </ul>
                <sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_LEADER')">
                    <div class="approvalDepth accordion" id="accordionPanelsStayOpenExample">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse"
                                        data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false"
                                        aria-controls="panelsStayOpen-collapseOne">
                                    결재함
                                </button>
                            </h2>
                            <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse show">
                                <div class="accordion-body">
                                    <ul class="list2 myAtdList">
                                        <sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_MANAGER')">
                                            <li class="${lnb eq 'myWaitList' ? 'on' : '' }"><a
                                                    href="${pageContext.request.contextPath}/approval/my/waitList">대기건</a>
                                            </li>
                                            <li class="${lnb eq 'myEndList' ? 'on' : '' }"><a
                                                    href="${pageContext.request.contextPath}/approval/my/endList">종결건</a>
                                            </li>
                                            <li class="${lnb eq 'myDenyList' ? 'on' : '' }"><a
                                                    href="${pageContext.request.contextPath}/approval/my/denyList">반려건</a>
                                            </li>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('ROLE_LEADER')">
                                            <li class="${lnb eq 'myRefList' ? 'on' : '' }"><a
                                                    href="${pageContext.request.contextPath}/approval/my/refList">열람건</a>
                                            </li>
                                        </sec:authorize>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </sec:authorize>
            </div>
            <main>
                <h3 class="title1">
                    ${menuTitle}
                </h3>
                <%-- 승인 상태 메시지 표시 --%>
                <c:if test="${not empty message}">
                    <div class="alert alert-success mgt20">${message}</div>
                </c:if>
                <div id="reqListW" class="containerW">
                    <div class="tableW mgt40">
                        <c:choose>
                            <c:when test="${empty endList}">
                                <div class="noData">
                                    <img src="${s3}/resources/images/noDataImg.png" class="noDataImg"/>
                                    <p class="noDataText">조회된 내역이 없습니다.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table">
                                    <colgroup>
                                        <col style="width:5%"/>
                                        <col style="width:10%"/>
                                        <col style="width:15%"/>
                                        <col style="width:auto"/>
                                        <col style="width:15%"/>
                                        <col style="width:15%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>요청자</th>
                                        <th>신청 유형</th>
                                        <th>제목</th>
                                        <th>신청일</th>
                                        <th>상태</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="form" items="${endList }" varStatus="loop">
                                        <tr>
                                            <td>${loop.count }</td>
                                            <td>${form.reqUserName} [${form.reqUserDeptName}]</td>
                                            <td>${form.categoryName }</td>
                                            <td class="text-start">
                                                <a href="/approval/my/detail/endDetail?no=${form.no}"
                                                   class="link">${form.title}</a>
                                            </td>
                                            <td><fmt:formatDate value="${form.createdDate }"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${form.status == 'pending'}">
                                                        <span class="badge text-bg-primary">승인 대기</span>
                                                    </c:when>
                                                    <c:when test="${form.status == 'rejected'}">
                                                        <span class="badge text-bg-danger">반려</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge border bg-secondary">처리 완료</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </section>
    </div>
</div>
</body>
</html>
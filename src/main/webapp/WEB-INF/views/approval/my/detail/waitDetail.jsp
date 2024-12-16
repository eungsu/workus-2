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
    <c:set var="menuTitle" value="대기건"/>
    <title>workus ㅣ 결재 ${menuTitle}</title>
</head>
<body>
<div id="divWrapper">
    <div id="divContents">
        <c:set var="menu" value="approval"/>
        <%@ include file="/WEB-INF/views/common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="/WEB-INF/views/common/nav.jsp" %>
            <c:set var="lnb" value="myWaitList"/>
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
                <div id="apvListW" class="containerW">
                    <div class="tableW mgt40">
                        <form id="approvalForm" action="${pageContext.request.contextPath}/approval/approve" method="post">
                            <input type="hidden" name="no" value="${waitByNo.no}">
                            <input type="hidden" name="status" value="${waitByNo.status}">
                            <div class="btn-group mgb30" role="group" aria-label="Basic example">
                                <button type="submit" class="btn btn-secondary">승인</button>
                                <button type="button" class="btn btn-warning btn-custom2" data-bs-toggle="modal"
                                        data-bs-target="#exampleModal" data-bs-whatever="@mdo">반려
                                </button>
                            </div>
                            <table class="table tableStyle">
                                <tbody>
                                    <tr>
                                        <th class="table-active title">신청 기본 정보</th>
                                        <td colspan="5" class="text-start">
                                            [${waitByNo.categoryName}] ${waitByNo.title}
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">요청일</th>
                                        <td colspan="2" class="text-start">
                                            <fmt:formatDate value="${waitByNo.createdDate }"/>
                                        </td>
                                        <th class="table-active">요청 상태</th>
                                        <td colspan="2" class="text-start">
                                            <c:choose>
                                                <c:when test="${waitByNo.status == 'pending'}">
                                                    <span class="badge text-bg-primary">승인 대기</span>
                                                </c:when>
                                                <c:when test="${waitByNo.status == 'rejected'}">
                                                    <span class="badge text-bg-danger">반려</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge border bg-secondary">처리 완료</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <table class="table tableStyle">
                                <tbody>
                                <c:forEach var="option" items="${waitByNo.optionTexts}">
                                    <tr>
                                        <th class='table-active title'>${option.textName}</th>
                                        <td colspan='5' class='text-start'>${option.textValue}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${not empty waitByNo.reason}">
                                    <tr>
                                        <th class="table-active title">${waitByNo.reasonTitle}</th>
                                        <td colspan='5' class='text-start'>${waitByNo.reason}</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty waitByNo.commonText}">
                                    <c:if test="${waitByNo.categoryNo == 800}">
                                        <tr>
                                            <th colspan='6' class='table-active'>
                                                양식
                                            </th>
                                        </tr>
                                        <tr class="editorArea">
                                            <td colspan='6' class='text-start'>
                                                <div id="editor${waitByNo.no}">${waitByNo.commonText}</div>
                                                <!-- 스마트 에디터 관련 스크립트 추가 -->
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${waitByNo.categoryNo != 800}">
                                        <tr>
                                            <th class="table-active title">기타 사항</th>
                                            <td colspan='5' class='text-start'>${waitByNo.commonText}</td>
                                        </tr>
                                    </c:if>
                                </c:if>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </div>
            </main>
        </section>
    </div>
</div>
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">결재 요청을 반려하시겠습니까?</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="rejectForm" action="${pageContext.request.contextPath}/approval/reject" method="post">
                <input type="hidden" name="no" value="${waitByNo.no}" />
                <div class="modal-body">
                    <p class="description">사유를 입력해야 성공적으로 처리됩니다.</p>
                        <div class="form-floating mb-3">
                            <textarea class="form-control" name="reason" id="rejectedReason" placeholder="사유를 남겨주세요." required></textarea>
                            <label for="rejectedReason">반려 사유를 입력해주세요.</label>
                        </div>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
                    <button type="submit" class="btn btn-primary">처리하기</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    if (${waitByNo.categoryNo} === 800) {
        // Quill 에디터 초기화
        var quill = new Quill('#editor${waitByNo.no}', {
            theme: 'snow',
            modules: {
                "toolbar": false
            }
        });
        // disabled 처리
        quill.enable(false);
        // XSS 방지를 위한 HTML 이스케이프
        let commonText = "${fn:escapeXml(waitByNo.commonText)}";
        // Quill의 clipboard 모듈을 사용하여 HTML 삽입
        let range = quill.getSelection();
        quill.clipboard.dangerouslyPasteHTML(range.index, commonText);
    }
    $(function() {
        // completed
        $("#approvalForm").on("submit", function() {
            return confirm('정말로 승인하시겠습니까?');
        });

        // rejected
        $('#exampleModal').on('hidden.bs.modal', function () {
            $('#rejectForm')[0].reset(); // 폼 초기화
        });
    })
</script>
</body>
</html>
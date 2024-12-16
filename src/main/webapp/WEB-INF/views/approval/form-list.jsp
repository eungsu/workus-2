<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@ include file="../common/common.jsp" %>
    <link rel="stylesheet" href="${s3}/resources/css/approval.css">
    <script src="${s3}/resources/js/approval.js"></script>
    <!-- Include the Quill library -->
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
    <title>workus ㅣ 결재</title>
</head>
<body>
<div id="divWrapper">
    <div id="divContents">
        <c:set var="menu" value="approval"/>
        <%@ include file="../common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="../common/nav.jsp" %>
            <c:set var="lnb" value="signOff"/>
            <div class="lnb">
                <ul class="list1">
                    <li class="${lnb eq 'signOff' ? 'on' : '' }"><a href="${pageContext.request.contextPath}/approval/form-list">결재 요청하기</a></li>
                    <li class="${lnb eq 'myReqList' ? 'on' : '' }"><a href="${pageContext.request.contextPath}/approval/my/reqList">요청 내역</a></li>
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
                                            <li class="${lnb eq 'myEndList' ? 'on' : '' }"><a href="${pageContext.request.contextPath}/approval/my/endList">종결건</a>
                                            </li>
                                            <li class="${lnb eq 'myEndList' ? 'on' : '' }"><a href="${pageContext.request.contextPath}/approval/my/endList">반려건</a>
                                            </li>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('ROLE_LEADER')">
                                            <li class="${lnb eq 'myRefList' ? 'on' : '' }"><a href="${pageContext.request.contextPath}/approval/my/refList">열람건</a>
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
                    결재 요청하기
                </h3>
                <div class="containerW">
                    <nav class="sidebar">
                        <ul>
                            <c:forEach var="category" items="${categories}">
                                <li class="category-item" data-id="${category.no}"
                                    data-name="${category.name}">${category.name}</li>
                            </c:forEach>
                        </ul>
                    </nav>
                    <div class="content">
                        <div id="100" class="form">
                            <h2 class="fs-4 text-center">양식 1</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo" value="1"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput"
                                                   value="카테고리 이름" required name="title"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">휴직 기간</th>
                                        <td colspan="5">
                                            <div class="d-flex align-items-center">
                                                <input type="date" name="fromDate" class="form-control wd150"
                                                       id="apvFromDate" required/>
                                                <span class="mgl5 mgr5">~</span>
                                                <input type="date" name="todate" class="form-control wd150"
                                                       id="apvToDate" required/>
                                                <span class="dayCheck">총 <span class="dayTotal">0</span>일</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">휴직 사유</th>
                                        <td colspan="5">
                                            <textarea required name="reason"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">업무 대행자</th>
                                        <td colspan="2">
                                            <textarea required name="optionTexts[agent]"></textarea>
                                        </td>
                                        <th class="table-active require">인수인계 상황</th>
                                        <td colspan="2">
                                            <textarea required name="optionTexts[handover]"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">기타사항</th>
                                        <td colspan="5">
                                            <textarea name="commonText"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="200" class="form">
                            <h2 class="fs-4 text-center">양식 2</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">휴직 기간</th>
                                        <td colspan="5">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                                <span class="mgl5 mgr5">~</span>
                                                <input type="date" name="toDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">휴직 사유</th>
                                        <td colspan="5">
                                            <textarea name="reason" required></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">병명</th>
                                        <td colspan="5">
                                            <textarea name="optionTexts[diseaseName]"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">업무 대행자</th>
                                        <td colspan="2">
                                            <textarea name="optionTexts[agent]" required></textarea>
                                        </td>
                                        <th class="table-active require">인수인계 상황</th>
                                        <td colspan="2">
                                            <textarea name="optionTexts[handover]" required></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">기타사항</th>
                                        <td colspan="5">
                                            <textarea name="commonText"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="300" class="form">
                            <h2 class="fs-4 text-center">양식 3</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">복직 일자</th>
                                        <td colspan="5">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">복직 사유</th>
                                        <td colspan="5">
                                            <textarea name="reason"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">기타사항</th>
                                        <td colspan="5">
                                            <textarea name="commonText"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="400" class="form">
                            <h2 class="fs-4 text-center">양식 4</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="titleInput form-control"
                                                   value="카테고리 이름" name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">협조요청일</th>
                                        <td colspan="2">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                        <th class="table-active">완료예정일</th>
                                        <td colspan="2">
                                            <div class="d-flex">
                                                <input type="date" name="toDate" class="form-control wd150"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">예정 작업 내용</th>
                                        <td colspan="5">
                                            <textarea name=""></textarea>
                                            <input type="hidden" name="optionTexts[work]"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="500" class="form">
                            <h2 class="fs-4 text-center">양식 5</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active">교육과정명</th>
                                        <td colspan="5">
                                            <input type="text" value="" class="form-control"
                                                   name="optionTexts[curriculum]">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">교육기관</th>
                                        <td colspan="5">
                                            <input type="text" value="" class="form-control" required
                                                   name="optionTexts[location]">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">교육참석일</th>
                                        <td colspan="5">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                                <span class="mgl5 mgr5">~</span>
                                                <input type="date" name="toDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">참석목적</th>
                                        <td colspan="2">
                                            <textarea name="reason"></textarea>
                                        </td>
                                        <th class="table-active">동행자</th>
                                        <td colspan="2">
                                            <textarea name="optionTexts[accompany]"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">교육내용</th>
                                        <td colspan="5">
                                            <textarea name="optionTexts[content]"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="600" class="form">
                            <h2 class="fs-4 text-center">양식 6</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">외근 일정</th>
                                        <td colspan="5">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                                <span class="mgl5 mgr5">~</span>
                                                <input type="date" name="toDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">외근 목적</th>
                                        <td colspan="5">
                                            <input type="text" value="" class="form-control" name="reason">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">외근 지역</th>
                                        <td colspan="2">
                                            <input type="text" value="" class="form-control"
                                                   name="optionTexts[location]" required>
                                        </td>
                                        <th class="table-active">외근 동행자</th>
                                        <td colspan="2">
                                            <input type="text" value="" class="form-control"
                                                   name="optionTexts[accompany]">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">주요 업무</th>
                                        <td colspan="5">
                                            <input type="text" value="" class="form-control" name="optionTexts[work]">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">이동 방안</th>
                                        <td colspan="5">
                                            <textarea name="optionTexts[transport]" required></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">준비사항</th>
                                        <td colspan="5">
                                            <textarea name="optionTexts[ready]"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">기타사항</th>
                                        <td colspan="5">
                                            <textarea name="commonText"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="700" class="form">
                            <h2 class="fs-4 text-center">양식 7</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active require">방문 날짜</th>
                                        <td colspan="5">
                                            <div class="d-flex">
                                                <input type="date" name="fromDate" class="form-control wd150" required/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active require">방문처</th>
                                        <td colspan="5">
                                            <input type="text" value="" class="form-control"
                                                   name="optionTexts[location]" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">방문 동기</th>
                                        <td colspan="2">
                                            <input type="text" value="" class="form-control" name="reason">
                                        </td>
                                        <th class="table-active require">방문 시간</th>
                                        <td colspan="2">
                                            <input type="text" value="" class="form-control" name="optionTexts[time]"
                                                   required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active">특이사항</th>
                                        <td colspan="5">
                                            <textarea name="commonText"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                        <div id="800" class="form">
                            <h2 class="fs-4 text-center">양식 8</h2>
                            <form method="post" action="${pageContext.request.contextPath}/approval/addForm">
                                <input type="hidden" name="categoryNo" class="categoryNo"/>
                                <textarea name="commonText" class="hiddenEditor" hidden></textarea>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <th class="table-active title require">제목</th>
                                        <td colspan="5">
                                            <input type="text" class="form-control titleInput" value="카테고리 이름"
                                                   name="title" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-active title">열람/공람자</th>
                                        <td colspan="5">${leader.name}</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <!-- Create the editor container -->
                                <div id="editor">
                                </div>
                                <div class="btnW mgt40 d-flex justify-content-center">
                                    <input type="reset" value="입력 취소" class="btn btn-secondary"/>
                                    <button type="submit" class="btn btn-dark">결재 요청하기</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </section>
    </div>
</div>
<script>
    const quill = new Quill('#editor', {
        theme: 'snow'
    });
</script>
</body>
</html>
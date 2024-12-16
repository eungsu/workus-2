<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@ include file="../common/common.jsp" %>
    <link rel="stylesheet" href="${s3}/resources/css/attendance.css">
    <%-- day.js --%>
    <script src="
https://cdn.jsdelivr.net/npm/dayjs@1.11.13/dayjs.min.js
"></script>
    <script src="${s3}/resources/js/attendance.js"></script>
    <title>workus ㅣ 근태</title>
</head>
<body>
<div id="divWrapper">
    <div id="divContents">
        <c:set var="menu" value="attendance"/>
        <%@ include file="../common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="../common/nav.jsp" %>
            <c:set var="lnb" value="myAtdInfo"/>
            <div class="lnb">
                <ul class="list1 myAtdInfo">
                    <li class="${lnb eq 'myAtdInfo' ? 'on' : '' }"><a href="list">내 근태 현황</a></li>
                </ul>
                <p class="listTitle">근태 내역</p>
                <ul class="list2 myAtdList">
                    <li class="${lnb eq 'myReqList' ? 'on' : '' }"><a href="myReqList">내 신청 내역</a></li>
                    <li class="${lnb eq 'myApvList' ? 'on' : '' }"><a href="myApvList">내 결재 내역</a></li>
                    <li class="${lnb eq 'myRefList' ? 'on' : '' }"><a href="myRefList">내 참조 내역</a></li>
                </ul>
            </div>
            <main>
                <h3 class="title1">
                    내 근태 현황
                </h3>
                <div id="atdCheck" class="content">
                    <div class="applyItem">
                        <button type="button"
                                class="applyBtn btn btn-lg border border-secondary d-flex justify-content-between align-items-center"
                                id="atdApplyBtnForModal">
              <span>
                휴가 신청
                <span class="holiday">
                    <span class="usable">${attendanceDto.unusedAnnualLeave}</span>
                    <span class="slash">/</span>
                    <span class="total">${attendanceDto.annualLeaveCount}</span>
                </span>
              </span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                        <a href="/attendance/myApvList"
                           class="applyWaitBtn btn btn-lg border border-secondary d-flex justify-content-between align-items-center">
                <span>
                  결재 대기
                  <span class="flex count">
                    <span class="data">${myApvCount}</span>건
                  </span>
                </span>
                            <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                    <div id="fullCalendarInAtd" class="mgt40">
                    </div>
                </div>
            </main>
            <dialog id="atdRequestForm">
                <div class="wrapper">
                    <div class="modalHeader flex justify-content-between align-items-center">
                        <h5 class="modalTitle">연차 신청하기</h5>
                        <button type="button" class="close closeBtn" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <form method="post" action="getApproval" id="atdApproval">
                        <input type="hidden" name="apv" id="apvUserList" required/>
                        <input type="hidden" name="ref" id="refUserList" required/>
                        <input type="hidden" name="categoryNo" id="categoryNo" required/>
                        <input type="hidden" name="dayTotal" id="dayTotal"/>
                        <div class="modalBody sec2">
                            <div class="modalLeft">
                                <div class="reqFormSec">
                                    <label for="atdCtgr" class="reqFormTit">종류</label>
                                    <select id="atdCtgr" class="form-select w-25" name="categoryOpt1">
                                    </select>
                                    <span class="annualLeaveOnly mgt10"></span>
                                    <span class="partOpt d-none">
                                      <label for="morningOff">
                                        <input type="radio" name="time" value="오전" id="morningOff">
                                        <span class="mgr10 mgl5">오전</span>
                                      </label>
                                      <label for="afternoonOff">
                                        <input type="radio" name="time" value="오후" id="afternoonOff">
                                        <span class="mgr10 mgl5">오후</span>
                                      </label>
                                    </span>
                                    <p class="description">* 근속 연차 :
                                        <span class="current">${attendanceDto.unusedAnnualLeave}</span>
                                        /
                                        <span class="total">${attendanceDto.annualLeaveCount}</span>일
                                    </p>
                                </div>
                                <div class="reqFormSec">
                                    <label for="atdFromDate" class="reqFormTit">기간</label>
                                    <input type="date" name="fromDate" id="atdFromDate"
                                           class="form-control wd150 inlineBlock" onkeydown="return false">
                                    ~
                                    <label for="atdToDate">
                                        <input type="date" name="toDate" id="atdToDate" class="form-control wd150"
                                               onkeydown="return false">
                                    </label>
                                    <span class="dayCheck">총 <span class="dayTotal">1</span>일</span>
                                </div>
                                <div class="reqFormSec">
                                    <label for="reasonSec" class="reqFormTit">사유</label>
                                    <textarea name="reason" id="reasonSec" required></textarea>
                                </div>
                            </div>
                            <div class="modalRight">
                                <span class="reqFormTit mgb10">결재 및 참조선</span>
                                <span class="smallText">* 결재선은 팀장, 참조선은 인사팀 부장이 기본값입니다.</span>
                                <div class="d-flex">
                                    <div class="listSec wholeList">
                                        <ul class="atdList" id="atdFormUser">
                                            <%-- atdForm --%>
                                        </ul>
                                    </div>
                                    <div class="listSec checkedList">
                                        <div class="d-flex">
                                            <div class="btnW">
                                                <button type="button" id="apvLineAdd">
                                                    <i class="bi bi-caret-right-square"></i>
                                                </button>
                                                <button type="button" id="apvLineCancel">
                                                    <i class="bi bi-caret-left-square"></i>
                                                </button>
                                            </div>
                                            <div class="atdList">
                                                <p class="sTit">결재선</p>
                                                <ul id="apv">
                                                    <%-- 결재선 자리 --%>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="d-flex">
                                            <div class="btnW">
                                                <button type="button" id="refLineAdd">
                                                    <i class="bi bi-caret-right-square"></i>
                                                </button>
                                                <button type="button" id="refLineCancel">
                                                    <i class="bi bi-caret-left-square"></i>
                                                </button>
                                            </div>
                                            <div class="atdList">
                                                <p class="sTit">참조선</p>
                                                <ul id="ref">
                                                    <%-- 참조선 자리 --%>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="collapse" id="collapseExample">
                            <div class="card card-body">
                                해당 정보로 연차를 신청하시겠습니까?
                            </div>
                        </div>
                        <div class="modalFooter d-flex justify-content-center">
                            <button type="button" class="btn btn-sm btn-secondary closeBtn">취소하기</button>
                            <button type="submit" class="btn btn-sm btn-primary" id="confirmModalBtn">신청하기</button>
                        </div>
                    </form>
                </div>
            </dialog>
        </section>
    </div>
</div>
</body>
</html>
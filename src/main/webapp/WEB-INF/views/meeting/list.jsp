<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/tags.jsp" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@ include file="../common/common.jsp" %>

    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/meeting.css' />">

    <title>Meeting</title>

</head>
<body>
<c:set var="menu" value="meeting"/>
<div id="divWrapper">
    <div id="divContents">
        <%@ include file="../common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="../common/nav.jsp" %>
            <c:set var="lnb" value="roomList"/>
            <div class="lnb">
                <!-- 회의실 예약 버튼 -->
                <div class="lnb-btn text-center mb-4">
                    <button type="button" class="btn btn-dark" id="addScheduleBtn">회의실 예약하기</button>
                </div>

                <!-- LNB 메뉴 -->
                <div class="lnb-menu">
                    <ul class="list1 myResInfo">
                        <li class="${lnb eq 'myResInfo' ? 'on' : '' }"><a href="#" id="myReservation">내 예약 현황</a></li>
                    </ul>
                    <p class="listTitle ${lnb eq 'roomList' ? 'on' : '' }" id="meetingRoom">회의실</p>
                    <ul class="list2 roomList">
                        <li class="${lnb eq 'roomA' ? 'on' : '' }"><a href="#" id="meetingRoomA">회의실 A</a></li>
                        <li class="${lnb eq 'roomB' ? 'on' : '' }"><a href="#" id="meetingRoomB">회의실 B</a></li>
                    </ul>
                </div>
            </div>
            <main>
                <div class="content">
                    <div id='meeting'></div>
                </div>
            </main>
        </section>
    </div>
</div>
<!-- Modal -->
<div class="modal" id="meetingModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="calendarModalLabel" aria-hidden="true">
    <div class="modal-dialog row mb-3 modal-dialog-centered modal-lg">
        <div class="modal-content col-12">
            <div class="modal-header">
                <h5 class="modal-title" id="meetingModalLabel">회의실 예약하기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="dialog">
                <div class="modal-body">
                    <!-- 시작 시간 입력 -->
                    <div class="reqFormSec">
                        <label for="startDate" class="reqFormTit">시작시간</label>
                        <input type="datetime-local" id="startDate" class="form-control" required />
                    </div>

                    <!-- 종료 시간 입력 -->
                    <div class="reqFormSec">
                        <label for="endDate" class="reqFormTit">종료시간</label>
                        <input type="datetime-local" id="endDate" class="form-control" required />
                    </div>

                    <!-- 캘린더 선택 -->
                    <div class="reqFormSec">
                        <label for="room" class="reqFormTit">회의실</label>
                        <select id="room" class="form-select" required>
                            <option value="a">회의실 A</option>
                            <option value="b">회의실 B</option>
                        </select>
                    </div>

                    <!-- 내용 입력 -->
                    <div class="reqFormSec">
                        <label for="content" class="reqFormTit">내용</label>
                        <input type="text" id="content" class="form-control" required />
                    </div>
                </div>

                <div class="modal-footer container w-100 justify-content-between">
                    <div>
                        <button type="button" class="btn btn-danger" id="delete" style="display:none;">삭제</button>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" id="save">예약</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 삭제 확인 모달 -->
<div class="modal" id="confirmDeleteModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
    <div class="modal-dialog row mb-3 modal-dialog-centered modal-sm">
        <div class="modal-content col-12">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmDeleteModalLabel">예약 취소 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                정말로 예약을 취소하시겠습니까?
            </div>
            <div class="modal-footer container w-100">
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">확인</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/meeting.js"></script>

</body>
</html>

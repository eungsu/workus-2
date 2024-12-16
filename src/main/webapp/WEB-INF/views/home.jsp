<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="common/tags.jsp" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@ include file="common/common.jsp" %>
    <title>workus ㅣ 중앙HTA 2404기 2조 FINAL PROJECT</title>
    <style>

        /* lnb 메뉴 설정 (예시) */
        #lnb {
            position: fixed;
            top: 0;
            left: 0;
            width: 200px; /* LNB 너비 */
            height: 100%; /* 화면 전체 높이 */
            background-color: #333; /* 배경색 */
            color: white;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
        }

        /* 메인 그리드 레이아웃 */
        #main-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr); /* 2열 그리드 */
            grid-template-rows: 1fr 2fr;   /* 첫 번째 행(채팅, 회의실)은 두 번째 행(커뮤니티, 일정)의 절반 높이 */
            gap: 20px; /* 섹션 간 간격 */
            padding: 20px;
            height: 100vh; /* 화면 전체 높이 */
            margin-left: 220px; /* LNB 너비(200px) + 여백(20px) */
        }

        /* 개별 섹션 스타일 */
        .grid-item {
            border: 1px solid #ddd; /* 테두리 */
            border-radius: 8px;     /* 모서리 둥글게 */
            padding: 16px;
            background-color: #f9f9f9; /* 배경색 */
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* 박스 그림자 */
        }


        /* 채팅 */
        #chatting-section {
            grid-column: 1; /* 첫 번째 열 */
            grid-row: 1;    /* 첫 번째 행 */
        }

        /* 회의실 */
        #meeting-section {
            grid-column: 2; /* 두 번째 열 */
            grid-row: 1;    /* 첫 번째 행 */
        }

        /* 커뮤니티 */
        #community-section {
            grid-column: 1; /* 첫 번째 열 */
            grid-row: 2;    /* 두 번째 행 */
        }

        /* 일정 */
        #calendar-section {
            grid-column: 2; /* 두 번째 열 */
            grid-row: 2;    /* 두 번째 행 */
        }
    </style>
</head>
<body>
<c:set var="menu" value="home"/>
<div id="divWrapper">
    <div id="divContents">
        <%@ include file="common/header.jsp" %>
        <section class="verticalLayoutFixedSection">
            <%@ include file="common/nav.jsp" %>
            <main>
                <section id="main-grid">
                    <!-- 채팅 -->
                    <div class="grid-item" id="chatting-section">
                        <h2>채팅</h2>
                        <div id="chatting-content"></div>
                    </div>

                    <!-- 회의실 -->
                    <div class="grid-item" id="meeting-section">
                        <h2>회의실</h2>
                        <div id="meeting"></div>
                    </div>

                    <!-- 커뮤니티 -->
                    <div class="grid-item" id="community-section">
                        <h2>커뮤니티</h2>
                        <div id="community-content"></div>
                    </div>

                    <!-- 일정 -->
                    <div class="grid-item" id="calendar-section">
                        <h2>일정</h2>
                        <div id="calendar"></div>
                    </div>
                </section>
            </main>
        </section>
    </div>
</div>
<script src="/resources/js/meeting.js"></script>
<script src="/resources/js/calendar.js"></script>


</body>

</html>
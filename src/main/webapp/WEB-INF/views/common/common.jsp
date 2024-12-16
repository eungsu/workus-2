<%@ page pageEncoding="UTF-8" %>
<%-- aws s3 --%>
<c:set var="s3" value="https://2404-bucket-team-2.s3.ap-northeast-2.amazonaws.com"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<%--
    full calendar + google calendar
    schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives', 이거 넣기
--%>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@6.1.15/index.global.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@fullcalendar/google-calendar@6.1.15/index.global.min.js"></script>
<%-- 채팅방 bootstrap
    혹시 위의 bootstrap의 css와 겹칠수도 있을 것 같음 --%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<%-- 공통 CSS : css 추가해야 한다면 main.css 위로 추가할 것 --%>
<link rel="stylesheet" href="${s3}/resources/css/main.css">
<%-- 웹 소켓 --%>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>

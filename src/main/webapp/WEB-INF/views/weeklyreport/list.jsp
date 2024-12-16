<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../../../resources/css/notice.css" rel="stylesheet"/>
    <title>주간보고서</title>
    <%@ include file="../home.jsp" %>
</head>
<body>
<section class="notice">
    <div class="page-title">
        <div class="container">
            <h3>주간보고서</h3>
        </div>
    </div>
    <!-- board search area -->
    <div id="board-search">
        <div class="container">
            <div class="search-window">
                <form action="">
                    <div class="search-wrap">
                        <label for="search" class="blind">주간보고서 내용 검색</label>
                        <input id="search" type="search" name="" placeholder="검색어를 입력해주세요." value="">
                        <button type="submit" class="btn btn-dark">검색</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- board list area -->
    <div id="board-list">
        <div class="container">
            <!-- 글쓰기 버튼 -->
            <div class="button-group1">
                <a href="detail" class="btn btn-dark">글쓰기</a>
            </div>

            <table class="board-table">
                <thead>
                    <tr>
                        <th scope="col" class="th-num">번호</th>
                        <th scope="col" class="th-title">제목</th>
                        <th scope="col" class="th-date">등록일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>3</td>
                        <th>
                          <a href="detail">[주간보고서] 영업팀 10월 1주차 주간보고서</a>
                          <p>주간보고서</p>
                        </th>
                        <td>2017.07.1</td>
                    </tr>

                    <tr>
                        <td>2</td>
                        <th><a href="#!">[주간보고서] 영업팀 10월 2주차 주간보고서</a></th>
                        <td>2017.10.9</td>
                    </tr>

                    <tr>
                        <td>1</td>
                        <th><a href="#!">[주간보고서] 영업팀 10월 3주차 주간보고서</a></th>
                        <td>2017.10.18</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</section>

</body>
</html>

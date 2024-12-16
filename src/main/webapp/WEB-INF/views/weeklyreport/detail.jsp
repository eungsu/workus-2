<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주간 보고서 작성 및 상세보기</title>
    <link href="../../../resources/css/report.css" rel="stylesheet">
    <%@ include file="../home.jsp" %>
</head>
<body>

<div class="report-container">
    <!-- 상단 버튼 그룹 -->
    <div class="report-header">
        <h1>주간 보고서 작성 및 상세보기</h1>
        <div class="button-group">
            <button class="btn-list" onclick="location.href='report_list.html'">목록</button>
            <button class="btn-edit" id="edit-btn">수정</button>
            <button class="btn-delete" id="delete-btn">삭제</button>
        </div>
    </div>

    <!-- 부서 및 작성자 정보 (텍스트로 표시) -->
    <div class="meta-info">
        <div>부서: 도움업무팀</div>
        <div>작성자: 홍길동 팀장</div>
    </div>

    <!-- 보고서 내용 섹션 (자세히 보기) -->
    <div>
        <h2>보고서 내용</h2>
        <table>
            <thead>
                <tr>
                    <th colspan="2">보고일시</th>
                    <th colspan="2">진행일자</th>
                </tr>
                <tr>
                    <td colspan="2">2020년 4월 20일 (월)</td>
                    <td colspan="2">2020년 4월 13일 - 2020년 4월 17일</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <th>현재 상태</th>
                    <th>작업자</th>
                </tr>
            </thead>
            <tbody>
                <tr class="section-header">
                    <td colspan="3">1. 행사 및 호스트 유지보수</td>
                </tr>
                <tr>
                    <td>1.1 역사 박람회 현장 방문 및 협업 창고지 고려</td>
                    <td class="status-ongoing">진행중</td>
                    <td>홍길동, 박지수</td>
                </tr>
                <tr>
                    <td>1.2 역사 기술 워크샵 기획 및 장비 대여</td>
                    <td class="status-ongoing">진행중</td>
                    <td>이순신, 역사팀 A</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 보고서 작성 폼 섹션 -->
    <div>
        <h2>보고서 작성</h2>
        <form id="report-form">
            <div class="form-group">
                <label for="report-title">보고서 제목</label>
                <input type="text" id="report-title" placeholder="보고서 제목을 입력하세요" value="2024년 10월 3주차 보고서">
            </div>
            <div class="form-group">
                <label for="report-date">작성일자</label>
                <input type="text" id="report-date" value="2024-10-20" disabled> <!-- sysdate로 자동 입력되는 필드 -->
            </div>
            <div class="form-group">
                <label>진행일자</label>
                <div class="date-range">
                    <input type="date" id="start-date" value="2024-10-13">
                    <span>-</span>
                    <input type="date" id="end-date" value="2024-10-17">
                </div>
            </div>
            <div class="form-group">
                <label for="report-status">진행 상태</label>
                <select id="report-status">
                    <option value="ongoing">진행중</option>
                    <option value="not-started">진행완료</option>
                </select>
            </div>
            <div class="form-group">
                <label for="report-content">내용</label>
                <textarea id="report-content" rows="10" placeholder="보고서 내용을 입력하세요">이번 주에는 교육용 콘텐츠 제작과 행사 준비가 진행되었습니다.</textarea>
            </div>

            <!-- 취소 및 저장 버튼 -->
            <div class="form-buttons">
                <button type="button" class="btn-cancel" onclick="location.href='list'">취소</button>
                <button type="submit" class="btn-save">등록</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 수정 버튼 클릭 시 동작
    document.getElementById('edit-btn').addEventListener('click', function() {
        alert('수정 페이지로 이동합니다.');
        // 수정 페이지로 이동하는 코드 추가 가능 (예: location.href = 'edit_report.html')
    });

    // 삭제 버튼 클릭 시 동작
    document.getElementById('delete-btn').addEventListener('click', function() {
        if (confirm('정말로 삭제하시겠습니까?')) {
            alert('보고서가 삭제되었습니다.');
            // 실제로는 서버로 삭제 요청 코드 추가 필요
            location.href = 'report_list.html'; // 삭제 후 목록으로 이동
        }
    });

    // 폼 제출 시 동작
    document.getElementById('report-form').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('보고서가 저장되었습니다.');
        // 실제로는 서버로 저장 요청 코드 추가 필요
        location.href = 'report_list.html';  // 저장 후 목록으로 이동
    });
</script>

</body>
</html>


    // 업로드 버튼 클릭 시 파일 선택 창 열기
    document.getElementById('addScheduleBtn').addEventListener('click', function () {
        document.getElementById('fileInput').click();
    });

    // 파일 선택 후 자동으로 폼 제출
    document.getElementById('fileInput').addEventListener('change', function() {
        document.getElementById('archiveForm').submit();
    });

    // 파일 선택 후 자동으로 폼 제출
    document.getElementById('fileInput2').addEventListener('change', function() {
        document.getElementById('archiveForm').submit();
    });

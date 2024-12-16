 <%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <%@ include file="../common/common.jsp" %>
  <link href="../../../resources/css/communitymain.css" rel="stylesheet"/>
  <title>workus template</title>
  <!-- 소스 다운 -->
  <script src="https://unpkg.com/@yaireo/tagify"></script>
  <!-- 폴리필 (구버젼 브라우저 지원) -->
  <script src="https://unpkg.com/@yaireo/tagify/dist/tagify.polyfills.min.js"></script>
  <link href="https://unpkg.com/@yaireo/tagify/dist/tagify.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="divWrapper">
  <div id="divContents">
    <%@ include file="../common/header.jsp" %>
    <section class="verticalLayoutFixedSection">
      <%@ include file="../common/nav.jsp" %>
      <div class="container">
        <!-- 미리보기 영역 -->
        <div class="left-section">
          <div class="header">미리보기</div>
          <div id="filePreview" class="file-preview"></div>
        </div>

        <!-- 게시글 작성 폼 -->
        <div class="right-section">
          <div class="header">새 게시물 작성</div>
          <form id="postForm" method="post" action="insertFeed" enctype="multipart/form-data">
          <div> <p id="text"></p></div>

            <!-- 제목 입력 -->
            <div class="form-group">
              <input type="text" name="title" id="postTitle" placeholder="게시물 제목을 입력하세요" >
            </div>

            <!-- 내용 입력 -->
            <div class="form-group">
              <textarea name="content"id="postContent" rows="5" placeholder="게시물 내용을 작성하세요" ></textarea>
            </div>

            <!-- 해시태그 입력 -->
            <div>
              <input name='tags' class='some_class_name' placeholder='예시 "#해쉬태그" 해쉬태그를 입력해주세요' value=''>
              <button type="button" id="resetTags">태그 초기화</button>
            </div>

            <!-- 이미지/동영상 업로드 -->
            <div class="form-group file-input-wrapper">
              <input type="file" name="upfile" id="postFiles" accept="image/*, video/*" multiple>
            </div>

            <!-- 게시 버튼 -->
            <button type="submit" class="btn-post" id="upfile">게시하기</button>
            <button type="button" class="btn-cancel"><a href="list">취소</a></button>
          </form>
        </div>
      </div>
      </main>
    </section>
  </div>
</div>
</body>
<script>
  // 파일 미리보기 기능
  document.getElementById('postFiles').addEventListener('change', function(event) {
    // 이벤트가 발생하는 파일
    const files = event.target.files;
    const previewContainer = document.getElementById('filePreview');
    previewContainer.innerHTML = ''; // 기존 미리보기 내용 초기화

    for (const file of files) {
      const reader = new FileReader();
      const fileType = file.type.split('/')[0]; // 'image' 또는 'video'

      reader.onload = function(e) {
        const fileUrl = e.target.result;
        const fileElement = document.createElement(fileType === 'image' ? 'img' : 'video');

        fileElement.src = fileUrl;
        fileElement.classList.add('file-preview-item');
        fileElement.controls = (fileType === 'video'); // 비디오일 경우 컨트롤러 표시

        previewContainer.appendChild(fileElement);
      };

      reader.readAsDataURL(file); // 파일을 base64로 읽어오기
    }
  });

  // Tagify 라이브러리 사용
  // 해시태그를 위한 Tagify 초기화
  // LocalStorage에서 기존 저장된 태그 불러오기
  // LocalStorage에서 기존 저장된 태그 불러오기
  // LocalStorage에서 저장된 태그 불러오기
  var storedTags = JSON.parse(localStorage.getItem("savedTags")) || [];
  var whitelist = [...new Set(storedTags)]; // 중복 제거

  // Tagify 초기화
  var input = document.querySelector('input[name="tags"]');
  var tagify = new Tagify(input, {
    whitelist: whitelist,
    maxTags: 20,
    dropdown: {
      maxItems: 20, // 최대 드롭다운 항목 수
      classname: "tags-look",
      enabled: 0, // 드롭다운 비활성화
      closeOnSelect: false
    },
    delimiters: "\n" // 엔터 키로만 태그 추가 가능
  });

  // 태그 추가 전 자동으로 # 붙이기
  tagify.settings.transformTag = function (tagData) {
    if (!tagData.value.startsWith("#")) {
      tagData.value = "#" + tagData.value.trim(); // 앞에 # 추가
    }
    return tagData;
  };

  // 태그 추가 이벤트 처리
  tagify.on('add', function (e) {
    const newTag = e.detail.data.value;

    // 한 글에서 중복된 태그를 허용하지 않음
    const currentTags = tagify.value.map(tag => tag.value);
    if (currentTags.filter(tag => tag === newTag).length > 1) {
      tagify.removeTags(newTag); // 중복된 태그 삭제
      alert("중복된 태그는 추가할 수 없습니다.");
      return;
    }

    // 태그를 whitelist와 LocalStorage에 추가
    if (!whitelist.includes(newTag)) {
      whitelist.push(newTag); // whitelist에 추가
      localStorage.setItem("savedTags", JSON.stringify(whitelist)); // LocalStorage에 저장
    }
  });

  // 태그 초기화 버튼 이벤트 처리
  document.getElementById("resetTags").addEventListener("click", function () {
    // whitelist와 LocalStorage 초기화
    whitelist = []; // whitelist 초기화
    localStorage.removeItem("savedTags"); // LocalStorage에서 삭제
    tagify.whitelist = whitelist; // Tagify에 반영
    tagify.dropdown.hide(); // 드롭다운 닫기
    alert("태그가 초기화되었습니다."); // 알림 표시
  });

  // 폼 제출 이벤트 처리
  document.getElementById("postForm").addEventListener("submit", function(event) {
    let formValid = true; // 폼이 유효한지 체크하는 변수

    // 경고 메시지 초기화
    document.getElementById("text").innerHTML = "";

    // 제목, 내용, 해시태그, 파일 첨부 확인
    const title = document.getElementById("postTitle").value;
    const content = document.getElementById("postContent").value;
    const tags = document.querySelector('input[name="tags"]').value;
    const files = document.getElementById("postFiles").files;

    // 제목이 비어있으면 경고 메시지 표시
    if (!title.trim()) {
      formValid = false;
      document.getElementById("text").innerHTML += "❌ 제목을 입력해주세요. <br>";
    }

    // 내용이 비어있으면 경고 메시지 표시
    if (!content.trim()) {
      formValid = false;
      document.getElementById("text").innerHTML += "❌ 내용을 입력해주세요. <br>";
    }

    // 해시태그가 비어있으면 경고 메시지 표시
    if (!tags.trim()) {
      formValid = false;
      document.getElementById("text").innerHTML += "❌ 해시태그를 입력해주세요. <br>";
    }

    // 파일이 첨부되지 않으면 경고 메시지 표시
    if (files.length === 0) {
      formValid = false;
      document.getElementById("text").innerHTML += "❌ 파일을 첨부해주세요. <br>";
    }

    // 폼 유효성 검사 실패 시 제출을 막고 경고 메시지 표시
    if (!formValid) {
      event.preventDefault(); // 폼 제출을 막습니다.
      document.getElementById("text").style.color = "red"; // 경고 메시지 색상을 빨간색으로 설정
    } else {
      // 폼이 유효하면 버튼 비활성화
      document.getElementById("upfile").disabled = true; // 버튼 비활성화
    }
  });
</script>
</html>
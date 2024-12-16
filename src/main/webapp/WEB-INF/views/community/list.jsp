<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <%@ include file="../common/common.jsp" %>
   <link href="../../resources/css/communitymain.css" rel="stylesheet"/>\
  <title>workus template</title>
</head>
<body>
<c:set var="menu" value="community"/>
<div id="divWrapper">
  <div id="divContents">
    <%@ include file="../common/header.jsp" %>
    <section class="verticalLayoutFixedSection">
      <%@ include file="../common/nav.jsp" %>
      <main class="noLnb">
        <h3 class="title1" ><a href="list">Workus Community</a></h3>
        <button type="button" class="form-button"><a href="form">글 작성📝</a></button>
        <div class="content">
          <div class="wrap">
            <form id="form-search" onsubmit="searchKeyword(event)">
                <div class="search">
                  <select name="opt">
                    <option value="title" >제목🏷️</option>
                    <option value="content" >내용 📄</option>
                    <option value="hashtag" >해쉬태그#️⃣</option>
                  </select>
                  <input type="text" name="keyword"  placeholder="검색"/>
                  <button type="button" id="searchBtn" onclick="searchKeyword(event)">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                      <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
                    </svg>
                  </button>
                </div>
            </form>
            <button id="scrollToTopBtn" onclick="scrollToTop()">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-arrow-up-short" viewBox="0 0 16 16">
                <path d="M7.646 4.646a.5.5 0 0 1 .708 0l4.5 4.5a.5.5 0 0 1-.708.708L8 5.707l-3.646 3.647a.5.5 0 0 1-.708-.708l4.5-4.5z"/>
              </svg>
            </button>
          </div>
          </div>
          <!---MAIN--->
          <main class="container wrap">
            <!--FEED BOARD-->
            <div class="feed_board"></div>
            <!--//FEED BOARD-->
          </main>
      </main>
    </section>
  </div>
  <%--팝업 창 기본 숨김  --%>
  <div class="popup-overlay" id="popupOverlay">
    <div class="popup">
      <div class="popup-left" id="popupUrl${feed.no}"></div>
      <div class="popup-right">
        <!-- 버튼 -->
        <div class="popup-header">
          <img src="" id="postProfile" alt="Profile Picture" class="profile">
          <div class="username" id="postUsername"></div>
          <div class="popup-close" onclick="closePopup()">×</div>
        </div>
        <div class="popup-detail">
          <p class="popup-title" id="postTitle"><span class="bold"></span></p>
          <p class="popup-content" id="postContent"></p>
        </div>
        <div id="tags-popup\${feed.no}" style="margin-left: 30px;"></div>
        <div class="comments-section" id="postReplys"></div>
        <div class="popup-footer">
          <span class="likes" id="likesCount"></span>
        </div>
        <form method="post" action="insertReply">
          <div class="add-reply">
            <input type="hidden" name="feedNo" id="postFeedNo"/>
            <input type="hidden" name="name" id="postReplyUsername"/>
            <input class="popup-replycontent" type="text" name="comment" id="postComment" placeholder="댓글 달기...">
            <button type="button" key onclick="inserReplyPopup(${feed.no})">게시</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</body>
<script>
  let currentPage = 1;
  let canRequest = true;

  function initPageAndCanRequest() {
    currentPage = 1;
    canRequest = true;
  }

  $(window).scroll(function() {
    // 창높이
    let windowHeight = $(window).height();
    // 게시글 높이
    let documentHeight = $(document).height();
    // 스크롤 높이
    let scrollHeight = $(window).scrollTop();
    // 창 높이 + 스크롤위치 + 100 > 게시글 높이 일 경우 게시글을 불러온다
    if (windowHeight + scrollHeight + 100 > documentHeight) {
      if (canRequest) {
        canRequest = false;
        getFeeds(currentPage);
      }
    }
  });

  getFeeds(currentPage);

  function getFeeds(page) {
    let data = {
      page: page
    };

    let opt = $("select[name=opt]").val();
    let keyword = $("input[name=keyword]").val();

    if (opt != "" && keyword != "") {
      data["opt"] = opt;
      data["keyword"] = keyword;
    }

    $.ajax({
      type: "get",
      url: "items",
      data: data,
      dataType: "json",
      success: function (items) {
        appendFeeds(items);
        currentPage++;
        canRequest = true;

      },
      
    })
  }


  function  searchKeyword(event){
    initPageAndCanRequest()
    event.preventDefault();
    currentPage = 1;
    $.ajax({
      type:"get",
      url:"items",
      data:{
        page: currentPage,
        opt: $("select[name=opt]").val(),
        keyword: $("input[name=keyword]").val()
      },
      dataType:"json",
      success:function (feeds){
        currentPage++;
        $("div.feed_board").empty();

        appendFeeds(feeds);
      },
      error(){
        alert("검색된 결과가 없습니다.")
      }
    })
  }

  function searchHashTag(event) {
    initPageAndCanRequest()
    const tagName = $(event.target).text().trim().replace("#","");
    currentPage = 1;
    $.ajax({
      type: "GET",
      url: "items",
      data: {
        page: currentPage,
        opt: "hashtag",
        keyword: tagName
      },
      dataType: "json",
      success: function(feeds) {
        currentPage++;
        $("select[name='opt']").val("hashtag");
        $("input[name='keyword']").val(tagName);
        $("div.feed_board").empty();

        appendFeeds(feeds); // 피드를 다시 그리기
        $(window).scrollTop(100);
      }
    });
  };

  function appendFeeds(items) {
    for (let feed of items) {

      let content = `
      <!--FEED COMPONENT-->
      <article class="feed" id="feed-\${feed.no}">
        <!--top-->
        <div class="new_poster">
          <div class="poster_img">
            <img alt="follower profile image" class="round_img" src="${s3}/resources/repository/userprofile/\${feed.user.profileSrc}" />
          </div>
          <p  class="poster_id txt_id">\${feed.user.name}</p>
          <div class="dropdown-container" id="dropdown-menu">
            <svg class="x1lliihq x1n2onr6 x5n08af" fill="currentColor" height="24" role="img" viewBox="0 0 24 24" width="24" id="dropdownToggle" data-bs-toggle="dropdown">
              <circle cx="12" cy="12" r="1.5"></circle>
              <circle cx="6" cy="12" r="1.5"></circle>
              <circle cx="18" cy="12" r="1.5"></circle>
            </svg>
            <ul class="dropdown-menu dropdown-menu-end p-3" id="ul-dropdown">
               <div class="dropdown-item1" id="box- fy">

                 <form class="dropdown-delete" method="get" action="modify">
                      <input type="hidden" name="feedNo" value="\${feed.no}" />
                      <button type="submit">수정</button>
                  </form>
               </div>
               <div class="dropdown-item2" id="box-delete">
                    <form class="dropdown-delete" method="post" action="deleteFeed">
                      <input type="hidden" name="feedNo" value="\${feed.no}" />
                      <button type="submit" class="">삭제</button>
                  </form>
                </div>
            </ul>
            </div>
        </div>

        <!--content-->
        <section class="feed_imgs">
          <div id="feed-\${feed.no}-insertUrl"></div>
            <div class="interactions">
              <div class="my_emotion">
                <!-- 피드 내 하트 버튼 -->
                <span class="like-btn" id="likeBtn" onclick="updateLike(\${feed.no})">
                  <i class="bi bi-heart large-heart" id="he"></i> <!-- 기본 빈 하트 아이콘 -->
                 </span>

                 <button class="open-popup-btn" onclick="openPopup(\${feed.no})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-chat" viewBox="0 0 16 16">
                    <path d="M2.678 11.894a1 1 0 0 1 .287.801 11 11 0 0 1-.398 2c1.395-.323 2.247-.697 2.634-.893a1 1 0 0 1 .71-.074A8 8 0 0 0 8 14c3.996 0 7-2.807 7-6s-3.004-6-7-6-7 2.808-7 6c0 1.468.617 2.83 1.678 3.894m-.493 3.905a22 22 0 0 1-.713.129c-.2.032-.352-.176-.273-.362a10 10 0 0 0 .244-.637l.003-.01c.5-1.05 1.548-.524 2.319C.743 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7-3.582 7-8 7a9 9 0 0 1-2.347-.306c-.52.263-1.639.742-3.468 1.105"/>
                  </svg>
                   </button>
              </div>
              <div class="like_user" id="like-user-\${feed.no}"></div>
            </div>
        </section>

        <!--feed text-->
        <section class="feed_txt">
            <div><strong>\${feed.title}</strong><div>
            <p>\${feed.content}</p>
            <div id="tags-\${feed.no}" style="margin: 10px 0;"></div>
        </section>


        <!--comment-->
        <div class="comments">
          <div id="listComment" class="list_comment">
            <div class="txt_comment">
            <p class="reply-name">\${feed.reply != null ? "🆕  "+feed.reply.user.name : ''}</p>
            <p class="reply-content">\${feed.reply != null ? feed.reply.content : ''}</p>
            </div>

            <form method="post" action="insertReply">
                <div class="add-reply">
                <input type="hidden" name="feedNo" value="">
                <input type="hidden" name="name">
                <input type="text" class="feedInsertReply" name="comment" id="feedinsertReply" placeholder="댓글 달기...">
                <button  type="button" onclick="inserReply(\${feed.no})">게시</button>
                </div>
            </form>
        </div>
      </article>
    `;
      $("div.feed_board").append(content);

      let tags = "";
      for (let tag of feed.hashTags) {
        tags += `
         <span type="button"id="\${tag.no}searchTag" onclick="searchHashTag(event)" style=" color: #3a9cfa; padding: 1px 1px; margin-right: 3px;">\${tag.name}</span>`
      }

      if (feed.likeCount > 0) {
        let content = `
            <span class="like-userName" name="userName" id="likeFeedUserName\${feed.no}">\${feed.userName}</span>님
            외<span class="like-count" name="likeCount" id="likeFeedCount\${feed.no}">\${feed.likeCount}</span>명이 좋아합니다.
        `;

        $(`#like-user-\${feed.no}`).html(content);
      }

      $("#tags-" + feed.no).append(tags);
      $("#tags-popup" + feed.no).append(tags);




      if(feed.mediaUrl.includes('jpg') || feed.mediaUrl.includes('png')|| feed.mediaUrl.includes('jpeg') || feed.mediaUrl.includes('gif')) {
        let insertUrl =
                `<img src="${s3}/resources/repository/communityfeedfile/\${feed.mediaUrl}"/>`;
        $(`#feed-\${feed.no}-insertUrl`).html(insertUrl)
      } else if(feed.mediaUrl.includes('mp4') || feed.mediaUrl.includes('mp4')|| feed.mediaUrl.includes('avi')|| feed.mediaUrl.includes('mpg') ||feed.mediaUrl.includes('mpeg') ) {
        let insertUrl =
                `<video controls src="${s3}/resources/repository/communityfeedfile/\${feed.mediaUrl}"/>`;
        $(`#feed-\${feed.no}-insertUrl`).html(insertUrl)
      }
    }
  }

  // 팝업 js
  function openPopup(feedNo) {
    $.ajax({
      type: "get",
      url: `feed/\${feedNo}`,
      dataType: "json",
      success: function (feed) {
        if(feed.mediaUrl.includes('jpg') || feed.mediaUrl.includes('png')|| feed.mediaUrl.includes('jpeg') || feed.mediaUrl.includes('gif')) {
          let insertUrl =
                  `<img src="${s3}/resources/repository/communityfeedfile/\${feed.mediaUrl}"/>`;
          $("#popupUrl${feed.no}").html(insertUrl)
        } else if(feed.mediaUrl.includes('mp4') || feed.mediaUrl.includes('mp4')|| feed.mediaUrl.includes('avi')|| feed.mediaUrl.includes('mpg') ||feed.mediaUrl.includes('mpeg') ) {
          let insertUrl =
                  `<video width=100%; height=100%; controls autoplay loop src="${s3}/resources/repository/communityfeedfile/\${feed.mediaUrl}"/>`;
          $("#popupUrl${feed.no}").html(insertUrl)
        }
        $("#postImage").attr("src", "https://2404-bucket-team-2.s3.ap-northeast-2.amazonaws.com/resources/repository/communityfeedfile/"+feed.mediaUrl);
        $("#postProfile").attr("src", "https://2404-bucket-team-2.s3.ap-northeast-2.amazonaws.com/resources/repository/userprofile/"+feed.user.profileSrc);
        $("#postUsername").text(feed.user.name);
        $("#postTitle").text(feed.title);
        $("#postContent").text(feed.content);
        $("#postFeedNo").val(feed.no);
        $("#likesCount").text("좋아요"+feed.likesCount+"개");



        let replys = feed.replys;
        let content = "";
        for (let reply of replys) {
          content += `

      <div class="popup-reply">
        <div id="reply-\${reply.no}">
           <p>
              <strong><span style="margin-right: 10px;">\${reply != null ? reply.user.name : ''} :</span></strong>
              <span>\${reply != null ? reply.content : ''}</span>
           </p>
         <button onclick="deleteRely(\${reply.no},\${reply.user.no})">🗑️</button>
      </div>
        `;
        }
        $("#postReplys").html(content);

        document.getElementById("popupOverlay").style.display = "flex";
      }
    })
  }

  function  deleteRely(replyNo){
    $.ajax({
      type:"post",
      url:"deleteReply",
      data:{
            replyNo : replyNo
            },
      success:function (){
        alert("댓글이 삭제 되었습니다.")
        $(`#reply-`+replyNo).remove();
      },
      error:function (){
        alert("댓글 삭제 권한이 없습니다.");
      }
    })
  }

  function closePopup() {
    document.getElementById("popupOverlay").style.display = "none";
  }

  // 댓글 js
  function inserReply(feedNo){
    $.ajax({
      type: "post",
      url: "insertReply",
      data:{
        feedNo:feedNo,
        name:$(`#feed-\${feedNo} input[name=name]`).val(),
        comment:$(`#feed-\${feedNo} input[name=comment]`).val()
      },
      dataType: "json",
      success:function (reply){
        $(`#feed-\${reply.feed.no} .reply-name`).text("🆕   "+reply.user.name);
        $(`#feed-\${reply.feed.no} .reply-content`).text(reply.content);
        $(".feedInsertReply").val(""); //
      }
    })
  }


  function inserReplyPopup(){
    $.ajax({
      type: "post",
      url: "insertReply",
      data:{feedNo:$("#postFeedNo").val(),
        comment:$("#postComment").val()},
      name:$("#postReplyUsername").val(),
      dataType: "json",
      success:function (reply){
        let content = `
         <div class="popup-reply">
           <p>
              <strong><span style="margin-right: 10px;">\${reply != null ? reply.user.name : ''} :</span></strong>
              <span>\${reply != null ? reply.content : ''}</span>
           </p>
           <button onclick="deleteRely(\${reply.no})">🗑️</button>
         </div>
        `;

        $(`#feed-\${reply.feed.no} .reply-name`).text("🆕  "+reply.user.name);
        $(`#feed-\${reply.feed.no} .reply-content`).text(reply.content);
        $("#postReplys").prepend(content);
        $(".popup-replycontent").val("")
      }
    })
  }

  $(document).ready(function() {
    // 댓글 입력 폼에서 엔터키 눌렀을 때 처리
    $(document).on("keydown", "#feedinsertReply", function(event) {
      if (event.key === "Enter") {
        event.preventDefault();

        var feedNo = $(this).closest("article").attr("id").replace('feed-', '');


        inserReply(feedNo);
      }
    });
  });

  $(document).ready(function() {
    $("#postComment").on("keydown", function(event) {
      if (event.key === "Enter") {
        event.preventDefault();
        inserReplyPopup();
      }
    });
  });

  // 좋아요 js
  function updateLike(feedNo) {
    let no = feedNo;
    $.ajax({
      type: "POST",
      url: "like",
      data: {
        feedNo: feedNo
      },
      dataType: "json",
      success:
              function(likeFeed) {
                if (likeFeed.likeCount == 0) {
                  $(`#like-user-\${feedNo}`).html("");

                } else if (likeFeed.likeCount == 1){
                  $(`#like-user-\${feedNo}`).html("");
                  let content = `
                <span class="like-userName" name="userName" id="likeFeedUserName\${feedNo}">\${likeFeed.userName}</span>님
                외<span class="like-count" name="likeCount" id="likeFeedCount\${feedNo}">\${likeFeed.likeCount}</span>명이 좋아합니다.
            `;
                  $(`#like-user-\${feedNo}`).html(content);

                } else {
                  $("#likeFeedUserName"+feedNo).text(likeFeed.userName);
                  $("#likeFeedCount"+feedNo).text(likeFeed.likeCount);
                }

              }
    });
  }

  //  드롭다운 js
  const toggle = document.getElementById('dropdownToggle'); // 드롭다운 토글 요소
  const menu = document.getElementById('dropdownMenu'); // 드롭다운 메뉴

  // 팝업 헤더의 더 많은 옵션 클릭 시 드롭다운 메뉴 표시/숨기기
  function toggleDropdown() {
    menu.classList.toggle('show'); // 드롭다운 메뉴 표시/숨기기
  }

  // 클릭 외부 시 드롭다운 닫기
  window.addEventListener('click', (event) => {
    if (!document.querySelector('.more-options').contains(event.target) && !menu.contains(event.target)) {
      menu.classList.remove('show'); // 드롭다운 숨기기
    }
  });

  function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' }); // 맨 위로 부드럽게 이동
  }

</script>
</html>
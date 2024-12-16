<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="../common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ include file="../common/common.jsp" %>
<title>채팅방</title>
</head>
<body>
	<div id="divWrapper">
		<div id="divContents">
			<%@ include file="../common/header.jsp" %>
			<section class="verticalLayoutFixedSection">
				<c:set var="menu" value="chat"/>
				<%@ include file="../common/nav.jsp" %>
				<main class="noLnb">
					<div class="container-fluid vh-100">
						<div class="row h-100">
							<!-- 채팅방 목록 -->
							<div class="col-4 border-end p-0 chatroomDiv vh-100 overflow-auto">
							  <!-- 채팅방 생성 버튼 -->
								<div class="border-bottom p-3 openCreateChatroomBtnDiv">
								<button class="btn btn-primary w-100 openCreateChatroomBtn" data-bs-toggle="modal" data-bs-target="#createChatroomModal">
								  <i class="bi bi-plus-circle me-2"></i>새 채팅방 만들기
								</button>
								</div>
								<!-- 채팅방 -->
								<c:forEach var="chatroom" items="${chatrooms}">
								<div class="border-bottom p-3 chatroom" id="chatroom${chatroom.chatroomNo}" role="button" data-chatroom-no="${chatroom.chatroomNo}">
									<div class="d-flex justify-content-between align-items-start">
										<h6 class="mb-1">${chatroom.chatroomTitle}</h6>
										<small class="text-muted"><fmt:formatDate value="${chatroom.lastChatDate}" pattern="yyyy년 MM월 dd시 HH시 mm분" /></small>
									</div>
									<p class="mb-1 text-muted">${chatroom.lastChatAuthor.name}</p>
									<div class="d-flex justify-content-between align-items-center">
										<small class="text-muted text-truncate me-2">${chatroom.lastChat}</small>
										<c:if test="${chatroom.notReadCount != 0}">
										<span class="badge bg-primary rounded-pill not-read-count${chatroom.chatroomNo}">${chatroom.notReadCount}</span>
										</c:if>
									</div>
								</div>
								</c:forEach>
							</div>

							<div class="col-8 p-0 d-flex flex-column h-100" id="chat">

							</div>
						</div>
					</div>
				</main>
			</section>
		</div>
	</div>

	<!-- 토스트 컨테이너 위치 -->
	<div class="toast-container position-fixed top-0 end-0 p-3">
		<div id="userJoinToast" class="toast" role="alert">
			<div class="toast-header">
				<strong class="me-auto">알림</strong>
				<button type="button" class="btn-close" data-bs-dismiss="toast"></button>
			</div>
			<div class="toast-body"></div>
		</div>
	</div>

	<!-- 프로필 모달 -->
	<div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="profileModalLabel">프로필 정보</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="row">
						<!-- 왼쪽 프로필 사진 영역 -->
						<div class="col-4 text-center profile_image" id="profileImgDiv">

						</div>
						<!-- 오른쪽 정보 영역 -->
						<div class="col-8">
							<div class="mb-3">
								<h5 class="fw-bold" id="profileName"></h5>
							</div>
							<div class="mb-2">
								<span class="text-muted">직책:</span>
								<span id="profilePosition"></span>
							</div>
							<div class="mb-2">
								<span class="text-muted">부서:</span>
								<span id="profileDept"></span>
							</div>
							<div class="mb-2">
								<span class="text-muted">이메일:</span>
								<span id="profileEmail"></span>
							</div>
							<div class="mt-3">
								<span class="text-muted">한 줄 소개:</span>
								<p class="mt-1" id="profilePr"></p>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-warning" data-bs-dismiss="modal">수정</button>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

<!-- 채팅방 생성 모달 -->
<div class="modal fade" id="createChatroomModal" tabindex="-1" aria-labelledby="createChatroomModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-md">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="createChatroomModalLabel"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="createChatroomForm">
          <div class="mb-4">
            <label for="chatroomTitle" class="form-label">채팅방 제목</label>
            <input type="text" class="form-control" id="chatroomTitle" name="chatroomTitle">
			  <p id="noTitleAlarm"></p>
          </div>

          <div class="mb-3">
			<label class="form-label">참여자 선택</label>
			  <input type="text" class="form-control mb-3" id="userSearch" placeholder="초대할 사원의 이름을 입력하세요." />
			  <p id="noUserAlarm"></p>
			  <div class="position-relative">
				  <div class="dropdown-menu w-100 show border shadow-sm d-none" id="searchResults" style="max-height: 200px; overflow-y: auto;">
					  <!-- 검색 결과가 없을 때 -->
					  <div class="dropdown-item text-muted no-results py-2">
						  검색 결과가 없습니다.
					  </div>

					  <!-- 검색 결과 목록 컨테이너 -->
					  <div class="search-results-container">
						  <!-- 검색 결과 유저들 -->
					  </div>
				  </div>
			  </div>

            <!-- 부서별 사용자 목록 -->
            <div class="border rounded p-3" style="height: 300px; overflow-y: auto;">
            	<%-- 부서 --%>
				<c:forEach var="dept" items="${depts}" varStatus="deptStatus">
                <div class="department-group mb-3">
                  <div class="form-check">
                    <input class="form-check-input dept-check" type="checkbox" id="dept${dept.deptNo}" data-dept-no="${dept.deptNo}">
                    <button class="btn btn-link p-0 text-decoration-none" type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#deptCollapse${dept.deptNo}"
                        aria-expanded="true">
                        ${dept.deptName}
					</button>
                  </div>
                  <div class="collapse ms-4 mt-2 dept-collapse" id="deptCollapse${dept.deptNo}">
                  	<%-- 부서에 속한 유저 --%>
					<c:forEach var="map" items="${participantInfos[deptStatus.index]}">
						<c:forEach var="participantInfo" items="${map.value}">
						<div class="form-check mb-2">
							<input class="form-check-input user-check" type="checkbox" name="userNo" value="${participantInfo.userNo}" id="createChatroomParticipant${participantInfo.userNo}" data-dept-no="${dept.deptNo}">
							  <span class="text-muted">[${participantInfo.positionName}]</span> ${participantInfo.userName}
						</div>
						</c:forEach>
					</c:forEach>
                  </div>
                </div>
				</c:forEach>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary closeBtn" data-bs-dismiss="modal">취소</button>
        <button type="button" id="createChatroomBtn" class="btn btn-primary hide">생성</button>
		<button type="button" id="updateUsersInChatroomBtn" class="btn btn-primary hide">초대</button>
      </div>
    </div>
  </div>
</div>
	<script>
		const LOGIN_USERNO = ${LOGIN_USERNO};
		const LOGIN_USERID = "${LOGIN_USERID}";
		const LOGIN_USERNAME = "${LOGIN_USERNAME}";

		// 모달 객체 생성
		const profileModal = new bootstrap.Modal('#profileModal');
		const createChatroomModal = new bootstrap.Modal('#createChatroomModal');

		let chatroomNo = null;
		let page = null;

		// 채팅방 입장
		$('.chatroomDiv').on('click', '.chatroom', async function () {
			if (chatroomNo !== null) {
				updateContime();
			}
			// data-chatroom-no 속성 가져오기
			chatroomNo = $(this).data("chatroomNo");
			updateContime();

			// 파일과 채팅 동시에 전송 막기
			$('#chat').on('change', '#fileInput', function() {
				$('input[name=content]').prop('disabled', false);
				const files = $(this)[0].files;

				if(files.length > 0) {
					$('input[name=content]').val('');
					$('input[name=content]').prop('disabled', true);
				}
			});

			// 읽지 않은 메시지 수 화면에서 삭제
			$(`.not-read-count\${chatroomNo}`).text("");
			const titleAndUsersDiv = await ajaxTitleAndUsersData(chatroomNo);
			const chatDiv = await ajaxChatsData(chatroomNo);
			const chatSubmitForm = loadSubmitChatForm(chatroomNo);
			const div = titleAndUsersDiv + chatDiv + chatSubmitForm;
			await $('#chat').html(div);

            // 스크롤 맨 아래로 이동
            $('.outer-chat-div').scrollTop($('.outer-chat-div')[0].scrollHeight);

			// 웹소켓 연결
			$(function () {
				let ws = null;

				function connect() {
					ws = new SockJS("/socket/chat");

					// 연결 직후
					ws.onopen = function () {
						let message = {
							cmd: "chat-open",
							chatroomNo: chatroomNo,
							user: {
								no: LOGIN_USERNO,
								id: LOGIN_USERID
							}
						}
						send(message);
					}

					// 메시지가 도착한 경우
					ws.onmessage = async function (message) {
						let data = JSON.parse(message.data);
						if (data.cmd === "chat-open-success") {
							userJoinToast(data);
							checkOnline(data);
						} else if (data.cmd === "chat-message") {
							updateContime();
							replaceFormatTime(data.chat);
							if (data.user.no === LOGIN_USERNO) {
								const div = appearSubmittedMyChat(data.chat);
								$('.inner-chat-div').append(div);
							} else {
								const div = appearSubmittedOtherChat(data.chat);
								$('.inner-chat-div').append(div);
							}
						} else if (data.cmd === "chat-close-success") {
							userJoinToast(data);
							checkOnline(data);
						} else if (data.cmd === "chat-enter-success") {
							// 참여자 목록에 추가
							addNewUserInParticipantList(data.users);
							// 취소 버튼 누르기
							$('.closeBtn').click();
							appearEnterAndOutDiv(data.text);
						} else if (data.cmd === "chat-leave-success") {
							appearEnterAndOutDiv(data.text);
							$(`.participant-name-div[data-user-no="\${data.user.no}"]`).remove();
						}
					}
				}

				connect();

				// 추가 초대하기
				$('#updateUsersInChatroomBtn').click(async function () {
					// disabled가 되어있는 것을 제외하고 checked상태인 것의 userNo만 뽑아낸다.
					let checkedUserNumbers = $('.user-check:checked:not(:disabled)').map(function () {
						return { no: $(this).val()};
					}).get();

					let message = {
						cmd: 'chat-enter',
						chatroomNo: chatroomNo,
						users: checkedUserNumbers
					}
					send(message);
				})

				// 채팅방 나가기
				$('#chat').on('click', '#outChatroom', async function () {
					if (!confirm('채팅방을 나가시겠습니까?')) {
						return;
					}
					let message = {
						cmd: 'chat-leave',
						chatroomNo: chatroomNo,
						user: {
							no: LOGIN_USERNO,
							name: LOGIN_USERNAME
						}
					}
					send(message);
					window.location.replace('/chatroom/list');
				})

				// 채팅 소켓으로 전송
				async function chat() {
					let inputMessage = $('input[name=content]').val();
					let fileInput = $('#fileInput')[0].files[0];

					if (inputMessage) {
						let message = {
							cmd: 'chat-message',
							chatroomNo: chatroomNo,
							user: {
								no: LOGIN_USERNO,
								id: LOGIN_USERID
							},
							payload: {
								type: 'text',
								content: inputMessage
							}
						}
						send(message);
					}

					if (fileInput) {
						const formData = new FormData();
						formData.append('upfile', fileInput);
						const response = await fetch('/ajax/chat/upload', {
							method: 'POST',
							body: formData
						});
						const result = await response.json();
						const data = result.data;
						if (response.ok) {
							let message = {
								cmd: 'chat-message',
								chatroomNo: chatroomNo,
								user: {
									no: LOGIN_USERNO,
									id: LOGIN_USERID
								},
								payload: {
									type: 'file',
									fileSrc: data.fileSrc
								}
							}
							send(message);
						} else {
							console.log('파일 업로드에 실패했습니다.');
						}
					}
					$('input[name=content]').prop('disabled', false);
					$('input[name=content]').val('');
					$('#fileInput').val('');
				}

				// 이모지 전송
				$('#chat').on('click', '#emojiDiv', async function() {
					let emojiNo = $(this).data('emojiNo');
					$('#emojiSuggestionsDiv').addClass('d-none');
					$('input[name=content]').val('');

					let message = {
						cmd: 'chat-message',
						chatroomNo: chatroomNo,
						user: {
							no: LOGIN_USERNO,
							id: LOGIN_USERID
						},
						payload: {
							type: 'emoji',
							emojiNo: emojiNo
						}
					}
					send(message);
				})

				// 다른 페이지로 이동하거나 창이 꺼지기 직전
				window.addEventListener('beforeunload', function () {
					let message = {
						cmd: 'chat-close',
						chatroomNo: chatroomNo,
						user: {
							no: LOGIN_USERNO,
							id: LOGIN_USERID
						}
					}
					send(message);
				});

				function send(message) {
					ws.send(JSON.stringify(message));
				}

				$('#chat').on('click', '#submitChat', function () {
					chat();
				});

				// 엔터키 입력 이벤트
				$('#chat').on('keypress', 'input[name=content]', function (e) {
					if (e.keyCode === 13) {
						e.preventDefault();
						chat();
					}
				});
			})
		})

		<%-- 이모지 관련 코드 시작 --%>
		// 이모지 가져오기
		$('#chat').on('keyup', 'input[name=content]', async function() {
			$('#emojiSuggestionsDiv').addClass('d-none');
			let tagName = $(this).val();
			if (tagName < 2 || tagName > 5) return;

			const response = await fetch('/ajax/chat/emoji/' + tagName);
			const result = await response.json();
			const data = result.data;
			if (response.ok) {
				// 해당하는 이모지가 없을 때
				if (data.length === 0) return;

				// 해당하는 이모지가 존재할 때
				$('#addEmojiDiv').html('');
				$('#emojiSuggestionsDiv').removeClass('d-none');

				data.map(item => {
					fetch('../../../resources/repository/chat/emoji/' + item.previewFileSrc)
						.then(emojiResponse => emojiResponse.text())
						.then(emojiData => $('#addEmojiDiv').append(emojiData));
				})
			}
		})
		<%-- 이모지 관련 코드 끝 --%>

		// 입장 퇴장 구분선
		function appearEnterAndOutDiv(text) {
			let div = `
			<div class="d-flex align-items-center my-4">
				<div class="border-bottom flex-grow-1"></div>
				<div class="message">
					<span class="mx-3 text-muted">\${text}</span>
				</div>
				<div class="border-bottom flex-grow-1"></div>
			</div>
			`
			$('.inner-chat-div').append(div);
		}

		// 연결 시간 업데이트
		function updateContime() {
			$.ajax({
				url: '/ajax/chatroom/' + chatroomNo,
				method: 'PUT',
				error: function (error) {
					console.log('연결시간 업데이트 에러 발생', error);
				}
			})
		}

		// 더 보기
		$('#chat').on('click', '#loadMoreBtn', async function () {
			page++;
			$('#loadMoreBtnDiv').remove();
            let prevScrollHeight = null;
			try {
				const response = await fetch('/ajax/chat/' + page + '/' + chatroomNo);
				const result = await response.json();
				const data = result.data;
				if (response.ok) {
                    data.data.map(item => replaceFormatTime(item));
                    // 더보기 누르기 전으로 스크롤 이동
                    prevScrollHeight = $('.inner-chat-div').height();
					$('.inner-chat-div').prepend(loadPlusChats(data));
                    let scrollHeight = $('.inner-chat-div').height();
                    $('.outer-chat-div').scrollTop(scrollHeight - prevScrollHeight);
				} else {
					console.log('채팅을 불러오는데 실패했습니다.', result.message);
				}
			} catch (error) {
				console.log('에러메시지', error);
			}
		})

		// 추가 초대를 위한 버튼
		$('#chat').on('click', '#addNewUserBtn', async function () {
			$('#createChatroomModalLabel').text('추가 초대하기');
			$('#updateUsersInChatroomBtn').removeClass('hide');
			$('#createChatroomBtn').addClass('hide');
			resetChatroomModal();
			try {
				const response = await fetch('/ajax/chatroom/invited/' + chatroomNo);
				const result = await response.json();
				const data = result.data;
				if (response.ok) {
					$('#chatroomTitle').val(data.chatroomTitle).prop('disabled', true);
					data.users.map(user => {
						$(`#createChatroomParticipant\${user.no}`).prop('checked', true).prop('disabled', true);
					});
				} else {
					console.log('초대된 유저들을 불러오지 못했습니다.');
				}
			} catch (error) {
				console.log('사용자 추가 초대에 사용자들을 불러오는데 실패했습니다.', error);
			}
		})

		// 참여자 목록에 추가
		function addNewUserInParticipantList(users) {
			let div = `
			\${users.map((user) => `
				<div class="d-flex align-items-center my-2 participant-name-div" data-user-no="\${user.no}">
					<img src="${s3}/resources/repository/userprofile/\${user.profileSrc}" alt="프로필" class="rounded-circle me-2" style="width: 40px; height: 40px;">
					<div class="d-flex align-items-center gap-2">
						<span role="button" class="participant-name" data-user-no="\${user.no}" data-user-id="\${user.id}">\${user.name}</span>
						<span class="badge rounded-pill bg-success span-online" id="span-online\${user.id}" style="font-size: 0.7em;"></span>
					</div>
				</div>
			`).join('')}`;
			$('#participantList').append(div);
		}

		<%-- 채팅방 생성 js 시작 --%>

		// 방 초대할 유저 검색
		$('#userSearch').keyup(async function () {
			// 맨 처음은 초기화
			$('.search-results-container').html('');
			$('#searchResults').addClass('d-none');
			$('.no-results').addClass('d-none');
			let searchLen = $('#userSearch').val().length;

			// 검색어가 2글자 부터
			if (searchLen > 1) {
				$('#searchResults').removeClass('d-none');
				let userName = $('#userSearch').val();
				const response = await fetch('/ajax/chatroom/user/search/' + userName);
				const result = await response.json();
				const data = await result.data;
				// 검색된 유저가 존재하면
				if (data.length !== 0) {
					$('.no-results').addClass('d-none');
					appendUserInSearchBarDiv(data);
				} else {
					$('.no-results').removeClass('d-none');
				}
			}
		})

		function appendUserInSearchBarDiv(users) {
			let div = `
				\${users.map(user => `
					<div class="dropdown-item py-2 d-flex align-items-center gap-2" id="searchedUser" data-user-no="\${user.no}" data-dept-no="\${user.deptNo}" role="button">
					<i class="bi bi-person-circle fs-5"></i>
						<div class="d-flex flex-column">
							<span class="fw-medium">\${user.name}</span>
							<small class="text-muted">\${user.deptName} · \${user.positionName}</small>
						</div>
					</div>
				`).join('')}`;
			$('.search-results-container').html(div);
		}

		// 검색된 유저 클릭 시 체크 표시
		$('#searchResults').on('click', '#searchedUser', function () {
			// 다시 클릭 시 기존에 펼쳐진 것 감추기
			$('.dept-collapse').removeClass('show');
			let userNo = $(this).data('userNo');
			$(`#createChatroomParticipant\${userNo}`).prop("checked", true);
			let deptNo = $(this).data('deptNo');
			$(`#deptCollapse\${deptNo}`).addClass('show');
			// 검색창 초기화
			$('#userSearch').val('');
			$('.search-results-container').html('');
			$('#searchResults').addClass('d-none');
			$('.no-results').addClass('d-none');
		})

		// 부서 체크박스 체크와 해제 이벤트
		$('.dept-check').change(function () {
			let deptNo = $(this).data('deptNo');
			// #deptCollapse\${deptNo}안에 [data-dept-no가 deptNo인 것 중에 disabled가 아닌 것의 checked의 속성이 checked가 되게 한다.
			$(`#deptCollapse\${deptNo} :not([data-dept-no=\${deptNo}]:disabled)`)
					.prop('checked', $(this).prop("checked"))
		})

        // 방 생성 버튼 클릭 이벤트
		$('#createChatroomBtn').click(async function () {
			if ($('#chatroomTitle').val().trim().length === 0) {
				$('#noTitleAlarm').text('채팅창 제목이 비었습니다.');
				return false;
			}

			if ($('.user-check:checked').length < 2) {
				$('#noUserAlarm').text('체크된 사람이 없습니다.');
				return false;
			}

			let formData = $('#createChatroomForm').serialize();
			try {
				const response = await fetch('/ajax/chatroom', {
					method: 'POST',
                    // fetch는 직렬화한 값은 제대로 잡아주지 못해서 따로 설정해줘야 함
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
					body: formData
				})
				const result = await response.json();
				const data = await result.data;
				// 채팅방 목록에 추가
				appearAddedChatroom(data);

				// 취소 버튼 누르기
				$('.closeBtn').click();

				// 생성된 채팅방 클릭
				$(`#chatroom\${data.chatroomNo}`).click();
			} catch (error) {
				console.log('채팅방 생성 중 에러발생', error);
			}
		})

		// 새로만든 채팅방 바로 보여주기
		function appearAddedChatroom(chatroom) {
			let div = `
				<div class="border-bottom p-3 chatroom" id="chatroom\${chatroom.chatroomNo}" role="button" data-chatroom-no="\${chatroom.chatroomNo}">
					<div class="d-flex justify-content-between align-items-start">
						<h6 class="mb-1">\${chatroom.chatroomTitle}</h6>
						<small class="text-muted"></small>
					</div>
					<p class="mb-1 text-muted"></p>
					<div class="d-flex justify-content-between align-items-center">
						<small class="text-muted text-truncate me-2"></small>
						<span class="badge bg-primary rounded-pill not-read-count${chatroom.chatroomNo}"></span>
					</div>
				</div>
			`;
			$('.openCreateChatroomBtnDiv').after(div);
		}

		// 메뉴 쪽 새 채팅방 만들기 버튼을 눌렀을 때
		$('.openCreateChatroomBtn').on('click', function () {
			$('#createChatroomModalLabel').text('새 채팅방 만들기');
			$('#chatroomTitle').prop('disabled', false);
			$('#createChatroomBtn').removeClass('hide');
			$('#updateUsersInChatroomBtn').addClass('hide');
			resetChatroomModal();
		});

	  	// 방 생성 모달 창 초기화
		function resetChatroomModal() {
			// 모달 input 깨끗하게 하기
			$('#noTitleAlarm').text('');
			$('#noUserAlarm').text('');
			$('#chatroomTitle').val('');
			$('#userSearch').val('');
			$('.search-results-container').html('');
			$('#searchResults').addClass('d-none');
			$('.no-results').addClass('d-none');

			// 모든 체크 박스 원상 복귀
			$(`.dept-check`).prop('checked', false);
			$(`.user-check`).prop('checked', false);
			$(`.user-check`).removeAttr('disabled');
			$('#createChatroomParticipant${LOGIN_USERNO}').prop('checked', true);
			$('#createChatroomParticipant${LOGIN_USERNO}').prop('disabled', true);
		}

		<%-- 채팅방 생성 js 끝 --%>

		// 프로필 모달 등장
		$('#chat').on('click', '.participant-name', async function () {
			try {
				// 프로필 모달 열기
				profileModal.show();
				const userNo = $(this).data("userNo");

				// ajax로 이름을 클릭하면 data-user-no의 값으로 유저 정보들을 가져온다.
				const response = await fetch('/ajax/chat/profile/' + userNo);
				const result = await response.json();
				const data = await result.data;

				// 가져온 정보들을 집어넣는다.
				if (response.ok) {
					$('#profileImgDiv').html(`<img src="${s3}/resources/repository/userprofile/\${data.profileSrc}" alt="프로필" style="width: 160px; height: 160px;"/>`);
					$('#profileName').text(data.name);
					$('#profilePosition').text(data.positionName);
					$('#profileDept').text(data.deptName);
					$('#profileEmail').text(data.email);
					$('#profilePr').text(data.pr);
				} else {
					console.log('프로필 불러오기 실패', data.message);
				}
			} catch (error) {
				console.log('에러 메시지', error);
			}
		})

		// 유저 입장 퇴장 토스트
		function userJoinToast(data) {
			const toast = new bootstrap.Toast($('#userJoinToast')[0]);
			$('#userJoinToast .toast-body').text(data.text);
			toast.show();
		}

		// 온라인 표시
		function checkOnline(data) {
			let onlineUserIds = data.onlineUserIds;
			try {
				$('.span-online').text('');
				for (let onlineUserId of onlineUserIds) {
					$(`#span-online\${onlineUserId}`).text('온라인');
				}
			} catch (error) {
				console.log('온라인 표시 에러가 발생했습니다.', error)
			}
		}

		<%-- 채팅 관련 js 시작 --%>

		// 채팅 전송 후 화면에 내 채팅 보이기
		function appearSubmittedMyChat(chat) {
			return `
				\${chat.isFirst === 'Y' ? `
			<!-- 날짜 구분선 -->
			<div class="d-flex align-items-center my-4">
				<div class="border-bottom flex-grow-1"></div>
				<span class="mx-3 text-muted">\${chat.time.date}</span>
				<div class="border-bottom flex-grow-1"></div>
			</div>
				` : ``}
				<div class="mb-3 w-75 ms-auto">
					<div class="text-end mb-1">
						<strong>나</strong>
					</div>
					<div class="d-flex justify-content-end">
					\${chat.type === 'file' ? `
						<div class="bg-light rounded p-2 mb-1">
							<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
								<i class="bi bi-file-earmark me-2 fs-5"></i>
								<div class="flex-grow-1">
									<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
								</div>
								<i class="bi bi-download ms-2"></i>
							</a>
						</div>
						` : chat.type === 'image' ? `
						<div class="bg-light rounded p-2 mb-1">
							<div class="image-container">
								<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
								alt="첨부 이미지"
								class="img-fluid rounded cursor-pointer mb-2"
								style="max-height: 200px;"/>
								<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
									<div class="flex-grow-1">
										<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
									</div>
									<i class="bi bi-download ms-2"></i>
								</a>
							</div>
						</div>
						`
						: chat.type === 'emoji'
								? `
						<div class="bg-light rounded p-2 mb-1">
							<div class="image-container">
								<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
								alt="이모지"
								class="emoji-image"
								style="width: 128px; height: 128px; object-fit: contain;" />
							</div>
						</div>
						`
						: `
					<div class="bg-light rounded p-2 mb-1">
						\${chat.content}
					</div>
					`}
					</div>
					<div class="text-end">
						<small class="text-muted">\${chat.time.time}</small>
					</div>
				</div>
			`;
		}

		// 수신한 채팅 내 화면에 보이기
		function appearSubmittedOtherChat(chat) {
			return `
				\${chat.isFirst === 'Y' ? `
			<%-- 날짜 구분선 --%>
			<div class="d-flex align-items-center my-4">
				<div class="border-bottom flex-grow-1"></div>
				<span class="mx-3 text-muted">\${chat.time.date}</span>
				<div class="border-bottom flex-grow-1"></div>
			</div>
				` : ``}
				<div class="mb-3 w-75">
					<div class="d-flex align-items-center mb-1">
						<img src="${s3}/resources/repository/userprofile/\${chat.user.profileSrc}" alt="프로필" class="rounded-circle me-2" style="width: 40px; height: 40px;"/>
						<strong>\${chat.user.name}</strong>
					</div>
					<div class="d-flex">
					\${chat.type === 'file' ? `
					<div class="bg-light rounded p-2 mb-1">
						<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
							<i class="bi bi-file-earmark me-2 fs-5"></i>
							<div class="flex-grow-1">
								<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
							</div>
							<i class="bi bi-download ms-2"></i>
						</a>
					</div>
					` : chat.type === 'image' ? `
					<div class="bg-light rounded p-2 mb-1">
						<div class="image-container">
							<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
							alt="첨부 이미지"
							class="img-fluid rounded cursor-pointer mb-2"
							style="max-height: 200px;"/>
							<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
								<div class="flex-grow-1">
									<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
								</div>
								<i class="bi bi-download ms-2"></i>
							</a>
						</div>
					</div>
						`
						: chat.type === 'emoji'
								? `
					<div class="bg-light rounded p-2 mb-1">
						<div class="image-container">
							<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
							alt="이모지"
							class="emoji-image"
							style="width: 128px; height: 128px; object-fit: contain;" />
						</div>
					</div>
						`
						: `
					<div class="bg-light rounded p-2 mb-1">
						\${chat.content}
					</div>
						`}
					</div>
					<small class="text-muted">\${chat.time.time}</small>
				</div>
			`;
		}

		// 날짜와 시간 포맷
		function formatTime(unformattedTime) {
			const time = new Date(unformattedTime);

			const year = time.getFullYear();
			const month = time.getMonth() + 1;
			const day = time.getDate();

			let hours = time.getHours();
			const minutes = time.getMinutes();
			const ampm = hours >= 12 ? '오후' : '오전';
			hours = hours >= 12 ? hours - 12 : hours;

			const timeStr = `\${ampm} \${hours}시 \${minutes}분`;
			const dateStr = `\${year}년 \${month}월 \${day}일`;

			return {
				time: timeStr,
				date: dateStr
			};
		}

		// data의 기존의 date타입 대신 포맷된 date타입을 집어넣는다.
		function replaceFormatTime(data) {
			data.time = formatTime(data.time);
		}

		// 채팅방 제목과 참여중인 유저들을 ajax로 불러온다.
		async function ajaxTitleAndUsersData(chatroomNo) {
			try {
				const response = await fetch('/ajax/chatroom/' + chatroomNo,{
					method: 'GET'
				});
				const result = await response.json();
				const data = await result.data;
				if (response.ok) {
					return loadTitleAndUsers(data);
				} else {
					console.log('채팅방 제목과 참여중인 유저들을 ajax로 불러오지 못했습니다.', data.message);
				}
			} catch (error) {
				console.log('에러메시지', error);
			}
		}

		// 채팅방에 해당하는 채팅들을 ajax로 불러온다.
		async function ajaxChatsData(chatroomNo) {
			page = 1;
			try {
				const response = await fetch('/ajax/chat/' + page + '/' + chatroomNo);
				const result = await response.json();
				const data = result.data;
				if (response.ok) {
					data.data.map(item => replaceFormatTime(item));
					return loadChats(data);
				} else {
					console.log('채팅을 불러오는데 실패했습니다.', result.message);
				}
			} catch (error) {
				console.log('에러메시지', error);
			}
		}

		// 채팅방 제목과 참여자 목록 불러오기
		function loadTitleAndUsers(data) {
			return `
			  <!-- 채팅방 헤더 -->
			  <div class="border-bottom p-3 bg-light d-flex justify-content-between align-items-center">
				 <h5 class="mb-0">\${data.chatroomTitle}</h5>
				<%-- 나가기 버튼 --%>
				<div class="d-flex align-items-center gap-2">
					<button type="button" class="btn btn-outline-danger btn-sm" id="outChatroom">
						<i class="bi bi-box-arrow-right me-1"></i>나가기
					</button>
					 <div class="dropdown">
						<button type="button" class="btn btn-light" data-bs-toggle="dropdown">
						   <i class="fas fa-users"></i>
						</button>
						<!-- 참여자 목록 드롭다운 -->
						<ul class="dropdown-menu dropdown-menu-end p-3" style="width: 250px;">
						   <li>
							 <div class="d-flex justify-content-between align-items-center border-bottom pb-2">
							   <h6 class="mb-0">참여자 목록</h6>
							   <button type="button" class="btn btn-sm btn-light" id="addNewUserBtn" data-bs-toggle="modal" data-bs-target="#createChatroomModal">
								 <i class="bi bi-person-plus"></i>
							   </button>
							 </div>
						   </li>
						   <li id="participantList">
							  \${data.users.map((user) => `
							<div class="d-flex align-items-center my-2 participant-name-div" data-user-no="\${user.no}">
								<img src="${s3}/resources/repository/userprofile/\${user.profileSrc}" alt="프로필" class="rounded-circle me-2" style="width: 40px; height: 40px;">
								<div class="d-flex align-items-center gap-2">
									<span role="button" class="participant-name" data-user-no="\${user.no}" data-user-id="\${user.id}">\${user.name}</span>
									<span class="badge rounded-pill bg-success span-online" id="span-online\${user.id}" style="font-size: 0.7em;"></span>
								</div>
							</div>
								`).join('')}
						   </li>
						</ul>
					</div>
				 </div>
			  </div>
			`;
		}

		// 클릭한 채팅방에 맞는 채팅들 불러오기
		function loadChats(data) {
			return `
        <!-- 채팅 내용 영역 -->
        <div class="flex-grow-1 p-3 outer-chat-div" style="overflow-y: auto;">
            <div class="inner-chat-div">
                \${data.paging.last === true || data.paging.begin === 0
                    ? ``
                    : `
                        <div class="d-flex justify-content-center mb-3" id="loadMoreBtnDiv">
                            <button type="button" class="btn btn-light btn-sm rounded-pill px-4" id="loadMoreBtn">
                                <i class="bi bi-chevron-up me-1"></i>더 보기
                            </button>
                        </div>
                    `}
                \${data.data.map((chat) => `
                    \${chat.isFirst === 'Y'
                        ? `
                            <!-- 날짜 구분선 -->
                            <div class="d-flex align-items-center my-4">
                                <div class="border-bottom flex-grow-1"></div>
                                <span class="mx-3 text-muted">\${chat.time.date}</span>
                                <div class="border-bottom flex-grow-1"></div>
                            </div>
                        `
                        : ``}

                    \${chat.type === 'message'
                        ? `
                            <!-- 입장/퇴장 구분선 -->
                            <div class="d-flex align-items-center my-4">
                                <div class="border-bottom flex-grow-1"></div>
                                <div class="message">
                                    <span class="mx-3 text-muted">\${chat.content}</span>
                                </div>
                                <div class="border-bottom flex-grow-1"></div>
                            </div>
                        `
                        : `
                            \${LOGIN_USERNO === chat.user.no
                                ? `
                                    <div class="mb-3 w-75 ms-auto">
                                        <div class="text-end mb-1">
                                            <strong>나</strong>
                                        </div>
                                        <div class="d-flex justify-content-end">
											\${chat.type === 'file'
												? `
												<div class="bg-light rounded p-2 mb-1">
													<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
														<i class="bi bi-file-earmark me-2 fs-5"></i>
														<div class="flex-grow-1">
															<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
														</div>
														<i class="bi bi-download ms-2"></i>
													</a>
												</div>
													`
												: chat.type === 'image'
														? `
												<div class="bg-light rounded p-2 mb-1">
													<div class="image-container">
														<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
															alt="첨부 이미지"
															class="img-fluid rounded cursor-pointer mb-2"
															style="max-height: 200px;"/>
															<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
																<div class="flex-grow-1">
																	<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
																</div>
																<i class="bi bi-download ms-2"></i>
															</a>
														</div>
													</div>
													`
														: chat.type === 'emoji'
																? `
												<div class="bg-light rounded p-2 mb-1">
													<div class="image-container">
														<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
														 alt="이모지"
														 class="emoji-image"
														 style="width: 128px; height: 128px; object-fit: contain;" />
														</div>
													</div>
															`
														: `
													<div class="bg-light rounded p-2 mb-1">
														\${chat.content}
													</div>
															`}
                                        </div>
                                        <div class="text-end">
                                            <small class="text-muted">\${chat.time.time}</small>
                                        </div>
                                    </div>
                                `
                                : `
                                    <!-- 상대 메시지 -->
                                    <div class="mb-3 w-75">
                                        <div class="d-flex align-items-center mb-1">
                                            <img src="${s3}/resources/repository/userprofile/\${chat.user.profileSrc}" alt="프로필" class="rounded-circle me-2" style="width: 40px; height: 40px;"/>
                                            <strong>\${chat.user.name}</strong>
                                        </div>
                                        <div class="d-flex">
                                            <div class="bg-light rounded p-2 mb-1">
												\${chat.type === 'file'
													? `
												<div class="bg-light rounded p-2 mb-1">
													<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
														<i class="bi bi-file-earmark me-2 fs-5"></i>
														<div class="flex-grow-1">
															<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
														</div>
														<i class="bi bi-download ms-2"></i>
													</a>
												</div>
													`
													: chat.type === 'image'
															? `
												<div class="bg-light rounded p-2 mb-1">
													<div class="image-container">
														<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
															alt="첨부 이미지"
															class="img-fluid rounded cursor-pointer mb-2"
															style="max-height: 200px;"/>
															<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
																<div class="flex-grow-1">
																	<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
																</div>
																<i class="bi bi-download ms-2"></i>
															</a>
														</div>
													</div>
															`
															: chat.type === 'emoji'
																	? `
												<div class="bg-light rounded p-2 mb-1">
													<div class="image-container">
														<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
														 alt="이모지"
														 class="emoji-image"
														 style="width: 128px; height: 128px; object-fit: contain;" />
														</div>
													</div>
															`
															: `
													<div class="bg-light rounded p-2 mb-1">
														\${chat.content}
													</div>
															`}
                                            </div>
                                        </div>
                                        <small class="text-muted">\${chat.time.time}</small>
                                    </div>
                                `}
                        `}
                `).join('')}
            </div>
        </div>
    `;
		}

		function loadPlusChats(data) {
			return `
				<%-- 더 보기 버튼 --%>
				\${data.paging.last === false ? `
				<div class="d-flex justify-content-center mb-3" id="loadMoreBtnDiv">
					<button type="button" class="btn btn-light btn-sm rounded-pill px-4" id="loadMoreBtn">
						<i class="bi bi-chevron-up me-1"></i>더 보기
					</button>
				</div>
			`:``}
                \${data.data.map((chat) => `
                    \${chat.isFirst === 'Y' ? `
                            <%-- 날짜 구분선 --%>
                            <div class="d-flex align-items-center my-4">
                                <div class="border-bottom flex-grow-1"></div>
                                <span class="mx-3 text-muted">\${chat.time.date}</span>
                                <div class="border-bottom flex-grow-1"></div>
                            </div>
                        ` : ``}

                    \${chat.type === 'message' ? `
                            <%-- 입장/퇴장 구분선 --%>
                            <div class="d-flex align-items-center my-4">
                                <div class="border-bottom flex-grow-1"></div>
                                <div class="message">
                                    <span class="mx-3 text-muted">\${chat.content}</span>
                                </div>
                                <div class="border-bottom flex-grow-1"></div>
                            </div>
                        ` : ` \${LOGIN_USERNO === chat.user.no ? `
					<div class="mb-3 w-75 ms-auto">
						<div class="text-end mb-1">
							<strong>나</strong>
						</div>
					<div class="d-flex justify-content-end">
					\${chat.type === 'file' ? `
					<div class="bg-light rounded p-2 mb-1">
						<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
							<i class="bi bi-file-earmark me-2 fs-5"></i>
							<div class="flex-grow-1">
								<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
							</div>
							<i class="bi bi-download ms-2"></i>
						</a>
					</div>
							` : chat.type === 'image' ? `
					<div class="bg-light rounded p-2 mb-1">
						<div class="image-container">
							<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
								alt="첨부 이미지"
								class="img-fluid rounded cursor-pointer mb-2"
								style="max-height: 200px;"/>
								<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
									<div class="flex-grow-1">
										<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
									</div>
									<i class="bi bi-download ms-2"></i>
								</a>
							</div>
						</div>
						`
						: chat.type === 'emoji'
								? `
						<div class="bg-light rounded p-2 mb-1">
							<div class="image-container">
								<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
								 alt="이모지"
								 class="emoji-image"
								 style="width: 128px; height: 128px; object-fit: contain;" />
							</div>
						</div>
									`
									: `
						<div class="bg-light rounded p-2 mb-1">
							\${chat.content}
						</div>
															`}
				</div>
				<div class="text-end">
					<small class="text-muted">\${chat.time.time}</small>
				</div>
			</div>
				` : `
				<%-- 상대 메시지 --%>
				<div class="mb-3 w-75">
					<div class="d-flex align-items-center mb-1">
						<img src="${s3}/resources/repository/userprofile/\${chat.user.profileSrc}" alt="프로필" class="rounded-circle me-2" style="width: 40px; height: 40px;"/>
						<strong>\${chat.user.name}</strong>
					</div>
				<div class="d-flex">
					<div class="bg-light rounded p-2 mb-1">
						\${chat.type === 'file' ? `
						<div class="bg-light rounded p-2 mb-1">
							<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
								<i class="bi bi-file-earmark me-2 fs-5"></i>
								<div class="flex-grow-1">
									<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
								</div>
								<i class="bi bi-download ms-2"></i>
							</a>
						</div>
						` : chat.type === 'image' ? `
						<div class="bg-light rounded p-2 mb-1">
							<div class="image-container">
								<img src="${s3}/resources/repository/chat/\${chat.fileSrc}"
									alt="첨부 이미지"
									class="img-fluid rounded cursor-pointer mb-2"
									style="max-height: 200px;"/>
									<a href="/chat/download/\${chat.no}" class="d-flex align-items-center text-decoration-none text-dark" download>
										<div class="flex-grow-1">
											<div class="fw-medium">\${chat.fileSrc.substring(13)}</div>
										</div>
										<i class="bi bi-download ms-2"></i>
									</a>
								</div>
							</div>
							`
							: chat.type === 'emoji'
									? `
							<div class="bg-light rounded p-2 mb-1">
								<div class="image-container">
									<img src="${s3}/resources/repository/emoji/\${chat.emoji.fileSrc}"
									 alt="이모지"
									 class="emoji-image"
									 style="width: 128px; height: 128px; object-fit: contain;" />
								</div>
							</div>
									`
									: `
							<div class="bg-light rounded p-2 mb-1">
								\${chat.content}
							</div>
							`}
					</div>
				</div>
				<small class="text-muted">\${chat.time.time}</small>
			</div>
					`}
            	`}
			`).join('')}
		</div>
	`;
		}

		// 메시지 입력 폼 영역 불러오기
		function loadSubmitChatForm(chatroomNo) {
			return `
					<%-- 채팅 입력 전체 영역 --%>
					<div class="position-relative">
						<%-- 이모지 제안 영역 --%>
						<div id="emojiSuggestionsDiv" class="position-absolute start-0 w-100 bg-white border rounded-3 p-3 d-none" style="bottom: 120px;">
							<div class="row g-3" id="addEmojiDiv">
								<%-- 추가될 이모지들 --%>

							</div>
						</div>

						<%-- 메시지 입력 영역 --%>
						<form action="ajax/chat" method="post" encType="multipart/form-data">
							<div class="border-top p-3">
								<div class="input-group mb-3">
									<input type="file" class="form-control" id="fileInput" name="file" />
								</div>
								<div class="input-group chat-text" data-chatroom-no="${chatroomNo}">
									<input type="text" class="form-control" name="content" required placeholder="메시지를 입력하세요." />
									<button type="button" id="submitChat" class="btn btn-primary">전송</button>
								</div>
							</div>
						</form>
					</div>
				`;
		}

		<%-- 채팅 관련 js 끝 --%>
	</script>
</body>
</html>
let source; // EventSource 변수 전역 선언

// EventSource를 설정해서 서버와 연결
function initializeEventSource() {
    if (typeof(EventSource) !== "undefined") {
        if (source) {
            source.close();
        }

        source = new EventSource("http://localhost/api/notifications/register");

        source.onmessage = function(event) {
            showNotification(event.data); // 알림 메시지를 표시
        };

        source.onerror = function(event) {
            // console.log("현재 상태:", source.readyState);
            source.close();
        };

    } else {
        console.log("IE의 경우 크롬 또는 다른 브라우저를 이용해 주세요.");
    }
}

// 초기화 함수 호출 (한 번만 호출되도록 보장)
initializeEventSource();

// 알림 표시 여부를 저장하는 변수
let notificationShown = false;

// 토스트 UI로 알림 메시지를 표시하는 함수
function showNotification(message) {
    if (notificationShown) return; // 이미 알림이 표시된 경우 함수 종료

    const toastElement = document.getElementById('notificationToast');

    const toastBody = toastElement.querySelector('.toast-body');
    toastBody.innerHTML = message + ' <a class="icon-link icon-link-hover" style="--bs-icon-link-transform: translate3d(0, -.125rem, 0);" href="/approval/my/waitList">확인하러 가기</a>';

    const toast = new bootstrap.Toast(toastElement);
    toast.show();

    notificationShown = true; // 알림 표시 상태 업데이트
}

// 필요 시 알림을 다시 표시할 수 있도록 리셋하는 함수
function resetNotification() {
    notificationShown = false; // 알림 표시 상태 리셋
}

// 서버에 메시지를 전송할 필요가 있을 때, 별도의 API 호출을 통해 처리
function notifyUsers(title) {
    const message = "신규 결재 요청이 있습니다.";
    const requestData = {
        message: message
    };

    fetch('/api/notifications/send', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('네트워크 응답이 좋지 않습니다.');
        }
        showNotification(message);
    })
    .catch(error => {
        console.error('알림 전송 중 오류 발생:', error);
    });
}

// 닫기 버튼에 이벤트 리스너 추가
window.onload = function () {
    document.querySelector('.toastClose').addEventListener('click', function() {
        toast.hide();
    });
};

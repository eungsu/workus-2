
    $(document).ready(function() {
        // "일정 추가하기" 버튼 클릭 시 모달 열기
        $("#addScheduleBtn").on("click", function () {

            $("#meetingModalLabel").text("회의실 예약하기");

            $("#meetingModal #startDate").val("");
            $("#meetingModal #endDate").val("");
            $("#meetingModal #room").val("1");
            $("#meetingModal #content").val("");

            $("#calendarModal").data("eventId", null);

            $("#meetingModal").modal("show");
        });

        const roomColors = {
            a: '#007bff', // 회의실 A
            b: '#28a745'  // 회의실 B
        };

        let filter = "all";

        var calendarEl = $('#meeting')[0];

        // full-calendar 생성하기
        var calendar = new FullCalendar.Calendar(calendarEl, {
            schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
            height: 'auto',
            expandRows: true,            // 화면에 맞게 높이 조절
            slotMinTime: '06:00',        // Day 캘린더 시작 시간
            slotMaxTime: '22:00',        // Day 캘린더 종료 시간
            timeZone: 'UTC',
            headerToolbar: {
                left: 'prev,next',
                center: 'title',
                right: 'today'
            },
            initialView: 'resourceTimeline', // 초기 뷰 설정
            initialDate: new Date().toISOString().slice(0, 10),
            editable: true,
            selectable: true,
            aspectRatio: 1.5,
            resourceAreaHeaderContent: 'Rooms',
            resourceAreaWidth: '7.5%',
            scrollTime: '00:00:00',
            locale: 'ko',

            // 시간 라벨 형식 설정
            slotLabelFormat: {
                hour: '2-digit',
                minute: '2-digit',
                hour12: false // 24시간 형식으로 표시
            },

            resources: [
                { id: 'a', title: '회의실 A' },
                { id: 'b', title: '회의실 B' }
            ],

            events: function(info, successCallback, failureCallback) {
                start = info.startStr.split("T")[0];
                end = info.endStr.split("T")[0];

                console.log(start, end);

                $.ajax({
                    type: 'GET',
                    url: '/meeting/events',
                    data: {
                        start: info.startStr.split("T")[0],
                        end: info.endStr.split("T")[0],
                        filter: filter,
                    },
                    success: function(meetings) {
                        let events = meetings.map(function(meeting) {
                            let event = {};
                            event.id = meeting.no;
                            event.title = meeting.content;
                            event.start = meeting.startDate;
                            event.end = meeting.endDate;
                            event.resourceId = meeting.room;
                            event.color = roomColors[meeting.room] || '#6c757d';
                            return event;
                        });

                        console.log(events);
                        successCallback(events); // FullCalendar에 이벤트 렌더링
                    },
                    error: function(xhr, status, error) {
                        console.error("일정 불러오기 실패:", error);
                        failureCallback(error);
                    }
                });
            },

            eventClick: function(info) {
                info.jsEvent.stopPropagation();
                info.jsEvent.preventDefault();

                var eventId = info.event.id;
                console.log(eventId);  // 여기서 확인

                if (!eventId) {
                    console.error("이벤트 ID가 없습니다.");
                    return;
                }

                $.ajax({
                    type: 'post',
                    url: '/meeting/detail',
                    data: { id: eventId },
                    success: function (response) {
                        $("#meetingModal #startDate").val(response.startDate);
                        $("#meetingModal #endDate").val(response.endDate);
                        $("#meetingModal #room").val(response.room);
                        $("#meetingModal #content").val(response.content);

                        $("#meetingModalLabel").text("예약 정보");

                        $("#save").text("저장");
                        $("#delete").show();

                        $("#meetingModal").data("eventId", eventId);
                        $("#meetingModal").modal("show");

                    },
                    error: function(xhr, status, error) {
                        console.error("예약 정보 가져오기 실패:", error);
                    }
                });
            },

            dateClick: function (info){
                let startDate = info.dateStr;
                console.log(info);

                let localDate = new Date(startDate);
                let localDateString = localDate.toISOString().slice(0, 16);

                let endDate = new Date(localDate);
                endDate.setMinutes(localDate.getMinutes() + 30); // 30분 더함
                let endDateString = endDate.toISOString().slice(0, 16);

                $("#meetingModalLabel").text("회의실 예약하기");

                $("#meetingModal #startDate").val(localDateString);
                $("#meetingModal #endDate").val(endDateString);

                if (info.resource && info.resource.id === 'a') {
                    $("#meetingModal #room").val("a");
                } else if (info.resource && info.resource.id === 'b') {
                    $("#meetingModal #room").val("b");
                }

                $("#meetingModal #content").val("");
                $("#meetingModal").data("eventId", null);

                $("#delete").hide();
                $("#save").text("예약");

                $("#meetingModal").modal("show");

                calendar.unselect();
            },
            select: function (info) {
                let startDate = info.startStr;
                let endDate = info.endStr;

                console.log(info);

                $("#meetingModalLabel").text("회의실 예약하기");

                $("#meetingModal #startDate").val(startDate.slice(0, 16)); // ISO 포맷 조정
                $("#meetingModal #endDate").val(endDate.slice(0, 16)); // ISO 포맷 조정

                if (info.resource && info.resource.id === 'a') {
                    $("#meetingModal #room").val("a"); // 회의실 A
                } else if (info.resource && info.resource.id === 'b') {
                    $("#meetingModal #room").val("b"); // 회의실 B
                }

                $("#meetingModal #content").val("");
                $("#meetingModal").data("eventId", null); // eventId 초기화

                $("#delete").hide();
                $("#save").text("예약");

                $("#meetingModal").modal("show");

                calendar.unselect();
            }

        });

        $("#save").on("click", function () {
            var eventData = {
                startDate: new Date($("#startDate").val()).toISOString(),
                endDate: new Date($("#endDate").val()).toISOString(),
                room: $("#room").val() || "a",
                content: $("#content").val()
            };

            if (!eventData.startDate || !eventData.endDate || !eventData.content) {
                alert("입력하지 않은 값이 있습니다.");
                return;
            }

            if (new Date(eventData.startDate) > new Date(eventData.endDate)) {
                alert("끝나는 시간이 시작 시간보다 클 수 없습니다.");
                return;
            }

            var eventId = $("#meetingModal").data("eventId");

            console.log(eventId)

            if (eventId) {
                $.ajax({
                    // 기존 일정을 수정하는 경우
                    type: "post",
                    url: "/meeting/update",
                    data: { id: eventId, ...eventData },
                    success: function (result) {
                        var event = calendar.getEventById(eventId);
                        event.setStart(result.startDate);
                        event.setEnd(result.endDate);
                        event.setExtendedProp('division', result.room);
                        event.setProp('title', result.content);

                        $("#save").text("저장");
                        $("#meetingModal").modal("hide");

                        $("#startDate, #endDate, #room, #content").val("");
                    },
                    error: function (xhr, status, error) {
                        console.error("일정 수정 실패:", error);
                    }
                });
            } else {
                // 새로운 일정을 추가하는 경우
                $.ajax({
                    type: "post",
                    url: "/meeting/add",
                    data: eventData,
                    success: function (result) {
                        calendar.addEvent({
                            id: result.no,
                            start: result.startDate,
                            end: result.endDate,
                            resourceId: result.room,
                            extendedProps: {
                                room: result.room,
                                content: result.content,
                                userNo: result.userNo,
                            }
                        });

                        $("#meetingModal").modal("hide");
                        $("#name, #location, #startDate, #endDate, #division, #content").val("");

                        console.log("일정이 추가되었습니다.");
                    },
                    error: function (xhr, status, error) {
                        console.error("일정 추가 실패:", error);
                    }
                });
            }
        });

        $("#delete").on("click", function (){
            var eventId = $("#meetingModal").data("eventId");
            if (!eventId) {
                alert("삭제할 수 없습니다.");
                return;
            }

            // 삭제 확인 모달 열기
            $("#confirmDeleteModal").modal("show");

            $("#confirmDeleteModal .btn-danger").off("click").on("click", function () {
                $.ajax({
                    type: "POST",
                    url: "/meeting/delete",
                    data: { id: eventId },
                    success: function () {
                        var event = calendar.getEventById(eventId);
                        if (event) {
                            event.remove();
                        }

                        alert("일정이 삭제되었습니다.");
                        $("#meetingModal").data("eventId", null);

                        $("#meetingModal").modal("hide");
                        $("#confirmDeleteModal").modal("hide");  // 확인 모달 닫기
                    },
                    error: function (xhr, status, error) {
                        console.error("일정 삭제 실패:", error);
                        alert("일정 삭제에 실패했습니다. 다시 시도해주세요.");
                        $("#confirmDeleteModal").modal("hide");  // 확인 모달 닫기
                    }
                });
            });

            // 취소 버튼 클릭 시 경고창 닫기
            $("#confirmDeleteModal .btn-secondary").off("click").on("click", function() {
                $("#confirmDeleteModal").modal("hide");
            });

        })

        // 캘린더 렌더링
        calendar.render();

        // 내 예약 현황 클릭 이벤트
        $('#myReservation').on('click', function () {
            filter = "myReservation";

            calendar.changeView('listMonth'); // 'listMonth' 뷰로 변경
            calendar.setOption('height', '800px');
            calendar.setOption('resourceAreaWidth', '30%');

            // 밑줄 효과 관리
            $('.lnb li, .listTitle').removeClass('on'); // 모든 on 클래스 제거
            $(this).closest('li').addClass('on'); // 클릭된 항목에 추가

            calendar.refetchEvents();
        });

        // 회의실 클릭 이벤트
        $('#meetingRoom').on('click', function () {
            filter = "all";

            calendar.changeView('resourceTimeline'); // 'resourceTimeline' 뷰로 변경
            calendar.scrollToTime('00:00:00'); // 선택한 뷰로 스크롤 이동
            calendar.setOption('resources', [
                {"id": "a", "title": "회의실 A"},
                {"id": "b", "title": "회의실 B"}
            ]);
            calendar.setOption('height', 'auto'); // 캘린더 높이를 320px로 설정
            calendar.setOption('resourceAreaWidth', '7.5%');

            // 밑줄 효과 관리
            $('.lnb li, .listTitle').removeClass('on'); // 모든 on 클래스 제거
            $(this).addClass('on'); // 클릭된 p 태그에 'on' 클래스 추가

            calendar.refetchEvents();
        });

        // 회의실 A 클릭 이벤트
        $('#meetingRoomA').on('click', function () {
            filter = "all";

            calendar.changeView('resourceTimeGridWeek'); // 'resourceTimeGridDay' 뷰로 변경
            calendar.scrollToTime('00:00:00'); // 선택한 뷰로 스크롤 이동
            calendar.setOption('resources', [
                {"id": "a", "title": "회의실 A"} // 회의실 A만 표시
            ]);
            calendar.setOption('height', '800px');
            calendar.setOption('resourceAreaWidth', '30%');

            // 밑줄 효과 관리
            $('.lnb li, .listTitle').removeClass('on');
            $(this).closest('li').addClass('on');

            calendar.refetchEvents();
        });

        // 회의실 B 클릭 이벤트
        $('#meetingRoomB').on('click', function () {
            filter = "all";

            calendar.changeView('resourceTimeGridWeek'); // 'resourceTimeGridDay' 뷰로 변경
            calendar.scrollToTime('00:00:00'); // 선택한 뷰로 스크롤 이동
            calendar.setOption('resources', [
                {"id": "b", "title": "회의실 B"} // 회의실 B만 표시
            ]);
            calendar.setOption('height', '800px');
            calendar.setOption('resourceAreaWidth', '30%');

            // 밑줄 효과 관리
            $('.lnb li, .listTitle').removeClass('on');
            $(this).closest('li').addClass('on');

            calendar.refetchEvents();
        });
    });



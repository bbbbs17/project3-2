<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ClothRepository" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>나의 코디 - 달력</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar/main.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f4f4; /* 연한 회색 배경 */
            font-family: 'Arial', sans-serif;
            color: #333; /* 어두운 회색 텍스트 */
        }

        h1, h2, h3 {
            color: #222; /* 더 어두운 텍스트 색상 */
        }

        .card-img-top {
            object-fit: cover;
            width: 100%;
            height: 200px;
        }

        .outfit-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            background-color: #ffffff; /* 하얀 배경 */
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .btn {
            background-color: #333; /* 어두운 회색 버튼 */
            color: white;
            border: none;
            font-size: 1rem;
            border-radius: 5px;
            padding: 10px 20px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #555; /* 호버 시 밝은 회색으로 변경 */
        }

        .btn-lg {
            font-size: 1.25rem;
        }

        #calendar {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        .d-flex.justify-content-between {
            margin-bottom: 40px;
        }

        .text-muted {
            color: #777; /* 흐린 텍스트 색상 */
        }

        .btn-secondary {
            background-color: #222; /* 어두운 회색 배경 */
            border-color: #444; /* 버튼 경계색 */
        }

        .btn-secondary:hover {
            background-color: #444; /* 호버 시 버튼 색상 변화 */
        }
    </style>
</head>
<body>
<div class="container py-4">
    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <!-- 홈 버튼 -->
        <a href="welcome.jsp" class="btn btn-secondary btn-lg">홈으로</a>
        <h1 class="text-center flex-grow-1">ootd 달력</h1>
        <!-- 나의 옷장 보기 버튼 -->
        <a href="myItems.jsp" class="btn btn-primary btn-lg">나의 옷장 보기</a>
    </div>

    <!-- 새 코디 추가 버튼 -->
    <div class="mb-4 text-end">
        <a href="createOutfit.jsp" class="btn btn-success btn-lg">새 코디 추가</a>
    </div>

    <!-- 달력 섹션 -->
    <div id="calendar"></div>

    <!-- 코디 상세 보기 -->
    <div id="outfitDetails" class="mt-4">
        <%
            // 데이터베이스에서 코디 데이터를 가져오기
            ClothRepository repository = ClothRepository.getInstance();
            List<Map<String, Object>> outfits = repository.getAllOutfits();

            // 디버깅: 콘솔에서 데이터 확인
            System.out.println("Outfits loaded from database:");
            for (Map<String, Object> outfit : outfits) {
                System.out.println(outfit);
            }

            if (outfits.isEmpty()) {
        %>
        <div class="text-center">
            <p class="text-muted">저장된 코디가 없습니다. 새 코디를 추가해보세요!</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar/main.min.js"></script>
<%
    // 중복 제거를 위한 Set 사용
    Set<String> uniqueDates = new HashSet<>();
%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('calendar');

        if (!calendarEl) {
            console.error('Calendar element not found!');
            return;
        }

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            timeZone: 'local',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            events: [
                <%-- JSP에서 중복된 날짜 제거 --%>
                <%
                    for (Map<String, Object> outfit : outfits) {
                        String outfitName = (String) outfit.get("outfit_name");
                        String memo = (String) outfit.get("memo"); // 메모 데이터 추가
                        java.sql.Date startDate = (java.sql.Date) outfit.get("start_date");

                        // 중복 제거: 이미 추가된 날짜는 건너뛰기
                        if (startDate != null && !uniqueDates.contains(startDate.toString())) {
                            uniqueDates.add(startDate.toString());
                %>
                {
                    title: "<%= outfitName %>",
                    start: "<%= startDate.toString() %>",
                    extendedProps: {
                        memo: "<%= memo %>" // 메모 추가
                    }
                },
                <%
                        }
                    }
                %>
            ],
            // 마우스 오버 시 메모 표시
            eventMouseEnter: function (info) {
                const memo = info.event.extendedProps.memo || "메모가 없습니다.";
                const tooltip = document.createElement('div');
                tooltip.id = 'event-tooltip';
                tooltip.style.position = 'fixed';
                tooltip.style.top = '50%';
                tooltip.style.left = '50%';
                tooltip.style.transform = 'translate(-50%, -50%)';
                tooltip.style.backgroundColor = '#fff';
                tooltip.style.border = '1px solid #ccc';
                tooltip.style.padding = '20px';
                tooltip.style.boxShadow = '0px 4px 10px rgba(0, 0, 0, 0.3)';
                tooltip.style.borderRadius = '10px';
                tooltip.style.zIndex = 1000;
                tooltip.style.animation = 'fadeIn 0.3s ease-in-out';
                tooltip.innerText = memo;

                // 팝업 스타일 개선
                tooltip.style.fontSize = '16px';
                tooltip.style.color = '#333';
                tooltip.style.textAlign = 'center';
                tooltip.style.maxWidth = '300px';

                document.body.appendChild(tooltip);

                // 마우스를 움직이면 팝업 위치 변경 (비활성화)
                document.addEventListener('mousemove', function (e) {}, { once: true });
            },
            // 마우스가 이벤트에서 떠날 때 팝업 제거
            eventMouseLeave: function () {
                const tooltip = document.getElementById('event-tooltip');
                if (tooltip) {
                    tooltip.remove();
                }
            },
            // 기존 클릭 이벤트 복원
            eventClick: function (info) {
                console.log('Event clicked:', info);

                if (!info.event.start) {
                    console.error('info.event.start is null or undefined.');
                    return;
                }

                try {
                    const clickedDate = new Date(info.event.start);

                    // 템플릿 리터럴 대신 문자열 연결로 날짜 포맷팅
                    const year = clickedDate.getFullYear();
                    const month = (clickedDate.getMonth() + 1 < 10 ? '0' : '') + (clickedDate.getMonth() + 1);
                    const day = (clickedDate.getDate() < 10 ? '0' : '') + clickedDate.getDate();

                    const formattedDate = year + '-' + month + '-' + day;

                    console.log('Formatted date:', formattedDate);

                    if (formattedDate) {
                        window.location.href = 'viewOutfits.jsp?date=' + formattedDate;
                    } else {
                        console.error('Formatted date is invalid or empty.');
                    }
                } catch (error) {
                    console.error('Error while formatting the date:', error);
                }
            }
        });

        calendar.render();
    });

    // CSS 애니메이션 추가
    const style = document.createElement('style');
    style.innerHTML = `
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }
    `;
    document.head.appendChild(style);
</script>

</body>
</html>

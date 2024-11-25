<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <title>나의 코디 - 달력</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar/main.min.css" rel="stylesheet">
    <style>
        #calendar {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
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
            background-color: #f9f9f9;
            margin-bottom: 20px;
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
                <%-- JSP에서 데이터베이스에서 가져온 이벤트 데이터 추가 --%>
                <%
                    for (Map<String, Object> outfit : outfits) {
                        String outfitName = (String) outfit.get("outfit_name");
                        java.sql.Date startDate = (java.sql.Date) outfit.get("start_date");
                %>
                {
                    title: "<%= outfitName %>",
                    start: "<%= startDate != null ? startDate.toString() : "" %>"
                },
                <%
                    }
                %>
            ],
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


</script>

</body>
</html>

<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ClothRepository" %>

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
    <h1 class="mb-4 text-center">ootd 달력</h1>

    <!-- 새 코디 추가 버튼 -->
    <div class="mb-4 text-end">
        <a href="createOutfit.jsp" class="btn btn-success btn-lg">새 코디 추가</a>
    </div>

    <!-- 달력 섹션 -->
    <div id="calendar"></div>

    <!-- 코디 상세 보기 -->
    <div id="outfitDetails" class="mt-4">
        <%
            // 코디 데이터를 가져오기
            ClothRepository repository = ClothRepository.getInstance();
            List<Map<String, Object>> outfits = repository.getAllOutfits();

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
        console.log('Initializing FullCalendar...');
        const calendarEl = document.getElementById('calendar');

        if (!calendarEl) {
            console.error('Calendar element not found!');
            return;
        }

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            events: [
                <%-- 이벤트 추가 --%>
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
            ]
        });

        console.log('Rendering FullCalendar...');
        calendar.render();
        console.log('FullCalendar rendered successfully.');
    });
</script>

</body>
</html>

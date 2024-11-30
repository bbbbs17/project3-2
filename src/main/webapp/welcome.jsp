<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나만의 옷장</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 기본 스타일 */
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; /* 스크롤 방지 */
        }

        /* 배경 이미지 설정 */
        .background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('resources/배경.jpg'); /* 배경 이미지 URL */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -1; /* 배경이 텍스트 아래에 위치하도록 설정 */
        }

        /* 로딩 화면 스타일 */
        .loading {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 2rem;
            z-index: 9999;
        }

        /* 텍스트와 버튼 영역 */
        .content {
            position: relative;
            text-align: center;
            color: white;
            visibility: hidden; /* 처음에는 숨겨놓음 */
            opacity: 0;
            transition: opacity 0.5s ease-in-out; /* 텍스트가 부드럽게 나타나도록 설정 */
        }

        .btn {
            background-color: #333;
            color: white;
            border-radius: 5px;
            font-size: 1.25rem;
            padding: 12px 25px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #555;
        }

        .header-title {
            font-size: 3rem;
            font-weight: bold;
        }

        .tagline {
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .time {
            font-size: 1.25rem;
        }
    </style>
</head>
<body>

<!-- 배경 이미지 -->
<div class="background"></div>

<!-- 로딩 화면 -->
<div id="loading" class="loading">로딩 중...</div>

<!-- 텍스트와 배경 이미지 -->
<div class="content">
    <%@ include file="menu.jsp" %>

    <%!
        String greeting = "나만의 옷장에 오신걸 환영합니다.";
        String tagline = "Welcome to Your Closet Manager!";
    %>

    <h1 class="header-title"><%=greeting%></h1>
    <p class="tagline">Closet Management System</p>

    <!-- 현재 시간 표시 -->
    <div class="mt-4">
        <%
            response.setIntHeader("Refresh", 5);
            Date day = new java.util.Date();
            String am_pm;
            int hour = day.getHours();
            int minute = day.getMinutes();
            int second = day.getSeconds();
            if (hour / 12 == 0) {
                am_pm = "AM";
            } else {
                am_pm = "PM";
                if (hour > 12) hour -= 12;
            }
            String CT = String.format("%02d:%02d:%02d %s", hour, minute, second, am_pm);
        %>
        <p class="time">현재 접속 시각: <%= CT %></p>
    </div>

    <!-- 버튼 섹션 -->
    <div class="mt-4">
        <a href="clothList.jsp" class="btn">나의 옷장 보기</a>
    </div>

    <%@ include file="footer.jsp" %>
</div>

<!-- 배경 이미지 로딩 후 텍스트 표시 -->
<script>
    window.onload = function() {
        // 배경 이미지가 로딩되었을 때 텍스트 표시
        var loading = document.getElementById('loading');
        var content = document.querySelector('.content');

        // 배경 이미지 로드 확인 후 처리
        var img = new Image();
        img.src = 'resources/배경.jpg'; // 배경 이미지 경로
        img.onload = function() {
            // 로딩 화면 숨기기
            loading.style.display = 'none';
            // 텍스트 보이게 설정
            content.style.visibility = 'visible';
            content.style.opacity = 1; // 부드럽게 보이도록
        };

        // 이미지 로드가 이미 완료된 경우 처리
        if (img.complete) {
            loading.style.display = 'none';
            content.style.visibility = 'visible';
            content.style.opacity = 1;
        }
    };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

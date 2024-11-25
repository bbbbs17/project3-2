<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <title>코디 보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card-img-top {
            object-fit: cover;
            width: 100%;
            height: 200px;
        }
        .card {
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <!-- 상단 네비게이션 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="myOutfits.jsp" class="btn btn-secondary btn-lg">달력으로 돌아가기</a>
        <h1 class="text-center flex-grow-1">코디 보기</h1>
    </div>

    <%
        // GET 파라미터에서 date 값 읽기
        String selectedDate = request.getParameter("date");

        // 디버깅: date 값 확인
        System.out.println("Received date parameter: " + selectedDate);

        // 날짜가 없거나 유효하지 않은 경우 처리
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
    %>
    <div class="text-center">
        <p class="text-danger">유효하지 않은 날짜입니다. 다시 시도해주세요.</p>
    </div>
    <%
    } else {
        // 데이터베이스에서 해당 날짜의 코디 조회
        ClothRepository repository = ClothRepository.getInstance();
        List<Map<String, Object>> outfits = repository.getOutfitsByDate(selectedDate);

        // 디버깅: 조회된 데이터 출력
        System.out.println("Outfits for selected date (" + selectedDate + "): " + outfits);

        if (outfits.isEmpty()) {
    %>
    <div class="text-center">
        <p class="text-muted">해당 날짜에 저장된 코디가 없습니다.</p>
    </div>
    <%
    } else {
    %>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <%
            // 조회된 코디 데이터를 화면에 출력
            for (Map<String, Object> outfit : outfits) {
                String clothName = (String) outfit.get("cloth_name");
                String imageUrl = (String) outfit.get("imageUrl");

                // 디버깅: 개별 코디 데이터 출력
                System.out.println("Cloth Name: " + clothName + ", Image URL: " + imageUrl);
        %>
        <div class="col">
            <div class="card h-100">
                <img src="<%= request.getContextPath() + '/' + imageUrl %>" class="card-img-top" alt="<%= clothName %>">
                <div class="card-body">
                    <h5 class="card-title"><%= clothName %></h5>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
            }
        }
    %>
</div>
</body>
</html>

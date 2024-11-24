<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ClothRepository" %>

<!DOCTYPE html>
<html>
<head>
    <title>코디 보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <a href="myOutfits.jsp" class="btn btn-secondary mb-4">달력으로 돌아가기</a>
    <h1 class="mb-4">코디 보기 -</h1>
    <%
        // 파라미터로 전달된 날짜
        String date = request.getParameter("date");
        ClothRepository repository = ClothRepository.getInstance();

        // 해당 날짜의 코디 데이터를 가져옴
        List<Map<String, Object>> outfits = repository.getOutfitsByDate(date);

        if (outfits.isEmpty()) {
    %>
    <p class="text-muted">해당 날짜에 저장된 코디가 없습니다.</p>
    <%
    } else {
        for (Map<String, Object> outfit : outfits) {
            String clothName = (String) outfit.get("cloth_name");
            String imageUrl = (String) outfit.get("imageUrl");
    %>
    <div class="card mb-3" style="max-width: 540px;">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="<%= request.getContextPath() + '/' + imageUrl %>" class="img-fluid rounded-start" alt="<%= clothName %>">
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title"><%= clothName %></h5>
                </div>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>
</div>
</body>
</html>

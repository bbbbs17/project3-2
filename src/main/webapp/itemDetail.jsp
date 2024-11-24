<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>아이템 상세보기</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <%
        int id = Integer.parseInt(request.getParameter("id"));
        ClothRepository repository = ClothRepository.getInstance();
        Cloth cloth = repository.getClothById(id); // ID로 Cloth 조회
    %>

    <div class="card mx-auto" style="max-width: 600px;">
        <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" class="card-img-top" alt="옷 이미지">
        <div class="card-body">
            <h5 class="card-title"><%= cloth.getName() %></h5>
            <p class="card-text">
                <strong>카테고리:</strong> <%= cloth.getCategory() %><br>
                <strong>색상:</strong> <%= cloth.getColor() %><br>
                <strong>사이즈:</strong> <%= cloth.getSize() %><br>
                <strong>계절:</strong> <%= cloth.getSeason() %>
            </p>
            <a href="myItems.jsp" class="btn btn-primary">목록으로 돌아가기</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>옷 목록</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">나의 옷장</h1>
            <p class="col-md-8 fs-4">Clothing List</p>
        </div>
    </div>

    <!-- 두 개의 버튼 -->
    <div class="text-center">
        <a href="myOutfits.jsp" class="btn btn-primary mb-4">나의 완성된 코디 보기</a>
        <a href="myItems.jsp" class="btn btn-secondary mb-4">나의 옷(아이템) 보기</a>
    </div>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

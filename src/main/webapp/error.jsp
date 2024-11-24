<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>오류 발생</title>
</head>
<body>
<h1>오류가 발생했습니다</h1>
<p><%= request.getAttribute("errorMessage") %></p>
<a href="createOutfit.jsp">코디 생성 페이지로 돌아가기</a>
</body>
</html>

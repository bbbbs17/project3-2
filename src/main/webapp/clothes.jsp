<%@ page import="java.util.List" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<%@ page contentType="text/html; charset=utf-8" %>

<%
  // ClothRepository 인스턴스 가져오기
  ClothRepository repository = ClothRepository.getInstance();

  // 옷 목록 가져오기
  List<Cloth> clothes = repository.getAllClothes();
%>
<!DOCTYPE html>
<html>
<head>
  <title>옷 목록</title>
</head>
<body>
<h2>옷 목록</h2>
<ul>
  <% if (clothes.isEmpty()) { %>
  <li>등록된 옷이 없습니다.</li>
  <% } else {
    for (Cloth cloth : clothes) { %>
  <li>
    <strong>이름:</strong> <%= cloth.getName() %> |
    <strong>카테고리:</strong> <%= cloth.getCategory() %> |
    <strong>색상:</strong> <%= cloth.getColor() %>
  </li>
  <% } } %>
</ul>
</body>
</html>

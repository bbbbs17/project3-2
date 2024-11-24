<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card-img-top {
            object-fit: cover;
            width: 100%;
            height: 200px;
        }
    </style>
    <title>나의 옷 아이템</title>
    <script>
        function filterItems() {
            const filterCategory = document.getElementById("filterCategory").value;
            const filterSeason = document.getElementById("filterSeason").value;

            const items = document.querySelectorAll(".cloth-item");
            items.forEach(item => {
                const itemCategory = item.getAttribute("data-category");
                const itemSeason = item.getAttribute("data-season");

                if ((filterCategory === "전체" || itemCategory === filterCategory) &&
                    (filterSeason === "전체" || itemSeason === filterSeason)) {
                    item.style.display = "block";
                } else {
                    item.style.display = "none";
                }
            });
        }
    </script>
</head>
<body>
<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5 text-center">
            <h1 class="display-5 fw-bold">나의 옷장</h1>
            <p class="col-md-8 fs-4 mx-auto">여기에 나의 모든 옷을 관리하세요!</p>
            <a href="addCloth.jsp" class="btn btn-primary btn-lg mt-3">옷 추가하기</a>
        </div>
    </div>

    <!-- 추가된 ootd(달력) 보러가기 버튼 -->
    <div class="text-end mb-4">
        <a href="myOutfits.jsp" class="btn btn-info btn-lg">ootd(달력) 보러가기</a>
    </div>

    <!-- 필터 버튼 -->
    <div class="row mb-4">
        <div class="col-md-6">
            <label for="filterCategory" class="form-label">카테고리 필터</label>
            <select id="filterCategory" class="form-select" onchange="filterItems()">
                <option value="전체">전체</option>
                <option value="상의">상의</option>
                <option value="하의">하의</option>
                <option value="아우터">아우터</option>
                <option value="악세사리">악세사리</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="filterSeason" class="form-label">계절 필터</label>
            <select id="filterSeason" class="form-select" onchange="filterItems()">
                <option value="전체">전체</option>
                <option value="봄">봄</option>
                <option value="여름">여름</option>
                <option value="가을">가을</option>
                <option value="겨울">겨울</option>
            </select>
        </div>
    </div>

    <div class="row align-items-md-stretch text-center">
        <%
            ClothRepository repository = ClothRepository.getInstance();
            List<Cloth> clothes = repository.getAllClothes();

            if (clothes.isEmpty()) {
        %>
        <div class="col-md-12">
            <div class="h-100 p-5">
                <h3>아직 등록된 옷이 없습니다.</h3>
                <p>새로운 옷을 추가하고 나만의 옷장을 시작해보세요!</p>
                <a href="addCloth.jsp" class="btn btn-success mb-4">옷 추가하기</a>
            </div>
        </div>
        <%
        } else {
        %>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <%
                for (Cloth cloth : clothes) {
            %>
            <div class="col cloth-item" data-category="<%= cloth.getCategory() %>" data-season="<%= cloth.getSeason() %>">
                <div class="card h-100">
                    <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" class="card-img-top" alt="옷 이미지">
                    <div class="card-body">
                        <h5 class="card-title"><%= cloth.getName() %></h5>
                        <a href="itemDetail.jsp?id=<%= cloth.getId() %>" class="btn btn-secondary mt-2">상세보기</a>
                        <!-- 삭제 버튼 추가 -->
                        <form action="deleteCloth" method="post" style="display:inline;">
                            <input type="hidden" name="clothId" value="<%= cloth.getId() %>">
                            <button type="submit" class="btn btn-danger mt-2">삭제</button>
                        </form>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        <% } %>
    </div>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

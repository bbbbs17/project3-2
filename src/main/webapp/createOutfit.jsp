<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>코디 생성</title>
    <style>
        .card-img-top {
            object-fit: contain;  /* 이미지 비율 유지하면서 크기 조정 */
            width: 100%;
            height: 200px;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <h1 class="mb-4 text-center">새로운 코디 만들기</h1>

    <form action="saveOutfit" method="post">
        <!-- 코디 이름 입력 -->
        <div class="mb-3">
            <label for="outfitName" class="form-label">코디 이름</label>
            <input type="text" class="form-control" id="outfitName" name="outfitName" required>
        </div>

        <!-- 날짜 선택 -->
        <div class="mb-3">
            <label for="startDate" class="form-label">날짜 선택</label>
            <input type="date" id="startDate" name="startDate" class="form-control" required>
        </div>

        <!-- 메모 입력 -->
        <div class="mb-3">
            <label for="memo" class="form-label">메모</label>
            <textarea id="memo" name="memo" class="form-control" rows="4" placeholder="코디와 관련된 메모를 입력하세요."></textarea>
        </div>

        <!-- 카테고리 선택 -->
        <div class="mb-3">
            <label for="category" class="form-label">카테고리 선택</label>
            <select id="category" name="category" class="form-control" onchange="filterClothes()">
                <option value="">모든 카테고리</option>
                <option value="상의">상의</option>
                <option value="하의">하의</option>
                <option value="아우터">아우터</option>
                <option value="신발">신발</option>
                <!-- 다른 카테고리 추가 가능 -->
            </select>
        </div>

        <!-- 옷 선택 -->
        <h3 class="mb-3">옷 선택</h3>
        <div class="row">
            <%
                // 데이터베이스에서 옷 목록 가져오기
                ClothRepository repository = ClothRepository.getInstance();
                List<Cloth> clothes = repository.getAllClothes();

                if (clothes.isEmpty()) {
            %>
            <!-- 옷이 없는 경우 -->
            <p>옷이 없습니다. 옷을 추가하세요!</p>
            <%
            } else {
                // 옷 목록 출력
                for (Cloth cloth : clothes) {
            %>
            <div class="col-md-4 cloth-item" data-category="<%= cloth.getCategory() %>">
                <div class="card mb-3">
                    <!-- 옷 이미지 -->
                    <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" class="card-img-top" alt="옷 이미지">
                    <div class="card-body text-center">
                        <h5 class="card-title"><%= cloth.getName() %></h5>
                        <!-- 체크박스: 옷 ID 값 전송 -->
                        <input type="checkbox" name="selectedClothes" value="<%= cloth.getId() %>"> 선택
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div> <!-- 닫히지 않은 div 추가 -->

        <!-- 저장 버튼 -->
        <div class="text-center mt-4">
            <button type="submit" class="btn btn-success btn-lg">코디 저장</button>
        </div>
    </form>
</div>

<!-- JavaScript -->
<script>
    function filterClothes() {
        const category = document.getElementById("category").value;  // 선택된 카테고리
        const clothesDivs = document.querySelectorAll(".cloth-item"); // 모든 옷 항목

        clothesDivs.forEach(function (div) {
            const clothCategory = div.getAttribute("data-category");  // 각 옷의 카테고리
            if (category === "" || category === clothCategory) {
                div.style.display = "block";  // 선택된 카테고리일 경우 보이게
            } else {
                div.style.display = "none";   // 아니면 숨김
            }
        });
    }
</script>

</body>
</html>

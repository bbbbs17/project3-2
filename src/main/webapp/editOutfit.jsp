<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="dao.ClothRepository" %>
<%@ page import="dto.Cloth" %>
<!DOCTYPE html>
<html>
<head>
    <title>코디 수정</title>
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
        .delete-section {
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="myOutfits.jsp" class="btn btn-secondary btn-lg">달력으로 돌아가기</a>
        <h1 class="text-center flex-grow-1">코디 수정</h1>
    </div>

    <%
        // GET 또는 POST 파라미터에서 date 값 읽기
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
        // 중복 제거를 위한 Set 생성
        Set<Integer> uniqueOutfitIds = new HashSet<>();
        Map<String, Object> outfit = outfits.get(0); // 첫 번째 코디 데이터 사용
        String outfitName = (String) outfit.get("outfit_name"); // 코디 이름 사용

        String memo = (String) outfit.get("memo");
        String startDate = (String) outfit.get("start_date");
    %>

    <!-- 수정 폼 -->
    <form action="updateOutfit" method="post">
        <!-- 코디 이름 수정 -->
        <div class="mb-3">
            <label for="outfitName" class="form-label">코디 이름</label>
            <input type="text" class="form-control" id="outfitName" name="outfitName" value="<%= outfitName %>" required>
        </div>

        <!-- 날짜 수정 -->
        <div class="mb-3">
            <label for="startDate" class="form-label">날짜 수정</label>
            <input type="date" id="startDate" name="startDate" class="form-control" value="<%= startDate %>" required>
        </div>

        <!-- 메모 수정 -->
        <div class="mb-3">
            <label for="memo" class="form-label">메모</label>
            <textarea id="memo" name="memo" class="form-control" rows="4" placeholder="코디와 관련된 메모를 입력하세요."><%= memo %></textarea>
        </div>

        <!-- 옷 선택 -->
        <h3 class="mb-3">옷 선택</h3>
        <div class="row">
            <%
                List<Cloth> clothes = repository.getAllClothes();
                Set<Integer> selectedClothIds = new HashSet<>();
                for (Map<String, Object> item : outfits) {
                    selectedClothIds.add((Integer) item.get("cloth_id")); // 이미 선택된 옷 ID
                }

                for (Cloth cloth : clothes) {
            %>
            <div class="col-md-4">
                <div class="card mb-3">
                    <!-- 옷 이미지 -->
                    <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" class="card-img-top" alt="옷 이미지">
                    <div class="card-body text-center">
                        <h5 class="card-title"><%= cloth.getName() %></h5>
                        <!-- 체크박스: 옷 ID 값 전송 -->
                        <input type="checkbox" name="selectedClothes" value="<%= cloth.getId() %>"
                            <%= selectedClothIds.contains(cloth.getId()) ? "checked" : "" %>> 선택
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <!-- 숨겨진 필드: 코디 ID -->
        <input type="hidden" name="outfitId" value="<%= outfit.get("outfit_id") %>">

        <!-- 저장 버튼 -->
        <button type="submit" class="btn btn-primary btn-lg">코디 저장</button>
    </form>


    <%
            }
        }
    %>
</div>
</body>
</html>

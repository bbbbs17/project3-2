<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 옷 아이템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 카드 이미지 비율 유지 */
        .card-img-top {
            object-fit: contain;  /* 비율을 유지하면서 이미지 크기 조정 */
            width: 100%;  /* 카드 너비에 맞게 이미지 너비 확장 */
            max-height: 250px;  /* 최대 높이 제한 */
            height: auto;  /* 높이를 자동으로 조정하여 비율 유지 */
        }

        /* 카드 안에 버튼 배치 */
        .card-body {
            padding: 1rem;
            position: relative; /* 버튼이 카드 안에서 위치할 수 있게 설정 */
            background-color: #ffffff;  /* 카드 배경은 흰색 */
            color: #333;  /* 텍스트 색상을 어두운 회색으로 설정 */
            border: 1px solid #ddd;  /* 카드 테두리 */
            border-radius: 8px;  /* 카드의 모서리 둥글게 */
        }

        /* 기본적으로 버튼 숨기기 */
        .card-body .btn {
            opacity: 0;
            transition: opacity 0.3s ease;
            position: absolute;
            bottom: 10px;
            width: auto;
            font-size: 0.9rem;  /* 버튼 크기 */
        }

        /* 카드에 마우스 오버 시 버튼 보이기 */
        .card:hover .btn {
            opacity: 1;
        }

        /* 상세보기 버튼 왼쪽 배치 */
        .card-body .btn-secondary {
            left: 10px;
        }

        /* 삭제 버튼 오른쪽 배치 */
        .card-body .btn-danger {
            right: 10px;
            left: auto;
        }

        /* 버튼 간격 조정 */
        .card-body .btn {
            margin-top: 5px;
            padding: 6px 12px; /* 버튼 크기 */
        }

        /* 버튼 간격을 넓혀서 겹치지 않게 만들기 */
        .card-body .btn-secondary {
            margin-right: 10px;
        }

        .card-body .btn-danger {
            margin-left: 10px;
        }

        /* 기본 버튼 스타일 (어두운 색상으로 변경) */
        .btn {
            background-color: #333;  /* 어두운 회색 배경 */
            color: white;  /* 버튼 텍스트는 흰색 */
            border: none;
            border-radius: 5px;
        }

        /* 버튼 호버 효과 */
        .btn:hover {
            background-color: #555; /* 호버 시 색상 변경 */
            color: white;
        }

        /* 상세보기 버튼 스타일 */
        .btn-secondary {
            background-color: #444;  /* 어두운 회색 */
        }

        .btn-secondary:hover {
            background-color: #666;  /* 호버 시 어두운 색상 */
        }

        /* 삭제 버튼 스타일 */
        .btn-danger {
            background-color: #d9534f;  /* 어두운 빨간색 */
        }

        .btn-danger:hover {
            background-color: #c9302c;  /* 삭제 버튼 호버 시 어두운 빨간색 */
        }

        /* 필터 레이아웃 개선 */
        .filter-row {
            margin-bottom: 1rem;
        }

        .cloth-item {
            margin-bottom: 1.5rem;
        }

        /* 화면 크기별 스타일 */
        @media (max-width: 768px) {
            .card-img-top {
                height: 200px; /* 모바일에서 이미지 크기 고정 */
            }
        }

        /* 전체 페이지 배경 */
        body {
            background-color: #ffffff; /* 전체 페이지 배경은 흰색 */
            color: #333;  /* 전체 텍스트 색상 */
            font-family: Arial, sans-serif;
        }

        /* 헤더 스타일 */
        .p-5 {
            background-color: #ffffff; /* 흰색 배경 */
            color: #333;  /* 텍스트는 어두운 회색 */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);  /* 부드러운 그림자 추가 */
        }

        /* 필터 부분 */
        .form-label, .form-select {
            color: #333;  /* 필터 글씨 색상 */
            background-color: #f8f8f8;  /* 연한 회색 배경 */
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-select {
            padding: 10px;
        }

        .form-select:focus {
            background-color: #e6e6e6; /* 선택 시 배경색 */
            border-color: #888;
        }

        /* 텍스트 링크 스타일 */
        a {
            color: #333;
            text-decoration: none;
        }

        a:hover {
            color: #007bff;  /* 링크 호버 시 파란색 */
        }
    </style>

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

    <!-- 헤더 부분 -->
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5 text-center">
            <h1 class="display-5 fw-bold">나의 옷장</h1>
            <p class="col-md-8 fs-4 mx-auto">여기에 나의 모든 옷을 관리하세요!</p>
            <a href="addCloth.jsp" class="btn btn-primary btn-lg mt-3">옷 추가하기</a>
        </div>
    </div>

    <!-- ootd(달력) 보러가기 버튼 -->
    <div class="text-end mb-4">
        <a href="myOutfits.jsp" class="btn btn-info btn-lg">ootd(달력) 보러가기</a>
    </div>

    <!-- 필터 부분 -->
    <div class="row filter-row">
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

    <!-- 옷 아이템 목록 -->
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <%
            ClothRepository repository = ClothRepository.getInstance();
            List<Cloth> clothes = repository.getAllClothes();

            if (clothes.isEmpty()) {
        %>
        <div class="col-md-12">
            <div class="h-100 p-5 text-center">
                <h3>아직 등록된 옷이 없습니다.</h3>
                <p>새로운 옷을 추가하고 나만의 옷장을 시작해보세요!</p>
                <a href="addCloth.jsp" class="btn btn-success mb-4">옷 추가하기</a>
            </div>
        </div>
        <%
        } else {
            for (Cloth cloth : clothes) {
        %>
        <div class="col cloth-item" data-category="<%= cloth.getCategory() %>" data-season="<%= cloth.getSeason() %>">
            <div class="card h-100">
                <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" class="card-img-top" alt="옷 이미지">
                <div class="card-body">
                    <h5 class="card-title"><%= cloth.getName() %></h5>
                    <!-- 버튼을 마우스 오버 시 나타나도록 설정 -->
                    <a href="itemDetail.jsp?id=<%= cloth.getId() %>" class="btn btn-secondary mt-2 btn-custom">상세보기</a>
                    <form action="deleteCloth" method="post" style="display:inline;">
                        <input type="hidden" name="clothId" value="<%= cloth.getId() %>">
                        <button type="submit" class="btn btn-danger mt-2 btn-custom">삭제</button>
                    </form>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>

=<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="dto.Cloth" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            margin: 0;
        }

        .top-background {
            width: 100%;
            height: 30vh;
            background-image: url('resources/배경1.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
        }

        .loading {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 2rem;
            z-index: 9999;
        }

        .content-container {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 30px;
            height: 70vh;
            padding: 0 30px;
            visibility: hidden;
            opacity: 0;
            transition: opacity 0.5s ease-in-out;
            flex-wrap: wrap;
        }

        .text-buttons {
            width: 40%;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
        }

        .image-gallery {
            width: 55%;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .image-gallery img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
        }

        .btn-custom {
            border-radius: 5px;
            font-size: 1.25rem;
            padding: 12px 24px;
            color: white;
            margin: 5px;
        }

        .btn-left {
            background-color: #000000;
        }

        .btn-right {
            background-color: #333;
        }

        .header-title {
            font-size: 2rem;
            font-weight: bold;
        }

        /* 반응형 스타일 */
        @media (max-width: 992px) {
            .content-container {
                flex-direction: column;
                align-items: center;
            }

            .text-buttons {
                width: 100%;
                text-align: center;
            }

            .image-gallery {
                width: 100%;
                grid-template-columns: 1fr 1fr; /* 두 개의 열 */
            }

            .image-gallery img {
                height: 250px;
            }

            .btn-custom {
                width: 100%;
                font-size: 1.1rem;
            }
        }

        @media (max-width: 576px) {
            .header-title {
                font-size: 1.5rem;
            }

            .text-buttons {
                width: 100%;
                text-align: center;
            }

            .image-gallery {
                width: 100%;
                grid-template-columns: 1fr; /* 세로로 하나씩 정렬 */
                padding: 0;
            }

            .image-gallery img {
                height: 200px;
            }

            .btn-custom {
                font-size: 1rem;
                padding: 10px;
            }
        }
    </style>

</head>
<body>
<!-- 로딩 화면 -->
<div id="loading" class="loading">로딩 중...</div>

<!-- 상단 배경 영역 -->
<div class="top-background"></div>

<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <!-- 왼쪽: 텍스트와 버튼들, 오른쪽: 사진들 -->
    <div class="content-container">
        <div class="text-buttons">
            <h3 class="header-title">나만의 옷장</h3>
            <p class="fs-5">Clothing List</p>
            <!-- 두 개의 버튼 -->
            <div class="text-center">
                <a href="myOutfits.jsp" class="btn btn-custom btn-left">나의 완성된 코디 보기</a>
                <a href="myItems.jsp" class="btn btn-custom btn-right">나의 옷아이템 보기</a>
            </div>
        </div>

        <!-- 오른쪽: 이미지 갤러리 -->
        <div class="image-gallery">
            <%
                ClothRepository repository = ClothRepository.getInstance();
                List<Cloth> clothes = repository.getAllClothes();
                Collections.shuffle(clothes);
                int limit = Math.min(clothes.size(), 4);
                for (int i = 0; i < limit; i++) {
                    Cloth cloth = clothes.get(i);
            %>
            <img src="<%= request.getContextPath() + '/' + cloth.getImageUrl() %>" alt="옷 이미지 <%= i + 1 %>">
            <% } %>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</div>

<script>
    window.onload = function() {
        var loading = document.getElementById('loading');
        var contentContainer = document.querySelector('.content-container');
        var img = new Image();
        img.src = 'resources/배경1.jpg';
        img.onload = function() {
            loading.style.display = 'none';
            contentContainer.style.visibility = 'visible';
            contentContainer.style.opacity = 1;
        };
        if (img.complete) {
            loading.style.display = 'none';
            contentContainer.style.visibility = 'visible';
            contentContainer.style.opacity = 1;
        }
    };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

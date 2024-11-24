<%@ page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>옷 추가</title>
    <script>
        function updateSizeOptions() {
            const category = document.getElementById("category").value;
            const sizeSelect = document.getElementById("size");
            sizeSelect.innerHTML = ""; // 기존 옵션 삭제

            const sizes = category === "악세사리" ? ["Free"] : ["S", "M", "L", "XL"];
            sizes.forEach(size => {
                const option = document.createElement("option");
                option.value = size;
                option.text = size;
                sizeSelect.add(option);
            });
        }

        // 페이지 로드 시 초기화
        document.addEventListener("DOMContentLoaded", () => {
            updateSizeOptions();
            document.getElementById("category").dispatchEvent(new Event("change"));
        });
    </script>

</head>
<body>
<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <div class="p-5 mb-4 bg-light rounded-3">
        <div class="container-fluid py-5 text-center">
            <h1 class="display-5 fw-bold">새 옷 추가</h1>
            <p class="col-md-8 mx-auto fs-4">새로운 옷을 추가하고 나만의 아이템 컬렉션을 완성하세요.</p>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <form name="newCloth" action="fileUpload" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="name" class="form-label">이름</label>
                    <input type="text" id="name" name="name" class="form-control" placeholder="예: 티셔츠, 바지" required>
                    <div class="invalid-feedback">이름을 입력해주세요.</div>
                </div>
                <div class="mb-3">
                    <label for="category" class="form-label">카테고리</label>
                    <select id="category" name="category" class="form-select" onchange="updateSizeOptions()" required>
                        <option value="상의" selected>상의</option>
                        <option value="하의">하의</option>
                        <option value="아우터">아우터</option>
                        <option value="악세사리">악세사리</option>
                    </select>
                    <div class="invalid-feedback">카테고리를 선택해주세요.</div>
                </div>
                <div class="mb-3">
                    <label for="color" class="form-label">색상</label>
                    <input type="text" id="color" name="color" class="form-control" placeholder="예: 빨강, 파랑" required>
                    <div class="invalid-feedback">색상을 입력해주세요.</div>
                </div>
                <div class="mb-3">
                    <label for="size" class="form-label">사이즈</label>
                    <select id="size" name="size" class="form-select" required></select>
                    <div class="invalid-feedback">사이즈를 선택해주세요.</div>
                </div>
                <div class="mb-3">
                    <label for="season" class="form-label">계절</label>
                    <select id="season" name="season" class="form-select" required>
                        <option value="봄">봄</option>
                        <option value="여름">여름</option>
                        <option value="가을">가을</option>
                        <option value="겨울">겨울</option>
                    </select>
                    <div class="invalid-feedback">계절을 선택해주세요.</div>
                </div>
                <div class="mb-3">
                    <label for="image" class="form-label">이미지</label>
                    <input type="file" id="image" name="image" class="form-control" accept=".jpg, .jpeg, .png, .gif" required>
                    <small class="form-text text-muted">이미지 파일 (jpg, png, gif)을 업로드하세요.</small>
                    <div class="invalid-feedback">이미지를 선택해주세요.</div>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">추가하기</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</div>

<script>
    // 부트스트랩 폼 검증 스크립트
    (() => {
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>

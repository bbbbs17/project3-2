<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="dao.ClothRepository" %>
<!DOCTYPE html>
<html>
<head>
    <title>코디 보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 기존 스타일은 유지 */
        .card-img-top {
            object-fit: cover;
            width: 100%;
            height: 250px; /* 이미지를 크게 보이게 */
            border-radius: 10px;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background-color: #f8f9fa;
        }

        .card-body {
            padding: 20px;
            text-align: center;
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 20px;
            gap: 30px;
        }

        .left {
            flex: 1;
            text-align: center;
            position: relative; /* 부모 컨테이너 기준으로 설정 */
        }

        .right {
            flex: 1;
            text-align: center;
        }

        .image-column {
            flex: 1;
            margin-bottom: 15px;
            position: relative;
        }

        .memo-section {
            margin-top: 20px;
            text-align: center;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
        }

        .memo-section h5 {
            font-size: 1.5rem;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 15px;
        }

        .memo-section .text-muted {
            font-size: 1rem;
            color: #6c757d;
        }

        .delete-section, .edit-section {
            margin-top: 40px;
            text-align: center;
        }

        .btn-lg {
            font-size: 1.25rem;
            padding: 12px 30px;
            border-radius: 30px;
        }

        .btn-danger, .btn-primary {
            width: 220px;
            margin-top: 20px;
        }

        /* 캔버스 컨테이너 스타일 */
        .canvas-container {
            position: relative;
            width: 600px; /* 고정 너비 */
            height: 800px; /* 고정 높이 */
            border: 2px solid black;
            overflow: hidden;
            background-color: #fff;
            margin-bottom: 20px;
        }

        /* 캔버스 스타일 */
        #outfitCanvas {
            width: 100%; /* 컨테이너에 맞게 조정 */
            height: 100%; /* 컨테이너에 맞게 조정 */
            display: block;
        }

        /* 추가된 이미지 목록 스타일 */
        .added-images-container {
            width: 600px;
            margin-bottom: 20px;
        }

        .added-images-container h3 {
            margin-bottom: 15px;
        }

        .added-images-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .added-image-item {
            position: relative;
            width: 100px;
            height: 100px;
        }

        .added-image-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .added-image-item .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(255, 0, 0, 0.8);
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .canvas-container, .added-images-container {
                width: 100%;
            }
        }

        /* 컨트롤 버튼 스타일 */
        .controls-section {
            margin-top: 10px;
        }

        .controls-section .btn {
            margin: 0 5px;
        }

        /* 상단 네비게이션 스타일 */
        .navbar {
            width: 100%;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <!-- 상단 네비게이션 -->
    <div class="d-flex justify-content-start align-items-center mb-4">
        <a href="myOutfits.jsp" class="btn btn-secondary btn-lg">달력으로 돌아가기</a>
    </div>
    <h1 class="text-center mb-4">OOTD구성하기!</h1>

    <%
        // GET 파라미터에서 date 값 읽기
        String selectedDate = request.getParameter("date");

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

        if (outfits.isEmpty()) {
    %>
    <div class="text-center">
        <p class="text-muted">해당 날짜에 저장된 코디가 없습니다.</p>
    </div>
    <%
    } else {
        // 중복 제거를 위한 Set 생성
        Set<Integer> uniqueOutfitIds = new HashSet<>();
        String memo = (String) outfits.get(0).get("memo"); // 메모 가져오기
    %>

    <!-- 메모 섹션 -->
    <div class="memo-section">
        <h5>메모: <span class="text-muted"><%= memo != null ? memo : "메모 없음" %></span></h5>
    </div>

    <!-- 캔버스 및 추가된 이미지 삭제 버튼 -->
    <div class="canvas-container">
        <canvas id="outfitCanvas" width="600" height="800"></canvas> <!-- 캔버스 크기 고정 -->
    </div>

    <!-- 추가된 이미지 삭제 버튼 목록 -->
    <div class="added-images-container">
        <h3>추가된 이미지 삭제</h3>
        <div class="added-images-list" id="addedImagesList">
            <!-- JavaScript를 통해 추가된 이미지 삭제 버튼이 여기 표시됩니다 -->
        </div>
    </div>

    <!-- 크기 조절 및 회전 버튼 -->
    <div class="controls-section text-center">
        <button class="btn btn-secondary btn-sm me-2" onclick="increaseSize()" disabled id="increaseSizeBtn">크기 키우기</button>
        <button class="btn btn-secondary btn-sm me-2" onclick="decreaseSize()" disabled id="decreaseSizeBtn">크기 줄이기</button>
        <button class="btn btn-secondary btn-sm me-2" onclick="rotateLeft()" disabled id="rotateLeftBtn">왼쪽 회전</button>
        <button class="btn btn-secondary btn-sm" onclick="rotateRight()" disabled id="rotateRightBtn">오른쪽 회전</button>
    </div>

    <!-- 개별 의류 이미지 (아래에 배치) -->
    <div class="row">
        <%
            for (Map<String, Object> outfit : outfits) {
                String clothName = (String) outfit.get("cloth_name");
                String imageUrl = (String) outfit.get("imageUrl");
                Integer outfitId = (Integer) outfit.get("outfit_id");
        %>
        <div class="image-column">
            <div class="card h-100">
                <img src="<%= request.getContextPath() + '/' + imageUrl %>" class="card-img-top" alt="<%= clothName %>">
                <div class="card-body">
                    <h5 class="card-title"><%= clothName %></h5>
                    <button class="btn btn-info" onclick="addClothToCanvas('<%= request.getContextPath() + '/' + imageUrl %>')">이 옷 추가</button>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <!-- 수정 및 삭제 버튼 (전체 코디에 대한) -->
    <div class="delete-section text-center">
        <form action="deleteOutfit" method="post">
            <%
                // 첫 번째 outfitId를 히든 필드로 전송 (전체 코디 삭제)
                for (Map<String, Object> outfit : outfits) {
                    Object idObject = outfit.get("outfit_id");
                    if (idObject != null) {
                        int outfitId = (int) idObject;
                        // 중복된 ID를 무시
                        if (!uniqueOutfitIds.contains(outfitId)) {
                            uniqueOutfitIds.add(outfitId);
            %>
            <!-- hidden 필드로 outfitId 전송 -->
            <input type="hidden" name="outfitId" value="<%= outfitId %>">
            <%
                            break; // 첫 번째 ID만 사용하고 반복문 종료
                        }
                    }
                }
            %>
            <button type="submit" class="btn btn-danger btn-lg mt-3" onclick="return confirm('선택된 코디를 정말 삭제하시겠습니까?');">
                선택된 코디 삭제
            </button>
        </form>
        <form action="editOutfit.jsp" method="post" class="d-inline">
            <!-- 수정: date 값을 히든 필드로 추가 -->
            <input type="hidden" name="date" value="<%= selectedDate %>">
            <%
                // 첫 번째 outfitId를 히든 필드로 전송
                for (Map<String, Object> outfit : outfits) {
                    Object idObject = outfit.get("outfit_id");
                    if (idObject != null) {
                        int outfitId = (int) idObject;
                        // 중복된 ID를 무시
                        if (!uniqueOutfitIds.contains(outfitId)) {
                            uniqueOutfitIds.add(outfitId);
            %>
            <!-- hidden 필드로 outfitId 전송 -->
            <input type="hidden" name="outfitId" value="<%= outfitId %>">
            <%
                            break; // 첫 번째 ID만 사용하고 반복문 종료
                        }
                    }
                }
            %>
            <button type="submit" class="btn btn-primary btn-lg mt-3">
                선택된 코디 수정
            </button>
        </form>
    </div>

    <%
            }
        }
    %>
</div>

<script>
    let addedImages = [];
    let imageCounter = 0; // Unique identifier for images
    let draggedImage = null; // To track the dragged image
    let offsetX, offsetY;
    let selectedImageId = null; // 현재 선택된 이미지 ID

    // 페이지 로드 시 캔버스 초기화
    window.onload = function() {
        redrawCanvas();
    };

    // 캔버스에 옷을 추가하는 함수
    function addClothToCanvas(imageUrl) {
        const canvas = document.getElementById('outfitCanvas');
        const ctx = canvas.getContext('2d');

        const img = new Image();
        img.onload = function () {
            // 이미지 크기 고정 (예: 최대 150x150)
            const maxWidth = 150;
            const maxHeight = 150;
            let width = img.width;
            let height = img.height;

            // 비율 유지하며 크기 축소
            if (width > maxWidth || height > maxHeight) {
                const widthRatio = maxWidth / width;
                const heightRatio = maxHeight / height;
                const ratio = Math.min(widthRatio, heightRatio);
                width = width * ratio;
                height = height * ratio;
            }

            // 이미지를 그릴 위치를 무작위로 설정 (캔버스 크기 내에서)
            const xPos = Math.random() * (canvas.width - width);
            const yPos = Math.random() * (canvas.height - height);
            //ctx.drawImage(img, xPos, yPos, width, height);  // 캔버스에 이미지를 그리기 (주석 처리)

            // Assign a unique id to this image
            const imageId = imageCounter++;
            addedImages.push({
                id: imageId,
                imageUrl,
                img,
                xPos,
                yPos,
                width,
                height,
                scale: 1, // 초기 스케일
                rotation: 0 // 초기 회전 각도
            });  // 추가된 이미지를 목록에 추가

            // 추가된 이미지 목록에 삭제 버튼 추가
            displayDeleteButton(imageId, imageUrl);
            redrawCanvas(); // 캔버스 다시 그리기
        };
        img.src = imageUrl;
    }

    // 추가된 이미지 삭제 버튼을 표시하는 함수
    function displayDeleteButton(imageId, imageUrl) {
        const addedImagesList = document.getElementById('addedImagesList');

        const imageItem = document.createElement('div');
        imageItem.classList.add('added-image-item');

        const img = document.createElement('img');
        img.src = imageUrl;
        img.alt = "추가된 의류 이미지";

        const deleteBtn = document.createElement('button');
        deleteBtn.classList.add('delete-btn');
        deleteBtn.innerHTML = 'X';
        deleteBtn.setAttribute('data-id', imageId);
        deleteBtn.onclick = function() {
            deleteAddedImage(imageId);
        };

        imageItem.appendChild(img);
        imageItem.appendChild(deleteBtn);
        addedImagesList.appendChild(imageItem);
    }

    // 추가된 이미지를 삭제하는 함수
    function deleteAddedImage(imageId) {
        const canvas = document.getElementById('outfitCanvas');
        const ctx = canvas.getContext('2d');

        // Find the image by id
        const imageIndex = addedImages.findIndex(image => image.id === imageId);

        if (imageIndex !== -1) {
            const image = addedImages[imageIndex];
            // Remove from addedImages
            addedImages.splice(imageIndex, 1);

            // Remove the corresponding delete button from the list
            const addedImagesList = document.getElementById('addedImagesList');
            const imageItems = addedImagesList.getElementsByClassName('added-image-item');
            for (let item of imageItems) {
                if (item.querySelector('.delete-btn').getAttribute('data-id') == imageId) {
                    addedImagesList.removeChild(item);
                    break;
                }
            }

            // If 삭제된 이미지가 선택된 이미지라면 선택 해제 및 버튼 비활성화
            if (selectedImageId === imageId) {
                selectedImageId = null;
                const buttons = ['increaseSizeBtn', 'decreaseSizeBtn', 'rotateLeftBtn', 'rotateRightBtn'];
                buttons.forEach(id => {
                    document.getElementById(id).disabled = true;
                });
            }

            // Redraw the canvas
            redrawCanvas();
        }
    }

    // 캔버스 클릭 시 이미지 선택
    document.getElementById('outfitCanvas').addEventListener('click', function(event) {
        const mouseX = event.offsetX;
        const mouseY = event.offsetY;
        selectedImageId = null; // 초기화

        // 뒤에서부터 검사하여 가장 위에 있는 이미지를 선택
        for (let i = addedImages.length - 1; i >= 0; i--) {
            const image = addedImages[i];
            // 이미지의 회전과 스케일을 고려한 좌표 계산
            const centerX = image.xPos + image.width / 2;
            const centerY = image.yPos + image.height / 2;

            // 회전된 좌표로 변환
            const radians = -image.rotation * Math.PI / 180;
            const cos = Math.cos(radians);
            const sin = Math.sin(radians);
            const dx = mouseX - centerX;
            const dy = mouseY - centerY;
            const x = dx * cos - dy * sin;
            const y = dx * sin + dy * cos;

            if (x > -image.width / 2 * image.scale && x < image.width / 2 * image.scale &&
                y > -image.height / 2 * image.scale && y < image.height / 2 * image.scale) {
                selectedImageId = image.id;
                break;
            }
        }

        // 버튼 활성화/비활성화
        const buttons = ['increaseSizeBtn', 'decreaseSizeBtn', 'rotateLeftBtn', 'rotateRightBtn'];
        buttons.forEach(id => {
            document.getElementById(id).disabled = (selectedImageId === null);
        });

        // 선택된 이미지의 테두리를 그리기 위해 다시 그리기
        redrawCanvas();
        if (selectedImageId !== null) {
            const canvas = document.getElementById('outfitCanvas');
            const ctx = canvas.getContext('2d');
            const image = addedImages.find(img => img.id === selectedImageId);
            if (image) {
                ctx.save();
                ctx.translate(image.xPos + image.width / 2, image.yPos + image.height / 2);
                ctx.rotate(image.rotation * Math.PI / 180);
                ctx.strokeStyle = 'red';
                ctx.lineWidth = 2;
                ctx.strokeRect(-image.width / 2, -image.height / 2, image.width, image.height);
                ctx.restore();
            }
        }
    });

    // 마우스 다운 시 이미지 드래그 시작
    document.getElementById('outfitCanvas').addEventListener('mousedown', function(event) {
        const mouseX = event.offsetX;
        const mouseY = event.offsetY;

        // 이미지 클릭 여부 확인
        for (const image of addedImages) {
            // 이미지의 회전과 스케일을 고려한 좌표 계산
            const centerX = image.xPos + image.width / 2;
            const centerY = image.yPos + image.height / 2;

            const radians = -image.rotation * Math.PI / 180;
            const cos = Math.cos(radians);
            const sin = Math.sin(radians);
            const dx = mouseX - centerX;
            const dy = mouseY - centerY;
            const x = dx * cos - dy * sin;
            const y = dx * sin + dy * cos;

            if (x > -image.width / 2 * image.scale && x < image.width / 2 * image.scale &&
                y > -image.height / 2 * image.scale && y < image.height / 2 * image.scale) {
                draggedImage = image; // 드래그할 이미지 선택
                offsetX = mouseX - image.xPos;
                offsetY = mouseY - image.yPos;
                break;
            }
        }
    });

    // 마우스 이동 시 이미지 이동
    document.getElementById('outfitCanvas').addEventListener('mousemove', function(event) {
        if (draggedImage) {
            const mouseX = event.offsetX;
            const mouseY = event.offsetY;

            draggedImage.xPos = mouseX - offsetX;
            draggedImage.yPos = mouseY - offsetY;

            redrawCanvas();
            // 선택된 이미지인 경우 테두리 다시 그리기
            if (draggedImage.id === selectedImageId) {
                const canvas = document.getElementById('outfitCanvas');
                const ctx = canvas.getContext('2d');
                ctx.save();
                ctx.translate(draggedImage.xPos + draggedImage.width / 2, draggedImage.yPos + draggedImage.height / 2);
                ctx.rotate(draggedImage.rotation * Math.PI / 180);
                ctx.strokeStyle = 'red';
                ctx.lineWidth = 2;
                ctx.strokeRect(-draggedImage.width / 2, -draggedImage.height / 2, draggedImage.width, draggedImage.height);
                ctx.restore();
            }
        }
    });

    // 마우스 버튼을 떼면 드래그 종료
    document.getElementById('outfitCanvas').addEventListener('mouseup', function() {
        draggedImage = null;
    });

    // 캔버스 다시 그리기
    function redrawCanvas() {
        const canvas = document.getElementById('outfitCanvas');
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // 캔버스 배경에 기본 텍스트 추가
        ctx.font = '24px Arial';
        ctx.fillStyle = 'gray';
        ctx.textAlign = 'center';
        ctx.fillText('선택한 옷으로 룩을 구성해보세요!', canvas.width / 2, 40);

        addedImages.forEach(imgObj => {
            ctx.save(); // 현재 상태 저장
            // 이미지의 중심을 기준으로 회전
            ctx.translate(imgObj.xPos + imgObj.width / 2, imgObj.yPos + imgObj.height / 2);
            ctx.rotate(imgObj.rotation * Math.PI / 180);
            ctx.scale(imgObj.scale, imgObj.scale);
            // 이미지를 다시 그릴 때 위치를 조정
            ctx.drawImage(imgObj.img, -imgObj.width / 2, -imgObj.height / 2, imgObj.width, imgObj.height);
            ctx.restore(); // 상태 복원
        });
    }

    // 크기 키우기 함수
    function increaseSize() {
        if (selectedImageId === null) return;
        const image = addedImages.find(img => img.id === selectedImageId);
        if (image) {
            image.scale *= 1.1; // 10% 증가
            redrawCanvas();
        }
    }

    // 크기 줄이기 함수
    function decreaseSize() {
        if (selectedImageId === null) return;
        const image = addedImages.find(img => img.id === selectedImageId);
        if (image) {
            image.scale /= 1.1; // 약 10% 감소
            redrawCanvas();
        }
    }

    // 왼쪽 회전 함수
    function rotateLeft() {
        if (selectedImageId === null) return;
        const image = addedImages.find(img => img.id === selectedImageId);
        if (image) {
            image.rotation -= 15; // 15도 왼쪽 회전
            redrawCanvas();
        }
    }

    // 오른쪽 회전 함수
    function rotateRight() {
        if (selectedImageId === null) return;
        const image = addedImages.find(img => img.id === selectedImageId);
        if (image) {
            image.rotation += 15; // 15도 오른쪽 회전
            redrawCanvas();
        }
    }
</script>

</body>
</html>

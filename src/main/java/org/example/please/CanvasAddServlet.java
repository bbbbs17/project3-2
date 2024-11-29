package org.example.please;

import dao.OutfitCanvasRepository;  // OutfitCanvasRepository 클래스 호출
import dto.OutfitCanvas;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/addCanvasWork")
public class CanvasAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 요청에서 데이터 추출
            int outfitId = Integer.parseInt(request.getParameter("outfitId"));
            int clothId = Integer.parseInt(request.getParameter("clothId"));
            float positionX = Float.parseFloat(request.getParameter("positionX"));
            float positionY = Float.parseFloat(request.getParameter("positionY"));
            float width = Float.parseFloat(request.getParameter("width"));
            float height = Float.parseFloat(request.getParameter("height"));
            float rotationAngle = Float.parseFloat(request.getParameter("rotationAngle"));

            // 현재 시간으로 생성된 시간 설정
            Timestamp createdAt = new Timestamp(System.currentTimeMillis());

            // OutfitCanvas 객체 생성
            OutfitCanvas canvasWork = new OutfitCanvas();
            canvasWork.setOutfitId(outfitId);
            canvasWork.setClothId(clothId);
            canvasWork.setPositionX(positionX);
            canvasWork.setPositionY(positionY);
            canvasWork.setWidth(width);
            canvasWork.setHeight(height);
            canvasWork.setRotationAngle(rotationAngle);
            canvasWork.setCreatedAt(createdAt);

            // OutfitCanvasRepository를 사용하여 DB에 작업 저장
            OutfitCanvasRepository repository = OutfitCanvasRepository.getInstance();
            repository.addCanvasWork(canvasWork);

            // 작업 추가 후 캔버스 작업 페이지로 리다이렉트
            response.sendRedirect("viewCanvasWork.jsp");

        } catch (NumberFormatException e) {
            // 파라미터 형식이 잘못된 경우
            request.setAttribute("errorMessage", "잘못된 입력 값입니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            // 일반적인 예외 처리
            e.printStackTrace();
            request.setAttribute("errorMessage", "서버에서 오류가 발생했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}

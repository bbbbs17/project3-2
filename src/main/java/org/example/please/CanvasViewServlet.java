package org.example.please;

import dao.OutfitCanvasRepository;  // OutfitCanvasRepository 호출
import dto.OutfitCanvas;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewCanvasWork")
public class CanvasViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int outfitId = Integer.parseInt(request.getParameter("outfitId"));  // URL 파라미터에서 outfitId를 가져옴

        // OutfitCanvasRepository에서 outfitId에 해당하는 캔버스 작업 조회
        OutfitCanvasRepository repository = OutfitCanvasRepository.getInstance();
        List<OutfitCanvas> canvasWorks = repository.getCanvasWorksByOutfitId(outfitId);

        // 조회된 캔버스 작업을 request 객체에 저장하여 JSP로 전달
        request.setAttribute("canvasWorks", canvasWorks);
        request.getRequestDispatcher("viewCanvasWork.jsp").forward(request, response);  // JSP로 포워딩
    }
}

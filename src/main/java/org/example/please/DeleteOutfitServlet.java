package org.example.please;

import dao.ClothRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/deleteOutfit")
public class DeleteOutfitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int outfitId = Integer.parseInt(request.getParameter("outfitId"));
        String date = request.getParameter("date"); // 날짜 파라미터 가져오기

        // 코디 삭제
        ClothRepository repository = ClothRepository.getInstance();
        repository.deleteOutfit(outfitId);

        // 삭제 후 다시 코디 상세 보기 페이지로 리다이렉트
        if (date != null && !date.trim().isEmpty()) {
            response.sendRedirect("viewOutfits.jsp?date=" + date);
        } else {
            response.sendRedirect("myOutfits.jsp"); // 날짜가 없으면 달력 페이지로 이동
        }
    }
}

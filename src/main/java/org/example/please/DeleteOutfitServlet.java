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

        // 코디 삭제
        ClothRepository repository = ClothRepository.getInstance();
        repository.deleteOutfit(outfitId);

        // 삭제 후 다시 코디 목록으로 리다이렉트
        response.sendRedirect("myOutfits.jsp");
    }
}

package org.example.please;

import dao.ClothRepository;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/deleteCloth")
public class DeleteClothServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int clothId = Integer.parseInt(request.getParameter("clothId"));

        ClothRepository repository = ClothRepository.getInstance();
        repository.deleteClothById(clothId);

        // 삭제 후 나의 옷장 페이지로 리다이렉트
        response.sendRedirect("myItems.jsp");
    }
}

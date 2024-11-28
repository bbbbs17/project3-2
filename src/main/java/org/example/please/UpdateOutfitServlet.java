package org.example.please;

import dao.ClothRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/updateOutfit")
public class UpdateOutfitServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int outfitId = Integer.parseInt(request.getParameter("outfitId"));
        String outfitName = request.getParameter("outfitName");
        String[] selectedClothes = request.getParameterValues("selectedClothes");
        String startDate = request.getParameter("startDate");
        String memo = request.getParameter("memo");

        List<Integer> clothIds = new ArrayList<>();
        if (selectedClothes != null) {
            for (String clothId : selectedClothes) {
                clothIds.add(Integer.parseInt(clothId));
            }
        }

        ClothRepository repository = ClothRepository.getInstance();
        boolean isUpdated = repository.updateOutfit(outfitId, outfitName, clothIds, startDate, memo);

        if (isUpdated) {
            response.sendRedirect("myOutfits.jsp");
        } else {
            request.setAttribute("errorMessage", "코디 저장 중 오류가 발생했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}

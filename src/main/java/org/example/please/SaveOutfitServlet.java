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

@WebServlet("/saveOutfit")
public class SaveOutfitServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");

        String outfitName = request.getParameter("outfitName");
        String[] selectedClothes = request.getParameterValues("selectedClothes");
        String startDate = request.getParameter("startDate");
        String memo = request.getParameter("memo"); // 메모 파라미터 추가

        // 입력값 검증
        if (outfitName == null || startDate == null || selectedClothes == null) {
            System.err.println("Missing required parameters: outfitName, startDate, or selectedClothes.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Required parameters are missing.");
            return;
        }

        List<Integer> clothIdList = new ArrayList<>();
        try {
            for (String clothId : selectedClothes) {
                clothIdList.add(Integer.parseInt(clothId));
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid cloth ID format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid cloth ID format.");
            return;
        }

        try {
            ClothRepository clothRepository = ClothRepository.getInstance();
            clothRepository.addOutfit(outfitName, clothIdList, startDate, memo); // 메모 추가

            // 성공적으로 저장되었을 때 리다이렉트
            response.sendRedirect("myOutfits.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 페이지로 리다이렉트
            request.setAttribute("errorMessage", "코디 저장 중 오류가 발생했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}

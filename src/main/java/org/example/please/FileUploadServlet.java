package org.example.please;

import dao.ClothRepository;
import dto.Cloth;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class FileUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // 저장 경로 설정
        String uploadPath = getServletContext().getRealPath("") + "resources/images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean dirCreated = uploadDir.mkdirs();
            if (!dirCreated) {
                response.getWriter().println("Error: Failed to create upload directory.");
                return;
            }
        }

        try {
            // 파일 업로드 처리
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSubmittedFileName() != null) {
                // 고유 파일 이름 생성
                String uniqueFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // 폼 데이터 가져오기
                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String color = request.getParameter("color");
                String size = request.getParameter("size");
                String season = request.getParameter("season");
                String imageUrl = "resources/images/" + uniqueFileName;

                // 디버깅: 경로 확인
                System.out.println("Upload Path: " + uploadPath);
                System.out.println("Saved File Path: " + filePath);
                System.out.println("Image URL: " + imageUrl);

                // DTO 객체 생성
                Cloth cloth = new Cloth(0, name, category, color, size, season, imageUrl);

                // 데이터베이스에 저장
                ClothRepository repository = ClothRepository.getInstance();
                repository.addCloth(cloth);

                response.sendRedirect("myItems.jsp");
            } else {
                response.getWriter().println("Error: No file selected.");
            }
        } catch (Exception e) {
            System.out.println("Exception during file upload: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("파일 업로드 중 오류가 발생했습니다.");
        }
    }
}

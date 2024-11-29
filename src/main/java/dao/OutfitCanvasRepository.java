package dao;

import dto.OutfitCanvas;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OutfitCanvasRepository {

    private static OutfitCanvasRepository instance = new OutfitCanvasRepository();

    private OutfitCanvasRepository() {}

    public static OutfitCanvasRepository getInstance() {
        return instance;
    }

    // 캔버스 작업 추가
    public void addCanvasWork(OutfitCanvas canvasWork) {
        String sql = "INSERT INTO outfit_canvas (outfit_id, cloth_id, position_x, position_y, width, height, rotation_angle, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, canvasWork.getOutfitId());
            statement.setInt(2, canvasWork.getClothId());
            statement.setFloat(3, canvasWork.getPositionX());
            statement.setFloat(4, canvasWork.getPositionY());
            statement.setFloat(5, canvasWork.getWidth());
            statement.setFloat(6, canvasWork.getHeight());
            statement.setFloat(7, canvasWork.getRotationAngle());
            statement.setTimestamp(8, canvasWork.getCreatedAt()); // created_at 값을 설정

            int rowsAffected = statement.executeUpdate();
            System.out.println("캔버스 작업 추가 성공, 삽입된 행 수: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("캔버스 작업 추가 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // outfitId로 캔버스 작업 조회
    public List<OutfitCanvas> getCanvasWorksByOutfitId(int outfitId) {
        List<OutfitCanvas> canvasWorks = new ArrayList<>();
        String sql = "SELECT * FROM outfit_canvas WHERE outfit_id = ?";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, outfitId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OutfitCanvas canvasWork = new OutfitCanvas(
                        resultSet.getInt("id"),
                        resultSet.getInt("outfit_id"),
                        resultSet.getInt("cloth_id"),
                        resultSet.getFloat("position_x"),
                        resultSet.getFloat("position_y"),
                        resultSet.getFloat("width"),
                        resultSet.getFloat("height"),
                        resultSet.getFloat("rotation_angle"),
                        resultSet.getTimestamp("created_at") // created_at 값도 가져옴
                );
                canvasWorks.add(canvasWork);
            }

        } catch (SQLException e) {
            System.out.println("캔버스 작업 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return canvasWorks;
    }
}

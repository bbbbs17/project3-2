package dao;

import dto.Cloth;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.*;

public class ClothRepository {

    private static ClothRepository instance = new ClothRepository();

    private ClothRepository() {}

    public static ClothRepository getInstance() {
        return instance;
    }

    // 데이터베이스에 옷 추가
    public void addCloth(Cloth cloth) {
        String sql = "INSERT INTO clothes (name, category, color, size, season, imageUrl) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, cloth.getName());
            statement.setString(2, cloth.getCategory());
            statement.setString(3, cloth.getColor());
            statement.setString(4, cloth.getSize());
            statement.setString(5, cloth.getSeason());
            statement.setString(6, cloth.getImageUrl());

            int rowsAffected = statement.executeUpdate();
            System.out.println("옷 추가 성공, 삽입된 행 수: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("데이터베이스에 저장 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 데이터베이스에서 모든 옷 조회
    public List<Cloth> getAllClothes() {
        List<Cloth> clothes = new ArrayList<>();
        String sql = "SELECT * FROM clothes";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Cloth cloth = new Cloth(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getString("category"),
                        resultSet.getString("color"),
                        resultSet.getString("size"),
                        resultSet.getString("season"),
                        resultSet.getString("imageUrl")
                );
                clothes.add(cloth);
            }

            System.out.println("총 " + clothes.size() + "개의 옷 데이터 조회 완료.");
        } catch (SQLException e) {
            System.out.println("옷 데이터 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return clothes;
    }
    public void deleteOutfit(int outfitId) {
        String deleteMappingsSql = "DELETE FROM outfit_clothes WHERE outfit_id = ?";
        String deleteOutfitSql = "DELETE FROM outfits WHERE id = ?";

        try (Connection connection = DatabaseUtil.getConnection()) {
            // 먼저 outfit_clothes의 관계 데이터 삭제
            try (PreparedStatement mappingStmt = connection.prepareStatement(deleteMappingsSql)) {
                mappingStmt.setInt(1, outfitId);
                mappingStmt.executeUpdate();
            }

            // outfits 테이블에서 코디 삭제
            try (PreparedStatement outfitStmt = connection.prepareStatement(deleteOutfitSql)) {
                outfitStmt.setInt(1, outfitId);
                outfitStmt.executeUpdate();
            }

            System.out.println("코디 삭제 성공: outfit_id = " + outfitId);

        } catch (SQLException e) {
            System.out.println("코디 삭제 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }


    // ID로 특정 옷 조회
    public Cloth getClothById(int id) {
        String sql = "SELECT * FROM clothes WHERE id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return new Cloth(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getString("category"),
                        resultSet.getString("color"),
                        resultSet.getString("size"),
                        resultSet.getString("season"),
                        resultSet.getString("imageUrl")
                );
            }

        } catch (SQLException e) {
            System.out.println("ID로 옷 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return null; // 옷이 없는 경우 null 반환
    }

    // 코디 추가
    // 코디 추가
    public void addOutfit(String outfitName, List<Integer> clothIds, String startDate, String memo) {
        String insertOutfitSql = "INSERT INTO outfits (name, start_date, memo) VALUES (?, ?, ?)";
        String insertMappingSql = "INSERT INTO outfit_clothes (outfit_id, cloth_id) VALUES (?, ?)";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement outfitStatement = connection.prepareStatement(insertOutfitSql, Statement.RETURN_GENERATED_KEYS)) {

            // outfits 테이블에 추가
            outfitStatement.setString(1, outfitName);
            outfitStatement.setString(2, startDate); // 날짜 저장
            outfitStatement.setString(3, memo); // 메모 저장
            outfitStatement.executeUpdate();

            // 생성된 코디 ID 가져오기
            ResultSet generatedKeys = outfitStatement.getGeneratedKeys();
            if (generatedKeys.next()) {
                int outfitId = generatedKeys.getInt(1);

                // outfit_clothes 매핑 추가
                try (PreparedStatement mappingStatement = connection.prepareStatement(insertMappingSql)) {
                    for (int clothId : clothIds) {
                        mappingStatement.setInt(1, outfitId);
                        mappingStatement.setInt(2, clothId);
                        mappingStatement.addBatch();
                    }
                    mappingStatement.executeBatch();
                }
            }
        } catch (SQLException e) {
            System.out.println("코디 추가 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }


    // ID로 특정 옷 삭제
    public void deleteClothById(int id) {
        String sql = "DELETE FROM clothes WHERE id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);
            int rowsAffected = statement.executeUpdate();
            System.out.println("옷 삭제 성공, 삭제된 행 수: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("옷 삭제 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }



    // 코디 조회
    public List<Map<String, Object>> getAllOutfits() {
        String sql = """
        SELECT o.id AS outfit_id, o.name AS outfit_name, o.start_date, o.memo, 
               c.id AS cloth_id, c.name AS cloth_name, c.imageUrl
        FROM outfits o
        JOIN outfit_clothes oc ON o.id = oc.outfit_id
        JOIN clothes c ON oc.cloth_id = c.id
        ORDER BY o.id, c.id;
    """;

        List<Map<String, Object>> outfits = new ArrayList<>();

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Map<String, Object> outfit = new HashMap<>();
                outfit.put("outfit_id", resultSet.getInt("outfit_id"));
                outfit.put("outfit_name", resultSet.getString("outfit_name"));
                outfit.put("start_date", resultSet.getDate("start_date"));
                outfit.put("memo", resultSet.getString("memo")); // 메모 추가
                outfit.put("cloth_id", resultSet.getInt("cloth_id"));
                outfit.put("cloth_name", resultSet.getString("cloth_name"));
                outfit.put("imageUrl", resultSet.getString("imageUrl"));
                outfits.add(outfit);
            }
        } catch (SQLException e) {
            System.out.println("코디 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return outfits;
    }
    public Map<String, Object> getOutfitById(int outfitId) {
        String sql = """
        SELECT o.id AS outfit_id, o.name AS outfit_name, o.start_date, o.memo, 
               c.id AS cloth_id, c.name AS cloth_name, c.imageUrl
        FROM outfits o
        LEFT JOIN outfit_clothes oc ON o.id = oc.outfit_id
        LEFT JOIN clothes c ON oc.cloth_id = c.id
        WHERE o.id = ?
        """;

        Map<String, Object> outfit = new HashMap<>();
        List<Map<String, Object>> clothes = new ArrayList<>();

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, outfitId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    // 코디 기본 정보
                    if (outfit.isEmpty()) {
                        outfit.put("outfit_id", resultSet.getInt("outfit_id"));
                        outfit.put("outfit_name", resultSet.getString("outfit_name"));
                        outfit.put("start_date", resultSet.getDate("start_date").toString());
                        outfit.put("memo", resultSet.getString("memo"));
                    }

                    // 옷 정보 추가
                    Map<String, Object> cloth = new HashMap<>();
                    cloth.put("cloth_id", resultSet.getInt("cloth_id"));
                    cloth.put("cloth_name", resultSet.getString("cloth_name"));
                    cloth.put("imageUrl", resultSet.getString("imageUrl"));
                    clothes.add(cloth);
                }
            }

            // 코디에 속한 옷 목록 추가
            outfit.put("clothes", clothes);

        } catch (SQLException e) {
            System.out.println("코디 조회 실패 (outfitId: " + outfitId + "): " + e.getMessage());
            e.printStackTrace();
        }

        return outfit;
    }
    public boolean updateOutfit(int outfitId, String name, List<Integer> clothIds, String date, String memo) {
        String updateOutfitSql = "UPDATE outfits SET name = ?, start_date = ?, memo = ? WHERE id = ?";
        String deleteMappingsSql = "DELETE FROM outfit_clothes WHERE outfit_id = ?";
        String insertMappingSql = "INSERT INTO outfit_clothes (outfit_id, cloth_id) VALUES (?, ?)";

        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            // 1. 코디 정보 업데이트
            try (PreparedStatement ps = conn.prepareStatement(updateOutfitSql)) {
                ps.setString(1, name);
                ps.setString(2, date);
                ps.setString(3, memo);
                ps.setInt(4, outfitId);
                ps.executeUpdate();
            }

            // 2. 기존 옷 연결 삭제
            try (PreparedStatement ps = conn.prepareStatement(deleteMappingsSql)) {
                ps.setInt(1, outfitId);
                ps.executeUpdate();
            }

            // 3. 새로운 옷 연결 추가
            try (PreparedStatement ps = conn.prepareStatement(insertMappingSql)) {
                for (int clothId : clothIds) {
                    ps.setInt(1, outfitId);
                    ps.setInt(2, clothId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }











    public List<Map<String, Object>> getOutfitsByDate(String date) {
        List<Map<String, Object>> outfits = new ArrayList<>();

        // 날짜 값 검증
        if (date == null || date.trim().isEmpty()) {
            System.out.println("유효하지 않은 날짜 값: " + date);
            return outfits;
        }

        String sql = """
        SELECT o.id AS outfit_id, o.name AS outfit_name, o.start_date, o.memo, 
               c.id AS cloth_id, c.name AS cloth_name, c.imageUrl
        FROM outfits o
        JOIN outfit_clothes oc ON o.id = oc.outfit_id
        JOIN clothes c ON oc.cloth_id = c.id
        WHERE o.start_date = ?
    """;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, date);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, Object> outfit = new HashMap<>();
                    outfit.put("outfit_id", resultSet.getInt("outfit_id"));
                    outfit.put("outfit_name", resultSet.getString("outfit_name"));
                    outfit.put("start_date", resultSet.getString("start_date")); // 날짜 추가
                    outfit.put("memo", resultSet.getString("memo")); // 메모 추가
                    outfit.put("cloth_id", resultSet.getInt("cloth_id"));
                    outfit.put("cloth_name", resultSet.getString("cloth_name"));
                    outfit.put("imageUrl", resultSet.getString("imageUrl"));
                    outfits.add(outfit);
                }
            }
        } catch (SQLException e) {
            System.out.println("코디 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }

        return outfits;
    }







}
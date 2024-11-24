package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    // 데이터베이스 설정
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/bsTest?useSSL=false&characterEncoding=UTF-8&serverTimezone=UTC";
    private static final String USERNAME = "bs";
    private static final String PASSWORD = "Rhdqudtjs0323!";
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver"; // MySQL 드라이버 클래스

    static {
        try {
            // 드라이버 로드
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL 드라이버를 로드하는 중 오류가 발생했습니다: " + e.getMessage());
            throw new RuntimeException("MySQL 드라이버를 찾을 수 없습니다.", e);
        }
    }

    // 데이터베이스 연결 메서드
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            System.out.println("데이터베이스 연결 실패: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}

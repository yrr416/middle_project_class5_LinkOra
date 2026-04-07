import java.sql.*;

public class DbCheckData {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/midproject?serverTimezone=UTC";
        String user = "root";
        String password = "1234"; // 이전 대화에서 확인된 비밀번호

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT * FROM inquiries";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                while (rs.next()) {
                    System.out.println("--- Record ---");
                    for (int i = 1; i <= columnCount; i++) {
                        System.out.println(metaData.getColumnName(i) + ": " + rs.getObject(i));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

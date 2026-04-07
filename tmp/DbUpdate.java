import java.sql.*;

public class DbUpdate {
    public static void main(String[] args) {
        String url = "jdbc:mysql://52.78.177.241:3306/team5_db?useSSL=false&serverTimezone=Asia/Seoul&allowPublicKeyRetrieval=true";
        String user = "team5_user";
        String password = "team5pass";

        String[] sqls = {
            "ALTER TABLE inquiries MODIFY i_answer TEXT NULL",
            "ALTER TABLE inquiries MODIFY i_answered DATETIME NULL"
        };

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            for (String sql : sqls) {
                System.out.println("Executing: " + sql);
                stmt.executeUpdate(sql);
                System.out.println("Success.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

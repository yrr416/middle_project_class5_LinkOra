import java.sql.*;

public class DbCheck {
    public static void main(String[] args) {
        String url = "jdbc:mysql://52.78.177.241:3306/team5_db?useSSL=false&serverTimezone=Asia/Seoul&allowPublicKeyRetrieval=true";
        String user = "team5_user";
        String pass = "team5pass";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println("--- Table: inquiries ---");
            printCreate(conn, "inquiries");
            System.out.println("\n--- Table: users ---");
            printCreate(conn, "users");
            System.out.println("\n--- Table: user (with backticks) ---");
            printCreate(conn, "user");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void printCreate(Connection conn, String tableName) {
        try (Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE " + tableName);
            if (rs.next()) {
                System.out.println(rs.getString(2));
            }
        } catch (SQLException e) {
            System.err.println("Table " + tableName + " not found or error: " + e.getMessage());
        }
    }
}

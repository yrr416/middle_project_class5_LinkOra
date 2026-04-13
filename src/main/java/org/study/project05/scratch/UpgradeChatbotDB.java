package org.study.project05.scratch;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class UpgradeChatbotDB {
    public static void main(String[] args) {
        String url = "jdbc:mysql://52.78.177.241:3306/team5_db?serverTimezone=Asia/Seoul&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true";
        String user = "team5_user";
        String pass = "team5pass";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Applying DB upgrade for 'chatbot' table...");
            
            // c_message와 c_response 컬럼의 크기를 TEXT(64KB)로 확장
            stmt.execute("ALTER TABLE chatbot MODIFY c_message TEXT");
            stmt.execute("ALTER TABLE chatbot MODIFY c_response TEXT");
            
            System.out.println("Successfully upgraded c_message and c_response to TEXT type.");
            
        } catch (Exception e) {
            System.err.println("DB Upgrade Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

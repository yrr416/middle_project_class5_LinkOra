package org.study.project05.scratch;

import java.sql.*;

public class CheckReservation26 {
    public static void main(String[] args) {
        String url = "jdbc:mysql://52.78.177.241:3306/team5_db?serverTimezone=Asia/Seoul&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true";
        String user = "team5_user";
        String pass = "team5pass";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery("SELECT r_idx, u_idx, r_status, r_start_time FROM reservation WHERE r_idx = 26");
            if (rs.next()) {
                System.out.println("Reservation #26 Found:");
                System.out.println("User ID (u_idx): " + rs.getInt("u_idx"));
                System.out.println("Status (r_status): " + rs.getString("r_status"));
                System.out.println("Start Time: " + rs.getString("r_start_time"));
            } else {
                System.out.println("Reservation #26 NOT FOUND.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

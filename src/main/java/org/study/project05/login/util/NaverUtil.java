/**
 * 네이버 OAuth2: 토큰 발급 및 회원 프로필(/v1/nid/me) 조회(HttpURLConnection + Gson).
 */
package org.study.project05.login.util;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.study.project05.login.vo.NaverUserVO;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Slf4j
@Component
public class NaverUtil {

    private static final String TOKEN_URL = "https://nid.naver.com/oauth2.0/token";
    private static final String USER_ME_URL = "https://openapi.naver.com/v1/nid/me";

    private final Gson gson = new Gson();

    @Value("${naver.client-id:}")
    private String clientId;

    @Value("${naver.client-secret:}")
    private String clientSecret;

    public String getAccessToken(String code, String state) {
        if (clientId == null || clientId.isBlank() || clientSecret == null || clientSecret.isBlank()) {
            log.warn("naver client-id / client-secret 미설정");
            return null;
        }
        try {
            String param = "grant_type=" + encode("authorization_code")
                    + "&client_id=" + encode(clientId)
                    + "&client_secret=" + encode(clientSecret)
                    + "&code=" + encode(code)
                    + "&state=" + encode(state);

            URL url = new URL(TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

            try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
                writer.write(param);
                writer.flush();
            }

            int codeHttp = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    codeHttp >= 200 && codeHttp < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            if (codeHttp < 200 || codeHttp >= 300) {
                log.info("naver token http {} body: {}", codeHttp, sb);
                return null;
            }

            AccessTokenResponse tokenResponse = gson.fromJson(sb.toString(), AccessTokenResponse.class);
            return tokenResponse != null ? tokenResponse.getAccessToken() : null;
        } catch (Exception e) {
            log.info("naver access token error : {}", e.getMessage());
            return null;
        }
    }

    public NaverUserVO getUserProfile(String accessToken) {
        if (accessToken == null || accessToken.isBlank()) {
            return null;
        }
        try {
            URL url = new URL(USER_ME_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int codeHttp = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    codeHttp >= 200 && codeHttp < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            if (codeHttp < 200 || codeHttp >= 300) {
                log.info("naver profile http {} body: {}", codeHttp, sb);
                return null;
            }

            NaverMeResponse me = gson.fromJson(sb.toString(), NaverMeResponse.class);
            if (me == null || me.getResponse() == null) {
                return null;
            }
            return me.getResponse();
        } catch (Exception e) {
            log.info("naver profile error : {}", e.getMessage());
            return null;
        }
    }

    private static String encode(String value) {
        if (value == null) {
            return "";
        }
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    @Getter
    @Setter
    private static class AccessTokenResponse {
        @SerializedName("access_token")
        private String accessToken;
    }

    @Getter
    @Setter
    private static class NaverMeResponse {
        private String resultcode;
        private String message;
        private NaverUserVO response;
    }
}

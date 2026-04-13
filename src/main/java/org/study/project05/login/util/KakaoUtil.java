/**
 * 카카오 OAuth2: 인가 코드로 액세스 토큰 발급 및 사용자 프로필 API 호출(HttpURLConnection + Gson).
 */
package org.study.project05.login.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.study.project05.login.vo.KakaoUserVO;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Slf4j
@Component
public class KakaoUtil {
    private static final String TOKEN_URL = "https://kauth.kakao.com/oauth/token";
    private static final String USER_ME_URL = "https://kapi.kakao.com/v2/user/me";

    private final Gson gson = new Gson();

    @Value("${kakao.client-id:}")
    private String clientId;

    @Value("${kakao.client-secret:}")
    private String clientSecret;

    @Value("${kakao.redirect-uri:http://localhost:8080/kakaologin}")
    private String redirectUri;

    public String getAccessToken(String code) {
        if (clientId == null || clientId.isBlank()) {
            log.warn("kakao client-id 미설정");
            return null;
        }
        try {
            StringBuilder param = new StringBuilder();
            param.append("grant_type=").append(encode("authorization_code"));
            param.append("&client_id=").append(encode(clientId));
            param.append("&redirect_uri=").append(encode(redirectUri));
            param.append("&code=").append(encode(code));
            if (clientSecret != null && !clientSecret.isBlank()) {
                param.append("&client_secret=").append(encode(clientSecret));
            }

            URL url = new URL(TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

            try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
                writer.write(param.toString());
                writer.flush();
            }

            int httpCode = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    httpCode >= 200 && httpCode < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8
            ));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            String body = sb.toString();
            if (httpCode < 200 || httpCode >= 300) {
                log.warn("카카오 토큰 요청 실패 http={} body={}", httpCode, body);
                return null;
            }

            KakaoTokenResponse tokenResponse = gson.fromJson(body, KakaoTokenResponse.class);
            if (tokenResponse != null && tokenResponse.getAccessToken() != null
                    && !tokenResponse.getAccessToken().isBlank()) {
                return tokenResponse.getAccessToken();
            }
            try {
                JsonObject err = gson.fromJson(body, JsonObject.class);
                if (err != null && err.has("error")) {
                    String desc = err.has("error_description") && !err.get("error_description").isJsonNull()
                            ? err.get("error_description").getAsString()
                            : err.get("error").getAsString();
                    log.warn("카카오 토큰 응답에 access_token 없음: {}", desc);
                } else {
                    log.warn("카카오 토큰 응답 파싱 실패 body={}", body);
                }
            } catch (Exception parseEx) {
                log.warn("카카오 토큰 응답 본문: {}", body);
            }
            return null;
        } catch (Exception e) {
            log.warn("카카오 access token 요청 예외: {}", e.getMessage(), e);
            return null;
        }
    }

    public KakaoUserVO getUserProfile(String accessToken) {
        if (accessToken == null || accessToken.isBlank()) {
            return null;
        }
        try {
            URL url = new URL(USER_ME_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int httpCode = conn.getResponseCode();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    httpCode >= 200 && httpCode < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8
            ));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            if (httpCode < 200 || httpCode >= 300) {
                log.info("kakao profile http {} body: {}", httpCode, sb);
                return null;
            }

            JsonObject root = gson.fromJson(sb.toString(), JsonObject.class);
            if (root == null) {
                return null;
            }
            KakaoUserVO user = new KakaoUserVO();
            if (root.has("id") && !root.get("id").isJsonNull()) {
                user.setId(root.get("id").getAsString());
            }
            JsonObject properties = root.has("properties") && root.get("properties").isJsonObject()
                    ? root.getAsJsonObject("properties") : null;
            if (properties != null) {
                if (properties.has("nickname") && !properties.get("nickname").isJsonNull()) {
                    user.setNickname(properties.get("nickname").getAsString());
                }
                if (properties.has("thumbnail_image_url") && !properties.get("thumbnail_image_url").isJsonNull()) {
                    user.setThumbnailImageUrl(properties.get("thumbnail_image_url").getAsString());
                }
            }
            JsonObject account = root.has("kakao_account") && root.get("kakao_account").isJsonObject()
                    ? root.getAsJsonObject("kakao_account") : null;
            if (account != null) {
                if (account.has("email") && !account.get("email").isJsonNull()) {
                    user.setEmail(account.get("email").getAsString());
                }
                if (account.has("phone_number") && !account.get("phone_number").isJsonNull()) {
                    user.setPhoneNumber(account.get("phone_number").getAsString());
                }
                JsonObject shippingAddress = account.has("shipping_address") && account.get("shipping_address").isJsonObject()
                        ? account.getAsJsonObject("shipping_address") : null;
                if (shippingAddress != null) {
                    if (shippingAddress.has("base_address") && !shippingAddress.get("base_address").isJsonNull()) {
                        user.setBaseAddress(shippingAddress.get("base_address").getAsString());
                    }
                    if (shippingAddress.has("detail_address") && !shippingAddress.get("detail_address").isJsonNull()) {
                        user.setDetailAddress(shippingAddress.get("detail_address").getAsString());
                    }
                }
            }
            return user;
        } catch (Exception e) {
            log.info("kakao profile error : {}", e.getMessage());
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
    private static class KakaoTokenResponse {
        @SerializedName("access_token")
        private String accessToken;
    }
}

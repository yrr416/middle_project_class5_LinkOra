package org.study.midproject.chat.service;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class ChatGPTService {
    
    // API 키와 모델명은 설정 파일(application.properties 등)에서 읽어옵니다.
    @Value("${openai.api.key:}")
    private String apiKey;
    
    @Value("${openai.model:gpt-3.5-turbo}")
    private String modelName;

    private static final String API_URL = "https://api.openai.com/v1/chat/completions";

    public String chat(List<Map<String, String>> messages) throws Exception {
        // 1. 입력값 검증
        if (apiKey == null || apiKey.isEmpty()) {
            throw new IllegalStateException("OpenAI API 키가 설정되지 않았습니다. application-secret.properties를 확인해주세요.");
        }
        if (messages == null || messages.isEmpty()) {
            throw new IllegalArgumentException("전송할 메시지가 없습니다.");
        }

        // 2. OkHttpClient 구성
        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();

        // 3. JSON 요청 바디 생성
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("model", modelName);

        JsonArray jsonArray = new JsonArray();
        for (Map<String, String> msg : messages) {
            JsonObject item = new JsonObject();
            item.addProperty("role", msg.get("role"));
            item.addProperty("content", msg.get("content"));
            jsonArray.add(item);
        }
        jsonObject.add("messages", jsonArray);

        // 4. Request 생성
        RequestBody body = RequestBody.create(
                jsonObject.toString(),
                MediaType.parse("application/json")
        );

        Request request = new Request.Builder()
                .url(API_URL)
                .header("Authorization", "Bearer " + apiKey)
                .post(body)
                .build();

        // 5. API 호출 및 결과 파싱
        try (Response response = client.newCall(request).execute()) {
            String respBody = response.body() != null ? response.body().string() : "";

            if (!response.isSuccessful()) {
                throw new RuntimeException("OpenAI API 호출 실패: " + response.code() + " - " + respBody);
            }

            JsonObject root = JsonParser.parseString(respBody).getAsJsonObject();
            return root.getAsJsonArray("choices")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("message")
                    .get("content").getAsString();
        }
    }
}

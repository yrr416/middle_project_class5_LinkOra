package org.study.project05.chat.service;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class ChatGPTService {
    
    // API 키와 모델명은 설정 파일(application.properties 등)에서 읽어옵니다.
    @Value("${openai.api.key:}")
    private String apiKey;
    
    @Value("${openai.model:gpt-5.4-mini}")
    private String modelName;

    private final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build();

    private static final String API_URL = "https://api.openai.com/v1/chat/completions";

    public String chat(List<Map<String, String>> messages) throws Exception {
        // 1. 입력값 검증
        if (apiKey == null || apiKey.isEmpty()) {
            throw new IllegalStateException("OpenAI API 키가 설정되지 않았습니다. application-secret.properties를 확인해주세요.");
        }
        if (messages == null || messages.isEmpty()) {
            throw new IllegalArgumentException("전송할 메시지가 없습니다.");
        }



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
        jsonObject.addProperty("temperature", 0.7);
        jsonObject.addProperty("max_completion_tokens", 500);

        // 4. Request 생성
        RequestBody body = RequestBody.create(
                jsonObject.toString(),
                MediaType.parse("application/json; charset=utf-8")
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
                log.error("OpenAI API Failure: {} - {}", response.code(), respBody);
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

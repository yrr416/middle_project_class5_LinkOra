# GPT 패키지 분석 및 검토 보고서

`gpt` 패키지는 OpenAI의 ChatGPT API를 연동하여 챗봇 기능을 제공하는 구현체입니다. 코드 분석 결과, 전체적인 구조는 잘 잡혀 있으나 `ChatController`에서 치명적인 호출 오류가 발견되었습니다.

## 사용자 검토 필요 사항

> [!IMPORTANT]
> `ChatController`의 `chatSend` 메서드에서 `getChatList`를 호출하고 있어, 실제 메세지 저장 및 GPT API 호출이 이루어지지 않는 문제가 있습니다. 이를 `getChatInsert` 호출로 수정해야 합니다.

> [!NOTE]
> 현재 모든 대화는 `latest`라는 고정된 세션 ID를 사용하도록 설계되어 있습니다. 추후 여러 대화방을 지원하려면 이 부분을 확장해야 합니다.

---

## 분석 결과 요약

### 1. 주요 구성 요소
- **VO**: `ChatVO` - 대화 이력 저장을 위한 데이터 객체
- **Mapper**: `ChatMapper` - MyBatis를 이용한 DB(chat_messages 테이블) 접근
- **Service**:
    - `ChatService` / `ChatServiceImpl`: 비즈니스 로직(사용자 메세지 저장 -> 이력 조회 -> GPT 요청 -> AI 답변 저장)
    - `ChatGPTService`: OkHttpClient를 사용한 외부 OpenAI API 통신
- **Controller**: `ChatController` - 화면 이동 및 사용자 요청 처리

### 2. 발견된 문제점
1. **Controller 로직 오류**: `chatSend` 메서드에서 `chatService.getChatInsert(chatVO)`를 호출해야 하는데, `getChatList(chatVO)`를 호출하고 있습니다. (인자 필터링 오류 및 기능 작동 불가)
2. **세션 ID 일관성**: `getChatList`에서는 `latest`를 강제하고 있으나, `chatSend`에서는 세션 ID를 명시적으로 세팅하지 않아 DB 저장 시 누락될 가능성이 있습니다.

---

## Proposed Changes (수정 제안)

### [GPT Component]

#### [MODIFY] [ChatController.java](file:///d:/dev/springmvc/myproject01/src/main/java/org/study/myproject01/gpt/controller/ChatController.java)
- `chatSend` 메서드에서 잘못된 서비스 메서드 호출 수정 및 `conversation_id` 세팅 추가.

#### [MODIFY] [ChatServiceImpl.java](file:///d:/dev/springmvc/myproject01/src/main/java/org/study/myproject01/gpt/service/ChatServiceImpl.java)
- `getChatInsert` 내부에서 `conversation_id`가 누락된 경우 기본값(`latest`)을 사용하도록 보완.

---

## Open Questions

- 현재 대화 내역을 최신 30개로 제한하고 있는데, 이 숫자를 조정할 필요가 있습니까?
- API Key와 모델명이 `application.properties`에 정상적으로 등록되어 있는지 확인이 필요합니다.

## Verification Plan

### Automated Tests
- 없음 (수동 테스트 권장)

### Manual Verification
1. `/chatGPT` 접속 시 이전 대화 목록이 정상적으로 출력되는지 확인.
2. 메세지 전송 시 GPT의 답변이 화면에 정상적으로 리다이렉트되어 출력되는지 확인.
3. DB `chat_messages` 테이블에 사용자 메세지와 AI 답변이 모두 저장되는지 확인.

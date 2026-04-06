# 🕒 챗봇 대화 이력 불러오기 구현 계획서 (2단계)

본 계획서는 사용자가 챗봇창을 열었을 때 데이터베이스에 저장된 이전 대화 내용을 자동으로 불러와 화면에 표시하는 기능을 구현하기 위함입니다.

## 사용자 검토 필요

> [!IMPORTANT]
> 1. **세션 유지 방식**: 브라우저의 `localStorage`를 사용하여 세션 ID를 반영구적으로 유지합니다. 만약 다른 브라우저나 기기에서 동일한 이력을 보고 싶다면 추후 '로그인 연동'이 필요합니다.
> 2. **이력 출력 시점**: 챗봇 위젯을 처음으로 '열기(Toggle Open)'할 때 서버에서 데이터를 한 번만 불러오도록 최적화합니다.

## 제안하는 변경 사항

### 1. 프론트엔드 (Logic)

#### [MODIFY] [chatbot.js](file:///d:/dev/project05/project05/src/main/webapp/static/js/chatbot.js)
*   `localStorage`에서 `chat_session_id`를 관리하도록 수정.
*   `loadChatHistory()` 함수 추가: 서버 엔드포인트 `/chat/history/{cSession}` 호출.
*   채팅창 오픈 시 기존 메시지를 비우고 다시 렌더링하는 로직 구현.

### 2. 백엔드 (Verification)

#### [VERIFY] [ChatController.java](file:///d:/dev/project05/project05/src/main/java/org/study/project05/chat/controller/ChatController.java)
*   `/chat/history/{cSession}` 엔드포인트가 정상적으로 작동하는지 확인.
*   필요 시 조회 데이터의 시간 순서(ORDER BY) 재검증.

---

## 오픈 질문

1. **이력 유지 기간**: 브라우저를 닫아도 계속 유지되게 할까요(`localStorage`), 아니면 창을 닫으면 초기화되게 할까요(`sessionStorage`)? (현재는 `localStorage`를 제안합니다.)
2. **중복 전송 방지**: 이미 창이 열려 있는 상태에서 또 다른 연동이 필요한지 등 UI 동작 방식을 확인해 주세요.

## 검증 계획

### 수동 검증
1.  대화를 몇 차례 진행한 후 페이지를 새로고침(`F5`) 합니다.
2.  챗봇을 다시 열었을 때 이전 대화가 순서대로 나타나는지 확인합니다.
3.  다른 브라우저 탭에서도 동일한 세션 ID로 대화가 이어지는지 체크합니다.

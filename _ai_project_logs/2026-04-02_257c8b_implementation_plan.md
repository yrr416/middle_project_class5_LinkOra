# GPT 패키지 코드 검토 및 기능 구현 계획

GPT 폴더 내의 코드를 검토한 결과, 여러 가지 문법 오류와 미구현된 기능이 발견되었습니다. 이를 수정하고 실제 ChatGPT 기능을 활성화하기 위한 계획입니다.

## User Review Required

> [!IMPORTANT]
> - `ChatMapper.xml`의 SQL 구문 오류(콤마 등)로 인해 현재 메세지 저장이 불가능합니다.
> - `ChatController`에서 잘못된 서비스 메서드(`getChatList`)를 호출하고 있어 데이터 처리가 되지 않고 있습니다.
> - `ChatGPTService`의 API 호출 로직이 비어있어 현재 GPT 응답을 받을 수 없는 상태입니다.
> - `inputForm.jsp`에 있는 '대화 초기화' 기능이 컨트롤러에 구현되어 있지 않습니다.

## Proposed Changes

### [Backend] GPT 연동 기능 정상화

---

#### [MODIFY] [ChatMapper.xml](file:///D:/dev/springmvc/myproject01/src/main/resources/mapper/ChatMapper.xml)
- `getChatInsert` 쿼리에서 컬럼 리스트 끝에 있는 콤마(`,`)를 제거합니다.

#### [MODIFY] [ChatController.java](file:///D:/dev/springmvc/myproject01/src/main/java/org/study/myproject01/gpt/controller/ChatController.java)
- `chatSend` 메서드에서 `chatService.getChatList(chatVO)`를 `chatService.getChatInsert(chatVO)`로 수정합니다.
- 대화 초기화를 위한 `/chatClear` POST 매핑 메서드를 추가합니다.

#### [MODIFY] [ChatGPTService.java](file:///D:/dev/springmvc/myproject01/src/main/java/org/study/myproject01/gpt/service/ChatGPTService.java)
- `OkHttp` 라이브러리를 사용하여 OpenAI API(`https://api.openai.com/v1/chat/completions`)를 호출하는 로직을 구현합니다.
- `application.properties`에 정의된 API 키와 모델을 사용합니다.
- JSON 파싱을 위해 `Gson`을 활용합니다.

#### [MODIFY] [ChatServiceImpl.java](file:///D:/dev/springmvc/myproject01/src/main/java/org/study/myproject01/gpt/service/ChatServiceImpl.java)
- `getChatInsert` 과정에서 `conversation_id`가 누락되지 않도록 로직을 보완합니다.

## Open Questions

- 현재 `conversation_id`를 "latest"로 고정해서 사용하고 있는데, 나중에 여러 브라우저 탭이나 다른 대화 세션을 지원해야 할까요? (현재는 단일 대화방 구조로 구현되어 있습니다.)

## Verification Plan

### Automated Tests
- 현재 자동화된 테스트 코드가 없으므로, 수동 테스트 후 필요시 JUnit 테스트 코드를 작성하겠습니다.

### Manual Verification
- 브라우저에서 `/chatGPT` 접속 후 메시지를 전송하여 DB 저장 및 GPT 답변이 정상적으로 출력되는지 확인합니다.
- '대화 초기화' 버튼 클릭 시 이전 내역이 삭제(또는 세션 변경)되는지 확인합니다.

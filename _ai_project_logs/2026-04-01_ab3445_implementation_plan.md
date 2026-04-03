# Project Setup: 'midproject'

기존 `myproject01` 프로젝트의 구조와 라이브러리를 기반으로 하여, 새로운 공유 오피스 서비스 웹사이트 개발을 위한 `midproject` 초기 설정을 진행합니다.

## User Review Required

> [!CAUTION]
> **보안 및 비밀번호 관리**: API Key나 DB 암호 등 민감한 정보가 GitHub에 노출되지 않도록 `application.properties` 외에 `application-secret.properties`를 분리하고, 이를 `.gitignore`에 등록하여 관리하겠습니다.
> - `.gitignore` 설정: `application-secret.properties`, `target/`, `.idea/` 등 제외

> [!WARNING]
> **데이터베이스 무결성 보호**: 기존 DB(`team5_db`)의 데이터를 임의로 수정(DML)하거나 구조를 변경(DDL)하지 않습니다. 모든 DB 작업은 사전에 한글 보고서를 통해 계획을 공유하고 사용자 승인을 받은 후 진행하겠습니다.

> [!TIP]
> **프로젝트 구조**: `myproject01`의 분석된 구조(Controller, Service, Mapper, VO, JSP 등)를 그대로 복제하여 `midproject`에 이식합니다.

## Proposed Changes

### [MidProject] - Core Setup

#### [NEW] [.gitignore](file:///D:/dev/midProject/midproject/.gitignore) [NEW]
보안 정보 및 빌드 파일을 제외하기 위한 설정 파일입니다.

#### [NEW] [pom.xml](file:///D:/dev/midProject/midproject/pom.xml)
`myproject01`의 의존성을 유지하며 프로젝트 명칭을 `midproject`로 설정합니다.

#### [NEW] [MidProjectApplication.java](file:///D:/dev/midProject/midproject/src/main/java/org/study/midproject/MidProjectApplication.java)
스프링 부트의 엔트리 포인트 클래스를 생성합니다.

#### [NEW] [ServletInitializer.java](file:///D:/dev/midProject/midproject/src/main/java/org/study/midproject/ServletInitializer.java)
WAR 배포 및 외장 톰캣 지원을 위한 초기화 클래스를 생성합니다.

#### [NEW] [application.properties](file:///D:/dev/midProject/midproject/src/main/resources/application.properties)
기본 설정을 포함하며, 민감 정보는 별도 분리된 파일을 참조하도록 설정합니다.

#### [NEW] [application-secret.properties](file:///D:/dev/midProject/midproject/src/main/resources/application-secret.properties)
- DB 접속 정보(Host, PWD 등)
- OpenAI API Key
- **주의**: 이 파일은 `.gitignore`에 의해 버전 관리에서 제외됩니다.

### [MidProject] - Feature Implementation (Chatbot & Inquiry)

#### [NEW] [InquiryController.java](file:///D:/dev/midProject/midproject/src/main/java/org/study/midproject/inquiry/controller/InquiryController.java)
문의하기 페이지 및 관련 API를 담당하는 컨트롤러입니다. (DB의 `inquiries` 테이블 연동)

#### [NEW] [ChatbotController.java](file:///D:/dev/midProject/midproject/src/main/java/org/study/midproject/chatbot/controller/ChatbotController.java)
OpenAI API와 통신하여 챗봇 응답을 처리하는 컨트롤러입니다. (DB의 `chatbot` 테이블 연동)

#### [NEW] [OpenAIService.java](file:///D:/dev/midProject/midproject/src/main/java/org/study/midproject/chatbot/service/OpenAIService.java)
OpenAI API 호출 로직을 분리하여 구현합니다.

## Open Questions

- **OpenAI API KEY**: 보안상의 이유로 API Key를 이곳에 직접 남기지 마시고, 프로젝트 생성 후 제가 안내해 드리는 곳에 직접 입력해 주시기 바랍니다.

## Verification Plan

### Automated Tests
- `mvn clean compile` 명령어를 통해 빌드 오류가 없는지 확인합니다.
- 내장 서버 실행 후 브라우저 테스트를 진행합니다.

### Manual Verification
- 브라우저에서 `http://localhost:8080/midproject/` 접속 시 "midproject" 관련 인덱스 페이지가 정상적으로 출력되는지 확인합니다.

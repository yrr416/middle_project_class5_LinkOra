# Project Walkthrough: 'project05' Setup

`myproject01`을 기반으로 한 `project05`의 초기 환경 구축이 완료되었습니다.

## 📁 주요 디렉토리 및 파일 구성

### [Core Config]
- **[.gitignore](file:///D:/dev/project05/project05/.gitignore)**: 빌드 산출물 및 비밀번호 설정 파일 제외
- **[pom.xml](file:///D:/dev/project05/project05/pom.xml)**: Spring Boot 4.0.3, MyBatis, JSP 의존성 설정
- **[application-secret.properties](file:///D:/dev/project05/project05/src/main/resources/application-secret.properties)**: DB 접속 정보 및 OpenAI API KEY (보안 격리)

### [Java Sources]
- **[project05Application.java](file:///D:/dev/project05/project05/src/main/java/org/study/project05/project05Application.java)**: 애플리케이션 시작점
- **[ServletInitializer.java](file:///D:/dev/project05/project05/src/main/java/org/study/project05/ServletInitializer.java)**: 외장 서블릿 컨테이너 대응
- **[IndexController.java](file:///D:/dev/project05/project05/src/main/java/org/study/project05/index/controller/IndexController.java)**: 루트 URL 매핑

### [Web Resources]
- **[index.jsp](file:///D:/dev/project05/project05/src/main/webapp/WEB-INF/views/index.jsp)**: 기본 메인 홈 페이지

## 🛠️ 빌드 및 실행 방법

1. **빌드**: 터미널에서 프로젝트 루트 폴더(`D:\dev\project05\project05`)로 이동한 후 다음 명령어를 실행합니다.
   ```bash
   .\mvnw clean compile
   ```
2. **실행**:
   ```bash
   .\mvnw spring-boot:run
   ```
3. **접속**: 브라우저에서 `http://localhost:8080/project05/` 주소로 접속하여 결과를 확인합니다.

## 🔐 보안 주의사항

> [!CAUTION]
> **API Key 및 패스워드 관리**: `application-secret.properties` 파일은 `.gitignore`에 등록되어 있어 GitHub에 업로드되지 않습니다. 팀원 간에 공유가 필요할 경우 수동으로 전달하시기 바랍니다.

## 🚀 다음 단계

현재 프로젝트는 빈 껍데기만 있는 상태입니다. 다음 작업으로 무엇을 할까요?
- [ ] OpenAI API 키를 설정하여 **챗봇 기능** 구현 시작
- [ ] DB의 `inquiries` 테이블을 활용한 **문의하기 페이지** 상세 디자인
- [ ] `myproject01`의 로그인/회원가입 기능 이식

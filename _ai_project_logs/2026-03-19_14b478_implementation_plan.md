# 공유오피스 예약 시스템(myproject102) 구현 계획

기존 `myproject101`의 검증된 기술 스택을 활용하여, 현대적이고 세련된 공유오피스 예약 플랫폼의 초기 화면을 신속하게 구축합니다.

## 제안된 변경 사항

### 1. 프로젝트 초기화 (Foundation)
- **[NEW] pom.xml**: Java 21 및 Spring Boot 기반 의존성 설정
- **[NEW] Project Structure**: `src/main/webapp/WEB-INF/views` 등 JSP 구조 생성
- **[NEW] application.properties**: 프로젝트명 및 포트(8081) 설정

### 2. UI/UX 디자인 (Presentation)
- **[NEW] static/css/index.css**: 전역 디자인 시스템 (컬러 팔레트, 타이포그래피, 애니메이션)
- **[NEW] WEB-INF/views/index.jsp**: 메인 검색 화면 (Hero Section, 주변 오피스 카드 레이아웃)
- **주요 디자인 포인트**:
    - **HERO Section**: 사용자 위치 기반 검색 바와 역동적인 배경
    - **Office Cards**: 유리 질감(Glassmorphism)과 마이크로 상호작용(Hover 효과)
    - **Premium Theme**: 다크 모드 지원 및 고해상도 이미지 활용

## 검증 계획

### 자동화 테스트
- `./mvnw compile`을 통해 빌드 오류가 없는지 확인합니다.
- `./mvnw spring-boot:run`으로 서버를 구동(포트 8081)하여 브라우저에서 화면을 검증합니다.

### 수동 검증
- 브라우저 서브에이전트를 통해 생성된 UI의 시각적 완성도를 확인하고 스크린샷을 제공합니다.

# 500 에러 해결 및 세션 처리 개선 계획

분석된 결과에 따라 데이터베이스 필수 입력 값 누락 문제를 해결하고, 세션 정보의 타입 안정성을 확보하기 위한 계획입니다.

## User Review Required

> [!CAUTION]
> 데이터베이스의 `inquiries` 테이블 구조를 직접 변경(`ALTER TABLE`)합니다.
> - `i_answer` (TEXT) -> NULL 허용으로 변경
> - `i_answered` (DATETIME) -> NULL 허용으로 변경

## Proposed Changes

### 1. Database Schema Update

#### [MODIFY] [inquiries table]
- 아래 SQL 명령어를 실행하여 문의 등록 시 아직 존재하지 않는 답변 관련 컬럼들이 NULL을 허용하도록 수정합니다.
```sql
ALTER TABLE inquiries MODIFY i_answer TEXT NULL;
ALTER TABLE inquiries MODIFY i_answered DATETIME NULL;
```

### 2. Inquiry Controller Logic Improvement

#### [MODIFY] [InquiryController.java](file:///d:/dev/project05/project05/src/main/java/org/study/project05/inquiry/controller/InquiryController.java)
- `getLoggedInUserIdx` 메서드를 수정하여 세션의 `u_idx`가 `Integer`, `Long`, `String` 중 어떤 타입으로 저장되어 있더라도 안전하게 `Integer`로 변환하여 반환하도록 로직을 강화합니다.

---

## Open Questions

- 세션의 `u_idx` 타입에 대해 다음에 알려주신다고 하셨으나, 현재 계획에서는 어떤 타입이든 대응 가능한 범용적인 변환 로직(String.valueOf 전용 후 Integer.parseInt 등)을 적용할 예정입니다. 이 방식으로 진행해도 괜찮을까요?

## Verification Plan

### Automated Tests
- `DbCheck.java`를 다시 실행하여 `inquiries` 테이블의 `Nullable` 설정이 `YES`로 변경되었는지 확인합니다.

### Manual Verification
- 브라우저에서 문의를 다시 등록해보고, 500 에러 없이 '나의 문의 내역' 페이지로 정상 이동하는지 확인합니다.

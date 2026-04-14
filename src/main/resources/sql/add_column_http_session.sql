-- chatbot 테이블에 비로그인 사용자의 세션 소유권 확인을 위한 컬럼 추가
-- 이 컬럼을 통해 chatSession과 httpSessionId가 모두 일치해야 게스트 대화 조회가 가능해집니다.

ALTER TABLE chatbot ADD COLUMN c_http_session VARCHAR(255) NULL COMMENT '브라우저 세션 ID (비회원 보안용)';

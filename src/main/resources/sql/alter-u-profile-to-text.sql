-- 기존 u_profile 이 VARCHAR로 짧게 잡혀 있을 때 길이 초과 오류 방지 (운영 DB에서 한 번 실행)
ALTER TABLE `user` MODIFY COLUMN u_profile TEXT NULL;

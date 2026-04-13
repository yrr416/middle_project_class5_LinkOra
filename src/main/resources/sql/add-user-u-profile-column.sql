-- `user` 테이블에 프로필 이미지 경로 컬럼 추가 (한 번만 실행, 긴 URL·경로 대비 TEXT)
ALTER TABLE `user` ADD COLUMN u_profile TEXT NULL;

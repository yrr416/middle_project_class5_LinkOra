CREATE TABLE IF NOT EXISTS `user` (
    u_idx BIGINT AUTO_INCREMENT PRIMARY KEY,
    u_id VARCHAR(128) NOT NULL UNIQUE,
    u_name VARCHAR(50) DEFAULT '',
    u_pwd VARCHAR(255) NOT NULL,
    u_email VARCHAR(255),
    u_addr VARCHAR(255),
    u_phone VARCHAR(255),
    u_created DATE NOT NULL,
    u_active INT DEFAULT 0,
    u_profile TEXT NULL
);

-- 특정 테이블 전체 조회
SELECT * FROM team5_db.partner;

-- 어떤 테이블들이 있는지 목록 먼저 확인
SHOW TABLES FROM team5_db;
-- 바이너리 로그 활성화 여부 확인
SHOW VARIABLES LIKE 'log_bin';
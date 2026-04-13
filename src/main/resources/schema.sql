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

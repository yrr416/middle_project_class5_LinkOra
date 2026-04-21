-- 1. 데이터베이스 생성 및 사용 설정 (선택 사항)
CREATE DATABASE IF NOT EXISTS team5_db;
USE team5_db;

-- ==========================================
-- [1단계] 부모 테이블 (다른 테이블이 참조하지 않는 독립 테이블)
-- ==========================================

-- 1-1. 회원 (user) : u_idx를 INT로 변경
CREATE TABLE IF NOT EXISTS `user` (
    `u_idx` INT AUTO_INCREMENT PRIMARY KEY,
    `u_id` VARCHAR(128) NOT NULL UNIQUE,
    `u_name` VARCHAR(50) DEFAULT '',
    `u_pwd` VARCHAR(255) NOT NULL,
    `u_email` VARCHAR(255),
    `u_addr` VARCHAR(255),
    `u_phone` VARCHAR(255),
    `u_created` DATE NOT NULL,
    `u_active` INT DEFAULT 0,
    `u_profile` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='회원';

-- 1-2. 관리자 (admin)
CREATE TABLE IF NOT EXISTS `admin` (
  `a_idx` int NOT NULL AUTO_INCREMENT,
  `a_id` varchar(50) NOT NULL,
  `a_name` varchar(50) NOT NULL,
  `a_pwd` varchar(255) NOT NULL,
  `a_email` varchar(255) NOT NULL,
  `a_addr` varchar(255) NOT NULL,
  `a_phone` varchar(255) NOT NULL,
  `a_active` int NOT NULL,
  PRIMARY KEY (`a_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='관리자';

-- 1-3. 파트너 회사 (partner)
CREATE TABLE IF NOT EXISTS `partner` (
  `p_idx` int NOT NULL AUTO_INCREMENT,
  `p_id` varchar(50) NOT NULL,
  `p_name` varchar(50) NOT NULL,
  `p_pwd` varchar(255) NOT NULL,
  `p_email` varchar(255) NOT NULL,
  `p_addr` varchar(255) NOT NULL,
  `p_phone` varchar(255) NOT NULL,
  `p_active` int NOT NULL,
  `p_number` varchar(12) NOT NULL,
  `p_profile` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`p_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='파트너 회사';

-- 1-4. 검색 로그 (search_log)
CREATE TABLE IF NOT EXISTS `search_log` (
  `keyword` varchar(100) NOT NULL,
  `hit_count` int DEFAULT '1',
  PRIMARY KEY (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 1-5. 시스템 설정 (settings)
CREATE TABLE IF NOT EXISTS `settings` (
  `s_key` varchar(100) NOT NULL COMMENT '설정 키',
  `s_value` text COMMENT '설정 값',
  `s_desc` varchar(255) DEFAULT NULL COMMENT '설명',
  PRIMARY KEY (`s_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='시스템 설정';

-- 1-6. 관리자 활동 로그 (admin_log)
CREATE TABLE IF NOT EXISTS `admin_log` (
  `l_idx` int NOT NULL AUTO_INCREMENT,
  `a_idx` int NOT NULL DEFAULT '0' COMMENT '관리자 번호',
  `a_name` varchar(50) NOT NULL DEFAULT '' COMMENT '관리자 이름',
  `l_action` varchar(100) NOT NULL COMMENT '수행 작업',
  `l_detail` varchar(500) DEFAULT NULL COMMENT '상세 내용',
  `l_ip` varchar(50) DEFAULT NULL COMMENT '접속 IP',
  `l_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`l_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='관리자 활동 로그';

-- 1-7. 문의 답변 템플릿 (inquiry_template)
CREATE TABLE IF NOT EXISTS `inquiry_template` (
  `t_idx` int NOT NULL AUTO_INCREMENT,
  `t_title` varchar(100) NOT NULL COMMENT '템플릿 제목',
  `t_content` text NOT NULL COMMENT '템플릿 내용',
  `t_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='문의 답변 템플릿';


-- ==========================================
-- [2단계] 자식 테이블 (user, admin, partner를 참조)
-- ==========================================

-- 2-1. 지점 (branch) - partner 참조
CREATE TABLE IF NOT EXISTS `branch` (
  `b_idx` int NOT NULL AUTO_INCREMENT,
  `p_idx` int NOT NULL DEFAULT '0',
  `b_name` varchar(100) NOT NULL COMMENT '지점 이름',
  `b_description` text NOT NULL COMMENT '지점 상세소개',
  `b_file` varchar(255) DEFAULT NULL COMMENT '파일',
  `b_address` varchar(200) NOT NULL COMMENT '지점 주소',
  `b_latitude` decimal(10,8) NOT NULL DEFAULT '0.00000000' COMMENT '경도',
  `b_altitude` decimal(11,8) NOT NULL DEFAULT '0.00000000' COMMENT '위도',
  `b_phone` varchar(20) NOT NULL COMMENT '지점 전화번호',
  `b_sns` varchar(255) NOT NULL COMMENT '지점 웹사이트',
  `b_hours` text NOT NULL COMMENT '운영시간',
  `b_notice` text COMMENT '운영수칙안내',
  `b_refund_policy` text COMMENT '환불규정안내',
  `b_active` int NOT NULL DEFAULT '0',
  `b_url` varchar(255) DEFAULT NULL,
  `b_created` datetime DEFAULT NULL,
  PRIMARY KEY (`b_idx`),
  KEY `p_idx_idx` (`p_idx`),
  CONSTRAINT `fk_branch_partner` FOREIGN KEY (`p_idx`) REFERENCES `partner` (`p_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='지점';

-- 2-2. 공지사항 (notice) - admin 참조
CREATE TABLE IF NOT EXISTS `notice` (
  `n_idx` int NOT NULL AUTO_INCREMENT,
  `n_title` varchar(255) NOT NULL COMMENT '제목',
  `n_content` longtext NOT NULL COMMENT '내용',
  `n_active` int NOT NULL DEFAULT '0',
  `n_created` datetime NOT NULL COMMENT '작성일',
  `n_updated` datetime NOT NULL COMMENT '수정일',
  `a_idx` int NOT NULL,
  PRIMARY KEY (`n_idx`),
  KEY `fk_notice_admin_idx` (`a_idx`),
  CONSTRAINT `fk_notice_admin` FOREIGN KEY (`a_idx`) REFERENCES `admin` (`a_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='공지사항';

-- 2-3. 챗봇 (chatbot) - user 참조
CREATE TABLE IF NOT EXISTS `chatbot` (
  `c_idx` int NOT NULL AUTO_INCREMENT,
  `u_idx` int NOT NULL COMMENT '회원 아이디',
  `c_session` int NOT NULL,
  `c_message` varchar(255) NOT NULL COMMENT '챗봇 질문내용',
  `c_response` varchar(500) NOT NULL COMMENT '챗본 답변내용',
  `c_intent` varchar(255) NOT NULL,
  `c_page` varchar(255) NOT NULL,
  `c_time` date NOT NULL COMMENT '채팅 생성시간',
  PRIMARY KEY (`c_idx`),
  KEY `u_idx_idx` (`u_idx`),
  CONSTRAINT `fk_chatbot_user` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='챗봇';

-- 2-4. 문의 (inquiries) - user 참조
CREATE TABLE IF NOT EXISTS `inquiries` (
  `i_idx` int NOT NULL AUTO_INCREMENT,
  `u_idx` int NOT NULL DEFAULT '0' COMMENT '회원 아이디',
  `i_category` varchar(50) NOT NULL COMMENT '문의 카테고리',
  `i_title` varchar(255) NOT NULL COMMENT '제목',
  `i_status` varchar(20) NOT NULL DEFAULT '대기중',
  `i_content` text COMMENT '내용',
  `i_file_url` varchar(255) DEFAULT NULL COMMENT '파일',
  `i_answer` text,
  `i_created` datetime DEFAULT (now()) COMMENT '문의 작성일',
  `i_answered` datetime DEFAULT NULL,
  PRIMARY KEY (`i_idx`),
  KEY `u_idx_idx` (`u_idx`),
  CONSTRAINT `fk_inquiries_user` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='문의';


-- ==========================================
-- [3단계] 손자 테이블 (branch, user 참조)
-- ==========================================

-- 3-1. 공간 (space) - branch 참조
CREATE TABLE IF NOT EXISTS `space` (
  `s_idx` int NOT NULL AUTO_INCREMENT,
  `b_idx` int NOT NULL,
  `s_type` enum('INDIVIDUAL','GROUP') NOT NULL,
  `s_name` varchar(100) NOT NULL,
  `s_price` int NOT NULL,
  `s_max_capacity` int NOT NULL,
  `s_description` text NOT NULL,
  `s_img` varchar(255) DEFAULT NULL,
  `s_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `s_active` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`s_idx`),
  KEY `fk_space_branch_idx` (`b_idx`),
  CONSTRAINT `fk_space_branch` FOREIGN KEY (`b_idx`) REFERENCES `branch` (`b_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='오피스안에 공간';

-- 3-2. 지점 이미지 (branch_img) - branch 참조(논리적)
CREATE TABLE IF NOT EXISTS `branch_img` (
  `bi_idx` int NOT NULL AUTO_INCREMENT,
  `b_idx` int NOT NULL,
  `bi_url` varchar(255) NOT NULL,
  `bi_order` int DEFAULT '0',
  `bi_is_main` tinyint DEFAULT '0',
  `bi_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bi_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3-3. 지점 문의 (contact) - branch, user 참조(논리적)
CREATE TABLE IF NOT EXISTS `contact` (
  `ct_idx` int NOT NULL AUTO_INCREMENT,
  `b_idx` int NOT NULL COMMENT '문의 대상 지점',
  `u_idx` int NOT NULL COMMENT '문의한 사용자',
  `ct_start_date` date DEFAULT NULL COMMENT '희망 시작일',
  `ct_duration` varchar(50) DEFAULT NULL COMMENT '계약 기간 (1개월/3개월 등)',
  `ct_headcount` int DEFAULT NULL COMMENT '인원 수',
  `ct_content` text NOT NULL COMMENT '문의 내용',
  `ct_status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/REPLIED/CLOSED',
  `ct_created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ct_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3-4. 찜 목록 (wishlist) - user, branch 참조
CREATE TABLE IF NOT EXISTS `wishlist` (
  `w_idx` int NOT NULL AUTO_INCREMENT,
  `u_idx` int NOT NULL,
  `b_idx` int NOT NULL,
  `w_regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`w_idx`),
  UNIQUE KEY `uk_user_branch` (`u_idx`,`b_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ==========================================
-- [4단계] 증손자 테이블 (space 참조)
-- ==========================================

-- 4-1. 편의시설 (facilities) - ALTER ADD COLUMN 통합됨
CREATE TABLE IF NOT EXISTS `facilities` (
  `f_idx` int NOT NULL AUTO_INCREMENT COMMENT '편의시설 고유 식별자',
  `f_cafe` int DEFAULT NULL COMMENT '카페테리아',
  `f_desk` int DEFAULT NULL COMMENT '리셉션/안내데스크',
  `f_delivery` int DEFAULT NULL COMMENT '택배수령 서비스',
  `f_water` int DEFAULT NULL COMMENT '정수기',
  `f_hours24` int DEFAULT NULL COMMENT '24시 운영 여부',
  `f_kitchen` int DEFAULT NULL COMMENT '공용주방',
  `f_display` int DEFAULT NULL COMMENT 'TV/프로젝터',
  `f_storage` int DEFAULT NULL COMMENT '창고/보관함',
  `f_parking` int DEFAULT NULL COMMENT '주차 시설',
  `f_fax` int DEFAULT NULL COMMENT '팩스 기기',
  `f_pet` int DEFAULT NULL COMMENT '반려견 출입 가능',
  `f_lounge` int DEFAULT NULL COMMENT '휴식공간/라운지',
  `s_idx` int DEFAULT NULL,
  `f_wifi` tinyint DEFAULT '0',
  `f_coffee` tinyint DEFAULT '0',
  `f_printer` tinyint DEFAULT '0',
  `f_locker` tinyint DEFAULT '0',
  PRIMARY KEY (`f_idx`),
  KEY `fk_facilities_space_idx` (`s_idx`),
  CONSTRAINT `fk_facilities_space` FOREIGN KEY (`s_idx`) REFERENCES `space` (`s_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='편의시설';

-- 4-2. 공간 이미지 (space_img)
CREATE TABLE IF NOT EXISTS `space_img` (
  `si_idx` int NOT NULL AUTO_INCREMENT,
  `s_idx` int NOT NULL,
  `si_url` varchar(255) NOT NULL,
  `si_order` int DEFAULT '0',
  `si_is_main` tinyint DEFAULT '0',
  `si_created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`si_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4-3. 예약 (reservation) - space, user 참조
CREATE TABLE IF NOT EXISTS `reservation` (
  `r_idx` int NOT NULL AUTO_INCREMENT,
  `s_idx` int NOT NULL DEFAULT '0' COMMENT '공간번호',
  `u_idx` int NOT NULL COMMENT '회원 아이디',
  `r_start_time` datetime NOT NULL,
  `r_end_time` datetime NOT NULL,
  `r_content` longtext NOT NULL,
  `r_headcount` int NOT NULL,
  `r_total_price` int NOT NULL,
  `r_created` datetime NOT NULL,
  `r_updated` datetime NOT NULL,
  `r_status` enum('PENDING','CONFIRMED','CANCELLED','FINISH','USE') NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`r_idx`),
  KEY `u_idx_idx` (`u_idx`),
  KEY `fk_reservation_space_idx` (`s_idx`),
  CONSTRAINT `fk_reservation_space` FOREIGN KEY (`s_idx`) REFERENCES `space` (`s_idx`),
  CONSTRAINT `fk_reservation_user` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='예약';

-- 4-4. 리뷰 (review) - space, user 참조
CREATE TABLE IF NOT EXISTS `review` (
  `v_idx` int NOT NULL AUTO_INCREMENT,
  `u_idx` int DEFAULT NULL,
  `s_idx` int NOT NULL,
  `v_time` datetime DEFAULT NULL,
  `v_rating` tinyint NOT NULL DEFAULT '0',
  `v_content` text NOT NULL,
  `v_parent_idx` int NOT NULL DEFAULT '0' COMMENT '답글처리',
  `v_created_at` datetime DEFAULT NULL,
  `v_updated_at` datetime DEFAULT NULL,
  `v_active` int unsigned NOT NULL DEFAULT '0',
  `v_img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`v_idx`),
  KEY `u_idx_idx` (`u_idx`),
  CONSTRAINT `fk_review_user` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='리뷰';


-- ==========================================
-- [5단계] 최하위 테이블 (review 등 참조)
-- ==========================================

-- 5-1. 리뷰 신고 (review_report) - review, user 참조
CREATE TABLE IF NOT EXISTS `review_report` (
  `rr_idx` int NOT NULL AUTO_INCREMENT,
  `v_idx` int NOT NULL,
  `u_idx` int NOT NULL,
  `rr_reason` varchar(255) DEFAULT NULL,
  `rr_status` varchar(20) DEFAULT 'PENDING',
  `rr_created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `rr_admin_reply` text,
  `rr_admin_reply_at` datetime DEFAULT NULL,
  `rr_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `rr_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`rr_idx`),
  KEY `v_idx` (`v_idx`),
  KEY `u_idx` (`u_idx`),
  CONSTRAINT `review_report_ibfk_1` FOREIGN KEY (`v_idx`) REFERENCES `review` (`v_idx`),
  CONSTRAINT `review_report_ibfk_2` FOREIGN KEY (`u_idx`) REFERENCES `user` (`u_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* payment 테이블 생성 */
CREATE TABLE payment (
    pay_idx INT AUTO_INCREMENT PRIMARY KEY, /* 결제 고유 번호 (자동 증가) */
    r_idx INT NOT NULL, /* 예약 번호 */
    u_idx INT NOT NULL, /* 사용자 번호 */
    payment_key VARCHAR(255), /* 결제 승인 키 */
    order_id VARCHAR(100) NOT NULL, /* 고유 주문 번호 */
    amount INT NOT NULL, /* 결제 금액 */
    pay_status VARCHAR(20) NOT NULL, /* 결제 상태 (예: DONE, CANCEL) */
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP /* 결제 일시 (기본값 현재시간) */
);
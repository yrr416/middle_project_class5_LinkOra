# Project Context

## Database
- Type: MySQL
- Host: 52.78.177.241
- Port: 3306
- Database: team5_db
- User: team5_user
- Password: team5pass
- Connection: `mysqlsh --sql -h 52.78.177.241 -P 3306 -u team5_user -pteam5pass --schema team5_db -e "쿼리"`

---

## 테이블 목록 (SHOW TABLES)

| 테이블명 | 설명 |
|----------|------|
| admin | 관리자 계정 |
| branch | 지점(지사) 정보 |
| chatbot | 챗봇 대화 로그 |
| facilities | 공간 시설/편의시설 |
| inquiries | 문의(1:1 문의) |
| notice | 공지사항 |
| partner | 파트너(업체) 계정 |
| reservation | 예약 정보 |
| review | 리뷰 |
| review_report | 리뷰 신고 |
| space | 공간(스페이스) 정보 |
| user | 일반 사용자 계정 |

---

## 테이블 스키마 (DESCRIBE)

### admin
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| a_idx | int | NO | PRI | NULL | auto_increment |
| a_id | varchar(50) | NO | | NULL | |
| a_name | varchar(50) | NO | | NULL | |
| a_pwd | varchar(255) | NO | | NULL | |
| a_email | varchar(255) | NO | | NULL | |
| a_addr | varchar(255) | NO | | NULL | |
| a_phone | varchar(255) | NO | | NULL | |
| a_active | int | NO | | NULL | |

### branch
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| b_idx | int | NO | PRI | NULL | auto_increment |
| p_idx | int | NO | MUL | 0 | (FK → partner) |
| b_name | varchar(100) | NO | | NULL | |
| b_description | text | NO | | NULL | |
| b_file | varchar(255) | NO | | NULL | |
| b_address | varchar(200) | NO | | NULL | |
| b_latitude | decimal(10,8) | NO | | 0 | |
| b_altitude | decimal(11,8) | NO | | 0 | |
| b_phone | varchar(20) | NO | | NULL | |
| b_sns | varchar(255) | NO | | NULL | |
| b_hours | text | NO | | NULL | |
| b_notice | text | YES | | NULL | |
| b_refund_policy | text | YES | | NULL | |
| b_active | int | NO | | 0 | |
| b_url | varchar(45) | YES | | NULL | |
| b_created | datetime | YES | | NULL | |

### chatbot
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| c_idx | int | NO | PRI | NULL | auto_increment |
| u_idx | int | NO | MUL | NULL | (FK → user) |
| c_session | int | NO | | NULL | |
| c_message | varchar(255) | NO | | NULL | |
| c_response | varchar(255) | NO | | NULL | |
| c_intent | varchar(255) | NO | | NULL | |
| c_page | varchar(255) | NO | | NULL | |
| c_time | date | NO | | NULL | |

### facilities
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| f_idx | int | NO | PRI | NULL | auto_increment |
| f_cafe | int | YES | | NULL | |
| f_desk | int | YES | | NULL | |
| f_delivery | int | YES | | NULL | |
| f_water | int | YES | | NULL | |
| f_24hours | int | YES | | NULL | |
| f_kitchen | int | YES | | NULL | |
| f_display | int | YES | | NULL | |
| f_storage | int | YES | | NULL | |
| f_parking | int | YES | | NULL | |
| f_fax | int | YES | | NULL | |
| f_pet | int | YES | | NULL | |
| f_lounge | int | YES | | NULL | |
| s_idx | int | YES | MUL | NULL | (FK → space) |

### inquiries
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| i_idx | int | NO | PRI | NULL | auto_increment |
| u_idx | int | NO | MUL | 0 | (FK → user) |
| i_category | varchar(50) | NO | | NULL | |
| i_title | varchar(255) | NO | | NULL | |
| i_status | varchar(20) | NO | | PENDING | |
| i_content | text | YES | | NULL | |
| i_file_url | varchar(255) | YES | | NULL | |
| i_answer | text | YES | | NULL | |
| i_created | datetime | YES | | now() | |
| i_answered | datetime | YES | | NULL | |

### notice
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| n_idx | int | NO | PRI | NULL | auto_increment |
| n_title | varchar(255) | NO | | NULL | |
| n_content | longtext | NO | | NULL | |
| n_active | int | NO | | 0 | |
| n_created | datetime | NO | | NULL | |
| n_updated | datetime | NO | | NULL | |
| a_idx | int | NO | MUL | NULL | (FK → admin) |

### partner
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| p_idx | int | NO | PRI | NULL | auto_increment |
| p_id | varchar(50) | NO | | NULL | |
| p_name | varchar(50) | NO | | NULL | |
| p_pwd | varchar(255) | NO | | NULL | |
| p_email | varchar(255) | NO | | NULL | |
| p_addr | varchar(255) | NO | | NULL | |
| p_phone | varchar(255) | NO | | NULL | |
| p_active | int | NO | | NULL | |

### reservation
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| r_idx | int | NO | PRI | NULL | auto_increment |
| s_idx | int | NO | MUL | 0 | (FK → space) |
| u_idx | int | NO | MUL | NULL | (FK → user) |
| r_start_time | datetime | NO | | NULL | |
| r_end_time | datetime | NO | | NULL | |
| r_content | longtext | NO | | NULL | |
| r_headcount | int | NO | | NULL | |
| r_total_price | int | NO | | NULL | |
| r_created | datetime | NO | | NULL | |
| r_updated | datetime | NO | | NULL | |
| r_status | enum('PENDING','CONFIRMED','CANCELLED') | NO | | PENDING | |

### review
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| v_idx | int | NO | PRI | NULL | auto_increment |
| u_idx | int | NO | MUL | NULL | (FK → user) |
| s_idx | int | NO | | NULL | (FK → space) |
| v_time | datetime | YES | | NULL | |
| v_rating | tinyint | NO | | 0 | |
| v_content | text | NO | | NULL | |
| v_parent_idx | int | NO | | 0 | (대댓글용) |
| v_created_at | datetime | YES | | NULL | |
| v_updated_at | datetime | YES | | NULL | |
| v_active | int unsigned | NO | | 0 | |
| v_img | varchar(255) | YES | | NULL | |

### review_report
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| rr_idx | int | NO | PRI | NULL | auto_increment |
| v_idx | int | NO | MUL | NULL | (FK → review) |
| u_idx | int | NO | MUL | NULL | (FK → user) |
| rr_reason | varchar(255) | YES | | NULL | |
| rr_status | varchar(20) | YES | | PENDING | |
| rr_created_at | datetime | YES | | CURRENT_TIMESTAMP | |
| rr_admin_reply | text | YES | | NULL | |
| rr_admin_reply_at | datetime | YES | | NULL | |
| rr_created | datetime | YES | | CURRENT_TIMESTAMP | |
| rr_updated | datetime | YES | | NULL | |

### space
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| s_idx | int | NO | PRI | NULL | auto_increment |
| b_idx | int | NO | MUL | NULL | (FK → branch) |
| s_type | enum('INDIVIDUAL','GROUP') | NO | | NULL | |
| s_name | varchar(100) | NO | | NULL | |
| s_price | int | NO | | NULL | |
| s_max_capacity | int | NO | | NULL | |
| s_description | text | NO | | NULL | |
| s_img | varchar(255) | YES | | NULL | |
| s_created | datetime | NO | | CURRENT_TIMESTAMP | |
| s_active | int | NO | | 0 | |

### user
| Field | Type | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| u_idx | int | NO | PRI | NULL | auto_increment |
| u_id | varchar(50) | NO | | 0 | |
| u_role | varchar(50) | NO | | | |
| u_name | varchar(50) | NO | | | |
| u_pwd | varchar(255) | NO | | NULL | |
| u_email | varchar(255) | NO | | NULL | |
| u_addr | varchar(255) | NO | | NULL | |
| u_phone | varchar(255) | NO | | NULL | |
| u_created | date | NO | | NULL | |
| u_active | int | NO | | 0 | |

---

## 테이블 관계 요약

```
user ──────── reservation ──── space ──── branch ──── partner
  │                               │
  ├── review ──── review_report   └── facilities
  ├── chatbot
  └── inquiries

admin ──── notice
```

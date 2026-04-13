INSERT INTO `user` (u_id, u_name, u_pwd, u_email, u_addr, u_phone, u_created, u_active, u_profile)
SELECT 'hong', '홍길동', '{noop}1234', 'hong@example.com', '서울특별시 강남구 테헤란로 123', '010-1234-5678', '2026-03-27', 0, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM `user` WHERE u_id = 'hong'
);

UPDATE `user`
SET u_pwd = '{noop}1234'
WHERE u_id = 'hong';

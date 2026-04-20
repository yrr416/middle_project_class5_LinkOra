/**
 * MyBatis 매퍼: 일반 회원(user 테이블) 조회·가입·OAuth 갱신·비밀번호·프로필·삭제.
 */
package org.study.project05.member.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.study.project05.member.vo.UserProfileVO;

import java.util.List;

@Mapper
public interface UserProfileMapper {

    @Select("""
            SELECT
                u_idx AS userIdx,
                u_id AS userId,
                '' AS role,
                u_name AS name,
                u_pwd AS password,
                u_email AS email,
                u_addr AS address,
                u_phone AS phone,
                u_created AS createdDate,
                u_active AS active,
                u_profile AS profileImage
            FROM `user`
            WHERE u_id = #{userId}
            ORDER BY u_idx DESC
            LIMIT 1
            """)
    UserProfileVO findByUserId(String userId);

    @Select("SELECT COUNT(*) FROM `user` WHERE u_id = #{userId}")
    int countByUserId(String userId);

    @Select("SELECT COUNT(*) FROM `user` WHERE u_email = #{email}")
    int countByEmail(String email);

    @Select("""
            SELECT
                u_idx AS userIdx,
                u_id AS userId,
                '' AS role,
                u_name AS name,
                u_pwd AS password,
                u_email AS email,
                u_addr AS address,
                u_phone AS phone,
                u_created AS createdDate,
                u_active AS active,
                u_profile AS profileImage
            FROM `user`
            WHERE LOWER(TRIM(COALESCE(u_email, ''))) = #{email}
            ORDER BY u_idx DESC
            LIMIT 1
            """)
    UserProfileVO findLatestByEmail(String email);

    @Insert("""
            INSERT INTO `user` (u_id, u_name, u_pwd, u_email, u_addr, u_phone, u_created, u_active, u_profile)
            VALUES (#{userId}, #{name}, #{password}, #{email}, #{address}, #{phone}, CURDATE(), 1, #{profilePath})
            """)
    int insertUser(
            @Param("userId") String userId,
            @Param("password") String password,
            @Param("name") String name,
            @Param("email") String email,
            @Param("address") String address,
            @Param("phone") String phone,
            @Param("profilePath") String profilePath
    );

    @Update("""
            UPDATE `user`
               SET u_name = #{name},
                   u_email = COALESCE(NULLIF(#{email}, ''), u_email),
                   u_addr = COALESCE(NULLIF(#{address}, ''), u_addr),
                   u_phone = COALESCE(NULLIF(#{phone}, ''), u_phone),
                   u_profile = COALESCE(NULLIF(#{profilePath}, ''), u_profile)
             WHERE u_id = #{userId}
            """)
    int updateOauthUserByUserId(
            @Param("userId") String userId,
            @Param("name") String name,
            @Param("email") String email,
            @Param("address") String address,
            @Param("phone") String phone,
            @Param("profilePath") String profilePath
    );

    @Update("UPDATE `user` SET u_pwd = #{encodedPassword} WHERE u_id = #{userId}")
    int updatePasswordByUserId(@Param("userId") String userId, @Param("encodedPassword") String encodedPassword);

    @Update("UPDATE `user` SET u_profile = #{profilePath} WHERE u_id = #{userId}")
    int updateProfileImageByUserId(@Param("userId") String userId, @Param("profilePath") String profilePath);

    @Delete("DELETE FROM `user` WHERE u_id = #{userId}")
    int deleteByUserId(@Param("userId") String userId);

    @Update("UPDATE `user` SET u_active = 0 WHERE u_id = #{userId}")
    int deactivateByUserId(@Param("userId") String userId);
    @Select("""
            SELECT u_id FROM `user`
            WHERE LOWER(TRIM(COALESCE(u_email, ''))) = #{email}
            ORDER BY u_idx DESC
            """)
    List<String> listUserIdsByEmail(@Param("email") String email);

    @Update("""
            UPDATE `user` SET u_pwd = #{encodedPassword}
            WHERE LOWER(TRIM(COALESCE(u_email, ''))) = #{email}
            """)
    int updatePasswordByUserEmail(@Param("email") String email, @Param("encodedPassword") String encodedPassword);

}

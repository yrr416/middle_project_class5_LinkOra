/**
 * MyBatis 매퍼: 사업자(partner 테이블) 조회·가입·프로필·비밀번호·삭제.
 */
package org.study.project05.partner.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.study.project05.partner.vo.PartnerVO;

import java.util.List;

@Mapper
public interface PartnerMapper {

    @Select("""
            SELECT
                p_idx AS ptnIdx,
                p_id AS partnerId,
                p_pwd AS password,
                p_name AS name,
                p_email AS email,
                p_addr AS address,
                p_phone AS phone,
                p_number AS businessNo,
                p_profile AS profileImage,
                p_active AS active
            FROM `partner`
            WHERE p_id = #{partnerId}
            LIMIT 1
            """)
    PartnerVO findByPartnerId(String partnerId);

    @Select("SELECT COUNT(*) FROM `partner` WHERE p_id = #{partnerId}")
    int countByPartnerId(String partnerId);

    @Select("SELECT COUNT(*) FROM `partner` WHERE p_email = #{email}")
    int countByEmail(String email);

    @Select("SELECT COUNT(*) FROM `partner` WHERE p_number = #{businessNo}")
    int countByBusinessNo(String businessNo);

    @Insert("""
            INSERT INTO `partner` (p_id, p_pwd, p_name, p_email, p_addr, p_phone, p_number, p_profile, p_active)
            VALUES (#{partnerId}, #{password}, #{name}, #{email}, #{address}, #{phone}, #{businessNo}, #{profileImagePath}, 1)
            """)
    int insertPartner(
            @Param("partnerId") String partnerId,
            @Param("password") String password,
            @Param("name") String name,
            @Param("email") String email,
            @Param("address") String address,
            @Param("phone") String phone,
            @Param("businessNo") String businessNo,
            @Param("profileImagePath") String profileImagePath
    );

    @Update("UPDATE `partner` SET p_profile = #{profileImagePath} WHERE p_id = #{partnerId}")
    int updateProfileImageByPartnerId(
            @Param("partnerId") String partnerId,
            @Param("profileImagePath") String profileImagePath
    );

    @Update("UPDATE `partner` SET p_pwd = #{encodedPassword} WHERE p_id = #{partnerId}")
    int updatePasswordByPartnerId(
            @Param("partnerId") String partnerId,
            @Param("encodedPassword") String encodedPassword
    );

    @Select("""
            SELECT
                p_idx AS ptnIdx,
                p_id AS partnerId,
                p_pwd AS password,
                p_name AS name,
                p_email AS email,
                p_addr AS address,
                p_phone AS phone,
                p_number AS businessNo,
                p_profile AS profileImage,
                p_active AS active
            FROM `partner`
            WHERE LOWER(TRIM(COALESCE(p_email, ''))) = #{email}
            ORDER BY p_idx DESC
            LIMIT 1
            """)
    PartnerVO findLatestByEmail(String email);

    @Select("""
            SELECT p_id FROM `partner`
            WHERE LOWER(TRIM(COALESCE(p_email, ''))) = #{email}
            ORDER BY p_idx DESC
            """)
    List<String> listPartnerIdsByEmail(@Param("email") String email);

    @Update("""
            UPDATE `partner` SET p_pwd = #{encodedPassword}
            WHERE LOWER(TRIM(COALESCE(p_email, ''))) = #{email}
            """)
    int updatePasswordByPartnerEmail(@Param("email") String email, @Param("encodedPassword") String encodedPassword);

    @Delete("DELETE FROM `partner` WHERE p_id = #{partnerId}")
    int deleteByPartnerId(@Param("partnerId") String partnerId);

    @Update("UPDATE `partner` SET p_active = 0 WHERE p_id = #{partnerId}")
    int deactivateByPartnerId(@Param("partnerId") String partnerId);
}

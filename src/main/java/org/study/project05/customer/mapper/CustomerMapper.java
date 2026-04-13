package org.study.project05.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.customer.vo.CustomerVO;

import java.util.List;
import java.util.Map;

/**
 * 고객(회원) 관리 매퍼
 */
@Mapper
public interface CustomerMapper {

    /** 전체 회원 수 (검색 조건 포함) */
    int getCustomerCount(Map<String, Object> params);

    /** 회원 목록 (페이징 + 검색) */
    List<CustomerVO> getCustomerList(Map<String, Object> params);

    /** 회원 총 수 (통계용) */
    int getTotalUserCount();

    /** 파트너 총 수 (통계용) */
    int getTotalPartnerCount();

    /** 회원 상세 조회 */
    CustomerVO getCustomerDetail(@Param("userIdx") String userIdx);

    /** 파트너 상세 조회 */
    CustomerVO getPartnerDetail(@Param("userIdx") String userIdx);

    /** 회원 등록 */
    void insertCustomer(CustomerVO vo);

    /** 회원 정보 수정 */
    void updateCustomer(CustomerVO vo);

    /** 파트너 정보 수정 */
    void updatePartner(CustomerVO vo);

    /** 회원 상태(숨김/정상) 변경 */
    void updateCustomerStatus(CustomerVO vo);

    /** 파트너 상태(숨김/정상) 변경 */
    void updatePartnerStatus(CustomerVO vo);

    /** 회원 삭제 (소프트 삭제: u_active=1) */
    void deleteCustomer(@Param("userIdx") String userIdx);

    /** 파트너 삭제 (소프트 삭제: p_active=1) */
    void deletePartner(@Param("userIdx") String userIdx);

    /** 아이디 중복 확인 */
    int checkDuplicateId(@Param("userId") String userId);

    /** 이메일 중복 확인 */
    int checkDuplicateEmail(@Param("userEmail") String userEmail);
}

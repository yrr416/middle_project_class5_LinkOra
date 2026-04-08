package org.study.project05class.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05class.customer.vo.CustomerVO;

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

    /** 회원 상세 조회 */
    CustomerVO getCustomerDetail(@Param("userIdx") String userIdx);

    /** 회원 등록 */
    void insertCustomer(CustomerVO vo);

    /** 회원 정보 수정 */
    void updateCustomer(CustomerVO vo);

    /** 회원 상태(숨김/정상) 변경 */
    void updateCustomerStatus(CustomerVO vo);

    /** 회원 삭제 (소프트 삭제: u_active=1) */
    void deleteCustomer(@Param("userIdx") String userIdx);

    /** 역할(role) 변경 */
    void updateCustomerMemo(CustomerVO vo);

    /** 아이디 중복 확인 */
    int checkDuplicateId(@Param("userId") String userId);

    /** 이메일 중복 확인 */
    int checkDuplicateEmail(@Param("userEmail") String userEmail);
}

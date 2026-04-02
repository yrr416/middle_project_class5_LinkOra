package org.study.project05class.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.customer.vo.CustomerVO;

import java.util.List;
import java.util.Map;

/**
 * 고객 관련 DB 처리 매퍼 인터페이스
 * MyBatis를 통해 CustomerMapper.xml 과 연동
 */
@Mapper
public interface CustomerMapper {

    // 전체 고객 수 조회 (페이징 및 통계용) - 검색 조건을 Map으로 받아 getCustomerList와 구조 통일
    int getCustomerCount(Map<String, Object> map);

    // 고객 목록 조회 (페이징, 검색 조건 포함)
    List<CustomerVO> getCustomerList(Map<String, Object> map);

    // 고객 상세 정보 조회 (고객 번호로 단건 조회)
    CustomerVO getCustomerDetail(String c_idx);

    // 고객 등록 처리
    int insertCustomer(CustomerVO customerVO);

    // 고객 정보 수정
    int updateCustomer(CustomerVO customerVO);

    // 고객 상태 변경 (정상/정지/탈퇴)
    int updateCustomerStatus(CustomerVO customerVO);

    // 고객 삭제 (관리자 전용)
    int deleteCustomer(String c_idx);

    // 고객 메모 수정 (관리자 메모)
    int updateCustomerMemo(CustomerVO customerVO);

    // 아이디 중복 확인
    int checkDuplicateId(String c_id);

    // 이메일 중복 확인
    int checkDuplicateEmail(String c_email);
}

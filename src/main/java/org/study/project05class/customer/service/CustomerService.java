package org.study.project05class.customer.service;

import org.study.project05class.customer.vo.CustomerVO;

import java.util.List;

/**
 * 고객 관리 서비스 인터페이스
 * 고객 CRUD 및 상태 관리 기능 정의
 */
public interface CustomerService {

    // 전체 고객 수 조회
    int getCustomerCount(CustomerVO customerVO);

    // 고객 목록 조회 (페이징 포함)
    List<CustomerVO> getCustomerList(int numPerPage, int offset, CustomerVO customerVO);

    // 고객 상세 조회
    CustomerVO getCustomerDetail(String c_idx);

    // 고객 등록
    int insertCustomer(CustomerVO customerVO);

    // 고객 정보 수정
    int updateCustomer(CustomerVO customerVO);

    // 고객 상태 변경 (정상/정지/탈퇴)
    int updateCustomerStatus(CustomerVO customerVO);

    // 고객 삭제
    int deleteCustomer(String c_idx);

    // 고객 메모 수정
    int updateCustomerMemo(CustomerVO customerVO);

    // 아이디 중복 확인
    int checkDuplicateId(String c_id);

    // 이메일 중복 확인
    int checkDuplicateEmail(String c_email);
}

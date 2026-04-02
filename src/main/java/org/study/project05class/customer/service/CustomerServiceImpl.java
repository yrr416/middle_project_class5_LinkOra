package org.study.project05class.customer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.customer.mapper.CustomerMapper;
import org.study.project05class.customer.vo.CustomerVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 고객 관리 서비스 구현 클래스
 * 비즈니스 로직 처리 후 매퍼에 위임
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    /**
     * 전체 고객 수 조회 (검색 조건 포함)
     * - getCustomerList 와 동일한 Map 구조로 searchCondition SQL 재사용
     */
    @Override
    public int getCustomerCount(CustomerVO customerVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("customerVO", customerVO);   // 검색 조건 (XML searchCondition 에서 customerVO.xxx 로 접근)
        return customerMapper.getCustomerCount(map);
    }

    /**
     * 고객 목록 조회
     * - numPerPage : 한 페이지에 표시할 고객 수
     * - offset     : 조회 시작 위치 (MySQL LIMIT offset, numPerPage)
     * - customerVO : 검색 조건 (이름, 아이디, 이메일, 상태 등)
     */
    @Override
    public List<CustomerVO> getCustomerList(int numPerPage, int offset, CustomerVO customerVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);   // 페이지당 표시 수
        map.put("offset", offset);           // 시작 위치
        map.put("customerVO", customerVO);   // 검색 조건 (XML searchCondition 에서 customerVO.xxx 로 접근)
        return customerMapper.getCustomerList(map);
    }

    /**
     * 고객 상세 정보 조회
     */
    @Override
    public CustomerVO getCustomerDetail(String c_idx) {
        return customerMapper.getCustomerDetail(c_idx);
    }

    /**
     * 고객 신규 등록
     */
    @Override
    public int insertCustomer(CustomerVO customerVO) {
        return customerMapper.insertCustomer(customerVO);
    }

    /**
     * 고객 정보 수정
     */
    @Override
    public int updateCustomer(CustomerVO customerVO) {
        return customerMapper.updateCustomer(customerVO);
    }

    /**
     * 고객 상태 변경
     * - active    : 정상 상태
     * - suspended : 이용 정지
     * - withdrawn : 탈퇴 처리
     */
    @Override
    public int updateCustomerStatus(CustomerVO customerVO) {
        return customerMapper.updateCustomerStatus(customerVO);
    }

    /**
     * 고객 삭제 (관리자 전용, 실제로는 상태 변경 권장)
     */
    @Override
    public int deleteCustomer(String c_idx) {
        return customerMapper.deleteCustomer(c_idx);
    }

    /**
     * 관리자 메모 수정
     */
    @Override
    public int updateCustomerMemo(CustomerVO customerVO) {
        return customerMapper.updateCustomerMemo(customerVO);
    }

    /**
     * 아이디 중복 확인 (0이면 사용 가능, 1 이상이면 중복)
     */
    @Override
    public int checkDuplicateId(String c_id) {
        return customerMapper.checkDuplicateId(c_id);
    }

    /**
     * 이메일 중복 확인 (0이면 사용 가능, 1 이상이면 중복)
     */
    @Override
    public int checkDuplicateEmail(String c_email) {
        return customerMapper.checkDuplicateEmail(c_email);
    }
}

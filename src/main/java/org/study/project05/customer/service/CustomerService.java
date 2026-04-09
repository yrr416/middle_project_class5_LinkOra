package org.study.project05.customer.service;

import org.study.project05.customer.vo.CustomerVO;

import java.util.List;

public interface CustomerService {

    int getCustomerCount(CustomerVO customerVO);
    List<CustomerVO> getCustomerList(int numPerPage, int offset, CustomerVO customerVO);
    CustomerVO getCustomerDetail(String u_idx);
    void insertCustomer(CustomerVO vo);
    void updateCustomer(CustomerVO vo);
    void updateCustomerStatus(CustomerVO vo);
    void deleteCustomer(String u_idx);
    void updateCustomerMemo(CustomerVO vo);
    int checkDuplicateId(String u_id);
    int checkDuplicateEmail(String u_email);
}

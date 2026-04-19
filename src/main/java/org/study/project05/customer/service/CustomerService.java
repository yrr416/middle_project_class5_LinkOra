package org.study.project05.customer.service;

import org.study.project05.customer.vo.CustomerVO;

import java.util.List;

public interface CustomerService {

    int getCustomerCount(CustomerVO customerVO);
    List<CustomerVO> getCustomerList(int numPerPage, int offset, CustomerVO customerVO);

    int getTotalUserCount();
    int getTotalPartnerCount();

    CustomerVO getCustomerDetail(String u_idx);
    CustomerVO getPartnerDetail(String p_idx);

    void insertCustomer(CustomerVO vo);

    void updateCustomer(CustomerVO vo);
    void updatePartner(CustomerVO vo);

    void updateCustomerStatus(CustomerVO vo);
    void updatePartnerStatus(CustomerVO vo);

    void deleteCustomer(String u_idx);
    void deletePartner(String p_idx);

    int checkDuplicateId(String u_id);
    int checkDuplicateEmail(String u_email);
}

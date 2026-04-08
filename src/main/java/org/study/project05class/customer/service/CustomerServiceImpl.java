package org.study.project05class.customer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.customer.mapper.CustomerMapper;
import org.study.project05class.customer.vo.CustomerVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    /* 페이징·검색 파라미터를 Map으로 묶어 매퍼에 전달 */
    private Map<String, Object> buildParams(int numPerPage, int offset, CustomerVO vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("customerVO", vo);
        params.put("numPerPage", numPerPage);
        params.put("offset",     offset);
        return params;
    }

    @Override public int getCustomerCount(CustomerVO vo) {
        return customerMapper.getCustomerCount(buildParams(0, 0, vo));
    }

    @Override public List<CustomerVO> getCustomerList(int numPerPage, int offset, CustomerVO vo) {
        return customerMapper.getCustomerList(buildParams(numPerPage, offset, vo));
    }

    @Override public CustomerVO getCustomerDetail(String u_idx)  { return customerMapper.getCustomerDetail(u_idx); }
    @Override public void insertCustomer(CustomerVO vo)          { customerMapper.insertCustomer(vo); }
    @Override public void updateCustomer(CustomerVO vo)          { customerMapper.updateCustomer(vo); }
    @Override public void updateCustomerStatus(CustomerVO vo)    { customerMapper.updateCustomerStatus(vo); }
    @Override public void deleteCustomer(String u_idx)           { customerMapper.deleteCustomer(u_idx); }
    @Override public void updateCustomerMemo(CustomerVO vo)      { customerMapper.updateCustomerMemo(vo); }
    @Override public int checkDuplicateId(String u_id)           { return customerMapper.checkDuplicateId(u_id); }
    @Override public int checkDuplicateEmail(String u_email)     { return customerMapper.checkDuplicateEmail(u_email); }
}

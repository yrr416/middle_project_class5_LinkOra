package org.study.project05.customer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.customer.mapper.CustomerMapper;
import org.study.project05.customer.vo.CustomerVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    private Map<String, Object> buildParams(int numPerPage, int offset, CustomerVO vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("customerVO", vo);
        params.put("numPerPage", numPerPage);
        params.put("offset",     offset);
        return params;
    }

    @Override public int getCustomerCount(CustomerVO vo)                      { return customerMapper.getCustomerCount(buildParams(0, 0, vo)); }
    @Override public List<CustomerVO> getCustomerList(int n, int o, CustomerVO vo) { return customerMapper.getCustomerList(buildParams(n, o, vo)); }

    @Override public int getTotalUserCount()                                   { return customerMapper.getTotalUserCount(); }
    @Override public int getTotalPartnerCount()                                { return customerMapper.getTotalPartnerCount(); }

    @Override public CustomerVO getCustomerDetail(String u_idx)               { return customerMapper.getCustomerDetail(u_idx); }
    @Override public CustomerVO getPartnerDetail(String p_idx)                { return customerMapper.getPartnerDetail(p_idx); }

    @Override public void insertCustomer(CustomerVO vo)                       { customerMapper.insertCustomer(vo); }

    @Override public void updateCustomer(CustomerVO vo)                       { customerMapper.updateCustomer(vo); }
    @Override public void updatePartner(CustomerVO vo)                        { customerMapper.updatePartner(vo); }

    @Override public void updateCustomerStatus(CustomerVO vo)                 { customerMapper.updateCustomerStatus(vo); }
    @Override public void updatePartnerStatus(CustomerVO vo)                  { customerMapper.updatePartnerStatus(vo); }

    @Override public void deleteCustomer(String u_idx)                        { customerMapper.deleteCustomer(u_idx); }
    @Override public void deletePartner(String p_idx)                         { customerMapper.deletePartner(p_idx); }

    @Override public int checkDuplicateId(String u_id)                        { return customerMapper.checkDuplicateId(u_id); }
    @Override public int checkDuplicateEmail(String u_email)                  { return customerMapper.checkDuplicateEmail(u_email); }
}

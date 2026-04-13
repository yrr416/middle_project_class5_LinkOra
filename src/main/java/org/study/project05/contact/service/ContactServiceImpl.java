package org.study.project05.contact.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.contact.mapper.ContactMapper;
import org.study.project05.contact.vo.ContactVO;

import java.util.List;

@Service
public class ContactServiceImpl implements ContactService {

    @Autowired
    private ContactMapper contactMapper;

    @Override
    public void writeContact(ContactVO vo) {
        if (vo.getCntContent() == null || vo.getCntContent().isBlank()) {
            throw new IllegalArgumentException("문의 내용을 입력해주세요.");
        }
        vo.setCntStatus("PENDING");
        contactMapper.insert(vo);
    }

    @Override
    public List<ContactVO> getAllContacts() {
        return contactMapper.selectAll();
    }

    @Override
    public List<ContactVO> getContactsByBranch(int brnIdx) {
        return contactMapper.selectByBranch(brnIdx);
    }

    @Override
    public void updateStatus(int cntIdx, String status) {
        if (!status.equals("PENDING") && !status.equals("REPLIED") && !status.equals("CLOSED")) {
            throw new IllegalArgumentException("유효하지 않은 상태값입니다.");
        }
        contactMapper.updateStatus(cntIdx, status);
    }
}

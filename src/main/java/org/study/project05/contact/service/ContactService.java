package org.study.project05.contact.service;

import org.study.project05.contact.vo.ContactVO;

import java.util.List;

public interface ContactService {

    /**
     * 장기 계약 문의 등록
     * @throws IllegalArgumentException 필수 항목 누락 시
     */
    void writeContact(ContactVO vo);

    /** 관리자용 전체 문의 목록 */
    List<ContactVO> getAllContacts();

    /** 특정 지점의 문의 목록 */
    List<ContactVO> getContactsByBranch(int bIdx);

    /** 문의 상태 변경 */
    void updateStatus(int ctIdx, String status);
}

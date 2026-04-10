package org.study.project05.contact.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.contact.vo.ContactVO;

import java.util.List;

@Mapper
public interface ContactMapper {

    /** 문의 등록 */
    void insert(ContactVO vo);

    /** 관리자용 전체 문의 목록 (최신순) */
    List<ContactVO> selectAll();

    /** 특정 지점의 문의 목록 */
    List<ContactVO> selectByBranch(@Param("brnIdx") int brnIdx);

    /** 문의 단건 조회 */
    ContactVO selectById(@Param("cntIdx") int cntIdx);

    /** 상태 변경 (PENDING → REPLIED / CLOSED) */
    void updateStatus(@Param("cntIdx") int cntIdx, @Param("status") String status);
}

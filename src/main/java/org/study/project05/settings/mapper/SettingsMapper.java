package org.study.project05.settings.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.settings.vo.AdminLogVO;
import org.study.project05.settings.vo.TemplateVO;

import java.util.List;
import java.util.Map;

/**
 * 설정 관리 Mapper 인터페이스
 */
@Mapper
public interface SettingsMapper {

    // ── 설정 키-값 ──────────────────────────────────────────────
    /** 전체 설정 조회 (key → value 맵) */
    List<Map<String, String>> getAllSettings();

    /** 특정 설정 값 조회 */
    String getSettingValue(String s_key);

    /** 설정 값 저장/갱신 */
    int upsertSetting(Map<String, String> map);

    // ── 관리자 계정 ──────────────────────────────────────────────
    /** 관리자 계정 정보 조회 (idx 기준) */
    Map<String, Object> getAdminInfo(String a_idx);

    /** 로그인 ID로 관리자 조회 (로그인용) */
    Map<String, Object> findAdminByLoginId(String loginId);

    /** 관리자 계정 정보 수정 (이름, 이메일, 연락처) */
    int updateAdminInfo(Map<String, Object> map);

    /** 비밀번호 변경 */
    int updateAdminPassword(Map<String, Object> map);

    // ── 답변 템플릿 ──────────────────────────────────────────────
    /** 템플릿 전체 목록 */
    List<TemplateVO> getTemplateList();

    /** 템플릿 등록 */
    int insertTemplate(TemplateVO templateVO);

    /** 템플릿 수정 */
    int updateTemplate(TemplateVO templateVO);

    /** 템플릿 삭제 */
    int deleteTemplate(@Param("tplIdx") String tplIdx);

    // ── 관리자 활동 로그 ─────────────────────────────────────────
    /** 활동 로그 전체 수 */
    int getLogCount();

    /** 활동 로그 목록 (최신순, 페이징) */
    List<AdminLogVO> getLogList(Map<String, Object> map);

    /** 활동 로그 기록 */
    int insertLog(AdminLogVO logVO);
}

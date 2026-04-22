package org.study.project05.settings.service;

import org.study.project05.settings.vo.AdminLogVO;
import org.study.project05.settings.vo.RefundPolicyVO;
import org.study.project05.settings.vo.TemplateVO;

import java.util.List;
import java.util.Map;

/**
 * 설정 관리 서비스 인터페이스
 */
public interface SettingsService {

    // ── 설정 키-값 ──────────────────────────────────────────────
    Map<String, String> getAllSettings();
    String getSettingValue(String key);
    int saveSetting(String key, String value);
    int saveSettings(Map<String, String> settingsMap);

    // ── 관리자 계정 ──────────────────────────────────────────────
    Map<String, Object> getAdminInfo(String a_idx);
    Map<String, Object> getAdminInfoByLoginId(String loginId);
    int updateAdminInfo(String a_idx, String a_name, String a_email, String a_phone);
    boolean changePassword(String a_idx, String currentPwd, String newPwd);

    // ── 답변 템플릿 ──────────────────────────────────────────────
    List<TemplateVO> getTemplateList();
    int insertTemplate(TemplateVO templateVO);
    int updateTemplate(TemplateVO templateVO);
    int deleteTemplate(String t_idx);

    // ── 환불 정책 ────────────────────────────────────────────────
    List<RefundPolicyVO> getRefundPolicyList();
    int insertRefundPolicy(RefundPolicyVO vo);
    int updateRefundPolicy(RefundPolicyVO vo);
    int deleteRefundPolicy(int policyIdx);
    /** 남은 시간(시)에 해당하는 환불율 반환. 해당 구간 없으면 0 */
    int getRefundRate(int hoursLeft);

    // ── 관리자 활동 로그 ─────────────────────────────────────────
    int getLogCount();
    List<AdminLogVO> getLogList(int numPerPage, int offset);
    void writeLog(String a_idx, String a_name, String action, String detail, String ip);
}

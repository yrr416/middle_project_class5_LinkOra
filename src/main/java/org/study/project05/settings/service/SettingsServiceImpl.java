package org.study.project05.settings.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.settings.mapper.SettingsMapper;
import org.study.project05.settings.vo.AdminLogVO;
import org.study.project05.settings.vo.TemplateVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 설정 관리 서비스 구현 클래스
 */
@Service
public class SettingsServiceImpl implements SettingsService {

    @Autowired
    private SettingsMapper settingsMapper;

    // ── 설정 키-값 ──────────────────────────────────────────────

    /** 전체 설정을 key→value 맵으로 반환 (MySQL alias 대소문자 무관 처리) */
    @Override
    public Map<String, String> getAllSettings() {
        Map<String, String> result = new HashMap<>();
        List<Map<String, String>> list = settingsMapper.getAllSettings();
        for (Map<String, String> row : list) {
            String key = null, value = null;
            for (Map.Entry<String, String> e : row.entrySet()) {
                String col = e.getKey().toLowerCase();
                if (col.equals("skey"))   key   = e.getValue();
                if (col.equals("svalue")) value = e.getValue();
            }
            if (key != null) result.put(key, value);
        }
        return result;
    }

    /** 단일 설정 저장 */
    @Override
    public int saveSetting(String key, String value) {
        Map<String, String> map = new HashMap<>();
        map.put("sKey", key);
        map.put("sValue", value);
        return settingsMapper.upsertSetting(map);
    }

    /** 여러 설정 일괄 저장 */
    @Override
    public int saveSettings(Map<String, String> settingsMap) {
        int cnt = 0;
        for (Map.Entry<String, String> entry : settingsMap.entrySet()) {
            cnt += saveSetting(entry.getKey(), entry.getValue());
        }
        return cnt;
    }

    // ── 관리자 계정 ──────────────────────────────────────────────

    /** 관리자 계정 정보 조회 (a_idx 기준) */
    @Override
    public Map<String, Object> getAdminInfo(String a_idx) {
        return settingsMapper.getAdminInfo(a_idx);
    }

    /** 로그인 ID(a_id)로 관리자 전체 정보 조회 */
    @Override
    public Map<String, Object> getAdminInfoByLoginId(String loginId) {
        return settingsMapper.getAdminInfoByLoginId(loginId);
    }

    /** 관리자 이름·이메일·연락처 수정 */
    @Override
    public int updateAdminInfo(String a_idx, String a_name, String a_email, String a_phone) {
        Map<String, Object> map = new HashMap<>();
        map.put("aIdx",   a_idx);
        map.put("aName",  a_name);
        map.put("aEmail", a_email);
        map.put("aPhone", a_phone);
        return settingsMapper.updateAdminInfo(map);
    }

    /**
     * 비밀번호 변경
     * - 현재 비밀번호 일치 확인 후 변경
     * - 일치하지 않으면 false 반환
     */
    @Override
    public boolean changePassword(String a_idx, String currentPwd, String newPwd) {
        Map<String, Object> adminInfo = settingsMapper.getAdminInfo(a_idx);
        if (adminInfo == null) return false;

        String storedPwd = String.valueOf(adminInfo.get("aPwd"));
        if (!storedPwd.equals(currentPwd)) return false; // 현재 비밀번호 불일치

        Map<String, Object> map = new HashMap<>();
        map.put("aIdx", a_idx);
        map.put("aPwd", newPwd);
        settingsMapper.updateAdminPassword(map);
        return true;
    }

    // ── 답변 템플릿 ──────────────────────────────────────────────

    @Override
    public List<TemplateVO> getTemplateList() {
        return settingsMapper.getTemplateList();
    }

    @Override
    public int insertTemplate(TemplateVO templateVO) {
        return settingsMapper.insertTemplate(templateVO);
    }

    @Override
    public int updateTemplate(TemplateVO templateVO) {
        return settingsMapper.updateTemplate(templateVO);
    }

    @Override
    public int deleteTemplate(String t_idx) {
        return settingsMapper.deleteTemplate(t_idx);
    }

    // ── 관리자 활동 로그 ─────────────────────────────────────────

    @Override
    public int getLogCount() {
        return settingsMapper.getLogCount();
    }

    @Override
    public List<AdminLogVO> getLogList(int numPerPage, int offset) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        return settingsMapper.getLogList(map);
    }

    /** 관리자 활동 로그 기록 */
    @Override
    public void writeLog(String a_idx, String a_name, String action, String detail, String ip) {
        AdminLogVO log = new AdminLogVO();
        log.setAdmIdx(a_idx);
        log.setAdmName(a_name);
        log.setAlogAction(action);
        log.setAlogDetail(detail);
        log.setAlogIp(ip);
        settingsMapper.insertLog(log);
    }
}

package org.study.project05class.settings.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05class.settings.service.SettingsService;
import org.study.project05class.settings.vo.TemplateVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 설정 관리 컨트롤러
 * /admin/settings/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/settings")
public class SettingsController {

    @Autowired
    private SettingsService settingsService;

    /** 활동 로그 페이지당 표시 수 */
    private static final int LOG_PER_PAGE = 15;

    /**
     * 설정 메인 페이지
     * - 전체 설정 값 로드
     * - 답변 템플릿 목록
     * - 관리자 계정 정보
     * - 활동 로그 (최신 15건)
     * GET /admin/settings
     */
    @GetMapping({"", "/"})
    public String index(@RequestParam(defaultValue = "1") int logPage,
                        @RequestParam(defaultValue = "account") String tab,
                        Model model) {

        // 전체 설정 key→value 맵
        Map<String, String> settings = settingsService.getAllSettings();
        model.addAttribute("settings", settings);

        // 관리자 계정 정보 (a_idx=1 고정; 실제 세션에서 가져올 경우 교체)
        Map<String, Object> adminInfo = settingsService.getAdminInfo("1");
        model.addAttribute("adminInfo", adminInfo);

        // 답변 템플릿 목록
        model.addAttribute("templateList", settingsService.getTemplateList());

        // 활동 로그 페이징
        int totalLog   = settingsService.getLogCount();
        int totalPage  = (totalLog <= 0) ? 1 : (int) Math.ceil((double) totalLog / LOG_PER_PAGE);
        if (logPage < 1) logPage = 1;
        if (logPage > totalPage) logPage = totalPage;
        int offset = (logPage - 1) * LOG_PER_PAGE;

        model.addAttribute("logList",   settingsService.getLogList(LOG_PER_PAGE, offset));
        model.addAttribute("totalLog",  totalLog);
        model.addAttribute("logPage",   logPage);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("tab",       tab);

        return "settings/index";
    }

    /**
     * 관리자 계정 정보 수정 (이름, 이메일, 연락처)
     * POST /admin/settings/account
     */
    @PostMapping("/account")
    public String updateAccount(@RequestParam String aName,
                                @RequestParam String aEmail,
                                @RequestParam String aPhone,
                                HttpServletRequest request,
                                RedirectAttributes rttr) {

        settingsService.updateAdminInfo("1", aName, aEmail, aPhone);
        // 활동 로그 기록
        settingsService.writeLog("1", aName, "계정 정보 수정",
                "이름·이메일·연락처 변경", request.getRemoteAddr());

        rttr.addFlashAttribute("msg", "계정 정보가 수정되었습니다.");
        return "redirect:/admin/settings?tab=account";
    }

    /**
     * 비밀번호 변경
     * POST /admin/settings/password
     */
    @PostMapping("/password")
    public String changePassword(@RequestParam String currentPwd,
                                 @RequestParam String newPwd,
                                 @RequestParam String newPwdConfirm,
                                 HttpServletRequest request,
                                 RedirectAttributes rttr) {

        // 새 비밀번호 확인 일치 검사
        if (!newPwd.equals(newPwdConfirm)) {
            rttr.addFlashAttribute("pwdMsg", "새 비밀번호가 일치하지 않습니다.");
            return "redirect:/admin/settings?tab=account";
        }

        boolean result = settingsService.changePassword("1", currentPwd, newPwd);
        if (result) {
            settingsService.writeLog("1", "", "비밀번호 변경", "", request.getRemoteAddr());
            rttr.addFlashAttribute("pwdMsg", "비밀번호가 변경되었습니다.");
        } else {
            rttr.addFlashAttribute("pwdMsg", "현재 비밀번호가 일치하지 않습니다.");
        }
        return "redirect:/admin/settings?tab=account";
    }

    /**
     * 서비스 정책 저장 (등급 기준, 포인트, 취소 정책)
     * POST /admin/settings/policy
     */
    @PostMapping("/policy")
    public String savePolicy(@RequestParam Map<String, String> params,
                             HttpServletRequest request,
                             RedirectAttributes rttr) {

        // 저장할 키만 추출 (Spring MVC 파라미터 중 설정 관련 키)
        String[] policyKeys = {
            "grade_silver_count", "grade_gold_count",
            "grade_silver_amount", "grade_gold_amount",
            "point_rate", "point_min_use",
            "cancel_period", "refund_rate_full", "refund_rate_half"
        };
        Map<String, String> toSave = new HashMap<>();
        for (String key : policyKeys) {
            if (params.containsKey(key)) toSave.put(key, params.get(key));
        }
        settingsService.saveSettings(toSave);
        settingsService.writeLog("1", "", "정책 설정 변경", "등급·포인트·취소 정책", request.getRemoteAddr());

        rttr.addFlashAttribute("msg", "정책 설정이 저장되었습니다.");
        return "redirect:/admin/settings?tab=policy";
    }

    /**
     * 서비스 설정 저장 (운영시간, 팝업, 알림)
     * POST /admin/settings/service
     */
    @PostMapping("/service")
    public String saveService(@RequestParam Map<String, String> params,
                              HttpServletRequest request,
                              RedirectAttributes rttr) {

        String[] serviceKeys = {
            "op_start_time", "op_end_time",
            "popup_enabled", "popup_notice_idx", "popup_end_date",
            "email_reservation", "email_inquiry", "email_report"
        };
        // 체크박스/토글은 미체크 시 params에 없으므로 기본값 0 처리
        String[] toggleKeys = {"popup_enabled", "email_reservation", "email_inquiry", "email_report"};
        for (String key : toggleKeys) {
            params.putIfAbsent(key, "0");
        }
        Map<String, String> toSave = new HashMap<>();
        for (String key : serviceKeys) {
            if (params.containsKey(key)) toSave.put(key, params.get(key));
        }
        settingsService.saveSettings(toSave);
        settingsService.writeLog("1", "", "서비스 설정 변경", "운영시간·팝업·알림", request.getRemoteAddr());

        rttr.addFlashAttribute("msg", "서비스 설정이 저장되었습니다.");
        return "redirect:/admin/settings?tab=service";
    }

    /**
     * 시스템 설정 저장 (수수료율, 약관, 개인정보처리방침)
     * POST /admin/settings/system
     */
    @PostMapping("/system")
    public String saveSystem(@RequestParam Map<String, String> params,
                             HttpServletRequest request,
                             RedirectAttributes rttr) {

        String[] systemKeys = {"commission_rate", "terms_content", "privacy_content"};
        Map<String, String> toSave = new HashMap<>();
        for (String key : systemKeys) {
            if (params.containsKey(key)) toSave.put(key, params.get(key));
        }
        settingsService.saveSettings(toSave);
        settingsService.writeLog("1", "", "시스템 설정 변경", "수수료·약관", request.getRemoteAddr());

        rttr.addFlashAttribute("msg", "시스템 설정이 저장되었습니다.");
        return "redirect:/admin/settings?tab=system";
    }

    /**
     * 답변 템플릿 저장 (등록 / 수정)
     * POST /admin/settings/template/save
     */
    @PostMapping("/template/save")
    public String saveTemplate(TemplateVO templateVO,
                               HttpServletRequest request,
                               RedirectAttributes rttr) {

        if (templateVO.getTplIdx() != null && !templateVO.getTplIdx().isEmpty()) {
            // 수정
            settingsService.updateTemplate(templateVO);
            rttr.addFlashAttribute("msg", "템플릿이 수정되었습니다.");
        } else {
            // 등록
            settingsService.insertTemplate(templateVO);
            rttr.addFlashAttribute("msg", "템플릿이 등록되었습니다.");
        }
        settingsService.writeLog("1", "", "답변 템플릿 변경",
                templateVO.getTplTitle(), request.getRemoteAddr());

        return "redirect:/admin/settings?tab=service";
    }

    /**
     * 답변 템플릿 삭제
     * POST /admin/settings/template/delete
     */
    @PostMapping("/template/delete")
    public String deleteTemplate(@RequestParam String tplIdx,
                                 HttpServletRequest request,
                                 RedirectAttributes rttr) {

        settingsService.deleteTemplate(tplIdx);
        settingsService.writeLog("1", "", "답변 템플릿 삭제", "tplIdx=" + tplIdx, request.getRemoteAddr());

        rttr.addFlashAttribute("msg", "템플릿이 삭제되었습니다.");
        return "redirect:/admin/settings?tab=service";
    }

    /**
     * 템플릿 단건 조회 (수정 모달용 AJAX)
     * GET /admin/settings/template/{t_idx}
     */
    @GetMapping("/template/{tplIdx}")
    @ResponseBody
    public TemplateVO getTemplate(@PathVariable String tplIdx) {
        return settingsService.getTemplateList().stream()
                .filter(t -> t.getTplIdx().equals(tplIdx))
                .findFirst().orElse(null);
    }
}

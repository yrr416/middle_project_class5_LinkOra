/**
 * 공통 웹 화면·진단: 루트 리다이렉트, 대시보드, 챗봇, DB 연결 확인(/db-check).
 */
package org.study.project05.common.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.study.project05.settings.service.SettingsService;

@Controller
public class CommonWebController {

    private final JdbcTemplate jdbcTemplate;
    private final String datasourceUrl;
    private final SettingsService settingsService;

    public CommonWebController(
            JdbcTemplate jdbcTemplate,
            @Value("${spring.datasource.url:}") String datasourceUrl,
            SettingsService settingsService
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.datasourceUrl = datasourceUrl;
        this.settingsService = settingsService;
    }

    @GetMapping("/root-home")
    public String root() {
        return "redirect:/home";
    }

    @GetMapping("/login")
    public String legacyLoginPath() {
        return "redirect:/loginPage";
    }

    @GetMapping("/dashboard")
    public String dashboardPage() {
        return "common/dashboard";
    }

    @GetMapping("/home")
    public String homePage() {
        return "common/dashboard";
    }

    @GetMapping("/chatbot")
    public String chatbotPage() {
        return "common/chatbot";
    }

    /** 회원가입 동의용 개인정보 처리방침 안내 페이지. */
    @GetMapping("/privacy")
    public String privacyPage(Model model) {
        String content = settingsService.getSettingValue("privacy_content");
        if (content == null || content.isBlank()) {
            content = """
                    <p>개인정보 처리방침 내용이 아직 등록되지 않았습니다.</p>
                    <p>관리자 설정에서 <strong>privacy_content</strong> 값을 등록해 주세요.</p>
                    """;
        }
        model.addAttribute("privacyContent", content);
        return "common/privacy";
    }

    /** 회원가입 동의용 이용약관 안내 페이지. */
    @GetMapping("/terms")
    public String termsPage(Model model) {
        String content = settingsService.getSettingValue("terms_content");
        if (content == null || content.isBlank()) {
            content = """
                    <p>이용약관 내용이 아직 등록되지 않았습니다.</p>
                    <p>관리자 설정에서 <strong>terms_content</strong> 값을 등록해 주세요.</p>
                    """;
        }
        model.addAttribute("termsContent", content);
        return "common/terms";
    }

    @GetMapping("/db-check")
    @ResponseBody
    public String dbCheck() {
        try {
            Integer ping = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM `user`", Integer.class);
            return "DB 연결 성공 (ping=" + ping + "), user 테이블 조회 성공 (count=" + count + ")";
        } catch (Exception e) {
            Throwable root = e;
            while (root.getCause() != null) {
                root = root.getCause();
            }
            return "DB 연결 실패: " + e.getMessage()
                    + " | rootCause=" + root.getClass().getSimpleName() + ": " + root.getMessage()
                    + " | datasource=" + datasourceUrl;
        }
    }
}

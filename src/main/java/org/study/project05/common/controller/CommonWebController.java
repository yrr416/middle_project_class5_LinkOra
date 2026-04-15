/**
 * 공통 웹 화면·진단: 루트 리다이렉트, 대시보드, 챗봇, DB 연결 확인(/db-check).
 */
package org.study.project05.common.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class CommonWebController {

    private final JdbcTemplate jdbcTemplate;
    private final String datasourceUrl;

    public CommonWebController(
            JdbcTemplate jdbcTemplate,
            @Value("${spring.datasource.url:}") String datasourceUrl
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.datasourceUrl = datasourceUrl;
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
    public String privacyPage() {
        return "common/privacy";
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

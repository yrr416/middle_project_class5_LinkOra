package org.study.project05class.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 루트 경로 처리 컨트롤러
 * "/" 또는 "/project05class/" 접속 시 고객 관리 목록으로 이동
 */
@Controller
public class MainController {

    // 루트 경로 접속 시 고객 관리 페이지로 리다이렉트
    @GetMapping({"/", "/project05class", "/project05class/"})
    public String index() {
        return "redirect:/admin/customer/list";
    }
}

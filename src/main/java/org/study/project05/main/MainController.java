package org.study.project05.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 루트 경로 → 대시보드로 리다이렉트
 */
@Controller
public class MainController {

    @GetMapping({"/", ""})
    public String index() {
        return "redirect:/admin/dashboard";
    }
}

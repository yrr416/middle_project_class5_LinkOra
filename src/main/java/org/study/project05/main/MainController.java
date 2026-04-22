package org.study.project05.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// 관리자 페이지 이동과 파비콘 에러를 막아주는 컨트롤러야
@Controller
public class MainController {

    // 관리자 주소로 들어오면 관리자 대시보드로 길을 안내해 줘
    @GetMapping("/admin")
    public String admin() {
        return "redirect:/admin/dashboard";
    }

    // 브라우저가 아이콘을 달라고 떼쓸 때 빈 대답을 줘서 에러를 막아
    @GetMapping("/favicon.ico")
    @ResponseBody
    public void returnNoFavicon() {
        // 아무것도 주지 않으면 브라우저가 더 이상 찾지 않아!
    }
}
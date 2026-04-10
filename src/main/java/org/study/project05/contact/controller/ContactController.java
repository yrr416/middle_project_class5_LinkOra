package org.study.project05.contact.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.contact.service.ContactService;
import org.study.project05.contact.vo.ContactVO;
import org.study.project05.member.vo.UserProfileVO;

import java.util.Map;

@Controller
@RequestMapping("/contact")
public class ContactController {

    @Autowired
    private ContactService contactService;

    /**
     * 장기 계약 문의 등록 (AJAX POST)
     * 요청: { brnIdx, cntStartDate, cntDuration, cntHeadcount, cntContent }
     */
    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> write(ContactVO vo, HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        vo.setUserIdx(user.getUserIdx());
        try {
            contactService.writeContact(vo);
            return Map.of("success", true, "message", "문의가 접수되었습니다. 담당자가 확인 후 연락드립니다.");
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    /** 문의 목록 페이지 (관리자) */
    @GetMapping("/admin/list")
    public String adminList(Model model, HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/loginPage";
        }
        model.addAttribute("contactList", contactService.getAllContacts());
        return "contact/adminList";
    }

    /** 문의 상태 변경 (관리자, AJAX POST) */
    @PostMapping("/admin/status")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam int cntIdx,
                                            @RequestParam String status,
                                            HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return Map.of("success", false, "message", "권한이 없습니다.");
        }
        try {
            contactService.updateStatus(cntIdx, status);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }
}

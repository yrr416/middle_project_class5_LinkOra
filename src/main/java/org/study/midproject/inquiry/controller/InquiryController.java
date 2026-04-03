package org.study.midproject.inquiry.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.midproject.inquiry.service.InquiryService;
import org.study.midproject.inquiry.vo.InquiryVO;

import java.util.List;

@Controller
@RequestMapping("/inquiry")
public class InquiryController {
    
    private final InquiryService inquiryService;

    @Autowired
    public InquiryController(InquiryService inquiryService) {
        this.inquiryService = inquiryService;
    }

    // 세션에서 사용자 정보를 가져오는 메서드
    private Long getLoggedInUserIdx(HttpSession session) {
        Object loginUser = session.getAttribute("loginUser");
        Object uIdxObj = session.getAttribute("uIdx");
        
        Long uIdx = null;
        
        if (loginUser instanceof Long) {
            uIdx = (Long) loginUser;
        } else if (loginUser instanceof Integer) {
            uIdx = ((Integer) loginUser).longValue();
        }
        
        if (uIdx == null && uIdxObj != null) {
            try {
                if (uIdxObj instanceof Long) {
                    uIdx = (Long) uIdxObj;
                } else if (uIdxObj instanceof Integer) {
                    uIdx = ((Integer) uIdxObj).longValue();
                } else if (uIdxObj instanceof Number) {
                    uIdx = ((Number) uIdxObj).longValue();
                } else {
                    uIdx = Long.parseLong(String.valueOf(uIdxObj));
                }
            } catch (Exception e) {}
        }
        
        if (uIdx == null) return 1L; // 테스트용 기본값
        
        return uIdx;
    }

    // 1. 문의 작성 페이지 이동
    @GetMapping("")
    public String inquiryForm(HttpSession session, Model model) {
        Long userIdx = getLoggedInUserIdx(session);
        if (userIdx == null) {
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/login");
            return "common/alert";
        }
        return "inquiry/inquiry_form";
    }

    // 2. 문의 등록 처리
    @PostMapping("/submit")
    public String submitInquiry(HttpSession session, InquiryVO vo) {
        Long userIdx = getLoggedInUserIdx(session);
        if (userIdx == null) return "redirect:/login";

        vo.setUserIdx(userIdx); // Standardized setter (userIdx)
        inquiryService.registerInquiry(vo);
        return "redirect:/inquiry/mylist";
    }

    // 3. 나의 문의 내역 리스트 조회
    @GetMapping("/mylist")
    public String myInquiryList(HttpSession session, Model model) {
        Long userIdx = getLoggedInUserIdx(session);
        if (userIdx == null) return "redirect:/login";

        List<InquiryVO> list = inquiryService.getInquiryList(userIdx);
        model.addAttribute("inquiryList", list);
        return "inquiry/my_inquiries";
    }

    // 4. 문의 상세 정보 및 답변 확인
    @GetMapping("/detail/{idx}")
    public String inquiryDetail(@PathVariable("idx") Integer idx, HttpSession session, Model model) {
        Long userIdx = getLoggedInUserIdx(session);
        if (userIdx == null) return "redirect:/login";

        InquiryVO detail = inquiryService.getInquiryDetail(idx);
        
        // 본인 글 확인 (Standardized getter: userIdx)
        if (detail == null || !detail.getUserIdx().equals(userIdx)) {
            return "redirect:/inquiry/mylist";
        }

        model.addAttribute("inquiry", detail);
        return "inquiry/inquiry_detail";
    }
}

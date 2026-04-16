package org.study.project05.inquiry.controller;

import org.study.project05.common.util.SessionUtil;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.inquiry.service.InquiryService;
import org.study.project05.inquiry.vo.InquiryVO;

import java.util.Map;

@Controller
@RequestMapping("/inquiry")
public class InquiryController {
    
    private final InquiryService inquiryService;

    @Autowired
    public InquiryController(InquiryService inquiryService) {
        this.inquiryService = inquiryService;
    }

    // 1. 문의 작성 페이지 이동
    @GetMapping("")
    public String inquiryForm(HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            session.setAttribute("prevUrl", "/inquiry");
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }
        return "inquiry/inquiry_form";
    }

    // 2. 문의 등록 처리
    @PostMapping("/submit")
    public String submitInquiry(HttpSession session, InquiryVO vo, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            model.addAttribute("msg", "로그인 세션이 만료되었습니다. 다시 로그인해 주세요.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        vo.setUserIdx(userIdx);
        inquiryService.registerInquiry(vo);
        return "redirect:/inquiry/mylist";
    }

    @GetMapping("/mylist")
    public String myInquiryList(@RequestParam(value = "page", defaultValue = "1") int page, 
                                HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            session.setAttribute("prevUrl", "/inquiry/mylist");
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        Map<String, Object> result = inquiryService.getInquiryList(userIdx.longValue(), page);
        model.addAttribute("inquiryList", result.get("inquiryList"));
        model.addAttribute("paging", result.get("paging"));
        return "inquiry/my_inquiries";
    }

    // 4. 문의 상세 정보 및 답변 확인
    @GetMapping("/detail/{inqIdx}")
    public String inquiryDetail(@PathVariable("inqIdx") Integer inqIdx, HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            session.setAttribute("prevUrl", "/inquiry/detail/" + inqIdx);
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        InquiryVO detail = inquiryService.getInquiryDetail(inqIdx);
        
        // 본인 글 확인
        if (detail == null || detail.getUserIdx() != userIdx) {
            return "redirect:/inquiry/mylist";
        }

        model.addAttribute("inquiry", detail);
        return "inquiry/inquiry_detail";
    }

    // 5. 문의 수정 페이지 이동
    @GetMapping("/edit/{inqIdx}")
    public String editForm(@PathVariable("inqIdx") Integer inqIdx, HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            session.setAttribute("prevUrl", "/inquiry/edit/" + inqIdx);
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        InquiryVO detail = inquiryService.getInquiryDetail(inqIdx);
        if (detail == null || detail.getUserIdx() != userIdx) {
            return "redirect:/inquiry/mylist";
        }

        if ("답변 완료".equals(detail.getInqStatus())) {
            model.addAttribute("msg", "답변이 완료된 문의는 수정할 수 없습니다.");
            model.addAttribute("url", "/inquiry/detail/" + inqIdx);
            return "common/alert";
        }

        model.addAttribute("inquiry", detail);
        return "inquiry/inquiry_edit";
    }

    // 6. 문의 수정 처리
    @PostMapping("/update")
    public String updateInquiry(InquiryVO vo, HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            model.addAttribute("msg", "로그인 세션이 만료되었습니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        String result = inquiryService.updateInquiry(vo, userIdx);
        if ("success".equals(result)) {
            return "redirect:/inquiry/detail/" + vo.getInqIdx();
        } else {
            model.addAttribute("msg", result);
            model.addAttribute("url", "/inquiry/edit/" + vo.getInqIdx());
            return "common/alert";
        }
    }

    // 7. 문의 삭제 처리
    @PostMapping("/delete/{inqIdx}")
    public String deleteInquiry(@PathVariable("inqIdx") Integer inqIdx, HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);
        if (userIdx == null) {
            model.addAttribute("msg", "로그인 세션이 만료되었습니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        String result = inquiryService.deleteInquiry(inqIdx, userIdx);
        if ("success".equals(result)) {
            model.addAttribute("msg", "문의가 삭제되었습니다.");
            model.addAttribute("url", "/inquiry/mylist");
            return "common/alert";
        } else {
            model.addAttribute("msg", result);
            model.addAttribute("url", "/inquiry/detail/" + inqIdx);
            return "common/alert";
        }
    }
}

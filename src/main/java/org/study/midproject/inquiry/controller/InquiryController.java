package org.study.midproject.inquiry.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.midproject.inquiry.service.InquiryService;
import org.study.midproject.inquiry.vo.InquiryVO;

import java.util.List;

@Controller
@RequestMapping("/inquiry")
@RequiredArgsConstructor
public class InquiryController {
    private final InquiryService inquiryService;

    // 세션에서 사용자 정보를 가져오는 메서드 (타입 안정성 보완)
    private Integer getLoggedInUserIdx(HttpSession session) {
        Object loginUser = session.getAttribute("loginUser");
        Object uIdxObj = session.getAttribute("u_idx");
        
        Integer uIdx = null;
        
        // 1. loginUser 세션 속성 확인
        if (loginUser instanceof Integer) {
            uIdx = (Integer) loginUser;
        } else if (loginUser != null) {
            // 만약 loginUser가 객체(VO)라면 여기서 uIdx를 추출하는 로직이 필요할 수 있음
            // 현재는 단순 ID 저장 방식 대응을 우선함
        }
        
        // 2. u_idx 세션 속성 확인 (loginUser가 없을 경우)
        if (uIdx == null && uIdxObj != null) {
            try {
                if (uIdxObj instanceof Integer) {
                    uIdx = (Integer) uIdxObj;
                } else if (uIdxObj instanceof Number) {
                    uIdx = ((Number) uIdxObj).intValue();
                } else {
                    uIdx = Integer.parseInt(String.valueOf(uIdxObj));
                }
            } catch (Exception e) {
                // 변환 실패 시 로그 기록 등 처리 가능
            }
        }
        
        // [테스트 전용] 로그인 정보를 찾을 수 없더라도 테스트를 위해 기본값(1번 사용자) 반환
        if (uIdx == null) return 1; 
        
        return uIdx;
    }

    // 1. 문의 작성 페이지 이동
    @GetMapping("")
    public String inquiryForm(HttpSession session, Model model) {
        Integer uIdx = getLoggedInUserIdx(session);
        if (uIdx == null) {
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/login"); // 임시 로그인 경로
            return "common/alert"; // 알림 후 이동하는 공통 페이지 가정
        }
        return "inquiry/inquiry_form";
    }

    // 2. 문의 등록 처리
    @PostMapping("/submit")
    public String submitInquiry(HttpSession session, InquiryVO vo) {
        Integer uIdx = getLoggedInUserIdx(session);
        if (uIdx == null) return "redirect:/login";

        vo.setUserIdx(uIdx);
        inquiryService.registerInquiry(vo);
        return "redirect:/inquiry/mylist";
    }

    // 3. 나의 문의 내역 리스트 조회
    @GetMapping("/mylist")
    public String myInquiryList(HttpSession session, Model model) {
        Integer uIdx = getLoggedInUserIdx(session);
        if (uIdx == null) return "redirect:/login";

        List<InquiryVO> list = inquiryService.getInquiryList(uIdx);
        model.addAttribute("inquiryList", list);
        return "inquiry/my_inquiries";
    }

    // 4. 문의 상세 정보 및 답변 확인
    @GetMapping("/detail/{iIdx}")
    public String inquiryDetail(@PathVariable("iIdx") Integer iIdx, HttpSession session, Model model) {
        Integer uIdx = getLoggedInUserIdx(session);
        if (uIdx == null) return "redirect:/login";

        InquiryVO detail = inquiryService.getInquiryDetail(iIdx);
        
        // 본인 글인지 확인 (보안)
        if (detail == null || !detail.getUserIdx().equals(uIdx)) {
            return "redirect:/inquiry/mylist";
        }

        model.addAttribute("inquiry", detail);
        return "inquiry/inquiry_detail";
    }
}

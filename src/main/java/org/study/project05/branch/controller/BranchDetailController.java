package org.study.project05.branch.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.study.project05.common.util.BizHoursUtil;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.study.project05.branch.service.SpaceBranchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.reservation.user.mapper.UserReservationMapper;

// ... 상단 import 생략 ...

@Controller
public class BranchDetailController {

    @Value("${kakao.map.key}")
    private String kakaoMapKey;

    @Autowired private SpaceBranchService branchService;
    @Autowired private UserReservationMapper reservationMapper;
    @Autowired private UserProfileService userProfileService;

    // 1. 목록 페이지
    @GetMapping("/detail/list")
    public String list(Model model) {
        model.addAttribute("branchList", branchService.getAllBranches());
        return "detail/list";
    }

    // 2. 상세 페이지 (다중 매핑 유지)
    @GetMapping({"/detail/detail", "/branch/detail"})
    public String detail(@RequestParam("brnIdx") int brnIdx, Model model,
                         HttpSession session, Authentication authentication) {

        BranchVO branch = branchService.getBranchWithSpaces(brnIdx);
        if (branch == null) {
            return "redirect:/error/404"; // 지점 정보가 없을 때의 방어 로직
        }

        model.addAttribute("branch", branch);
        model.addAttribute("kakaoMapKey", kakaoMapKey);
        model.addAttribute("bizStatus", BizHoursUtil.getBizStatus(branch.getBrnHours()));

        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");

        if (loginUser == null && authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            loginUser = userProfileService.getByUserId(authentication.getName());
            if (loginUser != null) {
                loginUser.setPassword(null);
                session.setAttribute("loginUser", loginUser);
            }
        }

        boolean hasReservation = loginUser != null &&
                reservationMapper.countByUserAndBranch(loginUser.getUserIdx(), brnIdx) > 0;
        model.addAttribute("hasReservation", hasReservation);

        boolean isAdmin = authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)
                && authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        model.addAttribute("isAdmin", isAdmin);

        return "detail/detail"; // WEB-INF/views/detail/detail.jsp를 호출
    }
}
package org.study.project05.branch.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.study.project05.branch.service.SpaceBranchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.reservation.user.service.UserReservationService;

@Controller
@RequestMapping("/detail")
public class SpaceController {

    @Value("${kakao.map.key}")
    private String kakaoMapKey;

    @Autowired private SpaceBranchService branchService;
    @Autowired private UserReservationService reservationService;
    @Autowired private UserProfileService userProfileService;

    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("branchList", branchService.getAllBranches());
        return "detail/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam int brnIdx, Model model,
                         HttpSession session, Authentication authentication) {
        BranchVO branch = branchService.getBranchWithSpaces(brnIdx);
        model.addAttribute("branch", branch);
        model.addAttribute("kakaoMapKey", kakaoMapKey);

        // 세션에서 UserProfileVO 꺼냄 (SessionSyncInterceptor에서 자동 관리됨)
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");

        boolean hasReservation = loginUser != null &&
                reservationService.countByUserAndBranch(loginUser.getUserIdx(), brnIdx) > 0;
        model.addAttribute("hasReservation", hasReservation);

        return "detail/detail";
    }
}

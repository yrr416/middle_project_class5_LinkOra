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
import org.study.project05.reservation.user.mapper.UserReservationMapper;

@Controller
@RequestMapping("/detail")
public class SpaceController {

    @Value("${kakao.map.key}")
    private String kakaoMapKey;

    @Autowired private SpaceBranchService branchService;
    @Autowired private UserReservationMapper reservationMapper;
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

        // 세션에서 UserProfileVO 꺼냄 (팀원 Spring Security 로그인 시 저장됨)
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");

        // 세션에 없으면 authentication(u_id)으로 DB 조회 후 세션에 저장
        if (loginUser == null
                && authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            loginUser = userProfileService.getByUserId(authentication.getName());
            if (loginUser != null) {
                loginUser.setPassword(null); // 세션에 비밀번호 저장 방지
                session.setAttribute("loginUser", loginUser);
            }
        }

        boolean hasReservation = loginUser != null &&
                reservationMapper.countByUserAndBranch(loginUser.getUserIdx(), brnIdx) > 0;
        model.addAttribute("hasReservation", hasReservation);

        return "detail/detail";
    }
}

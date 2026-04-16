package org.study.project05.branch.controller;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.service.WishService;
import org.study.project05.branch.vo.WishVO;
import org.study.project05.common.util.SessionUtil;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
// JSP 뷰 반환을 위해 ModelAndView 임포트 추가
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wishlist")
public class WishController {

    @Autowired
    private WishService wishService;

    // 관심 목록 화면으로 이동하는 기능
    @GetMapping("/view")
    public ModelAndView viewWishlist(HttpSession session) {
        ModelAndView mav = new ModelAndView();
        // 세션에서 로그인한 사용자 번호 가져오기
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인 안 되어 있을 때 처리
        if (userIdx == null) {
            // 화면에 띄울 메시지 내용
            mav.addObject("msg", "로그인이 필요한 서비스입니다.");
            // 알림창 확인 후 이동할 로그인 페이지 주소
            mav.addObject("url", "/login");
            // 메시지를 띄워주는 공용 알림 화면으로 이동
            mav.setViewName("common/alert");
            return mav;
        }

        try {
            // 해당 사용자가 찜한 지점 목록 조회
            List<BranchVO> myFavorites = wishService.getMyFavoriteBranches(userIdx);
            // 조회한 데이터를 JSP에 전달
            mav.addObject("wishList", myFavorites);
            // 보여줄 JSP 파일 위치 설정
            mav.setViewName("branch/wishlist");
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 발생 시 메인으로 이동
            mav.setViewName("redirect:/");
        }
        return mav;
    }

    // 찜하기 버튼을 눌렀을 때 실행되는 기능
    @PostMapping("/toggle")
    public Map<String, Object> toggleWish(@RequestBody WishVO wishVO, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 공통 도구를 사용하여 사용자 번호 확인
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인 필수 확인
        if (userIdx == null) {
            response.put("status", "login_required");
            return response;
        }

        try {
            wishVO.setUserIdx(userIdx);
            // 찜 추가 또는 해제 처리
            boolean isAdded = wishService.toggleWish(wishVO);

            response.put("status", "success");
            response.put("isAdded", isAdded);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
        }
        return response;
    }

    // 찜한 지점들의 목록 데이터만 가져오는 기능
    @GetMapping("/my")
    public Object getMyFavoriteBranches(HttpSession session) {
        // 안전하게 로그인 사용자 번호 확인
        Integer userIdx = SessionUtil.getUserIdx(session);

        if (userIdx == null) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "login_required");
            return response;
        }

        try {
            // 서비스에서 찜 목록 데이터 조회 후 반환
            List<BranchVO> myFavorites = wishService.getMyFavoriteBranches(userIdx);
            return myFavorites;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            return response;
        }
    }
}
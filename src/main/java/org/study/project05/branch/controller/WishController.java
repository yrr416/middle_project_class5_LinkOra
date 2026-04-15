package org.study.project05.branch.controller;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.service.WishService;
import org.study.project05.branch.vo.WishVO;
// [추가] 세션 정보를 정확하게 꺼내주는 공통 도구를 가져옴
import org.study.project05.common.util.SessionUtil;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wishlist")
public class WishController {

    @Autowired
    private WishService wishService;

    // ==========================================
    // 1. 찜하기 토글 (추가/삭제) API
    // ==========================================
    @PostMapping("/toggle")
    public Map<String, Object> toggleWish(@RequestBody WishVO wishVO, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // [수정] u_idx 대신 공통 도구인 SessionUtil을 사용하여 정확한 로그인 번호를 가져옴
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인이 안 되어 있으면 "login_required" 상태를 보냄
        if (userIdx == null) {
            response.put("status", "login_required");
            return response;
        }

        try {
            wishVO.setUserIdx(userIdx);
            boolean isAdded = wishService.toggleWish(wishVO);

            response.put("status", "success");
            response.put("isAdded", isAdded);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
        }
        return response;
    }

    // ==========================================
    // 2. 내 관심 지점 목록 가져오기 API
    // ==========================================
    @GetMapping("/my")
    public Object getMyFavoriteBranches(HttpSession session) {
        // [수정] 여기도 마찬가지로 SessionUtil을 사용하여 안전하게 로그인 번호를 확인함
        Integer userIdx = SessionUtil.getUserIdx(session);

        if (userIdx == null) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "login_required");
            return response;
        }

        try {
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
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
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 이 파일은 찜하기(관심지점)와 관련된 요청을 처리하는 곳이에요
@RestController
@RequestMapping("/api/wishlist") // 기본 주소 설정 (이 컨트롤러의 모든 주소는 /api/wishlist로 시작해요)
public class WishController {

    @Autowired
    private WishService wishService; // 데이터베이스에서 찜 목록을 가져다줄 서비스 도구 연결

    // 1. 찜 목록 화면으로 이동하는 기능 (/api/wishlist/view)
    // 햄버거 메뉴에서 '관심지점'을 누르면 이 코드가 실행돼서 화면을 보여줘요
    @GetMapping("/view")
    public ModelAndView viewWishlist(HttpSession session) {
        ModelAndView mav = new ModelAndView(); // 보여줄 화면과 데이터를 담을 바구니 준비

        // 로그인한 사람의 번호를 안전하게 가져와요
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 만약 로그인을 안 했다면? 경고창 띄우고 로그인 페이지로 보내요
        if (userIdx == null) {
            mav.addObject("msg", "로그인이 필요한 서비스입니다.");
            mav.addObject("url", "/loginPage");
            mav.setViewName("common/alert"); // 경고창 화면으로 이동
            return mav;
        }

        try {
            // 로그인한 사람의 찜 목록을 데이터베이스에서 가져와요
            List<BranchVO> myFavorites = wishService.getMyFavoriteBranches(userIdx);
            mav.addObject("wishList", myFavorites); // 가져온 목록을 바구니에 담기
            mav.setViewName("branch/wishlist"); // 찜 목록 화면(jsp)으로 이동
        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/"); // 에러가 나면 메인 화면으로 돌려보내요
        }
        return mav; // 완성된 바구니(화면+데이터)를 전달!
    }

    // 2. 찜하기 버튼을 눌렀을 때 (추가하거나 삭제하는 기능)
    @PostMapping("/toggle")
    public Map<String, Object> toggleWish(@RequestBody WishVO wishVO, HttpSession session) {
        Map<String, Object> response = new HashMap<>(); // 결과를 담아서 보낼 상자 준비

        // 로그인한 사람의 번호를 가져와요
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인이 안 되어 있으면 "로그인이 필요해!"라고 알려줘요
        if (userIdx == null) {
            response.put("status", "login_required");
            return response;
        }

        try {
            wishVO.setUserIdx(userIdx); // 누구의 찜인지 번호를 입력해줌
            boolean isAdded = wishService.toggleWish(wishVO); // 찜 추가/삭제 실행

            response.put("status", "success"); // 성공했다고 표시
            response.put("isAdded", isAdded);  // 찜이 추가됐는지 삭제됐는지 결과 담기
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error"); // 에러 났다고 표시
        }
        return response; // 결과를 담은 상자를 보내줘요
    }

    // 3. 내 관심 지점 목록 데이터를 주는 기능 (화면 없이 데이터만 줄 때 사용)
    @GetMapping("/my")
    public Object getMyFavoriteBranches(HttpSession session) {
        // 로그인한 사람의 번호를 가져와요
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인 안 했으면 에러 메시지를 보내요
        if (userIdx == null) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "login_required");
            return response;
        }

        try {
            // 찜 목록 데이터를 가져와서 그대로 전달해줘요
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
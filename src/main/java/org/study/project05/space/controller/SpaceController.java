package org.study.project05.space.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.study.project05.space.service.SpaceService;
import org.study.project05.space.vo.SpaceVO;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.List;
import java.util.UUID;

/**
 * 오피스(공간) 관리 컨트롤러
 * /admin/space/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/space")
public class SpaceController {

    @Autowired
    private SpaceService spaceService;

    private static final int NUM_PER_PAGE   = 9;  // 카드 3열 × 3행
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 공간 목록 페이지 (카드형) + 파트너 신청 목록
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       SpaceVO spaceVO,
                       Model model) {

        // 활성/비활성 공간만 (s_active = 1 or 2)
        int totalRecord = spaceService.getSpaceCount(spaceVO);

        int totalPage = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);
        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<SpaceVO> spaceList = spaceService.getSpaceList(NUM_PER_PAGE, offset, spaceVO);

        // 파트너 신청 대기 목록 (s_active = 0)
        List<SpaceVO> pendingList = spaceService.getPendingSpaceList();

        model.addAttribute("spaceList",   spaceList);
        model.addAttribute("pendingList", pendingList);
        model.addAttribute("totalRecord", totalRecord);
        model.addAttribute("totalPage",   totalPage);
        model.addAttribute("nowPage",     nowPage);
        model.addAttribute("beginBlock",  beginBlock);
        model.addAttribute("endBlock",    endBlock);
        model.addAttribute("spaceVO",     spaceVO);

        return "space/list";
    }

    /**
     * 공간 등록 폼 (GET)
     */
    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("branchList", spaceService.getBranchList());
        model.addAttribute("mode", "register");
        return "space/form";
    }

    /**
     * 공간 등록 처리 (POST)
     */
    @PostMapping("/registerok")
    public String registerOk(SpaceVO spaceVO,
                             @RequestParam(value = "imgFile", required = false) MultipartFile imgFile,
                             HttpServletRequest request) {
        if (imgFile != null && !imgFile.isEmpty()) {
            String savedPath = saveImage(imgFile, request);
            if (savedPath != null) spaceVO.setSpcImg(savedPath);
        }
        // 관리자 직접 등록은 바로 활성(1)
        spaceVO.setSpcActive("1");
        int result = spaceService.insertSpace(spaceVO);
        return result > 0 ? "redirect:/admin/space/list"
                          : "redirect:/admin/space/register?error=fail";
    }

    /**
     * 공간 수정 폼 (GET)
     */
    @GetMapping("/update")
    public String updateForm(@RequestParam("spcIdx") String spcIdx,
                             @RequestParam(defaultValue = "1") int nowPage,
                             Model model) {
        SpaceVO svo = spaceService.getSpaceDetail(spcIdx);
        if (svo == null) return "redirect:/admin/space/list";

        model.addAttribute("svo",        svo);
        model.addAttribute("branchList", spaceService.getBranchList());
        model.addAttribute("nowPage",    nowPage);
        model.addAttribute("mode",       "update");
        return "space/form";
    }

    /**
     * 공간 수정 처리 (POST)
     */
    @PostMapping("/updateok")
    public String updateOk(@RequestParam(defaultValue = "1") int nowPage,
                           SpaceVO spaceVO,
                           @RequestParam(value = "imgFile", required = false) MultipartFile imgFile,
                           HttpServletRequest request) {
        if (imgFile != null && !imgFile.isEmpty()) {
            String savedPath = saveImage(imgFile, request);
            if (savedPath != null) spaceVO.setSpcImg(savedPath);
        }
        int result = spaceService.updateSpace(spaceVO);
        return result > 0
                ? "redirect:/admin/space/list?nowPage=" + nowPage
                : "redirect:/admin/space/update?spcIdx=" + spaceVO.getSpcIdx() + "&nowPage=" + nowPage + "&error=fail";
    }

    /**
     * 활성/비활성 토글 (POST)
     * sActive: 1(활성) ↔ 2(비활성)
     */
    @PostMapping("/toggle")
    public String toggle(@RequestParam(defaultValue = "1") int nowPage,
                         SpaceVO spaceVO) {
        spaceService.toggleSpaceActive(spaceVO);
        return "redirect:/admin/space/list?nowPage=" + nowPage
                + "&typeFilter=" + (spaceVO.getTypeFilter() != null ? spaceVO.getTypeFilter() : "")
                + "&activeFilter=" + (spaceVO.getActiveFilter() != null ? spaceVO.getActiveFilter() : "");
    }

    /**
     * 파트너 매물 수락 (POST) → s_active = 1
     */
    @PostMapping("/approve")
    public String approve(@RequestParam("spcIdx") String spcIdx) {
        spaceService.approveSpace(spcIdx);
        log.info("파트너 매물 수락 - spcIdx: {}", spcIdx);
        return "redirect:/admin/space/list";
    }

    /**
     * 파트너 매물 거부 (POST) → DELETE
     */
    @PostMapping("/reject")
    public String reject(@RequestParam("spcIdx") String spcIdx) {
        spaceService.rejectSpace(spcIdx);
        log.info("파트너 매물 거부(삭제) - spcIdx: {}", spcIdx);
        return "redirect:/admin/space/list";
    }

    /**
     * 공간 삭제 (수정 페이지 하단 삭제 버튼)
     */
    @PostMapping("/delete")
    public String delete(@RequestParam("spcIdx") String spcIdx) {
        spaceService.deleteSpace(spcIdx);
        log.info("공간 삭제 - spcIdx: {}", spcIdx);
        return "redirect:/admin/space/list";
    }

    /**
     * 이미지 파일 저장 유틸리티
     * 저장 경로: {webapp}/static/img/spaces/
     */
    private String saveImage(MultipartFile file, HttpServletRequest request) {
        try {
            String uploadDir = request.getServletContext().getRealPath("/") + "static" + File.separator + "upload" + File.separator + "space";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String origName = file.getOriginalFilename();
            String ext      = origName != null && origName.contains(".")
                    ? origName.substring(origName.lastIndexOf("."))
                    : ".jpg";
            String fileName = UUID.randomUUID().toString().replace("-", "") + ext;

            file.transferTo(new File(dir, fileName));
            return "/static/upload/space/" + fileName;
        } catch (Exception e) {
            log.error("이미지 저장 실패: {}", e.getMessage());
            return null;
        }
    }
}

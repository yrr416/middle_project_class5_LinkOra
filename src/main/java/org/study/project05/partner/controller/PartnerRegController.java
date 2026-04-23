package org.study.project05.partner.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.partner.service.PartnerRegService;
import org.study.project05.partner.vo.BranchRegVO;
import org.study.project05.partner.vo.SpaceRegVO;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

// 파트너 오피스 등록 5단계 위자드 컨트롤러
@Controller
@RequestMapping("/partner/register")
@SessionAttributes({"branchVO", "spaceList"})
@RequiredArgsConstructor
public class PartnerRegController {

    private final PartnerRegService partnerRegService;
    private final ObjectMapper objectMapper;

    @Value("${kakao.client-id}")
    private String kakaoRestApiKey;

    /* 주소 → 위도/경도 변환 (Kakao Local REST API) */
    @GetMapping("/geocode")
    @ResponseBody
    public Map<String, Object> geocode(@RequestParam String address) {
        Map<String, Object> result = new HashMap<>();
        result.put("lat", 0.0);
        result.put("lng", 0.0);
        try {
            String url = "https://dapi.kakao.com/v2/local/search/address.json?query={query}";
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + kakaoRestApiKey);
            ResponseEntity<Map> response = new RestTemplate()
                    .exchange(url, HttpMethod.GET, new HttpEntity<>(headers), Map.class, address);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                List<Map<String, Object>> documents =
                        (List<Map<String, Object>>) response.getBody().get("documents");
                if (documents != null && !documents.isEmpty()) {
                    result.put("lat", Double.parseDouble(documents.get(0).get("y").toString()));
                    result.put("lng", Double.parseDouble(documents.get(0).get("x").toString()));
                } else {
                    result.put("error", "검색결과 없음");
                }
            }
        } catch (Exception e) {
            result.put("error", e.getMessage());
        }
        return result;
    }

    /* ──────────────────────────────────────────────
       Step1 : 기본 정보 입력
    ────────────────────────────────────────────── */
    @GetMapping("/step1")
    public String step1Get(Model model) {
        // 세션에 없으면 새 VO 세팅
        if (!model.containsAttribute("branchVO")) {
            model.addAttribute("branchVO", new BranchRegVO());
        }
        return "partner/step1";
    }

    /**
     * 내 매물 관리 → 공간 추가: 기존 지점을 세션에 주입 후 step3으로 이동
     * @SessionAttributes 컨트롤러에서 model.addAttribute하면 자동으로 세션에 저장됨
     */
    @GetMapping("/initForBranch")
    public String initForBranch(@RequestParam int brnIdx, Model model) {
        BranchRegVO branch = partnerRegService.getBranchById(brnIdx);
        if (branch == null) {
            return "redirect:/partner/manage";
        }
        model.addAttribute("branchVO", branch);
        return "redirect:/partner/register/step3";
    }

    /**
     * 내 매물 관리 → 사진 관리: 해당 지점을 세션에 주입 후 step4로 이동
     */
    @GetMapping("/initForBranchPhoto")
    public String initForBranchPhoto(@RequestParam int brnIdx, Model model) {
        BranchRegVO branch = partnerRegService.getBranchById(brnIdx);
        if (branch == null) {
            return "redirect:/partner/manage";
        }
        model.addAttribute("branchVO", branch);
        return "redirect:/partner/register/step4";
    }

    @PostMapping("/step1")
    public String step1Post(@ModelAttribute("branchVO") BranchRegVO branchVO,
                            @RequestParam String brnName,
                            @RequestParam String brnDescription,
                            @RequestParam String roadAddress,
                            @RequestParam String detailAddress,
                            @RequestParam String brnPhone,
                            @RequestParam(required = false, defaultValue = "") String brnSns) {
        // 폼 값 세팅
        branchVO.setPtnIdx(1); // 임시 고정 파트너 (실제 서비스에서는 세션 로그인 파트너 ptnIdx 사용)
        branchVO.setBrnName(brnName);
        branchVO.setBrnDescription(brnDescription);
        branchVO.setRoadAddress(roadAddress);
        branchVO.setDetailAddress(detailAddress);
        branchVO.setBrnAddress(roadAddress + " " + detailAddress);
        branchVO.setBrnPhone(brnPhone);
        branchVO.setBrnSns(brnSns);

        // DB 저장 (useGeneratedKeys 로 bIdx 자동 세팅)
        partnerRegService.saveBranchBasic(branchVO);

        return "redirect:/partner/register/step2";
    }

    /* ──────────────────────────────────────────────
       Step2 : 운영 정보 입력
    ────────────────────────────────────────────── */
    @GetMapping("/step2")
    public String step2Get(@ModelAttribute("branchVO") BranchRegVO branchVO) {
        return "partner/step2";
    }

    @PostMapping("/step2")
    public String step2Post(@ModelAttribute("branchVO") BranchRegVO branchVO,
                            @RequestParam String operDays,
                            @RequestParam String operStart,
                            @RequestParam String operEnd,
                            @RequestParam(required = false, defaultValue = "0") int holidayOp,
                            @RequestParam String minUnit,
                            @RequestParam int maxDays) {
        branchVO.setOperDays(operDays);
        branchVO.setOperStart(operStart);
        branchVO.setOperEnd(operEnd);
        branchVO.setHolidayOp(holidayOp);
        branchVO.setMinUnit(minUnit);
        branchVO.setMaxDays(maxDays);

        // 운영시간 문자열 조합
        branchVO.setBrnHours(operDays + " " + operStart + "~" + operEnd);

        partnerRegService.saveBranchOper(branchVO);

        return "redirect:/partner/register/step3";
    }

    /* ──────────────────────────────────────────────
       Step3 : 공간(룸) 등록
    ────────────────────────────────────────────── */
    @GetMapping("/step3")
    public String step3Get(@ModelAttribute("branchVO") BranchRegVO branchVO, Model model) {
        if (!model.containsAttribute("spaceList")) {
            model.addAttribute("spaceList", new ArrayList<SpaceRegVO>());
        }
        return "partner/step3";
    }

    @PostMapping("/step3")
    public String step3Post(@ModelAttribute("branchVO") BranchRegVO branchVO,
                            @RequestParam String spacesJson) throws Exception {
        // JSON 으로 전달된 공간 목록 파싱
        List<SpaceRegVO> spaceList = objectMapper.readValue(spacesJson,
                new TypeReference<List<SpaceRegVO>>() {});

        partnerRegService.saveSpaces(spaceList, branchVO.getBrnIdx());

        return "redirect:/partner/register/step4";
    }

    /* ──────────────────────────────────────────────
       Step4 : 사진 업로드
    ────────────────────────────────────────────── */
    @GetMapping("/step4")
    public String step4Get(@ModelAttribute("branchVO") BranchRegVO branchVO, Model model) {
        // 등록된 공간 목록 조회
        List<SpaceRegVO> spaceList = partnerRegService.getSpacesByBranchId(branchVO.getBrnIdx());
        model.addAttribute("spaceList", spaceList);
        return "partner/step4";
    }

    @PostMapping("/step4")
    public String step4Post(@ModelAttribute("branchVO") BranchRegVO branchVO,
                            @RequestParam String branchImgsJson,
                            @RequestParam String spaceImgsJson) throws Exception {
        List<Map<String, Object>> branchImgs = objectMapper.readValue(branchImgsJson,
                new TypeReference<List<Map<String, Object>>>() {});
        List<Map<String, Object>> spaceImgs = objectMapper.readValue(spaceImgsJson,
                new TypeReference<List<Map<String, Object>>>() {});

        partnerRegService.saveImages(branchVO.getBrnIdx(), branchImgs, spaceImgs);

        return "redirect:/partner/register/step5";
    }

    /* ──────────────────────────────────────────────
       Step5 : 최종 검토 및 제출
    ────────────────────────────────────────────── */
    @GetMapping("/step5")
    public String step5Get(@ModelAttribute("branchVO") BranchRegVO branchVO, Model model) {
        BranchRegVO branch = partnerRegService.getBranchById(branchVO.getBrnIdx());
        List<SpaceRegVO> spaceList = partnerRegService.getSpacesByBranchId(branchVO.getBrnIdx());
        model.addAttribute("branch", branch);
        model.addAttribute("spaceList", spaceList);
        return "partner/step5";
    }

    @PostMapping("/submit")
    public String submit(@ModelAttribute("branchVO") BranchRegVO branchVO,
                         SessionStatus sessionStatus,
                         RedirectAttributes ra) {
        partnerRegService.submitRegistration(branchVO.getBrnIdx());
        sessionStatus.setComplete(); // 세션 정리
        ra.addFlashAttribute("msg", "오피스 등록 신청이 완료되었습니다. 관리자 승인 후 게시됩니다.");
        return "redirect:/partner/register/complete";
    }

    /* ──────────────────────────────────────────────
       이미지 업로드 (Step4 AJAX)
    ────────────────────────────────────────────── */
    @PostMapping("/uploadImg")
    @ResponseBody
    public String uploadImg(@RequestParam MultipartFile file, HttpServletRequest request) {
        try {
            String uploadDir = request.getServletContext().getRealPath("/")
                    + "static" + File.separator + "upload" + File.separator + "partner";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String origName = file.getOriginalFilename();
            String ext = (origName != null && origName.contains("."))
                    ? origName.substring(origName.lastIndexOf(".")) : ".jpg";
            String fileName = UUID.randomUUID().toString().replace("-", "") + ext;

            file.transferTo(new File(dir, fileName));
            return "/static/upload/partner/" + fileName;
        } catch (Exception e) {
            return "";
        }
    }

    /* ──────────────────────────────────────────────
       완료 페이지
    ────────────────────────────────────────────── */
    @GetMapping("/complete")
    public String complete() {
        return "partner/complete";
    }
}

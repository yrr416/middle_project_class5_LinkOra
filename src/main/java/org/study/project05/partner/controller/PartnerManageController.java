package org.study.project05.partner.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.partner.service.PartnerRegService;
import org.study.project05.partner.vo.BranchRegVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/partner/manage")
@RequiredArgsConstructor
public class PartnerManageController {

    private final PartnerRegService partnerRegService;

    private int getPartnerIdx(HttpSession session) {
        Object val = session.getAttribute("partnerIdx");
        return (val instanceof Number) ? ((Number) val).intValue() : 0;
    }

    /** GET /partner/manage - 내 매물 목록 */
    @GetMapping
    public String myProperty(HttpSession session, Model model) {
        int partnerIdx = getPartnerIdx(session);
        List<BranchRegVO> branches = partnerRegService.getMyBranches(partnerIdx);
        model.addAttribute("branches", branches);
        return "partner/myProperty";
    }

    /** POST /partner/manage/toggleBranch - 지점 활성/비활성 토글 */
    @PostMapping("/toggleBranch")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBranch(
            @RequestParam int brnIdx,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        boolean ok = partnerRegService.toggleBranchActive(brnIdx, partnerIdx);
        Map<String, Object> body = new HashMap<>();
        body.put("success", ok);
        body.put("message", ok ? "상태가 변경되었습니다." : "변경 권한이 없거나 심사중인 매물입니다.");
        return ok ? ResponseEntity.ok(body)
                  : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    /** POST /partner/manage/toggleSpace - 공간 활성/비활성 토글 */
    @PostMapping("/toggleSpace")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleSpace(
            @RequestParam int spcIdx,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        boolean ok = partnerRegService.toggleSpaceActive(spcIdx, partnerIdx);
        Map<String, Object> body = new HashMap<>();
        body.put("success", ok);
        body.put("message", ok ? "공간 상태가 변경되었습니다." : "변경 권한이 없거나 심사중인 공간입니다.");
        return ok ? ResponseEntity.ok(body)
                  : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }
}

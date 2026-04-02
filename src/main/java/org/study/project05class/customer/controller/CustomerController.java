package org.study.project05class.customer.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05class.customer.service.CustomerService;
import org.study.project05class.customer.vo.CustomerVO;

import java.util.List;

/**
 * 고객(회원) 관리 컨트롤러
 * /admin/customer/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    // 한 페이지에 표시할 회원 수
    private static final int NUM_PER_PAGE  = 10;
    // 페이지 블록당 표시할 페이지 수
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 회원 목록 페이지
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       CustomerVO customerVO,
                       Model model) {

        // 1. 검색 조건에 맞는 전체 회원 수
        int totalRecord = customerService.getCustomerCount(customerVO);

        // 2. 전체 페이지 수
        int totalPage = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        // 3. 현재 페이지 범위 보정
        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        // 4. DB 조회 시작 위치(offset) 계산
        int offset = (nowPage - 1) * NUM_PER_PAGE;

        // 5. 페이지 블록 계산
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = beginBlock + PAGE_PER_BLOCK - 1;
        if (endBlock > totalPage) endBlock = totalPage;

        // 6. 회원 목록 조회
        List<CustomerVO> customerList = customerService.getCustomerList(NUM_PER_PAGE, offset, customerVO);

        model.addAttribute("customerList",  customerList);
        model.addAttribute("totalRecord",   totalRecord);
        model.addAttribute("totalPage",     totalPage);
        model.addAttribute("nowPage",       nowPage);
        model.addAttribute("beginBlock",    beginBlock);
        model.addAttribute("endBlock",      endBlock);
        model.addAttribute("customerVO",    customerVO); // 검색 조건 유지

        return "customer/list";
    }

    /**
     * 회원 상세 페이지
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("u_idx") String u_idx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         Model model) {

        CustomerVO cvo = customerService.getCustomerDetail(u_idx);
        if (cvo == null) return "redirect:/admin/customer/list";

        model.addAttribute("cvo",     cvo);
        model.addAttribute("nowPage", nowPage);
        return "customer/detail";
    }

    /**
     * 회원 등록 폼 (GET)
     */
    @GetMapping("/register")
    public String registerForm() {
        return "customer/register";
    }

    /**
     * 회원 등록 처리 (POST)
     */
    @PostMapping("/registerok")
    public String registerOk(CustomerVO customerVO) {

        // 이메일 중복 확인
        if (customerService.checkDuplicateEmail(customerVO.getU_email()) > 0) {
            return "redirect:/admin/customer/register?error=duplicateEmail";
        }

        // 기본 역할 설정
        customerVO.setU_role("user");
        // 신규 등록 시 u_active=0 (정상 상태, 0이 정상 / 1이 숨김)
        customerVO.setU_active("0");

        int result = customerService.insertCustomer(customerVO);
        return result > 0 ? "redirect:/admin/customer/list"
                          : "redirect:/admin/customer/register?error=fail";
    }

    /**
     * 회원 정보 수정 폼 (GET)
     */
    @GetMapping("/update")
    public String updateForm(@RequestParam("u_idx") String u_idx,
                             @RequestParam(defaultValue = "1") int nowPage,
                             Model model) {

        CustomerVO cvo = customerService.getCustomerDetail(u_idx);
        if (cvo == null) return "redirect:/admin/customer/list";

        model.addAttribute("cvo",     cvo);
        model.addAttribute("nowPage", nowPage);
        return "customer/update";
    }

    /**
     * 회원 정보 수정 처리 (POST)
     */
    @PostMapping("/updateok")
    public String updateOk(@RequestParam(defaultValue = "1") int nowPage,
                           CustomerVO customerVO) {

        int result = customerService.updateCustomer(customerVO);
        if (result > 0) {
            return "redirect:/admin/customer/detail?u_idx=" + customerVO.getU_idx() + "&nowPage=" + nowPage;
        }
        return "redirect:/admin/customer/update?u_idx=" + customerVO.getU_idx() + "&nowPage=" + nowPage + "&error=fail";
    }

    /**
     * 회원 활성여부 변경 (POST)
     * u_active: "1" → 정상, "0" → 비활성
     */
    @PostMapping("/statusChange")
    public String statusChange(@RequestParam(defaultValue = "1") int nowPage,
                               CustomerVO customerVO) {

        int result = customerService.updateCustomerStatus(customerVO);
        log.info("회원 상태 변경 - u_idx: {}, u_active: {}, 결과: {}",
                customerVO.getU_idx(), customerVO.getU_active(), result);

        return "redirect:/admin/customer/detail?u_idx=" + customerVO.getU_idx() + "&nowPage=" + nowPage;
    }

    /**
     * 회원 역할 수정 처리 (메모 대체 - POST)
     */
    @PostMapping("/memoUpdate")
    public String memoUpdate(@RequestParam(defaultValue = "1") int nowPage,
                             CustomerVO customerVO) {

        int result = customerService.updateCustomerMemo(customerVO);
        return "redirect:/admin/customer/detail?u_idx=" + customerVO.getU_idx() + "&nowPage=" + nowPage;
    }

    /**
     * 회원 숨김 처리 (POST) - 실제 삭제 대신 u_active=1 로 변경하여 데이터 보존
     */
    @PostMapping("/delete")
    public String delete(@RequestParam("u_idx") String u_idx,
                         @RequestParam(defaultValue = "1") int nowPage) {

        // deleteCustomer 는 실제 DELETE 가 아닌 u_active=1 UPDATE 로 동작
        int result = customerService.deleteCustomer(u_idx);
        log.info("회원 숨김 처리 - u_idx: {}, 결과: {}", u_idx, result);
        return "redirect:/admin/customer/list?nowPage=" + nowPage;
    }

    /**
     * 이메일 중복 확인 (AJAX)
     */
    @GetMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam("u_id") String u_id) {
        return customerService.checkDuplicateId(u_id) > 0 ? "1" : "0";
    }

    /**
     * 이메일 중복 확인 (AJAX)
     */
    @GetMapping("/checkEmail")
    @ResponseBody
    public String checkEmail(@RequestParam("u_email") String u_email) {
        return customerService.checkDuplicateEmail(u_email) > 0 ? "1" : "0";
    }
}

package org.study.project05.customer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.customer.service.CustomerService;
import org.study.project05.customer.vo.CustomerVO;

import java.util.List;

/**
 * 관리자 고객 관리 컨트롤러
 * 경로: /admin/customer/**
 */
@Controller
@RequestMapping("/admin/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    private static final int NUM_PER_PAGE = 10;
    private static final int BLOCK_SIZE   = 5;

    /* 고객 목록 */
    @GetMapping("/list")
    public String list(CustomerVO customerVO,
                       @RequestParam(defaultValue = "1") int nowPage,
                       Model model) {

        int totalRecord = customerService.getCustomerCount(customerVO);
        int totalPage   = Math.max(1, (int) Math.ceil((double) totalRecord / NUM_PER_PAGE));
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = ((nowPage - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
        int endBlock   = Math.min(beginBlock + BLOCK_SIZE - 1, totalPage);

        List<CustomerVO> customerList = customerService.getCustomerList(NUM_PER_PAGE, offset, customerVO);

        model.addAttribute("customerList",    customerList);
        model.addAttribute("customerVO",      customerVO);
        model.addAttribute("totalRecord",     totalRecord);
        model.addAttribute("totalPage",       totalPage);
        model.addAttribute("nowPage",         nowPage);
        model.addAttribute("beginBlock",      beginBlock);
        model.addAttribute("endBlock",        endBlock);
        model.addAttribute("totalUserCnt",    customerService.getTotalUserCount());
        model.addAttribute("totalPartnerCnt", customerService.getTotalPartnerCount());
        return "customer/list";
    }

    /* 고객 상세 */
    @GetMapping("/detail")
    public String detail(@RequestParam String userIdx,
                         @RequestParam(defaultValue = "") String memberType,
                         @RequestParam(defaultValue = "1") int nowPage,
                         Model model) {
        CustomerVO cvo = "partner".equals(memberType)
                ? customerService.getPartnerDetail(userIdx)
                : customerService.getCustomerDetail(userIdx);
        model.addAttribute("cvo",        cvo);
        model.addAttribute("memberType", memberType);
        model.addAttribute("nowPage",    nowPage);
        return "customer/detail";
    }

    /* 고객 등록 폼 */
    @GetMapping("/register")
    public String registerForm() { return "customer/register"; }

    /* 고객 등록 처리 */
    @PostMapping("/register")
    public String registerOk(CustomerVO vo) {
        customerService.insertCustomer(vo);
        return "redirect:/admin/customer/list";
    }

    /* 고객 수정 폼 */
    @GetMapping("/update")
    public String updateForm(@RequestParam String userIdx,
                             @RequestParam(defaultValue = "") String memberType,
                             @RequestParam(defaultValue = "1") int nowPage,
                             Model model) {
        CustomerVO cvo = "partner".equals(memberType)
                ? customerService.getPartnerDetail(userIdx)
                : customerService.getCustomerDetail(userIdx);
        model.addAttribute("cvo",        cvo);
        model.addAttribute("memberType", memberType);
        model.addAttribute("nowPage",    nowPage);
        return "customer/update";
    }

    /* 고객 수정 처리 */
    @PostMapping("/update")
    public String updateOk(CustomerVO vo,
                           @RequestParam(defaultValue = "") String memberType,
                           @RequestParam(defaultValue = "1") int nowPage) {
        if ("partner".equals(memberType)) {
            customerService.updatePartner(vo);
        } else {
            customerService.updateCustomer(vo);
        }
        return "redirect:/admin/customer/detail?userIdx=" + vo.getUserIdx()
                + "&memberType=" + memberType + "&nowPage=" + nowPage;
    }

    /* 상태 변경 (정상 ↔ 숨김) */
    @PostMapping("/statusChange")
    public String statusChange(CustomerVO vo,
                               @RequestParam(defaultValue = "") String memberType,
                               @RequestParam(defaultValue = "1") int nowPage) {
        if ("partner".equals(memberType)) {
            customerService.updatePartnerStatus(vo);
        } else {
            customerService.updateCustomerStatus(vo);
        }
        return "redirect:/admin/customer/detail?userIdx=" + vo.getUserIdx()
                + "&memberType=" + memberType + "&nowPage=" + nowPage;
    }

    /* 고객/파트너 삭제 (소프트) */
    @PostMapping("/delete")
    public String delete(@RequestParam String userIdx,
                         @RequestParam(defaultValue = "") String memberType) {
        if ("partner".equals(memberType)) {
            customerService.deletePartner(userIdx);
        } else {
            customerService.deleteCustomer(userIdx);
        }
        return "redirect:/admin/customer/list";
    }

    /* 아이디 중복 확인 (AJAX) */
    @GetMapping("/checkId")
    @ResponseBody
    public int checkId(@RequestParam String uId) {
        return customerService.checkDuplicateId(uId);
    }

    /* 이메일 중복 확인 (AJAX) */
    @GetMapping("/checkEmail")
    @ResponseBody
    public int checkEmail(@RequestParam String userEmail) {
        return customerService.checkDuplicateEmail(userEmail);
    }
}

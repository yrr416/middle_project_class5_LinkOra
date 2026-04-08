package org.study.project05class.partner.service;

import org.study.project05class.partner.vo.BranchRegVO;
import org.study.project05class.partner.vo.SpaceRegVO;

import java.util.List;
import java.util.Map;

// 파트너 오피스 등록 서비스 인터페이스
public interface PartnerRegService {

    // Step1 · 지점 기본 정보 저장 (bIdx 세팅 후 반환)
    BranchRegVO saveBranchBasic(BranchRegVO vo);

    // Step2 · 운영 정보 저장
    void saveBranchOper(BranchRegVO vo);

    // Step3 · 공간 목록 저장
    void saveSpaces(List<SpaceRegVO> spaceList, int bIdx);

    // Step4 · 사진 저장 (지점·공간)
    void saveImages(int bIdx, List<Map<String, Object>> branchImgs, List<Map<String, Object>> spaceImgs);

    // Step5 · 최종 제출 (지점 활성화)
    void submitRegistration(int bIdx);

    // Step5 · 미리보기용 지점 조회
    BranchRegVO getBranchById(int bIdx);

    // Step5 · 미리보기용 공간 목록 조회
    List<SpaceRegVO> getSpacesByBranchId(int bIdx);
}

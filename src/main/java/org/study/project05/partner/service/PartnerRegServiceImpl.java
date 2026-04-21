package org.study.project05.partner.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.project05.partner.mapper.PartnerRegMapper;
import org.study.project05.partner.vo.BranchRegVO;
import org.study.project05.partner.vo.SpaceRegVO;

import java.util.List;
import java.util.Map;

// 파트너 오피스 등록 서비스 구현체
@Service
@RequiredArgsConstructor
public class PartnerRegServiceImpl implements PartnerRegService {

    private final PartnerRegMapper partnerRegMapper;

    /** Step1 · 지점 기본 정보 INSERT */
    @Override
    @Transactional
    public BranchRegVO saveBranchBasic(BranchRegVO vo) {
        partnerRegMapper.insertBranch(vo); // useGeneratedKeys 로 bIdx 자동 세팅
        return vo;
    }

    /** Step2 · 운영 정보 UPDATE */
    @Override
    @Transactional
    public void saveBranchOper(BranchRegVO vo) {
        partnerRegMapper.updateBranchOper(vo);
    }

    /** Step3 · 공간 + 시설 INSERT */
    @Override
    @Transactional
    public void saveSpaces(List<SpaceRegVO> spaceList, int bIdx) {
        for (SpaceRegVO space : spaceList) {
            space.setBrnIdx(bIdx);
            partnerRegMapper.insertSpace(space);    // sIdx 자동 세팅
            partnerRegMapper.insertFacilities(space);
        }
    }

    /** Step4 · 지점·공간 이미지 저장 */
    @Override
    @Transactional
    public void saveImages(int bIdx, List<Map<String, Object>> branchImgs, List<Map<String, Object>> spaceImgs) {
        // 지점 이미지
        for (int i = 0; i < branchImgs.size(); i++) {
            Map<String, Object> img = branchImgs.get(i);
            img.put("brnIdx", bIdx);
            img.put("briOrder", i);
            img.put("briIsMain", i == 0 ? 1 : 0);
            partnerRegMapper.insertBranchImg(img);
            // 첫 번째 이미지를 b_url 로 설정
            if (i == 0) {
                partnerRegMapper.updateBranchImgUrl(bIdx, (String) img.get("briUrl"));
            }
        }
        // 공간 이미지
        for (int i = 0; i < spaceImgs.size(); i++) {
            Map<String, Object> img = spaceImgs.get(i);
            img.put("spiOrder", i);
            img.put("spiIsMain", i == 0 ? 1 : 0);
            partnerRegMapper.insertSpaceImg(img);
            if (i == 0) {
                partnerRegMapper.updateSpaceMainImg(img);
            }
        }
    }

    /** Step5 · 지점 활성화 */
    @Override
    @Transactional
    public void submitRegistration(int brnIdx) {
        partnerRegMapper.activateBranch(brnIdx);
    }

    /** Step5 · 지점 단건 조회 */
    @Override
    public BranchRegVO getBranchById(int brnIdx) {
        return partnerRegMapper.selectBranchById(brnIdx);
    }

    /** Step5 · 공간 목록 조회 */
    @Override
    public List<SpaceRegVO> getSpacesByBranchId(int brnIdx) {
        return partnerRegMapper.selectSpacesByBranchId(brnIdx);
    }

    /** 내 매물 관리 · 파트너 소유 지점 목록 (공간 포함) */
    @Override
    public List<BranchRegVO> getMyBranches(int partnerIdx) {
        List<BranchRegVO> branches = partnerRegMapper.selectMyBranches(partnerIdx);
        for (BranchRegVO b : branches) {
            b.setSpaces(partnerRegMapper.selectSpacesByBranchId(b.getBrnIdx()));
        }
        return branches;
    }

    /** 내 매물 관리 · 지점 활성/비활성 토글 (소속 공간 전체 연동) */
    @Override
    @Transactional
    public boolean toggleBranchActive(int brnIdx, int partnerIdx) {
        // 현재 상태를 먼저 파악 (토글 전)
        BranchRegVO branch = partnerRegMapper.selectBranchById(brnIdx);
        if (branch == null) return false;

        int affected = partnerRegMapper.toggleBranchActive(brnIdx, partnerIdx);
        if (affected == 0) return false;

        // 지점 비활성화(brnActive==1) → 공간 전체 비활성화, 지점 활성화 → 공간 전체 활성화
        if (branch.getBrnActive() == 1) {
            partnerRegMapper.deactivateAllSpacesByBranch(brnIdx, partnerIdx);
        } else {
            partnerRegMapper.activateAllSpacesByBranch(brnIdx, partnerIdx);
        }
        return true;
    }

    /** 내 매물 관리 · 공간 활성/비활성 토글 */
    @Override
    @Transactional
    public boolean toggleSpaceActive(int spcIdx, int partnerIdx) {
        return partnerRegMapper.toggleSpaceActiveByPartner(spcIdx, partnerIdx) > 0;
    }
}

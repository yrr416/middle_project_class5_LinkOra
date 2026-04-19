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
}

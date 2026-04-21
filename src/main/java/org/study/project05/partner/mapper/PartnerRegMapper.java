package org.study.project05.partner.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.partner.vo.BranchRegVO;
import org.study.project05.partner.vo.SpaceRegVO;

import java.util.List;
import java.util.Map;

// 파트너 오피스 등록 Mapper
@Mapper
public interface PartnerRegMapper {

    // Step1 · 지점 기본 정보 임시 저장 (INSERT 후 PK 반환)
    int insertBranch(BranchRegVO vo);

    // Step2 · 운영 정보 업데이트
    int updateBranchOper(BranchRegVO vo);

    // Step3 · 공간 단건 INSERT (PK 자동 세팅)
    int insertSpace(SpaceRegVO vo);

    // Step3 · 시설 정보 INSERT
    int insertFacilities(SpaceRegVO vo);

    // Step4 · 지점 대표 이미지 URL 저장
    int updateBranchImgUrl(@Param("brnIdx") int brnIdx, @Param("brnUrl") String brnUrl);

    // Step4 · 지점 이미지 목록 저장
    int insertBranchImg(Map<String, Object> param);

    // Step4 · 공간 이미지 목록 저장
    int insertSpaceImg(Map<String, Object> param);

    // Step4 · 공간 메인 이미지를 space.s_img에 동기화
    int updateSpaceMainImg(Map<String, Object> param);

    // Step5 · 지점 활성화 (최종 제출)
    int activateBranch(@Param("brnIdx") int brnIdx);

    // Step5 · 최종 제출된 지점 정보 조회
    BranchRegVO selectBranchById(@Param("brnIdx") int brnIdx);

    // Step5 · 지점에 속한 공간 목록 조회
    List<SpaceRegVO> selectSpacesByBranchId(@Param("brnIdx") int brnIdx);

    // 내 매물 관리 · 파트너 소유 지점 전체 조회
    List<BranchRegVO> selectMyBranches(@Param("partnerIdx") int partnerIdx);

    // 내 매물 관리 · 지점 활성/비활성 토글
    int toggleBranchActive(@Param("brnIdx") int brnIdx, @Param("partnerIdx") int partnerIdx);

    // 내 매물 관리 · 지점 소속 공간 전체 활성화
    int activateAllSpacesByBranch(@Param("brnIdx") int brnIdx, @Param("partnerIdx") int partnerIdx);

    // 내 매물 관리 · 지점 소속 공간 전체 비활성화
    int deactivateAllSpacesByBranch(@Param("brnIdx") int brnIdx, @Param("partnerIdx") int partnerIdx);

    // 내 매물 관리 · 공간 활성/비활성 토글
    int toggleSpaceActiveByPartner(@Param("spcIdx") int spcIdx, @Param("partnerIdx") int partnerIdx);
}

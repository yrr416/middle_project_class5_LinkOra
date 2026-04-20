package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.vo.WishVO;

import java.util.List;

public interface WishService {

    // 찜하기 버튼을 눌렀을 때 (있으면 삭제, 없으면 추가) 작동하는 기능임.
    boolean toggleWish(WishVO wishVO);

    // 내가 찜한 지점들만 쏙쏙 골라서 목록으로 가져오는 기능임.
    // 사용자의 번호를 나타내는 u_idx를 규칙에 맞게 userIdx로 변경함.
    List<BranchVO> getMyFavoriteBranches(int userIdx);

    // 새롭게 추가한 기능: 페이징을 위해 몇 개를 건너뛰고(skip), 몇 개를 가져올지(size) 정해서 목록을 가져옵니다.
    List<BranchVO> getMyFavoriteBranches(int userIdx, int skip, int size);

    // 새롭게 추가한 기능: 전체 페이지 수를 계산할 수 있도록, 내가 찜한 지점이 총 몇 개인지 세어줍니다.
    int getMyFavoriteBranchesCount(int userIdx);
}
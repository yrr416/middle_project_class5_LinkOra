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
}
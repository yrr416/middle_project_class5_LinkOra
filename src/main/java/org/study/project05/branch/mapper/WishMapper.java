package org.study.project05.branch.mapper;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.vo.WishVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List; // ★ List 사용을 위해 추가함.

@Mapper
public interface WishMapper {

    // 1. 이미 찜했는지 확인하는 주문임 (결과는 숫자로 나옴).
    int checkWish(WishVO wishVO);

    // 2. 찜 목록에 새로운 지점을 추가하는 주문임.
    int insertWish(WishVO wishVO);

    // 3. 찜 목록에서 지점을 빼는 주문임.
    int deleteWish(WishVO wishVO);

    // 내 관심 지점 목록(BranchVO 리스트)을 가져오는 주문임.
    // 사용자의 번호를 나타내는 u_idx를 규칙에 맞게 userIdx로 변경함.
    List<BranchVO> getMyFavoriteBranches(int userIdx);
}
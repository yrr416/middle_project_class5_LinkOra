package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.mapper.WishMapper;
import org.study.project05.branch.vo.WishVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List; // ★ List 사용을 위해 꼭 필요함.

@Service
public class WishServiceImpl implements WishService {

    @Autowired
    private WishMapper wishMapper;

    // 1. 기존 찜하기 토글 기능임.
    @Override
    @Transactional
    public boolean toggleWish(WishVO wishVO) {
        // 찜이 이미 되어있는지 확인함 (wishVO 내부의 userIdx, brnIdx 사용함).
        int count = wishMapper.checkWish(wishVO);

        if (count > 0) {
            wishMapper.deleteWish(wishVO); // 이미 있으면 삭제함.
            return false;
        } else {
            wishMapper.insertWish(wishVO); // 없으면 추가함.
            return true;
        }
    }

    // 내 관심 지점 목록 가져오기 구현임.
    @Override
    public List<BranchVO> getMyFavoriteBranches(int userIdx) {
        // Mapper(XML 쿼리)에 회원 번호(userIdx)를 넘겨서 찜한 지점 리스트를 받아옴.
        return wishMapper.getMyFavoriteBranches(userIdx);
    }
}
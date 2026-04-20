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

    // 1. 기존 찜하기 토글 기능임. (잘못 끼어있던 인터페이스 코드를 제거하고 깔끔하게 수정함)
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

    // 2. 내 관심 지점 목록 가져오기 기존 기능임.
    @Override
    public List<BranchVO> getMyFavoriteBranches(int userIdx) {
        // Mapper(XML 쿼리)에 회원 번호(userIdx)를 넘겨서 찜한 지점 리스트를 받아옴.
        // 페이징 없이 전체를 가져올 때는 skip과 size에 null을 보냅니다.
        return wishMapper.getMyFavoriteBranches(userIdx, null, null);
    }

    /* --- [여기서부터 페이징 관련 추가 부분] --- */

    // 3. [추가] 6개씩 끊어서 가져오기 위해 skip(건너뛸 개수)과 size(가져올 개수)를 매퍼로 전달하는 기능임.
    @Override
    public List<BranchVO> getMyFavoriteBranches(int userIdx, int skip, int size) {
        // 컨트롤러에서 계산해서 넘겨준 숫자를 그대로 매퍼의 바구니에 담아줍니다.
        return wishMapper.getMyFavoriteBranches(userIdx, skip, size);
    }

    // 4. [추가] 전체 페이지가 몇 개인지 계산하기 위해 내가 찜한 오피스의 총개수를 세어주는 기능임.
    @Override
    public int getMyFavoriteBranchesCount(int userIdx) {
        // 데이터베이스에 가서 "이 회원이 찜한 게 총 몇 개야?"라고 물어보고 결과를 받아옵니다.
        return wishMapper.getMyFavoriteBranchesCount(userIdx);
    }
}
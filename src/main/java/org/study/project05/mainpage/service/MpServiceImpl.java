package org.study.project05.mainpage.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

// [설명] MP 메뉴판에 적힌 기능을 실제로 작동시키는 클래스임.
@Service
@RequiredArgsConstructor
public class MpServiceImpl implements MpService {

    // [참고] 나중에 데이터베이스에서 정보를 가져와야 한다면 아래처럼 매퍼를 연결하면 됨.
    // private final org.study.project05.mainpage.mapper.MpMapper mpMapper;

    @Override
    public void getMainPageInfo() {
        // [작동] 여기에 실제 메인 화면 정보를 불러오는 코드를 작성하면 됨.
        System.out.println("메인 페이지 정보 준비 완료됨!");
    }
}
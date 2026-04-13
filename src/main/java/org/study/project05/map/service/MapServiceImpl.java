package org.study.project05.map.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.map.mapper.MapMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

// [설명] MapService(메뉴판)에 적힌 기능을 실제로 실행하는 요리사(구현체)임.
// [위치] 인텔리제이 화면에서 확인했던 경로(service/impl)에 정확히 맞췄음.
@Service
@RequiredArgsConstructor // [설명] final이 붙은 매퍼를 스프링이 자동으로 꽂아줌.
public class MapServiceImpl implements MapService {

    // [중요] 변수명은 반드시 소문자로 시작해야 에러가 안 남! (mapMapper)
    private final MapMapper mapMapper;

    // [기능] 메뉴판에 적힌 '전체 지점 가져오기'를 실제로 실행함.
    @Override
    public List<BranchVO> getBranchList() {
        // [작동] 매퍼한테 모든 지점 리스트를 가져오라고 시킴.
        return mapMapper.getBranchList();
    }

    // [기능] 지도 화면 영역(네모칸) 안에 있는 지점들을 찾아옴.
    @Override
    public List<BranchVO> getBranchesInMap(double swLat, double swLng, double neLat, double neLng) {
        // [작동] 컨트롤러에서 넘겨받은 지도 화면의 4개 좌표를 매퍼로 전달함.
        // [결과] 해당 영역 안에 있는 지점 목록을 반환함.
        return mapMapper.getBranchesInMap(swLat, swLng, neLat, neLng);
    }

    // [기능] 특정 마커를 클릭했을 때 지점 하나 상세 정보를 가져옴.
    // 기존 b_idx를 규칙에 맞게 brnIdx로 변경함.
    @Override
    public BranchVO getBranchLocation(int brnIdx) {
        // [작동] 지점의 고유 번호(brnIdx)를 매퍼로 전달함.
        // [결과] 지점 하나의 상세 데이터를 반환함.
        return mapMapper.getBranchLocation(brnIdx);
    }

    // 내 위치 주변 지점 찾기 실제 기능임.
    // [기능] GPS 위도와 경도를 받아서 주변 지점들을 가져옴.
    @Override
    public List<BranchVO> getNearbyBranches(double lat, double lng) {
        // [작동] 매퍼에게 내 위치(lat, lng)를 전달해서 주변 지점들을 주문함.
        return mapMapper.getNearbyBranches(lat, lng);
    }
} 

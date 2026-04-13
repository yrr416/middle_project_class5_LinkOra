package org.study.project05.map.service;

import org.study.project05.branch.vo.BranchVO;
import java.util.List;

/**
 * 지도 화면에서 쓸 기능들의 이름을 적어두는 메뉴판임.
 */
public interface MapService {

    // [지도] 모든 지점(전체 목록)을 찾아오는 메뉴임.
    List<BranchVO> getBranchList();

    // [기능] 현재 보고 있는 지도 화면(네모칸) 안에 있는 지점 목록을 가져옴.
    // [파라미터] sw: 남서쪽(왼쪽 아래) 좌표, ne: 북동쪽(오른쪽 위) 좌표임.
    List<BranchVO> getBranchesInMap(double swLat, double swLng, double neLat, double neLng);

    // [기능] 지도에서 마커를 눌렀을 때 보여줄 특정 지점 딱 하나의 정보를 가져옴.
    // 기존 b_idx를 규칙에 맞게 brnIdx로 변경함.
    BranchVO getBranchLocation(int brnIdx);

    // 내 위치 주변 지점을 찾는 메뉴임.
    // [기능] 사용자의 위도와 경도를 전달받아 주변에 있는 지점들을 찾아옴.
    List<BranchVO> getNearbyBranches(double lat, double lng);
} 

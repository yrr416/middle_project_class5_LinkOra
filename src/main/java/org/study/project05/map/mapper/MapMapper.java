package org.study.project05.map.mapper;

import org.study.project05.branch.vo.BranchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 지도 서비스가 데이터베이스에 요청할 주문서임.
 */
@Mapper
public interface MapMapper {

    // [주문] 모든 지점(전체 목록)을 찾아오는 주문임.
    List<BranchVO> getBranchList();

    // [주문] 지도 화면(네모칸) 안에 들어오는 지점들의 목록을 찾아옴.
    List<BranchVO> getBranchesInMap(
            @Param("swLat") double swLat,  // 남서쪽 위도임.
            @Param("swLng") double swLng,  // 남서쪽 경도임.
            @Param("neLat") double neLat,  // 북동쪽 위도임.
            @Param("neLng") double neLng   // 북동쪽 경도임.
    );

    // [주문] 마커를 눌렀을 때 특정 지점 딱 하나의 상세 정보를 찾아옴.
    // 기존 b_idx를 규칙에 맞게 brnIdx로 변경함.
    BranchVO getBranchLocation(@Param("brnIdx") int brnIdx);

    // ==========================================
    // [박사님 추가 항목] 내 위치 주변 지점을 찾는 주문임.
    // ==========================================
    // [주문] 내 GPS 좌표(위도, 경도)를 보내서 가까운 지점들을 찾아옴.
    List<BranchVO> getNearbyBranches(
            @Param("lat") double lat,  // 내 현재 위도임.
            @Param("lng") double lng   // 내 현재 경도임.
    );
} 

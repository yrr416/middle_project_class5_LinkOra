package org.study.project05.branch.vo; // 프로젝트의 실제 패키지 경로임

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor  // 기본 생성자 생성함
@AllArgsConstructor // 모든 필드를 포함한 생성자 생성함
@Builder            // 빌더 패턴 사용 가능하게 함
public class BranchVO {

    // [기본 지점 정보] - 접두어 brn 사용함
    private int brnIdx;           // 지점 번호 (b_idx) 임
    private int ptnIdx;           // 파트너 번호 (p_idx) 임
    private String brnName;       // 지점 이름 (b_name) 임
    private String brnDescription; // 지점 설명 (b_description) 임
    private String brnFile;        // 이미지 경로 (b_file) 임
    private String brnAddress;     // 지점 주소 (b_address) 임

    // [지도 필수 좌표]
    private double brnLatitude;    // 위도 (b_latitude) 임
    private double brnLongitude;   // 자바스크립트와 일치하도록 brnAltitude를 brnLongitude로 수정함

    // [운영 정보]
    private String brnPhone;       // 전화번호 (b_phone) 임
    private String brnSns;         // SNS 주소 (b_sns) 임
    private String brnHours;       // 운영 시간 (b_hours) 임
    private String brnNotice;      // 공지 사항 (b_notice) 임
    private String brnRefundPoli;  // 환불 정책 (b_refund_poli) 임
    private int brnActive;         // 활성화 여부 (b_active) 임
    private String brnUrl;         // 관련 URL (b_url) 임

    // [검색 필터용 편의시설 플래그] - BranchMapper.searchWithFilters 결과 매핑
    private Integer facParking;
    private Integer facH24;
    private Integer facPet;
    private Integer facWifi;
    private Integer facCoffee;
    private Integer facPrinter;
    private Integer facLocker;

    // [상세 조회용 — 서비스 레이어에서 조립]
    private String partnerName;          // JOIN으로 가져오는 파트너 브랜드명
    private List<SpaceVO> spaces;        // 지점 내 예약 가능 공간 목록
    private List<BranchImgVO> images;    // 지점 이미지 목록

}
package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BranchVO {

    // [기본 지점 정보] - b_idx 등 DB 컬럼과 매핑
    private int brnIdx;           // 지점 번호 (b_idx)
    private int ptnIdx;           // 파트너 번호 (p_idx)
    private String brnName;       // 지점 이름 (b_name)
    private String brnDescription; // 지점 설명 (b_description)
    private String brnFile;        // 이미지 경로 (b_file)
    private String brnAddress;     // 지점 주소 (b_address)

    // [지도 필수 좌표]
    private double brnLatitude;    // 위도 (b_latitude)
    private double brnLongitude;   // 경도 (b_altitude와 매핑됨)

    // [운영 정보]
    private String brnPhone;       // 전화번호 (b_phone)
    private String brnSns;         // SNS 주소 (b_sns)
    private String brnHours;       // 운영 시간 (b_hours)
    private String brnNotice;      // 공지 사항 (b_notice)
    private String brnRefundPoli;  // 환불 정책 (b_refund_poli)
    private int brnActive;         // 활성화 여부 (b_active)
    private String brnUrl;         // 관련 URL (b_url)

    // [중요: 거리 정보 추가]
    // Mapper의 위치 검색 기능을 위해 반드시 필요합니다.
    private double distance;       // 중심 좌표로부터의 거리 (KM 단위)

    // [검색 필터용 편의시설 플래그] - 지점 리스트 아이콘 출력용
    // 0: 없음, 1: 있음 (int로 선언하여 기본값 0 유지)
    private int facParking;
    private int facHours24;
    private int facPet;
    private int facWifi;
    private int facCoffee;
    private int facPrinter;
    private int facLocker;

    // [상세 조회 및 연관 데이터]
    private String partnerName;          // 파트너 브랜드명
    private List<BranchSpaceVO> spaces;        // 지점 내 공간 목록
    private List<BranchImgVO> images;    // 지점 이미지 목록

    // [검색 목록용 대표 이미지] - branch_img 테이블에서 bi_is_main=1인 이미지 URL
    private String mainImgUrl;

    // 로그인한 사용자의 찜 여부를 저장하는 공간
    private boolean isWish;

    // [핵심 추가] JSP EL (${branch.isWish}) 호환성을 위한 수동 Getter/Setter
    // Lombok이 생성하는 이름과 겹칠 수 있지만, 명시적으로 작성하면 JSP가 에러 없이 정확히 찾아냅니다.
    public boolean getIsWish() {
        return isWish;
    }

    public void setIsWish(boolean isWish) {
        this.isWish = isWish;
    }
}
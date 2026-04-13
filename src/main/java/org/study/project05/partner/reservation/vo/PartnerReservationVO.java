package org.study.project05.partner.reservation.vo;

import lombok.Data;

@Data
public class PartnerReservationVO {
    private int    resIdx;
    private String resCode;
    private String resStartTime;
    private String resEndTime;
    private int    resHeadcount;
    private int    resTotalPrice;
    private String resContent;
    private String resCreated;
    private String resUpdated;
    private String resStatus;

    private int    userIdx;
    private String userName;      // masked
    private String userPhone;     // masked
    private String userEmail;     // masked

    private int    spcIdx;
    private String spcName;
    private String spcType;
    private int    spcPrice;

    private int    brnIdx;
    private String brnName;

    private int    revIdx;
    private int    revRating;
    private String revContent;
    private String revCreatedAt;

    // search filters
    private String startDate;
    private String endDate;
    private String statusFilter;
    private String spaceFilter;
    private String searchWord;
}

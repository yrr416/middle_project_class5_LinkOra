package org.study.project05.partner.reservation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.partner.reservation.mapper.PartnerReservationMapper;
import org.study.project05.partner.reservation.vo.PartnerReservationVO;
import org.study.project05.reservation.user.service.ReservationMailService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PartnerReservationServiceImpl implements PartnerReservationService {

    @Autowired
    private PartnerReservationMapper mapper;

    @Autowired
    private ReservationMailService mailService;

    @Override
    public Map<String, Object> getSummary(int partnerIdx) {
        return mapper.getSummary(partnerIdx);
    }

    @Override
    public int getCount(int partnerIdx, int offset, int numPerPage, PartnerReservationVO vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("partnerIdx", partnerIdx);
        params.put("vo", vo);
        params.put("offset", offset);
        params.put("numPerPage", numPerPage);
        return mapper.getCount(params);
    }

    @Override
    public List<PartnerReservationVO> getList(int partnerIdx, int offset, int numPerPage, PartnerReservationVO vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("partnerIdx", partnerIdx);
        params.put("vo", vo);
        params.put("offset", offset);
        params.put("numPerPage", numPerPage);
        return mapper.getList(params);
    }

    @Override
    public PartnerReservationVO getDetail(int resIdx, int partnerIdx) {
        Map<String, Object> params = new HashMap<>();
        params.put("resIdx", resIdx);
        params.put("partnerIdx", partnerIdx);
        return mapper.getDetail(params);
    }

    @Override
    public List<PartnerReservationVO> getSpaceList(int partnerIdx) {
        return mapper.getSpaceList(partnerIdx);
    }

    @Override
    public List<Map<String, Object>> getCalendarEvents(int partnerIdx, int year, int month) {
        Map<String, Object> params = new HashMap<>();
        params.put("partnerIdx", partnerIdx);
        params.put("year", year);
        params.put("month", month);
        return mapper.getCalendarEvents(params);
    }

    @Override
    public Map<String, Object> getRevenueData(int partnerIdx, String startDate, String endDate, String periodType) {
        Map<String, Object> params = new HashMap<>();
        params.put("partnerIdx", partnerIdx);
        params.put("startDate",  startDate);
        params.put("endDate",    endDate);

        List<Map<String, Object>> byPeriod;
        if ("weekly".equals(periodType)) {
            byPeriod = mapper.getRevenueByWeek(params);
        } else if ("monthly".equals(periodType)) {
            byPeriod = mapper.getRevenueByMonth(params);
        } else {
            byPeriod = mapper.getRevenueByDay(params);
        }
        List<Map<String, Object>> bySpace = mapper.getRevenueBySpace(params);

        long totalRevenue = 0, totalCnt = 0;
        for (Map<String, Object> row : byPeriod) {
            Object rev = row.get("revenue");
            Object cnt = row.get("cnt");
            if (rev != null) totalRevenue += ((Number) rev).longValue();
            if (cnt != null) totalCnt     += ((Number) cnt).longValue();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("byPeriod",     byPeriod);
        result.put("bySpace",      bySpace);
        result.put("totalRevenue", totalRevenue);
        result.put("totalCnt",     totalCnt);
        result.put("feeRevenue",   Math.round(totalRevenue * 0.9));
        return result;
    }

    @Override
    public boolean confirmReservation(int resIdx, int partnerIdx) {
        Map<String, Object> params = new HashMap<>();
        params.put("resIdx",     resIdx);
        params.put("partnerIdx", partnerIdx);
        return mapper.confirmReservation(params) > 0;
    }

    @Override
    public boolean confirmAndNotify(int resIdx, int partnerIdx) {
        // ① 기존 승인 로직 그대로 실행
        boolean ok = confirmReservation(resIdx, partnerIdx);

        // ② 승인 성공했을 때만 이메일 발송
        if (ok) {
            // getDetail로 사용자 이메일·이름·공간명·시간 정보를 한 번에 가져옴
            PartnerReservationVO detail = getDetail(resIdx, partnerIdx);
            if (detail != null && detail.getUserEmail() != null) {
                // sendReservationApproved 내부에서 예외를 잡으므로 여기서 try-catch 불필요
                mailService.sendReservationApproved(
                        detail.getUserEmail(),
                        detail.getUserName(),
                        detail.getSpcName(),
                        detail.getResStartTime(),
                        detail.getResEndTime()
                );
            }
        }
        return ok;
    }

    @Override
    public boolean rejectReservation(int resIdx, int partnerIdx, String reason) {
        Map<String, Object> params = new HashMap<>();
        params.put("resIdx",     resIdx);
        params.put("partnerIdx", partnerIdx);
        params.put("reason",     reason);
        return mapper.rejectReservation(params) > 0;
    }
}

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드 - 오피스 예약 플랫폼</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Chart.js (차트 렌더링 라이브러리) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        /* ── 전체 배경 ── */
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }

        /* ── 사이드바 ── */
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #1a3a5c 0%, #0d2137 100%);
            position: sticky; top: 0;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,.75); padding: 10px 20px;
            border-radius: 6px; margin: 2px 8px; transition: .2s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: #fff; background: rgba(255,255,255,.15);
        }
        .sidebar .nav-link i { margin-right: 8px; }
        .sidebar-brand {
            color: #fff; font-size: 1.2rem; font-weight: 700;
            padding: 20px; border-bottom: 1px solid rgba(255,255,255,.1);
        }

        /* ── 메인 콘텐츠 ── */
        .main-content { padding: 24px; min-height: 100vh; }

        /* ── 페이지 헤더 ── */
        .page-header {
            background: #fff; border-radius: 10px;
            padding: 20px 24px; margin-bottom: 24px;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }

        /* ── 요약 카드 공통 ── */
        .summary-card {
            background: #fff; border-radius: 12px;
            padding: 20px 24px; box-shadow: 0 1px 4px rgba(0,0,0,.06);
            border-left: 4px solid transparent; transition: .2s;
        }
        .summary-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,.1); }
        .summary-card .icon-wrap {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
        }
        .summary-card .big-num { font-size: 1.8rem; font-weight: 700; line-height: 1.2; }
        .summary-card .sub-text { font-size: .8rem; color: #6c757d; margin-top: 2px; }
        .card-blue   { border-left-color: #0d6efd; }
        .card-green  { border-left-color: #198754; }
        .card-orange { border-left-color: #fd7e14; }
        .card-purple { border-left-color: #6f42c1; }
        .icon-blue   { background: #e8f0fe; color: #0d6efd; }
        .icon-green  { background: #d1fae5; color: #198754; }
        .icon-orange { background: #fff3cd; color: #fd7e14; }
        .icon-purple { background: #e8daff; color: #6f42c1; }

        /* ── 차트 카드 ── */
        .chart-card {
            background: #fff; border-radius: 12px;
            padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .chart-card .card-title {
            font-size: .95rem; font-weight: 600; margin-bottom: 16px; color: #212529;
        }

        /* ── 히트맵 그리드 ── */
        .heatmap-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; }
        .heatmap-day-label {
            text-align: center; font-size: .75rem; font-weight: 600;
            color: #6c757d; padding: 4px 0;
        }
        .heatmap-cell {
            aspect-ratio: 1; border-radius: 4px;
            background: #e9ecef; cursor: default;
            transition: .15s;
        }
        .heatmap-cell:hover { opacity: .8; }
        .heatmap-cell.empty { background: #f8f9fa; }
        /* 예약 건수에 따른 색상 강도 — JavaScript 에서 동적으로 적용 */
        .heat-0 { background: #e9ecef; }
        .heat-1 { background: #bdd7f5; }
        .heat-2 { background: #84b9ee; }
        .heat-3 { background: #4b9be3; }
        .heat-4 { background: #1a7fdb; }
        .heat-5 { background: #0d5fad; }

        /* ── 최근 예약 / 알림 카드 ── */
        .list-card {
            background: #fff; border-radius: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,.06); overflow: hidden;
        }
        .list-card .list-header {
            padding: 16px 20px; border-bottom: 1px solid #f0f0f0;
            font-weight: 600; font-size: .95rem;
        }
        .list-card .list-body { padding: 0; }
        .list-card .list-item {
            padding: 12px 20px; border-bottom: 1px solid #f8f9fa;
            display: flex; align-items: center; gap: 12px;
        }
        .list-card .list-item:last-child { border-bottom: none; }
        .list-card .list-item:hover { background: #f8faff; }

        /* ── 예약 상태 배지 ── */
        .badge-reserve   { background: #dbeafe; color: #1d4ed8; }
        .badge-using     { background: #d1fae5; color: #065f46; }
        .badge-done      { background: #e5e7eb; color: #374151; }
        .badge-cancel    { background: #fee2e2; color: #991b1b; }

        /* ── 알림 카드 ── */
        .alert-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 14px 20px; border-bottom: 1px solid #f0f0f0;
        }
        .alert-item:last-child { border-bottom: none; }

        /* ── 신규 회원 아이템 ── */
        .user-avatar {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff; display: flex; align-items: center;
            justify-content: center; font-weight: 700; font-size: .85rem;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ════════════════════════════════
         사이드바 네비게이션
         ════════════════════════════════ -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand">
            <i class="bi bi-building me-2"></i>오피스 예약
        </div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <!-- 대시보드: 현재 페이지이므로 active 클래스 적용 -->
            <a class="nav-link active" href="/admin/dashboard">
                <i class="bi bi-speedometer2"></i>대시보드
            </a>
            <a class="nav-link" href="/admin/customer/list">
                <i class="bi bi-people"></i>고객 관리
            </a>
            <a class="nav-link" href="/admin/reservation/list">
                <i class="bi bi-calendar-check"></i>예약 관리
            </a>
            <a class="nav-link" href="/admin/space/list">
                <i class="bi bi-building"></i>오피스 관리
            </a>
            <a class="nav-link" href="/admin/review/list">
                <i class="bi bi-star"></i>리뷰 관리
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-bell"></i>공지 관리
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-chat-left-text"></i>문의 내역
            </a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="#">
                <i class="bi bi-gear"></i>설정
            </a>
        </nav>
    </div>

    <!-- ════════════════════════════════
         메인 콘텐츠 영역
         ════════════════════════════════ -->
    <div class="col main-content">

        <!-- 페이지 헤더: 제목 + 현재 날짜 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold">
                    <i class="bi bi-speedometer2 me-2 text-primary"></i>대시보드
                </h5>
                <small class="text-muted">전체 현황을 한눈에 확인합니다.</small>
            </div>
            <div class="text-end">
                <!-- 현재 날짜·시간을 JavaScript 로 출력 -->
                <div class="small text-muted" id="currentDateTime"></div>
            </div>
        </div>

        <!-- ──────────────────────────────
             ① 요약 카드 (상단 4개)
             ────────────────────────────── -->
        <div class="row g-3 mb-4">

            <!-- 카드 1: 오늘 예약 건수 + 전일 대비 변화율 -->
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-blue">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">오늘 예약 건수</div>
                            <div class="big-num text-primary">${summary.todayReserveCnt}<span class="fs-6 fw-normal ms-1">건</span></div>
                            <div class="mt-2" style="font-size:.8rem;">
                                전일 대비&nbsp;
                                <c:choose>
                                    <c:when test="${reserveChangeRate > 0}">
                                        <span class="text-success fw-bold">▲ ${reserveChangeRate}%</span>
                                    </c:when>
                                    <c:when test="${reserveChangeRate < 0}">
                                        <span class="text-danger fw-bold">▼ ${reserveChangeRate}%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">— 동일</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="icon-wrap icon-blue">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 카드 2: 전체 회원 수 + 이번달 신규 -->
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-green">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">전체 회원 수</div>
                            <div class="big-num text-success">${summary.totalUserCnt}<span class="fs-6 fw-normal ms-1">명</span></div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">
                                이번달 신규&nbsp;<strong class="text-success">+${summary.newUserCnt}명</strong>
                            </div>
                        </div>
                        <div class="icon-wrap icon-green">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 카드 3: 이번달 누적 매출 -->
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-orange">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">이번달 누적 매출</div>
                            <div class="big-num text-warning">
                                <!-- 매출 숫자는 JavaScript 에서 천 단위 콤마 포맷 후 표기 -->
                                ₩ <span id="monthlyRevenue">${summary.monthlyRevenue}</span>
                            </div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">
                                공간 예약 매출 합계
                            </div>
                        </div>
                        <div class="icon-wrap icon-orange">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 카드 4: 현재 이용 중인 공간 수 -->
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-purple">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">현재 이용 중인 공간</div>
                            <div class="big-num text-purple" style="color:#6f42c1">${summary.activeSpaceCnt}<span class="fs-6 fw-normal ms-1">개</span></div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">
                                오늘 기준 '이용중' 상태
                            </div>
                        </div>
                        <div class="icon-wrap icon-purple">
                            <i class="bi bi-building-check"></i>
                        </div>
                    </div>
                </div>
            </div>

        </div><!-- /요약 카드 row -->


        <!-- ──────────────────────────────
             ② 차트 영역 (막대 + 도넛)
             ────────────────────────────── -->
        <div class="row g-3 mb-4">

            <!-- 월별 매출 막대 그래프 -->
            <div class="col-lg-8">
                <div class="chart-card" style="height:320px;">
                    <div class="card-title">
                        <i class="bi bi-bar-chart-line me-2 text-primary"></i>월별 매출 추이
                        <small class="text-muted fw-normal ms-2">(최근 6개월)</small>
                    </div>
                    <canvas id="monthlySalesChart" style="max-height:260px;"></canvas>
                </div>
            </div>

            <!-- 공간별 이용률 도넛 차트 -->
            <div class="col-lg-4">
                <div class="chart-card" style="height:320px;">
                    <div class="card-title">
                        <i class="bi bi-pie-chart me-2 text-success"></i>공간별 이용률
                        <small class="text-muted fw-normal ms-2">(최근 3개월)</small>
                    </div>
                    <div class="d-flex justify-content-center" style="height:250px;">
                        <canvas id="spaceUsageChart"></canvas>
                    </div>
                </div>
            </div>

        </div><!-- /차트 row -->


        <!-- ──────────────────────────────
             ③ 요일별 예약 히트맵
             ────────────────────────────── -->
        <div class="row g-3 mb-4">
            <div class="col-12">
                <div class="chart-card">
                    <div class="card-title">
                        <i class="bi bi-grid-3x3 me-2 text-warning"></i>요일별 예약 히트맵
                        <small class="text-muted fw-normal ms-2">(이번달 기준)</small>
                        <!-- 범례 -->
                        <span class="float-end d-flex align-items-center gap-1" style="font-size:.75rem;">
                            <span>적음</span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#e9ecef;display:inline-block;"></span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#bdd7f5;display:inline-block;"></span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#4b9be3;display:inline-block;"></span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#0d5fad;display:inline-block;"></span>
                            <span>많음</span>
                        </span>
                    </div>

                    <!-- 요일 헤더: 일(1)~토(7) — MySQL DAYOFWEEK 기준 -->
                    <div class="heatmap-grid mb-2" id="heatmapHeader">
                        <div class="heatmap-day-label text-danger">일</div>
                        <div class="heatmap-day-label">월</div>
                        <div class="heatmap-day-label">화</div>
                        <div class="heatmap-day-label">수</div>
                        <div class="heatmap-day-label">목</div>
                        <div class="heatmap-day-label">금</div>
                        <div class="heatmap-day-label text-primary">토</div>
                    </div>

                    <!-- 히트맵 셀 그리드 — JavaScript 로 동적 렌더링 -->
                    <div id="heatmapGrid"></div>
                    <div class="text-muted small mt-2" id="heatmapCaption"></div>
                </div>
            </div>
        </div><!-- /히트맵 row -->


        <!-- ──────────────────────────────
             ④ 최근 현황 목록
             ────────────────────────────── -->
        <div class="row g-3">

            <!-- 최근 예약 5건 -->
            <div class="col-lg-7">
                <div class="list-card">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2 text-primary"></i>최근 예약 현황</span>
                        <a href="#" class="btn btn-outline-primary btn-sm py-0">전체 보기</a>
                    </div>
                    <div class="list-body">
                        <c:if test="${empty recentReserves}">
                            <div class="text-center text-muted py-4">
                                <i class="bi bi-inbox fs-4 d-block mb-1"></i>최근 예약 내역이 없습니다.
                            </div>
                        </c:if>
                        <c:forEach var="r" items="${recentReserves}">
                            <div class="list-item">
                                <!-- 예약 번호 -->
                                <div class="text-muted small" style="width:36px;flex-shrink:0;">
                                    #${r.r_idx}
                                </div>
                                <!-- 예약자 + 공간 -->
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${r.u_name}</div>
                                    <div class="text-muted small">${r.s_name}</div>
                                </div>
                                <!-- 예약일 -->
                                <div class="text-muted small">${r.r_date}</div>
                                <!-- 금액 -->
                                <div class="fw-semibold small">
                                    ₩ <span class="res-price">${r.r_price}</span>
                                </div>
                                <!-- 상태 배지 -->
                                <div>
                                    <c:choose>
                                        <%-- 이용 중 (USING) --%>
                                        <c:when test="${r.r_status == 'USING'}">
                                            <span class="badge badge-using px-2 py-1 rounded-pill">이용중</span>
                                        </c:when>
                                        <%-- 이용 완료 (COMPLETED) --%>
                                        <c:when test="${r.r_status == 'COMPLETED'}">
                                            <span class="badge badge-done px-2 py-1 rounded-pill">완료</span>
                                        </c:when>
                                        <%-- 취소 (CANCELLED) --%>
                                        <c:when test="${r.r_status == 'CANCELLED'}">
                                            <span class="badge badge-cancel px-2 py-1 rounded-pill">취소</span>
                                        </c:when>
                                        <%-- 예약 확정 (CONFIRMED) --%>
                                        <c:when test="${r.r_status == 'CONFIRMED'}">
                                            <span class="badge badge-reserve px-2 py-1 rounded-pill">확정</span>
                                        </c:when>
                                        <%-- 대기 중 (PENDING) 및 기타 상태 --%>
                                        <c:otherwise>
                                            <span class="badge badge-reserve px-2 py-1 rounded-pill">대기</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div><!-- /최근 예약 -->

            <!-- 알림 + 신규 가입 회원 -->
            <div class="col-lg-5">

                <!-- 미처리 알림 카드 -->
                <div class="list-card mb-3">
                    <div class="list-header">
                        <i class="bi bi-bell-fill me-2 text-warning"></i>처리 대기 알림
                    </div>
                    <!-- 미처리 문의 건수 -->
                    <div class="alert-item">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-chat-left-dots text-info fs-5"></i>
                            <span>미처리 문의</span>
                        </div>
                        <span class="badge bg-info text-white rounded-pill px-3">
                            ${summary.pendingInquiryCnt}건
                        </span>
                    </div>
                    <!-- 처리 대기 신고 건수 -->
                    <div class="alert-item">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-flag text-danger fs-5"></i>
                            <span>대기 중인 신고</span>
                        </div>
                        <span class="badge bg-danger rounded-pill px-3">
                            ${summary.pendingReportCnt}건
                        </span>
                    </div>
                </div>

                <!-- 신규 가입 회원 목록 -->
                <div class="list-card">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person-plus me-2 text-success"></i>신규 가입 회원</span>
                        <a href="/admin/customer/list" class="btn btn-outline-success btn-sm py-0">전체 보기</a>
                    </div>
                    <div class="list-body">
                        <c:if test="${empty newUsers}">
                            <div class="text-center text-muted py-3">
                                <i class="bi bi-inbox d-block mb-1"></i>신규 회원이 없습니다.
                            </div>
                        </c:if>
                        <c:forEach var="u" items="${newUsers}">
                            <div class="list-item">
                                <!-- 이름 첫 글자로 아바타 생성 -->
                                <div class="user-avatar">
                                    ${fn:substring(u.u_name, 0, 1)}
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${u.u_name}</div>
                                    <div class="text-muted small">${u.u_email}</div>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-secondary">${u.u_role}</span>
                                    <div class="text-muted" style="font-size:.75rem;">${u.u_created}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

            </div><!-- /알림 + 신규 회원 -->

        </div><!-- /최근 현황 row -->

    </div><!-- /main-content -->
</div><!-- /row -->
</div><!-- /container-fluid -->


<!-- ════════════════════════════════
     Bootstrap JS
     ════════════════════════════════ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ════════════════════════════════════════
   현재 날짜·시간 표시
   ════════════════════════════════════════ */
(function showDateTime() {
    const el = document.getElementById('currentDateTime');
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    function fmt() {
        const d = new Date();
        const pad = n => String(n).padStart(2, '0');
        el.textContent =
            d.getFullYear() + '년 ' +
            (d.getMonth()+1) + '월 ' +
            d.getDate() + '일 (' + days[d.getDay()] + ') ' +
            pad(d.getHours()) + ':' + pad(d.getMinutes());
    }
    fmt();
    setInterval(fmt, 60000); // 1분마다 갱신
})();


/* ════════════════════════════════════════
   이번달 누적 매출 — 천 단위 콤마 포맷
   ════════════════════════════════════════ */
(function formatRevenue() {
    const el = document.getElementById('monthlyRevenue');
    if (el) {
        const val = parseInt(el.textContent.trim(), 10) || 0;
        el.textContent = val.toLocaleString('ko-KR');
    }
    /* 최근 예약 목록의 금액도 동일하게 포맷 */
    document.querySelectorAll('.res-price').forEach(function(el) {
        const val = parseInt(el.textContent.trim(), 10) || 0;
        el.textContent = val.toLocaleString('ko-KR');
    });
})();


/* ════════════════════════════════════════
   ① 월별 매출 추이 — 막대 그래프 (Chart.js Bar)
   ════════════════════════════════════════ */
(function initMonthlySalesChart() {
    /* JSP 서버에서 JSON으로 직렬화된 레이블·데이터 수신 */
    const labels   = ${monthLabelsJson};
    const revenues = ${monthRevenuesJson};

    new Chart(document.getElementById('monthlySalesChart'), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '매출 (₩)',
                data: revenues,
                backgroundColor: 'rgba(13, 110, 253, 0.7)',
                borderColor:     'rgba(13, 110, 253, 1)',
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        /* 툴팁 금액 포맷: ₩ 1,234,567 */
                        label: ctx => '₩ ' + ctx.parsed.y.toLocaleString('ko-KR')
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: val => '₩ ' + val.toLocaleString('ko-KR')
                    }
                }
            }
        }
    });
})();


/* ════════════════════════════════════════
   ② 공간별 이용률 — 도넛 차트 (Chart.js Doughnut)
   ════════════════════════════════════════ */
(function initSpaceUsageChart() {
    const labels = ${spaceLabelsJson};
    const counts = ${spaceCountsJson};

    /* 공간 수에 맞춰 색상 팔레트 생성 */
    const palette = [
        '#0d6efd','#198754','#fd7e14','#6f42c1',
        '#0dcaf0','#ffc107','#d63384','#20c997'
    ];
    const colors = labels.map((_, i) => palette[i % palette.length]);

    new Chart(document.getElementById('spaceUsageChart'), {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: counts,
                backgroundColor: colors,
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { font: { size: 11 }, padding: 8 }
                },
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.label + ': ' + ctx.parsed + '건'
                    }
                }
            },
            cutout: '60%'
        }
    });
})();


/* ════════════════════════════════════════
   ③ 요일별 예약 히트맵 — 달력 그리드 동적 렌더링
   ════════════════════════════════════════ */
(function initHeatmap() {
    /* 서버에서 넘어온 히트맵 원본 데이터
       형식: [{weeknum: 1, dayofweek: 2, reservecnt: 5}, ...] */
    const raw = ${heatmapJson};

    /* 최대 예약 건수 계산 (색상 강도 기준) */
    const maxCnt = raw.reduce((m, d) => Math.max(m, Number(d.reservecnt || 0)), 0);

    /* weeknum·dayofweek → 예약건수 맵으로 변환 */
    const map = {};
    raw.forEach(d => {
        map[d.weeknum + '-' + d.dayofweek] = Number(d.reservecnt || 0);
    });

    /* 최대 주차 파악 */
    const maxWeek = raw.reduce((m, d) => Math.max(m, Number(d.weeknum || 0)), 0) || 5;

    /* 예약 건수에 따른 heat 레벨 결정 (0~5) */
    function heatLevel(cnt) {
        if (!cnt) return 0;
        const ratio = cnt / maxCnt;
        if (ratio <= 0.2) return 1;
        if (ratio <= 0.4) return 2;
        if (ratio <= 0.6) return 3;
        if (ratio <= 0.8) return 4;
        return 5;
    }

    /* 그리드 HTML 생성: 주(행) × 요일(열) */
    const grid = document.getElementById('heatmapGrid');
    let html = '';
    for (let w = 1; w <= maxWeek; w++) {
        html += '<div class="heatmap-grid mb-1">';
        for (let d = 1; d <= 7; d++) {
            const cnt = map[w + '-' + d] || 0;
            const level = heatLevel(cnt);
            /* 툴팁: 요일명 + 예약 건수 표시 */
            const dayNames = ['', '일', '월', '화', '수', '목', '금', '토'];
            html +=
                '<div class="heatmap-cell heat-' + level + '"' +
                ' title="' + w + '주차 ' + dayNames[d] + '요일: ' + cnt + '건">' +
                '</div>';
        }
        html += '</div>';
    }

    if (raw.length === 0) {
        /* 데이터가 없을 때 빈 그리드 표시 */
        html = '<div class="text-center text-muted py-3">';
        html += '<i class="bi bi-calendar3 d-block mb-1 fs-4"></i>이번달 예약 데이터가 없습니다.';
        html += '</div>';
    }

    grid.innerHTML = html;

    /* 이번달 총 예약 건수 안내 문구 */
    const total = raw.reduce((s, d) => s + Number(d.reservecnt || 0), 0);
    const now   = new Date();
    document.getElementById('heatmapCaption').textContent =
        now.getFullYear() + '년 ' + (now.getMonth()+1) + '월 총 ' + total + '건의 예약';
})();

</script>
</body>
</html>

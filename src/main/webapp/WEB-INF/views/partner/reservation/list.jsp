<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파트너 예약 관리 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        body { background-color: #f4f6f9; }

        /* ── 사이드바 ── */
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #1a3a5c 0%, #0d2137 100%); position: sticky; top: 0; }
        .sidebar .nav-link { color: rgba(255,255,255,.75); padding: 10px 20px; border-radius: 6px; margin: 2px 8px; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right: 8px; }
        .sidebar-brand { color: #fff; font-size: 1.2rem; font-weight: 700; padding: 20px; border-bottom: 1px solid rgba(255,255,255,.1); }

        /* ── 레이아웃 ── */
        .main-content { padding: 24px; }
        .page-header { background: #fff; border-radius: 10px; padding: 20px 24px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06); }

        /* ── 요약 카드 ── */
        .summary-card { background: #fff; border-radius: 10px; padding: 18px 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06); border-left: 4px solid transparent; }
        .summary-card .num { font-size: 1.7rem; font-weight: 700; }
        .summary-card .lbl { font-size: .78rem; color: #6c757d; margin-top: 2px; }
        .card-blue   { border-left-color: #0d6efd; }
        .card-green  { border-left-color: #198754; }
        .card-yellow { border-left-color: #ffc107; }
        .card-red    { border-left-color: #dc3545; }

        /* ── 탭 ── */
        .tab-bar { background: #fff; border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; box-shadow: 0 1px 4px rgba(0,0,0,.06); display: flex; gap: 8px; }

        /* ── 필터·테이블 카드 ── */
        .filter-card, .table-card { background: #fff; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .filter-card { padding: 16px 20px; margin-bottom: 16px; }
        .table-card  { overflow: hidden; }
        .table thead th { background: #f8f9fa; font-size: .82rem; font-weight: 600; color: #495057; white-space: nowrap; }
        .table tbody tr:hover { background: #f0f4ff; cursor: default; }

        /* ── 상태 배지 ── */
        .badge-pending   { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #dbeafe; color: #1d4ed8; }
        .badge-using     { background: #d1fae5; color: #065f46; }
        .badge-completed { background: #e5e7eb; color: #374151; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }

        /* ── 모달 내부 ── */
        .detail-section { background: #f8f9fa; border-radius: 8px; padding: 14px 18px; margin-bottom: 12px; }
        .detail-section .section-title { font-size: .8rem; font-weight: 700; color: #6c757d; text-transform: uppercase; letter-spacing: .05em; margin-bottom: 10px; }
        .detail-row { display: flex; gap: 8px; margin-bottom: 6px; font-size: .875rem; }
        .detail-label { color: #6c757d; flex-shrink: 0; width: 100px; }
        .detail-value { font-weight: 500; word-break: break-all; }

        /* ── 캘린더 ── */
        #calendarEl { max-width: 900px; margin: 0 auto; }

        /* ── 매출 ── */
        .revenue-card { background: #fff; border-radius: 10px; padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06); margin-bottom: 16px; }
        .revenue-total-card { background: linear-gradient(135deg, #1a3a5c, #0d6efd); color: #fff; border-radius: 10px; padding: 20px; box-shadow: 0 2px 8px rgba(13,110,253,.3); }
        .revenue-total-card .lbl { font-size: .8rem; opacity: .8; }
        .revenue-total-card .num { font-size: 1.5rem; font-weight: 700; }

        /* ── 알림 ── */
        .alert-flash { position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 280px; }

        /* ── 별점 ── */
        .star-rating i { font-size: 1rem; }
        .star-on  { color: #ffc107; }
        .star-off { color: #dee2e6; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ════════════════════════════════
         파트너 사이드바
         ════════════════════════════════ -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-shop me-2"></i>파트너 센터</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">파트너 메뉴</span>
            <a class="nav-link active" href="${ctx}/partner/reservation/list">
                <i class="bi bi-calendar2-check"></i>예약 관리
            </a>
            <a class="nav-link" href="${ctx}/partner/register/step1">
                <i class="bi bi-building-add"></i>공간/오피스 관리
            </a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/partner/mypage">
                <i class="bi bi-person-circle"></i>파트너 마이페이지
            </a>
        </nav>
    </div>

    <!-- ════════════════════════════════
         메인 콘텐츠
         ════════════════════════════════ -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-calendar2-check me-2 text-primary"></i>파트너 예약 관리</h5>
                <small class="text-muted">내 공간의 예약 현황을 조회하고 정산 내역을 확인합니다.</small>
            </div>
            <span class="small text-muted">총 <strong>${totalRecord}</strong>건</span>
        </div>

        <!-- 플래시 알림 -->
        <c:if test="${not empty alertMsg}">
            <div class="alert-flash">
                <div class="alert alert-${not empty alertType ? alertType : 'info'} alert-dismissible shadow-sm" role="alert">
                    <i class="bi bi-check-circle me-2"></i>${alertMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- ── 요약 카드 4개 ── -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="summary-card card-blue">
                    <div class="num text-primary">${summary.todayCnt}</div>
                    <div class="lbl">오늘 예약</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="summary-card card-green">
                    <div class="num text-success">${summary.monthCnt}</div>
                    <div class="lbl">이번달 예약</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="summary-card card-yellow">
                    <div class="num text-warning">
                        ₩ <fmt:formatNumber value="${summary.monthRevenue}" pattern="#,###"/>
                    </div>
                    <div class="lbl">이번달 매출</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="summary-card card-red">
                    <div class="num text-danger">${summary.cancelCnt}</div>
                    <div class="lbl">이번달 취소</div>
                </div>
            </div>
        </div>

        <!-- ── 탭 버튼 ── -->
        <div class="tab-bar">
            <button id="list-tab-btn"     class="btn btn-sm" onclick="showTab('list')">
                <i class="bi bi-list-ul me-1"></i>예약 목록
            </button>
            <button id="calendar-tab-btn" class="btn btn-sm" onclick="showTab('calendar')">
                <i class="bi bi-calendar3 me-1"></i>캘린더 뷰
            </button>
            <button id="revenue-tab-btn"  class="btn btn-sm" onclick="showTab('revenue')">
                <i class="bi bi-bar-chart-line me-1"></i>정산/매출
            </button>
        </div>

        <!-- ══════════════════════════════════════════════
             탭 1: 예약 목록
             ══════════════════════════════════════════════ -->
        <div id="list-tab-content">

            <!-- 필터 폼 -->
            <div class="filter-card mb-3">
                <form method="get" action="${ctx}/partner/reservation/list" id="filterForm" class="row g-2 align-items-end">
                    <input type="hidden" name="tab" value="list">
                    <input type="hidden" name="nowPage" value="1">

                    <div class="col-auto">
                        <label class="form-label small mb-1">시작일</label>
                        <input type="date" name="startDate" value="${searchVO.startDate}"
                               class="form-control form-control-sm">
                    </div>
                    <div class="col-auto">
                        <label class="form-label small mb-1">종료일</label>
                        <input type="date" name="endDate" value="${searchVO.endDate}"
                               class="form-control form-control-sm">
                    </div>
                    <div class="col-auto">
                        <label class="form-label small mb-1">예약 상태</label>
                        <select name="statusFilter" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <option value="PENDING"   ${searchVO.statusFilter == 'PENDING'   ? 'selected':''}>대기중</option>
                            <option value="CONFIRMED" ${searchVO.statusFilter == 'CONFIRMED' ? 'selected':''}>확정</option>
                            <option value="USING"     ${searchVO.statusFilter == 'USING'     ? 'selected':''}>이용중</option>
                            <option value="COMPLETED" ${searchVO.statusFilter == 'COMPLETED' ? 'selected':''}>완료</option>
                            <option value="CANCELLED" ${searchVO.statusFilter == 'CANCELLED' ? 'selected':''}>취소</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <label class="form-label small mb-1">공간</label>
                        <select name="spaceFilter" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <c:forEach var="sp" items="${spaceList}">
                                <option value="${sp.spcIdx}" ${searchVO.spaceFilter == sp.spcIdx ? 'selected':''}>
                                    ${sp.spcName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col">
                        <label class="form-label small mb-1">예약자 검색</label>
                        <input type="text" name="searchWord" value="${searchVO.searchWord}"
                               class="form-control form-control-sm" placeholder="예약자 이름">
                    </div>
                    <div class="col-auto">
                        <label class="form-label small mb-1">페이지당</label>
                        <select name="numPerPage" class="form-select form-select-sm"
                                onchange="document.getElementById('filterForm').submit()">
                            <option value="10"  ${numPerPage == 10  ? 'selected':''}>10건</option>
                            <option value="20"  ${numPerPage == 20  ? 'selected':''}>20건</option>
                            <option value="50"  ${numPerPage == 50  ? 'selected':''}>50건</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search me-1"></i>검색
                        </button>
                        <a href="${ctx}/partner/reservation/list" class="btn btn-outline-secondary btn-sm ms-1">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                        </a>
                    </div>
                </form>
            </div>

            <!-- 목록 테이블 -->
            <div class="table-card">
                <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
                    <span class="small text-muted">
                        총 <strong>${totalRecord}</strong>건
                        <c:if test="${not empty searchVO.searchWord}">
                            (검색: <strong>${searchVO.searchWord}</strong>)
                        </c:if>
                    </span>
                    <span class="small text-muted">${nowPage} / ${totalPage} 페이지</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">예약번호</th>
                                <th>예약자명</th>
                                <th>공간명</th>
                                <th>이용시간</th>
                                <th class="text-end pe-3">결제금액</th>
                                <th class="text-center">상태</th>
                                <th class="text-center">상세보기</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                        조회된 예약이 없습니다.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="r" items="${list}">
                                <tr>
                                    <td class="ps-4">
                                        <span class="text-muted small">${r.resCode}</span>
                                    </td>
                                    <td><strong>${r.userName}</strong></td>
                                    <td>
                                        <div>${r.spcName}</div>
                                        <small class="text-muted">${r.brnName}</small>
                                    </td>
                                    <td>
                                        <small>${r.resStartTime}</small><br>
                                        <small class="text-muted">~ ${r.resEndTime}</small>
                                    </td>
                                    <td class="text-end pe-3">
                                        <strong>
                                            ₩ <fmt:formatNumber value="${r.resTotalPrice}" pattern="#,###"/>
                                        </strong>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.resStatus == 'PENDING'}">
                                                <span class="badge badge-pending px-2 py-1 rounded-pill">대기중</span>
                                                <div class="mt-1 d-flex gap-1 justify-content-center">
                                                    <button class="btn btn-success btn-sm py-0 px-2"
                                                            onclick="confirmRes(${r.resIdx}, this)">
                                                        <i class="bi bi-check-lg"></i> 수락
                                                    </button>
                                                    <button class="btn btn-outline-danger btn-sm py-0 px-2"
                                                            onclick="openRejectModal(${r.resIdx})">
                                                        <i class="bi bi-x-lg"></i> 거절
                                                    </button>
                                                </div>
                                            </c:when>
                                            <c:when test="${r.resStatus == 'CONFIRMED'}">
                                                <span class="badge badge-confirmed px-2 py-1 rounded-pill">확정</span>
                                            </c:when>
                                            <c:when test="${r.resStatus == 'USING'}">
                                                <span class="badge badge-using px-2 py-1 rounded-pill">이용중</span>
                                            </c:when>
                                            <c:when test="${r.resStatus == 'COMPLETED'}">
                                                <span class="badge badge-completed px-2 py-1 rounded-pill">완료</span>
                                            </c:when>
                                            <c:when test="${r.resStatus == 'CANCELLED'}">
                                                <span class="badge badge-cancelled px-2 py-1 rounded-pill">취소</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary px-2 py-1 rounded-pill">${r.resStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-outline-primary btn-sm py-0 px-2"
                                                onclick="openDetail(${r.resIdx})">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이징 -->
                <div class="p-3 d-flex justify-content-center">
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <c:if test="${beginBlock > 1}">
                                <li class="page-item">
                                    <a class="page-link"
                                       href="${ctx}/partner/reservation/list?nowPage=${beginBlock-1}&numPerPage=${numPerPage}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}&tab=list">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                                <li class="page-item ${nowPage == p ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${ctx}/partner/reservation/list?nowPage=${p}&numPerPage=${numPerPage}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}&tab=list">
                                        ${p}
                                    </a>
                                </li>
                            </c:forEach>
                            <c:if test="${endBlock < totalPage}">
                                <li class="page-item">
                                    <a class="page-link"
                                       href="${ctx}/partner/reservation/list?nowPage=${endBlock+1}&numPerPage=${numPerPage}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}&tab=list">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div><!-- /list-tab-content -->

        <!-- ══════════════════════════════════════════════
             탭 2: 캘린더 뷰
             ══════════════════════════════════════════════ -->
        <div id="calendar-tab-content" style="display:none;">
            <div class="revenue-card">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <p class="small text-muted mb-0">
                        <i class="bi bi-info-circle me-1"></i>
                        날짜 또는 이벤트를 클릭하면 해당 날짜의 예약 목록으로 이동합니다.
                    </p>
                </div>
                <!-- 공간별 색상 범례 -->
                <div id="calendarLegend" class="d-flex flex-wrap gap-3 mb-3"></div>
                <div id="calendarEl"></div>
            </div>
        </div>

        <!-- ══════════════════════════════════════════════
             탭 3: 정산/매출
             ══════════════════════════════════════════════ -->
        <div id="revenue-tab-content" style="display:none;">

            <!-- 조회 조건 -->
            <div class="revenue-card mb-3">
                <div class="d-flex flex-wrap gap-2 align-items-center">
                    <!-- 기간 유형 토글 -->
                    <div class="btn-group btn-group-sm">
                        <button class="btn btn-primary"         id="pt-daily"   onclick="setPeriodType('daily')">일별</button>
                        <button class="btn btn-outline-primary" id="pt-weekly"  onclick="setPeriodType('weekly')">주별</button>
                        <button class="btn btn-outline-primary" id="pt-monthly" onclick="setPeriodType('monthly')">월별</button>
                    </div>
                    <div class="vr mx-1"></div>
                    <!-- 빠른 선택 -->
                    <button class="btn btn-outline-secondary btn-sm" onclick="setPreset('thisMonth')">이번달</button>
                    <button class="btn btn-outline-secondary btn-sm" onclick="setPreset('lastMonth')">지난달</button>
                    <button class="btn btn-outline-secondary btn-sm" onclick="setPreset('3months')">최근 3개월</button>
                    <button class="btn btn-outline-secondary btn-sm" onclick="setPreset('thisYear')">올해</button>
                    <div class="vr mx-1"></div>
                    <!-- 직접 입력 -->
                    <input type="date" id="revStartDate" class="form-control form-control-sm" style="width:150px;">
                    <span class="text-muted small">~</span>
                    <input type="date" id="revEndDate"   class="form-control form-control-sm" style="width:150px;">
                    <button class="btn btn-primary btn-sm" onclick="loadRevenue()">
                        <i class="bi bi-search me-1"></i>조회
                    </button>
                </div>
            </div>

            <!-- 요약 카드 4개 -->
            <div class="row g-3 mb-3">
                <div class="col-md-3">
                    <div class="revenue-total-card text-center">
                        <div class="lbl">총 매출</div>
                        <div class="num" id="totalRevenueTxt">-</div>
                        <div class="lbl mt-1" id="totalCntTxt">조회 대기</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="revenue-total-card text-center" style="background:linear-gradient(135deg,#dc3545,#a71d2a);">
                        <div class="lbl">플랫폼 수수료 (10%)</div>
                        <div class="num" id="feeTxt">-</div>
                        <div class="lbl mt-1">차감 금액</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="revenue-total-card text-center" style="background:linear-gradient(135deg,#198754,#0d5c37);">
                        <div class="lbl">정산 예정 금액 (90%)</div>
                        <div class="num" id="netRevenueTxt">-</div>
                        <div class="lbl mt-1">받을 금액</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="revenue-total-card text-center" style="background:linear-gradient(135deg,#6f42c1,#4a2a8a);">
                        <div class="lbl">예약 건수</div>
                        <div class="num" id="revCntTxt">-</div>
                        <div class="lbl mt-1">취소 제외</div>
                    </div>
                </div>
            </div>

            <!-- 기간별 매출 차트 -->
            <div class="revenue-card mb-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold mb-0">
                        <i class="bi bi-bar-chart me-1 text-primary"></i>
                        <span id="chartTitle">일별 매출 현황</span>
                    </h6>
                    <span class="small text-muted" id="revPeriodLabel"></span>
                </div>
                <div id="revNoData" class="text-center py-5 text-muted" style="display:none;">
                    <i class="bi bi-bar-chart fs-2 d-block mb-2 opacity-25"></i>
                    해당 기간 매출 데이터가 없습니다.
                </div>
                <canvas id="revenueChart"></canvas>
            </div>

            <!-- 공간별 매출 비교 차트 -->
            <div class="revenue-card mb-3">
                <h6 class="fw-bold mb-3">
                    <i class="bi bi-buildings me-1 text-success"></i>공간별 매출 비교
                </h6>
                <div id="spaceNoData" class="text-center py-4 text-muted">
                    <i class="bi bi-building fs-2 d-block mb-2 opacity-25"></i>
                    데이터가 없습니다.
                </div>
                <canvas id="spaceChart" style="display:none;"></canvas>
            </div>

            <!-- 수수료 차감 내역 테이블 -->
            <div class="table-card mb-3">
                <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold mb-0">
                        <i class="bi bi-receipt me-1 text-warning"></i>공간별 수수료 차감 내역
                    </h6>
                    <span class="badge bg-warning text-dark">플랫폼 수수료 10%</span>
                </div>
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">공간명</th>
                                <th>유형</th>
                                <th class="text-center">예약 건수</th>
                                <th class="text-end">총 매출액</th>
                                <th class="text-end text-danger">수수료 (10%)</th>
                                <th class="text-end pe-4 text-success">정산 예정액 (90%)</th>
                            </tr>
                        </thead>
                        <tbody id="revenueSpaceTbody">
                            <tr><td colspan="6" class="text-center py-4 text-muted">
                                조회 버튼을 눌러 데이터를 불러오세요.
                            </td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /revenue-tab-content -->

    </div><!-- /main-content -->
</div>
</div>

<!-- ════════════════════════════════
     상세 모달
     ════════════════════════════════ -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title fw-bold" id="detailModalLabel">
                    <i class="bi bi-calendar2-check me-2 text-primary"></i>예약 상세 정보
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">

                <!-- 예약 기본 정보 -->
                <div class="detail-section">
                    <div class="section-title"><i class="bi bi-info-circle me-1"></i>예약 정보</div>
                    <div class="detail-row">
                        <span class="detail-label">예약번호</span>
                        <span class="detail-value" id="d-resCode">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">예약 상태</span>
                        <span class="detail-value" id="d-resStatus">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">이용 시작</span>
                        <span class="detail-value" id="d-resStart">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">이용 종료</span>
                        <span class="detail-value" id="d-resEnd">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">인원</span>
                        <span class="detail-value" id="d-resHeadcount">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">예약 일시</span>
                        <span class="detail-value" id="d-resCreated">-</span>
                    </div>
                </div>

                <!-- 예약자 정보 -->
                <div class="detail-section">
                    <div class="section-title"><i class="bi bi-person me-1"></i>예약자 정보</div>
                    <div class="detail-row">
                        <span class="detail-label">이름</span>
                        <span class="detail-value" id="d-userName">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">연락처</span>
                        <span class="detail-value" id="d-userPhone">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">이메일</span>
                        <span class="detail-value" id="d-userEmail">-</span>
                    </div>
                </div>

                <!-- 공간 정보 -->
                <div class="detail-section">
                    <div class="section-title"><i class="bi bi-building me-1"></i>공간 정보</div>
                    <div class="detail-row">
                        <span class="detail-label">지점명</span>
                        <span class="detail-value" id="d-brnName">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">공간명</span>
                        <span class="detail-value" id="d-spcName">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">공간 유형</span>
                        <span class="detail-value" id="d-spcType">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">기본 요금</span>
                        <span class="detail-value" id="d-spcPrice">-</span>
                    </div>
                </div>

                <!-- 결제 정보 -->
                <div class="detail-section">
                    <div class="section-title"><i class="bi bi-credit-card me-1"></i>결제 정보</div>
                    <div class="detail-row">
                        <span class="detail-label">총 결제금액</span>
                        <span class="detail-value fw-bold text-primary" id="d-totalPrice">-</span>
                    </div>
                </div>

                <!-- 취소 사유 (취소 시에만 표시) -->
                <div class="detail-section" id="d-cancelSection" style="display:none;">
                    <div class="section-title"><i class="bi bi-x-circle me-1 text-danger"></i>취소 사유</div>
                    <div class="detail-row">
                        <span class="detail-value" id="d-resContent">-</span>
                    </div>
                </div>

                <!-- 리뷰 정보 (리뷰 있을 때만) -->
                <div class="detail-section" id="d-reviewSection" style="display:none;">
                    <div class="section-title"><i class="bi bi-star me-1 text-warning"></i>고객 리뷰</div>
                    <div class="detail-row">
                        <span class="detail-label">별점</span>
                        <span class="detail-value star-rating" id="d-revRating">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">리뷰 내용</span>
                        <span class="detail-value" id="d-revContent">-</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">작성일</span>
                        <span class="detail-value" id="d-revCreatedAt">-</span>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <div id="modal-action-area" class="me-auto d-flex gap-2" style="display:none!important;">
                    <button id="btn-modal-confirm" class="btn btn-success btn-sm"
                            onclick="confirmRes(currentResIdx, null)">
                        <i class="bi bi-check-circle me-1"></i>예약 수락
                    </button>
                    <button id="btn-modal-reject" class="btn btn-outline-danger btn-sm"
                            onclick="openRejectModal(currentResIdx)">
                        <i class="bi bi-x-circle me-1"></i>예약 거절
                    </button>
                </div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-lg me-1"></i>닫기
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 거절 사유 입력 모달 -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0">
                <h6 class="modal-title text-danger fw-bold">
                    <i class="bi bi-x-circle me-1"></i>예약 거절
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted small mb-2">거절 후에는 되돌릴 수 없습니다.</p>
                <label class="form-label small fw-semibold">거절 사유</label>
                <textarea id="rejectReason" class="form-control form-control-sm" rows="3"
                          placeholder="예약자에게 전달될 거절 사유를 입력하세요"></textarea>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger btn-sm" onclick="submitReject()">
                    <i class="bi bi-x-circle me-1"></i>거절 확정
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const ctx = '${ctx}';

/* ──────────────────────────────────────
   예약 수락 / 거절
────────────────────────────────────── */
let currentResIdx  = null;   // 현재 액션 대상 예약 번호
let rejectModalInst = null;  // 거절 모달 인스턴스

function confirmRes(resIdx, btnEl) {
    if (!confirm('이 예약을 수락하시겠습니까?')) return;
    if (btnEl) btnEl.disabled = true;
    fetch(ctx + '/partner/reservation/confirm', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'resIdx=' + resIdx
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        alert(data.message);
        if (data.success) {
            // 상세 모달이 열려 있으면 닫고 새로고침
            var dm = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
            if (dm) dm.hide();
            location.reload();
        } else if (btnEl) {
            btnEl.disabled = false;
        }
    })
    .catch(function() {
        alert('처리 중 오류가 발생했습니다.');
        if (btnEl) btnEl.disabled = false;
    });
}

function openRejectModal(resIdx) {
    currentResIdx = resIdx;
    document.getElementById('rejectReason').value = '';
    if (!rejectModalInst) {
        rejectModalInst = new bootstrap.Modal(document.getElementById('rejectModal'));
    }
    rejectModalInst.show();
}

function submitReject() {
    var reason = document.getElementById('rejectReason').value.trim();
    fetch(ctx + '/partner/reservation/reject', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'resIdx=' + currentResIdx + '&reason=' + encodeURIComponent(reason)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        rejectModalInst.hide();
        alert(data.message);
        if (data.success) {
            var dm = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
            if (dm) dm.hide();
            location.reload();
        }
    })
    .catch(function() { alert('처리 중 오류가 발생했습니다.'); });
}

/* ──────────────────────────────────────
   탭 초기화
────────────────────────────────────── */
const TABS = ['list', 'calendar', 'revenue'];

function showTab(tab) {
    TABS.forEach(function(t) {
        const content = document.getElementById(t + '-tab-content');
        const btn     = document.getElementById(t + '-tab-btn');
        if (content) content.style.display = (t === tab) ? '' : 'none';
        if (btn) {
            btn.classList.toggle('btn-primary',           t === tab);
            btn.classList.toggle('btn-outline-secondary', t !== tab);
        }
    });
    if (tab === 'calendar' && !calendarInitialized) initCalendar();
    if (tab === 'revenue') loadRevenue();
}

/* 날짜 입력 기본값(이번달) 먼저 세팅 후 탭 초기화 */
(function() {
    setPreset('thisMonth');   /* revStartDate / revEndDate 초기화 */
    var urlTab = '${tab}';
    showTab(['list','calendar','revenue'].indexOf(urlTab) >= 0 ? urlTab : 'list');
})();

/* ──────────────────────────────────────
   FullCalendar  (공간별 색상 구분)
────────────────────────────────────── */
const SPACE_PALETTE = [
    '#0d6efd','#198754','#dc3545','#fd7e14',
    '#6f42c1','#20c997','#e83e8c','#0dcaf0'
];

let calendarInitialized = false;
let fcInstance          = null;

/* 공간 idx → 색상 매핑 (월이 바뀌어도 같은 공간은 같은 색 유지) */
var spaceColorMap = {};
var spaceColorIdx = 0;

function getSpaceColor(spcIdx) {
    if (spaceColorMap[spcIdx] === undefined) {
        spaceColorMap[spcIdx] = SPACE_PALETTE[spaceColorIdx % SPACE_PALETTE.length];
        spaceColorIdx++;
    }
    return spaceColorMap[spcIdx];
}

function updateCalendarLegend(spaceNames) {
    var legend = document.getElementById('calendarLegend');
    legend.innerHTML = '';
    Object.keys(spaceNames).forEach(function(spcIdx) {
        var dot = document.createElement('div');
        dot.className = 'd-flex align-items-center gap-1 small';
        dot.innerHTML =
            '<span style="width:11px;height:11px;border-radius:3px;display:inline-block;background:'
            + getSpaceColor(spcIdx) + '"></span>'
            + '<span>' + spaceNames[spcIdx] + '</span>';
        legend.appendChild(dot);
    });
}

function initCalendar() {
    var calendarEl = document.getElementById('calendarEl');
    fcInstance = new FullCalendar.Calendar(calendarEl, {
        initialView:   'dayGridMonth',
        locale:        'ko',
        height:        'auto',
        fixedWeekCount: false,
        headerToolbar: {
            left:   'prev,next today',
            center: 'title',
            right:  ''
        },
        buttonText: { today: '오늘' },
        /* ── 이벤트 소스: fetchInfo 의 중간값으로 표시 월 계산 ── */
        events: function(fetchInfo, successCallback, failureCallback) {
            var mid   = new Date((fetchInfo.start.getTime() + fetchInfo.end.getTime()) / 2);
            var year  = mid.getFullYear();
            var month = mid.getMonth() + 1;

            fetch(ctx + '/partner/reservation/calendar?year=' + year + '&month=' + month)
                .then(function(r) {
                    if (!r.ok) throw new Error('network');
                    return r.json();
                })
                .then(function(rows) {
                    /* 공간명 수집 → 범례 업데이트 */
                    var spaceNames = {};
                    rows.forEach(function(row) { spaceNames[row.spcIdx] = row.spcName; });
                    updateCalendarLegend(spaceNames);

                    /* FullCalendar 이벤트 배열 생성 */
                    var events = rows.map(function(row) {
                        var color = getSpaceColor(row.spcIdx);
                        return {
                            title:           row.spcName + ' ' + row.eventCnt + '건',
                            start:           row.eventDate,
                            backgroundColor: color,
                            borderColor:     color,
                            textColor:       '#fff',
                            extendedProps:   { date: row.eventDate }
                        };
                    });
                    successCallback(events);
                })
                .catch(function() { failureCallback(); });
        },
        /* 날짜 클릭 → 해당일 목록 */
        dateClick: function(info) {
            location.href = ctx + '/partner/reservation/list?startDate='
                          + info.dateStr + '&endDate=' + info.dateStr + '&tab=list';
        },
        /* 이벤트 클릭 → 해당일 목록 */
        eventClick: function(info) {
            var d = info.event.extendedProps.date;
            location.href = ctx + '/partner/reservation/list?startDate='
                          + d + '&endDate=' + d + '&tab=list';
        }
    });
    fcInstance.render();
    calendarInitialized = true;
}

/* ──────────────────────────────────────
   정산/매출
────────────────────────────────────── */
var revenueChart     = null;
var spaceChart       = null;
var currentPeriodType = 'daily';

function fmtNum(n) {
    return '₩ ' + Number(n || 0).toLocaleString('ko-KR');
}

function fmt2(d) {   /* Date → "YYYY-MM-DD" */
    return d.getFullYear() + '-'
         + String(d.getMonth() + 1).padStart(2, '0') + '-'
         + String(d.getDate()).padStart(2, '0');
}

function setPreset(preset) {
    var now = new Date(), y = now.getFullYear(), m = now.getMonth();
    var s, e;
    if      (preset === 'thisMonth')  { s = new Date(y, m,   1); e = new Date(y, m+1, 0); }
    else if (preset === 'lastMonth')  { s = new Date(y, m-1, 1); e = new Date(y, m,   0); }
    else if (preset === '3months')    { s = new Date(y, m-2, 1); e = new Date(y, m+1, 0); }
    else if (preset === 'thisYear')   { s = new Date(y, 0,   1); e = new Date(y, 11, 31); }
    document.getElementById('revStartDate').value = fmt2(s);
    document.getElementById('revEndDate').value   = fmt2(e);
}

function setPeriodType(type) {
    currentPeriodType = type;
    ['daily','weekly','monthly'].forEach(function(t) {
        var btn = document.getElementById('pt-' + t);
        if (!btn) return;
        btn.className = 'btn btn-sm ' + (t === type ? 'btn-primary' : 'btn-outline-primary');
    });
    var titles = { daily:'일별 매출 현황', weekly:'주별 매출 현황', monthly:'월별 매출 현황' };
    document.getElementById('chartTitle').textContent = titles[type] || '매출 현황';
    loadRevenue();
}

function loadRevenue() {
    var startDate = document.getElementById('revStartDate').value;
    var endDate   = document.getElementById('revEndDate').value;
    var label     = (startDate && endDate) ? startDate + ' ~ ' + endDate : '전체 기간';
    document.getElementById('revPeriodLabel').textContent = label;

    var url = ctx + '/partner/reservation/revenue?periodType=' + currentPeriodType;
    if (startDate) url += '&startDate=' + startDate;
    if (endDate)   url += '&endDate='   + endDate;

    fetch(url)
        .then(function(r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        })
        .then(function(data) { renderRevenue(data); })
        .catch(function(err) {
            console.error('revenue error:', err);
            document.getElementById('totalRevenueTxt').textContent = '오류';
        });
}

function renderRevenue(data) {
    /* 요약 카드 */
    var total = Number(data.totalRevenue) || 0;
    var cnt   = Number(data.totalCnt)     || 0;
    var fee   = Math.round(total * 0.1);
    var net   = Number(data.feeRevenue)   || Math.round(total * 0.9);

    document.getElementById('totalRevenueTxt').textContent = fmtNum(total);
    document.getElementById('totalCntTxt').textContent     = cnt + '건';
    document.getElementById('feeTxt').textContent          = fmtNum(fee);
    document.getElementById('netRevenueTxt').textContent   = fmtNum(net);
    document.getElementById('revCntTxt').textContent       = cnt + '건';

    /* ── 기간별 차트 ── */
    var byPeriod = data.byPeriod || [];
    var canvas   = document.getElementById('revenueChart');
    var noData   = document.getElementById('revNoData');

    if (revenueChart) { revenueChart.destroy(); revenueChart = null; }

    if (byPeriod.length === 0) {
        canvas.style.display = 'none';
        noData.style.display = '';
    } else {
        noData.style.display = 'none';
        canvas.style.display = '';
        var labels = byPeriod.map(function(r) { return r.periodLabel || ''; });
        var values = byPeriod.map(function(r) { return Number(r.revenue) || 0; });
        revenueChart = new Chart(canvas, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '매출',
                    data: values,
                    backgroundColor: 'rgba(13,110,253,0.65)',
                    borderColor:     'rgba(13,110,253,1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(item) { return ' ' + fmtNum(item.parsed.y); }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: function(v) { return fmtNum(v); } }
                    }
                }
            }
        });
    }

    /* ── 공간별 비교 차트 ── */
    var bySpace     = data.bySpace || [];
    var sCanvas     = document.getElementById('spaceChart');
    var sNoData     = document.getElementById('spaceNoData');

    if (spaceChart) { spaceChart.destroy(); spaceChart = null; }

    if (bySpace.length === 0) {
        sCanvas.style.display = 'none';
        sNoData.style.display = '';
    } else {
        sNoData.style.display = 'none';
        sCanvas.style.display = '';
        var sLabels = bySpace.map(function(s) { return s.spcName || '-'; });
        var sValues = bySpace.map(function(s) { return Number(s.revenue) || 0; });
        var sColors = SPACE_PALETTE.slice(0, bySpace.length);
        spaceChart = new Chart(sCanvas, {
            type: 'bar',
            data: {
                labels: sLabels,
                datasets: [{
                    label: '매출',
                    data: sValues,
                    backgroundColor: sColors.map(function(c) { return c + 'bb'; }),
                    borderColor: sColors,
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                indexAxis: 'y',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(item) { return ' ' + fmtNum(item.parsed.x); }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: { callback: function(v) { return fmtNum(v); } }
                    }
                }
            }
        });
    }

    /* ── 수수료 테이블 ── */
    var tbody = document.getElementById('revenueSpaceTbody');
    tbody.innerHTML = '';
    if (bySpace.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">데이터가 없습니다.</td></tr>';
    } else {
        bySpace.forEach(function(sp) {
            var rev  = Number(sp.revenue) || 0;
            var spFee  = Math.round(rev * 0.1);
            var spNet  = Math.round(rev * 0.9);
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td class="ps-4"><strong>' + (sp.spcName || '-') + '</strong></td>' +
                '<td><span class="badge bg-secondary">' + (sp.spcType || '-') + '</span></td>' +
                '<td class="text-center">' + (Number(sp.cnt) || 0) + '건</td>' +
                '<td class="text-end">' + fmtNum(rev) + '</td>' +
                '<td class="text-end text-danger">- ' + fmtNum(spFee) + '</td>' +
                '<td class="text-end pe-4 fw-bold text-success">' + fmtNum(spNet) + '</td>';
            tbody.appendChild(tr);
        });
    }
}

/* ──────────────────────────────────────
   상세 모달
────────────────────────────────────── */
function openDetail(resIdx) {
    fetch(ctx + '/partner/reservation/detail?resIdx=' + resIdx)
        .then(function(r) {
            if (!r.ok) { throw new Error('forbidden'); }
            return r.json();
        })
        .then(function(data) {
            populateModal(data);
            new bootstrap.Modal(document.getElementById('detailModal')).show();
        })
        .catch(function() {
            alert('상세 정보를 불러올 수 없습니다.');
        });
}

function statusLabel(s) {
    var map = { PENDING:'대기중', CONFIRMED:'확정', USING:'이용중', COMPLETED:'완료', CANCELLED:'취소' };
    return map[s] || s;
}
function statusClass(s) {
    var map = { PENDING:'badge-pending', CONFIRMED:'badge-confirmed', USING:'badge-using', COMPLETED:'badge-completed', CANCELLED:'badge-cancelled' };
    return map[s] || 'bg-secondary';
}
function buildStars(rating) {
    var html = '';
    for (var i = 1; i <= 5; i++) {
        html += '<i class="bi bi-star-fill ' + (i <= rating ? 'star-on' : 'star-off') + '"></i>';
    }
    return html;
}

function populateModal(d) {
    currentResIdx = d.resIdx;

    /* 수락/거절 버튼: PENDING 상태일 때만 표시 */
    var actionArea = document.getElementById('modal-action-area');
    if (d.resStatus === 'PENDING') {
        actionArea.style.removeProperty('display');
        actionArea.style.display = 'flex';
    } else {
        actionArea.style.display = 'none';
    }

    document.getElementById('d-resCode').textContent      = d.resCode      || '-';
    document.getElementById('d-resStart').textContent     = d.resStartTime || '-';
    document.getElementById('d-resEnd').textContent       = d.resEndTime   || '-';
    document.getElementById('d-resHeadcount').textContent = (d.resHeadcount || 0) + '명';
    document.getElementById('d-resCreated').textContent   = d.resCreated   || '-';
    document.getElementById('d-userName').textContent     = d.userName     || '-';
    document.getElementById('d-userPhone').textContent    = d.userPhone    || '-';
    document.getElementById('d-userEmail').textContent    = d.userEmail    || '-';
    document.getElementById('d-brnName').textContent      = d.brnName      || '-';
    document.getElementById('d-spcName').textContent      = d.spcName      || '-';
    document.getElementById('d-spcType').textContent      = d.spcType      || '-';
    document.getElementById('d-spcPrice').textContent     = d.spcPrice ? '₩ ' + Number(d.spcPrice).toLocaleString('ko-KR') : '-';
    document.getElementById('d-totalPrice').textContent   = d.resTotalPrice ? '₩ ' + Number(d.resTotalPrice).toLocaleString('ko-KR') : '-';

    /* 상태 배지 */
    var statusEl = document.getElementById('d-resStatus');
    statusEl.innerHTML = '<span class="badge ' + statusClass(d.resStatus) + ' px-2 py-1 rounded-pill">' + statusLabel(d.resStatus) + '</span>';

    /* 취소 사유 */
    var cancelSec = document.getElementById('d-cancelSection');
    if (d.resStatus === 'CANCELLED' && d.resContent) {
        document.getElementById('d-resContent').textContent = d.resContent;
        cancelSec.style.display = '';
    } else {
        cancelSec.style.display = 'none';
    }

    /* 리뷰 */
    var revSec = document.getElementById('d-reviewSection');
    if (d.revIdx && d.revIdx > 0) {
        document.getElementById('d-revRating').innerHTML  = buildStars(d.revRating);
        document.getElementById('d-revContent').textContent   = d.revContent   || '-';
        document.getElementById('d-revCreatedAt').textContent = d.revCreatedAt || '-';
        revSec.style.display = '';
    } else {
        revSec.style.display = 'none';
    }

    document.getElementById('detailModalLabel').innerHTML =
        '<i class="bi bi-calendar2-check me-2 text-primary"></i>예약 상세 - ' + (d.resCode || '');
}
</script>
</body>
</html>

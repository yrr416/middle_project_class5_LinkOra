<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        /* ── 사이드바 ── */
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position:sticky; top:0; }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        /* ── 레이아웃 ── */
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        /* ── 통계 카드 ── */
        .stat-card { background:#fff; border-radius:10px; padding:16px 20px; box-shadow:0 1px 4px rgba(0,0,0,.06); text-align:center; border-top:3px solid transparent; }
        .stat-card .num { font-size:1.6rem; font-weight:700; }
        .stat-card .lbl { font-size:.78rem; color:#6c757d; margin-top:2px; }
        .stat-pending   { border-top-color:#ffc107; }
        .stat-confirmed { border-top-color:#0d6efd; }
        .stat-using     { border-top-color:#20c997; }
        .stat-completed { border-top-color:#6c757d; }
        .stat-cancelled { border-top-color:#dc3545; }
        /* ── 필터·테이블 카드 ── */
        .filter-card, .table-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .filter-card { padding:16px 20px; margin-bottom:16px; }
        .table-card  { overflow:hidden; }
        .table thead th { background:#f8f9fa; font-size:.82rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; cursor:pointer; }
        /* ── 상태 배지 ── */
        .badge-pending   { background:#fff3cd; color:#856404; }
        .badge-confirmed { background:#dbeafe; color:#1d4ed8; }
        .badge-using     { background:#d1fae5; color:#065f46; }
        .badge-completed { background:#e5e7eb; color:#374151; }
        .badge-cancelled { background:#fee2e2; color:#991b1b; }
        /* ── 모달 내부 ── */
        .detail-section { background:#f8f9fa; border-radius:8px; padding:14px 18px; margin-bottom:12px; }
        .detail-section .section-title { font-size:.8rem; font-weight:700; color:#6c757d; text-transform:uppercase; letter-spacing:.05em; margin-bottom:10px; }
        .detail-row { display:flex; gap:8px; margin-bottom:6px; font-size:.875rem; }
        .detail-label { color:#6c757d; flex-shrink:0; width:90px; }
        .detail-value { font-weight:500; }
        /* ── 이력 타임라인 ── */
        .timeline { position:relative; padding-left:24px; }
        .timeline::before { content:''; position:absolute; left:7px; top:0; bottom:0; width:2px; background:#dee2e6; }
        .timeline-item { position:relative; margin-bottom:14px; }
        .timeline-dot { position:absolute; left:-21px; top:3px; width:12px; height:12px; border-radius:50%; background:#0d6efd; border:2px solid #fff; box-shadow:0 0 0 2px #0d6efd; }
        .timeline-dot.dot-cancel   { background:#dc3545; box-shadow:0 0 0 2px #dc3545; }
        .timeline-dot.dot-confirm  { background:#198754; box-shadow:0 0 0 2px #198754; }
        .timeline-dot.dot-complete { background:#6c757d; box-shadow:0 0 0 2px #6c757d; }
        .timeline-time { font-size:.75rem; color:#6c757d; }
        .timeline-text { font-size:.875rem; font-weight:500; }
        /* ── 취소 폼 영역 ── */
        #cancelForm { display:none; background:#fff3f3; border:1px solid #fcc; border-radius:8px; padding:16px; margin-top:12px; }
        /* ── 알림 토스트 ── */
        .alert-flash { position:fixed; top:20px; right:20px; z-index:9999; min-width:280px; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ════════════════════════════════
         사이드바
         ════════════════════════════════ -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <!-- 현재 페이지: 예약 관리 (active) -->
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- ════════════════════════════════
         메인 콘텐츠
         ════════════════════════════════ -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-calendar-check me-2 text-primary"></i>예약 관리</h5>
                <small class="text-muted">전체 예약 현황을 조회하고 상태를 관리합니다.</small>
            </div>
            <span class="small text-muted">총 <strong>${totalRecord}</strong>건</span>
        </div>

        <!-- ── 처리 결과 알림 (Flash Attribute) ─────────── -->
        <c:if test="${not empty alertMsg}">
            <div class="alert-flash">
                <div class="alert alert-${alertType} alert-dismissible shadow-sm" role="alert">
                    <i class="bi bi-check-circle me-2"></i>${alertMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- ── 통계 카드 (상태별 건수) ────────────────────
             날짜·공간 필터만 적용, 상태 필터 무시 → 전체 현황 표시 -->
        <div class="row g-3 mb-3">
            <div class="col">
                <div class="stat-card stat-pending">
                    <div class="num text-warning">${statusSummary['PENDING']}</div>
                    <div class="lbl">대기</div>
                </div>
            </div>
            <div class="col">
                <div class="stat-card stat-confirmed">
                    <div class="num text-primary">${statusSummary['CONFIRMED']}</div>
                    <div class="lbl">확정</div>
                </div>
            </div>
            <div class="col">
                <div class="stat-card stat-using">
                    <div class="num text-success">${statusSummary['USING']}</div>
                    <div class="lbl">이용중</div>
                </div>
            </div>
            <div class="col">
                <div class="stat-card stat-completed">
                    <div class="num text-secondary">${statusSummary['COMPLETED']}</div>
                    <div class="lbl">완료</div>
                </div>
            </div>
            <div class="col">
                <div class="stat-card stat-cancelled">
                    <div class="num text-danger">${statusSummary['CANCELLED']}</div>
                    <div class="lbl">취소</div>
                </div>
            </div>
        </div>

        <!-- ── 필터 영역 ──────────────────────────────────── -->
        <div class="filter-card">
            <form method="get" action="${ctx}/admin/reservation/list" class="row g-2 align-items-end">

                <!-- 날짜 범위 (시작) -->
                <div class="col-md-2">
                    <label class="form-label small mb-1">시작일</label>
                    <input type="date" name="startDate" class="form-control form-control-sm"
                           value="${searchVO.startDate}">
                </div>
                <!-- 날짜 범위 (종료) -->
                <div class="col-md-2">
                    <label class="form-label small mb-1">종료일</label>
                    <input type="date" name="endDate" class="form-control form-control-sm"
                           value="${searchVO.endDate}">
                </div>
                <!-- 상태 필터 -->
                <div class="col-md-2">
                    <label class="form-label small mb-1">예약 상태</label>
                    <select name="statusFilter" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <option value="PENDING"   ${searchVO.statusFilter == 'PENDING'   ? 'selected':''}>대기</option>
                        <option value="CONFIRMED" ${searchVO.statusFilter == 'CONFIRMED' ? 'selected':''}>확정</option>
                        <option value="USING"     ${searchVO.statusFilter == 'USING'     ? 'selected':''}>이용중</option>
                        <option value="COMPLETED" ${searchVO.statusFilter == 'COMPLETED' ? 'selected':''}>완료</option>
                        <option value="CANCELLED" ${searchVO.statusFilter == 'CANCELLED' ? 'selected':''}>취소</option>
                    </select>
                </div>
                <!-- 공간별 필터 -->
                <div class="col-md-2">
                    <label class="form-label small mb-1">공간</label>
                    <select name="spaceFilter" class="form-select form-select-sm">
                        <option value="">전체 공간</option>
                        <c:forEach var="sp" items="${spaceList}">
                            <option value="${sp.spcIdx}"
                                    ${searchVO.spaceFilter == sp.spcIdx.toString() ? 'selected':''}>
                                ${sp.spcName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <!-- 고객명 검색 -->
                <div class="col-md-2">
                    <label class="form-label small mb-1">고객명</label>
                    <input type="text" name="searchWord" class="form-control form-control-sm"
                           placeholder="고객명 검색" value="${searchVO.searchWord}">
                </div>
                <!-- 검색 버튼 -->
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary btn-sm me-1">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                    <a href="${ctx}/admin/reservation/list" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- ── 예약 목록 테이블 ───────────────────────────── -->
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
                            <th>고객명</th>
                            <th>공간</th>
                            <th>지점</th>
                            <th>예약 시간</th>
                            <th>인원</th>
                            <th>금액</th>
                            <th>상태</th>
                            <th class="text-center">상세</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty reservationList}">
                            <tr>
                                <td colspan="9" class="text-center py-5 text-muted">
                                    <i class="bi bi-calendar-x fs-3 d-block mb-2"></i>
                                    조회된 예약이 없습니다.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="r" items="${reservationList}">
                            <tr onclick="location.href='${ctx}/admin/reservation/view?resIdx=${r.resIdx}&nowPage=${nowPage}'" style="cursor:pointer;">
                                <td class="ps-4 text-muted">#${r.resIdx}</td>
                                <td>
                                    <div class="fw-semibold">${r.userName}</div>
                                    <div class="text-muted small">${r.userPhone}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold">${r.spcName}</div>
                                    <div class="text-muted small">${r.spcType}</div>
                                </td>
                                <td class="text-muted small">${r.brnName}</td>
                                <td>
                                    <div class="small">${r.resStartTime}</div>
                                    <div class="small text-muted">~ ${r.resEndTime}</div>
                                </td>
                                <td class="text-center">${r.resHeadcount}명</td>
                                <td>
                                    <strong>
                                        ₩ <fmt:formatNumber value="${r.resTotalPrice}" type="number"/>
                                    </strong>
                                </td>
                                <td>
                                    <%-- 예약 상태 배지 --%>
                                    <c:choose>
                                        <c:when test="${r.resStatus == 'PENDING'}">
                                            <span class="badge badge-pending px-2 py-1 rounded-pill">대기</span>
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
                                    </c:choose>
                                </td>
                                <td class="text-center" onclick="event.stopPropagation()">
                                    <a href="${ctx}/admin/reservation/view?resIdx=${r.resIdx}&nowPage=${nowPage}"
                                       class="btn btn-outline-primary btn-sm py-0 px-2">
                                        <i class="bi bi-eye"></i>
                                    </a>
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
                                   href="${ctx}/admin/reservation/list?nowPage=${beginBlock-1}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                            <li class="page-item ${nowPage == p ? 'active':''}">
                                <a class="page-link"
                                   href="${ctx}/admin/reservation/list?nowPage=${p}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${ctx}/admin/reservation/list?nowPage=${endBlock+1}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div><!-- /table-card -->

    </div><!-- /main-content -->
</div>
</div>


<!-- ════════════════════════════════════════════════
     예약 상세 모달
     - AJAX 로 /admin/reservation/detail?r_idx= 를 호출하여 데이터 로드
     - 이력 로그: r_created / r_updated 기반 타임라인 표시
     - 하단 액션 버튼: 예약 확정 / 완료 처리 / 강제 취소 (상태에 따라 표시)
     ════════════════════════════════════════════════ -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">

            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalLabel">
                    <i class="bi bi-calendar2-check me-2 text-primary"></i>예약 상세 정보
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- 모달 본문 -->
            <div class="modal-body">

                <!-- 로딩 스피너 (AJAX 대기 중 표시) -->
                <div id="modalLoading" class="text-center py-4">
                    <div class="spinner-border text-primary" role="status"></div>
                    <div class="mt-2 text-muted small">데이터 불러오는 중...</div>
                </div>

                <!-- 상세 내용 (AJAX 로드 후 표시) -->
                <div id="modalContent" style="display:none;">

                    <!-- ① 예약 기본 정보 -->
                    <div class="detail-section">
                        <div class="section-title"><i class="bi bi-info-circle me-1"></i>예약 정보</div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">예약번호</span>
                                    <span class="detail-value" id="d_r_idx"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">예약 상태</span>
                                    <span class="detail-value" id="d_r_status_badge"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">시작 일시</span>
                                    <span class="detail-value" id="d_r_start_time"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">종료 일시</span>
                                    <span class="detail-value" id="d_r_end_time"></span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">예약 인원</span>
                                    <span class="detail-value" id="d_r_headcount"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">예약 금액</span>
                                    <span class="detail-value fw-bold text-primary" id="d_r_total_price"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">메모/사유</span>
                                    <span class="detail-value text-muted" id="d_r_content"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ② 예약자 정보 -->
                    <div class="detail-section">
                        <div class="section-title"><i class="bi bi-person me-1"></i>예약자 정보</div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">이름</span>
                                    <span class="detail-value" id="d_u_name"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">이메일</span>
                                    <span class="detail-value" id="d_u_email"></span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">전화번호</span>
                                    <span class="detail-value" id="d_u_phone"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ③ 공간 정보 -->
                    <div class="detail-section">
                        <div class="section-title"><i class="bi bi-building me-1"></i>공간 정보</div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">공간명</span>
                                    <span class="detail-value" id="d_s_name"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">유형</span>
                                    <span class="detail-value" id="d_s_type"></span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <span class="detail-label">지점</span>
                                    <span class="detail-value" id="d_b_name"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">공간 단가</span>
                                    <span class="detail-value" id="d_s_price"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ④ 예약 이력 로그 (r_created / r_updated 기반 타임라인)
                         ⚠️ 별도 이력 로그 테이블 없으므로 접수·변경 시점만 표시
                            정확한 이력 관리가 필요하면 별도 reservation_log 테이블 추가 권장 -->
                    <div class="detail-section">
                        <div class="section-title"><i class="bi bi-clock-history me-1"></i>예약 이력 로그</div>
                        <div class="timeline" id="d_timeline"></div>
                    </div>

                    <!-- ⑤ 강제 취소 폼 (상태가 PENDING / CONFIRMED / USING 일 때만 표시) -->
                    <div id="cancelForm">
                        <div class="fw-semibold text-danger mb-2">
                            <i class="bi bi-exclamation-triangle me-1"></i>강제 취소 처리
                        </div>
                        <form method="post" action="${ctx}/admin/reservation/cancel" id="cancelFormTag">
                            <!-- 현재 필터 유지용 hidden 값은 JavaScript 에서 동적 추가 -->
                            <input type="hidden" name="resIdx"       id="cancel_r_idx">
                            <input type="hidden" name="nowPage"     value="${nowPage}">
                            <input type="hidden" name="startDate"  value="${searchVO.startDate}">
                            <input type="hidden" name="endDate"    value="${searchVO.endDate}">
                            <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">
                            <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">
                            <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">

                            <!-- 취소 사유 입력 (필수) -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">취소 사유 <span class="text-danger">*</span></label>
                                <textarea class="form-control form-control-sm" name="cancel_reason"
                                          id="cancelReason" rows="3"
                                          placeholder="취소 사유를 입력하세요." required></textarea>
                            </div>

                            <!-- 환불 금액 안내 -->
                            <div class="alert alert-info py-2 small mb-3">
                                <i class="bi bi-info-circle me-1"></i>
                                환불 예정 금액: <strong id="cancelRefundAmount"></strong>
                                <br>
                                <span class="text-muted">
                                    ⚠️ 실제 환불 처리는 결제 시스템과 별도 연동이 필요합니다.
                                </span>
                            </div>

                            <!-- 환불 처리 완료 확인 체크박스 (관리자 수동 확인용) -->
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox"
                                       name="refund_checked" id="refundCheck" value="true">
                                <label class="form-check-label small" for="refundCheck">
                                    환불 처리를 완료했습니다. (결제 시스템에서 직접 처리한 경우 체크)
                                </label>
                            </div>

                            <button type="submit" class="btn btn-danger btn-sm"
                                    onclick="return confirm('정말로 이 예약을 취소하시겠습니까?')">
                                <i class="bi bi-x-circle me-1"></i>취소 확정
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm ms-1"
                                    onclick="hideCancelForm()">
                                취소 접기
                            </button>
                        </form>
                    </div>

                </div><!-- /modalContent -->
            </div><!-- /modal-body -->

            <!-- 모달 푸터 — 상태에 따라 액션 버튼 표시 -->
            <div class="modal-footer" id="modalFooter">
                <!-- 버튼은 JavaScript 에서 상태에 따라 동적으로 생성 -->
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>
            </div>

        </div>
    </div>
</div>


<!-- ════════════════════════════════
     Bootstrap JS
     ════════════════════════════════ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ══════════════════════════════════════════════
   현재 페이지의 nowPage 값 (리다이렉트 URL 구성용)
   ══════════════════════════════════════════════ */
const ctx = '${pageContext.request.contextPath}';
const CURRENT_PAGE = ${nowPage};

/* 상태 코드 → 한국어 레이블·배지 CSS 맵 */
const STATUS_MAP = {
    PENDING:   { label: '대기',   css: 'badge-pending'   },
    CONFIRMED: { label: '확정',   css: 'badge-confirmed' },
    USING:     { label: '이용중', css: 'badge-using'     },
    COMPLETED: { label: '완료',   css: 'badge-completed' },
    CANCELLED: { label: '취소',   css: 'badge-cancelled' }
};

/* ══════════════════════════════════════════════
   모달 열기 — r_idx 로 AJAX 상세 조회 후 렌더링
   ══════════════════════════════════════════════ */
function openDetailModal(rIdx) {
    /* 모달 초기화 */
    document.getElementById('modalLoading').style.display = 'block';
    document.getElementById('modalContent').style.display = 'none';
    document.getElementById('cancelForm').style.display   = 'none';
    /* 푸터 버튼 초기화 */
    resetFooterButtons();

    const modal = new bootstrap.Modal(document.getElementById('detailModal'));
    modal.show();

    /* AJAX 상세 조회 */
    fetch(ctx + '/admin/reservation/detail?resIdx=' + rIdx)
        .then(res => {
            if (!res.ok) throw new Error('데이터 조회 실패');
            return res.json();
        })
        .then(data => renderModal(data))
        .catch(err => {
            document.getElementById('modalLoading').innerHTML =
                '<div class="text-danger py-4 text-center"><i class="bi bi-exclamation-triangle fs-3"></i><br>' +
                '데이터를 불러오는 중 오류가 발생했습니다.</div>';
        });
}

/* ══════════════════════════════════════════════
   모달 데이터 렌더링
   ══════════════════════════════════════════════ */
function renderModal(d) {
    /* 숫자 포맷 (천 단위 콤마) */
    const fmtNum = n => Number(n || 0).toLocaleString('ko-KR');

    /* ① 예약 기본 정보 채우기 */
    document.getElementById('d_r_idx').textContent       = '#' + d.resIdx;
    document.getElementById('d_r_start_time').textContent = d.resStartTime || '-';
    document.getElementById('d_r_end_time').textContent   = d.resEndTime   || '-';
    document.getElementById('d_r_headcount').textContent  = (d.resHeadcount || 0) + '명';
    document.getElementById('d_r_total_price').textContent = '₩ ' + fmtNum(d.resTotalPrice);

    /* 취소 상태일 때는 r_content 를 "취소 사유"로 표시 */
    const contentLabel = d.resStatus === 'CANCELLED' ? '[취소 사유] ' : '';
    document.getElementById('d_r_content').textContent = contentLabel + (d.r_content || '-');

    /* 상태 배지 */
    const statusInfo = STATUS_MAP[d.resStatus] || { label: d.resStatus, css: '' };
    document.getElementById('d_r_status_badge').innerHTML =
        '<span class="badge ' + statusInfo.css + ' px-3 py-1 rounded-pill">' + statusInfo.label + '</span>';

    /* ② 예약자 정보 */
    document.getElementById('d_u_name').textContent  = d.userName  || '-';
    document.getElementById('d_u_email').textContent = d.userEmail || '-';
    document.getElementById('d_u_phone').textContent = d.userPhone || '-';

    /* ③ 공간 정보 */
    document.getElementById('d_s_name').textContent  = d.spcName  || '-';
    document.getElementById('d_s_type').textContent  = d.spcType  || '-';
    document.getElementById('d_b_name').textContent  = d.brnName  || '-';
    document.getElementById('d_s_price').textContent = '₩ ' + fmtNum(d.spcPrice) + ' / 건';

    /* ④ 이력 타임라인 렌더링 */
    renderTimeline(d);

    /* ⑤ 취소 폼 — r_idx 및 환불 금액 미리 세팅 */
    document.getElementById('cancel_r_idx').value      = d.resIdx;
    document.getElementById('cancelRefundAmount').textContent = '₩ ' + fmtNum(d.resTotalPrice);

    /* ⑥ 상태별 액션 버튼 생성 */
    renderFooterButtons(d);

    /* 로딩 숨기고 내용 표시 */
    document.getElementById('modalLoading').style.display = 'none';
    document.getElementById('modalContent').style.display = 'block';
}

/* ══════════════════════════════════════════════
   이력 타임라인 렌더링
   - 별도 로그 테이블 없으므로 r_created / r_updated 기반으로 표시
   - 정확한 이력 관리가 필요하면 reservation_log 테이블 추가 권장
   ══════════════════════════════════════════════ */
function renderTimeline(d) {
    const tl = document.getElementById('d_timeline');
    const statusInfo = STATUS_MAP[d.resStatus] || { label: d.resStatus };

    /* 이벤트 목록 구성 */
    const events = [];

    /* 예약 접수 (항상 첫 번째) */
    events.push({ time: d.resCreated, text: '예약 접수 (PENDING)', dot: '' });

    /* 마지막 상태 변경 (r_updated 가 r_created 와 다를 때만 표시) */
    if (d.resUpdated && d.resUpdated !== d.resCreated) {
        let dotClass = '';
        let eventText = '상태 변경 → ' + statusInfo.label;
        if (d.resStatus === 'CANCELLED') { dotClass = 'dot-cancel';   eventText = '강제 취소 처리'; }
        if (d.resStatus === 'CONFIRMED') { dotClass = 'dot-confirm';  eventText = '예약 확정'; }
        if (d.resStatus === 'COMPLETED') { dotClass = 'dot-complete'; eventText = '이용 완료 처리'; }
        events.push({ time: d.resUpdated, text: eventText, dot: dotClass });
    }

    /* 현재 상태 마커 (PENDING 이면 "처리 대기 중") */
    if (d.resStatus === 'PENDING') {
        events.push({ time: '현재', text: '처리 대기 중', dot: '' });
    }

    /* HTML 생성 */
    tl.innerHTML = events.map(e =>
        '<div class="timeline-item">' +
        '  <div class="timeline-dot ' + e.dot + '"></div>' +
        '  <div class="timeline-time">' + e.time + '</div>' +
        '  <div class="timeline-text">' + e.text + '</div>' +
        '</div>'
    ).join('');
}

/* ══════════════════════════════════════════════
   모달 푸터 액션 버튼 — 상태에 따라 표시
   ══════════════════════════════════════════════ */
function renderFooterButtons(d) {
    const footer = document.getElementById('modalFooter');
    /* 닫기 버튼은 유지 */
    let html = '<button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>';

    /* PENDING → 예약 확정 버튼 */
    if (d.resStatus === 'PENDING') {
        html = '<form method="post" action="${ctx}/admin/reservation/confirm" class="d-inline">' +
               '  <input type="hidden" name="resIdx"         value="' + d.resIdx + '">' +
               '  <input type="hidden" name="nowPage"       value="' + CURRENT_PAGE + '">' +
               '  <input type="hidden" name="startDate"    value="${searchVO.startDate}">' +
               '  <input type="hidden" name="endDate"      value="${searchVO.endDate}">' +
               '  <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">' +
               '  <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">' +
               '  <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">' +
               '  <button type="submit" class="btn btn-primary btn-sm me-1"' +
               '    onclick="return confirm(\'이 예약을 확정 처리하시겠습니까?\')">' +
               '    <i class="bi bi-check-circle me-1"></i>예약 확정' +
               '  </button>' +
               '</form>' + html;
    }

    /* CONFIRMED / USING → 이용 완료 처리 버튼 */
    if (d.resStatus === 'CONFIRMED' || d.resStatus === 'USING') {
        html = '<form method="post" action="${ctx}/admin/reservation/complete" class="d-inline">' +
               '  <input type="hidden" name="resIdx"         value="' + d.resIdx + '">' +
               '  <input type="hidden" name="nowPage"       value="' + CURRENT_PAGE + '">' +
               '  <input type="hidden" name="startDate"    value="${searchVO.startDate}">' +
               '  <input type="hidden" name="endDate"      value="${searchVO.endDate}">' +
               '  <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">' +
               '  <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">' +
               '  <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">' +
               '  <button type="submit" class="btn btn-success btn-sm me-1"' +
               '    onclick="return confirm(\'이용 완료 처리하시겠습니까?\')">' +
               '    <i class="bi bi-check2-all me-1"></i>이용 완료' +
               '  </button>' +
               '</form>' + html;
    }

    /* PENDING / CONFIRMED / USING → 강제 취소 버튼 */
    if (['PENDING', 'CONFIRMED', 'USING'].includes(d.resStatus)) {
        html = '<button type="button" class="btn btn-danger btn-sm me-1"' +
               '  onclick="showCancelForm()">' +
               '  <i class="bi bi-x-circle me-1"></i>강제 취소' +
               '</button>' + html;
    }

    footer.innerHTML = html;
}

/* ── 강제 취소 폼 표시/숨기기 ── */
function showCancelForm() {
    document.getElementById('cancelForm').style.display = 'block';
    document.getElementById('cancelForm').scrollIntoView({ behavior: 'smooth' });
}
function hideCancelForm() {
    document.getElementById('cancelForm').style.display = 'none';
    document.getElementById('cancelReason').value = '';
}

/* ── 모달 푸터 초기화 ── */
function resetFooterButtons() {
    document.getElementById('modalFooter').innerHTML =
        '<button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>';
}

/* ══════════════════════════════════════════════
   알림 토스트 자동 숨김 (3초 후)
   ══════════════════════════════════════════════ */
(function() {
    const alert = document.querySelector('.alert-flash .alert');
    if (alert) {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            bsAlert.close();
        }, 3000);
    }
})();
</script>
</body>
</html>

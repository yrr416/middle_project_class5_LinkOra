<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }

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
        .stats-card { background:#fff; border-radius:10px; padding:18px 20px; box-shadow:0 1px 4px rgba(0,0,0,.06); text-align:center; }
        .stats-card .number { font-size:1.9rem; font-weight:700; }

        /* ── 공통 섹션 카드 ── */
        .section-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; margin-bottom:24px; }
        .section-header { padding:14px 20px; border-bottom:1px solid #f0f0f0; display:flex; justify-content:space-between; align-items:center; }
        .filter-bar { padding:14px 20px; border-bottom:1px solid #f0f0f0; background:#fafafa; }
        .table thead th { background:#f8f9fa; font-size:.83rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; cursor:pointer; }

        /* ── 별점 ── */
        .stars { color:#f59e0b; letter-spacing:1px; }
        .stars-empty { color:#d1d5db; }

        /* ── 상태 배지 ── */
        .badge-normal   { background:#d1fae5; color:#065f46; }
        .badge-blind    { background:#fee2e2; color:#991b1b; }
        .badge-done     { background:#e5e7eb; color:#374151; }
        .badge-pending  { background:#fef9c3; color:#854d0e; }
        .badge-blinded  { background:#fee2e2; color:#991b1b; }
        .badge-dismissed{ background:#e5e7eb; color:#374151; }

        /* ── 신고 강조 행 ── */
        tr.has-report td { background:#fffbeb !important; }
        tr.has-report:hover td { background:#fef3c7 !important; }

        /* ── 신고 섹션 헤더 ── */
        .report-header { background:linear-gradient(90deg,#fff7ed,#fff); border-bottom:2px solid #fed7aa; }

        /* ── 모달 내부 ── */
        .review-box { background:#f8f9fa; border-radius:8px; padding:14px 18px; font-size:.9rem; border-left:3px solid #0d6efd; }
        .report-box { background:#fff7ed; border-radius:8px; padding:14px 18px; font-size:.9rem; border-left:3px solid #f97316; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- 사이드바 -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link active" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-star me-2 text-warning"></i>리뷰 관리</h5>
                <small class="text-muted">고객 리뷰를 조회하고 답글·블라인드·신고 처리를 합니다.</small>
            </div>
        </div>

        <!-- 통계 카드 -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-primary">${totalRecord}</div>
                    <div class="text-muted small mt-1">전체 리뷰 (미처리)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="blindCnt" value="0"/>
                    <c:forEach var="r" items="${reviewList}">
                        <c:if test="${r.revActive == '2'}"><c:set var="blindCnt" value="${blindCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-danger">${blindCnt}</div>
                    <div class="text-muted small mt-1">블라인드 (이 페이지)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-warning">${reportTotal}</div>
                    <div class="text-muted small mt-1">신고 대기 처리</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-success">${answeredCount}</div>
                    <div class="text-muted small mt-1">답변완료</div>
                </div>
            </div>
        </div>

        <!-- ====================================================
             신고 대기 섹션 (PENDING 신고 우선 표시)
             ==================================================== -->
        <div class="section-card">
            <div class="section-header report-header">
                <div>
                    <h6 class="mb-0 fw-bold text-warning-emphasis">
                        <i class="bi bi-flag-fill me-2 text-warning"></i>신고 대기 처리
                    </h6>
                    <small class="text-muted">신고된 리뷰를 검토하고 블라인드 처리 또는 반려하세요.</small>
                </div>
                <span class="badge bg-warning text-dark rounded-pill px-3">${reportTotal}건 대기</span>
            </div>

            <c:choose>
                <c:when test="${empty reportList}">
                    <div class="text-center py-4 text-muted">
                        <i class="bi bi-check-circle fs-3 d-block mb-2 text-success"></i>
                        처리 대기 중인 신고가 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-3" style="width:60px;">번호</th>
                                    <th>신고 대상 리뷰</th>
                                    <th style="width:80px;">별점</th>
                                    <th>리뷰 작성자</th>
                                    <th>신고자</th>
                                    <th>신고 사유</th>
                                    <th style="width:90px;">신고일</th>
                                    <th class="text-center" style="width:140px;">처리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rp" items="${reportList}">
                                    <tr>
                                        <td class="ps-3">${rp.rvrIdx}</td>
                                        <td>
                                            <span class="d-inline-block text-truncate" style="max-width:220px;"
                                                  title="${rp.revContent}">
                                                ${rp.revContent}
                                            </span>
                                            <br>
                                            <small class="text-muted">
                                                <i class="bi bi-building me-1"></i>${rp.spcName}
                                                <c:if test="${rp.revActive == '2'}">
                                                    &nbsp;<span class="badge badge-blind rounded-pill">블라인드됨</span>
                                                </c:if>
                                            </small>
                                        </td>
                                        <td>
                                            <c:set var="rating" value="${rp.revRating}"/>
                                            <span class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= rating}">★</c:when>
                                                        <c:otherwise><span class="stars-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                        </td>
                                        <td>${rp.writerName}</td>
                                        <td><strong>${rp.userName}</strong></td>
                                        <td>
                                            <span class="d-inline-block text-truncate" style="max-width:180px;"
                                                  title="${rp.rvrReason}">${rp.rvrReason}</span>
                                        </td>
                                        <td>
                                            <small>${rp.rvrCreated}</small>
                                        </td>
                                        <td class="text-center" onclick="event.stopPropagation()">
                                            <!-- 신고 처리 모달 열기 버튼 -->
                                            <button class="btn btn-sm btn-outline-danger py-0 px-2"
                                                    onclick="openReportModal('${rp.rvrIdx}','${rp.revIdx}',
                                                        `${rp.revContent}`, '${rp.rvrReason}',
                                                        '${rp.userName}', '${rp.writerName}')">
                                                <i class="bi bi-shield-exclamation me-1"></i>처리
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 신고 목록 페이징 -->
                    <c:if test="${reportTotalPage > 1}">
                        <div class="p-3 d-flex justify-content-center">
                            <nav>
                                <ul class="pagination pagination-sm mb-0">
                                    <c:forEach var="p" begin="1" end="${reportTotalPage}">
                                        <li class="page-item ${reportPage == p ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${ctx}/admin/review/list?reportPage=${p}&nowPage=${nowPage}&rating_filter=${reviewVO.ratingFilter}&blind_filter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ====================================================
             전체 리뷰 목록
             ==================================================== -->
        <div class="section-card">
            <!-- 필터 바 -->
            <div class="filter-bar">
                <form method="get" action="${ctx}/admin/review/list" class="row g-2 align-items-end">
                    <!-- 별점 필터 -->
                    <div class="col-auto">
                        <label class="form-label small mb-1">별점</label>
                        <select name="ratingFilter" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <c:forEach begin="1" end="5" var="i">
                                <option value="${i}" ${reviewVO.ratingFilter == i.toString() ? 'selected':''}>
                                    ${i}점
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- 블라인드 여부 필터 -->
                    <div class="col-auto">
                        <label class="form-label small mb-1">상태</label>
                        <select name="blindFilter" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <option value="0" ${reviewVO.blindFilter == '0' ? 'selected':''}>정상</option>
                            <option value="2" ${reviewVO.blindFilter == '2' ? 'selected':''}>블라인드</option>
                        </select>
                    </div>
                    <!-- 답변 여부 필터 -->
                    <div class="col-auto">
                        <label class="form-label small mb-1">답변</label>
                        <select name="answerFilter" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <option value="Y" ${reviewVO.answerFilter == 'Y' ? 'selected':''}>답변완료</option>
                            <option value="N" ${reviewVO.answerFilter == 'N' ? 'selected':''}>미답변</option>
                        </select>
                    </div>
                    <!-- 신고 우선 정렬 -->
                    <div class="col-auto d-flex align-items-end pb-1">
                        <div class="form-check mb-0">
                            <input class="form-check-input" type="checkbox" name="sortReported"
                                   id="sortReported" value="1"
                                   ${reviewVO.sortReported == '1' ? 'checked':''}>
                            <label class="form-check-label small" for="sortReported">신고 많은 순</label>
                        </div>
                    </div>
                    <!-- 검색어 -->
                    <div class="col">
                        <label class="form-label small mb-1">검색 (작성자 / 내용)</label>
                        <input type="text" name="searchWord" value="${reviewVO.searchWord}"
                               class="form-control form-control-sm" placeholder="작성자 이름 또는 공간명">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search me-1"></i>검색
                        </button>
                        <a href="${ctx}/admin/review/list" class="btn btn-outline-secondary btn-sm ms-1">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                        </a>
                    </div>
                </form>
            </div>

            <!-- 섹션 헤더 -->
            <div class="section-header">
                <span class="small text-muted">
                    총 <strong>${totalRecord}</strong>개 리뷰
                    <c:if test="${not empty reviewVO.searchWord}">
                        · 검색: <strong>${reviewVO.searchWord}</strong>
                    </c:if>
                </span>
                <span class="small text-muted">${nowPage} / ${totalPage} 페이지</span>
            </div>

            <!-- 리뷰 테이블 -->
            <c:choose>
                <c:when test="${empty reviewList}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                        조회된 리뷰가 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-3" style="width:55px;">번호</th>
                                    <th>리뷰 내용</th>
                                    <th style="width:100px;">별점</th>
                                    <th style="width:100px;">작성자</th>
                                    <th style="width:120px;">공간</th>
                                    <th style="width:70px;">신고</th>
                                    <th style="width:80px;">상태</th>
                                    <th style="width:85px;">답변</th>
                                    <th style="width:95px;">작성일</th>
                                    <th class="text-center" style="width:180px;">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reviewList}">
                                    <tr class="${r.reportCnt > 0 ? 'has-report' : ''}"
                                        onclick="location.href='${ctx}/admin/review/detail?revIdx=${r.revIdx}&nowPage=${nowPage}&ratingFilter=${reviewVO.ratingFilter}&blindFilter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}'"
                                        style="cursor:pointer;">
                                        <td class="ps-3">${r.revIdx}</td>
                                        <td>
                                            <span class="d-inline-block text-truncate" style="max-width:260px;"
                                                  title="${r.revContent}">${r.revContent}</span>
                                            <!-- 관리자 답글 표시 -->
                                            <c:if test="${not empty r.adminReply}">
                                                <br>
                                                <small class="text-primary">
                                                    <i class="bi bi-reply-fill me-1"></i>
                                                    <span class="d-inline-block text-truncate" style="max-width:240px;"
                                                          title="${r.adminReply}">${r.adminReply}</span>
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <!-- 별점 시각화 (★) -->
                                            <span class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= r.revRating}">★</c:when>
                                                        <c:otherwise><span class="stars-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                            <small class="text-muted ms-1">${r.revRating}점</small>
                                        </td>
                                        <td>${r.userName}</td>
                                        <td>
                                            <small>${r.spcName}</small>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${r.reportCnt > 0}">
                                                    <span class="badge bg-danger rounded-pill">${r.reportCnt}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <!-- v_active: 0=정상, 2=블라인드 -->
                                            <c:choose>
                                                <c:when test="${r.revActive == '2'}">
                                                    <span class="badge badge-blind rounded-pill">블라인드</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-normal rounded-pill">정상</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r.adminReply}">
                                                    <span class="badge badge-done rounded-pill">답변완료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-pending rounded-pill">미답변</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small>${r.revCreatedAt}</small></td>
                                        <td class="text-center" onclick="event.stopPropagation()">
                                            <!-- 답글 버튼 -->
                                            <button class="btn btn-outline-primary btn-sm py-0 px-2"
                                                    onclick="openReplyModal('${r.revIdx}', `${r.revContent}`, '${r.userName}')">
                                                <i class="bi bi-reply"></i>
                                            </button>
                                            <!-- 블라인드 처리/해제 버튼 -->
                                            <c:choose>
                                                <c:when test="${r.revActive == '2'}">
                                                    <!-- 블라인드 해제 -->
                                                    <form method="post" action="${ctx}/admin/review/unblind" class="d-inline ms-1">
                                                        <input type="hidden" name="revIdx" value="${r.revIdx}">
                                                        <input type="hidden" name="nowPage" value="${nowPage}">
                                                        <input type="hidden" name="ratingFilter" value="${reviewVO.ratingFilter}">
                                                        <input type="hidden" name="blindFilter"  value="${reviewVO.blindFilter}">
                                                        <input type="hidden" name="searchWord" value="${reviewVO.searchWord}">
                                                        <button type="submit" class="btn btn-outline-success btn-sm py-0 px-2"
                                                                title="블라인드 해제"
                                                                onclick="return confirm('블라인드를 해제하시겠습니까?')">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- 블라인드 처리 -->
                                                    <form method="post" action="${ctx}/admin/review/blind" class="d-inline ms-1">
                                                        <input type="hidden" name="revIdx" value="${r.revIdx}">
                                                        <input type="hidden" name="nowPage" value="${nowPage}">
                                                        <input type="hidden" name="ratingFilter" value="${reviewVO.ratingFilter}">
                                                        <input type="hidden" name="blindFilter"  value="${reviewVO.blindFilter}">
                                                        <input type="hidden" name="searchWord" value="${reviewVO.searchWord}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm py-0 px-2"
                                                                title="블라인드 처리"
                                                                onclick="return confirm('이 리뷰를 블라인드 처리하시겠습니까?')">
                                                            <i class="bi bi-eye-slash"></i>
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 리뷰 목록 페이징 -->
            <div class="p-3 d-flex justify-content-center">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:if test="${beginBlock > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${ctx}/admin/review/list?nowPage=${beginBlock-1}&rating_filter=${reviewVO.ratingFilter}&blind_filter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}&sort_reported=${reviewVO.sortReported}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                            <li class="page-item ${nowPage == p ? 'active' : ''}">
                                <a class="page-link"
                                   href="${ctx}/admin/review/list?nowPage=${p}&rating_filter=${reviewVO.ratingFilter}&blind_filter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}&sort_reported=${reviewVO.sortReported}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${ctx}/admin/review/list?nowPage=${endBlock+1}&rating_filter=${reviewVO.ratingFilter}&blind_filter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}&sort_reported=${reviewVO.sortReported}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div><!-- /section-card -->

    </div><!-- /main-content -->
</div>
</div>

<!-- ====================================================
     [모달 1] 관리자 답글 모달
     - 열기: openReplyModal(v_idx, reviewContent, writerName)
     ==================================================== -->
<div class="modal fade" id="replyModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title fw-bold">
                    <i class="bi bi-reply-fill me-2 text-primary"></i>관리자 답글 달기
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${ctx}/admin/review/reply">
                <input type="hidden" name="revIdx" id="reply_rev_idx">
                <input type="hidden" name="nowPage" value="${nowPage}">
                <input type="hidden" name="ratingFilter" value="${reviewVO.ratingFilter}">
                <input type="hidden" name="blindFilter"  value="${reviewVO.blindFilter}">
                <input type="hidden" name="searchWord" value="${reviewVO.searchWord}">
                <div class="modal-body">
                    <!-- 원본 리뷰 미리보기 -->
                    <p class="small text-muted mb-2">작성자: <strong id="reply_writer"></strong></p>
                    <div class="review-box mb-3" id="reply_content_box"></div>
                    <!-- 답글 입력 -->
                    <label class="form-label fw-semibold">
                        관리자 답글 <span class="text-danger">*</span>
                    </label>
                    <textarea name="reply_content" class="form-control" rows="5" required
                              placeholder="고객에게 표시될 관리자 답글을 입력하세요.&#10;답글을 등록하면 해당 리뷰는 처리완료 상태로 변경되어 관리자 목록에서 숨겨집니다."></textarea>
                    <div class="form-text mt-1 text-warning">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        답글 등록 후에는 해당 리뷰가 관리자 페이지 목록에서 숨겨집니다.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-check-circle me-1"></i>답글 등록
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ====================================================
     [모달 2] 신고 처리 모달
     - 블라인드 처리 + 신고 반려 선택
     - 관리자 알림 메시지 (신고자에게 전달)
     - 열기: openReportModal(rr_idx, v_idx, reviewContent, reportReason, reporterName, writerName)
     ==================================================== -->
<div class="modal fade" id="reportModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-warning-subtle">
                <h6 class="modal-title fw-bold">
                    <i class="bi bi-shield-exclamation me-2 text-warning"></i>신고 처리
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 신고 정보 표시 -->
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <p class="small text-muted mb-1">신고된 리뷰 (작성자: <strong id="rp_writer"></strong>)</p>
                        <div class="review-box" id="rp_review_content"></div>
                    </div>
                    <div class="col-md-6">
                        <p class="small text-muted mb-1">신고 사유 (신고자: <strong id="rp_reporter"></strong>)</p>
                        <div class="report-box" id="rp_reason"></div>
                    </div>
                </div>

                <!-- 처리 결과 + 알림 메시지 -->
                <label class="form-label fw-semibold">
                    신고자에게 전달할 처리 결과 메시지 <span class="text-danger">*</span>
                </label>
                <textarea id="rp_admin_reply" class="form-control mb-1" rows="4" required
                          placeholder="예) 해당 리뷰를 검토한 결과, 커뮤니티 정책에 위반되어 블라인드 처리하였습니다.&#10;또는 검토 결과 이용 약관 위반 사항이 없어 반려 처리하였습니다."></textarea>
                <div class="form-text text-muted mb-0">
                    <i class="bi bi-info-circle me-1"></i>신고자가 확인할 수 있는 처리 결과 메시지입니다.
                </div>
            </div>
            <div class="modal-footer justify-content-between">
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <div class="d-flex gap-2">
                    <!-- 반려 처리 폼 -->
                    <form method="post" action="${ctx}/admin/review/reportDismiss" id="dismissForm">
                        <input type="hidden" name="rvrIdx" id="dismiss_rr_idx">
                        <input type="hidden" name="rvrAdminReply" id="dismiss_reply">
                        <input type="hidden" name="nowPage" value="${nowPage}">
                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                onclick="submitReport('dismiss')">
                            <i class="bi bi-x-circle me-1"></i>반려 (문제없음)
                        </button>
                    </form>
                    <!-- 블라인드 처리 폼 -->
                    <form method="post" action="${ctx}/admin/review/reportBlind" id="blindForm">
                        <input type="hidden" name="rvrIdx" id="blind_rr_idx">
                        <input type="hidden" name="revIdx"  id="blind_rev_idx">
                        <input type="hidden" name="rvrAdminReply" id="blind_reply">
                        <input type="hidden" name="nowPage" value="${nowPage}">
                        <button type="button" class="btn btn-danger btn-sm"
                                onclick="submitReport('blind')">
                            <i class="bi bi-eye-slash me-1"></i>블라인드 처리 + 알림
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* ─────────────────────────────────────────────────────────
       관리자 답글 모달 열기
       - v_idx     : 답글을 달 리뷰 번호
       - content   : 원본 리뷰 내용
       - writer    : 리뷰 작성자명
    ───────────────────────────────────────────────────────── */
    function openReplyModal(v_idx, content, writer) {
        document.getElementById('reply_rev_idx').value = v_idx;
        document.getElementById('reply_writer').textContent = writer;
        document.getElementById('reply_content_box').textContent = content;
        new bootstrap.Modal(document.getElementById('replyModal')).show();
    }

    /* ─────────────────────────────────────────────────────────
       신고 처리 모달 열기
       - rr_idx      : 신고 번호
       - v_idx       : 신고된 리뷰 번호
       - reviewContent: 원본 리뷰 내용
       - reason      : 신고 사유
       - reporter    : 신고자명
       - writer      : 리뷰 작성자명
    ───────────────────────────────────────────────────────── */
    function openReportModal(rr_idx, v_idx, reviewContent, reason, reporter, writer) {
        /* 신고 폼 값 주입 */
        document.getElementById('dismiss_rr_idx').value = rr_idx;
        document.getElementById('blind_rr_idx').value   = rr_idx;
        document.getElementById('blind_rev_idx').value    = v_idx;

        /* 모달 내용 표시 */
        document.getElementById('rp_writer').textContent  = writer;
        document.getElementById('rp_reporter').textContent = reporter;
        document.getElementById('rp_review_content').textContent = reviewContent;
        document.getElementById('rp_reason').textContent = reason;

        /* 이전 입력값 초기화 */
        document.getElementById('rp_admin_reply').value = '';

        new bootstrap.Modal(document.getElementById('reportModal')).show();
    }

    /* ─────────────────────────────────────────────────────────
       신고 처리 폼 제출
       - type: 'blind' (블라인드 처리) or 'dismiss' (반려)
    ───────────────────────────────────────────────────────── */
    function submitReport(type) {
        const adminReply = document.getElementById('rp_admin_reply').value.trim();
        if (!adminReply) {
            alert('처리 결과 메시지를 입력해주세요.');
            document.getElementById('rp_admin_reply').focus();
            return;
        }

        if (type === 'blind') {
            const confirmed = confirm('이 리뷰를 블라인드 처리하고 신고자에게 알림을 전송하시겠습니까?');
            if (!confirmed) return;
            document.getElementById('blind_reply').value = adminReply;
            document.getElementById('blindForm').submit();
        } else {
            const confirmed = confirm('신고를 반려(문제없음) 처리하고 신고자에게 알림을 전송하시겠습니까?');
            if (!confirmed) return;
            document.getElementById('dismiss_reply').value = adminReply;
            document.getElementById('dismissForm').submit();
        }
    }
</script>
</body>
</html>

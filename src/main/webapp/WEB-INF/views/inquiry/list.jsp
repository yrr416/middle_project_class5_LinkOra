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
    <title>1:1 문의 관리 - 오피스 예약 플랫폼</title>
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

        /* ── 섹션 카드 ── */
        .section-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; margin-bottom:24px; }
        .section-header { padding:14px 20px; border-bottom:1px solid #f0f0f0; display:flex; justify-content:space-between; align-items:center; }
        .filter-bar { padding:14px 20px; border-bottom:1px solid #f0f0f0; background:#fafafa; }
        .table thead th { background:#f8f9fa; font-size:.83rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; cursor:pointer; }

        /* ── 미답변 행 강조 ── */
        tr.pending-row td { background:#fffbeb !important; }
        tr.pending-row:hover td { background:#fef3c7 !important; }

        /* ── 상태 배지 ── */
        .badge-pending  { background:#fef9c3; color:#854d0e; }
        .badge-complete { background:#d1fae5; color:#065f46; }

        /* ── 필터 탭 ── */
        .filter-tab { border:none; border-bottom:2px solid transparent; background:none; padding:8px 16px; color:#6c757d; font-weight:500; }
        .filter-tab.active { border-bottom-color:#0d6efd; color:#0d6efd; }

        /* ── 페이지네이션 ── */
        .pagination .page-link { color:#1a3a5c; }
        .pagination .page-item.active .page-link { background:#1a3a5c; border-color:#1a3a5c; color:#fff; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ── 사이드바 ────────────────────────────────────────────── -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link active" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- ── 메인 콘텐츠 ────────────────────────────────────────── -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-chat-left-text me-2 text-info"></i>1:1 문의 관리</h5>
                <small class="text-muted">고객 문의를 조회하고 답변을 작성합니다. 미답변 문의가 우선 표시됩니다.</small>
            </div>
            <!-- 미답변 알림 배지 -->
            <c:if test="${pendingCount > 0}">
                <span class="badge bg-danger fs-6">
                    <i class="bi bi-exclamation-circle me-1"></i>미답변 ${pendingCount}건
                </span>
            </c:if>
        </div>

        <!-- 답변 저장 완료 메시지 -->
        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                <i class="bi bi-check-circle me-1"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- ── 통계 카드 ────────────────────────────────────────── -->
        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-primary">${totalRecord}</div>
                    <div class="text-muted small mt-1">전체 문의</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-warning">${pendingCount}</div>
                    <div class="text-muted small mt-1">미답변</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-success">${totalRecord - pendingCount}</div>
                    <div class="text-muted small mt-1">답변완료</div>
                </div>
            </div>
        </div>

        <!-- ── 문의 목록 섹션 ────────────────────────────────────── -->
        <div class="section-card">
            <!-- 상태 필터 탭 -->
            <div class="section-header p-0">
                <div class="d-flex">
                    <a href="${ctx}/admin/inquiry/list?nowPage=1&search_word=${inquiryVO.searchWord}"
                       class="filter-tab ${inquiryVO.statusFilter == '' || inquiryVO.statusFilter == null ? 'active' : ''}">
                        전체
                    </a>
                    <a href="${ctx}/admin/inquiry/list?nowPage=1&statusFilter=PENDING&search_word=${inquiryVO.searchWord}"
                       class="filter-tab ${inquiryVO.statusFilter == 'PENDING' ? 'active' : ''}">
                        <i class="bi bi-hourglass-split me-1 text-warning"></i>대기중
                        <c:if test="${pendingCount > 0}">
                            <span class="badge bg-danger rounded-pill ms-1" style="font-size:.7rem;">${pendingCount}</span>
                        </c:if>
                    </a>
                    <a href="${ctx}/admin/inquiry/list?nowPage=1&statusFilter=COMPLETE&search_word=${inquiryVO.searchWord}"
                       class="filter-tab ${inquiryVO.statusFilter == 'COMPLETE' ? 'active' : ''}">
                        <i class="bi bi-check-circle me-1 text-success"></i>답변완료
                    </a>
                </div>
            </div>

            <!-- 검색 바 -->
            <div class="filter-bar">
                <form method="get" action="${ctx}/admin/inquiry/list" class="row g-2 align-items-end">
                    <input type="hidden" name="statusFilter" value="${inquiryVO.statusFilter}">
                    <div class="col-auto">
                        <div class="input-group input-group-sm">
                            <input type="text" name="searchWord" class="form-control"
                                   placeholder="제목 또는 작성자 검색"
                                   value="${inquiryVO.searchWord}">
                            <button class="btn btn-outline-secondary" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-auto">
                        <a href="${ctx}/admin/inquiry/list?statusFilter=${inquiryVO.statusFilter}"
                           class="btn btn-outline-secondary btn-sm">초기화</a>
                    </div>
                </form>
            </div>

            <!-- 문의 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width:60px;">번호</th>
                            <th style="width:100px;">유형</th>
                            <th>제목</th>
                            <th style="width:110px;">작성자</th>
                            <th style="width:90px;">상태</th>
                            <th style="width:140px;">작성일</th>
                            <th style="width:140px;">답변일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty inquiryList}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox me-1"></i>문의 내역이 없습니다.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="inq" items="${inquiryList}">
                                    <!-- 미답변 행은 배경 강조 -->
                                    <tr class="${inq.inqStatus == '대기중' ? 'pending-row' : ''}"
                                        onclick="location.href='${ctx}/admin/inquiry/detail?inqIdx=${inq.inqIdx}&nowPage=${nowPage}&statusFilter=${inquiryVO.statusFilter}&searchWord=${inquiryVO.searchWord}'">
                                        <td class="text-muted small">${inq.inqIdx}</td>
                                        <td>
                                            <span class="badge bg-secondary">${inq.inqCategory}</span>
                                        </td>
                                        <td>
                                            <!-- 미답변 강조 아이콘 -->
                                            <c:if test="${inq.inqStatus == '대기중'}">
                                                <i class="bi bi-exclamation-circle-fill text-warning me-1"></i>
                                            </c:if>
                                            ${inq.inqTitle}
                                        </td>
                                        <td class="small">${inq.userName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${inq.inqStatus == '대기중'}">
                                                    <span class="badge badge-pending">대기중</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-complete">답변완료</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small">${inq.inqCreated}</td>
                                        <td class="text-muted small">
                                            <c:choose>
                                                <c:when test="${not empty inq.inqAnswered}">${inq.inqAnswered}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="d-flex justify-content-center py-3">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:if test="${beginBlock > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/inquiry/list?nowPage=${beginBlock - 1}&statusFilter=${inquiryVO.statusFilter}&searchWord=${inquiryVO.searchWord}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach begin="${beginBlock}" end="${endBlock}" var="page">
                            <li class="page-item ${page == nowPage ? 'active' : ''}">
                                <a class="page-link" href="${ctx}/admin/inquiry/list?nowPage=${page}&statusFilter=${inquiryVO.statusFilter}&searchWord=${inquiryVO.searchWord}">
                                    ${page}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/inquiry/list?nowPage=${endBlock + 1}&statusFilter=${inquiryVO.statusFilter}&searchWord=${inquiryVO.searchWord}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div><!-- /.section-card -->

    </div><!-- /.main-content -->
</div><!-- /.row -->
</div><!-- /.container-fluid -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

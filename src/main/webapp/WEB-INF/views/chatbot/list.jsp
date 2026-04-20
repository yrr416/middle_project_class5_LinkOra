<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>챗봇 상담내역 - 오피스 예약 플랫폼</title>
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

        /* ── 상태 배지 ── */
        .badge-resolved   { background:#d1fae5; color:#065f46; }
        .badge-unresolved { background:#fee2e2; color:#991b1b; }

        /* ── 필터 탭 ── */
        .filter-tab { border:none; border-bottom:2px solid transparent; background:none; padding:8px 16px; color:#6c757d; font-weight:500; text-decoration:none; display:inline-block; }
        .filter-tab.active { border-bottom-color:#0d6efd; color:#0d6efd; }

        /* ── 페이지네이션 ── */
        .pagination .page-link { color:#1a3a5c; }
        .pagination .page-item.active .page-link { background:#1a3a5c; border-color:#1a3a5c; color:#fff; }

        /* ── 첫 질문 미리보기 말줄임 ── */
        .preview-text { max-width:280px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; display:inline-block; vertical-align:middle; }
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
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link active" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building me-1"></i>오피스 관리</a>
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
                <h5 class="mb-1 fw-bold"><i class="bi bi-robot me-2 text-info"></i>챗봇 상담내역</h5>
                <small class="text-muted">고객 챗봇 상담 세션을 조회하고 미해결 내역을 확인합니다.</small>
            </div>
        </div>

        <!-- ── 통계 카드 ────────────────────────────────────────── -->
        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-primary">${totalRecord}</div>
                    <div class="text-muted small mt-1">전체 상담건수</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-danger" id="unresolvedTotal">-</div>
                    <div class="text-muted small mt-1">미해결 세션</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="number text-success" id="resolvedTotal">-</div>
                    <div class="text-muted small mt-1">완료 세션</div>
                </div>
            </div>
        </div>

        <!-- ── 상담 목록 섹션 ────────────────────────────────────── -->
        <div class="section-card">
            <!-- 목록 헤더 -->
            <div class="section-header">
                <span class="small text-muted">총 ${totalRecord}건</span>
            </div>

            <!-- 필터 바 -->
            <div class="filter-bar">
                <form method="get" action="${ctx}/admin/chatbot/list" class="row g-2 align-items-end">
                    <input type="hidden" name="statusFilter" value="${chatbotVO.statusFilter}">
                    <input type="hidden" name="nowPage" value="1">
                    <!-- 고객명/이메일 검색 -->
                    <div class="col-auto">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="searchWord" class="form-control"
                                   placeholder="고객명 또는 이메일 검색"
                                   value="${chatbotVO.searchWord}" style="min-width:200px;">
                        </div>
                    </div>
                    <!-- 날짜 범위 -->
                    <div class="col-auto">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text"><i class="bi bi-calendar3"></i></span>
                            <input type="date" name="dateFrom" class="form-control"
                                   value="${chatbotVO.dateFrom}">
                            <span class="input-group-text">~</span>
                            <input type="date" name="dateTo" class="form-control"
                                   value="${chatbotVO.dateTo}">
                        </div>
                    </div>
                    <!-- 페이지당 건수 -->
                    <div class="col-auto">
                        <select name="numPerPage" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="10"  ${numPerPage == 10  ? 'selected' : ''}>10건</option>
                            <option value="20"  ${numPerPage == 20  ? 'selected' : ''}>20건</option>
                            <option value="50"  ${numPerPage == 50  ? 'selected' : ''}>50건</option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <button class="btn btn-outline-primary btn-sm" type="submit">
                            <i class="bi bi-search me-1"></i>검색
                        </button>
                        <a href="${ctx}/admin/chatbot/list?statusFilter=${chatbotVO.statusFilter}&numPerPage=${numPerPage}"
                           class="btn btn-outline-secondary btn-sm ms-1">초기화</a>
                    </div>
                </form>
            </div>

            <!-- 상담 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width:80px;">세션번호</th>
                            <th style="width:100px;">고객명</th>
                            <th>첫 질문 미리보기</th>
                            <th style="width:90px;">대화횟수</th>
                            <th style="width:120px;">상담일</th>
                            <th style="width:90px;">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty sessionList}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox me-1"></i>상담 내역이 없습니다.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="session" items="${sessionList}">
                                    <tr onclick="location.href='${ctx}/admin/chatbot/detail?cSession=${session.chatSession}&nowPage=${nowPage}&numPerPage=${numPerPage}&statusFilter=${chatbotVO.statusFilter}&searchWord=${chatbotVO.searchWord}&dateFrom=${chatbotVO.dateFrom}&dateTo=${chatbotVO.dateTo}'">
                                        <td class="text-muted small">#${session.chatSession}</td>
                                        <td class="small fw-semibold">${session.userName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty session.firstMessage}">
                                                    <c:choose>
                                                        <c:when test="${fn:length(session.firstMessage) > 20}">
                                                            <span class="preview-text" title="${session.firstMessage}">
                                                                ${fn:substring(session.firstMessage, 0, 20)}...
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="preview-text">${session.firstMessage}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center small">${session.msgCount}회</td>
                                        <td class="text-muted small">${session.startTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${session.unresolvedCount > 0}">
                                                    <span class="badge badge-unresolved">
                                                        <i class="bi bi-exclamation-circle me-1"></i>미해결
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-resolved">
                                                        <i class="bi bi-check-circle me-1"></i>완료
                                                    </span>
                                                </c:otherwise>
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
                                <a class="page-link" href="${ctx}/admin/chatbot/list?nowPage=${beginBlock - 1}&numPerPage=${numPerPage}&statusFilter=${chatbotVO.statusFilter}&searchWord=${chatbotVO.searchWord}&dateFrom=${chatbotVO.dateFrom}&dateTo=${chatbotVO.dateTo}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach begin="${beginBlock}" end="${endBlock}" var="page">
                            <li class="page-item ${page == nowPage ? 'active' : ''}">
                                <a class="page-link" href="${ctx}/admin/chatbot/list?nowPage=${page}&numPerPage=${numPerPage}&statusFilter=${chatbotVO.statusFilter}&searchWord=${chatbotVO.searchWord}&dateFrom=${chatbotVO.dateFrom}&dateTo=${chatbotVO.dateTo}">
                                    ${page}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/chatbot/list?nowPage=${endBlock + 1}&numPerPage=${numPerPage}&statusFilter=${chatbotVO.statusFilter}&searchWord=${chatbotVO.searchWord}&dateFrom=${chatbotVO.dateFrom}&dateTo=${chatbotVO.dateTo}">
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
<script>
    // 현재 페이지의 세션 목록에서 미해결/완료 수 계산하여 통계 카드 표시
    (function() {
        var rows = document.querySelectorAll('tbody tr');
        var unresolved = 0, resolved = 0;
        rows.forEach(function(row) {
            if (row.querySelector('.badge-unresolved')) unresolved++;
            else if (row.querySelector('.badge-resolved')) resolved++;
        });
        document.getElementById('unresolvedTotal').textContent = unresolved;
        document.getElementById('resolvedTotal').textContent   = resolved;
    })();
</script>
</body>
</html>

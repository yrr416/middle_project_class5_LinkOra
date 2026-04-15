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
    <title>공지 관리 - 오피스 예약 플랫폼</title>
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

        /* ── 공통 섹션 카드 ── */
        .section-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; margin-bottom:24px; }
        .section-header { padding:14px 20px; border-bottom:1px solid #f0f0f0; display:flex; justify-content:space-between; align-items:center; }
        .filter-bar { padding:14px 20px; border-bottom:1px solid #f0f0f0; background:#fafafa; }
        .table thead th { background:#f8f9fa; font-size:.83rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; cursor:pointer; }

        /* ── 고정 공지 행 강조 ── */
        tr.pinned td { background:#fffbeb !important; }
        tr.pinned:hover td { background:#fef3c7 !important; }

        /* ── 배지 ── */
        .badge-pinned  { background:#fef9c3; color:#854d0e; }
        .badge-normal  { background:#e5e7eb; color:#374151; }

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
            <a class="nav-link active" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
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
                <h5 class="mb-1 fw-bold"><i class="bi bi-bell me-2 text-warning"></i>공지 관리</h5>
                <small class="text-muted">공지사항을 등록·수정·삭제하고 고정 여부를 설정합니다.</small>
            </div>
            <!-- 공지 등록 버튼 -->
            <a href="${ctx}/admin/notice/register?nowPage=${nowPage}" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-lg me-1"></i>공지 등록
            </a>
        </div>

        <!-- 등록/수정/삭제 완료 메시지 -->
        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                <i class="bi bi-check-circle me-1"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- ── 공지 목록 섹션 ───────────────────────────────────── -->
        <div class="section-card">
            <div class="section-header">
                <span class="fw-semibold">전체 공지 <span class="text-primary">${totalRecord}</span>건</span>
            </div>

            <!-- 검색/필터 바 -->
            <div class="filter-bar">
                <form method="get" action="${ctx}/admin/notice/list" class="row g-2 align-items-end">
                    <!-- 고정 필터 -->
                    <div class="col-auto">
                        <select name="activeFilter" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value=""  <c:if test="${noticeVO.activeFilter == ''}">selected</c:if>>전체</option>
                            <option value="1" <c:if test="${noticeVO.activeFilter == '1'}">selected</c:if>>고정 공지</option>
                            <option value="0" <c:if test="${noticeVO.activeFilter == '0'}">selected</c:if>>일반 공지</option>
                        </select>
                    </div>
                    <!-- 제목 검색 -->
                    <div class="col-auto">
                        <div class="input-group input-group-sm">
                            <input type="text" name="searchWord" class="form-control"
                                   placeholder="제목 검색" value="${noticeVO.searchWord}">
                            <button class="btn btn-outline-secondary" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                    <!-- 검색 초기화 -->
                    <div class="col-auto">
                        <a href="${ctx}/admin/notice/list" class="btn btn-outline-secondary btn-sm">초기화</a>
                    </div>
                </form>
            </div>

            <!-- 공지 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th style="width:60px;">번호</th>
                            <th>제목</th>
                            <th style="width:100px;">고정 여부</th>
                            <th style="width:150px;">작성일</th>
                            <th style="width:160px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty noticeList}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox me-1"></i>등록된 공지가 없습니다.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="notice" items="${noticeList}">
                                    <tr class="${notice.ntcActive == '1' ? 'pinned' : ''}">
                                        <td class="text-muted small">${notice.ntcIdx}</td>
                                        <td>
                                            <!-- 제목 클릭 → 수정 폼 이동 -->
                                            <a href="${ctx}/admin/notice/update?ntcIdx=${notice.ntcIdx}&nowPage=${nowPage}"
                                               class="text-decoration-none text-dark fw-semibold">
                                                <c:if test="${notice.ntcActive == '1'}">
                                                    <i class="bi bi-pin-angle-fill text-warning me-1"></i>
                                                </c:if>
                                                ${notice.ntcTitle}
                                            </a>
                                        </td>
                                        <td>
                                            <!-- 고정 배지 -->
                                            <c:choose>
                                                <c:when test="${notice.ntcActive == '1'}">
                                                    <span class="badge badge-pinned">고정</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-normal">일반</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small">${notice.ntcCreated}</td>
                                        <td>
                                            <!-- 고정/해제 토글 버튼 -->
                                            <form method="post" action="${ctx}/admin/notice/toggle" class="d-inline">
                                                <input type="hidden" name="ntcIdx"        value="${notice.ntcIdx}">
                                                <input type="hidden" name="nowPage"      value="${nowPage}">
                                                <input type="hidden" name="searchWord"  value="${noticeVO.searchWord}">
                                                <input type="hidden" name="activeFilter" value="${noticeVO.activeFilter}">
                                                <c:choose>
                                                    <c:when test="${notice.ntcActive == '1'}">
                                                        <button type="submit" class="btn btn-sm btn-warning me-1" title="고정 해제">
                                                            <i class="bi bi-pin-angle"></i> 해제
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="btn btn-sm btn-outline-warning me-1" title="고정 설정">
                                                            <i class="bi bi-pin-angle-fill"></i> 고정
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                            <!-- 수정 버튼 -->
                                            <a href="${ctx}/admin/notice/update?ntcIdx=${notice.ntcIdx}&nowPage=${nowPage}"
                                               class="btn btn-sm btn-outline-primary me-1">수정</a>
                                            <!-- 삭제 버튼 -->
                                            <form method="post" action="${ctx}/admin/notice/delete" class="d-inline"
                                                  onsubmit="return confirm('공지를 삭제하시겠습니까?');">
                                                <input type="hidden" name="ntcIdx"   value="${notice.ntcIdx}">
                                                <input type="hidden" name="nowPage" value="${nowPage}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
                                            </form>
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
                        <!-- 이전 블록 -->
                        <c:if test="${beginBlock > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/notice/list?nowPage=${beginBlock - 1}&searchWord=${noticeVO.searchWord}&activeFilter=${noticeVO.activeFilter}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <!-- 페이지 번호 -->
                        <c:forEach begin="${beginBlock}" end="${endBlock}" var="page">
                            <li class="page-item ${page == nowPage ? 'active' : ''}">
                                <a class="page-link" href="${ctx}/admin/notice/list?nowPage=${page}&searchWord=${noticeVO.searchWord}&activeFilter=${noticeVO.activeFilter}">
                                    ${page}
                                </a>
                            </li>
                        </c:forEach>
                        <!-- 다음 블록 -->
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/notice/list?nowPage=${endBlock + 1}&searchWord=${noticeVO.searchWord}&activeFilter=${noticeVO.activeFilter}">
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객 관리 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .stats-card { background:#fff; border-radius:10px; padding:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); text-align:center; }
        .stats-card .number { font-size:2rem; font-weight:700; }
        .table-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; }
        .table thead th { background:#f8f9fa; font-size:.85rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; cursor:pointer; }
        .badge-active   { background:#d1fae5; color:#065f46; }
        .badge-inactive { background:#fee2e2; color:#991b1b; }
        .search-area { background:#fff; border-radius:10px; padding:16px 20px; margin-bottom:16px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
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
            <a class="nav-link" href="/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link active" href="/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="#"><i class="bi bi-building"></i>오피스 관리</a>
            <a class="nav-link" href="#"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="#"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="#"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="#"><i class="bi bi-gear"></i>설정</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-people me-2 text-primary"></i>고객 관리</h5>
                <small class="text-muted">등록된 회원 정보를 조회하고 관리합니다.</small>
            </div>
            <a href="/admin/customer/register" class="btn btn-primary btn-sm">
                <i class="bi bi-person-plus me-1"></i>신규 고객 등록
            </a>
        </div>

        <!-- 통계 카드 -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-primary">${totalRecord}</div>
                    <div class="text-muted small mt-1">전체 회원</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="activeCnt" value="0"/>
                    <c:forEach var="c" items="${customerList}">
                        <c:if test="${c.u_active == '0'}"><c:set var="activeCnt" value="${activeCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-success">${activeCnt}</div>
                    <div class="text-muted small mt-1">정상 (이 페이지)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="hiddenCnt" value="0"/>
                    <c:forEach var="c" items="${customerList}">
                        <c:if test="${c.u_active == '1'}"><c:set var="hiddenCnt" value="${hiddenCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-danger">${hiddenCnt}</div>
                    <div class="text-muted small mt-1">숨김 (이 페이지)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-secondary">${totalPage}</div>
                    <div class="text-muted small mt-1">전체 페이지</div>
                </div>
            </div>
        </div>

        <!-- 검색 영역 -->
        <div class="search-area">
            <form method="get" action="/admin/customer/list" class="row g-2 align-items-end">
                <!-- 상태 필터 (0=정상, 1=숨김) -->
                <div class="col-auto">
                    <label class="form-label small mb-1">상태</label>
                    <select name="status_filter" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <option value="0" ${customerVO.status_filter == '0' ? 'selected' : ''}>정상</option>
                        <option value="1" ${customerVO.status_filter == '1' ? 'selected' : ''}>숨김</option>
                    </select>
                </div>
                <!-- 검색 유형 -->
                <div class="col-auto">
                    <label class="form-label small mb-1">검색 항목</label>
                    <select name="search_type" class="form-select form-select-sm">
                        <option value="all"   ${customerVO.search_type == 'all'   ? 'selected':''}>전체</option>
                        <option value="name"  ${customerVO.search_type == 'name'  ? 'selected':''}>이름</option>
                        <option value="email" ${customerVO.search_type == 'email' ? 'selected':''}>이메일</option>
                        <option value="phone" ${customerVO.search_type == 'phone' ? 'selected':''}>전화번호</option>
                    </select>
                </div>
                <!-- 검색어 -->
                <div class="col">
                    <label class="form-label small mb-1">검색어</label>
                    <input type="text" name="search_word" value="${customerVO.search_word}"
                           class="form-control form-control-sm" placeholder="검색어를 입력하세요">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                    <a href="/admin/customer/list" class="btn btn-outline-secondary btn-sm ms-1">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                    </a>
                </div>
            </form>
        </div>

        <!-- 목록 테이블 -->
        <div class="table-card">
            <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
                <span class="small text-muted">
                    총 <strong>${totalRecord}</strong>명
                    <c:if test="${not empty customerVO.search_word}">
                        (검색: <strong>${customerVO.search_word}</strong>)
                    </c:if>
                </span>
                <span class="small text-muted">${nowPage} / ${totalPage} 페이지</span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">번호</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>주소</th>
                            <th>역할</th>
                            <th>예약 수</th>
                            <th>상태</th>
                            <th>가입일</th>
                            <th class="text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty customerList}">
                            <tr>
                                <td colspan="10" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                    조회된 회원이 없습니다.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="c" items="${customerList}">
                            <tr onclick="location.href='/admin/customer/detail?u_idx=${c.u_idx}&nowPage=${nowPage}'">
                                <td class="ps-4">${c.u_idx}</td>
                                <td><strong>${c.u_name}</strong></td>
                                <td>${c.u_email}</td>
                                <td>${c.u_phone}</td>
                                <td>${c.u_addr}</td>
                                <td>
                                    <span class="badge bg-secondary">${c.u_role}</span>
                                </td>
                                <td>${c.reserve_cnt}건</td>
                                <td>
                                    <!-- 0=정상(초록), 1=숨김(빨강) -->
                                    <c:choose>
                                        <c:when test="${c.u_active == '0'}">
                                            <span class="badge badge-active px-2 py-1 rounded-pill">정상</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-inactive px-2 py-1 rounded-pill">숨김</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${c.u_created}</td>
                                <td class="text-center" onclick="event.stopPropagation()">
                                    <a href="/admin/customer/detail?u_idx=${c.u_idx}&nowPage=${nowPage}"
                                       class="btn btn-outline-primary btn-sm py-0 px-2">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="/admin/customer/update?u_idx=${c.u_idx}&nowPage=${nowPage}"
                                       class="btn btn-outline-warning btn-sm py-0 px-2 ms-1">
                                        <i class="bi bi-pencil"></i>
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
                                <a class="page-link" href="/admin/customer/list?nowPage=${beginBlock-1}&search_type=${customerVO.search_type}&search_word=${customerVO.search_word}&status_filter=${customerVO.status_filter}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                            <li class="page-item ${nowPage == p ? 'active' : ''}">
                                <a class="page-link" href="/admin/customer/list?nowPage=${p}&search_type=${customerVO.search_type}&search_word=${customerVO.search_word}&status_filter=${customerVO.status_filter}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link" href="/admin/customer/list?nowPage=${endBlock+1}&search_type=${customerVO.search_type}&search_word=${customerVO.search_word}&status_filter=${customerVO.status_filter}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>

    </div><!-- /main-content -->
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

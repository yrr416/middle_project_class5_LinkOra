<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
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
        .role-tab { font-size:.8rem; }
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
            <a class="nav-link active" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
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

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-people me-2 text-primary"></i>고객 관리</h5>
                <small class="text-muted">등록된 회원 및 파트너 정보를 조회하고 관리합니다.</small>
            </div>
            <a href="${ctx}/admin/customer/register" class="btn btn-primary btn-sm">
                <i class="bi bi-person-plus me-1"></i>신규 고객 등록
            </a>
        </div>

        <!-- 통계 카드 -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-primary">${totalUserCnt}</div>
                    <div class="text-muted small mt-1">회원</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-info">${totalPartnerCnt}</div>
                    <div class="text-muted small mt-1">파트너</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="activeCnt" value="0"/>
                    <c:forEach var="c" items="${customerList}">
                        <c:if test="${c.userActive == '0'}"><c:set var="activeCnt" value="${activeCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-success">${activeCnt}</div>
                    <div class="text-muted small mt-1">정상 (이 페이지)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="hiddenCnt" value="0"/>
                    <c:forEach var="c" items="${customerList}">
                        <c:if test="${c.userActive != '0'}"><c:set var="hiddenCnt" value="${hiddenCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-danger">${hiddenCnt}</div>
                    <div class="text-muted small mt-1">숨김 (이 페이지)</div>
                </div>
            </div>
        </div>

        <!-- 검색 영역 -->
        <div class="search-area">
            <form method="get" action="${ctx}/admin/customer/list" class="row g-2 align-items-end">
                <input type="hidden" name="roleFilter" value="${customerVO.roleFilter}">
                <!-- 상태 필터 -->
                <div class="col-auto">
                    <label class="form-label small mb-1">상태</label>
                    <select name="statusFilter" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <option value="0" ${customerVO.statusFilter == '0' ? 'selected' : ''}>정상</option>
                        <option value="1" ${customerVO.statusFilter == '1' ? 'selected' : ''}>숨김</option>
                    </select>
                </div>
                <!-- 검색 유형 -->
                <div class="col-auto">
                    <label class="form-label small mb-1">검색 항목</label>
                    <select name="searchType" class="form-select form-select-sm">
                        <option value="all"   ${customerVO.searchType == 'all'   ? 'selected':''}>전체</option>
                        <option value="name"  ${customerVO.searchType == 'name'  ? 'selected':''}>이름</option>
                        <option value="email" ${customerVO.searchType == 'email' ? 'selected':''}>이메일</option>
                        <option value="phone" ${customerVO.searchType == 'phone' ? 'selected':''}>전화번호</option>
                    </select>
                </div>
                <!-- 검색어 -->
                <div class="col">
                    <label class="form-label small mb-1">검색어</label>
                    <input type="text" name="searchWord" value="${customerVO.searchWord}"
                           class="form-control form-control-sm" placeholder="검색어를 입력하세요">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                    <a href="${ctx}/admin/customer/list" class="btn btn-outline-secondary btn-sm ms-1">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                    </a>
                </div>
            </form>
        </div>

        <!-- 목록 테이블 -->
        <div class="table-card">
            <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
                <span class="small text-muted d-flex align-items-center gap-2">
                    총 <strong>${totalRecord}</strong>명
                    <c:if test="${not empty customerVO.searchWord}">
                        (검색: <strong>${customerVO.searchWord}</strong>)
                    </c:if>
                    <!-- 회원/파트너 구분 탭 -->
                    <span class="ms-2 d-flex gap-1">
                        <a href="${ctx}/admin/customer/list?statusFilter=${customerVO.statusFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}"
                           class="btn btn-sm role-tab ${empty customerVO.roleFilter ? 'btn-primary' : 'btn-outline-secondary'}">전체</a>
                        <a href="${ctx}/admin/customer/list?roleFilter=user&statusFilter=${customerVO.statusFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}"
                           class="btn btn-sm role-tab ${customerVO.roleFilter == 'user' ? 'btn-primary' : 'btn-outline-secondary'}">회원만</a>
                        <a href="${ctx}/admin/customer/list?roleFilter=partner&statusFilter=${customerVO.statusFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}"
                           class="btn btn-sm role-tab ${customerVO.roleFilter == 'partner' ? 'btn-info' : 'btn-outline-secondary'}">파트너만</a>
                    </span>
                </span>
                <span class="small text-muted">${nowPage} / ${totalPage} 페이지</span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">번호</th>
                            <th>구분</th>
                            <th>이름</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>주소</th>
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
                            <tr onclick="location.href='${ctx}/admin/customer/detail?userIdx=${c.userIdx}&memberType=${c.memberType}&nowPage=${nowPage}'">
                                <td class="ps-4">${c.userIdx}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.memberType == 'partner'}">
                                            <span class="badge bg-info text-dark">파트너</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">회원</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>${c.userName}</strong></td>
                                <td>${c.userEmail}</td>
                                <td>${c.userPhone}</td>
                                <td>${c.userAddr}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.memberType == 'partner'}">-</c:when>
                                        <c:otherwise>${c.reserveCnt}건</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.userActive == '0'}">
                                            <span class="badge badge-active px-2 py-1 rounded-pill">정상</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-inactive px-2 py-1 rounded-pill">숨김</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.userCreated}">${c.userCreated}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center" onclick="event.stopPropagation()">
                                    <a href="${ctx}/admin/customer/detail?userIdx=${c.userIdx}&memberType=${c.memberType}&nowPage=${nowPage}"
                                       class="btn btn-outline-primary btn-sm py-0 px-2">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${ctx}/admin/customer/update?userIdx=${c.userIdx}&memberType=${c.memberType}&nowPage=${nowPage}"
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
                                <a class="page-link" href="${ctx}/admin/customer/list?nowPage=${beginBlock-1}&roleFilter=${customerVO.roleFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}&statusFilter=${customerVO.statusFilter}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                            <li class="page-item ${nowPage == p ? 'active' : ''}">
                                <a class="page-link" href="${ctx}/admin/customer/list?nowPage=${p}&roleFilter=${customerVO.roleFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}&statusFilter=${customerVO.statusFilter}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${endBlock < totalPage}">
                            <li class="page-item">
                                <a class="page-link" href="${ctx}/admin/customer/list?nowPage=${endBlock+1}&roleFilter=${customerVO.roleFilter}&searchType=${customerVO.searchType}&searchWord=${customerVO.searchWord}&statusFilter=${customerVO.statusFilter}">
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        body { background-color: #f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .table-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; }
        .table thead th { background:#f8f9fa; font-size:.85rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; }
        .search-area { background:#fff; border-radius:10px; padding:16px 20px; margin-bottom:16px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .report-badge { background:#fee2e2; color:#991b1b; }
        .content-cell { max-width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
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
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
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
                <small class="text-muted">전체 리뷰를 조회하고 문제 리뷰를 삭제할 수 있습니다.</small>
            </div>
            <span class="text-muted small">총 <strong>${totalRecord}</strong>건</span>
        </div>

        <!-- 검색 -->
        <div class="search-area">
            <form method="get" action="${ctx}/admin/review/list" class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label small mb-1">검색 (작성자·공간명·내용)</label>
                    <input type="text" name="searchWord" value="${searchWord}"
                           class="form-control form-control-sm" placeholder="검색어를 입력하세요">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                    <a href="${ctx}/admin/review/list" class="btn btn-outline-secondary btn-sm ms-1">초기화</a>
                </div>
            </form>
        </div>

        <!-- 리뷰 테이블 -->
        <div class="table-card">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th style="width:60px;">번호</th>
                        <th style="width:100px;">작성자</th>
                        <th style="width:130px;">공간명</th>
                        <th style="width:50px;">별점</th>
                        <th>내용</th>
                        <th style="width:70px;">신고수</th>
                        <th style="width:110px;">작성일</th>
                        <th style="width:70px;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty reviewList}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>등록된 리뷰가 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reviewList}">
                                <tr>
                                    <td class="text-muted small">${r.revIdx}</td>
                                    <td>${r.authorName}</td>
                                    <td class="small">${r.spaceName}</td>
                                    <td class="text-center">
                                        <span class="text-warning">
                                            <c:forEach begin="1" end="${r.revRating}">★</c:forEach>
                                        </span>
                                        <span class="text-muted small">(${r.revRating})</span>
                                    </td>
                                    <td class="content-cell" title="${r.revContent}">${r.revContent}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.reportCount >= 3}">
                                                <span class="badge report-badge">${r.reportCount}회</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">${r.reportCount}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="small text-muted">
                                        <fmt:formatDate value="${r.revCreatedAt}" pattern="yy.MM.dd HH:mm"/>
                                    </td>
                                    <td>
                                        <form method="post" action="${ctx}/admin/review/delete"
                                              onsubmit="return confirm('이 리뷰를 삭제하시겠습니까?');">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="revIdx"     value="${r.revIdx}">
                                            <input type="hidden" name="nowPage"    value="${nowPage}">
                                            <input type="hidden" name="searchWord" value="${searchWord}">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash"></i>
                                            </button>
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
        <c:if test="${totalPage > 1}">
            <nav class="mt-3 d-flex justify-content-center">
                <ul class="pagination pagination-sm">
                    <c:if test="${beginBlock > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/admin/review/list?nowPage=${beginBlock - 1}&searchWord=${searchWord}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach begin="${beginBlock}" end="${endBlock}" var="p">
                        <li class="page-item ${p == nowPage ? 'active' : ''}">
                            <a class="page-link" href="${ctx}/admin/review/list?nowPage=${p}&searchWord=${searchWord}">${p}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${endBlock < totalPage}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/admin/review/list?nowPage=${endBlock + 1}&searchWord=${searchWord}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>

    </div><!-- /main-content -->
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

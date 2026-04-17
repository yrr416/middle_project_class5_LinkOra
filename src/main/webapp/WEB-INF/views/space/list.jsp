<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 관리 - 오피스 예약 플랫폼</title>
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
        .search-area { background:#fff; border-radius:10px; padding:16px 20px; margin-bottom:16px; box-shadow:0 1px 4px rgba(0,0,0,.06); }

        /* 공간 카드 */
        .space-card { background:#fff; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.08); overflow:hidden; transition:transform .2s, box-shadow .2s; }
        .space-card:hover { transform:translateY(-4px); box-shadow:0 6px 20px rgba(0,0,0,.12); }
        .space-card .thumbnail { width:100%; height:180px; object-fit:cover; background:#e9ecef; display:block; }
        .space-card .thumbnail-placeholder { width:100%; height:180px; background:linear-gradient(135deg,#e9ecef,#dee2e6); display:flex; align-items:center; justify-content:center; color:#adb5bd; font-size:3rem; }
        .space-card .card-body { padding:16px; }
        .space-card .space-name { font-weight:700; font-size:1rem; margin-bottom:6px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .space-card .space-meta { font-size:.82rem; color:#6c757d; }
        .space-card .space-price { font-size:1.1rem; font-weight:700; color:#0d6efd; }
        .space-card .toggle-btn { width:100%; border-radius:0 0 8px 8px; }

        /* 타입 배지 */
        .badge-conference { background:#dbeafe; color:#1d4ed8; }
        .badge-individual  { background:#d1fae5; color:#065f46; }
        .badge-lounge      { background:#fef3c7; color:#92400e; }

        /* 활성 배지 */
        .badge-active   { background:#d1fae5; color:#065f46; }
        .badge-inactive { background:#fee2e2; color:#991b1b; }
        .badge-pending  { background:#fef9c3; color:#854d0e; }

        /* 파트너 신청 테이블 */
        .pending-section { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; }
        .pending-section .section-header { background:linear-gradient(90deg,#fff7ed,#fff); border-bottom:1px solid #fed7aa; padding:14px 20px; }
        .table thead th { background:#f8f9fa; font-size:.85rem; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f0f4ff; }
        .usage-bar { height:6px; background:#e9ecef; border-radius:3px; overflow:hidden; }
        .usage-fill { height:100%; background:linear-gradient(90deg,#3b82f6,#6366f1); border-radius:3px; transition:width .4s; }
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
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
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
                <h5 class="mb-1 fw-bold"><i class="bi bi-building me-2 text-primary"></i>오피스 관리</h5>
                <small class="text-muted">등록된 공간을 조회하고 관리합니다.</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${ctx}/admin/space/register" class="btn btn-primary btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>공간 등록
                </a>
                <a href="${ctx}/partner/register/step1" class="btn btn-success btn-sm">
                    <i class="bi bi-plus-circle me-1"></i>오피스 등록 신청
                </a>
            </div>
        </div>

        <!-- 통계 카드 -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-primary">${totalRecord}</div>
                    <div class="text-muted small mt-1">전체 공간</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <c:set var="activeCnt" value="0"/>
                    <c:forEach var="s" items="${spaceList}">
                        <c:if test="${s.spcActive == '1'}"><c:set var="activeCnt" value="${activeCnt+1}"/></c:if>
                    </c:forEach>
                    <div class="number text-success">${activeCnt}</div>
                    <div class="text-muted small mt-1">운영 중 (이 페이지)</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-warning">${pendingList.size()}</div>
                    <div class="text-muted small mt-1">파트너 신청 대기</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="number text-secondary">${totalPage}</div>
                    <div class="text-muted small mt-1">전체 페이지</div>
                </div>
            </div>
        </div>

        <!-- 검색 / 필터 영역 -->
        <div class="search-area">
            <form method="get" action="${ctx}/admin/space/list" class="row g-2 align-items-end">
                <!-- 타입 필터 -->
                <div class="col-auto">
                    <label class="form-label small mb-1">공간 타입</label>
                    <select name="typeFilter" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <option value="CONFERENCE" ${spaceVO.typeFilter == 'CONFERENCE' ? 'selected':''}>회의실</option>
                        <option value="INDIVIDUAL"  ${spaceVO.typeFilter == 'INDIVIDUAL'  ? 'selected':''}>집중석</option>
                        <option value="LOUNGE"      ${spaceVO.typeFilter == 'LOUNGE'      ? 'selected':''}>라운지</option>
                    </select>
                </div>
                <!-- 활성 상태 필터 -->
                <div class="col-auto">
                    <label class="form-label small mb-1">상태</label>
                    <select name="activeFilter" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <option value="1" ${spaceVO.activeFilter == '1' ? 'selected':''}>활성</option>
                        <option value="2" ${spaceVO.activeFilter == '2' ? 'selected':''}>비활성</option>
                    </select>
                </div>
                <!-- 검색어 -->
                <div class="col">
                    <label class="form-label small mb-1">공간명 검색</label>
                    <input type="text" name="searchWord" value="${spaceVO.searchWord}"
                           class="form-control form-control-sm" placeholder="공간명을 입력하세요">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-search me-1"></i>검색
                    </button>
                    <a href="${ctx}/admin/space/list" class="btn btn-outline-secondary btn-sm ms-1">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>초기화
                    </a>
                </div>
            </form>
        </div>

        <!-- 공간 카드 목록 -->
        <div class="mb-2 d-flex justify-content-between align-items-center">
            <span class="text-muted small">총 <strong>${totalRecord}</strong>개 공간</span>
            <span class="text-muted small">${nowPage} / ${totalPage} 페이지</span>
        </div>

        <c:choose>
            <c:when test="${empty spaceList}">
                <div class="text-center py-5 text-muted bg-white rounded-3 shadow-sm">
                    <i class="bi bi-building fs-1 d-block mb-3 text-secondary"></i>
                    <p class="mb-0">등록된 공간이 없습니다.</p>
                    <a href="${ctx}/admin/space/register" class="btn btn-primary btn-sm mt-3">
                        <i class="bi bi-plus-circle me-1"></i>첫 번째 공간 등록하기
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-3 mb-4">
                    <c:forEach var="s" items="${spaceList}">
                        <div class="col-md-4">
                            <div class="space-card h-100 d-flex flex-column">
                                <!-- 썸네일 -->
                                <c:choose>
                                    <c:when test="${not empty s.spcImg}">
                                        <img src="${s.spcImg}" alt="${s.spcName}" class="thumbnail">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="thumbnail-placeholder">
                                            <i class="bi bi-image"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- 카드 본문 -->
                                <div class="card-body flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <!-- 타입 배지 -->
                                        <c:choose>
                                            <c:when test="${s.spcType == 'CONFERENCE'}">
                                                <span class="badge badge-conference rounded-pill">회의실</span>
                                            </c:when>
                                            <c:when test="${s.spcType == 'INDIVIDUAL'}">
                                                <span class="badge badge-individual rounded-pill">집중석</span>
                                            </c:when>
                                            <c:when test="${s.spcType == 'LOUNGE'}">
                                                <span class="badge badge-lounge rounded-pill">라운지</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary rounded-pill">${s.spcType}</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <!-- 활성 상태 배지 -->
                                        <c:choose>
                                            <c:when test="${s.spcActive == '1'}">
                                                <span class="badge badge-active rounded-pill">운영 중</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive rounded-pill">비활성</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="space-name">${s.spcName}</div>

                                    <div class="space-meta mb-2">
                                        <i class="bi bi-geo-alt me-1"></i>${not empty s.brnName ? s.brnName : '-'}
                                        &nbsp;|&nbsp;
                                        <i class="bi bi-people me-1"></i>최대 ${s.spcMaxCapacity}명
                                    </div>

                                    <!-- 이용률 -->
                                    <c:set var="usageMax" value="50"/>
                                    <c:set var="usageCnt" value="${empty s.reservationCnt ? 0 : s.reservationCnt}"/>
                                    <c:set var="usagePct" value="${usageCnt > usageMax ? 100 : usageCnt * 100 / usageMax}"/>
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <small class="text-muted">이용률</small>
                                        <small class="fw-bold">${usageCnt}회</small>
                                    </div>
                                    <div class="usage-bar mb-2">
                                        <div class="usage-fill" style="width:${usagePct}%"></div>
                                    </div>

                                    <div class="space-price mt-auto">
                                        <fmt:formatNumber value="${s.spcPrice}" type="number"/>원 <small class="text-muted fw-normal">/ 시간</small>
                                    </div>
                                </div>

                                <!-- 카드 푸터: 수정 + 토글 버튼 -->
                                <div class="d-flex border-top">
                                    <a href="${ctx}/admin/space/update?spcIdx=${s.spcIdx}&nowPage=${nowPage}"
                                       class="btn btn-sm btn-outline-primary flex-grow-1 rounded-0" style="border-right:0;">
                                        <i class="bi bi-pencil me-1"></i>수정
                                    </a>
                                    <form method="post" action="${ctx}/admin/space/toggle" class="flex-grow-1 m-0">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="spcIdx" value="${s.spcIdx}">
                                        <input type="hidden" name="nowPage" value="${nowPage}">
                                        <input type="hidden" name="typeFilter" value="${spaceVO.typeFilter}">
                                        <input type="hidden" name="activeFilter" value="${spaceVO.activeFilter}">
                                        <c:choose>
                                            <c:when test="${s.spcActive == '1'}">
                                                <input type="hidden" name="spcActive" value="2">
                                                <button type="submit" class="btn btn-sm btn-outline-danger toggle-btn rounded-0"
                                                        onclick="return confirm('이 공간을 비활성화하시겠습니까?')">
                                                    <i class="bi bi-pause-circle me-1"></i>비활성화
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="spcActive" value="1">
                                                <button type="submit" class="btn btn-sm btn-outline-success toggle-btn rounded-0"
                                                        onclick="return confirm('이 공간을 활성화하시겠습니까?')">
                                                    <i class="bi bi-play-circle me-1"></i>활성화
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- 페이징 -->
        <div class="d-flex justify-content-center mb-4">
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <c:if test="${beginBlock > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/admin/space/list?nowPage=${beginBlock-1}&typeFilter=${spaceVO.typeFilter}&activeFilter=${spaceVO.activeFilter}&searchWord=${spaceVO.searchWord}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach var="p" begin="${beginBlock}" end="${endBlock}">
                        <li class="page-item ${nowPage == p ? 'active' : ''}">
                            <a class="page-link" href="${ctx}/admin/space/list?nowPage=${p}&typeFilter=${spaceVO.typeFilter}&activeFilter=${spaceVO.activeFilter}&searchWord=${spaceVO.searchWord}">
                                ${p}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${endBlock < totalPage}">
                        <li class="page-item">
                            <a class="page-link" href="${ctx}/admin/space/list?nowPage=${endBlock+1}&typeFilter=${spaceVO.typeFilter}&activeFilter=${spaceVO.activeFilter}&searchWord=${spaceVO.searchWord}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>

        <!-- ====================================================
             파트너 신청 대기 매물 섹션
             ==================================================== -->
        <div class="pending-section mb-4">
            <div class="section-header d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-bold text-warning-emphasis">
                        <i class="bi bi-hourglass-split me-2 text-warning"></i>파트너 매물 검토 대기
                    </h6>
                    <small class="text-muted">파트너사가 등록한 공간입니다. 검토 후 수락 또는 거부하세요.</small>
                </div>
                <span class="badge bg-warning text-dark rounded-pill px-3">${pendingList.size()}건 대기 중</span>
            </div>

            <c:choose>
                <c:when test="${empty pendingList}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-check-circle fs-3 d-block mb-2 text-success"></i>
                        검토 대기 중인 파트너 매물이 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4" style="width:60px;">번호</th>
                                    <th style="width:80px;">썸네일</th>
                                    <th>공간명</th>
                                    <th>타입</th>
                                    <th>지점</th>
                                    <th>수용인원</th>
                                    <th>시간당 가격</th>
                                    <th>신청일</th>
                                    <th class="text-center" style="width:160px;">처리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pendingList}">
                                    <tr>
                                        <td class="ps-4">${p.spcIdx}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.spcImg}">
                                                    <img src="${p.spcImg}" alt="썸네일"
                                                         style="width:56px;height:40px;object-fit:cover;border-radius:4px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width:56px;height:40px;background:#e9ecef;border-radius:4px;display:flex;align-items:center;justify-content:center;">
                                                        <i class="bi bi-image text-muted small"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong>${p.spcName}</strong>
                                            <c:if test="${not empty p.spcDescription}">
                                                <br>
                                                <small class="text-muted" style="max-width:200px;display:inline-block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                    ${p.spcDescription}
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.spcType == 'CONFERENCE'}"><span class="badge badge-conference rounded-pill">회의실</span></c:when>
                                                <c:when test="${p.spcType == 'INDIVIDUAL'}"><span class="badge badge-individual rounded-pill">집중석</span></c:when>
                                                <c:when test="${p.spcType == 'LOUNGE'}"><span class="badge badge-lounge rounded-pill">라운지</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary rounded-pill">${p.spcType}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${not empty p.brnName ? p.brnName : '-'}</td>
                                        <td>${p.spcMaxCapacity}명</td>
                                        <td><fmt:formatNumber value="${p.spcPrice}" type="number"/>원</td>
                                        <td>${p.spcCreated}</td>
                                        <td class="text-center">
                                            <!-- 수락 -->
                                            <form method="post" action="${ctx}/admin/space/approve" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="spcIdx" value="${p.spcIdx}">
                                                <button type="submit" class="btn btn-success btn-sm"
                                                        onclick="return confirm('이 공간을 수락하시겠습니까?\n수락하면 바로 활성화됩니다.')">
                                                    <i class="bi bi-check-lg me-1"></i>수락
                                                </button>
                                            </form>
                                            <!-- 거부 -->
                                            <form method="post" action="${ctx}/admin/space/reject" class="d-inline ms-1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="spcIdx" value="${p.spcIdx}">
                                                <button type="submit" class="btn btn-danger btn-sm"
                                                        onclick="return confirm('이 공간을 거부하시겠습니까?\n거부하면 데이터가 완전히 삭제됩니다.')">
                                                    <i class="bi bi-x-lg me-1"></i>거부
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div><!-- /main-content -->
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

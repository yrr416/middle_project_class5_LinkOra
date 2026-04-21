<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isPartner" value="${memberType == 'partner'}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객 상세 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .info-card { background:#fff; border-radius:10px; padding:24px; box-shadow:0 1px 4px rgba(0,0,0,.06); margin-bottom:20px; }
        .card-title { font-size:.95rem; font-weight:600; color:#374151; margin-bottom:16px; padding-bottom:10px; border-bottom:2px solid #e5e7eb; }
        .info-row { display:flex; margin-bottom:12px; }
        .info-label { width:120px; min-width:120px; color:#6b7280; font-size:.875rem; }
        .info-value { color:#111827; font-size:.875rem; }
        .status-active   { display:inline-block; background:#d1fae5; color:#065f46; padding:3px 10px; border-radius:20px; font-size:.8rem; font-weight:600; }
        .status-inactive { display:inline-block; background:#fee2e2; color:#991b1b; padding:3px 10px; border-radius:20px; font-size:.8rem; font-weight:600; }
        .avatar-circle { width:80px; height:80px; background:linear-gradient(135deg,#667eea,#764ba2); border-radius:50%; display:flex; align-items:center; justify-content:center; color:#fff; font-size:2rem; font-weight:700; }
        .avatar-circle.partner { background:linear-gradient(135deg,#0ea5e9,#0284c7); }
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
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building me-1"></i>오피스 관리</a>
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
                <h5 class="mb-1 fw-bold">
                    <i class="bi bi-person-lines-fill me-2 text-primary"></i>
                    <c:choose>
                        <c:when test="${isPartner}">파트너 상세 정보</c:when>
                        <c:otherwise>고객 상세 정보</c:otherwise>
                    </c:choose>
                </h5>
                <small class="text-muted">
                    <c:choose>
                        <c:when test="${isPartner}">파트너의 상세 정보를 확인하고 관리합니다.</c:when>
                        <c:otherwise>회원의 상세 정보를 확인하고 관리합니다.</c:otherwise>
                    </c:choose>
                </small>
            </div>
            <a href="${ctx}/admin/customer/list?nowPage=${nowPage}" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <div class="row g-3">

            <!-- 왼쪽 : 프로필 + 상태 관리 -->
            <div class="col-md-4">

                <!-- 프로필 카드 -->
                <div class="info-card text-center mb-3">
                    <div class="avatar-circle ${isPartner ? 'partner' : ''} mx-auto mb-3">
                        ${fn:substring(cvo.userName, 0, 1)}
                    </div>
                    <h5 class="fw-bold mb-1">${cvo.userName}</h5>
                    <p class="text-muted small mb-2">${cvo.userEmail}</p>
                    <c:choose>
                        <c:when test="${isPartner}">
                            <span class="badge bg-info text-dark mb-1">파트너</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary mb-1">회원</span>
                        </c:otherwise>
                    </c:choose>
                    <br>
                    <c:choose>
                        <c:when test="${cvo.userActive == '0'}">
                            <span class="status-active">정상 이용중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-inactive">숨김 처리됨</span>
                        </c:otherwise>
                    </c:choose>
                    <hr>
                    <div class="row text-center g-0">
                        <c:choose>
                            <c:when test="${isPartner}">
                                <div class="col-12">
                                    <div class="fw-bold text-info fs-6">${cvo.partnerNumber}</div>
                                    <div class="text-muted" style="font-size:.75rem;">사업자번호</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-6 border-end">
                                    <div class="fw-bold text-primary fs-5">${cvo.reserveCnt}</div>
                                    <div class="text-muted" style="font-size:.75rem;">총 예약</div>
                                </div>
                                <div class="col-6">
                                    <div class="fw-bold text-secondary fs-5">회원</div>
                                    <div class="text-muted" style="font-size:.75rem;">구분</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 상태 변경 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-toggle-on me-2 text-warning"></i>활성 상태 변경</div>
                    <form method="post" action="${ctx}/admin/customer/statusChange" id="statusForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="userIdx"    value="${cvo.userIdx}">
                        <input type="hidden" name="memberType" value="${memberType}">
                        <input type="hidden" name="nowPage"    value="${nowPage}">
                        <input type="hidden" name="userActive" id="statusInput">
                        <div class="d-grid gap-2">
                            <c:if test="${cvo.userActive == '1'}">
                                <button type="button" class="btn btn-success btn-sm"
                                        onclick="changeStatus('0','정상 상태로 복구하시겠습니까?')">
                                    <i class="bi bi-check-circle me-1"></i>정상 복구
                                </button>
                            </c:if>
                            <c:if test="${cvo.userActive == '0'}">
                                <button type="button" class="btn btn-warning btn-sm"
                                        onclick="changeStatus('1','이 계정을 숨김 처리하시겠습니까?')">
                                    <i class="bi bi-slash-circle me-1"></i>숨김 처리
                                </button>
                            </c:if>
                        </div>
                    </form>
                </div>

                <!-- 계정 숨김/삭제 처리 -->
                <div class="info-card">
                    <div class="card-title text-danger"><i class="bi bi-eye-slash me-2"></i>계정 숨김 처리</div>
                    <p class="small text-muted mb-2">
                        숨김 처리 시 active 값이 1로 변경됩니다.<br>
                        데이터는 보존되며 복구 가능합니다.
                    </p>
                    <form method="post" action="${ctx}/admin/customer/delete"
                          onsubmit="return confirm('이 계정을 숨김 처리하시겠습니까?\n(데이터는 보존됩니다)')">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="userIdx"    value="${cvo.userIdx}">
                        <input type="hidden" name="memberType" value="${memberType}">
                        <input type="hidden" name="nowPage"    value="${nowPage}">
                        <button type="submit" class="btn btn-outline-danger btn-sm w-100"
                                ${cvo.userActive == '1' ? 'disabled' : ''}>
                            <i class="bi bi-eye-slash me-1"></i>숨김 처리
                        </button>
                    </form>
                </div>
            </div>

            <!-- 오른쪽 : 상세 정보 -->
            <div class="col-md-8">

                <!-- 기본 정보 -->
                <div class="info-card">
                    <div class="card-title d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person me-2 text-primary"></i>기본 정보</span>
                        <a href="${ctx}/admin/customer/update?userIdx=${cvo.userIdx}&memberType=${memberType}&nowPage=${nowPage}"
                           class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-pencil me-1"></i>수정
                        </a>
                    </div>
                    <div class="info-row">
                        <span class="info-label">번호</span>
                        <span class="info-value">${cvo.userIdx}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">이름</span>
                        <span class="info-value">${cvo.userName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">이메일</span>
                        <span class="info-value">${cvo.userEmail}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">전화번호</span>
                        <span class="info-value">${cvo.userPhone}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">주소</span>
                        <span class="info-value">${cvo.userAddr}</span>
                    </div>
                    <c:if test="${isPartner}">
                        <div class="info-row">
                            <span class="info-label">사업자번호</span>
                            <span class="info-value">${cvo.partnerNumber}</span>
                        </div>
                    </c:if>
                </div>

                <!-- 계정 정보 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-clock-history me-2 text-info"></i>계정 정보</div>
                    <div class="info-row">
                        <span class="info-label">가입일</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty cvo.userCreated}">${cvo.userCreated}</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <c:if test="${!isPartner}">
                        <div class="info-row">
                            <span class="info-label">총 예약 수</span>
                            <span class="info-value"><strong>${cvo.reserveCnt}건</strong></span>
                        </div>
                    </c:if>
                    <div class="info-row">
                        <span class="info-label">활성여부</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${cvo.userActive == '0'}">
                                    <span class="status-active">정상 (0)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-inactive">숨김 (1)</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>


            </div>

        </div><!-- /row -->
    </div><!-- /main-content -->
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function changeStatus(status, message) {
        if (confirm(message)) {
            document.getElementById('statusInput').value = status;
            document.getElementById('statusForm').submit();
        }
    }
</script>
</body>
</html>

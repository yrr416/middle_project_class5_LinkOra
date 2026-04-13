<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isPartner" value="${memberType == 'partner'}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객 수정 - 오피스 예약 플랫폼</title>
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
        .form-card { background:#fff; border-radius:10px; padding:28px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .form-section-title { font-size:.9rem; font-weight:600; color:#374151; margin-bottom:16px; padding-bottom:8px; border-bottom:2px solid #e5e7eb; }
        .required-mark { color:#dc3545; margin-left:2px; }
        .readonly-field { background:#f3f4f6 !important; color:#6b7280; cursor:not-allowed; }
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
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building"></i>오피스 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
            <span class="nav-link text-white-50 small px-3 pb-1">파트너 페이지</span>
            <a class="nav-link" href="${ctx}/partner/register/step1"><i class="bi bi-person-badge me-1"></i>파트너 등록</a>
            <a class="nav-link" href="${ctx}/partner/reservation/list"><i class="bi bi-calendar2-check me-1"></i>파트너 예약 관리</a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-pencil-square me-2 text-warning"></i>
                    <c:choose>
                        <c:when test="${isPartner}">파트너 정보 수정</c:when>
                        <c:otherwise>고객 정보 수정</c:otherwise>
                    </c:choose>
                </h5>
                <small class="text-muted"><strong>${cvo.userName}</strong>
                    <c:choose>
                        <c:when test="${isPartner}">파트너의 정보를 수정합니다.</c:when>
                        <c:otherwise>회원의 정보를 수정합니다.</c:otherwise>
                    </c:choose>
                </small>
            </div>
            <div class="d-flex gap-2">
                <a href="${ctx}/admin/customer/detail?userIdx=${cvo.userIdx}&memberType=${memberType}&nowPage=${nowPage}"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>상세로
                </a>
                <a href="${ctx}/admin/customer/list?nowPage=${nowPage}"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-list me-1"></i>목록으로
                </a>
            </div>
        </div>

        <!-- 에러 메시지 -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>
                정보 수정에 실패했습니다. 다시 시도해주세요.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 수정 폼 -->
        <form method="post" action="${ctx}/admin/customer/update" onsubmit="return validateForm()">
            <input type="hidden" name="userIdx"    value="${cvo.userIdx}">
            <input type="hidden" name="memberType" value="${memberType}">
            <input type="hidden" name="nowPage"    value="${nowPage}">

            <div class="row g-3">

                <!-- 변경 불가 정보 -->
                <div class="col-md-6">
                    <div class="form-card">
                        <div class="form-section-title">
                            <i class="bi bi-lock me-2 text-secondary"></i>변경 불가 항목
                        </div>

                        <div class="mb-3">
                            <label class="form-label form-label-sm">번호</label>
                            <input type="text" class="form-control form-control-sm readonly-field"
                                   value="${cvo.userIdx}" readonly>
                        </div>
                        <c:if test="${!isPartner}">
                            <div class="mb-3">
                                <label class="form-label form-label-sm">가입일</label>
                                <input type="text" class="form-control form-control-sm readonly-field"
                                       value="${cvo.userCreated}" readonly>
                            </div>
                        </c:if>
                        <c:if test="${isPartner}">
                            <div class="mb-3">
                                <label class="form-label form-label-sm">사업자번호</label>
                                <input type="text" class="form-control form-control-sm readonly-field"
                                       value="${cvo.partnerNumber}" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label form-label-sm">구분</label>
                                <input type="text" class="form-control form-control-sm readonly-field"
                                       value="파트너" readonly>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- 수정 가능 정보 -->
                <div class="col-md-6">
                    <div class="form-card">
                        <div class="form-section-title">
                            <i class="bi bi-person-gear me-2 text-warning"></i>수정 가능 항목
                        </div>

                        <!-- 이름 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                이름 <span class="required-mark">*</span>
                            </label>
                            <input type="text" name="userName"
                                   class="form-control form-control-sm"
                                   value="${cvo.userName}" maxlength="50" required>
                        </div>

                        <!-- 이메일 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                이메일 <span class="required-mark">*</span>
                            </label>
                            <input type="email" name="userEmail"
                                   class="form-control form-control-sm"
                                   value="${cvo.userEmail}" required>
                        </div>

                        <!-- 전화번호 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">전화번호</label>
                            <input type="tel" name="userPhone" id="uPhone"
                                   class="form-control form-control-sm"
                                   value="${cvo.userPhone}" maxlength="20">
                        </div>

                        <!-- 주소 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">주소</label>
                            <input type="text" name="userAddr"
                                   class="form-control form-control-sm"
                                   value="${cvo.userAddr}">
                        </div>
                    </div>
                </div>

                <!-- 안내 + 제출 -->
                <div class="col-12">
                    <div class="alert alert-info py-2 mb-0">
                        <i class="bi bi-info-circle me-2"></i>
                        비밀번호 변경은 별도 기능을 통해 처리하세요.
                    </div>
                </div>
                <div class="col-12">
                    <div class="form-card py-3">
                        <div class="d-flex justify-content-center gap-2">
                            <button type="submit" class="btn btn-warning px-4">
                                <i class="bi bi-save me-2"></i>수정 완료
                            </button>
                            <a href="${ctx}/admin/customer/detail?userIdx=${cvo.userIdx}&memberType=${memberType}&nowPage=${nowPage}"
                               class="btn btn-outline-secondary px-4">
                                <i class="bi bi-x-circle me-2"></i>취소
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </form>

    </div><!-- /main-content -->
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('uPhone').addEventListener('input', function() {
        let val = this.value.replace(/[^0-9]/g, '');
        if (val.length <= 3)      this.value = val;
        else if (val.length <= 7) this.value = val.slice(0,3) + '-' + val.slice(3);
        else                      this.value = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
    });

    function validateForm() {
        const name  = document.querySelector('input[name="userName"]').value.trim();
        const email = document.querySelector('input[name="userEmail"]').value.trim();
        if (!name)  { alert('이름을 입력해주세요.'); return false; }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('올바른 이메일 형식을 입력해주세요.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 - Step 5</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; }
        .wizard-wrap { max-width: 860px; margin: 40px auto; }
        .step-bar .step { display:inline-flex; align-items:center; gap:6px; color:#aaa; font-size:.88rem; }
        .step-bar .step.active { color:#0d6efd; font-weight:600; }
        .step-bar .step.done  { color:#198754; }
        .step-bar .step-num { width:26px; height:26px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:.8rem; background:#e9ecef; color:#6c757d; }
        .step-bar .step.active .step-num { background:#0d6efd; color:#fff; }
        .step-bar .step.done  .step-num { background:#198754; color:#fff; }
        .step-bar .sep { color:#dee2e6; margin: 0 8px; }
        .card { border:none; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.08); }
        .review-section { background:#f8f9fa; border-radius:10px; padding:18px 20px; margin-bottom:16px; }
        .review-label { font-size:.8rem; color:#6c757d; margin-bottom:2px; }
        .review-value { font-weight:500; }
        .space-badge { font-size:.78rem; }
    </style>
</head>
<body>
<div class="wizard-wrap">

    <!-- 단계 표시 바 -->
    <div class="step-bar d-flex align-items-center mb-4">
        <span class="step done"><span class="step-num"><i class="bi bi-check"></i></span>기본 정보</span>
        <span class="sep">›</span>
        <span class="step done"><span class="step-num"><i class="bi bi-check"></i></span>운영 정보</span>
        <span class="sep">›</span>
        <span class="step done"><span class="step-num"><i class="bi bi-check"></i></span>공간 등록</span>
        <span class="sep">›</span>
        <span class="step done"><span class="step-num"><i class="bi bi-check"></i></span>사진 업로드</span>
        <span class="sep">›</span>
        <span class="step active"><span class="step-num">5</span>최종 확인</span>
    </div>

    <div class="card p-4">
        <h5 class="fw-bold mb-1"><i class="bi bi-clipboard-check me-2 text-primary"></i>최종 검토 및 제출</h5>
        <p class="text-muted small mb-4">입력하신 내용을 확인하고 등록 신청을 완료하세요.</p>

        <!-- 지점 기본 정보 -->
        <div class="review-section">
            <div class="fw-semibold mb-3"><i class="bi bi-building me-1"></i>지점 기본 정보</div>
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="review-label">지점명</div>
                    <div class="review-value">${branch.brnName}</div>
                </div>
                <div class="col-md-6">
                    <div class="review-label">연락처</div>
                    <div class="review-value">${branch.brnPhone}</div>
                </div>
                <div class="col-12">
                    <div class="review-label">주소</div>
                    <div class="review-value">${branch.brnAddress}</div>
                </div>
                <c:if test="${not empty branch.brnSns}">
                    <div class="col-12">
                        <div class="review-label">SNS / 홈페이지</div>
                        <div class="review-value"><a href="${branch.brnSns}" target="_blank">${branch.brnSns}</a></div>
                    </div>
                </c:if>
                <div class="col-12">
                    <div class="review-label">지점 소개</div>
                    <div class="review-value small">${branch.brnDescription}</div>
                </div>
            </div>
        </div>

        <!-- 운영 정보 -->
        <div class="review-section">
            <div class="fw-semibold mb-3"><i class="bi bi-clock me-1"></i>운영 정보</div>
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="review-label">운영 시간</div>
                    <div class="review-value">${branch.brnHours}</div>
                </div>
            </div>
        </div>

        <!-- 공간 목록 -->
        <div class="review-section">
            <div class="fw-semibold mb-3"><i class="bi bi-door-open me-1"></i>등록 공간 (${spaceList.size()}개)</div>
            <c:choose>
                <c:when test="${empty spaceList}">
                    <p class="text-muted small mb-0">등록된 공간이 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>공간명</th>
                                    <th>유형</th>
                                    <th>시간당 가격</th>
                                    <th>최대 수용</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="space" items="${spaceList}">
                                    <tr>
                                        <td>${space.spcName}</td>
                                        <td>
                                            <span class="badge ${space.spcType == 'INDIVIDUAL' ? 'bg-info' : 'bg-warning text-dark'} space-badge">
                                                ${space.spcType}
                                            </span>
                                        </td>
                                        <td><fmt:formatNumber value="${space.spcPrice}" pattern="#,###"/>원</td>
                                        <td>${space.spcMaxCapacity}명</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 안내 메시지 -->
        <div class="alert alert-info small mb-4">
            <i class="bi bi-info-circle me-1"></i>
            등록 신청 후 관리자 승인 절차가 진행됩니다. 승인 완료 후 플랫폼에 오피스가 공개됩니다.
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a href="${ctx}/partner/register/step4" class="btn btn-outline-secondary">
                <i class="bi bi-chevron-left"></i> 이전
            </a>
            <form method="post" action="${ctx}/partner/register/submit" class="d-inline">
                <button type="submit" class="btn btn-success px-4" onclick="return confirm('오피스 등록 신청을 완료하시겠습니까?')">
                    <i class="bi bi-check-circle me-1"></i>등록 신청 완료
                </button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 완료</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; }
        .complete-wrap { max-width: 560px; margin: 80px auto; text-align: center; }
        .check-icon { font-size: 5rem; color: #198754; }
        .card { border:none; border-radius:16px; box-shadow:0 4px 16px rgba(0,0,0,.1); }
    </style>
</head>
<body>
<div class="complete-wrap">
    <div class="card p-5">
        <div class="check-icon mb-3"><i class="bi bi-check-circle-fill"></i></div>
        <h4 class="fw-bold mb-2">등록 신청이 완료되었습니다!</h4>
        <p class="text-muted">
            관리자 검토 후 승인 절차가 진행됩니다.<br>
            승인 완료 시 플랫폼에 오피스가 공개됩니다.
        </p>
        <c:if test="${not empty msg}">
            <div class="alert alert-success small mt-2">${msg}</div>
        </c:if>
        <div class="d-flex justify-content-center gap-3 mt-3">
            <a href="${ctx}/partner/mypage" class="btn btn-outline-primary">
                <i class="bi bi-person-circle me-1"></i>마이페이지
            </a>
            <a href="${ctx}/partner/register/step1" class="btn btn-success">
                <i class="bi bi-plus-circle me-1"></i>추가 등록
            </a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

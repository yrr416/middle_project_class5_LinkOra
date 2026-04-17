<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 - Step 2</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; }
        .wizard-wrap { max-width: 780px; margin: 40px auto; }
        .step-bar .step { display:inline-flex; align-items:center; gap:6px; color:#aaa; font-size:.88rem; }
        .step-bar .step.active { color:#0d6efd; font-weight:600; }
        .step-bar .step.done  { color:#198754; }
        .step-bar .step-num { width:26px; height:26px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:.8rem; background:#e9ecef; color:#6c757d; }
        .step-bar .step.active .step-num { background:#0d6efd; color:#fff; }
        .step-bar .step.done  .step-num { background:#198754; color:#fff; }
        .step-bar .sep { color:#dee2e6; margin: 0 8px; }
        .card { border:none; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.08); }
        .day-btn { cursor:pointer; }
        .day-btn input[type=checkbox] { display:none; }
        .day-btn label { display:inline-block; padding:6px 14px; border:1px solid #dee2e6; border-radius:20px; cursor:pointer; font-size:.88rem; }
        .day-btn input:checked + label { background:#0d6efd; color:#fff; border-color:#0d6efd; }
    </style>
</head>
<body>
<div class="wizard-wrap">

    <!-- 단계 표시 바 -->
    <div class="step-bar d-flex align-items-center mb-4">
        <span class="step done"><span class="step-num"><i class="bi bi-check"></i></span>기본 정보</span>
        <span class="sep">›</span>
        <span class="step active"><span class="step-num">2</span>운영 정보</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">3</span>공간 등록</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">4</span>사진 업로드</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">5</span>최종 확인</span>
    </div>

    <div class="card p-4">
        <h5 class="fw-bold mb-1"><i class="bi bi-clock me-2 text-primary"></i>운영 정보</h5>
        <p class="text-muted small mb-4">운영 요일, 시간, 예약 정책을 설정하세요.</p>

        <form method="post" action="${ctx}/partner/register/step2" id="step2Form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

            <!-- 운영 요일 -->
            <div class="mb-4">
                <label class="form-label fw-semibold">운영 요일 <span class="text-danger">*</span></label>
                <div class="d-flex flex-wrap gap-2" id="dayGroup">
                    <c:forEach var="day" items="${['월','화','수','목','금','토','일']}">
                        <span class="day-btn">
                            <input type="checkbox" id="day_${day}" name="dayCheck" value="${day}">
                            <label for="day_${day}">${day}</label>
                        </span>
                    </c:forEach>
                </div>
                <!-- 선택된 요일을 문자열로 담을 hidden -->
                <input type="hidden" id="operDays" name="operDays" required>
            </div>

            <!-- 운영 시간 -->
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">운영 시작 시간 <span class="text-danger">*</span></label>
                    <input type="time" class="form-control" name="operStart"
                           value="${branchVO.operStart != null ? branchVO.operStart : '09:00'}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">운영 종료 시간 <span class="text-danger">*</span></label>
                    <input type="time" class="form-control" name="operEnd"
                           value="${branchVO.operEnd != null ? branchVO.operEnd : '18:00'}" required>
                </div>
            </div>

            <!-- 공휴일 운영 -->
            <div class="mb-3">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="holidayOp" name="holidayOp"
                           value="1" ${branchVO.holidayOp == 1 ? 'checked' : ''}>
                    <label class="form-check-label fw-semibold" for="holidayOp">공휴일 운영</label>
                </div>
            </div>

            <!-- 최소 예약 단위 -->
            <div class="mb-3">
                <label class="form-label fw-semibold">최소 예약 단위 <span class="text-danger">*</span></label>
                <select class="form-select" name="minUnit" required>
                    <option value="30분"  ${branchVO.minUnit == '30분'  ? 'selected' : ''}>30분</option>
                    <option value="1시간" ${branchVO.minUnit == '1시간' ? 'selected' : ''}>1시간</option>
                    <option value="2시간" ${branchVO.minUnit == '2시간' ? 'selected' : ''}>2시간</option>
                    <option value="반일"  ${branchVO.minUnit == '반일'  ? 'selected' : ''}>반일(4시간)</option>
                    <option value="하루"  ${branchVO.minUnit == '하루'  ? 'selected' : ''}>하루(8시간)</option>
                </select>
            </div>

            <!-- 최대 예약 가능 일수 -->
            <div class="mb-4">
                <label class="form-label fw-semibold">최대 예약 가능 일수 <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="maxDays" min="1" max="365"
                       value="${branchVO.maxDays > 0 ? branchVO.maxDays : 30}"
                       placeholder="예) 30" required>
                <div class="form-text">오늘 기준 몇 일 후까지 예약 가능한지 설정합니다.</div>
            </div>

            <div class="d-flex justify-content-between">
                <a href="${ctx}/partner/register/step1" class="btn btn-outline-secondary">
                    <i class="bi bi-chevron-left"></i> 이전
                </a>
                <button type="submit" class="btn btn-primary px-4">
                    다음 단계 <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 요일 체크박스 → hidden input 동기화
    function syncDays() {
        const checked = [...document.querySelectorAll('#dayGroup input:checked')].map(cb => cb.value);
        document.getElementById('operDays').value = checked.join(',');
    }

    document.querySelectorAll('#dayGroup input[type=checkbox]').forEach(cb => {
        cb.addEventListener('change', syncDays);
    });

    // 기존 저장 값 복원
    const savedDays = '${branchVO.operDays}';
    if (savedDays) {
        savedDays.split(',').forEach(d => {
            const cb = document.querySelector('#dayGroup input[value="' + d.trim() + '"]');
            if (cb) cb.checked = true;
        });
        syncDays();
    }

    // 폼 제출 전 요일 검증
    document.getElementById('step2Form').addEventListener('submit', function(e) {
        syncDays();
        if (!document.getElementById('operDays').value) {
            e.preventDefault();
            alert('운영 요일을 1개 이상 선택해주세요.');
        }
    });
</script>
</body>
</html>

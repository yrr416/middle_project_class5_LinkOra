<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 - Step 3</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; }
        .wizard-wrap { max-width: 900px; margin: 40px auto; }
        .step-bar .step { display:inline-flex; align-items:center; gap:6px; color:#aaa; font-size:.88rem; }
        .step-bar .step.active { color:#0d6efd; font-weight:600; }
        .step-bar .step.done  { color:#198754; }
        .step-bar .step-num { width:26px; height:26px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:.8rem; background:#e9ecef; color:#6c757d; }
        .step-bar .step.active .step-num { background:#0d6efd; color:#fff; }
        .step-bar .step.done  .step-num { background:#198754; color:#fff; }
        .step-bar .sep { color:#dee2e6; margin: 0 8px; }
        .card { border:none; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,.08); }
        .space-card { border:1px solid #e9ecef; border-radius:10px; padding:20px; margin-bottom:16px; background:#fff; position:relative; }
        .space-card .card-num { position:absolute; top:12px; right:14px; font-size:.8rem; color:#aaa; }
        .facility-check label { font-size:.83rem; }
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
        <span class="step active"><span class="step-num">3</span>공간 등록</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">4</span>사진 업로드</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">5</span>최종 확인</span>
    </div>

    <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-1">
            <h5 class="fw-bold mb-0"><i class="bi bi-door-open me-2 text-primary"></i>공간(룸) 등록</h5>
            <button type="button" class="btn btn-outline-primary btn-sm" onclick="addSpace()">
                <i class="bi bi-plus-circle me-1"></i>공간 추가
            </button>
        </div>
        <p class="text-muted small mb-4">등록할 공간(룸)을 1개 이상 입력하세요.</p>

        <form method="post" action="${ctx}/partner/register/step3" id="step3Form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" id="spacesJson" name="spacesJson">

            <!-- 공간 목록 영역 -->
            <div id="spaceContainer"></div>

            <div class="d-flex justify-content-between mt-3">
                <a href="${ctx}/partner/register/step2" class="btn btn-outline-secondary">
                    <i class="bi bi-chevron-left"></i> 이전
                </a>
                <button type="submit" class="btn btn-primary px-4">
                    다음 단계 <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- 공간 카드 템플릿 -->
<template id="spaceTemplate">
    <div class="space-card" id="spaceCard_{idx}">
        <span class="card-num">공간 ${num}</span>
        <div class="row g-3">
            <!-- 공간 유형 -->
            <div class="col-md-4">
                <label class="form-label fw-semibold small">공간 유형 <span class="text-danger">*</span></label>
                <select class="form-select form-select-sm" data-field="spcType" required>
                    <option value="INDIVIDUAL">개인 공간 (INDIVIDUAL)</option>
                    <option value="GROUP">그룹 공간 (GROUP)</option>
                </select>
            </div>
            <!-- 공간 이름 -->
            <div class="col-md-8">
                <label class="form-label fw-semibold small">공간 이름 <span class="text-danger">*</span></label>
                <input type="text" class="form-control form-control-sm" data-field="spcName"
                       placeholder="예) A룸, 세미나실 1" required>
            </div>
            <!-- 가격 -->
            <div class="col-md-4">
                <label class="form-label fw-semibold small">시간당 가격(원) <span class="text-danger">*</span></label>
                <input type="number" class="form-control form-control-sm" data-field="spcPrice"
                       placeholder="예) 10000" min="0" required>
            </div>
            <!-- 최대 수용 인원 -->
            <div class="col-md-4">
                <label class="form-label fw-semibold small">최대 수용 인원 <span class="text-danger">*</span></label>
                <input type="number" class="form-control form-control-sm" data-field="spcMaxCapacity"
                       placeholder="예) 8" min="1" required>
            </div>
            <!-- 활성 여부 -->
            <div class="col-md-4 d-flex align-items-end">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" data-field="spcActive" checked>
                    <label class="form-check-label small">즉시 활성화</label>
                </div>
            </div>
            <!-- 공간 설명 -->
            <div class="col-12">
                <label class="form-label fw-semibold small">공간 설명</label>
                <textarea class="form-control form-control-sm" data-field="spcDescription"
                          rows="2" placeholder="공간에 대한 간략한 설명을 입력하세요."></textarea>
            </div>
            <!-- 시설 정보 -->
            <div class="col-12">
                <label class="form-label fw-semibold small">시설/편의시설</label>
                <div class="d-flex flex-wrap gap-3 facility-check">
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facCafe"><label class="form-check-label">카페</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facDesk"><label class="form-check-label">좌석</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facDelivery"><label class="form-check-label">배달수령</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facWater"><label class="form-check-label">음료제공</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="fac24hours"><label class="form-check-label">24시간</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facKitchen"><label class="form-check-label">주방</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facDisplay"><label class="form-check-label">디스플레이</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facStorage"><label class="form-check-label">짐보관</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facParking"><label class="form-check-label">주차</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facFax"><label class="form-check-label">팩스</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facPet"><label class="form-check-label">반려동물</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" data-fac="facLounge"><label class="form-check-label">라운지</label></div>
                </div>
            </div>
            <!-- 삭제 버튼 -->
            <div class="col-12 text-end">
                <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeSpace({idx})">
                    <i class="bi bi-trash me-1"></i>이 공간 삭제
                </button>
            </div>
        </div>
    </div>
</template>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let spaceIdx = 0;

    // 공간 카드 추가
    function addSpace() {
        const tpl = document.getElementById('spaceTemplate').innerHTML
            .replace(/{idx}/g, spaceIdx)
            .replace(/{num}/g, spaceIdx + 1);
        document.getElementById('spaceContainer').insertAdjacentHTML('beforeend', tpl);
        spaceIdx++;
    }

    // 공간 카드 삭제
    function removeSpace(idx) {
        const card = document.getElementById('spaceCard_' + idx);
        if (card) card.remove();
        if (document.querySelectorAll('.space-card').length === 0) {
            addSpace(); // 최소 1개 유지
        }
    }

    // 폼 제출 시 JSON 직렬화
    document.getElementById('step3Form').addEventListener('submit', function(e) {
        const cards = document.querySelectorAll('.space-card');
        if (cards.length === 0) {
            e.preventDefault();
            alert('공간을 1개 이상 등록해주세요.');
            return;
        }

        const spaceList = [];
        cards.forEach(card => {
            const space = {};
            // 기본 필드
            card.querySelectorAll('[data-field]').forEach(el => {
                const field = el.dataset.field;
                if (el.type === 'checkbox') {
                    space[field] = el.checked ? 1 : 0;
                } else if (el.type === 'number') {
                    space[field] = parseInt(el.value) || 0;
                } else {
                    space[field] = el.value;
                }
            });
            // 시설 필드
            card.querySelectorAll('[data-fac]').forEach(cb => {
                space[cb.dataset.fac] = cb.checked ? 1 : 0;
            });
            spaceList.push(space);
        });

        document.getElementById('spacesJson').value = JSON.stringify(spaceList);
    });

    // 초기 공간 1개 표시
    addSpace();
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 - Step 1</title>
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
    </style>
</head>
<body>
<div class="wizard-wrap">

    <!-- 단계 표시 바 -->
    <div class="step-bar d-flex align-items-center mb-4">
        <span class="step active"><span class="step-num">1</span>기본 정보</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">2</span>운영 정보</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">3</span>공간 등록</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">4</span>사진 업로드</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">5</span>최종 확인</span>
    </div>

    <div class="card p-4">
        <h5 class="fw-bold mb-1"><i class="bi bi-building me-2 text-primary"></i>오피스 기본 정보</h5>
        <p class="text-muted small mb-4">지점(오피스)의 기본 정보를 입력하세요.</p>

        <form method="post" action="${ctx}/partner/register/step1" id="step1Form">

            <!-- 지점명 -->
            <div class="mb-3">
                <label class="form-label fw-semibold">지점명 <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="brnName"
                       value="${branchVO.brnName}" placeholder="예) 강남 오피스" required>
            </div>

            <!-- 지점 설명 (CKEditor) -->
            <div class="mb-3">
                <label class="form-label fw-semibold">지점 소개 <span class="text-danger">*</span></label>
                <textarea id="brnDescription" name="brnDescription" class="form-control" rows="5"
                          placeholder="오피스에 대한 상세 소개를 입력하세요.">${branchVO.brnDescription}</textarea>
            </div>

            <!-- 주소 (카카오 우편번호) -->
            <div class="mb-3">
                <label class="form-label fw-semibold">주소 <span class="text-danger">*</span></label>
                <div class="input-group mb-2">
                    <input type="text" id="roadAddress" name="roadAddress" class="form-control"
                           placeholder="도로명 주소" value="${branchVO.roadAddress}" readonly required>
                    <button type="button" class="btn btn-outline-secondary" onclick="searchAddress()">
                        <i class="bi bi-search"></i> 주소 찾기
                    </button>
                </div>
                <input type="text" name="detailAddress" class="form-control"
                       placeholder="상세 주소를 입력하세요" value="${branchVO.detailAddress}">
            </div>

            <!-- 연락처 -->
            <div class="mb-3">
                <label class="form-label fw-semibold">연락처 <span class="text-danger">*</span></label>
                <input type="tel" class="form-control" name="brnPhone"
                       value="${branchVO.brnPhone}" placeholder="예) 02-1234-5678" required>
            </div>

            <!-- SNS -->
            <div class="mb-4">
                <label class="form-label fw-semibold">SNS / 홈페이지 URL</label>
                <input type="url" class="form-control" name="brnSns"
                       value="${branchVO.brnSns}" placeholder="https://...">
            </div>

            <div class="d-flex justify-content-end">
                <button type="submit" class="btn btn-primary px-4">
                    다음 단계 <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- 카카오 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- CKEditor 5 -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // CKEditor 초기화 (인스턴스 저장)
    let editorInstance;
    ClassicEditor.create(document.querySelector('#brnDescription'))
        .then(editor => { editorInstance = editor; })
        .catch(console.error);

    // 카카오 주소 검색
    function searchAddress() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('roadAddress').value = data.roadAddress || data.jibunAddress;
            }
        }).open();
    }

    // 폼 제출 시 CKEditor 내용을 textarea로 동기화 (CKEditor5 는 자동 동기화 안 함)
    document.getElementById('step1Form').addEventListener('submit', function(e) {
        if (editorInstance) {
            document.querySelector('#brnDescription').value = editorInstance.getData();
        }
    });
</script>
</body>
</html>

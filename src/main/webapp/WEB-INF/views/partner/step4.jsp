<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오피스 등록 신청 - Step 4</title>
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

        /* 이미지 업로드 영역 */
        .upload-zone { border:2px dashed #dee2e6; border-radius:10px; padding:30px; text-align:center; cursor:pointer; transition:.2s; }
        .upload-zone:hover { border-color:#0d6efd; background:#f0f4ff; }
        .preview-grid { display:flex; flex-wrap:wrap; gap:10px; margin-top:12px; }
        .preview-item { position:relative; width:110px; height:110px; border-radius:8px; overflow:hidden; }
        .preview-item img { width:100%; height:100%; object-fit:cover; }
        .preview-item .remove-btn { position:absolute; top:4px; right:4px; background:rgba(0,0,0,.55); color:#fff; border:none; border-radius:50%; width:22px; height:22px; font-size:.75rem; cursor:pointer; display:flex; align-items:center; justify-content:center; }
        .preview-item .main-badge { position:absolute; bottom:0; left:0; right:0; background:rgba(13,110,253,.85); color:#fff; font-size:.7rem; text-align:center; padding:2px 0; }
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
        <span class="step active"><span class="step-num">4</span>사진 업로드</span>
        <span class="sep">›</span>
        <span class="step"><span class="step-num">5</span>최종 확인</span>
    </div>

    <div class="card p-4">
        <h5 class="fw-bold mb-1"><i class="bi bi-images me-2 text-primary"></i>사진 업로드</h5>
        <p class="text-muted small mb-4">지점 및 공간 대표 사진을 등록하세요. 첫 번째 사진이 대표 이미지로 사용됩니다.</p>

        <form method="post" action="${ctx}/partner/register/step4" id="step4Form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" id="branchImgsJson" name="branchImgsJson" value="[]">
            <input type="hidden" id="spaceImgsJson"  name="spaceImgsJson"  value="[]">

            <!-- 지점 사진 -->
            <div class="mb-4">
                <label class="form-label fw-semibold">지점 사진 <span class="text-muted small">(최대 10장)</span></label>
                <div class="upload-zone" onclick="document.getElementById('branchFileInput').click()">
                    <i class="bi bi-cloud-upload fs-3 text-muted"></i>
                    <p class="text-muted mb-0 mt-2 small">클릭 또는 드래그하여 사진을 추가하세요</p>
                </div>
                <input type="file" id="branchFileInput" accept="image/*" multiple hidden onchange="previewImages(this, 'branchPreview', 'branch')">
                <div class="preview-grid" id="branchPreview"></div>
            </div>

            <!-- 공간별 사진 -->
            <c:if test="${not empty spaceList}">
                <div class="mb-4">
                    <label class="form-label fw-semibold">공간별 사진</label>
                    <c:forEach var="space" items="${spaceList}" varStatus="st">
                        <div class="mb-3">
                            <div class="text-muted small mb-1">${space.spcName} (${space.spcType})</div>
                            <div class="upload-zone" onclick="document.getElementById('spaceFile_${space.spcIdx}').click()">
                                <i class="bi bi-cloud-upload text-muted"></i>
                                <span class="text-muted small ms-2">${space.spcName} 사진 추가</span>
                            </div>
                            <input type="file" id="spaceFile_${space.spcIdx}" accept="image/*" multiple hidden
                                   data-sidx="${space.spcIdx}"
                                   onchange="previewImages(this, 'spacePreview_${space.spcIdx}', 'space', ${space.spcIdx})">
                            <div class="preview-grid" id="spacePreview_${space.spcIdx}"></div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <div class="d-flex justify-content-between">
                <a href="${ctx}/partner/register/step3" class="btn btn-outline-secondary">
                    <i class="bi bi-chevron-left"></i> 이전
                </a>
                <button type="submit" class="btn btn-primary px-4" onclick="buildJsonAndSubmit(event)">
                    다음 단계 <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 이미지 데이터 저장소
    const branchImgs = [];
    const spaceImgs  = [];

    // 파일 선택 → 서버 업로드 후 경로 저장
    function previewImages(input, previewId, type, sIdx) {
        const preview = document.getElementById(previewId);
        const files   = Array.from(input.files);

        files.forEach(file => {
            const localUrl = URL.createObjectURL(file);
            const formData = new FormData();
            formData.append('file', file);

            // CSRF 토큰을 헤더에 포함 (Spring Security CSRF 보호)
            fetch('${ctx}/partner/register/uploadImg', {
                method: 'POST',
                headers: { '${_csrf.headerName}': '${_csrf.token}' },
                body: formData
            })
                .then(res => res.text())
                .then(serverUrl => {
                    if (!serverUrl) return;
                    const isMain = (type === 'branch' ? branchImgs.length : spaceImgs.length) === 0;

                    // 미리보기 DOM
                    const div = document.createElement('div');
                    div.className = 'preview-item';
                    div.innerHTML = '<img src="' + localUrl + '" alt="preview">'
                        + (isMain ? '<span class="main-badge">대표</span>' : '')
                        + '<button type="button" class="remove-btn" onclick="removeImg(this,\'' + type + '\',' + (sIdx || 0) + ')">'
                        + '<i class="bi bi-x"></i></button>';
                    preview.appendChild(div);

                    // 서버 경로만 저장
                    if (type === 'branch') {
                        branchImgs.push({ briUrl: serverUrl });
                    } else {
                        spaceImgs.push({ spcIdx: sIdx, spiUrl: serverUrl });
                    }
                });
        });
    }

    // 이미지 제거 (간단 구현)
    function removeImg(btn, type, sIdx) {
        btn.closest('.preview-item').remove();
    }

    // 폼 제출 전 JSON 빌드
    function buildJsonAndSubmit(e) {
        e.preventDefault();
        document.getElementById('branchImgsJson').value = JSON.stringify(branchImgs);
        document.getElementById('spaceImgsJson').value  = JSON.stringify(spaceImgs);
        document.getElementById('step4Form').submit();
    }
</script>
</body>
</html>

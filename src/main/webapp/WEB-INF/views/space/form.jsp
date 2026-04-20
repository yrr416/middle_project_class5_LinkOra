<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mode == 'register' ? '공간 등록' : '공간 수정'} - 오피스 예약 플랫폼</title>
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
        .form-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; }
        .form-section { padding:24px; border-bottom:1px solid #f0f0f0; }
        .form-section:last-child { border-bottom:none; }
        .section-title { font-size:.9rem; font-weight:700; color:#495057; margin-bottom:16px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
        .amenity-box { display:flex; flex-wrap:wrap; gap:10px; }
        .amenity-item { display:flex; align-items:center; gap:6px; padding:8px 14px; border:1px solid #dee2e6; border-radius:8px; cursor:pointer; transition:all .15s; background:#fff; }
        .amenity-item:hover { border-color:#0d6efd; background:#f0f4ff; }
        .amenity-item input[type=checkbox]:checked + label { color:#0d6efd; }
        .amenity-item.selected { border-color:#0d6efd; background:#f0f4ff; }
        .img-preview-wrap { position:relative; width:100%; max-height:240px; border-radius:8px; overflow:hidden; background:#f8f9fa; border:2px dashed #dee2e6; display:flex; align-items:center; justify-content:center; min-height:160px; }
        .img-preview-wrap img { width:100%; max-height:240px; object-fit:cover; }
        .img-preview-wrap .placeholder-text { color:#adb5bd; text-align:center; }
        .upload-label { cursor:pointer; }
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
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link active" href="${ctx}/admin/space/list"><i class="bi bi-building me-1"></i>오피스 관리</a>
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
                    <i class="bi bi-${mode == 'register' ? 'plus-circle' : 'pencil-square'} me-2 text-primary"></i>
                    ${mode == 'register' ? '공간 등록' : '공간 수정'}
                </h5>
                <small class="text-muted">${mode == 'register' ? '새로운 공간을 등록합니다.' : '공간 정보를 수정합니다.'}</small>
            </div>
            <a href="${ctx}/admin/space/list" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <!-- 폼 -->
        <c:choose>
            <c:when test="${mode == 'register'}"><c:set var="formAction" value="${ctx}/admin/space/registerok"/></c:when>
            <c:otherwise><c:set var="formAction" value="${ctx}/admin/space/updateok"/></c:otherwise>
        </c:choose>
        <form method="post" action="${formAction}?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data" id="spaceForm">

            <c:if test="${mode == 'update'}">
                <input type="hidden" name="spcIdx" value="${svo.spcIdx}">
                <input type="hidden" name="nowPage" value="${nowPage}">
            </c:if>

            <div class="form-card">

                <!-- ① 기본 정보 -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-info-circle me-2 text-primary"></i>기본 정보</div>
                    <div class="row g-3">
                        <!-- 공간명 -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">공간명 <span class="text-danger">*</span></label>
                            <input type="text" name="spcName" class="form-control"
                                   value="${svo.spcName}" placeholder="예) 강남 A 회의실" required>
                        </div>
                        <!-- 지점 -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">지점 <c:if test="${mode == 'register'}"><span class="text-danger">*</span></c:if></label>
                            <select name="brnIdx" class="form-select" ${mode == 'register' ? 'required' : ''}>
                                <option value="">-- 지점 선택 --</option>
                                <c:forEach var="b" items="${branchList}">
                                    <option value="${b.brnIdx}"
                                        ${svo.brnIdx == b.brnIdx ? 'selected' : ''}>
                                        ${b.brnName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <!-- 타입 -->
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">공간 타입 <span class="text-danger">*</span></label>
                            <select name="spcType" class="form-select" required>
                                <option value="">-- 타입 선택 --</option>
                                <option value="CONFERENCE" ${svo.spcType == 'CONFERENCE' ? 'selected':''}>회의실 (Conference)</option>
                                <option value="INDIVIDUAL"  ${svo.spcType == 'INDIVIDUAL'  ? 'selected':''}>집중석 (Individual)</option>
                                <option value="LOUNGE"      ${svo.spcType == 'LOUNGE'      ? 'selected':''}>라운지 (Lounge)</option>
                            </select>
                        </div>
                        <!-- 수용 인원 -->
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">최대 수용 인원 <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="spcMaxCapacity" class="form-control"
                                       value="${svo.spcMaxCapacity}" min="1" placeholder="0" required>
                                <span class="input-group-text">명</span>
                            </div>
                        </div>
                        <!-- 시간당 가격 -->
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">시간당 가격 <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="spcPrice" class="form-control"
                                       value="${svo.spcPrice}" min="0" step="1000" placeholder="0" required>
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ② 사진 업로드 -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-image me-2 text-primary"></i>대표 이미지</div>
                    <div class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <div class="img-preview-wrap" id="previewWrap">
                                <c:choose>
                                    <c:when test="${not empty svo.spcImg}">
                                        <img id="imgPreview" src="${svo.spcImg}" alt="미리보기">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="placeholder-text" id="placeholder">
                                            <i class="bi bi-cloud-upload fs-2 d-block mb-2"></i>
                                            이미지를 업로드하세요
                                        </div>
                                        <img id="imgPreview" src="#" alt="미리보기" style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label fw-semibold upload-label" for="imgFile">
                                <i class="bi bi-upload me-1"></i>이미지 선택
                            </label>
                            <input type="file" name="imgFile" id="imgFile"
                                   class="form-control" accept="image/*"
                                   onchange="previewImage(this)">
                            <div class="form-text mt-2">
                                <i class="bi bi-info-circle me-1"></i>
                                JPG, PNG, GIF, WEBP 형식 지원 / 권장 크기: 800×500px
                            </div>
                            <c:if test="${not empty svo.spcImg}">
                                <div class="mt-2">
                                    <small class="text-muted">현재 이미지: ${svo.spcImg}</small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- ③ 편의시설 -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-wifi me-2 text-primary"></i>편의시설</div>
                    <div class="amenity-box" id="amenityBox">
                        <label class="amenity-item" id="lbl-wifi">
                            <input type="checkbox" name="amenities" value="WIFI" class="amenity-chk" style="display:none;">
                            <i class="bi bi-wifi text-primary"></i> Wi-Fi
                        </label>
                        <label class="amenity-item" id="lbl-printer">
                            <input type="checkbox" name="amenities" value="PRINTER" class="amenity-chk" style="display:none;">
                            <i class="bi bi-printer text-success"></i> 프린터
                        </label>
                        <label class="amenity-item" id="lbl-monitor">
                            <input type="checkbox" name="amenities" value="MONITOR" class="amenity-chk" style="display:none;">
                            <i class="bi bi-display text-info"></i> 모니터
                        </label>
                        <label class="amenity-item" id="lbl-whiteboard">
                            <input type="checkbox" name="amenities" value="WHITEBOARD" class="amenity-chk" style="display:none;">
                            <i class="bi bi-easel2 text-warning"></i> 화이트보드
                        </label>
                        <label class="amenity-item" id="lbl-projector">
                            <input type="checkbox" name="amenities" value="PROJECTOR" class="amenity-chk" style="display:none;">
                            <i class="bi bi-projector text-danger"></i> 빔프로젝터
                        </label>
                        <label class="amenity-item" id="lbl-locker">
                            <input type="checkbox" name="amenities" value="LOCKER" class="amenity-chk" style="display:none;">
                            <i class="bi bi-lock text-secondary"></i> 사물함
                        </label>
                        <label class="amenity-item" id="lbl-parking">
                            <input type="checkbox" name="amenities" value="PARKING" class="amenity-chk" style="display:none;">
                            <i class="bi bi-p-circle text-dark"></i> 주차
                        </label>
                        <label class="amenity-item" id="lbl-kitchen">
                            <input type="checkbox" name="amenities" value="KITCHEN" class="amenity-chk" style="display:none;">
                            <i class="bi bi-cup-hot text-warning"></i> 음료/간식
                        </label>
                    </div>
                    <div class="form-text mt-2">
                        <i class="bi bi-info-circle me-1"></i>해당 공간에서 이용 가능한 편의시설을 선택하세요.
                    </div>
                </div>

                <!-- ④ 이용 가능 시간 (참고용 UI — DB 저장 없음, branch.b_hours 에서 관리) -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-clock me-2 text-primary"></i>이용 가능 시간 (참고)</div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">운영 시작 시간</label>
                            <input type="time" class="form-control" value="09:00" disabled>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">운영 종료 시간</label>
                            <input type="time" class="form-control" value="22:00" disabled>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">최소 예약 단위</label>
                            <select class="form-select" disabled>
                                <option>1시간</option>
                                <option>2시간</option>
                                <option>4시간</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-text mt-2 text-warning-emphasis">
                        <i class="bi bi-info-circle me-1"></i>운영 시간은 지점(branch) 설정에서 관리됩니다.
                    </div>
                </div>

                <!-- ⑤ 공간 설명 -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-text-left me-2 text-primary"></i>공간 설명</div>
                    <textarea name="spcDescription" class="form-control" rows="6"
                              placeholder="공간의 특징, 분위기, 이용 안내 등을 상세히 입력해 주세요."
                              style="resize:vertical;">${svo.spcDescription}</textarea>
                    <div class="form-text mt-1">최대 2000자까지 입력 가능합니다.</div>
                </div>

                <!-- 저장 버튼 -->
                <div class="form-section d-flex justify-content-between align-items-center gap-2">
                    <div>
                        <c:if test="${mode == 'update'}">
                            <button type="button" class="btn btn-outline-danger"
                                    onclick="if(confirm('정말 삭제하시겠습니까? 삭제된 공간은 복구할 수 없습니다.')) document.getElementById('deleteForm').submit();">
                                <i class="bi bi-trash me-1"></i>삭제
                            </button>
                        </c:if>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${ctx}/admin/space/list" class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-1"></i>취소
                        </a>
                        <button type="submit" form="spaceForm" class="btn btn-primary px-4">
                            <i class="bi bi-check-circle me-1"></i>
                            ${mode == 'register' ? '등록 완료' : '수정 완료'}
                        </button>
                    </div>
                </div>

            </div><!-- /form-card -->
        </form>

        <!-- 삭제 전용 form (main form 밖에 위치) -->
        <c:if test="${mode == 'update'}">
            <form id="deleteForm" method="post" action="${ctx}/admin/space/delete">
                <input type="hidden" name="spcIdx" value="${svo.spcIdx}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
        </c:if>

    </div><!-- /main-content -->
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* 이미지 미리보기 */
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                const preview = document.getElementById('imgPreview');
                const placeholder = document.getElementById('placeholder');
                preview.src = e.target.result;
                preview.style.display = 'block';
                if (placeholder) placeholder.style.display = 'none';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    /* 편의시설 체크박스 토글 스타일 */
    document.querySelectorAll('.amenity-chk').forEach(chk => {
        const label = chk.closest('.amenity-item');
        chk.addEventListener('change', () => {
            label.classList.toggle('selected', chk.checked);
        });
    });
</script>
</body>
</html>

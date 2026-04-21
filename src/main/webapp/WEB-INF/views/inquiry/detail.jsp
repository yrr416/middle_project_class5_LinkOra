<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 상세 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }

        /* ── 사이드바 ── */
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position:sticky; top:0; }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }

        /* ── 레이아웃 ── */
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }

        /* ── 상세 카드 ── */
        .detail-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); padding:28px; margin-bottom:20px; }

        /* ── 문의 내용 박스 ── */
        .inquiry-box { background:#f8f9fa; border-radius:8px; padding:18px 20px; border-left:4px solid #0d6efd; white-space:pre-wrap; word-break:break-word; }

        /* ── 기존 답변 박스 ── */
        .answer-box { background:#f0fdf4; border-radius:8px; padding:18px 20px; border-left:4px solid #22c55e; white-space:pre-wrap; word-break:break-word; }

        /* ── 상태 배지 ── */
        .badge-pending  { background:#fef9c3; color:#854d0e; }
        .badge-complete { background:#d1fae5; color:#065f46; }

        /* ── 답변 템플릿 버튼 ── */
        .template-btn { font-size:.8rem; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ── 사이드바 ────────────────────────────────────────────── -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link active" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building me-1"></i>오피스 관리</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- ── 메인 콘텐츠 ────────────────────────────────────────── -->
    <div class="col main-content">

        <!-- 답변 수정 완료 메시지 -->
        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                <i class="bi bi-check-circle me-1"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-chat-left-text me-2 text-info"></i>문의 상세</h5>
                <small class="text-muted">고객 문의 내용을 확인하고 답변을 작성합니다.</small>
            </div>
            <!-- 목록으로 돌아가기 (필터 유지) -->
            <a href="${ctx}/admin/inquiry/list?nowPage=${nowPage}&statusFilter=${statusFilter}&searchWord=${searchWord}"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록
            </a>
        </div>

        <!-- ── 문의 정보 카드 ─────────────────────────────────── -->
        <div class="detail-card">
            <!-- 제목 + 상태 배지 -->
            <div class="d-flex justify-content-between align-items-start mb-3">
                <h5 class="fw-bold mb-0">${inquiry.inqTitle}</h5>
                <c:choose>
                    <c:when test="${inquiry.inqStatus == 'PENDING'}">
                        <span class="badge badge-pending ms-3">대기중</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-complete ms-3">답변완료</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 문의 메타 정보 -->
            <div class="row g-2 mb-4 text-muted small">
                <div class="col-auto">
                    <i class="bi bi-person me-1"></i>작성자: <strong class="text-dark">${inquiry.userName}</strong>
                </div>
                <div class="col-auto">
                    <i class="bi bi-tag me-1"></i>유형: <strong class="text-dark">${inquiry.inqCategory}</strong>
                </div>
                <div class="col-auto">
                    <i class="bi bi-clock me-1"></i>작성일: <strong class="text-dark">${inquiry.inqCreated}</strong>
                </div>
                <c:if test="${not empty inquiry.inqAnswered}">
                    <div class="col-auto">
                        <i class="bi bi-check-circle me-1 text-success"></i>답변일: <strong class="text-dark">${inquiry.inqAnswered}</strong>
                    </div>
                </c:if>
            </div>

            <!-- 문의 내용 -->
            <div class="mb-4">
                <label class="form-label fw-semibold text-muted small">
                    <i class="bi bi-chat-quote me-1"></i>문의 내용
                </label>
                <div class="inquiry-box">${inquiry.inqContent}</div>
            </div>

            <!-- 첨부 파일 (있는 경우) -->
            <c:if test="${not empty inquiry.inqFileUrl}">
                <div class="mb-4">
                    <label class="form-label fw-semibold text-muted small">
                        <i class="bi bi-paperclip me-1"></i>첨부 파일
                    </label>
                    <div class="d-flex flex-column gap-2">
                        <div>
                            <a href="${ctx}${inquiry.inqFileUrl}" target="_blank" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-download me-1"></i>첨부 파일 열기 / 다운로드
                            </a>
                        </div>
                        <%-- 이미지일 경우 관리자도 바로 확인 가능하게 표시 --%>
                        <c:set var="fileUrlLower" value="${fn:toLowerCase(inquiry.inqFileUrl)}"/>
                        <c:if test="${fn:endsWith(fileUrlLower, '.jpg') || fn:endsWith(fileUrlLower, '.jpeg') || fn:endsWith(fileUrlLower, '.png') || fn:endsWith(fileUrlLower, '.gif') || fn:endsWith(fileUrlLower, '.webp')}">
                            <div class="mt-2 text-center" style="max-width: 400px; border: 1px solid #eee; padding: 10px; border-radius: 8px;">
                                <img src="${ctx}${inquiry.inqFileUrl}" class="img-fluid rounded" alt="첨부 이미지 미리보기">
                                <div class="mt-1 small text-muted">이미지 미리보기</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- ── 기존 답변 표시 (답변완료인 경우) ─────────────── -->
            <c:if test="${inquiry.inqStatus == '답변완료' and not empty inquiry.inqAnswer}">
                <div class="mb-4">
                    <label class="form-label fw-semibold text-muted small">
                        <i class="bi bi-check-circle text-success me-1"></i>기존 답변
                        <span class="text-muted fw-normal">(${inquiry.inqAnswered})</span>
                    </label>
                    <div class="answer-box">${inquiry.inqAnswer}</div>
                </div>
            </c:if>
        </div><!-- /.detail-card -->

        <!-- ── 답변 입력 카드 ─────────────────────────────────── -->
        <div class="detail-card">
            <h6 class="fw-bold mb-3">
                <i class="bi bi-pencil-square me-2 text-primary"></i>
                ${inquiry.inqStatus == '답변완료' ? '답변 수정' : '답변 작성'}
            </h6>

            <!-- 답변 템플릿 선택 버튼 (DB에서 동적 렌더링) -->
            <div class="mb-2">
                <small class="text-muted me-2">답변 템플릿:</small>

                <!-- DB 템플릿 버튼 목록 -->
                <span id="templateBtnArea">
                    <c:choose>
                        <c:when test="${empty templates}">
                            <span class="text-muted small">등록된 템플릿이 없습니다.</span>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="tmpl" items="${templates}">
                                <span class="d-inline-flex align-items-center me-1 mb-1 template-item"
                                      data-tidx="${tmpl.tIdx}">
                                    <button type="button"
                                            class="btn btn-outline-secondary btn-sm template-btn"
                                            onclick="applyTemplateText(this)"
                                            data-content="${tmpl.tContent}">
                                        <i class="bi bi-file-text me-1"></i>${tmpl.tTitle}
                                    </button>
                                    <button type="button"
                                            class="btn btn-sm btn-link text-danger p-0 ms-1"
                                            title="삭제"
                                            onclick="deleteTemplate(${tmpl.tIdx}, this)">
                                        <i class="bi bi-x-circle"></i>
                                    </button>
                                </span>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </span>

                <!-- 템플릿 추가 버튼 -->
                <button type="button" class="btn btn-outline-primary btn-sm template-btn ms-1"
                        onclick="toggleAddTemplateForm()">
                    <i class="bi bi-plus-circle me-1"></i>템플릿 추가
                </button>
            </div>

            <!-- 템플릿 추가 폼 (기본 숨김) -->
            <div id="addTemplateForm" class="border rounded p-3 mb-3 bg-light" style="display:none;">
                <div class="row g-2 align-items-end">
                    <div class="col-auto">
                        <label class="form-label small fw-semibold mb-1">버튼 이름</label>
                        <input type="text" id="newTmplTitle" class="form-control form-control-sm"
                               placeholder="예) 환불 안내" maxlength="50" style="width:160px;">
                    </div>
                    <div class="col">
                        <label class="form-label small fw-semibold mb-1">템플릿 내용</label>
                        <textarea id="newTmplContent" class="form-control form-control-sm" rows="3"
                                  placeholder="답변 템플릿 내용을 입력하세요..."></textarea>
                    </div>
                    <div class="col-auto d-flex gap-2">
                        <button type="button" class="btn btn-primary btn-sm" onclick="saveTemplate()">
                            <i class="bi bi-save me-1"></i>저장
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                onclick="toggleAddTemplateForm()">취소</button>
                    </div>
                </div>
                <div id="tmplFormMsg" class="mt-2 small" style="display:none;"></div>
            </div>

            <!-- 답변 폼 -->
            <form method="post" action="${ctx}/admin/inquiry/answer" id="answerForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="inqIdx"         value="${inquiry.inqIdx}">
                <input type="hidden" name="nowPage"       value="${nowPage}">
                <input type="hidden" name="statusFilter" value="${statusFilter}">
                <input type="hidden" name="searchWord"   value="${searchWord}">
                <!-- 수정 여부 구분 플래그: 이미 답변완료 상태면 수정 -->
                <input type="hidden" name="isUpdate" value="${inquiry.inqStatus == '답변완료' ? 'true' : 'false'}">

                <div class="mb-3">
                    <textarea name="inqAnswer" id="answerTextarea" class="form-control"
                              rows="8" placeholder="답변 내용을 입력하세요..."
                              required>${inquiry.inqAnswer}</textarea>
                    <div class="d-flex justify-content-between mt-1">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            <c:choose>
                                <c:when test="${inquiry.inqStatus == '답변완료'}">
                                    수정 저장 시 <strong>i_answer</strong>(답변 내용)와 <strong>i_answered</strong>(답변 시각)가 함께 갱신됩니다.
                                </c:when>
                                <c:otherwise>
                                    답변 저장 시 상태가 자동으로 <strong>답변완료</strong>로 변경되고 답변 시각이 기록됩니다.
                                </c:otherwise>
                            </c:choose>
                        </small>
                        <small class="text-muted">
                            <span id="charCount">0</span>자
                        </small>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <!-- 목록으로 이동 -->
                    <a href="${ctx}/admin/inquiry/list?nowPage=${nowPage}&statusFilter=${statusFilter}&searchWord=${searchWord}"
                       class="btn btn-outline-secondary">취소</a>
                    <!-- 답변 저장 / 수정 버튼 -->
                    <c:choose>
                        <c:when test="${inquiry.inqStatus == '답변완료'}">
                            <!-- 수정: 기존 답변 덮어쓰기 + i_answered 갱신 -->
                            <button type="submit" class="btn btn-warning"
                                    onclick="return confirm('답변을 수정하시겠습니까?\n답변 내용(i_answer)과 답변 시각(i_answered)이 갱신됩니다.');">
                                <i class="bi bi-pencil me-1"></i>답변 수정
                            </button>
                        </c:when>
                        <c:otherwise>
                            <!-- 신규 저장: 상태 대기중 → 답변완료 변경 -->
                            <button type="submit" class="btn btn-primary"
                                    onclick="return confirm('답변을 저장하시겠습니까?\n저장 시 상태가 답변완료로 변경됩니다.');">
                                <i class="bi bi-send me-1"></i>답변 저장
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div><!-- /.detail-card -->

    </div><!-- /.main-content -->
</div><!-- /.row -->
</div><!-- /.container-fluid -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const ctx = '<%=request.getContextPath()%>';
const csrfParam = '${_csrf.parameterName}';
const csrfToken = '${_csrf.token}';

// ── 글자 수 카운트 ───────────────────────────────────────
const textarea = document.getElementById('answerTextarea');
function updateCharCount() {
    document.getElementById('charCount').textContent = textarea.value.length;
}
textarea.addEventListener('input', updateCharCount);
updateCharCount();

// ── 템플릿 내용을 답변창에 적용 ─────────────────────────
function applyTemplateText(btn) {
    const content = btn.getAttribute('data-content');
    if (textarea.value.trim() !== '') {
        if (!confirm('기존 내용을 템플릿으로 교체하시겠습니까?')) return;
    }
    textarea.value = content;
    updateCharCount();
    textarea.focus();
}

// ── 템플릿 추가 폼 토글 ──────────────────────────────────
function toggleAddTemplateForm() {
    var form = document.getElementById('addTemplateForm');
    form.style.display = (form.style.display === 'none') ? '' : 'none';
    document.getElementById('newTmplTitle').value   = '';
    document.getElementById('newTmplContent').value = '';
    document.getElementById('tmplFormMsg').style.display = 'none';
}

// ── 템플릿 저장 (AJAX) ───────────────────────────────────
function saveTemplate() {
    var title   = document.getElementById('newTmplTitle').value.trim();
    var content = document.getElementById('newTmplContent').value.trim();
    var msgEl   = document.getElementById('tmplFormMsg');

    if (!title || !content) {
        msgEl.textContent   = '버튼 이름과 내용을 모두 입력해주세요.';
        msgEl.className     = 'mt-2 small text-danger';
        msgEl.style.display = '';
        return;
    }

    fetch(ctx + '/admin/inquiry/template/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: csrfParam + '=' + encodeURIComponent(csrfToken)
            + '&title='   + encodeURIComponent(title)
            + '&content=' + encodeURIComponent(content)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            renderTemplates(data.templates);
            toggleAddTemplateForm();
        } else {
            msgEl.textContent   = data.message || '저장 실패';
            msgEl.className     = 'mt-2 small text-danger';
            msgEl.style.display = '';
        }
    })
    .catch(function() {
        msgEl.textContent   = '서버 오류가 발생했습니다.';
        msgEl.className     = 'mt-2 small text-danger';
        msgEl.style.display = '';
    });
}

// ── 템플릿 삭제 (AJAX) ───────────────────────────────────
function deleteTemplate(tIdx, btn) {
    if (!confirm('이 템플릿을 삭제하시겠습니까?')) return;
    fetch(ctx + '/admin/inquiry/template/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: csrfParam + '=' + encodeURIComponent(csrfToken) + '&tIdx=' + tIdx
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) renderTemplates(data.templates);
        else alert(data.message || '삭제 실패');
    })
    .catch(function() { alert('서버 오류가 발생했습니다.'); });
}

// ── 템플릿 버튼 영역 재렌더링 ────────────────────────────
// 추가/삭제 후 서버에서 받은 최신 목록으로 버튼 목록을 교체
function renderTemplates(list) {
    var area = document.getElementById('templateBtnArea');
    if (!list || list.length === 0) {
        area.innerHTML = '<span class="text-muted small">등록된 템플릿이 없습니다.</span>';
        return;
    }
    var html = '';
    list.forEach(function(tmpl) {
        // data-content 안의 따옴표/HTML 특수문자 이스케이프
        var safeContent = tmpl.tContent
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
        html +=
            '<span class="d-inline-flex align-items-center me-1 mb-1 template-item" data-tidx="' + tmpl.tIdx + '">' +
            '<button type="button" class="btn btn-outline-secondary btn-sm template-btn"' +
            ' onclick="applyTemplateText(this)" data-content="' + safeContent + '">' +
            '<i class="bi bi-file-text me-1"></i>' + tmpl.tTitle +
            '</button>' +
            '<button type="button" class="btn btn-sm btn-link text-danger p-0 ms-1" title="삭제"' +
            ' onclick="deleteTemplate(' + tmpl.tIdx + ', this)">' +
            '<i class="bi bi-x-circle"></i></button>' +
            '</span>';
    });
    area.innerHTML = html;
}
</script>
</body>
</html>

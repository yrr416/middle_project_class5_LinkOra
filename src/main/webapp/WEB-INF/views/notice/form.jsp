<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 수정이면 "공지 수정", 등록이면 "공지 등록" -->
    <title>${not empty notice ? '공지 수정' : '공지 등록'} - 오피스 예약 플랫폼</title>
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

        /* ── 폼 카드 ── */
        .form-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); padding:28px; }
        .form-label { font-weight:600; font-size:.9rem; }

        /* ── 발행 옵션 ── */
        .publish-option { border:1px solid #dee2e6; border-radius:8px; padding:14px 18px; cursor:pointer; transition:.15s; }
        .publish-option:hover { border-color:#0d6efd; background:#f0f4ff; }
        .publish-option.selected { border-color:#0d6efd; background:#eef3ff; }

        /* ── 에디터 래퍼 ── */
        .ck-editor__editable { min-height:350px; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ── 사이드바 ─────────────────────────────────────────────── -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link active" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- ── 메인 콘텐츠 ─────────────────────────────────────────── -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold">
                    <c:choose>
                        <c:when test="${not empty notice}">
                            <i class="bi bi-pencil-square me-2 text-warning"></i>
                            ${notice.ntcActive == '1' ? '이벤트' : '공지'} 수정
                        </c:when>
                        <c:when test="${type == 'event'}">
                            <i class="bi bi-star me-2 text-warning"></i>이벤트 등록
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-bell me-2 text-primary"></i>공지 등록
                        </c:otherwise>
                    </c:choose>
                </h5>
                <small class="text-muted">내용을 작성하고 발행 방식을 선택합니다.</small>
            </div>
            <!-- 목록으로 돌아가기 -->
            <a href="${ctx}/admin/notice/list?nowPage=${nowPage}" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록
            </a>
        </div>

        <%-- ── 공지/이벤트 타입 탭 (새 등록 시만 표시) ── --%>
        <c:if test="${empty notice}">
        <div class="d-flex gap-2 mb-3">
            <a href="${ctx}/admin/notice/register?nowPage=${nowPage}&type=notice"
               class="btn btn-sm ${type == 'event' ? 'btn-outline-primary' : 'btn-primary'}">
                <i class="bi bi-bell me-1"></i>공지 등록
            </a>
            <a href="${ctx}/admin/notice/register?nowPage=${nowPage}&type=event"
               class="btn btn-sm ${type == 'event' ? 'btn-warning' : 'btn-outline-warning'}">
                <i class="bi bi-star me-1"></i>이벤트 등록
            </a>
        </div>
        </c:if>

        <!-- ── 공지 작성 폼 ──────────────────────────────────────── -->
        <div class="form-card">
            <!-- enctype="multipart/form-data": 이미지 파일 전송을 위해 필수 -->
            <form id="noticeForm" method="post" enctype="multipart/form-data"
                  action="${ctx}${not empty notice ? '/admin/notice/updateok' : '/admin/notice/registerok'}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <!-- 수정 시 공지 번호 전달 -->
                <c:if test="${not empty notice}">
                    <input type="hidden" name="ntcIdx" value="${notice.ntcIdx}">
                </c:if>
                <input type="hidden" name="nowPage" value="${nowPage}">
                <!-- CKEditor 내용을 받을 숨김 필드 -->
                <input type="hidden" name="ntcContent" id="ntcContentHidden">

                <!-- 제목 -->
                <div class="mb-4">
                    <label class="form-label">제목 <span class="text-danger">*</span></label>
                    <input type="text" name="ntcTitle" class="form-control"
                           placeholder="공지 제목을 입력하세요"
                           value="${notice.ntcTitle}" required>
                </div>

                <!-- 본문 에디터 (CKEditor 5) -->
                <div class="mb-4">
                    <label class="form-label">내용 <span class="text-danger">*</span></label>
                    <!-- CKEditor 가 이 div 를 에디터로 교체 -->
                    <div id="editor">${notice.ntcContent}</div>
                </div>

                <!-- 대표 이미지 업로드 -->
                <div class="mb-4">
                    <label class="form-label">대표 이미지</label>
                    <input type="file" name="ntcImgFile" id="ntcImgFile"
                           class="form-control" accept="image/*"
                           onchange="previewImage(this)">
                    <small class="text-muted d-block mt-1">
                        <i class="bi bi-info-circle me-1"></i>
                        목록/상세 페이지에 표시될 대표 이미지입니다. (JPG, PNG, GIF 권장)
                    </small>
                    <!-- 이미지 미리보기 -->
                    <div id="imgPreviewWrap" class="mt-2" style="${empty notice.ntcImg ? 'display:none;' : ''}">
                        <img id="imgPreview"
                             src="${not empty notice.ntcImg ? notice.ntcImg : ''}"
                             alt="대표 이미지 미리보기"
                             style="max-width:320px; max-height:200px; border-radius:8px; border:1px solid #dee2e6; object-fit:cover;">
                        <div class="mt-1">
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearImage()">
                                <i class="bi bi-x-circle me-1"></i>이미지 제거
                            </button>
                        </div>
                    </div>
                </div>

                <%--
                  ntcActive 값 사전 계산 (중첩 삼항연산자 EL 오류 방지)
                  - 수정 시: 기존 notice.ntcActive 그대로 유지
                  - 이벤트 등록 시: 1
                  - 공지 등록 시: 0
                --%>
                <c:choose>
                    <c:when test="${not empty notice}">
                        <c:set var="ntcActiveValue" value="${notice.ntcActive}" />
                    </c:when>
                    <c:when test="${type == 'event'}">
                        <c:set var="ntcActiveValue" value="1" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="ntcActiveValue" value="0" />
                    </c:otherwise>
                </c:choose>
                <input type="hidden" name="ntcActive" value="${ntcActiveValue}">

                <!-- 발행 방식 선택 -->
                <div class="mb-4">
                    <label class="form-label">발행 방식 <span class="text-danger">*</span></label>
                    <div class="row g-3">
                        <!-- 즉시 발행 -->
                        <div class="col-md-6">
                            <div class="publish-option selected" id="optImmediate"
                                 onclick="selectPublish('immediate')">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-send-check text-primary me-2 fs-5"></i>
                                    <strong>즉시 발행</strong>
                                </div>
                                <small class="text-muted">저장 즉시 사용자에게 공개됩니다.</small>
                                <input type="radio" name="publishType" value="immediate"
                                       id="radioImmediate" class="d-none" checked>
                            </div>
                        </div>
                        <!-- 예약 발행 -->
                        <div class="col-md-6">
                            <div class="publish-option" id="optScheduled"
                                 onclick="selectPublish('scheduled')">
                                <div class="d-flex align-items-center mb-1">
                                    <i class="bi bi-clock text-secondary me-2 fs-5"></i>
                                    <strong>예약 발행</strong>
                                </div>
                                <small class="text-muted">지정한 날짜/시간에 자동 공개됩니다.</small>
                                <input type="radio" name="publishType" value="scheduled"
                                       id="radioScheduled" class="d-none">
                            </div>
                        </div>
                    </div>

                    <!-- 예약 발행 날짜/시간 입력 (즉시 발행 선택 시 숨김) -->
                    <div id="scheduledArea" class="mt-3" style="display:none;">
                        <label class="form-label">발행 일시</label>
                        <input type="datetime-local" id="scheduledAt" class="form-control"
                               style="max-width:280px;"
                               value="${notice.ntcCreated}">
                        <small class="text-muted mt-1 d-block">
                            <i class="bi bi-info-circle me-1"></i>
                            설정 시간이 지나야 사용자에게 공지가 노출됩니다.
                        </small>
                    </div>
                    <!-- 실제 DB에 저장될 n_created 숨김 필드 -->
                    <input type="hidden" name="ntcCreated" id="ntcCreatedHidden">
                </div>

                <!-- 버튼 영역 -->
                <div class="d-flex gap-2 justify-content-end border-top pt-3 mt-2">
                    <a href="${ctx}/admin/notice/list?nowPage=${nowPage}" class="btn btn-outline-secondary">취소</a>
                    <button type="button" class="btn btn-primary" onclick="submitForm()">
                        <i class="bi bi-check-lg me-1"></i>
                        ${not empty notice ? '수정 완료' : '등록'}
                    </button>
                </div>

            </form>
        </div><!-- /.form-card -->

    </div><!-- /.main-content -->
</div><!-- /.row -->
</div><!-- /.container-fluid -->

<!-- CKEditor 5 Classic Build (CDN) -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let editorInstance;

    /*
     * ── 커스텀 이미지 업로드 어댑터 ─────────────────────────────
     * CKEditor 5 Classic Build CDN에는 SimpleUploadAdapter가 포함되지 않으므로
     * fetch API를 이용해 직접 구현한다.
     *
     * loader.file : CKEditor가 넘겨주는 업로드 대상 파일 Promise
     * resolve({ default: url }) : 성공 시 에디터에 삽입될 이미지 URL
     * reject(message)           : 실패 시 에디터에 오류 표시
     */
    class NoticeImageUploadAdapter {
        constructor(loader) {
            this.loader = loader;
            // 서버 업로드 엔드포인트
            this.uploadUrl = '${ctx}/admin/notice/imageUpload';
            // Spring Security CSRF 토큰 (헤더로 전송)
            this.csrfHeaderName = '${_csrf.headerName}';
            this.csrfToken      = '${_csrf.token}';
        }

        upload() {
            return this.loader.file.then(file => new Promise((resolve, reject) => {
                const data = new FormData();
                data.append('upload', file); // 서버 @RequestParam("upload") 와 일치

                fetch(this.uploadUrl, {
                    method: 'POST',
                    headers: {
                        [this.csrfHeaderName]: this.csrfToken
                    },
                    body: data
                })
                .then(res => res.json())
                .then(result => {
                    if (result.url) {
                        resolve({ default: result.url }); // 에디터에 이미지 삽입
                    } else {
                        reject(result.error?.message || '이미지 업로드 실패');
                    }
                })
                .catch(() => reject('네트워크 오류로 이미지 업로드에 실패했습니다.'));
            }));
        }

        abort() {} // 업로드 취소 시 호출 (구현 생략 가능)
    }

    // CKEditor 플러그인 형태로 등록 (extraPlugins에 전달)
    function NoticeImageUploadAdapterPlugin(editor) {
        editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
            return new NoticeImageUploadAdapter(loader);
        };
    }

    // ── CKEditor 5 초기화 ───────────────────────────────────────
    ClassicEditor
        .create(document.querySelector('#editor'), {
            // simpleUpload 대신 커스텀 어댑터 플러그인 사용
            extraPlugins: [NoticeImageUploadAdapterPlugin],
            toolbar: {
                items: [
                    'heading', '|',
                    'bold', 'italic', 'underline', 'strikethrough', '|',
                    'bulletedList', 'numberedList', '|',
                    'outdent', 'indent', '|',
                    'link', 'uploadImage', 'blockQuote', 'insertTable', '|',
                    'undo', 'redo'
                ]
            }
        })
        .then(editor => {
            editorInstance = editor;
        })
        .catch(err => console.error('CKEditor 초기화 실패:', err));

    // ── 발행 방식 선택 ──────────────────────────────────────────
    function selectPublish(type) {
        document.getElementById('radioImmediate').checked  = (type === 'immediate');
        document.getElementById('radioScheduled').checked  = (type === 'scheduled');
        document.getElementById('optImmediate').classList.toggle('selected', type === 'immediate');
        document.getElementById('optScheduled').classList.toggle('selected', type === 'scheduled');
        // 예약 발행 날짜 입력 영역 표시/숨김
        document.getElementById('scheduledArea').style.display = (type === 'scheduled') ? 'block' : 'none';
    }

    // ── 폼 제출 처리 ────────────────────────────────────────────
    function submitForm() {
        // CKEditor 내용 → 숨김 필드에 복사
        const content = editorInstance.getData();
        if (!content || content.trim() === '') {
            alert('공지 내용을 입력하세요.');
            return;
        }
        document.getElementById('ntcContentHidden').value = content;

        // 발행 방식에 따라 n_created 설정
        const isScheduled = document.getElementById('radioScheduled').checked;
        if (isScheduled) {
            const scheduledAt = document.getElementById('scheduledAt').value;
            if (!scheduledAt) {
                alert('예약 발행 날짜/시간을 입력하세요.');
                return;
            }
            // datetime-local 값("YYYY-MM-DDTHH:mm") → MySQL 형식("YYYY-MM-DD HH:mm:ss")
            document.getElementById('ntcCreatedHidden').value = scheduledAt.replace('T', ' ') + ':00';
        } else {
            // 즉시 발행: n_created = "" → 서버에서 NOW() 처리
            document.getElementById('ntcCreatedHidden').value = '';
        }

        document.getElementById('noticeForm').submit();
    }

    // ── 대표 이미지 미리보기 ─────────────────────────────────────
    function previewImage(input) {
        const wrap = document.getElementById('imgPreviewWrap');
        const preview = document.getElementById('imgPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                wrap.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // ── 이미지 제거 ─────────────────────────────────────────────
    function clearImage() {
        document.getElementById('ntcImgFile').value = '';
        document.getElementById('imgPreview').src = '';
        document.getElementById('imgPreviewWrap').style.display = 'none';
    }
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객 등록 - 오피스 예약 플랫폼</title>
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
        .msg-ok  { color:#059669; font-size:.8rem; }
        .msg-err { color:#dc3545; font-size:.8rem; }
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
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building me-1"></i>오피스 관리</a>
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
                <h5 class="mb-1 fw-bold"><i class="bi bi-person-plus me-2 text-primary"></i>신규 고객 등록</h5>
                <small class="text-muted">새로운 회원 정보를 등록합니다.</small>
            </div>
            <a href="${ctx}/admin/customer/list" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <!-- 에러 메시지 -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'duplicateEmail'}">이미 등록된 이메일입니다.</c:when>
                    <c:otherwise>등록에 실패했습니다. 다시 시도해주세요.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 등록 폼 -->
        <form method="post" action="${ctx}/admin/customer/register" id="registerForm" onsubmit="return validateForm()">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="row g-3">

                <!-- 계정 정보 -->
                <div class="col-md-6">
                    <div class="form-card">
                        <div class="form-section-title">
                            <i class="bi bi-shield-lock me-2 text-primary"></i>계정 정보
                        </div>

                        <!-- 아이디 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                아이디 <span class="required-mark">*</span>
                            </label>
                            <div class="input-group input-group-sm">
                                <input type="text" name="userId" id="uId"
                                       class="form-control" placeholder="아이디를 입력하세요"
                                       maxlength="50" required>
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="checkDuplicateId()">중복확인</button>
                            </div>
                            <div id="idCheckMsg" class="mt-1"></div>
                        </div>

                        <!-- 비밀번호 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                비밀번호 <span class="required-mark">*</span>
                            </label>
                            <input type="password" name="userPwd" id="uPwd"
                                   class="form-control form-control-sm"
                                   placeholder="비밀번호를 입력하세요"
                                   minlength="8" required>
                            <div class="form-text text-muted" style="font-size:.75rem;">
                                영문 대·소문자, 숫자, 특수문자를 각각 1개 이상 포함, 8자 이상
                            </div>
                            <div id="pwdPolicyMsg" class="mt-1"></div>
                        </div>

                        <!-- 비밀번호 확인 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                비밀번호 확인 <span class="required-mark">*</span>
                            </label>
                            <input type="password" id="uPwdConfirm"
                                   class="form-control form-control-sm"
                                   placeholder="비밀번호를 다시 입력하세요"
                                   minlength="8" required>
                            <div id="pwdCheckMsg" class="mt-1"></div>
                        </div>

                        <!-- 이메일 + 중복확인 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                이메일 <span class="required-mark">*</span>
                            </label>
                            <div class="input-group input-group-sm">
                                <input type="email" name="userEmail" id="uEmail"
                                       class="form-control" placeholder="example@email.com" required>
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="checkDuplicateEmail()">중복확인</button>
                            </div>
                            <div id="emailCheckMsg" class="mt-1"></div>
                        </div>

                        <!-- 역할 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">역할</label>
                            <select name="userRole" id="userRole" class="form-select form-select-sm"
                                    onchange="togglePartnerFields()">
                                <option value="user">user</option>
                                <option value="admin">admin</option>
                                <option value="partner">partner</option>
                            </select>
                        </div>

                        <!-- 사업자번호 (partner 선택 시에만 표시) -->
                        <div class="mb-3" id="partnerNumberArea" style="display:none;">
                            <label class="form-label form-label-sm">
                                사업자번호 <span class="required-mark">*</span>
                            </label>
                            <input type="text" name="partnerNumber" id="partnerNumber"
                                   class="form-control form-control-sm"
                                   placeholder="000-00-00000" maxlength="12">
                        </div>
                    </div>
                </div>

                <!-- 개인 정보 -->
                <div class="col-md-6">
                    <div class="form-card">
                        <div class="form-section-title">
                            <i class="bi bi-person me-2 text-success"></i>개인 정보
                        </div>

                        <!-- 이름 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">
                                이름 <span class="required-mark">*</span>
                            </label>
                            <input type="text" name="userName" class="form-control form-control-sm"
                                   placeholder="이름" maxlength="50" required>
                        </div>

                        <!-- 전화번호 -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">전화번호</label>
                            <input type="tel" name="userPhone" id="uPhone"
                                   class="form-control form-control-sm"
                                   placeholder="010-0000-0000" maxlength="20">
                        </div>

                        <!-- 주소 (카카오 우편번호 검색) -->
                        <div class="mb-3">
                            <label class="form-label form-label-sm">주소</label>
                            <!-- 우편번호 + 검색 버튼 -->
                            <div class="input-group input-group-sm mb-1">
                                <input type="text" id="addrPostcode" class="form-control"
                                       placeholder="우편번호" readonly>
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="execDaumPostcode()">우편번호 찾기</button>
                            </div>
                            <!-- 도로명 주소 -->
                            <input type="text" id="addrRoad" class="form-control form-control-sm mb-1"
                                   placeholder="도로명 주소" readonly>
                            <!-- 지번 주소 -->
                            <input type="text" id="addrJibun" class="form-control form-control-sm mb-1"
                                   placeholder="지번 주소" readonly>
                            <!-- 상세 주소 -->
                            <input type="text" id="addrDetail" class="form-control form-control-sm mb-1"
                                   placeholder="상세 주소 입력">
                            <!-- 참고 항목 -->
                            <input type="text" id="addrExtra" class="form-control form-control-sm"
                                   placeholder="참고 항목" readonly>
                            <!-- 최종 합산 주소 (서버 전송용) -->
                            <input type="hidden" id="userAddr" name="userAddr">
                        </div>
                    </div>
                </div>

                <!-- 제출 버튼 -->
                <div class="col-12">
                    <div class="form-card py-3">
                        <div class="d-flex justify-content-center gap-2">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-person-check me-2"></i>고객 등록
                            </button>
                            <a href="${ctx}/admin/customer/list" class="btn btn-outline-secondary px-4">
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
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    /* ── 카카오 우편번호 검색 ─────────────────────────── */
    function execDaumPostcode() {
        new kakao.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress;
                var extraRoadAddr = '';

                if (data.bname !== '' && /[동로가]$/.test(data.bname)) {
                    extraRoadAddr += data.bname;
                }
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if (extraRoadAddr !== '') {
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                document.getElementById('addrPostcode').value = data.zonecode;
                document.getElementById('addrRoad').value     = roadAddr;
                document.getElementById('addrJibun').value    = data.jibunAddress;
                document.getElementById('addrExtra').value    = roadAddr !== '' ? extraRoadAddr : '';
                document.getElementById('addrDetail').value   = '';
                document.getElementById('addrDetail').focus();
            }
        }).open();
    }

    // 중복 확인 여부 플래그
    let idChecked    = false;
    let emailChecked = false;

    /**
     * 아이디 중복 확인 (AJAX)
     */
    function checkDuplicateId() {
        const uId = document.getElementById('uId').value.trim();
        if (!uId) { alert('아이디를 입력해주세요.'); return; }

        const ctx = '${pageContext.request.contextPath}';
        fetch(ctx + '/admin/customer/checkId?uId=' + encodeURIComponent(uId))
            .then(res => res.text())
            .then(result => {
                const msg = document.getElementById('idCheckMsg');
                if (result === '0') {
                    msg.innerHTML = '<span class="msg-ok"><i class="bi bi-check-circle me-1"></i>사용 가능한 아이디입니다.</span>';
                    idChecked = true;
                } else {
                    msg.innerHTML = '<span class="msg-err"><i class="bi bi-x-circle me-1"></i>이미 사용 중인 아이디입니다.</span>';
                    idChecked = false;
                }
            })
            .catch(() => alert('중복 확인 중 오류가 발생했습니다.'));
    }

    // 아이디 변경 시 중복 확인 초기화
    document.getElementById('uId').addEventListener('input', function() {
        idChecked = false;
        document.getElementById('idCheckMsg').innerHTML = '';
    });

    /**
     * 이메일 중복 확인 (AJAX)
     */
    function checkDuplicateEmail() {
        const email = document.getElementById('uEmail').value.trim();
        if (!email) { alert('이메일을 입력해주세요.'); return; }

        const ctx = '${pageContext.request.contextPath}';
        fetch(ctx + '/admin/customer/checkEmail?userEmail=' + encodeURIComponent(email))
            .then(res => res.text())
            .then(result => {
                const msg = document.getElementById('emailCheckMsg');
                if (result === '0') {
                    msg.innerHTML = '<span class="msg-ok"><i class="bi bi-check-circle me-1"></i>사용 가능한 이메일입니다.</span>';
                    emailChecked = true;
                } else {
                    msg.innerHTML = '<span class="msg-err"><i class="bi bi-x-circle me-1"></i>이미 등록된 이메일입니다.</span>';
                    emailChecked = false;
                }
            })
            .catch(() => alert('중복 확인 중 오류가 발생했습니다.'));
    }

    /**
     * 비밀번호 정책 검사 (대·소문자·숫자·특수문자 각 1개 이상, 8자 이상)
     */
    function passwordMeetsPolicy(pw) {
        if (!pw || pw.length < 8) return false;
        return /[A-Z]/.test(pw) && /[a-z]/.test(pw) && /[0-9]/.test(pw)
            && /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?`~]/.test(pw);
    }

    /**
     * 비밀번호 정책 실시간 표시
     */
    document.getElementById('uPwd').addEventListener('input', function() {
        const msg = document.getElementById('pwdPolicyMsg');
        const confirmMsg = document.getElementById('pwdCheckMsg');
        if (!this.value) { msg.innerHTML = ''; confirmMsg.innerHTML = ''; return; }
        if (passwordMeetsPolicy(this.value)) {
            msg.innerHTML = '<span class="msg-ok"><i class="bi bi-check-circle me-1"></i>사용 가능한 비밀번호입니다.</span>';
        } else {
            msg.innerHTML = '<span class="msg-err"><i class="bi bi-x-circle me-1"></i>대·소문자·숫자·특수문자 각 1개 이상, 8자 이상 필요합니다.</span>';
        }
        // 비밀번호 변경 시 확인란 재검사
        const confirm = document.getElementById('uPwdConfirm').value;
        if (confirm) {
            confirmMsg.innerHTML = this.value === confirm
                ? '<span class="msg-ok"><i class="bi bi-check-circle me-1"></i>비밀번호가 일치합니다.</span>'
                : '<span class="msg-err"><i class="bi bi-x-circle me-1"></i>비밀번호가 일치하지 않습니다.</span>';
        }
    });

    /**
     * 비밀번호 확인 일치 여부 실시간 확인
     */
    document.getElementById('uPwdConfirm').addEventListener('input', function() {
        const pwd = document.getElementById('uPwd').value;
        const msg = document.getElementById('pwdCheckMsg');
        if (!this.value) { msg.innerHTML = ''; return; }
        msg.innerHTML = pwd === this.value
            ? '<span class="msg-ok"><i class="bi bi-check-circle me-1"></i>비밀번호가 일치합니다.</span>'
            : '<span class="msg-err"><i class="bi bi-x-circle me-1"></i>비밀번호가 일치하지 않습니다.</span>';
    });

    /**
     * 연락처 자동 하이픈 삽입
     */
    document.getElementById('uPhone').addEventListener('input', function() {
        let val = this.value.replace(/[^0-9]/g, '');
        if (val.length <= 3)       this.value = val;
        else if (val.length <= 7)  this.value = val.slice(0,3) + '-' + val.slice(3);
        else                       this.value = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
    });

    /**
     * 폼 최종 유효성 검사
     */
    function validateForm() {
        if (!idChecked) {
            alert('아이디 중복 확인을 해주세요.');
            document.getElementById('uId').focus();
            return false;
        }
        if (!emailChecked) {
            alert('이메일 중복 확인을 해주세요.');
            document.getElementById('uEmail').focus();
            return false;
        }
        const pwd = document.getElementById('uPwd').value;
        if (!passwordMeetsPolicy(pwd)) {
            alert('비밀번호는 영문 대·소문자, 숫자, 특수문자를 각각 1개 이상 포함하고 8자 이상이어야 합니다.');
            document.getElementById('uPwd').focus();
            return false;
        }
        if (pwd !== document.getElementById('uPwdConfirm').value) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }
        // partner 선택 시 사업자번호 필수 확인
        if (document.getElementById('userRole').value === 'partner') {
            const bizNo = document.getElementById('partnerNumber').value.trim();
            if (!bizNo) {
                alert('사업자번호를 입력해주세요.');
                document.getElementById('partnerNumber').focus();
                return false;
            }
        }

        // 주소 합산 → hidden userAddr 에 저장
        var road   = document.getElementById('addrRoad').value;
        var jibun  = document.getElementById('addrJibun').value;
        var detail = document.getElementById('addrDetail').value;
        var extra  = document.getElementById('addrExtra').value;
        var merged = [road || jibun, detail, extra].filter(Boolean).join(' ');
        document.getElementById('userAddr').value = merged;
        return true;
    }

    // 이메일 변경 시 중복 확인 초기화
    document.getElementById('uEmail').addEventListener('input', function() {
        emailChecked = false;
        document.getElementById('emailCheckMsg').innerHTML = '';
    });

    /**
     * 역할 선택에 따라 사업자번호 필드 표시/숨김
     */
    function togglePartnerFields() {
        const role = document.getElementById('userRole').value;
        const area = document.getElementById('partnerNumberArea');
        const input = document.getElementById('partnerNumber');
        if (role === 'partner') {
            area.style.display = 'block';
            input.required = true;
        } else {
            area.style.display = 'none';
            input.required = false;
            input.value = '';
        }
    }
</script>
</body>
</html>

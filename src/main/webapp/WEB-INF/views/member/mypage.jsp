<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- 일반 회원 마이페이지 화면: 내 정보 조회, 비밀번호/프로필 변경, 회원 탈퇴 기능을 제공한다. --%>
<html lang="ko">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 · LinkOra</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            background: #f4f6f8;
            font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
            color: #243140;
        }
        .top-bar {
            height: 64px;
            background: #e8e8e3;
            border-bottom: 1px solid #d7d7d1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
        }
        .logo-image {
            height: 48px;
            width: auto;
            display: block;
        }
        .nav-links {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .nav-btn {
            height: 38px;
            padding: 0 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #ffffff;
            color: #334155;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .nav-btn:hover {
            background: #f8fafc;
        }
        .content {
            padding: 24px;
        }
        .content-box {
            max-width: 720px;
            margin: 0 auto;
            background: #ffffff;
            border: 1px solid #e6e8ec;
            border-radius: 12px;
            padding: 28px 28px 32px;
        }
        .profile-head {
            position: relative;
            text-align: center;
            margin-bottom: 24px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e6e8ec;
        }
        .avatar {
            width: 72px;
            height: 72px;
            margin: 0 auto 12px;
            border-radius: 50%;
            background: #162a4a;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            overflow: hidden;
            border: 3px solid #e6e8ec;
        }
        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .avatar-edit {
            margin-top: -2px;
            margin-bottom: 10px;
            text-align: center;
        }
        .profile-edit-btn {
            height: 28px;
            padding: 0 10px;
            border: 1px solid #cbd5e1;
            border-radius: 999px;
            background: #ffffff;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .profile-edit-btn:hover {
            background: #f8fafc;
        }
        .manage-links {
            position: absolute;
            top: 0;
            right: 0;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }
        .manage-btn {
            height: 36px;
            padding: 0 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #ffffff;
            color: #334155;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            white-space: nowrap;
        }
        .manage-btn:hover {
            background: #f8fafc;
        }
        .profile-head h1 {
            margin: 0 0 6px;
            font-size: 24px;
            color: #243140;
        }
        .profile-head .sub {
            margin: 0;
            font-size: 14px;
            color: #64748b;
        }
        .badge {
            display: inline-block;
            margin-top: 10px;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        .badge-wrap {
            text-align: center;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 14px;
        }
        .info-item {
            background: #fafafa;
            border: 1px solid #e6e8ec;
            border-radius: 8px;
            padding: 14px 16px;
        }
        .info-item .label {
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            margin-bottom: 6px;
        }
        .info-item .value {
            font-size: 15px;
            font-weight: 600;
            color: #243140;
            word-break: break-word;
            line-height: 1.45;
        }
        .info-item.full {
            grid-column: 1 / -1;
        }
        .password-card {
            margin-top: 18px;
            border: 1px solid #e6e8ec;
            border-radius: 10px;
            background: #fafafa;
            padding: 12px;
            max-width: 520px;
        }
        .password-card h2 {
            margin: 0 0 10px;
            font-size: 14px;
            color: #243140;
        }
        .password-form .row {
            margin-bottom: 8px;
        }
        .password-form label {
            display: block;
            margin-bottom: 4px;
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
        }
        .password-form input {
            width: 100%;
            height: 36px;
            border: 1px solid #d9d9d9;
            border-radius: 8px;
            padding: 0 9px;
            font-size: 13px;
            background: #fff;
        }
        .password-form input:focus {
            outline: none;
            border-color: #162a4a;
        }
        .pwd-msg {
            margin: 0 0 10px;
            font-size: 11px;
            font-weight: 700;
        }
        .password-form .btn.btn-primary {
            height: 38px;
            padding: 0 16px;
            font-size: 13px;
        }
        .pwd-hint {
            margin-top: 6px;
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .pwd-hint .icon {
            width: 16px;
            text-align: center;
        }
        .pwd-hint.ok {
            color: #16a34a;
        }
        .pwd-hint.err {
            color: #dc2626;
        }
        .pwd-msg.ok {
            color: #16a34a;
        }
        .pwd-msg.err {
            color: #dc2626;
        }
        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e6e8ec;
        }
        .withdraw-form {
            display: inline-flex;
        }
        .btn {
            height: 44px;
            padding: 0 22px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-primary {
            background: #162a4a;
            color: #fff;
        }
        .btn-primary:hover {
            filter: brightness(1.06);
        }
        .btn-ghost {
            background: #ffffff;
            color: #334155;
            border: 1px solid #cbd5e1;
        }
        .btn-ghost:hover {
            background: #f8fafc;
        }
        .btn-danger {
            background: #ffffff;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        .btn-danger:hover {
            background: #fef2f2;
        }
        .chatbot-fab {
            position: fixed;
            right: 24px;
            bottom: 24px;
            width: 62px;
            height: 62px;
            border-radius: 50%;
            background: #162a4a;
            color: #ffffff;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: 0 10px 18px rgba(22, 42, 74, 0.3);
            z-index: 50;
        }
        .chatbot-fab:hover {
            filter: brightness(1.08);
        }
        .withdraw-modal {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .withdraw-modal.open {
            display: flex;
        }
        .withdraw-modal-card {
            width: 100%;
            max-width: 360px;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 14px 24px rgba(15, 23, 42, 0.2);
        }
        .withdraw-modal-title {
            margin: 0 0 8px;
            font-size: 16px;
            color: #1e293b;
            font-weight: 800;
        }
        .withdraw-modal-desc {
            margin: 0 0 12px;
            font-size: 13px;
            color: #64748b;
        }
        .withdraw-modal-input {
            width: 100%;
            height: 40px;
            border: 1px solid #d9d9d9;
            border-radius: 8px;
            padding: 0 10px;
            font-size: 14px;
            background: #fff;
        }
        .withdraw-modal-actions {
            margin-top: 12px;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }
        .withdraw-modal-btn {
            height: 36px;
            padding: 0 12px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #334155;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
        }
        .withdraw-modal-btn.danger {
            border-color: #fecaca;
            color: #dc2626;
        }
    </style>
<%@include file="../layout/header.jsp"%>
<body>

<main class="content">
    <section class="content-box">
        <div class="profile-head">
            <div class="manage-links">
                <a class="manage-btn" href="${pageContext.request.contextPath}/inquiry/mylist">문의관리</a>
                <a class="manage-btn" href="/review-management">리뷰관리</a>
                <a class="manage-btn" href="/reservation-management">예약관리</a>
            </div>
            <div class="avatar" aria-hidden="true">
                <% if (request.getAttribute("profileImage") != null && !((String) request.getAttribute("profileImage")).isBlank()) { %>
                <img src="${profileImage}" alt="프로필">
                <% } else { %>
                👤
                <% } %>
            </div>
            <% if (!Boolean.TRUE.equals(request.getAttribute("oauthLogin"))) { %>
            <div class="avatar-edit">
                <form method="post" action="${pageContext.request.contextPath}/mypage/profile" enctype="multipart/form-data">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <label class="profile-edit-btn" for="profileImageFile">프로필 수정</label>
                    <input id="profileImageFile" name="profileImage" type="file" accept="image/*" style="display:none" onchange="this.form.submit()">
                </form>
            </div>
            <% } %>
            <h1>${name}</h1>
            <p class="sub">회원 정보를 한눈에 확인하세요.</p>
            <div class="badge-wrap">
                <span class="badge">
                    <% if (Boolean.TRUE.equals(request.getAttribute("oauthLogin"))) { %>
                    ${oauthProvider} 로그인 · LinkOra
                    <% } else { %>
                    회원 · LinkOra
                    <% } %>
                </span>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <div class="label">아이디</div>
                <div class="value">${username}</div>
            </div>
            <div class="info-item">
                <div class="label">가입일</div>
                <div class="value">${joinDate}</div>
            </div>
            <div class="info-item">
                <div class="label">이메일</div>
                <div class="value">${empty email ? '—' : email}</div>
            </div>
            <div class="info-item">
                <div class="label">전화번호</div>
                <div class="value">${phone}</div>
            </div>
            <div class="info-item full">
                <div class="label">주소</div>
                <div class="value">${address}</div>
            </div>
            <% if (!Boolean.TRUE.equals(request.getAttribute("oauthLogin"))) { %>
            <div class="info-item full">
                <div class="label">비밀번호</div>
                <div class="value">
                    보안 정책상 표시되지 않습니다.
                </div>
            </div>
            <% } %>
        </div>

        <% if (!Boolean.TRUE.equals(request.getAttribute("oauthLogin"))) { %>
        <section class="password-card">
            <h2>비밀번호 변경</h2>
            <% if ("success".equals(request.getAttribute("pwdChanged"))) { %>
            <p class="pwd-msg ok">비밀번호가 변경되었습니다.</p>
            <% } %>
            <% if ("mismatch".equals(request.getAttribute("pwdError"))) { %>
            <p class="pwd-msg err">새 비밀번호와 확인 값이 일치하지 않습니다.</p>
            <% } %>
            <% if ("current".equals(request.getAttribute("pwdError"))) { %>
            <p class="pwd-msg err">현재 비밀번호가 올바르지 않습니다.</p>
            <% } %>
            <% if ("weak".equals(request.getAttribute("pwdError"))) { %>
            <p class="pwd-msg err">새 비밀번호는 8자 이상 입력해주세요.</p>
            <% } %>
            <% if ("complex".equals(request.getAttribute("pwdError"))) { %>
            <p class="pwd-msg err">새 비밀번호는 영문 대문자·소문자·숫자·특수문자(!@#$%^&amp;* 등)를 각각 포함해야 합니다.</p>
            <% } %>
            <% if ("failed".equals(request.getAttribute("pwdError"))) { %>
            <p class="pwd-msg err">비밀번호 변경에 실패했습니다. 다시 시도해주세요.</p>
            <% } %>
            <form class="password-form" method="post" action="${pageContext.request.contextPath}/mypage/password">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="row">
                    <label for="currentPassword">현재 비밀번호</label>
                    <input id="currentPassword" name="currentPassword" type="password" required autocomplete="current-password">
                </div>
                <div class="row">
                    <label for="newPassword">새 비밀번호</label>
                    <input id="newPassword" name="newPassword" type="password" minlength="8" required autocomplete="new-password">
                    <p id="pwdLengthHint" class="pwd-hint">
                        <span class="icon">•</span><span>8자 이상, 영문 대·소문자·숫자·특수문자 포함</span>
                    </p>
                </div>
                <div class="row">
                    <label for="newPasswordConfirm">새 비밀번호 확인</label>
                    <input id="newPasswordConfirm" name="newPasswordConfirm" type="password" minlength="8" required autocomplete="new-password">
                    <p id="pwdMatchHint" class="pwd-hint">
                        <span class="icon">•</span><span>비밀번호 확인 입력 필요</span>
                    </p>
                </div>
                <button type="submit" class="btn btn-primary">비밀번호 변경</button>
            </form>
        </section>
        <% } %>

        <div class="actions">
            <form id="userWithdrawForm" class="withdraw-form" method="post" action="${pageContext.request.contextPath}/mypage/delete">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input type="hidden" name="currentPassword">
                <button type="button" class="btn btn-danger" onclick="openWithdrawModal('회원')">회원 탈퇴</button>
            </form>
            <a class="btn btn-danger" href="${pageContext.request.contextPath}/logoutNow">로그아웃</a>
        </div>
        <% if ("password".equals(request.getAttribute("withdrawError"))) { %>
        <p class="pwd-msg err">탈퇴 비밀번호가 올바르지 않습니다.</p>
        <% } %>
        <% if ("failed".equals(request.getAttribute("withdrawError"))) { %>
        <p class="pwd-msg err">회원 탈퇴 처리에 실패했습니다.</p>
        <% } %>
    </section>
</main>

<div id="withdrawModal" class="withdraw-modal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="withdraw-modal-card">
        <h2 class="withdraw-modal-title">회원 탈퇴 확인</h2>
        <p class="withdraw-modal-desc">탈퇴를 위해 비밀번호를 입력하세요.</p>
        <input id="withdrawModalPassword" class="withdraw-modal-input" type="password" autocomplete="current-password" placeholder="비밀번호">
        <div class="withdraw-modal-actions">
            <button type="button" class="withdraw-modal-btn" onclick="closeWithdrawModal()">취소</button>
            <button type="button" class="withdraw-modal-btn danger" onclick="submitWithdrawModal()">탈퇴</button>
        </div>
    </div>
</div>
<%@include file="../layout/footer.jsp"%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var root = '${pageContext.request.contextPath}';
        var btn = document.querySelector('.header-right .login-btn');
        if (!btn || btn.tagName !== 'BUTTON') return;
        if ((btn.textContent || '').trim() !== '마이페이지') return;
        btn.textContent = '홈페이지';
        btn.onclick = function () { location.href = root + '/'; };
    });

    var withdrawTargetForm = null;
    var withdrawModal = document.getElementById('withdrawModal');
    var withdrawModalInput = document.getElementById('withdrawModalPassword');

    function openWithdrawModal(label) {
        withdrawTargetForm = document.getElementById('userWithdrawForm');
        document.querySelector('#withdrawModal .withdraw-modal-title').textContent = label + ' 탈퇴 확인';
        document.querySelector('#withdrawModal .withdraw-modal-desc').textContent = '탈퇴를 위해 비밀번호를 입력하세요.';
        withdrawModalInput.value = '';
        withdrawModal.classList.add('open');
        withdrawModal.setAttribute('aria-hidden', 'false');
        setTimeout(function () { withdrawModalInput.focus(); }, 0);
    }

    function closeWithdrawModal() {
        withdrawModal.classList.remove('open');
        withdrawModal.setAttribute('aria-hidden', 'true');
        withdrawTargetForm = null;
    }

    function submitWithdrawModal() {
        if (!withdrawTargetForm) {
            return;
        }
        var password = withdrawModalInput.value || '';
        if (!password.trim()) {
            alert('비밀번호를 입력해주세요.');
            return;
        }
        if (!window.confirm('정말 탈퇴하시겠습니까? 계정 정보는 복구할 수 없습니다.')) {
            return;
        }
        withdrawTargetForm.currentPassword.value = password;
        withdrawTargetForm.submit();
    }

    withdrawModal.addEventListener('click', function (event) {
        if (event.target === withdrawModal) {
            closeWithdrawModal();
        }
    });

    document.addEventListener('keydown', function (event) {
        if (!withdrawModal.classList.contains('open')) {
            return;
        }
        if (event.key === 'Escape') {
            closeWithdrawModal();
            return;
        }
        if (event.key === 'Enter') {
            submitWithdrawModal();
        }
    });

    (function initPasswordHints() {
        var newPasswordInput = document.getElementById('newPassword');
        var newPasswordConfirmInput = document.getElementById('newPasswordConfirm');
        var pwdLengthHint = document.getElementById('pwdLengthHint');
        var pwdMatchHint = document.getElementById('pwdMatchHint');
        if (!newPasswordInput || !newPasswordConfirmInput || !pwdLengthHint || !pwdMatchHint) {
            return;
        }

        function passwordMeetsComplexity(pw) {
            if (!pw || pw.length < 8) {
                return false;
            }
            return /[A-Z]/.test(pw) && /[a-z]/.test(pw) && /[0-9]/.test(pw)
                && /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?`~]/.test(pw);
        }

        function setHint(element, icon, text, stateClass) {
            element.classList.remove('ok', 'err');
            if (stateClass) {
                element.classList.add(stateClass);
            }
            element.querySelector('.icon').textContent = icon;
            element.querySelector('span:last-child').textContent = text;
        }

        function updateHints() {
            var newValue = newPasswordInput.value || '';
            var confirmValue = newPasswordConfirmInput.value || '';

            if (newValue.length === 0) {
                setHint(pwdLengthHint, '•', '8자 이상, 영문 대·소문자·숫자·특수문자 포함', '');
            } else if (newValue.length < 8) {
                setHint(pwdLengthHint, '✕', '최소 8자 이상 입력해주세요.', 'err');
            } else if (!passwordMeetsComplexity(newValue)) {
                setHint(pwdLengthHint, '✕', '영문 대문자·소문자·숫자·특수문자를 모두 포함해주세요.', 'err');
            } else {
                setHint(pwdLengthHint, '✓', '비밀번호 규칙을 만족합니다.', 'ok');
            }

            if (confirmValue.length === 0) {
                setHint(pwdMatchHint, '•', '비밀번호 확인 입력 필요', '');
            } else if (newValue === confirmValue && passwordMeetsComplexity(newValue)) {
                setHint(pwdMatchHint, '✓', '비밀번호가 일치합니다.', 'ok');
            } else if (newValue === confirmValue) {
                setHint(pwdMatchHint, '✕', '위 규칙을 만족한 뒤 일치해야 합니다.', 'err');
            } else {
                setHint(pwdMatchHint, '✕', '비밀번호가 일치하지 않습니다.', 'err');
            }
        }

        newPasswordInput.addEventListener('input', updateHints);
        newPasswordConfirmInput.addEventListener('input', updateHints);
        updateHints();
    })();
</script>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사업자 마이페이지 | LinkOra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #1a3a5c 0%, #0d2137 100%); position: sticky; top: 0; }
        .sidebar .nav-link { color: rgba(255,255,255,.75); padding: 10px 20px; border-radius: 6px; margin: 2px 8px; transition: .2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right: 8px; }
        .sidebar-brand { color: #fff; font-size: 1.2rem; font-weight: 700; padding: 20px; border-bottom: 1px solid rgba(255,255,255,.1); }
        .sidebar-avatar { width: 56px; height: 56px; border-radius: 50%; background: #3730a3; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 22px; overflow: hidden; border: 2px solid rgba(255,255,255,.3); margin: 16px auto 4px; }
        .sidebar-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .main-content { padding: 24px; }
        .page-header { background: #fff; border-radius: 10px; padding: 20px 24px; margin-bottom: 24px; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .profile-card { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,.06); margin-bottom: 20px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 12px; }
        .info-item { border: 1px solid #e6e8ec; border-radius: 8px; background: #fafafa; padding: 12px 14px; }
        .info-item.full { grid-column: 1 / -1; }
        .info-label { font-size: 12px; color: #64748b; font-weight: 700; margin-bottom: 4px; }
        .info-value { font-size: 14px; color: #243140; font-weight: 600; word-break: break-word; }
        .password-card { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .pwd-msg { font-size: 12px; font-weight: 700; margin-bottom: 8px; }
        .pwd-msg.ok { color: #16a34a; }
        .pwd-msg.err { color: #dc2626; }
        .pwd-hint { margin-top: 4px; font-size: 11px; font-weight: 700; color: #64748b; display: flex; align-items: center; gap: 6px; }
        .pwd-hint.ok { color: #16a34a; }
        .pwd-hint.err { color: #dc2626; }
        .partner-page-btn { background: #3730a3; color: #fff; border: none; padding: 10px 22px; border-radius: 8px; font-size: 14px; font-weight: 700; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; transition: .2s; }
        .partner-page-btn:hover { background: #2e28a3; color: #fff; filter: brightness(1.1); }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- 사이드바 -->
    <div class="col-auto sidebar" style="width: 220px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>파트너</div>

        <!-- 프로필 아바타 -->
        <div class="text-center px-3 pb-2">
            <div class="sidebar-avatar mx-auto">
                <% if (request.getAttribute("profileImage") != null && !((String) request.getAttribute("profileImage")).isBlank()) { %>
                <img src="${profileImage}" alt="프로필">
                <% } else { %>
                🏪
                <% } %>
            </div>
            <div class="text-white-50 small mt-1" style="font-size: .8rem;">${empty name ? '파트너' : name}</div>
        </div>

        <nav class="nav flex-column mt-1">
            <span class="nav-link text-white-50 small px-3 pt-2 pb-1">파트너 메뉴</span>
            <a class="nav-link" href="${ctx}/partner/reservation/list"><i class="bi bi-calendar-check"></i>파트너 예약관리</a>
            <a class="nav-link" href="${ctx}/partner/register/step1"><i class="bi bi-person-badge"></i>파트너 등록</a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/partner/mypage"><i class="bi bi-person-circle"></i>마이페이지</a>
            <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-person-circle me-2 text-primary"></i>사업자 마이페이지</h5>
                <small class="text-muted">사업자 계정 정보를 확인하고 관리합니다.</small>
            </div>
            <a class="partner-page-btn" href="${ctx}/partner/reservation/list">
                <i class="bi bi-calendar-check"></i>파트너 페이지
            </a>
        </div>

        <!-- 프로필 정보 -->
        <div class="profile-card">
            <div class="d-flex align-items-center gap-3 mb-4">
                <div style="width:56px;height:56px;border-radius:50%;background:#3730a3;color:#fff;display:flex;align-items:center;justify-content:center;font-size:22px;overflow:hidden;border:2px solid #e6e8ec;">
                    <% if (request.getAttribute("profileImage") != null && !((String) request.getAttribute("profileImage")).isBlank()) { %>
                    <img src="${profileImage}" alt="프로필" style="width:100%;height:100%;object-fit:cover;">
                    <% } else { %>
                    🏪
                    <% } %>
                </div>
                <div>
                    <div class="fw-bold fs-6">${empty name ? '-' : name}</div>
                    <span class="badge" style="background:#eef2ff;color:#3730a3;border:1px solid #c7d2fe;font-size:11px;">사업자 계정 | LinkOra</span>
                </div>
                <div class="ms-auto">
                    <form method="post" action="${ctx}/partner/mypage/profile" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <label class="btn btn-sm btn-outline-secondary" for="partnerProfileImageFile" style="cursor:pointer;">프로필 수정</label>
                        <input id="partnerProfileImageFile" name="profileImage" type="file" accept="image/*" style="display:none" onchange="this.form.submit()">
                    </form>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">사업자 아이디</div>
                    <div class="info-value">${empty partnerId ? '-' : partnerId}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">상호/담당자명</div>
                    <div class="info-value">${empty name ? '-' : name}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">사업자번호</div>
                    <div class="info-value">${empty bizNo ? '-' : bizNo}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">이메일</div>
                    <div class="info-value">${empty email ? '-' : email}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">전화번호</div>
                    <div class="info-value">${empty phone ? '-' : phone}</div>
                </div>
                <div class="info-item full">
                    <div class="info-label">주소</div>
                    <div class="info-value">${empty address ? '-' : address}</div>
                </div>
            </div>
        </div>

        <!-- 비밀번호 변경 -->
        <div class="password-card">
            <h6 class="fw-bold mb-3"><i class="bi bi-lock me-2 text-secondary"></i>비밀번호 변경</h6>
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

            <form method="post" action="${ctx}/partner/mypage/password" style="max-width: 460px;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="mb-3">
                    <label class="form-label small fw-bold text-secondary" for="partnerCurrentPassword">현재 비밀번호</label>
                    <input id="partnerCurrentPassword" name="currentPassword" type="password" class="form-control form-control-sm" required autocomplete="current-password">
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold text-secondary" for="partnerNewPassword">새 비밀번호</label>
                    <input id="partnerNewPassword" name="newPassword" type="password" class="form-control form-control-sm" minlength="8" required autocomplete="new-password">
                    <p id="partnerPwdLengthHint" class="pwd-hint"><span class="icon">•</span><span>8자 이상, 영문 대·소문자·숫자·특수문자 포함</span></p>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold text-secondary" for="partnerNewPasswordConfirm">새 비밀번호 확인</label>
                    <input id="partnerNewPasswordConfirm" name="newPasswordConfirm" type="password" class="form-control form-control-sm" minlength="8" required autocomplete="new-password">
                    <p id="partnerPwdMatchHint" class="pwd-hint"><span class="icon">•</span><span>비밀번호 확인 입력 필요</span></p>
                </div>
                <button type="submit" class="btn btn-primary btn-sm px-4">비밀번호 변경</button>
            </form>

            <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                <form id="partnerWithdrawForm" method="post" action="${ctx}/partner/mypage/delete">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <input type="hidden" name="currentPassword">
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="openWithdrawModal('사업자')">사업자 탈퇴</button>
                </form>
                <a class="btn btn-sm btn-outline-secondary" href="${ctx}/logoutNow">로그아웃</a>
            </div>
            <% if ("password".equals(request.getAttribute("withdrawError"))) { %>
            <p class="pwd-msg err mt-2">탈퇴 비밀번호가 올바르지 않습니다.</p>
            <% } %>
            <% if ("failed".equals(request.getAttribute("withdrawError"))) { %>
            <p class="pwd-msg err mt-2">사업자 탈퇴 처리에 실패했습니다.</p>
            <% } %>
        </div>
    </div>

</div>
</div>

<!-- 탈퇴 모달 -->
<div id="withdrawModal" style="position:fixed;inset:0;background:rgba(15,23,42,.45);display:none;align-items:center;justify-content:center;z-index:1000;" role="dialog" aria-modal="true" aria-hidden="true">
    <div style="width:100%;max-width:360px;background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:20px;box-shadow:0 14px 24px rgba(15,23,42,.2);">
        <h2 id="withdrawModalTitle" style="margin:0 0 8px;font-size:16px;font-weight:800;">사업자 탈퇴 확인</h2>
        <p style="margin:0 0 12px;font-size:13px;color:#64748b;">탈퇴를 위해 비밀번호를 입력하세요.</p>
        <input id="withdrawModalPassword" type="password" autocomplete="current-password" placeholder="비밀번호" class="form-control form-control-sm mb-3">
        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="closeWithdrawModal()">취소</button>
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="submitWithdrawModal()">탈퇴</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
var withdrawTargetForm = null;
var withdrawModal = document.getElementById('withdrawModal');
var withdrawModalInput = document.getElementById('withdrawModalPassword');

function openWithdrawModal(label) {
    withdrawTargetForm = document.getElementById('partnerWithdrawForm');
    document.getElementById('withdrawModalTitle').textContent = label + ' 탈퇴 확인';
    withdrawModalInput.value = '';
    withdrawModal.style.display = 'flex';
    withdrawModal.setAttribute('aria-hidden', 'false');
    setTimeout(function() { withdrawModalInput.focus(); }, 0);
}

function closeWithdrawModal() {
    withdrawModal.style.display = 'none';
    withdrawModal.setAttribute('aria-hidden', 'true');
    withdrawTargetForm = null;
}

function submitWithdrawModal() {
    if (!withdrawTargetForm) return;
    var password = withdrawModalInput.value || '';
    if (!password.trim()) { alert('비밀번호를 입력해주세요.'); return; }
    if (!window.confirm('정말 탈퇴하시겠습니까? 계정 정보는 복구할 수 없습니다.')) return;
    withdrawTargetForm.currentPassword.value = password;
    withdrawTargetForm.submit();
}

withdrawModal.addEventListener('click', function(e) { if (e.target === withdrawModal) closeWithdrawModal(); });
document.addEventListener('keydown', function(e) {
    if (!withdrawModal.style.display || withdrawModal.style.display === 'none') return;
    if (e.key === 'Escape') closeWithdrawModal();
    if (e.key === 'Enter') submitWithdrawModal();
});

(function initPartnerPasswordHints() {
    var newInput = document.getElementById('partnerNewPassword');
    var confirmInput = document.getElementById('partnerNewPasswordConfirm');
    var lengthHint = document.getElementById('partnerPwdLengthHint');
    var matchHint = document.getElementById('partnerPwdMatchHint');
    if (!newInput || !confirmInput) return;

    function complex(pw) {
        return pw && pw.length >= 8 && /[A-Z]/.test(pw) && /[a-z]/.test(pw) && /[0-9]/.test(pw) && /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?`~]/.test(pw);
    }
    function setHint(el, icon, text, cls) {
        el.className = 'pwd-hint' + (cls ? ' ' + cls : '');
        el.querySelector('.icon').textContent = icon;
        el.querySelector('span:last-child').textContent = text;
    }
    function update() {
        var nv = newInput.value || '', cv = confirmInput.value || '';
        if (!nv) setHint(lengthHint, '•', '8자 이상, 영문 대·소문자·숫자·특수문자 포함', '');
        else if (nv.length < 8) setHint(lengthHint, '✕', '최소 8자 이상 입력해주세요.', 'err');
        else if (!complex(nv)) setHint(lengthHint, '✕', '영문 대문자·소문자·숫자·특수문자를 모두 포함해주세요.', 'err');
        else setHint(lengthHint, '✓', '비밀번호 규칙을 만족합니다.', 'ok');

        if (!cv) setHint(matchHint, '•', '비밀번호 확인 입력 필요', '');
        else if (nv === cv && complex(nv)) setHint(matchHint, '✓', '비밀번호가 일치합니다.', 'ok');
        else if (nv === cv) setHint(matchHint, '✕', '위 규칙을 만족한 뒤 일치해야 합니다.', 'err');
        else setHint(matchHint, '✕', '비밀번호가 일치하지 않습니다.', 'err');
    }
    newInput.addEventListener('input', update);
    confirmInput.addEventListener('input', update);
    update();
})();
</script>
</body>
</html>

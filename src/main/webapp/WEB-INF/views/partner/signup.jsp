<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사업자 회원가입</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: #f4f6f8;
            font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
        }
        .content { padding: 16px; }
        .wrap {
            max-width: 420px;
            margin: 0 auto;
            background: #ffffff;
            border: 1px solid #e6e8ec;
            border-radius: 10px;
            padding: 18px 20px;
        }
        h1 { margin: 0 0 14px; font-size: 20px; color: #243140; }
        .form-group { margin-bottom: 10px; }
        .pwd-inline {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .pwd-inline input {
            flex: 1;
        }
        .pwd-mark {
            min-width: 20px;
            font-size: 16px;
            font-weight: 700;
            line-height: 1;
            visibility: hidden;
        }
        .pwd-mark.ok {
            color: #16a34a;
            visibility: visible;
        }
        .pwd-mark.fail {
            color: #dc2626;
            visibility: visible;
        }
        .address-row {
            display: flex;
            gap: 6px;
            margin-bottom: 6px;
        }
        label {
            display: block;
            margin-bottom: 4px;
            font-size: 12px;
            color: #334155;
            font-weight: 700;
        }
        input {
            width: 100%;
            height: 36px;
            border: 1px solid #d9d9d9;
            border-radius: 6px;
            padding: 0 10px;
            font-size: 13px;
        }
        .submit-btn {
            width: 100%;
            height: 40px;
            border: none;
            border-radius: 6px;
            background: #3730a3;
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 4px;
        }
        .msg { margin: 0 0 10px; font-size: 12px; text-align: center; }
        .msg.error { color: #dc2626; }
        .hint { color: #64748b; font-size: 12px; margin: 0 0 12px; }
        .postcode-btn {
            width: 118px;
            height: 36px;
            flex-shrink: 0;
            border: 1px solid #3730a3;
            background: #ffffff;
            color: #3730a3;
            font-size: 12px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
        }
        .guide {
            color: #999;
            display: none;
            margin: 2px 0 10px;
            font-size: 13px;
        }
        .file-input {
            width: 100%;
            height: auto;
            padding: 6px 0;
        }
        .id-row {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .id-row input {
            flex: 1;
            min-width: 0;
        }
        .dup-check-btn {
            flex-shrink: 0;
            height: 36px;
            padding: 0 12px;
            border: 1px solid #3730a3;
            border-radius: 6px;
            background: #ffffff;
            color: #3730a3;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
        }
        .dup-check-btn:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }
        .id-check-msg {
            margin: 4px 0 0;
            font-size: 12px;
            min-height: 1.2em;
        }
        .id-check-msg.ok { color: #16a34a; font-weight: 600; }
        .id-check-msg.fail { color: #dc2626; font-weight: 600; }
        .id-check-msg.wait { color: #64748b; }
        .verify-row {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-top: 8px;
        }
        .verify-row input {
            flex: 1;
            min-width: 0;
        }
        .consent-block { margin-top: 12px; margin-bottom: 8px; }
        .consent-label {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 13px;
            color: #334155;
            font-weight: 500;
            cursor: pointer;
            line-height: 1.45;
        }
        .consent-label input[type="checkbox"] {
            width: auto;
            height: auto;
            margin-top: 3px;
            flex-shrink: 0;
        }
        .consent-label a { color: #3730a3; font-weight: 700; }
    </style>
</head>
<body>
<%
    String errorParam = request.getParameter("error");
%>
<%@include file="../layout/header.jsp"%>

<main class="content">
    <section class="wrap">
        <h1>사업자 회원가입</h1>
        <% if ("duplicateId".equals(errorParam)) { %>
        <p class="msg error">이미 사용 중인 아이디입니다. (일반 회원·사업자 계정과 서로 중복될 수 없습니다.)</p>
        <% } else if ("duplicateEmail".equals(errorParam)) { %>
        <p class="msg error">이미 사용 중인 이메일입니다. (일반 회원·사업자 계정과 서로 중복될 수 없습니다.)</p>
        <% } else if ("duplicateBizNo".equals(errorParam)) { %>
        <p class="msg error">이미 등록된 사업자번호입니다.</p>
        <% } else if ("passwordMismatch".equals(errorParam)) { %>
        <p class="msg error">비밀번호와 비밀번호 확인이 일치하지 않습니다.</p>
        <% } else if ("passwordWeak".equals(errorParam)) { %>
        <p class="msg error">비밀번호는 8자 이상 입력해주세요.</p>
        <% } else if ("passwordComplex".equals(errorParam)) { %>
        <p class="msg error">비밀번호는 8자 이상이며, 영문 대문자·소문자·숫자·특수문자(!@#$%^&amp;* 등)를 각각 1개 이상 포함해야 합니다.</p>
        <% } else if ("phoneFormat".equals(errorParam)) { %>
        <p class="msg error">전화번호 형식은 xxx-xxxx-xxxx 입니다.</p>
        <% } else if ("emailFormat".equals(errorParam)) { %>
        <p class="msg error">이메일에는 @와 .이 모두 포함되어야 합니다.</p>
        <% } else if ("emailVerifyRequired".equals(errorParam)) { %>
        <p class="msg error">이메일 인증을 완료해 주세요.</p>
        <% } else if ("bizNoFormat".equals(errorParam)) { %>
        <p class="msg error">사업자번호 형식은 xxx-xx-xxxxx 입니다.</p>
        <% } else if ("schema".equals(errorParam)) { %>
        <p class="msg error">partner 테이블 컬럼 확인이 필요합니다.</p>
        <% } else if ("failed".equals(errorParam)) { %>
        <p class="msg error">사업자회원가입 처리에 실패했습니다.</p>
        <% } else if ("privacyRequired".equals(errorParam)) { %>
        <p class="msg error">개인정보 처리방침에 동의해야 회원가입할 수 있습니다.</p>
        <% } else if ("termsRequired".equals(errorParam)) { %>
        <p class="msg error">이용약관에 동의해야 회원가입할 수 있습니다.</p>
        <% } %>

        <form method="post" action="${ctx}/partner-signup" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <div class="form-group">
                <label for="partnerProfileImage">프로필 이미지 (선택)</label>
                <input class="file-input" type="file" id="partnerProfileImage" name="partnerProfileImage" accept="image/*">
            </div>
            <div class="form-group">
                <label for="partnerId">사업자 아이디</label>
                <div class="id-row">
                    <input type="text" id="partnerId" name="partnerId" required maxlength="64" autocomplete="username">
                    <button type="button" class="dup-check-btn" id="partnerIdDupCheckBtn">중복 확인</button>
                </div>
                <p id="partnerIdCheckMsg" class="id-check-msg" role="status" aria-live="polite"></p>
            </div>
            <div class="form-group">
                <label for="partnerPwd">비밀번호</label>
                <div class="pwd-inline">
                    <input type="password" id="partnerPwd" name="partnerPwd" minlength="8" required autocomplete="new-password">
                    <span id="pwdMark" class="pwd-mark" aria-hidden="true"></span>
                </div>
                <p class="hint">8자 이상, 영문 대문자·소문자·숫자·특수문자(!@#$%^&amp;* 등)를 각각 포함해야 합니다.</p>
            </div>
            <div class="form-group">
                <label for="partnerPwdConfirm">비밀번호 확인</label>
                <div class="pwd-inline">
                    <input type="password" id="partnerPwdConfirm" name="partnerPwdConfirm" minlength="8" required autocomplete="new-password">
                    <span id="pwdConfirmMark" class="pwd-mark" aria-hidden="true"></span>
                </div>
            </div>
            <div class="form-group">
                <label for="partnerName">상호/담당자명</label>
                <input type="text" id="partnerName" name="partnerName" required>
            </div>
            <div class="form-group">
                <label for="partnerBizNo">사업자번호</label>
                <input type="text" id="partnerBizNo" name="partnerBizNo" placeholder="123-45-67890" pattern="[0-9]{3}-[0-9]{2}-[0-9]{5}" maxlength="13" inputmode="numeric" autocomplete="off" required>
            </div>
            <div class="form-group">
                <label for="partnerPhone">전화번호</label>
                <input type="text" id="partnerPhone" name="partnerPhone" placeholder="010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" maxlength="13" inputmode="numeric" autocomplete="off" required>
            </div>
            <div class="form-group">
                <label for="partnerEmail">이메일</label>
                <div class="id-row">
                    <input type="email" id="partnerEmail" name="partnerEmail" placeholder="이메일을 입력하세요" pattern=".+@.+\..+" maxlength="128" required autocomplete="email">
                    <button type="button" class="dup-check-btn" id="partnerEmailDupCheckBtn">중복 확인</button>
                </div>
                <p id="partnerEmailCheckMsg" class="id-check-msg" role="status" aria-live="polite"></p>
                <div class="verify-row">
                    <input type="text" id="partnerEmailVerifyCode" placeholder="인증번호 6자리" maxlength="6" inputmode="numeric" autocomplete="one-time-code">
                    <button type="button" class="dup-check-btn" id="partnerSendEmailCodeBtn">인증번호 받기</button>
                    <button type="button" class="dup-check-btn" id="partnerVerifyEmailCodeBtn">인증 확인</button>
                </div>
                <p id="partnerEmailVerifyMsg" class="id-check-msg" role="status" aria-live="polite"></p>
                <input type="hidden" id="partnerEmailVerified" value="false">
            </div>
            <div class="form-group">
                <label for="sample4Postcode">주소</label>
                <div class="address-row">
                    <input type="text" id="sample4Postcode" name="postcode" placeholder="우편번호">
                    <input type="button" class="postcode-btn" onclick="sample4ExecDaumPostcode()" value="우편번호 찾기">
                </div>
                <input type="text" id="sample4RoadAddress" name="roadAddress" placeholder="도로명주소">
                <div style="height:4px;"></div>
                <input type="text" id="sample4JibunAddress" name="jibunAddress" placeholder="지번주소">
                <span id="guide" class="guide"></span>
                <div style="height:4px;"></div>
                <input type="text" id="sample4DetailAddress" name="detailAddress" placeholder="상세주소">
                <div style="height:4px;"></div>
                <input type="text" id="sample4ExtraAddress" name="extraAddress" placeholder="참고항목">
            </div>
            <input type="hidden" id="partnerAddr" name="partnerAddr">

            <div class="form-group consent-block">
                <label class="consent-label" for="agreePrivacy">
                    <input type="checkbox" name="agreePrivacy" value="true" id="agreePrivacy" required>
                    <span><a href="${ctx}/privacy" target="_blank" rel="noopener noreferrer">개인정보 처리방침</a>을 확인하였으며 이에 동의합니다. (필수)</span>
                </label>
                <label class="consent-label" for="agreeTerms" style="margin-top:8px;">
                    <input type="checkbox" name="agreeTerms" value="true" id="agreeTerms" required>
                    <span><a href="${ctx}/terms" target="_blank" rel="noopener noreferrer">이용약관</a>을 확인하였으며 이에 동의합니다. (필수)</span>
                </label>
            </div>
            <button class="submit-btn" type="submit">사업자 회원가입</button>
        </form>
    </section>
</main>
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function passwordMeetsPolicy(pw) {
        if (!pw || pw.length < 8) {
            return false;
        }
        return /[A-Z]/.test(pw) && /[a-z]/.test(pw) && /[0-9]/.test(pw)
            && /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?`~]/.test(pw);
    }

    (function () {
        var bizNo = document.getElementById('partnerBizNo');
        var phone = document.getElementById('partnerPhone');
        var pwd = document.getElementById('partnerPwd');
        var pwdConfirm = document.getElementById('partnerPwdConfirm');
        var pwdMark = document.getElementById('pwdMark');
        var pwdConfirmMark = document.getElementById('pwdConfirmMark');
        if (!bizNo) return;

        function updatePasswordMarks() {
            if (!pwd || !pwdConfirm || !pwdMark || !pwdConfirmMark) {
                return;
            }
            var a = pwd.value || '';
            var b = pwdConfirm.value || '';

            pwdMark.className = 'pwd-mark';
            pwdConfirmMark.className = 'pwd-mark';
            pwdMark.textContent = '';
            pwdConfirmMark.textContent = '';

            if (!a && !b) {
                return;
            }

            if (a === b && passwordMeetsPolicy(a)) {
                pwdMark.className = 'pwd-mark ok';
                pwdConfirmMark.className = 'pwd-mark ok';
                pwdMark.textContent = '✓';
                pwdConfirmMark.textContent = '✓';
            } else {
                pwdMark.className = 'pwd-mark fail';
                pwdConfirmMark.className = 'pwd-mark fail';
                pwdMark.textContent = '✕';
                pwdConfirmMark.textContent = '✕';
            }
        }

        function formatBizNo(raw) {
            var onlyDigits = (raw || '').replace(/\D/g, '').substring(0, 10);
            if (onlyDigits.length <= 3) return onlyDigits;
            if (onlyDigits.length <= 5) return onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3);
            return onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3, 5) + '-' + onlyDigits.slice(5);
        }

        bizNo.addEventListener('input', function () {
            var before = bizNo.value;
            var formatted = formatBizNo(before);
            bizNo.value = formatted;
        });

        if (phone) {
            phone.addEventListener('input', function () {
                var raw = phone.value || '';
                var onlyDigits = raw.replace(/\D/g, '').substring(0, 11);
                if (onlyDigits.length <= 3) {
                    phone.value = onlyDigits;
                    return;
                }
                if (onlyDigits.length <= 7) {
                    phone.value = onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3);
                    return;
                }
                phone.value = onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3, 7) + '-' + onlyDigits.slice(7);
            });
        }
        if (pwd) pwd.addEventListener('input', updatePasswordMarks);
        if (pwdConfirm) pwdConfirm.addEventListener('input', updatePasswordMarks);

        var partnerIdInput = document.getElementById('partnerId');
        var partnerDupBtn = document.getElementById('partnerIdDupCheckBtn');
        var partnerIdMsg = document.getElementById('partnerIdCheckMsg');
        if (partnerIdInput && partnerDupBtn && partnerIdMsg) {
            function clearPartnerIdMsg() {
                partnerIdMsg.textContent = '';
                partnerIdMsg.className = 'id-check-msg';
            }
            partnerIdInput.addEventListener('input', clearPartnerIdMsg);
            partnerDupBtn.addEventListener('click', function () {
                var id = (partnerIdInput.value || '').trim();
                if (!id) {
                    partnerIdMsg.className = 'id-check-msg fail';
                    partnerIdMsg.textContent = '아이디를 입력해 주세요.';
                    return;
                }
                partnerDupBtn.disabled = true;
                partnerIdMsg.className = 'id-check-msg wait';
                partnerIdMsg.textContent = '확인 중…';
                fetch('${pageContext.request.contextPath}/api/signup/check-user-id?userId=' + encodeURIComponent(id), { method: 'GET', credentials: 'same-origin' })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var ok = data && data.available === true;
                        partnerIdMsg.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                        partnerIdMsg.textContent = (data && data.message) ? data.message : (ok ? '사용 가능합니다.' : '사용할 수 없습니다.');
                    })
                    .catch(function () {
                        partnerIdMsg.className = 'id-check-msg fail';
                        partnerIdMsg.textContent = '확인에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                    })
                    .finally(function () {
                        partnerDupBtn.disabled = false;
                    });
            });
        }

        var partnerEmailInput = document.getElementById('partnerEmail');
        var partnerEmailDupBtn = document.getElementById('partnerEmailDupCheckBtn');
        var partnerEmailMsg = document.getElementById('partnerEmailCheckMsg');
        var partnerSendEmailCodeBtn = document.getElementById('partnerSendEmailCodeBtn');
        var partnerVerifyEmailCodeBtn = document.getElementById('partnerVerifyEmailCodeBtn');
        var partnerEmailVerifyCodeInput = document.getElementById('partnerEmailVerifyCode');
        var partnerEmailVerifyMsg = document.getElementById('partnerEmailVerifyMsg');
        var partnerEmailVerified = document.getElementById('partnerEmailVerified');
        if (partnerEmailInput && partnerEmailDupBtn && partnerEmailMsg) {
            function clearPartnerEmailMsg() {
                partnerEmailMsg.textContent = '';
                partnerEmailMsg.className = 'id-check-msg';
                if (partnerEmailVerifyMsg) {
                    partnerEmailVerifyMsg.textContent = '';
                    partnerEmailVerifyMsg.className = 'id-check-msg';
                }
                if (partnerEmailVerified) {
                    partnerEmailVerified.value = 'false';
                }
            }
            partnerEmailInput.addEventListener('input', clearPartnerEmailMsg);
            if (partnerEmailVerifyCodeInput) {
                partnerEmailVerifyCodeInput.addEventListener('input', function () {
                    partnerEmailVerifyCodeInput.value = (partnerEmailVerifyCodeInput.value || '').replace(/\D/g, '').substring(0, 6);
                });
            }
            partnerEmailDupBtn.addEventListener('click', function () {
                var em = (partnerEmailInput.value || '').trim();
                if (!em) {
                    partnerEmailMsg.className = 'id-check-msg fail';
                    partnerEmailMsg.textContent = '이메일을 입력해 주세요.';
                    return;
                }
                if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(em)) {
                    partnerEmailMsg.className = 'id-check-msg fail';
                    partnerEmailMsg.textContent = '올바른 이메일 형식이 아닙니다.';
                    return;
                }
                partnerEmailDupBtn.disabled = true;
                partnerEmailMsg.className = 'id-check-msg wait';
                partnerEmailMsg.textContent = '확인 중…';
                fetch('${pageContext.request.contextPath}/api/signup/check-email?email=' + encodeURIComponent(em), { method: 'GET', credentials: 'same-origin' })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var ok = data && data.available === true;
                        partnerEmailMsg.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                        partnerEmailMsg.textContent = (data && data.message) ? data.message : (ok ? '사용 가능합니다.' : '사용할 수 없습니다.');
                    })
                    .catch(function () {
                        partnerEmailMsg.className = 'id-check-msg fail';
                        partnerEmailMsg.textContent = '확인에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                    })
                    .finally(function () {
                        partnerEmailDupBtn.disabled = false;
                    });
            });

            function csrfInfo() {
                var csrfName = '${_csrf.parameterName}';
                var csrfToken = '${_csrf.token}';
                return { name: csrfName, token: csrfToken };
            }

            if (partnerSendEmailCodeBtn) {
                partnerSendEmailCodeBtn.addEventListener('click', function () {
                    var em = (partnerEmailInput.value || '').trim();
                    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(em)) {
                        partnerEmailVerifyMsg.className = 'id-check-msg fail';
                        partnerEmailVerifyMsg.textContent = '올바른 이메일 형식을 입력해 주세요.';
                        return;
                    }
                    var csrf = csrfInfo();
                    partnerSendEmailCodeBtn.disabled = true;
                    partnerEmailVerifyMsg.className = 'id-check-msg wait';
                    partnerEmailVerifyMsg.textContent = '인증번호 발송 중…';
                    fetch('${pageContext.request.contextPath}/api/signup/send-email-code', {
                        method: 'POST',
                        credentials: 'same-origin',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                            'X-Requested-With': 'XMLHttpRequest',
                            'X-CSRF-TOKEN': csrf.token
                        },
                        body: 'email=' + encodeURIComponent(em) + '&' + encodeURIComponent(csrf.name) + '=' + encodeURIComponent(csrf.token)
                    })
                        .then(function (res) { return res.json(); })
                        .then(function (data) {
                            var ok = data && data.success === true;
                            partnerEmailVerifyMsg.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                            if (!ok && data && data.cooldownSeconds) {
                                partnerEmailVerifyMsg.textContent = '재요청은 ' + data.cooldownSeconds + '초 후 가능합니다.';
                            } else {
                                partnerEmailVerifyMsg.textContent = (data && data.message) ? data.message : (ok ? '인증번호를 보냈습니다.' : '인증번호 발송에 실패했습니다.');
                            }
                            partnerEmailVerified.value = 'false';
                        })
                        .catch(function () {
                            partnerEmailVerifyMsg.className = 'id-check-msg fail';
                            partnerEmailVerifyMsg.textContent = '인증번호 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                        })
                        .finally(function () {
                            partnerSendEmailCodeBtn.disabled = false;
                        });
                });
            }

            if (partnerVerifyEmailCodeBtn) {
                partnerVerifyEmailCodeBtn.addEventListener('click', function () {
                    var em = (partnerEmailInput.value || '').trim();
                    var code = (partnerEmailVerifyCodeInput && partnerEmailVerifyCodeInput.value ? partnerEmailVerifyCodeInput.value : '').trim();
                    if (!em || !code) {
                        partnerEmailVerifyMsg.className = 'id-check-msg fail';
                        partnerEmailVerifyMsg.textContent = '이메일과 인증번호를 입력해 주세요.';
                        return;
                    }
                    var csrf = csrfInfo();
                    partnerVerifyEmailCodeBtn.disabled = true;
                    partnerEmailVerifyMsg.className = 'id-check-msg wait';
                    partnerEmailVerifyMsg.textContent = '인증 확인 중…';
                    fetch('${pageContext.request.contextPath}/api/signup/verify-email-code', {
                        method: 'POST',
                        credentials: 'same-origin',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                            'X-Requested-With': 'XMLHttpRequest',
                            'X-CSRF-TOKEN': csrf.token
                        },
                        body: 'email=' + encodeURIComponent(em) + '&code=' + encodeURIComponent(code)
                            + '&' + encodeURIComponent(csrf.name) + '=' + encodeURIComponent(csrf.token)
                    })
                        .then(function (res) { return res.json(); })
                        .then(function (data) {
                            var ok = data && data.success === true;
                            partnerEmailVerifyMsg.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                            partnerEmailVerifyMsg.textContent = (data && data.message) ? data.message : (ok ? '인증 완료' : '인증 실패');
                            partnerEmailVerified.value = ok ? 'true' : 'false';
                        })
                        .catch(function () {
                            partnerEmailVerifyMsg.className = 'id-check-msg fail';
                            partnerEmailVerifyMsg.textContent = '인증 처리에 실패했습니다.';
                            partnerEmailVerified.value = 'false';
                        })
                        .finally(function () {
                            partnerVerifyEmailCodeBtn.disabled = false;
                        });
                });
            }
        }

        document.querySelector('form').addEventListener('submit', function (e) {
            if ((pwd.value || '') !== (pwdConfirm.value || '')) {
                e.preventDefault();
                alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
                return;
            }
            if ((pwd.value || '').length < 8) {
                e.preventDefault();
                alert('비밀번호는 8자 이상 입력해주세요.');
                return;
            }
            if (!passwordMeetsPolicy(pwd.value || '')) {
                e.preventDefault();
                alert('비밀번호는 영문 대문자·소문자·숫자·특수문자를 각각 1개 이상 포함해야 합니다.');
                return;
            }
            var email = document.getElementById('partnerEmail').value;
            if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
                e.preventDefault();
                alert('이메일에는 @와 .이 모두 포함되어야 합니다.');
                return;
            }
            if (!partnerEmailVerified || partnerEmailVerified.value !== 'true') {
                e.preventDefault();
                alert('이메일 인증을 완료해 주세요.');
                return;
            }
            var agreePrivacyEl = document.getElementById('agreePrivacy');
            if (agreePrivacyEl && !agreePrivacyEl.checked) {
                e.preventDefault();
                alert('개인정보 처리방침에 동의해 주세요.');
                return;
            }
            var agreeTermsEl = document.getElementById('agreeTerms');
            if (agreeTermsEl && !agreeTermsEl.checked) {
                e.preventDefault();
                alert('이용약관에 동의해 주세요.');
                return;
            }
            var road = document.getElementById('sample4RoadAddress').value;
            var jibun = document.getElementById('sample4JibunAddress').value;
            var detail = document.getElementById('sample4DetailAddress').value;
            var extra = document.getElementById('sample4ExtraAddress').value;
            var merged = [road || jibun, detail, extra].filter(Boolean).join(' ');
            document.getElementById('partnerAddr').value = merged;
        });
    })();

    function sample4ExecDaumPostcode() {
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

                document.getElementById('sample4Postcode').value = data.zonecode;
                document.getElementById('sample4RoadAddress').value = roadAddr;
                document.getElementById('sample4JibunAddress').value = data.jibunAddress;

                if (roadAddr !== '') {
                    document.getElementById('sample4ExtraAddress').value = extraRoadAddr;
                } else {
                    document.getElementById('sample4ExtraAddress').value = '';
                }

                var guideTextBox = document.getElementById('guide');
                if (data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';
                } else if (data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
</script>
</body>
</html>


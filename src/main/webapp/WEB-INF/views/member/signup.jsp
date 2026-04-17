<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- 일반 회원가입 화면: 기본 회원 정보/비밀번호 검증 후 가입 요청을 전송한다. --%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: #f4f6f8;
            font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
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
        .home-btn {
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
        .content {
            padding: 16px;
        }
        .wrap {
            max-width: 400px;
            margin: 0 auto;
            background: #ffffff;
            border: 1px solid #e6e8ec;
            border-radius: 10px;
            padding: 18px 20px;
        }
        h1 {
            margin: 0 0 14px;
            font-size: 20px;
            color: #243140;
        }
        .form-group {
            margin-bottom: 10px;
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
        .postcode-btn {
            width: 118px;
            height: 36px;
            flex-shrink: 0;
            border: 1px solid #162a4a;
            background: #ffffff;
            color: #162a4a;
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
        .submit-btn {
            width: 100%;
            height: 38px;
            border: none;
            border-radius: 6px;
            background: #162a4a;
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 4px;
        }
        .msg {
            margin: 0 0 10px;
            font-size: 12px;
            text-align: center;
        }
        .msg.error {
            color: #dc2626;
        }
        input[type="file"] {
            width: 100%;
            font-size: 13px;
            padding: 8px 0;
        }
        .hint {
            font-size: 11px;
            color: #94a3b8;
            font-weight: 500;
            margin-top: 4px;
        }
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
            font-weight: 800;
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
            border: 1px solid #162a4a;
            border-radius: 6px;
            background: #ffffff;
            color: #162a4a;
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
        .consent-label a { color: #162a4a; font-weight: 700; }
    </style>
</head>
<%@include file="../layout/header.jsp"%>
<body>
<%
    String errorParam = request.getParameter("error");
%>

<main class="content">
    <section class="wrap">
        <h1>회원가입</h1>

        <% if ("duplicateId".equals(errorParam)) { %>
        <p class="msg error">이미 사용 중인 아이디입니다. (일반 회원·사업자 계정과 서로 중복될 수 없습니다.)</p>
        <% } else if ("duplicateEmail".equals(errorParam)) { %>
        <p class="msg error">이미 사용 중인 이메일입니다. (일반 회원·사업자 계정과 서로 중복될 수 없습니다.)</p>
        <% } else if ("failed".equals(errorParam)) { %>
        <p class="msg error">회원가입 처리에 실패했습니다.</p>
        <% } else if ("invalidImage".equals(errorParam)) { %>
        <p class="msg error">프로필 사진은 이미지 파일(jpg, png, gif, webp)만 올릴 수 있습니다.</p>
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
        <% } else if ("privacyRequired".equals(errorParam)) { %>
        <p class="msg error">개인정보 처리방침에 동의해야 회원가입할 수 있습니다.</p>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/signup" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

            <div class="form-group">
                <label for="profileImage">프로필 사진 (선택)</label>
                <input type="file" id="profileImage" name="profileImage" accept="image/jpeg,image/png,image/gif,image/webp,.jpg,.jpeg,.png,.gif,.webp">
                <p class="hint">선택 사항입니다. JPG, PNG, GIF, WEBP · 최대 2MB 권장</p>
            </div>

            <div class="form-group">
                <label for="userId">아이디</label>
                <div class="id-row">
                    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required maxlength="64" autocomplete="username">
                    <button type="button" class="dup-check-btn" id="userIdDupCheckBtn">중복 확인</button>
                </div>
                <p id="userIdCheckMsg" class="id-check-msg" role="status" aria-live="polite"></p>
            </div>
            <div class="form-group">
                <label for="userPwd">비밀번호</label>
                <div class="pwd-inline">
                    <input type="password" id="userPwd" name="userPwd" placeholder="비밀번호를 입력하세요" minlength="8" required autocomplete="new-password">
                    <span id="pwdMark" class="pwd-mark" aria-hidden="true"></span>
                </div>
                <p class="hint">8자 이상, 영문 대문자·소문자·숫자·특수문자(!@#$%^&amp;* 등)를 각각 포함해야 합니다.</p>
            </div>
            <div class="form-group">
                <label for="userPwdConfirm">비밀번호 확인</label>
                <div class="pwd-inline">
                    <input type="password" id="userPwdConfirm" name="userPwdConfirm" placeholder="비밀번호를 다시 입력하세요" minlength="8" required autocomplete="new-password">
                    <span id="pwdConfirmMark" class="pwd-mark" aria-hidden="true"></span>
                </div>
            </div>
            <div class="form-group">
                <label for="userName">이름</label>
                <input type="text" id="userName" name="userName" placeholder="이름을 입력하세요" required>
            </div>
            <div class="form-group">
                <label for="userPhone">전화번호</label>
                <input type="text" id="userPhone" name="userPhone" placeholder="010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" maxlength="13" inputmode="numeric" autocomplete="off" required>
            </div>
            <div class="form-group">
                <label for="userEmail">이메일</label>
                <div class="id-row">
                    <input type="email" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요" pattern=".+@.+\..+" maxlength="128" required autocomplete="email">
                    <button type="button" class="dup-check-btn" id="userEmailDupCheckBtn">중복 확인</button>
                </div>
                <p id="userEmailCheckMsg" class="id-check-msg" role="status" aria-live="polite"></p>
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

            <input type="hidden" id="userAddr" name="userAddr">

            <div class="form-group consent-block">
                <label class="consent-label" for="agreePrivacy">
                    <input type="checkbox" name="agreePrivacy" value="true" id="agreePrivacy" required>
                    <span><a href="${pageContext.request.contextPath}/privacy" target="_blank" rel="noopener noreferrer">개인정보 처리방침</a>을 확인하였으며 이에 동의합니다. (필수)</span>
                </label>
            </div>
            <button class="submit-btn" type="submit">회원가입</button>
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

    function updatePasswordMatchUi() {
        var pwd = document.getElementById('userPwd');
        var pwd2 = document.getElementById('userPwdConfirm');
        var pwdMark = document.getElementById('pwdMark');
        var pwdConfirmMark = document.getElementById('pwdConfirmMark');
        var a = pwd.value || '';
        var b = pwd2.value || '';

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

    document.getElementById('userPwd').addEventListener('input', updatePasswordMatchUi);
    document.getElementById('userPwdConfirm').addEventListener('input', updatePasswordMatchUi);

    (function () {
        var userIdInput = document.getElementById('userId');
        var dupBtn = document.getElementById('userIdDupCheckBtn');
        var msgEl = document.getElementById('userIdCheckMsg');
        if (!userIdInput || !dupBtn || !msgEl) {
            return;
        }
        function clearIdCheckMsg() {
            msgEl.textContent = '';
            msgEl.className = 'id-check-msg';
        }
        userIdInput.addEventListener('input', clearIdCheckMsg);
        dupBtn.addEventListener('click', function () {
            var id = (userIdInput.value || '').trim();
            if (!id) {
                msgEl.className = 'id-check-msg fail';
                msgEl.textContent = '아이디를 입력해 주세요.';
                return;
            }
            dupBtn.disabled = true;
            msgEl.className = 'id-check-msg wait';
            msgEl.textContent = '확인 중…';
            fetch('${pageContext.request.contextPath}/api/signup/check-user-id?userId=' + encodeURIComponent(id), { method: 'GET', credentials: 'same-origin' })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    var ok = data && data.available === true;
                    msgEl.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                    msgEl.textContent = (data && data.message) ? data.message : (ok ? '사용 가능합니다.' : '사용할 수 없습니다.');
                })
                .catch(function () {
                    msgEl.className = 'id-check-msg fail';
                    msgEl.textContent = '확인에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                })
                .finally(function () {
                    dupBtn.disabled = false;
                });
        });
    })();

    (function () {
        var emailInput = document.getElementById('userEmail');
        var emailDupBtn = document.getElementById('userEmailDupCheckBtn');
        var emailMsg = document.getElementById('userEmailCheckMsg');
        if (!emailInput || !emailDupBtn || !emailMsg) {
            return;
        }
        function clearEmailCheckMsg() {
            emailMsg.textContent = '';
            emailMsg.className = 'id-check-msg';
        }
        emailInput.addEventListener('input', clearEmailCheckMsg);
        emailDupBtn.addEventListener('click', function () {
            var em = (emailInput.value || '').trim();
            if (!em) {
                emailMsg.className = 'id-check-msg fail';
                emailMsg.textContent = '이메일을 입력해 주세요.';
                return;
            }
            if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(em)) {
                emailMsg.className = 'id-check-msg fail';
                emailMsg.textContent = '올바른 이메일 형식이 아닙니다.';
                return;
            }
            emailDupBtn.disabled = true;
            emailMsg.className = 'id-check-msg wait';
            emailMsg.textContent = '확인 중…';
            fetch('${pageContext.request.contextPath}/api/signup/check-email?email=' + encodeURIComponent(em), { method: 'GET', credentials: 'same-origin' })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    var ok = data && data.available === true;
                    emailMsg.className = ok ? 'id-check-msg ok' : 'id-check-msg fail';
                    emailMsg.textContent = (data && data.message) ? data.message : (ok ? '사용 가능합니다.' : '사용할 수 없습니다.');
                })
                .catch(function () {
                    emailMsg.className = 'id-check-msg fail';
                    emailMsg.textContent = '확인에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                })
                .finally(function () {
                    emailDupBtn.disabled = false;
                });
        });
    })();
    document.getElementById('userPhone').addEventListener('input', function () {
        var raw = this.value || '';
        var onlyDigits = raw.replace(/\D/g, '').substring(0, 11);
        if (onlyDigits.length <= 3) {
            this.value = onlyDigits;
            return;
        }
        if (onlyDigits.length <= 7) {
            this.value = onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3);
            return;
        }
        this.value = onlyDigits.slice(0, 3) + '-' + onlyDigits.slice(3, 7) + '-' + onlyDigits.slice(7);
    });

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

    document.querySelector('form').addEventListener('submit', function(e) {
        var pwd = document.getElementById('userPwd').value;
        var pwd2 = document.getElementById('userPwdConfirm').value;
        if (pwd !== pwd2) {
            e.preventDefault();
            alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
            return;
        }
        if (pwd.length < 8) {
            e.preventDefault();
            alert('비밀번호는 8자 이상 입력해주세요.');
            return;
        }
        if (!passwordMeetsPolicy(pwd)) {
            e.preventDefault();
            alert('비밀번호는 영문 대문자·소문자·숫자·특수문자를 각각 1개 이상 포함해야 합니다.');
            return;
        }
        var phone = document.getElementById('userPhone').value;
        if (!/^\d{3}-\d{4}-\d{4}$/.test(phone)) {
            e.preventDefault();
            alert('전화번호 형식은 xxx-xxxx-xxxx 입니다.');
            return;
        }
        var email = document.getElementById('userEmail').value;
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
            e.preventDefault();
            alert('이메일에는 @와 .이 모두 포함되어야 합니다.');
            return;
        }
        var agreePrivacy = document.getElementById('agreePrivacy');
        if (agreePrivacy && !agreePrivacy.checked) {
            e.preventDefault();
            alert('개인정보 처리방침에 동의해 주세요.');
            return;
        }
        var road = document.getElementById('sample4RoadAddress').value;
        var jibun = document.getElementById('sample4JibunAddress').value;
        var detail = document.getElementById('sample4DetailAddress').value;
        var extra = document.getElementById('sample4ExtraAddress').value;
        var merged = [road || jibun, detail, extra].filter(Boolean).join(' ');
        document.getElementById('userAddr').value = merged;
    });
</script>
<%@include file="../layout/footer.jsp"%>
</body>
</html>


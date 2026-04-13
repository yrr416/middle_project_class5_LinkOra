<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- 로그인 메인 화면: 일반 로그인, 소셜 로그인, 회원가입/계정찾기 진입점을 제공한다. --%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LinkOra</title>
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
        .top-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .logo-image {
            height: 48px;
            width: auto;
            display: block;
        }
        .mypage-btn {
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
        .top-right {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .content {
            padding: 24px;
        }
        .content-box {
            width: 100%;
            min-height: 420px;
            background: #ffffff;
            border: 1px solid #e6e8ec;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .login-card {
            width: 360px;
        }
        .login-card h1 {
            margin: 0 0 18px;
            font-size: 24px;
            text-align: center;
            color: #243140;
        }
        .form-group {
            margin-bottom: 14px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
            color: #333;
        }
        input {
            width: 100%;
            height: 42px;
            border: 1px solid #d9d9d9;
            border-radius: 8px;
            padding: 0 12px;
            font-size: 14px;
        }
        input:focus {
            outline: none;
            border-color: #162a4a;
        }
        .submit-btn {
            width: 100%;
            height: 44px;
            border: none;
            border-radius: 8px;
            background: #162a4a;
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 6px;
        }
        .signup-btn {
            width: calc(50% - 5px);
            height: 44px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-top: 10px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: #334155;
        }
        .partner-signup-btn {
            width: calc(50% - 5px);
            height: 44px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-top: 10px;
            border: 1px solid #c7d2fe;
            background: #eef2ff;
            color: #3730a3;
        }
        .signup-row {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .help-row {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            justify-content: center;
        }
        .forgot-btn {
            width: 120px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid #d1d5db;
            background: #f3f4f6;
            color: #4b5563;
        }
        .find-id-btn {
            width: 120px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid #d1d5db;
            background: #f3f4f6;
            color: #4b5563;
        }
        .divider {
            text-align: center;
            color: #94a3b8;
            margin: 16px 0;
            font-size: 13px;
        }
        .error-msg {
            margin: 0 0 12px;
            color: #dc2626;
            font-size: 13px;
            text-align: center;
        }
        .success-msg {
            margin: 0 0 12px;
            color: #16a34a;
            font-size: 13px;
            text-align: center;
        }
        .social-btn {
            width: 100%;
            height: 44px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .kakao-btn {
            background: #fee500;
            color: #191919;
            border: 1px solid #f4da00;
        }
        .naver-btn {
            background: #03c75a;
            color: #ffffff;
            border: 1px solid #03b353;
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
        }
    </style>
</head>
<body>
<%
    String signupParam = request.getParameter("signup");
    String errorParam = request.getParameter("error");
    String resetParam = request.getParameter("reset");
    String findIdParam = request.getParameter("findId");
%>
<%@include file="../../views/layout/header.jsp"%>
<main class="content">
    <section class="content-box">
        <div class="login-card">
            <h1>로그인</h1>

            <% if ("success".equals(signupParam)) { %>
            <p class="success-msg">회원가입이 완료되었습니다. 로그인해주세요.</p>
            <% } else if ("partnerSuccess".equals(signupParam)) { %>
            <p class="success-msg">사업자회원가입이 완료되었습니다. 로그인해주세요.</p>
            <% } %>
            <% if ("mailSent".equals(resetParam)) { %>
            <p class="success-msg">임시 비밀번호를 이메일로 발송했습니다. 메일함을 확인해주세요.</p>
            <% } %>
            <% if ("mailSent".equals(findIdParam)) { %>
            <p class="success-msg">아이디 안내 메일을 발송했습니다. 메일함을 확인해주세요.</p>
            <% } %>
            <% if (errorParam != null) { %>
            <p class="error-msg">
                <%
                    if ("naver_config".equals(errorParam)) {
                        out.print("네이버 로그인 설정(client-id)이 비어 있습니다.");
                    } else if ("naver_denied".equals(errorParam)) {
                        out.print("네이버 로그인 동의가 취소되었습니다.");
                    } else if ("naver_state".equals(errorParam)) {
                        out.print("네이버 로그인 상태값(state) 검증에 실패했습니다. 로그인 시작 URL/도메인(localhost)과 Redirect URI를 동일하게 맞춰주세요.");
                    } else if ("naver_no_code".equals(errorParam)) {
                        out.print("네이버 인가코드를 받지 못했습니다.");
                    } else if ("naver_token".equals(errorParam)) {
                        out.print("네이버 토큰 발급에 실패했습니다. client-id/client-secret/redirect-uri를 확인해주세요.");
                    } else if ("naver_profile".equals(errorParam)) {
                        out.print("네이버 사용자 정보 조회에 실패했습니다.");
                    } else if ("naver_fail".equals(errorParam)) {
                        out.print("네이버 로그인 처리 중 오류가 발생했습니다.");
                    } else if ("kakao_config".equals(errorParam)) {
                        out.print("카카오 로그인 설정(client-id)이 비어 있습니다.");
                    } else if ("kakao_denied".equals(errorParam)) {
                        out.print("카카오 로그인 동의가 취소되었습니다.");
                    } else if ("kakao_no_code".equals(errorParam)) {
                        out.print("카카오 인가코드를 받지 못했습니다.");
                    } else if ("kakao_token".equals(errorParam)) {
                        out.print("카카오 토큰 발급에 실패했습니다.");
                    } else if ("kakao_fail".equals(errorParam)) {
                        out.print("카카오 로그인 처리 중 오류가 발생했습니다.");
                    } else {
                        out.print("아이디 또는 비밀번호를 확인해주세요.");
                    }
                %>
            </p>
            <% } %>

            <%-- Spring Security 폼 로그인 처리 URL로 아이디/비밀번호를 전송한다. --%>
            <form method="post" action="/perform_login">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <input id="username" name="username" type="text" placeholder="아이디를 입력하세요" required>
                </div>
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input id="password" name="password" type="password" placeholder="비밀번호를 입력하세요" required>
                </div>
                <button class="submit-btn" type="submit">로그인</button>
                <div class="signup-row">
                    <a class="signup-btn" href="/signup">회원가입</a>
                    <a class="partner-signup-btn" href="/partner-signup">사업자회원가입</a>
                </div>
                <div class="help-row">
                    <a class="find-id-btn" href="/forgot-id">아이디 찾기</a>
                    <a class="forgot-btn" href="/forgot-password">비밀번호 찾기</a>
                </div>
            </form>
            <p class="divider">또는 소셜 계정으로 로그인</p>
            <a class="social-btn kakao-btn" href="/kakao/authorize">카카오로 로그인</a>
            <a class="social-btn naver-btn" href="/naver/authorize">네이버로 로그인</a>
        </div>
    </section>
</main>
<%-- 공통 푸터를 포함한다. --%>
<%@include file="../../views/layout/footer.jsp" %>
<%-- 헤더 우측 LOGIN 버튼 라벨/이동경로를 홈페이지로 덮어쓴다. --%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var root = '${pageContext.request.contextPath}';
    var btn = document.querySelector('.header-right .login-btn');
    if (!btn || btn.tagName !== 'BUTTON') return;
    if ((btn.textContent || '').trim() !== 'LOGIN') return;
    btn.textContent = '홈페이지';
    btn.onclick = function () { location.href = root + '/'; };
});
</script>
</body>
</html>


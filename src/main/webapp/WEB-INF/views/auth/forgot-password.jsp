<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 · LinkOra</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: #f4f6f8;
            font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
            color: #243140;
        }
        .wrap {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .card {
            width: 380px;
            background: #fff;
            border: 1px solid #e6e8ec;
            border-radius: 12px;
            padding: 24px;
        }
        h1 {
            margin: 0 0 10px;
            font-size: 22px;
            text-align: center;
        }
        .desc {
            margin: 0 0 16px;
            font-size: 13px;
            color: #64748b;
            text-align: center;
            line-height: 1.5;
        }
        .msg {
            margin: 0 0 12px;
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            color: #dc2626;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
            font-weight: 700;
        }
        input {
            width: 100%;
            height: 42px;
            border: 1px solid #d9d9d9;
            border-radius: 8px;
            padding: 0 12px;
            font-size: 14px;
        }
        .actions {
            margin-top: 14px;
            display: flex;
            gap: 8px;
        }
        .btn {
            flex: 1;
            height: 42px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #334155;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .btn-primary {
            border: none;
            background: #162a4a;
            color: #fff;
        }
    </style>
    <%@include file="../../views/layout/header.jsp"%>
<body>
<%
    String errorParam = request.getParameter("error");
%>
<main class="wrap">
    <section class="card">
        <h1>비밀번호 찾기</h1>
        <p class="desc">가입한 이메일을 입력하면 임시 비밀번호를 발송합니다.</p>
        <% if ("emailFormat".equals(errorParam)) { %>
        <p class="msg">이메일 형식을 확인해주세요.</p>
        <% } else if ("notFound".equals(errorParam)) { %>
        <p class="msg">해당 이메일로 가입된 계정을 찾을 수 없습니다.</p>
        <% } else if ("mailConfig".equals(errorParam)) { %>
        <p class="msg">메일 설정이 비어 있습니다. MAIL_USERNAME / MAIL_PASSWORD를 설정해주세요.</p>
        <% } else if ("mailProvider".equals(errorParam)) { %>
        <p class="msg">지원 도메인이 아닙니다. Gmail/Naver/Daum(Hanmail)/Nate/Outlook/iCloud 계정을 사용해주세요.</p>
        <% } else if ("mail".equals(errorParam)) { %>
        <p class="msg">메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.</p>
        <% } %>

        <form method="post" action="/forgot-password">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <label for="email">이메일</label>
            <input id="email" name="email" type="email" required placeholder="example@domain.com">
            <div class="actions">
                <a class="btn" href="/loginPage">로그인으로</a>
                <button class="btn btn-primary" type="submit">임시 비밀번호 발송</button>
            </div>
        </form>
    </section>
</main>
<%@include file="../../views/layout/footer.jsp" %>
</body>
</html>

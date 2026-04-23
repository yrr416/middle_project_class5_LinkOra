<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 회원가입 동의용 개인정보 처리방침: settings.privacy_content를 렌더링한다. --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인정보 처리방침</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #f4f6f8; font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif; color: #1e293b; line-height: 1.6; }
        .wrap { max-width: 720px; margin: 0 auto; padding: 24px 16px 48px; }
        h1 { font-size: 22px; margin: 0 0 16px; color: #0f172a; }
        h2 { font-size: 15px; margin: 20px 0 8px; color: #334155; }
        p, li { font-size: 14px; color: #475569; }
        ul { margin: 0 0 12px; padding-left: 20px; }
        .actions { margin-top: 28px; display: flex; flex-wrap: wrap; gap: 10px; }
        .actions a {
            display: inline-flex; align-items: center; justify-content: center;
            height: 38px; padding: 0 16px; border-radius: 8px; font-size: 14px; font-weight: 600;
            text-decoration: none; border: 1px solid #cbd5e1; background: #fff; color: #334155;
        }
        .actions a.primary { background: #162a4a; color: #fff; border-color: #162a4a; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>개인정보 처리방침</h1>
    <div>
        <c:out value="${privacyContent}" escapeXml="false"/>
    </div>

    <div class="actions">
        <a class="primary" href="javascript:window.close();">창 닫기</a>
    </div>
</div>
</body>
</html>

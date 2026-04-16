<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드</title>
    <style>
        body {
            margin: 0;
            background: #f4f6f8;
            font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
        }
        .wrap {
            max-width: 920px;
            margin: 40px auto;
            background: #fff;
            border: 1px solid #e6e8ec;
            border-radius: 12px;
            padding: 28px;
        }
        h1 {
            margin: 0 0 10px;
            color: #243140;
        }
        p {
            color: #475569;
            margin-bottom: 20px;
        }
        .actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
        }
        .actions form {
            margin: 0;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 18px;
            border-radius: 999px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid transparent;
            cursor: pointer;
            transition: background-color .15s ease, color .15s ease, box-shadow .15s ease;
        }
        .btn-logout {
            background: #ef4444;
            color: #fff;
            border-color: #ef4444;
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.35);
        }
        .btn-logout:hover {
            background: #dc2626;
        }
        .btn-back {
            background: #ffffff;
            color: #111827;
            border-color: #d1d5db;
        }
        .btn-back:hover {
            background: #f3f4f6;
        }
    </style>
</head>
<body>
<main class="wrap">
    <h1>로그인 성공</h1>
    <p>카카오 또는 네이버 인증을 통해 접속되었습니다.</p>
    <div class="actions">
        <a class="btn btn-logout" href="${pageContext.request.contextPath}/logoutNow">로그아웃</a>
        <a class="btn btn-back" href="${pageContext.request.contextPath}/loginPage">로그인 페이지로 돌아가기</a>
    </div>
</main>
</body>
</html>


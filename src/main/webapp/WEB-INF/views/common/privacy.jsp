<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- 회원가입 동의용 개인정보 처리방침 안내(교육·데모 목적의 요약 문구). --%>
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
    <p>본 방침은 서비스 회원가입 시 수집·이용되는 개인정보에 대한 안내를 위해 제공됩니다. 실제 서비스 운영 시에는 법령에 맞게 보완·게시해야 합니다.</p>

    <h2>수집 항목</h2>
    <ul>
        <li>회원: 아이디, 비밀번호, 이름, 이메일, 전화번호, 주소, 선택 시 프로필 이미지</li>
        <li>사업자 회원: 위 정보 및 사업자등록번호 등 사업자 식별 정보</li>
    </ul>

    <h2>이용 목적</h2>
    <ul>
        <li>회원 식별, 서비스 제공·이용 기록, 본인 확인, 고객 문의 대응</li>
    </ul>

    <h2>보관 및 파기</h2>
    <p>관련 법령 또는 내부 방침에 따라 보관이 필요한 경우를 제외하고, 이용 목적 달성 후 지체 없이 파기합니다.</p>

    <h2>문의</h2>
    <p>개인정보 관련 문의는 서비스 운영자에게 연락해 주세요.</p>

    <div class="actions">
        <a class="primary" href="javascript:window.close();">창 닫기</a>
    </div>
</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>1:1 문의하기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <style>
        :root {
            --point-main: #2F4F4F;
            --point-hover: #1e3333;
            --text-main: #2a2a2a;
            --text-muted: #757575;
            --bg-light: #f8f9fa;
            --border: #e4e7ec;
            --white: #ffffff;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Pretendard', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-main); line-height: 1.6; }
        
        .container { max-width: 800px; margin: 60px auto; padding: 40px; background: var(--white); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid var(--border); }
        
        .header { margin-bottom: 30px; text-align: center; }
        .header h1 { font-size: 28px; font-weight: 700; color: var(--point-main); margin-bottom: 10px; }
        .header p { color: var(--text-muted); font-size: 15px; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: var(--text-main); }
        
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid var(--border); border-radius: 8px; outline: none; font-size: 15px; transition: border-color 0.2s; background: #fafafa; }
        .form-control:focus { border-color: var(--point-main); background: white; }
        
        textarea.form-control { height: 200px; resize: none; }
        
        .btn-submit { width: 100%; padding: 15px; background: var(--point-main); color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: var(--point-hover); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(47, 79, 79, 0.2); }
        
        .btn-back { display: block; text-align: center; margin-top: 20px; color: var(--text-muted); font-size: 14px; text-decoration: none; transition: color 0.2s; }
        .btn-back:hover { color: var(--point-main); text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>1:1 문의하기</h1>
            <p>궁금하신 점이나 불편한 사항을 남겨주시면 정성껏 답변해 드리겠습니다.</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/inquiry/submit" method="post">
            <div class="form-group">
                <label class="form-label">문의 카테고리</label>
                <select name="inqCategory" class="form-control" required>
                    <option value="">카테고리를 선택해주세요</option>
                    <option value="공간 예약">공간 예약 문의</option>
                    <option value="결제 및 환불">결제 및 환불 문의</option>
                    <option value="시설 이용">시설 이용 문의</option>
                    <option value="회원정보/계정">회원정보 / 계정 문의</option>
                    <option value="이용방법">이용방법 안내</option>
                    <option value="제휴 및 광고">제휴 및 광고 문의</option>
                    <option value="장애/오류">장애 / 오류 신고</option>
                    <option value="건의 사항">건의 사항</option>
                    <option value="기타">기타</option>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label">문의 제목</label>
                <input type="text" name="inqTitle" class="form-control" placeholder="제목을 입력해주세요" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">문의 내용</label>
                <textarea name="inqContent" class="form-control" placeholder="문의하실 내용을 상세히 적어주세요. 관리자가 확인 후 답변을 드립니다." required></textarea>
            </div>
            
            <button type="submit" class="btn-submit">문의 등록하기</button>
        </form>
        
        <a href="${pageContext.request.contextPath}/" class="btn-back">홈으로 돌아가기</a>
    </div>
</body>
</html>

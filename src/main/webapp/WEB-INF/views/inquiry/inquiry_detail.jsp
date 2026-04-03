<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의 상세 보기</title>
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
            --ans-bg: #f0f4f4;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Pretendard', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-main); line-height: 1.6; }
        
        .container { max-width: 900px; margin: 60px auto; padding: 40px; background: var(--white); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid var(--border); }
        
        .header { margin-bottom: 40px; padding-bottom: 20px; border-bottom: 2px solid var(--border); }
        .category-tag { display: inline-block; padding: 4px 12px; background: var(--ans-bg); color: var(--point-main); border-radius: 20px; font-size: 13px; font-weight: 700; margin-bottom: 12px; }
        .title { font-size: 28px; font-weight: 700; color: var(--text-main); margin-bottom: 10px; }
        .meta-info { display: flex; gap: 20px; color: var(--text-muted); font-size: 14px; }
        
        .section-title { font-size: 14px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
        .section-title::before { content: ''; width: 4px; height: 14px; background: var(--point-main); border-radius: 2px; display: inline-block; }
        
        .content-box { padding: 30px; background: #fafafa; border-radius: 10px; border: 1px solid var(--border); min-height: 150px; white-space: pre-wrap; font-size: 16px; margin-bottom: 40px; }
        
        .answer-box { padding: 35px; background: var(--ans-bg); border-radius: 12px; border: 1px solid rgba(47, 79, 79, 0.1); position: relative; }
        .answer-box h3 { font-size: 18px; color: var(--point-main); margin-bottom: 15px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .answer-box p { font-size: 16px; color: var(--text-main); }
        .ans-meta { margin-top: 20px; text-align: right; font-size: 13px; color: var(--text-muted); }
        
        .waiting-box { padding: 40px; text-align: center; background: #fffcf5; border: 1px dashed #ffd54f; border-radius: 12px; }
        .waiting-box i { font-size: 30px; color: #ffca28; margin-bottom: 15px; display: block; }
        .waiting-box p { color: #8d6e63; font-weight: 500; }

        .btn-wrap { margin-top: 40px; display: flex; justify-content: center; gap: 15px; }
        .btn { padding: 12px 30px; border-radius: 8px; font-size: 15px; font-weight: 600; text-decoration: none; transition: 0.2s; cursor: pointer; border: 1px solid var(--border); }
        .btn-list { background: var(--white); color: var(--text-main); }
        .btn-list:hover { background: var(--bg-light); border-color: #ccd0d5; }
        .btn-home { background: var(--point-main); color: white; border-color: var(--point-main); }
        .btn-home:hover { background: var(--point-hover); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <span class="category-tag">${inquiry.category}</span>
            <h1 class="title">${inquiry.title}</h1>
            <div class="meta-info">
                <span>작성일: ${inquiry.created}</span>
                <span>상태: <strong>${inquiry.status}</strong></span>
            </div>
        </div>
        
        <div class="section-title">문의 내용</div>
        <div class="content-box">${inquiry.content}</div>
        
        <div class="section-title">관리자 답변</div>
        <c:choose>
            <c:when test="${inquiry.status == '답변완료'}">
                <div class="answer-box">
                    <h3><i class="fa-solid fa-comment-dots"></i> 관리자 답변입니다.</h3>
                    <p>${inquiry.answer}</p>
                    <div class="ans-meta">
                        답변일: ${inquiry.answered}
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="waiting-box">
                    <p>정성껏 답변을 준비 중입니다. 조금만 기다려 주세요!</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="btn-wrap">
            <a href="${pageContext.request.contextPath}/inquiry/mylist" class="btn btn-list">목록으로</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">홈으로</a>
        </div>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>나의 문의 내역</title>
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
            --status-waiting: #ff9800;
            --status-complete: #2F4F4F;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Pretendard', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-main); }
        
        .container { max-width: 1000px; margin: 60px auto; padding: 40px; background: var(--white); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid var(--border); }
        
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; padding-bottom: 20px; border-bottom: 1px solid var(--border); }
        .header h1 { font-size: 26px; font-weight: 700; color: var(--point-main); }
        
        .btn-new { padding: 10px 22px; background: var(--point-main); color: white; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.2s; }
        .btn-new:hover { background: var(--point-hover); }
        
        .inquiry-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .inquiry-table th { padding: 18px 15px; border-bottom: 1px solid var(--border); font-size: 13px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; background: #fafafa; }
        .inquiry-table td { padding: 20px 15px; border-bottom: 1px solid var(--border); font-size: 15px; text-align: center; }
        
        .inquiry-link { text-decoration: none; color: var(--text-main); font-weight: 500; transition: color 0.2s; }
        .inquiry-link:hover { color: var(--point-main); text-decoration: underline; }
        
        .status-badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; letter-spacing: -0.5px; }
        .status-waiting { background: #fff8e1; color: var(--status-waiting); border: 1px solid rgba(255, 152, 0, 0.2); }
        .status-complete { background: #e0f2f1; color: var(--status-complete); border: 1px solid rgba(47, 79, 79, 0.2); }
        
        .empty-msg { text-align: center; padding: 100px 0; color: var(--text-muted); font-size: 16px; width: 100%; }
        
        .navigation { margin-top: 30px; text-align: center; }
        .navigation a { color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color 0.2s; }
        .navigation a:hover { color: var(--point-main); text-decoration: underline; }
        .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 40px; }
        .page-link { display: flex; align-items: center; justify-content: center; width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--border); background: var(--white); color: var(--text-muted); text-decoration: none; font-size: 14px; font-weight: 600; transition: all 0.2s; }
        .page-link:hover { border-color: var(--point-main); color: var(--point-main); }
        .page-link.active { background: var(--point-main); color: var(--white); border-color: var(--point-main); }
        .page-link.prev, .page-link.next { width: auto; padding: 0 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>나의 문의 내역</h1>
            <a href="${pageContext.request.contextPath}/inquiry" class="btn-new">새로운 문의 남기기</a>
        </div>
        
        <c:choose>
            <c:when test="${not empty inquiryList}">
                <table class="inquiry-table">
                    <thead>
                        <tr>
                            <th style="width: 150px;">날짜</th>
                            <th style="width: 150px;">카테고리</th>
                            <th>제목</th>
                            <th style="width: 150px;">답변상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="inquiry" items="${inquiryList}">
                            <tr>
                                <td style="font-size: 13px; color: var(--text-muted);">
                                    ${inquiry.icreated}
                                </td>
                                <td style="font-size: 14px; font-weight: 600; color: var(--point-main);">${inquiry.icategory}</td>
                                <td style="text-align: left;">
                                    <a href="${pageContext.request.contextPath}/inquiry/detail/${inquiry.iidx}" class="inquiry-link">${inquiry.ititle}</a>
                                </td>
                                <td>
                                    <span class="status-badge ${inquiry.istatus == '답변완료' ? 'status-complete' : 'status-waiting'}">
                                        ${inquiry.istatus}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <%-- Pagination Bar --%>
                <c:if test="${paging.totalPage > 1}">
                    <div class="pagination">
                        <%-- Previous Block --%>
                        <c:if test="${paging.beginBlock > 1}">
                            <a href="?page=${paging.beginBlock - 1}" class="page-link prev">이전</a>
                        </c:if>
                        
                        <%-- Page Numbers --%>
                        <c:forEach var="p" begin="${paging.beginBlock}" end="${paging.endBlock}">
                            <a href="?page=${p}" class="page-link ${p == paging.nowPage ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        
                        <%-- Next Block --%>
                        <c:if test="${paging.endBlock < paging.totalPage}">
                            <a href="?page=${paging.endBlock + 1}" class="page-link next">다음</a>
                        </c:if>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">
                    <p>등록된 문의가 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>

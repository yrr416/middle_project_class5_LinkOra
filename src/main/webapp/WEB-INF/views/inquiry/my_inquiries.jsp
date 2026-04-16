<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- [Link Ora] 표준 레이아웃 적용 --%>
<%@ include file="../layout/header.jsp" %>

<style>
    /* 문의 목록 전용 강화 스타일 */
    .inquiry-list-wrap { padding: 60px 0; background: #f8fafb; min-height: calc(100vh - 400px); }
    .inquiry-list-card { 
        max-width: 1000px; 
        margin: 0 auto; 
        padding: 40px; 
        background: #ffffff; 
        border-radius: 16px; 
        box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
        border: 1px solid #eef0f2; 
    }
    
    .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
    .list-header h1 { font-size: 28px; font-weight: 800; color: #2F4F4F; }
    
    .btn-create-new { padding: 12px 24px; background: #2F4F4F; color: white; border-radius: 10px; text-decoration: none; font-size: 14px; font-weight: 700; transition: all 0.2s; box-shadow: 0 4px 10px rgba(47, 79, 79, 0.2); }
    .btn-create-new:hover { background: #1e3333; transform: translateY(-2px); }
    
    .inq-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .inq-table th { padding: 18px 15px; border-bottom: 2px solid #f0f0f0; font-size: 14px; color: #888; font-weight: 700; text-align: center; background: #fafafa; }
    .inq-table td { padding: 22px 15px; border-bottom: 1px solid #f5f5f5; font-size: 15px; text-align: center; color: #444; }
    
    .inq-title-link { text-decoration: none; color: #333; font-weight: 600; transition: color 0.2s; }
    .inq-title-link:hover { color: #2F4F4F; text-decoration: underline; }
    
    .badge-status { display: inline-block; padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 800; }
    .bg-waiting { background: #fff8e1; color: #ff9800; border: 1px solid rgba(255, 152, 0, 0.2); }
    .bg-complete { background: #e0f2f1; color: #2F4F4F; border: 1px solid rgba(47, 79, 79, 0.2); }
    
    .no-data { text-align: center; padding: 100px 0; color: #999; font-size: 16px; }
    
    /* 페이징 */
    .pagination-inq { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 50px; }
    .pg-item { display: flex; align-items: center; justify-content: center; min-width: 40px; height: 40px; border-radius: 10px; border: 1px solid #e0e0e0; background: white; color: #666; text-decoration: none; font-size: 14px; font-weight: 700; transition: all 0.2s; }
    .pg-item:hover { border-color: #2F4F4F; color: #2F4F4F; background: #f0f8f8; }
    .pg-item.active { background: #2F4F4F; color: white; border-color: #2F4F4F; }
    .pg-item.edge { padding: 0 15px; }

    .inq-footer-nav { margin-top: 30px; text-align: center; }
    .inq-footer-nav a { color: #888; text-decoration: none; font-size: 14px; font-weight: 600; }
    .inq-footer-nav a:hover { color: #2F4F4F; text-decoration: underline; }
</style>

<main class="inquiry-list-wrap">
    <div class="container">
        <div class="inquiry-list-card">
            <div class="list-header">
                <h1>나의 문의 내역</h1>
                <a href="${pageContext.request.contextPath}/inquiry" class="btn-create-new">
                    <i class="fa-solid fa-pen-to-square"></i> 새로운 문의 남기기
                </a>
            </div>
            
            <c:choose>
                <c:when test="${not empty inquiryList}">
                    <table class="inq-table">
                        <thead>
                            <tr>
                                <th style="width: 140px;">등록일</th>
                                <th style="width: 150px;">카테고리</th>
                                <th>제목</th>
                                <th style="width: 130px;">상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inquiry" items="${inquiryList}">
                                <tr>
                                    <td style="font-size: 13px; color: #999;">${inquiry.inqCreated}</td>
                                    <td style="font-weight: 700; color: #2F4F4F;">${inquiry.inqCategory}</td>
                                    <td style="text-align: left; padding-left: 30px;">
                                        <a href="${pageContext.request.contextPath}/inquiry/detail/${inquiry.inqIdx}" class="inq-title-link">
                                            ${inquiry.inqTitle}
                                        </a>
                                    </td>
                                    <td>
                                        <span class="badge-status ${inquiry.inqStatus == '답변완료' ? 'bg-complete' : 'bg-waiting'}">
                                            ${inquiry.inqStatus}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <%-- 페이징 영역 --%>
                    <c:if test="${paging.totalPage > 1}">
                        <div class="pagination-inq">
                            <%-- 이전 블록 --%>
                            <c:if test="${paging.beginBlock > 1}">
                                <a href="?page=${paging.beginBlock - 1}" class="pg-item edge">이전</a>
                            </c:if>
                            
                            <%-- 페이지 번호 --%>
                            <c:forEach var="p" begin="${paging.beginBlock}" end="${paging.endBlock}">
                                <a href="?page=${p}" class="pg-item ${p == paging.nowPage ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            
                            <%-- 다음 블록 --%>
                            <c:if test="${paging.endBlock < paging.totalPage}">
                                <a href="?page=${paging.endBlock + 1}" class="pg-item edge">다음</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fa-solid fa-inbox" style="font-size: 40px; display: block; margin-bottom: 20px; opacity: 0.3;"></i>
                        <p>등록된 문의가 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="inq-footer-nav">
                <a href="${pageContext.request.contextPath}/">
                    <i class="fa-solid fa-house"></i> 홈으로 돌아가기
                </a>
            </div>
        </div>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- [Link Ora] 표준 레이아웃 적용 --%>
<%@ include file="../layout/header.jsp" %>

<style>
    /* 문의 상세 전용 강화 스타일 */
    .inquiry-detail-wrap { padding: 60px 0; background: #f8fafb; min-height: calc(100vh - 400px); }
    .inquiry-detail-card { 
        max-width: 900px; 
        margin: 0 auto; 
        padding: 50px; 
        background: #ffffff; 
        border-radius: 16px; 
        box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
        border: 1px solid #eef0f2; 
    }
    
    .detail-header { margin-bottom: 40px; padding-bottom: 25px; border-bottom: 2px solid #f0f0f0; }
    .cat-tag { display: inline-block; padding: 5px 14px; background: #f0f4f4; color: #2F4F4F; border-radius: 20px; font-size: 13px; font-weight: 800; margin-bottom: 15px; }
    .detail-title { font-size: 32px; font-weight: 800; color: #222; margin-bottom: 12px; line-height: 1.3; }
    .detail-meta { display: flex; gap: 25px; color: #888; font-size: 14px; font-weight: 500; }
    .detail-meta strong { color: #2F4F4F; font-weight: 700; }
    
    .sec-title { font-size: 15px; font-weight: 800; color: #888; text-transform: uppercase; margin-bottom: 18px; display: flex; align-items: center; gap: 10px; }
    .sec-title::before { content: ''; width: 4px; height: 16px; background: #2F4F4F; border-radius: 2px; }
    
    .text-content-box { padding: 35px; background: #fafafa; border-radius: 12px; border: 1px solid #f0f0f0; min-height: 180px; white-space: pre-wrap; font-size: 16px; color: #444; line-height: 1.8; margin-bottom: 50px; }
    
    .ans-container { padding: 40px; background: #f0f8f8; border-radius: 16px; border: 1px solid rgba(47, 79, 79, 0.08); position: relative; }
    .ans-container h3 { font-size: 19px; color: #2F4F4F; margin-bottom: 20px; font-weight: 800; display: flex; align-items: center; gap: 12px; }
    .ans-container p { font-size: 16px; color: #444; line-height: 1.8; }
    .ans-date { margin-top: 25px; text-align: right; font-size: 13px; color: #999; font-weight: 500; }
    
    .wait-container { padding: 50px; text-align: center; background: #fffcf5; border: 1px dashed #ffd54f; border-radius: 16px; }
    .wait-container p { color: #8d6e63; font-weight: 600; font-size: 16px; }

    .detail-btn-row { margin-top: 50px; display: flex; justify-content: center; gap: 15px; }
    .inq-btn { padding: 14px 35px; border-radius: 10px; font-size: 15px; font-weight: 700; text-decoration: none; transition: 0.2s; cursor: pointer; border: 1px solid #ddd; }
    
    .btn-gray-outline { background: white; color: #666; }
    .btn-gray-outline:hover { background: #f8f9fa; border-color: #bbb; }
    
    .btn-point { background: #2F4F4F; color: white; border-color: #2F4F4F; }
    .btn-point:hover { background: #1e3333; transform: translateY(-2px); }
    
    .btn-slate { background: #607d8b; color: white; border-color: #607d8b; }
    .btn-slate:hover { background: #455a64; transform: translateY(-2px); }
    
    .btn-warm { background: #ff5252; color: white; border-color: #ff5252; }
    .btn-warm:hover { background: #d32f2f; transform: translateY(-2px); }
    
    .btn-lock { background: #eee; color: #aaa; cursor: not-allowed; border-color: #eee; }
</style>

<script>
    function confirmDelete(inqIdx) {
        if (confirm("정말로 이 문의를 삭제하시겠습니까?")) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/inquiry/delete/' + inqIdx;
            
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = '${_csrf.parameterName}';
            csrfInput.value = '${_csrf.token}';
            form.appendChild(csrfInput);
            
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

<main class="inquiry-detail-wrap">
    <div class="container">
        <div class="inquiry-detail-card">
            <div class="detail-header">
                <span class="cat-tag">${inquiry.inqCategory}</span>
                <h1 class="detail-title">${inquiry.inqTitle}</h1>
                <div class="detail-meta">
                    <span><i class="fa-regular fa-calendar" style="margin-right: 6px;"></i> 작성일: ${inquiry.inqCreated}</span>
                    <span>상태: <strong>${inquiry.inqStatus}</strong></span>
                </div>
            </div>
            
            <div class="sec-title">문의 내용</div>
            <div class="text-content-box">${inquiry.inqContent}</div>
            
            <div class="sec-title">관리자 답변</div>
            <c:choose>
                <c:when test="${inquiry.inqStatus == '답변 완료' || inquiry.inqStatus == '답변완료'}">
                    <div class="ans-container">
                        <h3><i class="fa-solid fa-square-check"></i> 공식 답변입니다.</h3>
                        <p>${inquiry.inqAnswer}</p>
                        <div class="ans-date">
                            답변 등록일: ${inquiry.inqAnswered}
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="wait-container">
                        <i class="fa-solid fa-hourglass-half" style="font-size: 32px; color: #ffca28; margin-bottom: 20px; display: block;"></i>
                        <p>정성껏 답변을 준비 중입니다. 조금만 기다려 주세요!</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="detail-btn-row">
                <a href="${pageContext.request.contextPath}/inquiry/mylist" class="inq-btn btn-gray-outline">목록으로</a>
                
                <%-- 작성자 본인 제어 --%>
                <c:if test="${not empty sessionScope.userIdx && sessionScope.userIdx == inquiry.userIdx}">
                    <c:choose>
                        <c:when test="${inquiry.inqStatus == '답변 완료' || inquiry.inqStatus == '답변완료'}">
                            <span class="inq-btn btn-lock" title="답변이 완료된 원본 글은 수정할 수 없습니다.">수정불가</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/inquiry/edit/${inquiry.inqIdx}" class="inq-btn btn-slate">수정하기</a>
                        </c:otherwise>
                    </c:choose>
                    <button type="button" onclick="confirmDelete(${inquiry.inqIdx})" class="inq-btn btn-warm">삭제하기</button>
                </c:if>
                
                <a href="${pageContext.request.contextPath}/" class="inq-btn btn-point">홈으로</a>
            </div>
        </div>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>

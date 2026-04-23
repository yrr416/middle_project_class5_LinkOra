<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [Link Ora] 표준 레이아웃 적용 --%>
<%@ include file="../layout/header.jsp" %>

<style>
    /* 문의 폼 전용 강화 스타일 (메인 테마에 맞춤) */
    .inquiry-wrap { padding: 60px 0; background: #f8fafb; min-height: calc(100vh - 400px); }
    .inquiry-card { 
        max-width: 800px; 
        margin: 0 auto; 
        padding: 50px; 
        background: #ffffff; 
        border-radius: 16px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.08); 
        border: 1px solid #eef0f2; 
    }
    
    .inquiry-header { margin-bottom: 40px; text-align: center; }
    .inquiry-header h1 { font-size: 32px; font-weight: 800; color: #2F4F4F; margin-bottom: 12px; }
    .inquiry-header p { color: #666; font-size: 16px; }
    
    .inq-group { margin-bottom: 25px; }
    .inq-label { display: block; font-size: 15px; font-weight: 700; margin-bottom: 10px; color: #333; }
    
    .inq-control { 
        width: 100%; 
        padding: 14px 18px; 
        border: 1px solid #ddd; 
        border-radius: 10px; 
        outline: none; 
        font-size: 15px; 
        transition: all 0.2s; 
        background: #fdfdfd; 
    }
    .inq-control:focus { border-color: #2F4F4F; background: white; box-shadow: 0 0 0 3px rgba(47, 79, 79, 0.1); }
    
    textarea.inq-control { height: 220px; resize: none; line-height: 1.6; }
    
    .btn-submit-inq { 
        width: 100%; 
        padding: 18px; 
        background: #2F4F4F; 
        color: white; 
        border: none; 
        border-radius: 10px; 
        font-size: 17px; 
        font-weight: 700; 
        cursor: pointer; 
        transition: all 0.3s; 
        margin-top: 15px; 
        box-shadow: 0 4px 12px rgba(47, 79, 79, 0.2);
    }
    .btn-submit-inq:hover { background: #1e3333; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(47, 79, 79, 0.3); }
    
    .inq-back-link { display: inline-block; margin-top: 25px; color: #888; font-size: 14px; text-decoration: none; font-weight: 600; transition: 0.2s; }
    .inq-back-link:hover { color: #2F4F4F; }
    .action-row { text-align: center; }
</style>

<main class="inquiry-wrap">
    <div class="container">
        <div class="inquiry-card">
            <div class="inquiry-header">
                <h1>1:1 문의하기</h1>
                <p>궁금하신 점이나 불편한 사항을 남겨주시면 정성껏 답변해 드리겠습니다.</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/inquiry/submit?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
                
                <div class="inq-group">
                    <label class="inq-label">문의 카테고리</label>
                    <select name="inqCategory" class="inq-control" required>
                        <option value="">카테고리를 선택해주세요</option>
                        <option value="공간 예약">공간 예약 문의</option>
                        <option value="결제 및 환불">결제 및 환불 문의</option>
                        <option value="시설 이용">시설 이용 문의</option>
                        <option value="회원정보/계정">회원정보 / 계정 문의</option>
                        <option value="이용방법">이용방법 안내</option>
                        <option value="제휴 및 광고">제휴 및 광고 문의</option>
                        <option value="장애/오류">장애 / 오류 신고</option>
                        <option value="건의 사항">건의 사항</option>
                        <option value="불편 사항">불편 사항</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                
                <div class="inq-group">
                    <label class="inq-label">문의 제목</label>
                    <input type="text" name="inqTitle" class="inq-control" placeholder="문의 내용을 요약하는 제목을 입력해주세요" required>
                </div>
                
                <div class="inq-group">
                    <label class="inq-label">문의 내용</label>
                    <textarea name="inqContent" class="inq-control" placeholder="문의하실 내용을 상세히 적어주세요. 관리자가 확인 후 영업일 기준 1~2일 내에 답변을 드립니다." required></textarea>
                </div>

                <div class="inq-group">
                    <label class="inq-label">파일 첨부 (선택)</label>
                    <input type="file" name="inqFile" class="inq-control">
                    <p style="font-size: 12px; color: #888; margin-top: 5px;">* 이미지 및 일반 파일을 첨부하실 수 있습니다.</p>
                </div>
                
                <button type="submit" class="btn-submit-inq">문의 등록하기</button>
                
                <div class="action-row">
                    <a href="${pageContext.request.contextPath}/inquiry/mylist" class="inq-back-link">
                        <i class="fa-solid fa-arrow-left"></i> 문의 목록으로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
(function() {
    const params = new URLSearchParams(window.location.search);
    const branch = params.get('reportBranch');
    if (!branch) return;
    // 카테고리 "불편 사항" 선택
    const sel = document.querySelector('select[name="inqCategory"]');
    if (sel) sel.value = '불편 사항';
    // 제목 자동 입력
    const titleInput = document.querySelector('input[name="inqTitle"]');
    if (titleInput) titleInput.value = '[신고] ' + branch;
    // 내용 placeholder 변경
    const contentArea = document.querySelector('textarea[name="inqContent"]');
    if (contentArea) contentArea.placeholder = branch + ' 지점에 대한 불편사항이나 문제 내용을 상세히 적어주세요.';
})();
</script>

<%@ include file="../layout/footer.jsp" %>


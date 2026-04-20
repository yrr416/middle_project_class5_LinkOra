<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [Link Ora] 표준 레이아웃 적용 --%>
<%@ include file="../layout/header.jsp" %>

<style>
    /* 문의 수정 전용 강화 스타일 (작성 폼과 대칭) */
    .inquiry-edit-wrap { padding: 60px 0; background: #f8fafb; min-height: calc(100vh - 400px); }
    .inquiry-edit-card { 
        max-width: 800px; 
        margin: 0 auto; 
        padding: 50px; 
        background: #ffffff; 
        border-radius: 16px; 
        box-shadow: 0 15px 35px rgba(0,0,0,0.08); 
        border: 1px solid #eef0f2; 
    }
    
    .edit-header { margin-bottom: 40px; text-align: center; }
    .edit-header h1 { font-size: 32px; font-weight: 800; color: #2F4F4F; margin-bottom: 12px; }
    .edit-header p { color: #888; font-size: 15px; }
    
    .edit-group { margin-bottom: 25px; }
    .edit-label { display: block; font-size: 15px; font-weight: 700; margin-bottom: 10px; color: #333; }
    
    .edit-control { 
        width: 100%; 
        padding: 14px 18px; 
        border: 1px solid #ddd; 
        border-radius: 10px; 
        outline: none; 
        font-size: 15px; 
        transition: all 0.2s; 
        background: #fdfdfd; 
    }
    .edit-control:focus { border-color: #2F4F4F; background: white; box-shadow: 0 0 0 3px rgba(47, 79, 79, 0.1); }
    
    textarea.edit-control { height: 220px; resize: none; line-height: 1.6; }
    
    .btn-edit-submit { 
        width: 100%; 
        padding: 18px; 
        background: #607d8b; 
        color: white; 
        border: none; 
        border-radius: 10px; 
        font-size: 17px; 
        font-weight: 700; 
        cursor: pointer; 
        transition: all 0.3s; 
        margin-top: 15px; 
        box-shadow: 0 4px 12px rgba(96, 125, 139, 0.2);
    }
    .btn-edit-submit:hover { background: #455a64; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(96, 125, 139, 0.3); }
    
    .edit-back-link { display: inline-block; margin-top: 25px; color: #888; font-size: 14px; text-decoration: none; font-weight: 600; transition: 0.2s; }
    .edit-back-link:hover { color: #2F4F4F; }
    .edit-action-row { text-align: center; }
</style>

<main class="inquiry-edit-wrap">
    <div class="container">
        <div class="inquiry-edit-card">
            <div class="edit-header">
                <h1>문의 수정하기</h1>
                <p>작성하신 내용을 수정하실 수 있습니다. (답변이 달린 후에는 수정이 불가능합니다.)</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/inquiry/update?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="inqIdx" value="${inquiry.inqIdx}">
                
                <div class="edit-group">
                    <label class="edit-label">문의 카테고리</label>
                    <select name="inqCategory" class="edit-control" required>
                        <option value="공간 예약" ${inquiry.inqCategory == '공간 예약' ? 'selected' : ''}>공간 예약 문의</option>
                        <option value="결제 및 환불" ${inquiry.inqCategory == '결제 및 환불' ? 'selected' : ''}>결제 및 환불 문의</option>
                        <option value="시설 이용" ${inquiry.inqCategory == '시설 이용' ? 'selected' : ''}>시설 이용 문의</option>
                        <option value="회원정보/계정" ${inquiry.inqCategory == '회원정보/계정' ? 'selected' : ''}>회원정보 / 계정 문의</option>
                        <option value="이용방법" ${inquiry.inqCategory == '이용방법' ? 'selected' : ''}>이용방법 안내</option>
                        <option value="제휴 및 광고" ${inquiry.inqCategory == '제휴 및 광고' ? 'selected' : ''}>제휴 및 광고 문의</option>
                        <option value="장애/오류" ${inquiry.inqCategory == '장애/오류' ? 'selected' : ''}>장애 / 오류 신고</option>
                        <option value="건의 사항" ${inquiry.inqCategory == '건의 사항' ? 'selected' : ''}>건의 사항</option>
                        <option value="기타" ${inquiry.inqCategory == '기타' ? 'selected' : ''}>기타</option>
                    </select>
                </div>
                
                <div class="edit-group">
                    <label class="edit-label">문의 제목</label>
                    <input type="text" name="inqTitle" class="edit-control" value="${inquiry.inqTitle}" required>
                </div>
                
                <div class="edit-group">
                    <label class="edit-label">문의 내용</label>
                    <textarea name="inqContent" class="edit-control" required>${inquiry.inqContent}</textarea>
                </div>

                <div class="edit-group">
                    <label class="edit-label">첨부파일 관리</label>
                    <c:if test="${not empty inquiry.inqFileUrl}">
                        <div style="margin-bottom: 10px; font-size: 14px; color: #555;">
                            현재 파일: <a href="${pageContext.request.contextPath}${inquiry.inqFileUrl}" target="_blank" style="color: #2F4F4F; font-weight: bold;">[미리보기]</a>
                            <label style="margin-left: 15px; font-size: 13px; cursor: pointer;">
                                <input type="checkbox" name="removeFile" value="true"> 기존 파일 삭제
                            </label>
                        </div>
                    </c:if>
                    <input type="file" name="inqFile" class="edit-control">
                    <p style="font-size: 12px; color: #888; margin-top: 5px;">* 새 파일을 선택하면 기존 파일은 대체됩니다.</p>
                </div>
                
                <button type="submit" class="btn-edit-submit">수정 완료하기</button>
                
                <div class="edit-action-row">
                    <a href="${pageContext.request.contextPath}/inquiry/detail/${inquiry.inqIdx}" class="edit-back-link">
                        <i class="fa-solid fa-arrow-left"></i> 상세 정보로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>

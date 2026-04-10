<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="main-footer">
    <div class="container">
        <p>&copy; 2026 Link Ora. All rights reserved. | Premium Workspace Network</p>
    </div>
</footer>

<%-- [복구] 챗봇 플로팅 버튼: HTML 원본 디자인과 동일한 구조를 유지함. --%>
<div class="chatbot-floating" onclick="location.href='${pageContext.request.contextPath}/chatbot'" style="cursor:pointer;">
    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
        <circle cx="8" cy="12" r="1.5" fill="currentColor" stroke="none"></circle>
        <circle cx="12" cy="12" r="1.5" fill="currentColor" stroke="none"></circle>
        <circle cx="16" cy="12" r="1.5" fill="currentColor" stroke="none"></circle>
    </svg>
</div>

<%--
  1. contextPath를 추가하여 /linkora 주소에서도 파일을 찾게 함.
  2. 파일 이름을 mp_script.js로 정확히 수정하여 연동함.
--%>
<script src="${pageContext.request.contextPath}/js/mp_script.js"></script>
</body>
</html>

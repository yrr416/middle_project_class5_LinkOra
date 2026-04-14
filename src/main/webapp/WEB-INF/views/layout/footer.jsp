<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="main-footer">
    <div class="container">
        <p>&copy; 2026 Link Ora. All rights reserved. | Premium Workspace Network</p>
    </div>
</footer>


<%-- 챗봇 컴포넌트 전역 포함 (모든 페이지에서 실시간 사용 가능) --%>
<jsp:include page="/WEB-INF/views/common/chatbot.jsp" />

<%--
  1. contextPath를 추가하여 /linkora 주소에서도 파일을 찾게 함.
  2. 파일 이름을 mp_script.js로 정확히 수정하여 연동함.
--%>
<script src="${pageContext.request.contextPath}/static/js/mp_script.js"></script>
</body>
</html>

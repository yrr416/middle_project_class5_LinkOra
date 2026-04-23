<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--/* 푸터 디자인 스타일 */--%>
<style>
    .custom-footer {
        background-color: #f8f9fa;
        padding: 30px 20px; /* 위아래 여백을 30px로 줄임 */
        border-top: 1px solid #eee;
        color: #666;
        font-family: 'Pretendard', sans-serif;
    }
    .custom-footer-inner {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    .custom-footer-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eaeaea;
        padding-bottom: 15px;
    }
    .footer-links {
        display: flex;
        gap: 25px;
        font-weight: 700;
        font-size: 14px;
    }
    .footer-links a {
        color: #444;
        text-decoration: none;
    }
    .footer-sns {
        display: flex;
        gap: 15px;
    }
    .footer-sns a {
        color: #aaa;
        font-size: 20px;
    }
    .custom-footer-bottom {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        font-size: 13px;
        line-height: 1.6;
        color: #888;
    }
    .company-info p {
        margin: 0;
    }
    .copyright {
        font-size: 12px;
        color: #bbb;
        margin-top: 10px;
    }
    .cs-center {
        text-align: right;
    }
    .cs-center h3 {
        margin: 0 0 5px 0;
        font-size: 18px; /* 크기를 18px로 줄임 */
        color: #333;
        font-weight: 700; /* 두께를 적당하게 조절함 */
    }
    .cs-center p {
        margin: 0;
        font-size: 12px;
    }
</style>

<%--/* 푸터 본문 레이아웃 */--%>
<footer class="custom-footer">
    <div class="custom-footer-inner">

<%--        /* 상단: 정책 링크 및 SNS 연결 */--%>
        <div class="custom-footer-top">
            <div class="footer-links">
                <a href="${pageContext.request.contextPath}/privacy" target="_blank">개인정보처리방침</a>
                <a href="${pageContext.request.contextPath}/terms" target="_blank">이용약관</a>
            </div>
            <div class="footer-sns">
<%--                /* SNS 아이콘에 기본 링크 연결 */--%>
                <a href="https://www.instagram.com" target="_blank"><i class="fa-brands fa-instagram"></i></a>
                <a href="https://www.youtube.com" target="_blank"><i class="fa-brands fa-youtube"></i></a>
                <a href="https://section.blog.naver.com" target="_blank"><i class="fa-solid fa-blog"></i></a>
            </div>
        </div>

<%--        /* 하단: 회사 상세 정보 및 고객센터 */--%>
        <div class="custom-footer-bottom">
            <div class="company-info">
                <p>상호명 : (주)링크오라 | 대표 : 김팀장 | 사업자등록번호 : 123-45-67890</p>
                <p>주소 : 서울특별시 마포구 백범로 23, 지하 1층</p>
                <p class="copyright">&copy; 2026 Link Ora. All rights reserved. | Premium Workspace Network</p>
            </div>
            <div class="cs-center">
                <h3>1588-0000</h3>
                <p>평일 09:00 ~ 18:00</p>
                <p>주말 및 공휴일 휴무</p>
            </div>
        </div>

    </div>
</footer>

<%--/* 챗봇 컴포넌트 포함 */--%>
<jsp:include page="/WEB-INF/views/common/chatbot.jsp" />

<%--/* 메인 스크립트 연결 */--%>
<script src="${pageContext.request.contextPath}/static/js/mp_script.js"></script>
</body>
</html>
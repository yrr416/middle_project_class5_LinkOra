<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 챗봇 플로팅 위젯 -->
<div id="chatbot-container">
    <!-- 챗봇 윈도우 -->
    <div id="chatbot-window" class="hidden">
        <div class="chatbot-header">
            <div class="bot-profile">
                <div class="bot-avatar">🤖</div>
                <div class="bot-info">
                    <span class="bot-name">MidBot</span>
                    <span class="status-online">Online</span>
                </div>
            </div>
            <button id="close-chatbot" title="닫기">&times;</button>
        </div>
        
        <div id="chatbot-messages">
            <div class="message bot">
                안녕하세요! **MidBot**입니다. 궁금하신 점을 물어봐 주세요.
            </div>
        </div>
        
        <div class="chatbot-input-area">
            <input type="text" id="chatbot-input" placeholder="메시지를 입력하세요..." autocomplete="off">
            <button id="send-btn">
                <svg viewBox="0 0 24 24" width="24" height="24">
                    <path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"></path>
                </svg>
            </button>
        </div>
    </div>

    <!-- 플로팅 실행 버튼 -->
    <button id="chatbot-toggle" title="챗봇 열기">
        <div class="toggle-icon">💬</div>
        <div class="pulse-ring"></div>
    </button>
</div>

<!-- 스타일 및 스크립트 연결 (추후 static 경로에 맞게 조정 필요) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chatbot.css">
<script src="${pageContext.request.contextPath}/static/js/chatbot.js"></script>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 챗봇 플로팅 위젯 -->
<div id="chatbot-container">
    <!-- 챗봇 윈도우 -->
    <div id="chatbot-window" class="hidden">
        <div class="chatbot-header">
            <div class="bot-profile">
                <div class="bot-avatar">🤖</div>
                <div class="bot-info">
                    <span class="bot-name">오피 (Offy)</span>
                    <span class="status-online">Online</span>
                </div>
            </div>
            <div class="header-actions">
                <button id="direct-inquiry" title="1:1 문의">직접 문의</button>
                <button id="close-chatbot" title="닫기">&times;</button>
            </div>
        </div>
        
        <div id="chatbot-messages">
            <!-- 메시지는 JS를 통해 동적으로 추가됩니다 -->
        </div>

        <!-- 추천 칩 영역 제거됨 -->
        
        <div class="chatbot-input-area">
            <input type="text" id="chatbot-input" placeholder="메시지를 입력하거나 버튼을 선택하세요..." autocomplete="off">
            <button id="send-btn">
                <svg viewBox="0 0 24 24" width="24" height="24">
                    <path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"></path>
                </svg>
            </button>
        </div>
    </div>

    <!-- 플로팅 실행 버튼 -->
    <button id="chatbot-toggle" title="챗봇 열기">
        <div class="toggle-icon">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
                <circle cx="8" cy="12" r="1.5" fill="currentColor" stroke="none" style="fill: white;"></circle>
                <circle cx="12" cy="12" r="1.5" fill="currentColor" stroke="none" style="fill: white;"></circle>
                <circle cx="16" cy="12" r="1.5" fill="currentColor" stroke="none" style="fill: white;"></circle>
            </svg>
        </div>
        <div class="pulse-ring"></div>
    </button>
</div>

<!-- 스타일 및 스크립트 연결 (추후 static 경로에 맞게 조정 필요) -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
    window.userIdx = '${userIdx != null ? userIdx : 0}';
</script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chatbot.css?v=1.2">
<script src="${pageContext.request.contextPath}/static/js/chatbot.js?v=1.2"></script>


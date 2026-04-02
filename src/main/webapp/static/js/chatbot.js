document.addEventListener('DOMContentLoaded', function() {
    const chatToggle = document.getElementById('chatbot-toggle');
    const chatWindow = document.getElementById('chatbot-window');
    const closeChat = document.getElementById('close-chatbot');
    const sendBtn = document.getElementById('send-btn');
    const chatInput = document.getElementById('chatbot-input');
    const chatMessages = document.getElementById('chatbot-messages');

    // 1. 세션 ID 관리 (localStorage 사용)
    let sessionId = localStorage.getItem('chatbot_session_id');
    if (!sessionId) {
        sessionId = Math.floor(Math.random() * 1000000);
        localStorage.setItem('chatbot_session_id', sessionId);
    }

    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || "";

    // 2. 이력 로드 여부 플래그
    let historyLoaded = false;

    // 3. 채팅 이력 불러오기 함수
    const loadChatHistory = () => {
        if (historyLoaded) return; // 이미 로드했다면 중복 생략

        fetch(`${contextPath}/chat/history/${sessionId}`)
        .then(response => response.json())
        .then(data => {
            if (data && data.length > 0) {
                // 기존 메시지 이력 출력
                data.forEach(chat => {
                    if (chat.cmessage) appendMessage('user', chat.cmessage);
                    if (chat.cresponse) appendMessage('bot', chat.cresponse);
                });
                historyLoaded = true;
            }
        })
        .catch(error => console.error('History Load Error:', error));
    };

    // 챗봇 열기/닫기 토글
    chatToggle.addEventListener('click', () => {
        chatWindow.classList.toggle('hidden');
        if (!chatWindow.classList.contains('hidden')) {
            chatInput.focus();
            loadChatHistory(); // 창을 열 때 이력 로드
        }
    });

    closeChat.addEventListener('click', () => {
        chatWindow.classList.add('hidden');
    });

    // 메시지 전송 로직
    const sendMessage = () => {
        const message = chatInput.value.trim();
        if (!message) return;

        appendMessage('user', message);
        chatInput.value = '';

        fetch(`${contextPath}/chat/send`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                cmessage: message, // ChatVO 필드명에 맞춰 소문자로 전송될 수 있으니 주의 (MyBatis resultType 설정 확인)
                csession: sessionId
            })
        })
        .then(response => response.json())
        .then(data => {
            appendMessage('bot', data.cresponse);
        })
        .catch(error => {
            console.error('Error:', error);
            appendMessage('bot', '죄송합니다. 서버와 연결이 원활하지 않습니다.');
        });
    };

    // UI에 메시지 추가 (동일)
    const appendMessage = (sender, text) => {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender);
        messageDiv.innerText = text;
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    };

    sendBtn.addEventListener('click', sendMessage);
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });
});

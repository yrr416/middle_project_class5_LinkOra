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

    const contextPath = window.contextPath || "";
    const currentPage = window.location.pathname;

    // 2. 이력 로드 여부 플래그
    let historyLoaded = false;

    // 3. 채팅 이력 불러오기 또는 초기 인사
    const loadChatHistory = () => {
        if (historyLoaded) return; 

        fetch(`${contextPath}/chat/history/${sessionId}`)
        .then(response => response.json())
        .then(data => {
            console.log("[Chat History Response]", data);
            if (data && data.length > 0) {
                data.forEach(chat => {
                    if (chat.chatMessage) appendMessage('user', chat.chatMessage);
                    if (chat.chatResponse) appendMessage('bot', chat.chatResponse);
                });
            } else {
                // 이력이 없을 때만 초기 인사 요청 (페이지 정보 포함)
                requestInitialGreeting();
            }
            historyLoaded = true;
        })
        .catch(error => console.error('History Load Error:', error));
    };

    // 현재 페이지 정보가 포함된 초기 인사 요청
    const requestInitialGreeting = () => {
        fetch(`${contextPath}/chat/send`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                chatMessage: "[OPEN_CHAT]", 
                chatSession: sessionId,
                chatPage: currentPage
            })
        })
        .then(response => response.json())
        .then(data => {
            console.log("[Initial Greeting Response]", data);
            appendMessage('bot', data.chatResponse);
        });
    };

    // 챗봇 열기/닫기 토글
    chatToggle.addEventListener('click', () => {
        chatWindow.classList.toggle('hidden');
        if (!chatWindow.classList.contains('hidden')) {
            chatInput.focus();
            loadChatHistory();
        }
    });

    closeChat.addEventListener('click', () => {
        chatWindow.classList.add('hidden');
    });

    // 직접 문의 버튼 연결
    document.getElementById('direct-inquiry').addEventListener('click', () => {
        if(confirm("1:1 문의 페이지로 이동하시겠습니까?")) {
            window.location.href = `${contextPath}/inquiry`;
        }
    });

    // 칩 클릭 이벤트
    document.querySelectorAll('.chip').forEach(chip => {
        chip.addEventListener('click', function() {
            const msg = this.getAttribute('data-msg');
            sendMessage(msg);
        });
    });

    // 메시지 전송 로직
    const sendMessage = (text) => {
        const message = text || chatInput.value.trim();
        if (!message) return;

        appendMessage('user', message);
        chatInput.value = '';

        fetch(`${contextPath}/chat/send`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                chatMessage: message,
                chatSession: sessionId,
                chatPage: currentPage
            })
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            console.log("[Chat Send Response]", data);
            if (data && data.chatResponse) {
                appendMessage('bot', data.chatResponse);
            } else {
                appendMessage('bot', '죄송합니다. 답변을 가져오는 중 문제가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            appendMessage('bot', '죄송합니다. 서버와 연결이 원활하지 않습니다. 잠시 후 다시 시도해 주세요.');
        });
    };

    const appendMessage = (sender, text) => {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender);
        messageDiv.innerText = text;
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    };

    sendBtn.addEventListener('click', () => sendMessage());
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });
});

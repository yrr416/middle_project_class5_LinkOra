document.addEventListener('DOMContentLoaded', function() {
    const chatToggle = document.getElementById('chatbot-toggle');
    const chatWindow = document.getElementById('chatbot-window');
    const closeChat = document.getElementById('close-chatbot');
    const sendBtn = document.getElementById('send-btn');
    const chatInput = document.getElementById('chatbot-input');
    const chatMessages = document.getElementById('chatbot-messages');

    // 1. 세션 ID 관리 (sessionStorage 사용 - 브라우저 종료 시 초기화)
    let sessionId = sessionStorage.getItem('chatbot_session_id');
    if (!sessionId) {
        sessionId = Math.floor(Math.random() * 1000000);
        sessionStorage.setItem('chatbot_session_id', sessionId);
    }

    const contextPath = window.contextPath || "";
    const currentPage = window.location.pathname;

    // 2. 이력 로드 여부 플래그
    let historyLoaded = false;

    // 3. 채팅 이력 불러오기 또는 초기 인사
    const loadChatHistory = () => {
        if (historyLoaded) return; 

        // 현재 세션 이력을 로드
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
                // 현재 세션 이력이 없을 때만 과거 전체 이력 존재 여부 체크
                checkRecentHistory();
                requestInitialGreeting();
            }
            historyLoaded = true;
        })
        .catch(error => console.error('History Load Error:', error));
    };

    // 과거 대화 내역이 있는지 확인 (사용자 ID 1L 기준)
    const checkRecentHistory = () => {
        fetch(`${contextPath}/chat/recent/1`)
        .then(response => response.json())
        .then(data => {
            if (data && data.length > 0) {
                showLoadHistoryBtn(data);
            }
        });
    };

    // "이전 대화 불러오기" 버튼 노출
    const showLoadHistoryBtn = (historyData) => {
        const btnContainer = document.createElement('div');
        btnContainer.id = 'load-history-container';
        btnContainer.innerHTML = `
            <button id="load-history-btn">
                <span class="icon">🕒</span> 이전 대화 불러오기
            </button>
        `;
        chatMessages.prepend(btnContainer);

        document.getElementById('load-history-btn').addEventListener('click', function() {
            this.disabled = true;
            this.innerText = "불러오는 중...";
            
            // 💡 수정 포인트: 데이터를 역순으로 순회하며 prepend하면 화면에는 정순(최신이 아래)으로 보임
            for (let i = historyData.length - 1; i >= 0; i--) {
                const chat = historyData[i];
                if (chat.chatResponse) prependMessage('bot', chat.chatResponse);
                if (chat.chatMessage) prependMessage('user', chat.chatMessage);
            }

            const divider = document.createElement('div');
            divider.className = 'history-divider';
            divider.innerText = "이전 대화 내역입니다";
            btnContainer.after(divider);
            btnContainer.remove();

            // 💡 추가 포인트: 이력을 불러온 후 가장 최근 대화(맨 아래)로 스크롤 이동
            setTimeout(() => {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }, 50); 
        });
    };

    // 메시지를 상단에 삽입하는 함수 (이력 복구용)
    const prependMessage = (sender, text) => {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender, 'history-msg');
        messageDiv.innerText = text;
        
        // 상단 버튼 컨테이너 바로 다음에 삽입
        const container = document.getElementById('load-history-container');
        if (container) {
            container.after(messageDiv);
        } else {
            chatMessages.prepend(messageDiv);
        }
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
        
        // 1. 액션 카드 태그 추출 ([[ACTIONS:ID|NAME|BRANCH|IMAGE]])
        const actionMatch = text.match(/\[\[ACTIONS:(.*?)\]\]/);
        let cleanText = text.replace(/\[\[ACTIONS:.*?\]\]/g, '').trim();
        
        // 2. 메시지 본문 렌더링
        messageDiv.innerText = cleanText;
        chatMessages.appendChild(messageDiv);

        // 3. 액션 카드가 있다면 추가 렌더링
        if (actionMatch && actionMatch[1]) {
            const parts = actionMatch[1].split('|');
            const spcIdx = parts[0];
            const spcName = parts[1];
            const brnName = parts[2];
            const spcImg = parts[3] || 'default_office.png';

            const cardDiv = document.createElement('div');
            cardDiv.classList.add('action-card');
            cardDiv.innerHTML = `
                <div class="action-thumb" style="background-image: url('${contextPath}/static/images/${spcImg}')"></div>
                <div class="action-body">
                    <div class="action-title">${spcName}</div>
                    <div class="action-subtitle">${brnName}</div>
                    <div class="action-btns">
                        <a href="${contextPath}/space/detail?spcIdx=${spcIdx}" class="btn-action detail">상세보기</a>
                        <a href="${contextPath}/reservation/user/form?spcIdx=${spcIdx}" class="btn-action reserve">예약하기</a>
                    </div>
                </div>
            `;
            chatMessages.appendChild(cardDiv);
        }

        chatMessages.scrollTop = chatMessages.scrollHeight;
    };

    sendBtn.addEventListener('click', () => sendMessage());
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });
});

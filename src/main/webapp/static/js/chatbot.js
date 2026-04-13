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

    // 2. 이력 로드 여부 플래그 및 임시 데이터 저장소
    // 전역 상태 관리 (스마트 프리필 데이터)
    let historyLoaded = false;
    let greetingRequested = false;
    let prefillData = { date: '', startTime: '', endTime: '' };

    // 3. 채팅 이력 불러오기 또는 초기 인사
    const loadChatHistory = () => {
        if (historyLoaded) return; 

        // 현재 세션 이력을 로드
        fetch(`${contextPath}/chat/history/${sessionId}`)
        .then(response => response.json())
        .then(data => {
            console.log("[Chat History Response]", data);
            let hasWelcomeMenu = false;
            if (data && data.length > 0) {
                data.forEach(chat => {
                    if (chat.chatMessage) appendMessage('user', chat.chatMessage);
                    if (chat.chatResponse) {
                        appendMessage('bot', chat.chatResponse);
                        if (chat.chatResponse.includes('[[WELCOME_MENU')) hasWelcomeMenu = true;
                    }
                });
            }
            
            // 이력이 없거나, 이력 중에 웰컴 메뉴가 한 번도 나오지 않았다면 초기 인사 요청
            if (!data || data.length === 0 || !hasWelcomeMenu) {
                checkRecentHistory();
                requestInitialGreeting();
            }
            historyLoaded = true;
        })
        .catch(error => console.error('History Load Error:', error));
    };

    // 과거 대화 내역이 있는지 확인 (로그인 유저 기반으로 변경)
    const checkRecentHistory = () => {
        // 백엔드 세션에서 정보를 가져오도록 0번(또는 가상의 번호) 전달 시 컨트롤러가 세션 체크
        fetch(`${contextPath}/chat/recent/0`)
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

            setTimeout(() => {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }, 50); 
        });
    };

    // 4. 메시지 렌더링 엔진 (상단 삽입/하단 추가 통합 지원)
    const renderMessage = (sender, text, position = 'append') => {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender);
        if (position === 'prepend') messageDiv.classList.add('history-msg');
        
        // --- 1. 특수 태그 처리 (PREFILL, COMPLETE_LINK) ---
        // 형식: [[PREFILL:yyyy-MM-dd|HH:mm|HH:mm]]
        const prefillMatch = text.match(/\[\[PREFILL:(.*?)\|(.*?)\|(.*?)\]\]/);
        if (prefillMatch) {
            prefillData.date = prefillMatch[1].trim();
            prefillData.startTime = prefillMatch[2].trim();
            prefillData.endTime = prefillMatch[3].trim();
            console.log("[Prefill Detected]", prefillData);
            text = text.replace(/\[\[PREFILL:.*?\]\]/g, '');
            
            // 현재 열려 있는 폼이 있다면 실시간 업데이트
            updateOpenForm();
        }

        const hasCompleteLink = text.includes('[[COMPLETE_LINK]]');
        text = text.replace('[[COMPLETE_LINK]]', '');

        // --- 2. 카드 및 일반 텍스트 렌더링 ---
        const welcomeMenuMatch = text.match(/\[\[WELCOME_MENU:([\s\S]*?)\]\]/);
        const actionMatches = [...text.matchAll(/\[\[ACTIONS:([\s\S]*?)\]\]/g)];
        let cleanText = text.replace(/\[\[WELCOME_MENU:[\s\S]*?\]\]/g, '')
                            .replace(/\[\[ACTIONS:[\s\S]*?\]\]/g, '').trim();
        
        messageDiv.innerText = cleanText || (welcomeMenuMatch || actionMatches.length > 0 ? "이런 서비스를 제공하고 있습니다." : "");
        
        // 위치 결정 로직
        const container = document.getElementById('load-history-container');
        const appendTo = chatMessages;
        
        const insertElement = (el) => {
            if (position === 'prepend' && container) {
                container.after(el);
            } else if (position === 'prepend') {
                appendTo.prepend(el);
            } else {
                appendTo.appendChild(el);
            }
        };

        if (messageDiv.innerText) insertElement(messageDiv);

        // 2-1. 웰컴 메뉴 렌더링
        if (welcomeMenuMatch && welcomeMenuMatch[1]) {
            const menuItems = welcomeMenuMatch[1].split(',').map(item => item.split('|').map(p => p.trim()));
            const menuGrid = document.createElement('div');
            menuGrid.classList.add('welcome-menu-grid', 'rich-content');
            if (position === 'prepend') menuGrid.classList.add('history-msg');

            menuItems.forEach(([label, msg, icon]) => {
                const menuItem = document.createElement('button');
                menuItem.classList.add('welcome-item');
                menuItem.innerHTML = `
                    <div class="welcome-icon">${icon || '✨'}</div>
                    <div class="welcome-label">${label}</div>
                `;
                menuItem.onclick = () => {
                    if (label.includes("공간 추천")) {
                        handleLocationAndSend(msg);
                    } else {
                        sendMessage(msg);
                    }
                };
                menuGrid.appendChild(menuItem);
            });
            insertElement(menuGrid);
        }


        // 3. 액션 카드가 있다면 추가 렌더링 (캐러셀 지원)
        if (actionMatches.length > 0) {
            const isCarousel = actionMatches.length > 1;
            
            let targetContentLayer = insertElement; // 기본은 바로 삽입

            if (isCarousel) {
                const wrapper = document.createElement('div');
                wrapper.classList.add('carousel-wrapper', 'rich-content');
                if (position === 'prepend') wrapper.classList.add('history-msg');
                insertElement(wrapper);

                const track = document.createElement('div');
                track.classList.add('carousel-track');
                wrapper.appendChild(track);

                // 좌우 네비게이션 버튼 (SVG)
                const prevBtn = document.createElement('button');
                prevBtn.classList.add('carousel-nav-btn', 'prev');
                prevBtn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>`;
                
                const nextBtn = document.createElement('button');
                nextBtn.classList.add('carousel-nav-btn', 'next');
                nextBtn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>`;

                wrapper.appendChild(prevBtn);
                wrapper.appendChild(nextBtn);

                // 스크롤 이벤트 (카드 260px + gap 16px = 276px)
                prevBtn.onclick = () => track.scrollBy({ left: -276, behavior: 'smooth' });
                nextBtn.onclick = () => track.scrollBy({ left: 276, behavior: 'smooth' });

                targetContentLayer = (el) => track.appendChild(el);
            }

            actionMatches.forEach(match => {
                const parts = match[1].split('|').map(p => p.trim());
                const spcIdx = parts[0], spcName = parts[1], brnName = parts[2], 
                      spcImg = (parts[3] && parts[3] !== ' ') ? parts[3] : 'default_office.png', 
                      facInfo = parts[4] || '',
                      spcPrice = parts[5] || '0';

                const cardDiv = document.createElement('div');
                cardDiv.classList.add('action-card');
                if (isCarousel) cardDiv.classList.add('carousel-item');
                if (position === 'prepend') cardDiv.classList.add('history-msg');
                
                const imgPath = `${contextPath}/static/images/${spcImg}`;
                const fallbackImg = `${contextPath}/static/images/default_office.png`;
                
                cardDiv.innerHTML = `
                    <div class="action-thumb" style="background-image: url('${imgPath}'), url('${fallbackImg}')">
                        ${facInfo ? `<span class="fac-badge">${facInfo.split(',')[0]}</span>` : ''}
                    </div>
                    <div class="action-body">
                        <div class="action-title">${spcName}</div><div class="action-subtitle">${brnName}</div>
                        <div class="action-btns">
                            <a href="${contextPath}/space/detail?spcIdx=${spcIdx}" target="_blank" class="btn-action detail">상세정보</a>
                            <button class="btn-action quick-reserve reserve" data-idx="${spcIdx}" data-name="${spcName}" data-price="${spcPrice}">바로예약</button>
                        </div>
                    </div>
                `;
                
                if (isCarousel) {
                    targetContentLayer(cardDiv);
                } else {
                    insertElement(cardDiv);
                }

                cardDiv.querySelector('.quick-reserve').onclick = function() { 
                    renderReserveForm(this.dataset.idx, this.dataset.name, this.dataset.price); 
                };
            });
        }

        // 예약 완료 버튼 추가
        if (hasCompleteLink) {
            const linkBtn = document.createElement('button');
            linkBtn.className = 'btn-complete';
            if (position === 'prepend') linkBtn.style.opacity = '0.7';
            linkBtn.innerText = '내 예약 내역 확인하기';
            linkBtn.onclick = () => { window.location.href = `${contextPath}/reservation/user/mylist`; };
            insertElement(linkBtn);
        }

        if (position === 'append') chatMessages.scrollTop = chatMessages.scrollHeight;
    };

    // 기존 함수들을 renderMessage로 연결
    const appendMessage = (sender, text) => renderMessage(sender, text, 'append');
    const prependMessage = (sender, text) => renderMessage(sender, text, 'prepend');

    // 현재 페이지 정보가 포함된 초기 인사 요청
    const requestInitialGreeting = () => {
        if (greetingRequested) return;
        greetingRequested = true;

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

    // 실시간 프리필 데이터 반영을 위한 폼 업데이트 함수
    const updateOpenForm = () => {
        const form = document.querySelector('.reserve-form-container');
        if (!form) return;

        const dateInput = form.querySelector('#res-date');
        const startSelect = form.querySelector('#res-time-start');
        const endSelect = form.querySelector('#res-time-end');

        if (prefillData.date && dateInput) {
            dateInput.value = prefillData.date;
            dateInput.classList.add('is-prefilled');
        }
        if (prefillData.startTime && startSelect) {
            startSelect.value = prefillData.startTime;
            startSelect.classList.add('is-prefilled');
        }
        if (prefillData.endTime && endSelect) {
            endSelect.value = prefillData.endTime;
            endSelect.classList.add('is-prefilled');
        }
    };

    // 위치 정보 획득 후 메시지 전송 핸들러
    const handleLocationAndSend = (msg) => {
        appendMessage('bot', '가까운 매장을 찾기 위해 위치 정보를 확인하고 있습니다... (거부 시 기본 추천으로 진행됩니다)');
        
        if (!navigator.geolocation) {
            console.log("Geolocation not supported");
            sendMessage(msg);
            return;
        }

        const options = { timeout: 5000, maximumAge: 0 };
        
        navigator.geolocation.getCurrentPosition(
            (pos) => {
                const lat = pos.coords.latitude;
                const lng = pos.coords.longitude;
                console.log("[Location Success]", lat, lng);
                sendMessage(msg, lat, lng);
            },
            (err) => {
                console.warn("[Location Error]", err.message);
                sendMessage(msg); // 위치 획득 실패 시 일반 전송 (폴백)
            },
            options
        );
    };

    // 메시지 전송 로직
    const sendMessage = (text, lat = null, lng = null) => {
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
                chatPage: currentPage,
                lat: lat,
                lng: lng
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



    // 간편 예약 폼 렌더링
    const renderReserveForm = (spcIdx, spcName, spcPrice = 0) => {
        const existingForm = document.querySelector('.reserve-form-container');
        if (existingForm) existingForm.remove();
        const formDiv = document.createElement('div');
        formDiv.classList.add('reserve-form-container');
        
        const defDate = prefillData.date || new Date().toISOString().split('T')[0];
        const defStart = prefillData.startTime || "14:00";
        
        // 종료 시간 계산 (프리필 데이터가 없으면 시작 시간 + 1시간)
        let defEnd = prefillData.endTime;
        if (!defEnd) {
            const startHour = parseInt(defStart.split(':')[0]);
            defEnd = `${(startHour + 1).toString().padStart(2, '0')}:00`;
        }
        
        const isDatePrefilled = !!prefillData.date;
        const isStartPrefilled = !!prefillData.startTime;
        const isEndPrefilled = !!prefillData.endTime;

        formDiv.innerHTML = `
            <div class="reserve-form-header"> ✨ ${spcName} 간편 예약</div>
            <div class="form-row"><label>이용 날짜</label><input type="date" id="res-date" value="${defDate}" style="width:100%; box-sizing:border-box;" class="${isDatePrefilled ? 'is-prefilled' : ''}"></div>
            <div class="form-row">
                <label>시작 시간</label>
                <select id="res-time-start" class="${isStartPrefilled ? 'is-prefilled' : ''}">
                    <option value="">선택</option>
                    ${Array.from({length: 12}, (_, i) => i + 9).map(h => {
                        const val = `${h.toString().padStart(2, '0')}:00`;
                        return `<option value="${val}" ${val === defStart ? 'selected' : ''}>${val}</option>`;
                    }).join('')}
                </select>
            </div>
            <div class="form-row">
                <label>종료 시간</label>
                <select id="res-time-end" class="${isEndPrefilled || (isStartPrefilled && !prefillData.endTime) ? 'is-prefilled' : ''}">
                    <option value="">선택</option>
                    ${Array.from({length: 12}, (_, i) => i + 10).map(h => {
                        const val = `${h.toString().padStart(2, '0')}:00`;
                        return `<option value="${val}" ${val === defEnd ? 'selected' : ''}>${val}</option>`;
                    }).join('')}
                </select>
            </div>
            <div class="form-row"><label>이용 인원</label>
                <div class="count-box"><button type="button" class="minus">-</button><input type="number" id="res-count" value="1" min="1" max="10" readonly><button type="button" class="plus">+</button></div>
            </div>
            <div class="price-row">
                <span class="price-label">총 예상 금액</span>
                <span class="price-value" id="total-price-display">0원</span>
            </div>
            <button class="btn-submit-form" id="submit-reserve">공간 예약하기</button>
        `;
        chatMessages.appendChild(formDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;

        // 가격 계산 핸들러 (시간 x 인원 x 요금)
        const updatePriceDisplay = () => {
            const start = formDiv.querySelector('#res-time-start').value;
            const end = formDiv.querySelector('#res-time-end').value;
            const count = parseInt(formDiv.querySelector('#res-count').value);
            const display = formDiv.querySelector('#total-price-display');
            
            if (start && end) {
                const sH = parseInt(start.split(':')[0]);
                const eH = parseInt(end.split(':')[0]);
                const diff = eH - sH;
                if (diff > 0) {
                    const total = diff * count * parseInt(spcPrice);
                    display.innerText = `${total.toLocaleString()}원 (${diff}시간 x ${count}명)`;
                    display.classList.remove('error');
                    return total;
                } else {
                    display.innerText = "시간 확인 필";
                    display.classList.add('error');
                }
            }
            return 0;
        };

        const startSelect = formDiv.querySelector('#res-time-start');
        const endSelect = formDiv.querySelector('#res-time-end');
        startSelect.onchange = updatePriceDisplay;
        endSelect.onchange = updatePriceDisplay;
        
        const countInput = formDiv.querySelector('#res-count');
        formDiv.querySelector('.minus').onclick = () => { 
            if(countInput.value > 1) {
                countInput.value--; 
                updatePriceDisplay();
            }
        };
        formDiv.querySelector('.plus').onclick = () => { 
            if(countInput.value < 10) {
                countInput.value++; 
                updatePriceDisplay();
            }
        };
        updatePriceDisplay(); // 초기 계산

        // [고도화] 예약 단계 관리 (0:입력, 1:확인)
        let formStep = 0;

        formDiv.querySelector('#submit-reserve').onclick = function() {
            const date = formDiv.querySelector('#res-date').value;
            const startTimeVal = formDiv.querySelector('#res-time-start').value;
            const endTimeVal = formDiv.querySelector('#res-time-end').value;
            const count = formDiv.querySelector('#res-count').value;

            if(!date || !startTimeVal || !endTimeVal) { alert("날짜와 시간을 선택해 주세요."); return; }
            if(startTimeVal >= endTimeVal) { alert("종료 시간은 시작 시간보다 늦어야 합니다."); return; }

            const total = updatePriceDisplay();

            if (formStep === 0) {
                // 1단계: 입력 완료 -> 확인 화면으로 전환
                formStep = 1;
                this.innerText = "위 정보로 최종 확정하기";
                this.classList.add('btn-confirm');
                
                // 입력 필드 비활성화 연출
                formDiv.querySelectorAll('input, select, button.plus, button.minus').forEach(el => el.disabled = true);
                formDiv.querySelector('.reserve-form-header').innerText = "📋 예약 내용을 확인해주세요";
                
                // [고도화] 수정 버튼 스타일링 (프리미엄 디자인 반영)
                const backBtn = document.createElement('button');
                backBtn.className = 'btn-form-back';
                backBtn.innerText = "◀ 정보 수정하기";
                Object.assign(backBtn.style, {
                    background: "transparent",
                    border: "1px solid #1e3a34",
                    color: "#1e3a34",
                    padding: "8px 12px",
                    borderRadius: "12px",
                    marginBottom: "10px",
                    cursor: "pointer",
                    fontSize: "13px",
                    fontWeight: "500",
                    display: "block",
                    width: "fit-content",
                    transition: "all 0.2s ease"
                });
                backBtn.onmouseover = () => { backBtn.style.background = "#f0f7f5"; };
                backBtn.onmouseout = () => { backBtn.style.background = "transparent"; };
                
                backBtn.onclick = () => {

                    formStep = 0;
                    this.innerText = "공간 예약하기";
                    this.classList.remove('btn-confirm');
                    formDiv.querySelectorAll('input, select, button.plus, button.minus').forEach(el => el.disabled = false);
                    formDiv.querySelector('.reserve-form-header').innerText = `✨ ${spcName} 간편 예약`;
                    backBtn.remove();
                };
                this.before(backBtn);
                return;
            }

            // 2단계: 최종 확정 -> 전송
            const startTime = `${date}T${startTimeVal}`;
            const endTime = `${date}T${endTimeVal}`;
            const reserveMsg = `[[COMMIT_BOOKING:${spcIdx}|${startTime}|${endTime}|${count}]]`;
            
            this.disabled = true;
            this.innerText = "예약 처리 중...";
            appendMessage('user', `${spcName} 예약 요청 (인원: ${count}명, ${total.toLocaleString()}원)`);
            
            setTimeout(() => {
                fetch(`${contextPath}/chat/send`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ chatMessage: reserveMsg, chatSession: sessionId, chatPage: currentPage })
                })
                .then(r => r.json())
                .then(data => {
                    formDiv.remove();
                    prefillData = { date: '', startTime: '', endTime: '' }; // 데이터 초기화
                    appendMessage('bot', data.chatResponse);
                })
                .catch(err => { 
                    alert("오류가 발생했습니다. 다시 시도해 주세요."); 
                    this.disabled = false; 
                    this.innerText = "최종 확정하기";
                });
            }, 600);
        };
    };


    sendBtn.addEventListener('click', () => sendMessage());
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });
});

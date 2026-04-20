<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% String today = LocalDate.now().toString(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약하기</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .slot-btn { flex-shrink: 0; width: 64px; height: 88px; }
        .timeline-scroll::-webkit-scrollbar { height: 6px; }
        .timeline-scroll::-webkit-scrollbar-track { background: #f1f5f9; border-radius: 4px; }
        .timeline-scroll::-webkit-scrollbar-thumb { background: #c7d2fe; border-radius: 4px; }
    </style>
</head>
<body class="bg-gray-50">

<%-- Null-safe 변수 선언 --%>
<c:set var="safeSpaceName"  value='${empty space.spcName        ? "공간 정보 없음" : space.spcName}'/>
<c:set var="safeSpaceType"  value='${empty space.spcType        ? "INDIVIDUAL"    : space.spcType}'/>
<c:set var="safeSpacePrice" value='${empty space.spcPrice       ? "0"             : space.spcPrice}'/>
<c:set var="safeMaxCap"     value='${empty space.spcMaxCapacity ? "0"             : space.spcMaxCapacity}'/>

<div class="max-w-4xl mx-auto px-4 py-10">
    <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${branch.brnIdx}"
       class="text-sm text-indigo-600 hover:underline mb-6 inline-block">← 지점 상세로</a>

    <div class="bg-white rounded-2xl shadow p-8">

        <%-- 공간 헤더 --%>
        <div class="flex items-start justify-between mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">${safeSpaceName}</h1>
                <p class="text-sm text-gray-500 mt-1">
                    <c:choose>
                        <c:when test="${safeSpaceType eq 'INDIVIDUAL'}">
                            좌석 단위 · 시간당 <strong class="text-indigo-600">${safeSpacePrice}원/인</strong>
                        </c:when>
                        <c:otherwise>
                            공간 전체 · 시간당 <strong class="text-indigo-600">${safeSpacePrice}원</strong>
                        </c:otherwise>
                    </c:choose>
                    &nbsp;·&nbsp; 최대 ${safeMaxCap}인
                </p>
            </div>
            <div class="flex gap-3 text-xs text-gray-500 mt-1">
                <span class="flex items-center gap-1.5">
                    <span class="w-3 h-3 rounded-sm bg-indigo-500 inline-block"></span>선택
                </span>
                <span class="flex items-center gap-1.5">
                    <span class="w-3 h-3 rounded-sm bg-gray-200 inline-block"></span>예약불가
                </span>
                <span class="flex items-center gap-1.5">
                    <span class="w-3 h-1 bg-orange-400 inline-block rounded"></span>피크
                </span>
            </div>
        </div>

        <%-- 에러 메시지 --%>
        <c:if test="${not empty errorMsg}">
            <div class="bg-red-50 border border-red-300 text-red-600 text-sm rounded-xl px-4 py-3 mb-6">
                ${errorMsg}
            </div>
        </c:if>

        <form id="reservationForm"
              action="${pageContext.request.contextPath}/reservation/submit" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="spcIdx"        value="${space.spcIdx}">
            <input type="hidden" name="resStartTime" id="startTimeInput">
            <input type="hidden" name="resEndTime"   id="endTimeInput">
            <%-- 영업시간 파싱용: JS 문자열 직접 주입 시 줄바꿈 오류가 생겨 hidden 요소로 전달 --%>
            <div id="branchHoursData" class="hidden">${branch.brnHours}</div>

            <%-- 날짜 선택 --%>
            <div class="mb-6">
                <label class="block text-sm font-semibold text-gray-700 mb-2">날짜 선택</label>
                <input type="date" id="dateInput"
                       class="border border-gray-300 rounded-xl px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400"
                       min="<%= today %>"
                       onchange="onDateChange(this.value)">
            </div>

            <%-- 타임라인 --%>
            <div class="mb-6">
                <div class="flex items-center justify-between mb-3">
                    <label class="text-sm font-semibold text-gray-700">
                        시간 선택
                        <span class="text-xs font-normal text-gray-400 ml-1">(최소 2시간 · 클릭으로 시작/끝 지정)</span>
                    </label>
                </div>

                <%-- 날짜 미선택 안내 --%>
                <div id="slotPlaceholder"
                     class="text-center py-10 text-gray-400 text-sm border-2 border-dashed border-gray-200 rounded-xl">
                    날짜를 먼저 선택해주세요
                </div>

                <%-- 로딩 --%>
                <div id="slotLoading" class="hidden text-center py-10 text-gray-400 text-sm">
                    <svg class="animate-spin h-6 w-6 text-indigo-400 mx-auto mb-2"
                         xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                    </svg>
                    예약 현황 불러오는 중...
                </div>

                <%-- 타임라인 컨테이너 --%>
                <div id="timelineWrap" class="hidden rounded-xl border border-gray-200 overflow-hidden">

                    <%-- 피크/오프피크 구간 라벨 --%>
                    <div class="flex bg-gray-50 border-b border-gray-200 text-xs font-medium">
                        <div class="flex-shrink-0 text-center text-slate-400 py-1.5 border-r border-gray-200"
                             style="width:576px">오프피크 (00~08시)</div>
                        <div class="flex-shrink-0 text-center text-orange-500 py-1.5 border-r border-gray-200"
                             style="width:640px">🔥 피크 (09~18시)</div>
                        <div class="flex-shrink-0 text-center text-slate-400 py-1.5 border-r border-gray-200"
                             style="width:256px">오프피크 (19~22시)</div>
                        <div class="flex-shrink-0 text-center text-gray-300 py-1.5"
                             style="width:64px">마감</div>
                    </div>

                    <%-- 슬롯 트랙 --%>
                    <div class="timeline-scroll overflow-x-auto">
                        <div id="slotTrack" class="flex" style="width:1536px"></div>
                    </div>
                </div>

                <p id="rangeError" class="hidden text-red-500 text-xs mt-2">
                    선택 범위에 예약 불가 시간이 포함되어 있습니다. 다시 선택해주세요.
                </p>
            </div>

            <%-- 인원수 --%>
            <div class="mb-6" id="headcountSection"
                 <c:if test="${safeSpaceType eq 'GROUP'}">style="display:none"</c:if>>

                <label class="block text-sm font-semibold text-gray-700 mb-2">예약 인원</label>
                <div class="flex items-center gap-2 flex-wrap">
                    <button type="button" onclick="changeCount(-1)"
                            class="w-10 h-10 rounded-xl border border-gray-300 text-xl font-bold text-gray-600 hover:bg-gray-100 transition">−</button>
                    <input type="number" name="resHeadcount" id="headcount"
                           value="1" min="1"
                           <c:if test="${safeSpaceType eq 'GROUP'}">disabled</c:if>
                           class="w-20 text-center border border-gray-300 rounded-xl px-2 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400"
                           oninput="updateSummary()">
                    <button type="button" onclick="changeCount(1)"
                            class="w-10 h-10 rounded-xl border border-gray-300 text-xl font-bold text-gray-600 hover:bg-gray-100 transition">+</button>
                    <button type="button" onclick="setCount(50)"
                            class="px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-sm text-gray-700 transition">50명</button>
                    <button type="button" onclick="setCount(100)"
                            class="px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-sm text-gray-700 transition">100명+</button>
                </div>
                <p id="capacityWarn" class="hidden text-red-500 text-xs mt-1">최대 수용 인원을 초과했습니다.</p>
            </div>

            <%-- 예약 요약 --%>
            <div class="bg-indigo-50 rounded-xl px-5 py-4 mb-6">
                <p id="summaryText" class="text-sm text-indigo-600">날짜와 시간을 선택하면 예상 금액이 표시됩니다.</p>
            </div>

            <%-- 제출 버튼 --%>
            <button type="submit" id="submitBtn" disabled
                    class="w-full py-3 rounded-xl font-semibold text-white bg-gray-300 cursor-not-allowed transition">
                예약 신청 (2시간 이상 선택 시 활성화)
            </button>
        </form>

        <%-- 계약 문의 유도 --%>
        <div class="mt-6 pt-6 border-t border-gray-200 text-center">
            <p class="text-sm text-gray-400 mb-3">장기 계약이 필요하신가요?</p>
            <button type="button" onclick="openInquiryModal()"
                    class="inline-block border border-indigo-500 text-indigo-600 hover:bg-indigo-50
                           font-semibold px-5 py-2 rounded-xl text-sm transition">
                계약 문의하기
            </button>
        </div>
    </div>
</div>

<%-- ── 계약 문의 모달 ── --%>
<div id="inquiryOverlay"
     class="hidden fixed inset-0 bg-black/40 z-40 flex items-center justify-center px-4"
     onclick="closeInquiryModalOnOverlay(event)">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg p-7 relative">

        <button type="button" onclick="closeInquiryModal()"
                class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 text-xl leading-none">✕</button>

        <h2 class="text-lg font-bold text-gray-800 mb-1">계약 문의</h2>
        <p class="text-xs text-gray-400 mb-5">장기 이용, 법인 계약 등 자유롭게 문의해 주세요.</p>

        <form action="${pageContext.request.contextPath}/inquiry/submit" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <div class="mb-4">
                <label class="block text-sm font-semibold text-gray-700 mb-1">제목</label>
                <input type="text" name="title" id="inquiryTitle"
                       class="w-full border border-gray-300 rounded-xl px-4 py-2.5 text-sm
                              focus:outline-none focus:ring-2 focus:ring-indigo-400"
                       placeholder="문의 제목을 입력해주세요" required>
            </div>
            <div class="mb-6">
                <label class="block text-sm font-semibold text-gray-700 mb-1">내용</label>
                <textarea name="content" id="inquiryContent" rows="6"
                          class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm
                                 focus:outline-none focus:ring-2 focus:ring-indigo-400 resize-none"
                          placeholder="희망 계약 조건, 이용 기간, 인원 등 자유롭게 작성해 주세요." required></textarea>
            </div>
            <button type="submit"
                    class="w-full py-3 rounded-xl font-semibold text-white
                           bg-indigo-600 hover:bg-indigo-700 transition text-sm">
                문의 제출
            </button>
        </form>
    </div>
</div>

<script>
    const CTX        = '${pageContext.request.contextPath}';
    const spaceIdx   = ${space.spcIdx};
    const spacePrice = parseInt('${safeSpacePrice}') || 0;
    const spaceType  = '${safeSpaceType}';
    const maxCap     = parseInt('${safeMaxCap}') || 0;
    const priceLabel = spaceType === 'INDIVIDUAL'
                       ? spacePrice.toLocaleString('ko-KR') + '원/인'
                       : spacePrice.toLocaleString('ko-KR') + '원';

    let unavailableSlots = [];
    let remainingSeats   = {}; // hour(0~23) → 잔여 좌석 수 (INDIVIDUAL 전용)
    let selStart = null;
    let selEnd   = null;

    /* ── 영업시간 파싱 → 오늘의 openHour / closeHour 계산 ──
       반환값: { open: 0~23, close: 0~24 }
       파싱 실패 시 { open: 0, close: 24 } (제한 없음)
    */
    function parseBranchHours() {
        const el = document.getElementById('branchHoursData');
        if (!el) return { open: 0, close: 24 };
        const text = el.textContent || '';
        if (!text.trim()) return { open: 0, close: 24 };

        // 24시간 연중무휴
        if (text.indexOf('24시간') !== -1) return { open: 0, close: 24 };

        const day = new Date().getDay(); // 0=일, 1~5=평일, 6=토

        // 오늘 요일 → 검색 키워드 (우선순위 순)
        let keywords;
        if      (day === 0)            keywords = ['일요일', '주말'];
        else if (day >= 1 && day <= 5) keywords = ['평일'];
        else                           keywords = ['토요일', '주말'];

        const lines = text.split('\n');
        let matched = null;

        // 키워드 우선순위 순서로 매칭
        for (const kw of keywords) {
            matched = lines.find(l => l.indexOf(kw) !== -1) || null;
            if (matched) break;
        }

        // 키워드 없이 시간만 있는 줄 (예: "09:00 ~ 22:00") — 전체 적용
        if (!matched) {
            matched = lines.find(l => /^\s*\d{2}:\d{2}\s*~\s*\d{2}:\d{2}\s*$/.test(l)) || null;
        }

        if (!matched) return { open: 0, close: 24 };

        // 휴무 → 종일 예약 불가
        if (matched.indexOf('휴무') !== -1) return { open: 0, close: 0 };

        // "HH:MM ~ HH:MM" 파싱
        const m = matched.match(/(\d{2}):(\d{2})\s*~\s*(\d{2}):(\d{2})/);
        if (!m) return { open: 0, close: 24 };

        return { open: parseInt(m[1]), close: parseInt(m[3]) };
    }

    // 페이지 로드 시 1회 계산 (요일이 바뀌지 않으므로 캐싱)
    const BIZ_HOURS = parseBranchHours();

    /* ── 날짜 변경 → AJAX ── */
    async function onDateChange(date) {
        if (!date) return;
        // 과거 날짜 선택 시 경고 후 오늘로 초기화
        const todayStr = new Date().toISOString().split('T')[0];
        if (date < todayStr) {
            alert('오늘 이후 날짜만 예약 가능합니다.');
            document.getElementById('dateInput').value = todayStr;
            date = todayStr;
        }
        showState('loading');
        try {
            const res = await fetch(CTX + '/reservation/slots?spaceIdx=' + spaceIdx + '&date=' + date);
            unavailableSlots = await res.json();

            // INDIVIDUAL 타입일 때만 잔여 좌석 조회
            if (spaceType === 'INDIVIDUAL') {
                const res2 = await fetch(
                    CTX + '/reservation/remaining?spaceIdx=' + spaceIdx +
                    '&date=' + date + '&maxCapacity=' + maxCap
                );
                remainingSeats = await res2.json();
            }
        } catch (e) {
            unavailableSlots = [];
            remainingSeats   = {};
        }
        selStart = null;
        selEnd   = null;
        showState('timeline');
        renderTimeline();
        updateSummary();
    }

    function showState(state) {
        document.getElementById('slotPlaceholder').classList.toggle('hidden', state !== 'placeholder');
        document.getElementById('slotLoading').classList.toggle('hidden', state !== 'loading');
        document.getElementById('timelineWrap').classList.toggle('hidden', state !== 'timeline');
    }

    /* ── 타임라인 렌더링 ── */
    function renderTimeline() {
        const track = document.getElementById('slotTrack');
        track.innerHTML = '';

        // 과거 날짜/시간 슬롯 비활성화 처리
        const selectedDate = document.getElementById('dateInput').value;
        const todayStr     = new Date().toISOString().split('T')[0];
        const isPastDate   = selectedDate < todayStr;  // 선택한 날짜 자체가 과거
        const isToday      = (selectedDate === todayStr);
        const currentHour  = new Date().getHours();    // 현재 시각(시 단위)

        for (let h = 0; h < 24; h++) {
            const isUnavailable = unavailableSlots.includes(h);
            const isClosed      = (h === 23);
            // 영업시간 외: open~close 범위 밖이거나 휴무(close===0)인 경우
            const isOutOfHours  = (h < BIZ_HOURS.open || h >= BIZ_HOURS.close);
            // 과거 날짜 전체 비활성화 OR 오늘이면 현재 시각 이하 슬롯 비활성화
            const isPast        = isPastDate || (isToday && h <= currentHour);
            const isBlocked     = isUnavailable || isClosed || isOutOfHours || isPast;
            const isPeak        = (h >= 9 && h <= 18);
            const isSelected    = selStart !== null && h >= selStart && h <= selEnd;
            const isSelStart    = isSelected && h === selStart;
            const isSelEnd      = isSelected && h === selEnd;
            const isSingle      = isSelStart && isSelEnd;

            const btn = document.createElement('button');
            btn.type = 'button';

            /* 기본 클래스 */
            let cls = 'slot-btn relative flex flex-col items-center justify-center border-r border-gray-200 transition-all duration-150 ';

            if (isSelected) {
                cls += 'bg-indigo-500 border-indigo-400 text-white shadow-inner rounded-none ';
            } else if (isClosed || isOutOfHours || isPast) {
                cls += 'bg-gray-50 text-gray-300 cursor-not-allowed ';
            } else if (isUnavailable) {
                cls += 'bg-gray-200 text-gray-400 cursor-not-allowed ';
            } else if (isPeak) {
                cls += 'bg-white text-gray-800 hover:bg-indigo-50 cursor-pointer ';
            } else {
                cls += 'bg-slate-50 text-gray-600 hover:bg-indigo-50 cursor-pointer ';
            }
            btn.className = cls;
            btn.disabled = isBlocked;

            /* 상단 컬러 바 (피크 표시) */
            const bar = document.createElement('div');
            bar.className = 'absolute top-0 left-0 right-0 h-1 ';
            if (isSelected)                              bar.className += 'bg-indigo-300';
            else if (isUnavailable)                      bar.className += 'bg-gray-400';
            else if (isClosed || isOutOfHours || isPast) bar.className += 'bg-gray-200';
            else if (isPeak)                     bar.className += 'bg-orange-400';
            else                                 bar.className += 'bg-slate-300';
            btn.appendChild(bar);

            /* 시간 라벨 */
            const hourEl = document.createElement('span');
            hourEl.className = 'font-bold text-sm leading-none mt-2';
            hourEl.textContent = pad(h) + '시';
            btn.appendChild(hourEl);

            /* 서브 라벨 */
            const subEl = document.createElement('span');
            subEl.className = 'text-xs mt-1.5 leading-none ';
            subEl.className += isSelected ? 'text-indigo-200' : 'opacity-60';
            if (isClosed) {
                subEl.textContent = '마감';
            } else if (isOutOfHours) {
                // 휴무일(close===0)과 영업시간 외 구분
                subEl.textContent = BIZ_HOURS.close === 0 ? '휴무' : '영업외';
            } else if (isUnavailable) {
                subEl.textContent = '예약불가';
            } else if (spaceType === 'INDIVIDUAL' && remainingSeats[h] !== undefined) {
                // 잔여 좌석 수 표시 (예: "잔여 7석")
                subEl.textContent = isSelected ? priceLabel : '잔여 ' + remainingSeats[h] + '석';
            } else {
                subEl.textContent = priceLabel;
            }
            btn.appendChild(subEl);

            /* 선택 시작/끝 핀 */
            if (isSelStart && !isSingle) {
                const pin = document.createElement('div');
                pin.className = 'absolute bottom-1.5 left-1.5 w-1.5 h-1.5 rounded-full bg-white opacity-80';
                btn.appendChild(pin);
            }
            if (isSelEnd && !isSingle) {
                const pin = document.createElement('div');
                pin.className = 'absolute bottom-1.5 right-1.5 w-1.5 h-1.5 rounded-full bg-white opacity-80';
                btn.appendChild(pin);
            }

            if (!isBlocked) {
                btn.onclick = (function(hour) { return function() { clickSlot(hour); }; })(h);
            }
            track.appendChild(btn);
        }
    }

    /* ── 슬롯 클릭 ── */
    function clickSlot(hour) {
        document.getElementById('rangeError').classList.add('hidden');

        if (selStart === null) {
            selStart = hour;
            selEnd   = hour;
        } else if (selStart === selEnd && selStart === hour) {
            selStart = null;
            selEnd   = null;
        } else {
            const newMin = Math.min(selStart, hour);
            const newMax = Math.max(selStart, hour);
            const blocked = unavailableSlots.some(function(u) { return u >= newMin && u <= newMax; });
            if (blocked) {
                document.getElementById('rangeError').classList.remove('hidden');
                selStart = hour;
                selEnd   = hour;
            } else {
                selStart = newMin;
                selEnd   = newMax;
            }
        }
        renderTimeline();
        updateSummary();
    }

    /* ── 요약 & 버튼 상태 ── */
    function updateSummary() {
        const dateVal     = document.getElementById('dateInput').value;
        const summaryEl   = document.getElementById('summaryText');
        const headcountEl = document.getElementById('headcount');
        const headcount   = headcountEl ? (parseInt(headcountEl.value) || 1) : 1;
        const selectedHrs = selStart === null ? 0 : (selEnd - selStart + 1);

        if (spaceType === 'INDIVIDUAL') {
            const warn = document.getElementById('capacityWarn');
            if (warn) warn.classList.toggle('hidden', headcount <= maxCap);
        }

        if (!dateVal || selStart === null) {
            summaryEl.textContent = '날짜와 시간을 선택하면 예상 금액이 표시됩니다.';
            setSubmitDisabled(true);
            return;
        }

        document.getElementById('startTimeInput').value = dateVal + 'T' + pad(selStart) + ':00';
        document.getElementById('endTimeInput').value   = dateVal + 'T' + pad(selEnd + 1) + ':00';

        const total = spaceType === 'INDIVIDUAL'
            ? spacePrice * headcount * selectedHrs
            : spacePrice * selectedHrs;

        summaryEl.innerHTML =
            '<strong>' + pad(selStart) + ':00 ~ ' + pad(selEnd + 1) + ':00</strong>' +
            ' &nbsp;·&nbsp; ' + selectedHrs + '시간' +
            ' &nbsp;·&nbsp; 예상 금액: <strong class="text-indigo-700">' +
            total.toLocaleString('ko-KR') + '원</strong>';

        const overCap = spaceType === 'INDIVIDUAL' && headcount > maxCap;
        setSubmitDisabled(selectedHrs < 2 || overCap);
    }

    function setSubmitDisabled(disabled) {
        const btn = document.getElementById('submitBtn');
        btn.disabled = disabled;
        btn.className = disabled
            ? 'w-full py-3 rounded-xl font-semibold text-white bg-gray-300 cursor-not-allowed transition'
            : 'w-full py-3 rounded-xl font-semibold text-white bg-indigo-600 hover:bg-indigo-700 cursor-pointer transition';
        btn.textContent = disabled ? '예약 신청 (2시간 이상 선택 시 활성화)' : '예약 신청';
    }

    function changeCount(delta) {
        const input = document.getElementById('headcount');
        input.value = Math.max(1, (parseInt(input.value) || 1) + delta);
        updateSummary();
    }
    function setCount(val) {
        document.getElementById('headcount').value = val;
        updateSummary();
    }
    function pad(n) { return String(n).padStart(2, '0'); }

    document.getElementById('dateInput').min = new Date().toISOString().split('T')[0];

    /* ── 계약 문의 모달 ── */
    function openInquiryModal() {
        const title = document.getElementById('inquiryTitle');
        if (!title.value) title.value = '[${safeSpaceName}] 계약 문의합니다.';
        document.getElementById('inquiryOverlay').classList.remove('hidden');
    }
    function closeInquiryModal() {
        document.getElementById('inquiryOverlay').classList.add('hidden');
    }
    function closeInquiryModalOnOverlay(e) {
        if (e.target === document.getElementById('inquiryOverlay')) closeInquiryModal();
    }
</script>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<%-- CSRF 토큰: AJAX (특히 FormData) 요청에 헤더로 포함하기 위해 meta 태그에 저장 --%>
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<%-- 페이지 전용 스타일 및 라이브러리 --%>
<script src="https://cdn.tailwindcss.com"></script>
<%-- Tailwind 색상을 프로젝트 디자인(다크 테일)에 맞춰 재정의함 --%>
<%-- CDN 로드 후에 config를 설정해야 tailwind 객체가 존재함 --%>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          indigo: {
            50:  '#f4f7f6',
            100: '#e8f0ef',
            200: '#d1e1e1',
            300: '#a3b8b8',
            400: '#7a9e9e',
            500: '#4f8080',
            600: '#2F4F4F',
            700: '#1e3333',
            800: '#162828',
            900: '#0e1c1c',
          }
        }
      }
    }
  }
</script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
  .tab-btn.active   { color:#2F4F4F; border-bottom:2px solid #2F4F4F; }
  .tab-btn          { border-bottom:2px solid transparent; }
  .tab-panel        { display:none; }
  .tab-panel.active { display:block; }
  .star-filled      { color:#fbbf24; }
  .star-empty       { color:#e5e7eb; }
  /* 욕설 배지 스타일은 censorContent() 함수에서 인라인 스타일로 직접 적용 */
  /* 예약 바(64px)에 footer가 가려지지 않도록 padding-bottom을 늘림 */
  .main-footer { padding-bottom: 80px; }
  /* 챗봇 버튼을 예약 바 위로 올려서 겹치지 않게 함 */
  #chatbot-container { bottom: 95px !important; }
  #mapbtn { margin: 10px; }
</style>

<%-- 카카오맵 SDK (키가 있을 때만 로드) --%>
<%--카카오맵이 로딩이되기전에 탭을 누르면 카카오객체가 생성이 끝까지 생성안되는일이 있어 autoload=false를 해두고
    탭을 누를때만 로딩이되게 처리하자(콜백)--%>
<c:if test="${not empty kakaoMapKey}">
  <script type="text/javascript"
          src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false"></script>
</c:if>

<%-- main에 pb-20(80px) 추가: 하단 고정 예약 바에 콘텐츠가 가려지지 않도록 함 --%>
<main class="pb-20">

  <div class="max-w-4xl mx-auto px-4 py-8">

    <%-- 뒤로가기 --%>
    <a href="${pageContext.request.contextPath}/detail/list"
       class="text-sm text-indigo-600 hover:underline mb-4 inline-block">← 목록으로</a>

    <%-- 헤더: 지점명 + 파트너 배지 --%>
    <div class="mb-2 flex items-center gap-3 flex-wrap">
      <h1 class="text-2xl font-bold text-gray-800">${branch.brnName}</h1>
      <span class="text-xs font-semibold text-indigo-600 bg-indigo-50 px-2.5 py-1 rounded-full">
        ${branch.partnerName}
      </span>
    </div>
    <c:if test="${not empty branch.brnDescription}">
      <p class="text-sm text-gray-500 mb-5">${branch.brnDescription}</p>
    </c:if>

    <%-- 이미지 슬라이더 --%>
    <c:choose>
      <c:when test="${not empty branch.images}">
        <div class="relative mb-6 rounded-2xl overflow-hidden" id="imgSlider">
            <%-- 슬라이드 목록 --%>
          <div class="flex transition-transform duration-300 ease-in-out" id="imgTrack">
            <c:forEach var="img" items="${branch.images}">
              <div class="min-w-full h-64 flex-shrink-0">
                <img src="${pageContext.request.contextPath}${img.biUrl}"
                     alt="${branch.brnName}"
                     class="w-full h-full object-cover">
              </div>
            </c:forEach>
          </div>

            <%-- 이미지가 2장 이상일 때만 버튼/인디케이터 표시 --%>
          <c:if test="${fn:length(branch.images) > 1}">
            <button onclick="slideImg(-1)"
                    class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/40 hover:bg-black/60
                         text-white rounded-full w-8 h-8 flex items-center justify-center transition">‹</button>
            <button onclick="slideImg(1)"
                    class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/40 hover:bg-black/60
                         text-white rounded-full w-8 h-8 flex items-center justify-center transition">›</button>
            <div class="absolute bottom-2 left-1/2 -translate-x-1/2 flex gap-1.5" id="imgDots"></div>
          </c:if>
        </div>
        <script>
          (function() {
            const total = ${fn:length(branch.images)};
            if (total <= 1) return;
            let cur = 0;
            const track = document.getElementById('imgTrack');
            const dotsEl = document.getElementById('imgDots');

            for (let i = 0; i < total; i++) {
              const d = document.createElement('span');
              d.className = 'w-1.5 h-1.5 rounded-full ' + (i === 0 ? 'bg-white' : 'bg-white/50');
              dotsEl.appendChild(d);
            }

            window.slideImg = function(dir) {
              cur = (cur + dir + total) % total;
              track.style.transform = 'translateX(-' + (cur * 100) + '%)';
              dotsEl.querySelectorAll('span').forEach((d, i) => {
                d.className = 'w-1.5 h-1.5 rounded-full ' + (i === cur ? 'bg-white' : 'bg-white/50');
              });
            };
          })();
        </script>
      </c:when>
      <c:otherwise>
        <div class="w-full h-64 bg-gradient-to-br from-indigo-50 to-indigo-100
                  rounded-2xl mb-6 flex items-center justify-center
                  text-indigo-200 text-6xl font-bold select-none">WS</div>
      </c:otherwise>
    </c:choose>

    <%-- 탭 네비게이션 --%>
    <div class="flex border-b border-gray-200 mb-6 gap-1">
      <button id="tab-btn-info"   class="tab-btn active px-5 py-3 text-sm font-semibold text-gray-500 transition"
              onclick="switchTab('info', this)">상세정보</button>
      <button id="tab-btn-map"    class="tab-btn px-5 py-3 text-sm font-semibold text-gray-500 transition"
              onclick="switchTab('map', this)">위치 및 주변시설</button>
    </div>

    <%-- ── 탭: 상세정보 ── --%>
    <div id="tab-info" class="tab-panel active">
      <div class="space-y-6">

        <c:if test="${not empty branch.brnHours}">
          <%-- 줄바꿈 포함 텍스트를 JS에 안전하게 전달: 요소의 textContent로 읽음 --%>
          <div id="branchHoursData" class="hidden">${branch.brnHours}</div>
          <div class="bg-white rounded-2xl p-6 shadow-sm">
            <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center gap-2">
              <span class="text-indigo-500">🕐</span> 영업시간
                <%-- JS가 채워 넣을 영업중/종료 뱃지 --%>
              <span id="hoursStatusBadge"></span>
            </h3>
            <p class="text-sm text-gray-600 whitespace-pre-line">${branch.brnHours}</p>
          </div>
        </c:if>


        <c:if test="${not empty branch.brnNotice}">
          <div class="bg-amber-50 rounded-2xl p-6 shadow-sm border border-amber-100">
            <h3 class="text-sm font-bold text-amber-700 mb-3 flex items-center gap-2">
              <span>⚠️</span> 예약 시 주의사항
            </h3>
            <p class="text-sm text-amber-700 whitespace-pre-line">${branch.brnNotice}</p>
          </div>
        </c:if>

        <c:if test="${not empty branch.brnRefundPoli}">
          <div class="bg-white rounded-2xl p-6 shadow-sm">
            <h3 class="text-sm font-bold text-gray-700 mb-3 flex items-center gap-2">
              <span class="text-indigo-500">💳</span> 환불 규정
            </h3>
            <p class="text-sm text-gray-600 whitespace-pre-line">${branch.brnRefundPoli}</p>
          </div>
        </c:if>

      </div>
    </div>

    <%-- ── 탭: 위치 ── --%>
    <div id="tab-map" class="tab-panel">
      <div class="bg-white rounded-2xl p-6 shadow-sm">

        <%-- 카카오맵 지도 컨테이너 --%>
        <div id="kakaoMap" class="w-full h-64 rounded-xl bg-gray-100 mb-5 flex items-center justify-center">
          <c:if test="${empty kakaoMapKey}">
            <span class="text-gray-400 text-sm">카카오맵 API 키를 설정해주세요 (application.properties)</span>
          </c:if>
        </div>

        <%-- 주소 + 연락처 --%>
        <div class="space-y-3 text-sm text-gray-600">
          <c:if test="${not empty branch.brnAddress}">
            <div class="flex items-start gap-2">
              <span class="text-base mt-0.5">📍</span>
              <span>${branch.brnAddress}</span>
            </div>
          </c:if>
          <c:if test="${not empty branch.brnPhone}">
            <div class="flex items-center gap-2">
              <span class="text-base">📞</span>
              <a href="tel:${branch.brnPhone}" class="hover:text-indigo-600">${branch.brnPhone}</a>
            </div>
          </c:if>
          <c:if test="${not empty branch.brnSns}">
            <div class="flex items-center gap-2">
              <span class="text-base">🔗</span>
              <a href="${branch.brnSns}" target="_blank"
                 class="text-indigo-600 hover:underline truncate">${branch.brnSns}</a>
            </div>
          </c:if>
        </div>

        <%-- 네이버 지도 길찾기 버튼 --%>
        <c:if test="${not empty branch.brnAddress}">
          <a href="https://map.naver.com/v5/search/${branch.brnAddress}" target="_blank"
             class="mt-5 inline-flex items-center gap-2 bg-green-500 hover:bg-green-600
                          text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition">
            🗺️ 네이버 지도로 길찾기
          </a>
        </c:if>
        <br>
        <div class="flex flex-wrap gap-2 p-4 ">
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="CS2"><span>🏪</span> 편의점</button>
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="FD6"><span>🍽️</span> 음식점</button>
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="PM9"><span>🏥</span> 약국</button>
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="BK9"><span>🏦</span> 은행</button>
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="SW8"><span>🚌</span> 교통</button>
          <button class="category-btn flex items-center gap-1.5 px-4 py-1.5 rounded-full border-2 text-sm transition-all duration-150" data-category="PK6"><span>🅿️</span> 주차</button>
        </div>

      </div>
    </div><%-- /tab-map --%>

    <%-- ── 이용후기 (항상 표시) ── --%>
    <div class="mt-10">
      <div class="flex items-center gap-3 mb-3 flex-wrap">
        <h2 class="text-lg font-bold text-gray-800">이용후기</h2>
        <span id="reviewStats" class="text-sm text-gray-400"></span>
      </div>
      <div id="reviewContainer">
        <p class="text-center text-gray-400 py-10 text-sm">이용후기를 불러오는 중...</p>
      </div>

      <%-- 리뷰 작성 폼: 로그인한 사용자에게만 표시 --%>
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <div class="bg-white rounded-2xl p-5 shadow-sm mt-6">
            <h3 class="text-sm font-bold text-gray-700 mb-3">후기 작성</h3>

              <%-- 별점 선택 --%>
            <div class="flex items-center gap-1 mb-3" id="starSelector">
              <c:forEach begin="1" end="5" var="i">
                <button type="button"
                        onclick="setRating(${i})"
                        class="star-btn text-2xl text-gray-300 hover:text-yellow-400 transition"
                        data-val="${i}">★</button>
              </c:forEach>
              <span id="ratingLabel" class="text-xs text-gray-400 ml-2">별점을 선택해주세요</span>
            </div>
            <input type="hidden" id="reviewRating" value="0">

              <%-- 공간 선택 (지점 내 공간이 여러 개일 경우) --%>
            <c:if test="${fn:length(branch.spaces) > 1}">
              <select id="reviewSpcIdx" class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm mb-3
                                             focus:outline-none focus:ring-2 focus:ring-indigo-300">
                <c:forEach var="sp" items="${branch.spaces}">
                  <option value="${sp.spcIdx}">${sp.spcName}</option>
                </c:forEach>
              </select>
            </c:if>
            <c:if test="${fn:length(branch.spaces) == 1}">
              <input type="hidden" id="reviewSpcIdx" value="${branch.spaces[0].spcIdx}">
            </c:if>

            <textarea id="reviewContent" rows="3"
                      placeholder="이용 후기를 남겨주세요."
                      class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm
                           resize-none focus:outline-none focus:ring-2 focus:ring-indigo-300 mb-3"></textarea>

              <%-- 이미지 첨부 (선택) --%>
            <label class="block text-xs text-gray-400 mb-1">사진 첨부 (선택, 최대 10MB)</label>
            <input type="file" id="reviewImgFile" accept="image/*"
                   class="block w-full text-xs text-gray-500 mb-3
                        file:mr-3 file:py-1 file:px-3 file:rounded-lg file:border-0
                        file:text-xs file:font-semibold file:bg-indigo-50 file:text-indigo-600
                        hover:file:bg-indigo-100">

            <c:choose>
              <c:when test="${hasReservation}">
                <button onclick="submitReview()"
                        class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold
                             px-5 py-2 rounded-xl transition">
                  후기 등록
                </button>
              </c:when>
              <c:otherwise>
                <button type="button" onclick="showReviewMsg('예약한 사용자만 이용후기를 작성할 수 있습니다.', false)"
                        class="bg-gray-200 text-gray-400 text-sm font-semibold
                             px-5 py-2 rounded-xl cursor-not-allowed">
                  후기 등록
                </button>
              </c:otherwise>
            </c:choose>
            <p id="reviewMsg" class="text-xs mt-2 hidden"></p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="bg-gray-50 rounded-2xl p-5 text-center mt-6">
            <p class="text-sm text-gray-400">
              후기 작성은 로그인 후 이용 가능합니다.
              <a href="${pageContext.request.contextPath}/loginPage"
                 class="text-indigo-600 hover:underline ml-1">로그인하기</a>
            </p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- ── 예약 가능 공간 카드 ── --%>
    <div id="spaceSection" class="mt-10">
      <h2 class="text-lg font-bold text-gray-800 mb-4">예약 가능 공간</h2>

      <c:choose>
        <c:when test="${not empty branch.spaces}">
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <c:forEach var="space" items="${branch.spaces}">
              <div class="bg-white rounded-2xl shadow-sm p-5 flex flex-col gap-3">
                <div class="flex items-center gap-2">
                  <c:choose>
                    <c:when test="${space.spcType eq 'INDIVIDUAL'}">
                      <span class="text-xs font-semibold text-blue-600 bg-blue-50 px-2 py-0.5 rounded-full">개인 좌석</span>
                    </c:when>
                    <c:otherwise>
                      <span class="text-xs font-semibold text-purple-600 bg-purple-50 px-2 py-0.5 rounded-full">공간 전체</span>
                    </c:otherwise>
                  </c:choose>
                  <span class="font-semibold text-gray-800">${space.spcName}</span>
                </div>

                <c:if test="${not empty space.spcDescription}">
                  <p class="text-xs text-gray-500">${space.spcDescription}</p>
                </c:if>

                  <%-- 시설 아이콘 (DB 값 1 = 제공) --%>
                <c:if test="${not empty space.facilities}">
                  <div class="flex flex-wrap gap-1.5">
                    <c:if test="${space.facilities.facCafe     == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">☕ 카페</span></c:if>
                    <c:if test="${space.facilities.facDesk     == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🖥️ 데스크</span></c:if>
                    <c:if test="${space.facilities.facDelivery == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">📦 택배</span></c:if>
                    <c:if test="${space.facilities.facWater    == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">💧 정수기</span></c:if>
                    <c:if test="${space.facilities.facHours24  == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🕐 24시간</span></c:if>
                    <c:if test="${space.facilities.facKitchen  == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🍳 주방</span></c:if>
                    <c:if test="${space.facilities.facDisplay  == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">📺 디스플레이</span></c:if>
                    <c:if test="${space.facilities.facStorage  == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🗄️ 보관함</span></c:if>
                    <c:if test="${space.facilities.facParking  == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🅿️ 주차</span></c:if>
                    <c:if test="${space.facilities.facFax      == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">📠 팩스</span></c:if>
                    <c:if test="${space.facilities.facPet      == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🐾 반려동물</span></c:if>
                    <c:if test="${space.facilities.facLounge   == 1}"><span class="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2 py-1">🛋️ 라운지</span></c:if>
                  </div>
                </c:if>

                <div class="flex items-center justify-between text-sm">
                  <span class="text-gray-500">최대 ${space.spcMaxCapacity}인</span>
                  <span class="font-bold text-indigo-600">
                                    <c:choose>
                                      <c:when test="${space.spcType eq 'INDIVIDUAL'}">
                                        ${space.spcPrice}원/인·시간
                                      </c:when>
                                      <c:otherwise>
                                        ${space.spcPrice}원/시간
                                      </c:otherwise>
                                    </c:choose>
                                </span>
                </div>

                <c:choose>
                  <c:when test="${not empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/reservation/form?spcIdx=${space.spcIdx}"
                       class="block text-center bg-indigo-600 hover:bg-indigo-700
                                              text-white text-sm font-semibold py-2 rounded-xl transition">
                      예약하기
                    </a>
                  </c:when>
                  <c:otherwise>
                    <a href="${pageContext.request.contextPath}/loginPage?redirectUrl=${pageContext.request.contextPath}/reservation/form?spcIdx=${space.spcIdx}"
                       class="block text-center bg-gray-200 hover:bg-gray-300
                                              text-gray-600 text-sm font-semibold py-2 rounded-xl transition">
                      로그인 후 예약
                    </a>
                  </c:otherwise>
                </c:choose>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <p class="text-gray-400 text-sm py-6 text-center">등록된 공간이 없습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- ── 장기 계약 문의 섹션 ── --%>
    <div class="mt-10">
      <h2 class="text-lg font-bold text-gray-800 mb-4">장기 계약 문의</h2>

      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <div class="bg-white rounded-2xl p-6 shadow-sm">
            <p class="text-sm text-gray-500 mb-5">
              월 단위 장기 계약을 원하신다면 아래 양식을 작성해 주세요.<br>
              담당자가 확인 후 연락드립니다.
            </p>
            <div class="space-y-4">

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <%-- 희망 시작일 --%>
                <div>
                  <label class="block text-xs font-semibold text-gray-500 mb-1">희망 시작일</label>
                  <input type="date" id="ctStartDate"
                         class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-300">
                </div>
                  <%-- 계약 기간 --%>
                <div>
                  <label class="block text-xs font-semibold text-gray-500 mb-1">계약 기간</label>
                  <select id="ctDuration"
                          class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-300">
                    <option value="">선택해주세요</option>
                    <option value="1개월">1개월</option>
                    <option value="3개월">3개월</option>
                    <option value="6개월">6개월</option>
                    <option value="1년">1년</option>
                    <option value="1년 이상">1년 이상</option>
                  </select>
                </div>
              </div>

                <%-- 인원 수 --%>
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1">인원 수</label>
                <input type="number" id="ctHeadcount" min="1" max="200" placeholder="예: 5"
                       class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-300">
              </div>

                <%-- 문의 내용 --%>
              <div>
                <label class="block text-xs font-semibold text-gray-500 mb-1">문의 내용 <span class="text-red-400">*</span></label>
                <textarea id="ctContent" rows="4" placeholder="원하시는 조건, 추가 요청사항 등을 자유롭게 작성해주세요."
                          class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-indigo-300"></textarea>
              </div>

              <button onclick="submitContact()"
                      class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2.5 rounded-xl text-sm transition">
                문의 접수하기
              </button>

              <p id="contactMsg" class="text-sm text-center hidden"></p>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <div class="bg-gray-50 rounded-2xl p-5 text-center">
            <p class="text-sm text-gray-400">
              장기 계약 문의는 로그인 후 이용 가능합니다.
              <a href="${pageContext.request.contextPath}/loginPage"
                 class="text-indigo-600 hover:underline ml-1">로그인하기</a>
            </p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div><%-- /max-w-4xl --%>

  <%-- ── 리뷰 신고 모달 ── --%>
  <div id="reportModal"
       class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center px-4"
       onclick="closeReportModal(event)">
    <div class="bg-white rounded-2xl p-6 w-full max-w-sm shadow-xl" onclick="event.stopPropagation()">
      <h3 class="font-bold text-gray-800 mb-1">리뷰 신고</h3>
      <p class="text-xs text-gray-400 mb-4">부적절한 내용이 포함된 리뷰를 신고합니다.</p>

      <label class="block text-xs font-semibold text-gray-500 mb-1">신고 사유</label>
      <select id="reportReason"
              class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm mb-4 focus:outline-none focus:ring-2 focus:ring-red-200">
        <option value="욕설/비방">욕설 · 비방</option>
        <option value="허위정보">허위 정보</option>
        <option value="광고/스팸">광고 · 스팸</option>
        <option value="개인정보노출">개인정보 노출</option>
        <option value="기타">기타</option>
      </select>

      <p id="reportMsg" class="text-xs text-red-400 mb-3 hidden"></p>

      <div class="flex gap-2">
        <button onclick="submitReport()"
                class="flex-1 bg-red-500 hover:bg-red-600 text-white text-sm font-semibold py-2 rounded-xl transition">
          신고하기
        </button>
        <button onclick="closeReportModal()"
                class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm font-semibold py-2 rounded-xl transition">
          취소
        </button>
      </div>
    </div>
  </div>

  <%-- ── 리뷰 수정 모달 ── --%>
  <div id="editModal"
       class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center px-4"
       onclick="closeEditModal()">
    <div class="bg-white rounded-2xl p-6 w-full max-w-sm shadow-xl" onclick="event.stopPropagation()">
      <h3 class="font-bold text-gray-800 mb-4">리뷰 수정</h3>

      <%-- 별점 선택 --%>
      <input type="hidden" id="editRating" value="0">
      <div class="flex gap-1 mb-3">
        <c:forEach var="i" begin="1" end="5">
          <button type="button"
                  class="edit-star-btn text-2xl text-gray-300 transition"
                  data-val="${i}"
                  onclick="setEditRating(${i})">★</button>
        </c:forEach>
      </div>

      <textarea id="editContent" rows="4"
                class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm mb-3
                     focus:outline-none focus:ring-2 focus:ring-indigo-200 resize-none"
                placeholder="수정할 내용을 입력해주세요."></textarea>

      <%-- 기존 이미지 미리보기: 이미지가 있을 때만 표시 --%>
      <div id="editImgPreviewWrap" class="mb-3 hidden">
        <img id="editImgPreview" src="" alt="현재 이미지"
             class="max-h-40 rounded-xl object-cover border border-gray-100 mb-1 block">
        <button type="button" onclick="removeEditImg()"
                class="text-xs text-red-400 hover:text-red-600">이미지 삭제</button>
      </div>

      <%-- 새 이미지 첨부 --%>
      <label class="block text-xs text-gray-400 mb-1">사진 첨부 (선택, 최대 10MB)</label>
      <input type="file" id="editImgFile" accept="image/*"
             class="block w-full text-xs text-gray-500 mb-3
                  file:mr-3 file:py-1 file:px-3 file:rounded-lg file:border-0
                  file:text-xs file:font-semibold file:bg-indigo-50 file:text-indigo-600
                  hover:file:bg-indigo-100"
             onchange="previewEditImg(this)">
      <%-- 이미지 삭제 요청 여부 전달용 hidden 필드 --%>
      <input type="hidden" id="editRemoveImg" value="false">

      <p id="editMsg" class="text-xs text-red-400 mb-3 hidden"></p>

      <div class="flex gap-2">
        <button onclick="submitEdit()"
                class="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold py-2 rounded-xl transition">
          수정하기
        </button>
        <button onclick="closeEditModal()"
                class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm font-semibold py-2 rounded-xl transition">
          취소
        </button>
      </div>
    </div>
  </div>

  <%-- ── 하단 고정 예약 바 ── --%>
  <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50">
    <div class="max-w-4xl mx-auto px-4 h-16 flex items-center justify-between">
      <div>
        <p class="text-xs text-gray-400">${branch.partnerName}</p>
        <p class="font-bold text-gray-800 text-sm">${branch.brnName}</p>
      </div>
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <a href="#" onclick="document.getElementById('spaceSection').scrollIntoView({behavior:'smooth'}); return false;"
             class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold
                          px-6 py-2.5 rounded-xl text-sm transition">
            공간 선택하기 ↑
          </a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/loginPage"
             class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold
                          px-6 py-2.5 rounded-xl text-sm transition">
            로그인 후 예약
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <script>
    const CTX         = '${pageContext.request.contextPath}';


    const BRANCH_IDX  = ${branch.brnIdx};
    const LAT         = '${branch.brnLatitude}';
    const LNG         = '${branch.brnLongitude}';
    const BRANCH_NAME = '${branch.brnName}';
    // 로그인 사용자 번호 (비로그인이면 0) — 신고/삭제 기능에서 r.userIdx와 비교
    const LOGIN_USER_IDX = ${not empty sessionScope.loginUser ? sessionScope.loginUser.userIdx : 0};

    /* ── 탭 전환 ── */
    function switchTab(id, btn) {
      document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      document.getElementById('tab-' + id).classList.add('active');
      btn.classList.add('active');

      if (id === 'map') initMap();       // 지도 탭 열릴 때만 초기화
    }

    /* ── 카카오맵 초기화 (탭이 열릴 때만 실행) ── */
    var map = null;
    var ps  = null;
    var activeMarkers = {};   // { 'CS': [marker, marker, ...], 'FD6': [...] }
    var infowindow    = null;
    var mapInitialized = false;

    function initMap() {
      if (mapInitialized) return;   // 이미 초기화됐으면 스킵
      //콜백처리
      kakao.maps.load(function (){
        mapInitialized = true;

        infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

        var mapContainer = document.getElementById('kakaoMap');
        var mapOption    = {
          center: new kakao.maps.LatLng(LAT, LNG), // 카카오맵 검색
          level: 4
        };
        map = new kakao.maps.Map(mapContainer, mapOption);
        ps  = new kakao.maps.services.Places(map);

        // 지점 마커 색깔 변경을위한 설정
        var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 별 모양이나 다른 색상 이미지
        var imageSize = new kakao.maps.Size(24, 35);
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

        // 지점 자체 마커
        new kakao.maps.Marker({
          map: map,
          position: new kakao.maps.LatLng(LAT, LNG),
          title: BRANCH_NAME,
          image: markerImage,
          zIndex: 10 // 주변 시설 마커(기본 0)보다 항상 위에 표시됨
        });
      });  //콜백 끝
    }

    /*
     * 카테고리별 커스텀 마커 이미지 정의
     * SVG를 Base64로 인코딩 → 외부 서버 없이 바로 사용 가능
     * 원 배경색(fill)만 바꾸면 새 카테고리 추가도 쉬움
     */
    function makeSvgMarker(emoji, bgColor) {
      // 이모지 + 배경색으로 32×38px 마커 SVG 생성
      var svg = [
        '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="38" viewBox="0 0 32 38">',
        '  <path d="M16 0C9.4 0 4 5.4 4 12c0 8.4 12 26 12 26S28 20.4 28 12C28 5.4 22.6 0 16 0z" fill="' + bgColor + '"/>',
        '  <circle cx="16" cy="12" r="10" fill="white" opacity="0.9"/>',
        '  <text x="16" y="17" text-anchor="middle" font-size="12">' + emoji + '</text>',
        '</svg>'
      ].join('');
      var encoded = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
      return new kakao.maps.MarkerImage(
              encoded,
              new kakao.maps.Size(32, 38),
              { offset: new kakao.maps.Point(16, 38) } // 마커 하단 꼭짓점이 좌표에 오도록
      );
    }

    // 카테고리 코드 → { 이모지, 배경색 } 매핑
    var CATEGORY_STYLE = {
      CS2: { emoji: '🏪', color: '#f59e0b' }, // 편의점 — 주황
      FD6: { emoji: '🍽️', color: '#ef4444' }, // 음식점 — 빨강
      PM9: { emoji: '🏥', color: '#10b981' }, // 약국   — 초록
      BK9: { emoji: '🏦', color: '#3b82f6' }, // 은행   — 파랑
      SW8: { emoji: '🚌', color: '#8b5cf6' }, // 교통   — 보라
      PK6: { emoji: '🅿️', color: '#64748b' }  // 주차   — 회색
    };

    /* ── 카테고리 마커 토글 ── */
    function toggleMarkers(category, show) {
      if (show) {
        // 이미 검색한 카테고리면 재사용
        if (activeMarkers[category]) {
          activeMarkers[category].forEach(m => m.setMap(map));
          return;
        }

        // 카테고리별 커스텀 마커 이미지 생성
        var style      = CATEGORY_STYLE[category] || { emoji: '📍', color: '#6366f1' };
        var markerImg  = makeSvgMarker(style.emoji, style.color);

        // 카테고리 검색시 검색범위 및 개수 제한
        var searchOptions = {
          location: new kakao.maps.LatLng(LAT, LNG),
          radius: 500,
          size: 10
        };

        // 처음 검색
        ps.categorySearch(category, function(data, status) {
          if (status !== kakao.maps.services.Status.OK) return;
          activeMarkers[category] = [];
          data.forEach(place => {
            var marker = new kakao.maps.Marker({
              map: map,
              position: new kakao.maps.LatLng(place.y, place.x),
              image: markerImg   // 카테고리별 커스텀 이미지 적용
            });

            kakao.maps.event.addListener(marker, 'click', function() {
              infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
              infowindow.open(map, marker);
            });
            activeMarkers[category].push(marker);
          });
        }, searchOptions);
      } else {
        // 마커 숨기기
        if (activeMarkers[category]) {
          activeMarkers[category].forEach(m => m.setMap(null));
        }
      }
    }

    /* ── 카테고리 버튼 클릭 hover 색 처리 ── */
    const STATE = {
      active:   'border-blue-500 bg-blue-500 text-white',
      inactive: 'border-gray-300 bg-white text-gray-700'
    };

    document.querySelectorAll('.category-btn').forEach(btn => {
      // 페이지 로딩시 버튼 활성화 속성 초기화
      btn.classList.add(...STATE.inactive.split(' '));
      //클릭시 처리
      btn.addEventListener('click', function () {
        // 클릭한 버튼의 속성을 isActive에 저장후 반대속성으로 변경
        const isActive = this.dataset.active === 'true';
        this.dataset.active = !isActive; // 속성을 추가하고 비활성화

        const remove = isActive ? STATE.active   : STATE.inactive;
        const add    = isActive ? STATE.inactive : STATE.active;
        this.classList.remove(...remove.split(' '));
        this.classList.add(...add.split(' '));

        toggleMarkers(this.dataset.category, !isActive);
      });
    });

    /* ── 이용후기 로드 (AJAX) ── */
    let currentPage = 1;
    function loadReviews(page) {
      currentPage = page;
      $('#reviewContainer').html('<p class="text-center text-gray-400 py-10 text-sm">불러오는 중...</p>');
      $.ajax({
        url: CTX + '/review/list',
        type: 'GET',
        data: { brnIdx: BRANCH_IDX, page: page },
        dataType: 'json',
        success: function(data) {
          renderReviews(data);
        },
        error: function() {
          $('#reviewContainer').html('<p class="text-center text-red-400 py-6 text-sm">후기를 불러올 수 없습니다.</p>');
        }
      });
    }

    function renderReviews(data) {
      const pg = data.paging;
      currentPage = pg.nowPage;

      // 평균 별점 + 댓글 수 업데이트
      const statsEl = document.getElementById('reviewStats');
      if (pg.totalRecord > 0) {
        statsEl.innerHTML = '<span class="text-gray-500">평균</span>'
                + ' <span class="font-semibold text-indigo-600">' + data.avgRating.toFixed(1) + '점</span>'
                + ' <span class="text-gray-300">•</span>'
                + ' <span>총 ' + pg.totalRecord + '건</span>';
      } else {
        statsEl.innerHTML = '';
      }

      const container = document.getElementById('reviewContainer');
      if (!data.reviews || data.reviews.length === 0) {
        container.innerHTML = '<p class="text-center text-gray-400 py-10 text-sm">아직 이용후기가 없습니다. 첫 번째 후기를 남겨보세요!</p>';
        return;
      }

      let html = '<div class="space-y-4">';
      data.reviews.forEach(r => {
        html += renderReview(r);
      });
      html += '</div>';

      // 페이지네이션
      if (pg.totalPage > 1) {
        html += '<div class="flex justify-center items-center gap-1 mt-6">';
        if (pg.beginBlock > 1) {
          html += '<button onclick="loadReviews(' + (pg.beginBlock - 1) + ')" class="px-2 py-1 text-sm text-gray-400 hover:text-indigo-600">◀</button>';
        }
        for (let p = pg.beginBlock; p <= pg.endBlock; p++) {
          const active = p === pg.nowPage
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white text-gray-600 hover:bg-indigo-50';
          html += '<button onclick="loadReviews(' + p + ')" class="' + active + ' w-8 h-8 rounded-lg text-sm font-semibold border border-gray-200 transition">' + p + '</button>';
        }
        if (pg.endBlock < pg.totalPage) {
          html += '<button onclick="loadReviews(' + (pg.endBlock + 1) + ')" class="px-2 py-1 text-sm text-gray-400 hover:text-indigo-600">▶</button>';
        }
        html += '</div>';
      }

      container.innerHTML = html;
    }

    function renderReview(r) {
      const stars    = renderStars(r.revRating);
      const date     = r.revCreatedAt ? r.revCreatedAt.substring(0, 10) : '';
      const spaceTag = r.spaceName
              ? `<span class="text-xs bg-indigo-50 text-indigo-500 px-2 py-0.5 rounded-full">\${esc(r.spaceName)}</span>`
              : '';

      // 신고 버튼: 로그인한 사용자에게만 표시 (단, 본인 글은 신고 불가)
      const reportBtn = (LOGIN_USER_IDX > 0 && LOGIN_USER_IDX !== r.userIdx)
              ? `<button onclick="openReportModal(\${r.revIdx})"
                       class="text-xs text-gray-300 hover:text-red-400 transition ml-2"
                       title="부적절한 리뷰 신고">신고</button>`
              : '';

      // 삭제/수정 버튼: 본인이 작성한 리뷰에만 표시
      const deleteBtn = (LOGIN_USER_IDX > 0 && LOGIN_USER_IDX === r.userIdx)
              ? `<button onclick="deleteReview(\${r.revIdx}, this)"
                       class="text-xs text-gray-300 hover:text-red-500 transition ml-2"
                       title="리뷰 삭제">삭제</button>`
              : '';
      // data 속성에 값을 저장 → onclick 안에 따옴표 충돌 없이 안전하게 전달
      const editBtn = (LOGIN_USER_IDX > 0 && LOGIN_USER_IDX === r.userIdx)
              ? `<button onclick="openEditModal(this)"
                       data-rev-idx="\${r.revIdx}"
                       data-content="\${esc(r.revContent)}"
                       data-rating="\${r.revRating}"
                       data-img="\${r.revImg ? esc(r.revImg) : ''}"
                       class="text-xs text-gray-300 hover:text-indigo-500 transition ml-2"
                       title="리뷰 수정">수정</button>`
              : '';

      // 신고 3회 이상이면 블라인드 처리
      // 블라인드 상태: "블라인드 처리된 리뷰입니다" 버튼만 표시
      // 클릭하면 욕설은 블러, 나머지는 원문 그대로 공개
      const isBlinded = r.reportCount >= 3;
      const contentHtml = isBlinded
              ? `<div class="blind-wrapper">
                   <button class="blind-toggle w-full text-left text-sm text-gray-400
                                  bg-gray-100 hover:bg-gray-200 rounded-xl px-4 py-3 transition
                                  flex items-center gap-2"
                           onclick="toggleBlind(this)">
                       <span>🚫</span>
                       <span>신고가 누적된 리뷰입니다. 클릭하면 내용을 볼 수 있습니다.</span>
                   </button>
                   <div class="blind-content hidden mt-2">
                       <p class="text-sm text-gray-600">\${censorContent(r.revContent)}</p>
                   </div>
               </div>`
              : `<p class="text-sm text-gray-600">\${censorContent(r.revContent)}</p>`;

      // 리뷰 이미지: 서버에 저장된 파일명을 /static/upload/review/ 경로로 표시
      const imgHtml = r.revImg
              ? `<img src="\${CTX}/static/upload/review/\${esc(r.revImg)}"
                    alt="리뷰 이미지"
                    class="mt-3 max-h-48 rounded-xl object-cover border border-gray-100"
                    onerror="this.style.display='none'">`
              : '';

      let html = `
        <div class="bg-white rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2 flex-wrap">
                    <span class="font-semibold text-sm text-gray-800">\${esc(r.authorName)}</span>
                    \${spaceTag}
                    <span class="text-xs text-gray-400">\${date}</span>
                    \${reportBtn}
                    \${editBtn}
                    \${deleteBtn}
                </div>
                <span class="text-sm">\${stars}</span>
            </div>
            \${contentHtml}
            \${imgHtml}`;

      // 답글
      if (r.replies && r.replies.length > 0) {
        r.replies.forEach(reply => {
          const rDate = reply.revCreatedAt ? reply.revCreatedAt.substring(0, 10) : '';
          html += `
            <div class="mt-3 ml-4 pl-4 border-l-2 border-indigo-100 bg-indigo-50 rounded-xl p-3">
                <div class="flex items-center gap-2 mb-1">
                    <span class="text-xs font-bold text-indigo-700 bg-indigo-100 px-2 py-0.5 rounded-full">파트너</span>
                    <span class="text-xs font-semibold text-gray-700">\${esc(reply.authorName)}</span>
                    <span class="text-xs text-gray-400">\${rDate}</span>
                </div>
                <p class="text-xs text-gray-600">\${censorContent(reply.revContent)}</p>
            </div>`;
        });
      }

      html += '</div>';
      return html;
    }

    function renderStars(rating) {
      if (!rating) return '';
      let s = '';
      for (let i = 1; i <= 5; i++) {
        s += i <= rating ? '<span class="star-filled">★</span>' : '<span class="star-empty">★</span>';
      }
      return s;
    }

    function esc(str) {
      if (!str) return '';
      return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    /* ── 리뷰 등록 AJAX ── */
    function submitReview() {
      const spcIdxEl = document.getElementById('reviewSpcIdx');
      const content  = document.getElementById('reviewContent').value.trim();
      const rating   = parseInt(document.getElementById('reviewRating').value);
      const imgFile  = document.getElementById('reviewImgFile');

      if (!rating)  { showReviewMsg('별점을 선택해주세요.', false);   return; }
      if (!content) { showReviewMsg('후기 내용을 입력해주세요.', false); return; }

      // 파일 크기 10MB 제한
      if (imgFile && imgFile.files.length > 0 && imgFile.files[0].size > 10 * 1024 * 1024) {
        showReviewMsg('이미지는 10MB 이하만 첨부할 수 있습니다.', false);
        return;
      }

      // FormData: 텍스트 + 파일을 multipart/form-data 로 함께 전송
      const formData = new FormData();
      formData.append('spcIdx',  spcIdxEl.value);
      formData.append('content', content);
      formData.append('rating',  rating);
      if (imgFile && imgFile.files.length > 0) {
        formData.append('imgFile', imgFile.files[0]);
      }

      // CSRF 토큰을 헤더로 전달 (Spring Security 기본 방식)
      const csrfToken  = document.querySelector('meta[name="_csrf"]').getAttribute('content');
      const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

      $.ajax({
        url:         CTX + '/review/write',
        type:        'POST',
        data:        formData,
        dataType:    'json',
        // FormData 사용 시 jQuery가 Content-Type을 자동 설정하도록 false 지정
        processData: false,
        contentType: false,
        beforeSend: function(xhr) {
          xhr.setRequestHeader(csrfHeader, csrfToken);
        },
        success: function(res) {
          if (res.success) {
            showReviewMsg('후기가 등록되었습니다.', true);
            document.getElementById('reviewContent').value = '';
            document.getElementById('reviewImgFile').value = '';
            setRating(0);
            loadReviews(1); // 목록 새로고침
          } else {
            showReviewMsg(res.message || '등록에 실패했습니다.', false);
          }
        },
        error: function() { showReviewMsg('오류가 발생했습니다.', false); }
      });
    }

    function showReviewMsg(msg, ok) {
      const el = document.getElementById('reviewMsg');
      el.textContent = msg;
      el.className = 'text-xs mt-2 ' + (ok ? 'text-green-500' : 'text-red-400');
      el.classList.remove('hidden');
    }

    // 별점 초기화 (0점 = 미선택 상태)
    function setRating(val) {
      document.getElementById('reviewRating').value = val;
      document.querySelectorAll('.star-btn').forEach(btn => {
        btn.classList.toggle('text-yellow-400', val > 0 && btn.dataset.val <= val);
        btn.classList.toggle('text-gray-300',   val === 0 || btn.dataset.val > val);
      });
      const labels = ['별점을 선택해주세요', '별로예요', '그냥저냥', '괜찮아요', '좋아요', '최고예요'];
      const labelEl = document.getElementById('ratingLabel');
      if (labelEl) labelEl.textContent = labels[val] || '';
    }

    // 블라인드 리뷰 토글: 버튼 클릭 시 숨겨진 원문을 보여줌
    function toggleBlind(btn) {
      const content = btn.closest('.blind-wrapper').querySelector('.blind-content');
      content.classList.toggle('hidden');
      // 버튼 텍스트 변경
      const label = btn.querySelector('span:last-child');
      if (content.classList.contains('hidden')) {
        label.textContent = '신고가 누적된 리뷰입니다. 클릭하면 내용을 볼 수 있습니다.';
      } else {
        label.textContent = '내용 접기';
      }
    }

    /**
     * 욕설 블러 렌더링
     * 서버에서 badWordFiltering.change()로 치환된 * 연속 패턴을
     * 클릭 가능한 블러 span으로 감쌈
     * 클릭 시 .revealed 클래스 토글로 블러 해제
     */
    function censorContent(str) {
      if (!str) return '';
      // 1) HTML 이스케이프 먼저 (XSS 방지)
      const escaped = esc(str);
      // 2) 연속된 * 패턴 → 빨간 배지로 교체
      //    onclick 대신 인라인 스타일만 사용 (브라우저가 innerHTML의 onclick을 차단하는 경우 대비)
      return escaped.replace(/\*+/g, () =>
              '<span style="display:inline-block;background:#fee2e2;color:#ef4444;' +
              'border:1px solid #fca5a5;border-radius:4px;padding:0 5px;' +
              'font-size:0.75em;font-weight:bold;vertical-align:middle;">' +
              '🚫 비속어</span>'
      );
    }

    /* ── 페이지 로드 시 후기 자동 로드 ── */
    document.addEventListener('DOMContentLoaded', () => loadReviews(1));

    /* ──────────────────────────────────────────
       리뷰 삭제 기능
    ────────────────────────────────────────── */
    /**
     * 본인 리뷰 삭제 AJAX
     * @param revIdx - 삭제할 리뷰 번호
     * @param btn    - 클릭된 버튼 (삭제 후 해당 카드를 화면에서 제거하기 위해 사용)
     */
    function deleteReview(revIdx, btn) {
      if (!confirm('리뷰를 삭제하시겠습니까?')) return;

      $.post(CTX + '/review/delete', { revIdx: revIdx }, function(res) {
        if (res.success) {
          // 버튼의 가장 가까운 리뷰 카드(bg-white rounded-2xl)를 찾아서 제거
          const card = btn.closest('.bg-white.rounded-2xl');
          if (card) card.remove();
        } else {
          alert(res.message || '삭제에 실패했습니다.');
        }
      });
    }

    /* ──────────────────────────────────────────
       리뷰 신고 기능
    ────────────────────────────────────────── */
    let reportTargetIdx = 0; // 현재 신고 대상 리뷰 번호

    /** 신고 모달 열기 */
    function openReportModal(vIdx) {
      reportTargetIdx = vIdx;
      document.getElementById('reportMsg').classList.add('hidden');
      document.getElementById('reportModal').classList.remove('hidden');
    }

    /** 신고 모달 닫기 (배경 클릭 또는 취소 버튼) */
    function closeReportModal(event) {
      // event가 있으면 배경 클릭인지 확인 (이미 stopPropagation으로 내부 클릭은 차단됨)
      document.getElementById('reportModal').classList.add('hidden');
      reportTargetIdx = 0;
    }

    /** 신고 제출 */
    function submitReport() {
      if (reportTargetIdx === 0) return;

      const reason = document.getElementById('reportReason').value;
      const msgEl  = document.getElementById('reportMsg');

      $.ajax({
        url:      CTX + '/review/report',
        type:     'POST',
        data:     { revIdx: reportTargetIdx, reason: reason },
        dataType: 'json',
        success: function(res) {
          if (res.success) {
            // 성공 시 모달 닫고 간단한 완료 표시
            document.getElementById('reportModal').classList.add('hidden');
            alert(res.message); // 더 나은 UX를 원하면 토스트로 교체 가능
          } else {
            // 실패 사유를 모달 내부에 표시
            msgEl.textContent = res.message;
            msgEl.classList.remove('hidden');
          }
        },
        error: function() {
          msgEl.textContent = '서버 오류가 발생했습니다.';
          msgEl.classList.remove('hidden');
        }
      });
    }

    /* ──────────────────────────────────────────
       리뷰 수정 기능
    ────────────────────────────────────────── */
    let editTargetIdx = 0; // 현재 수정 대상 리뷰 번호

    /**
     * 수정 모달 열기
     * @param revIdx  - 수정할 리뷰 번호
     * @param content - 기존 내용 (esc() 처리된 문자열)
     * @param rating  - 기존 별점 (1~5)
     */
    // btn: 클릭된 수정 버튼 요소 — data 속성에서 값을 읽어옴
    function openEditModal(btn) {
      editTargetIdx = parseInt(btn.dataset.revIdx);
      const content = btn.dataset.content || '';
      const rating  = parseInt(btn.dataset.rating) || 0;
      const img     = btn.dataset.img || ''; // 기존 이미지 파일명

      // esc()로 HTML 엔티티 처리된 값을 원래 문자로 복원
      const textarea = document.getElementById('editContent');
      textarea.value = content.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"');
      setEditRating(rating);

      // 이미지 관련 초기화
      document.getElementById('editImgFile').value = '';
      document.getElementById('editRemoveImg').value = 'false';

      // 기존 이미지가 있으면 미리보기 표시
      const previewWrap = document.getElementById('editImgPreviewWrap');
      const preview     = document.getElementById('editImgPreview');
      if (img) {
        preview.src = CTX + '/static/upload/review/' + img;
        previewWrap.classList.remove('hidden');
      } else {
        previewWrap.classList.add('hidden');
        preview.src = '';
      }

      document.getElementById('editMsg').classList.add('hidden');
      document.getElementById('editModal').classList.remove('hidden');
    }

    /** 수정 모달 닫기 */
    function closeEditModal() {
      document.getElementById('editModal').classList.add('hidden');
      document.getElementById('editImgFile').value = '';
      document.getElementById('editImgPreviewWrap').classList.add('hidden');
      document.getElementById('editRemoveImg').value = 'false';
      editTargetIdx = 0;
    }

    /** 수정 모달 - 새 이미지 선택 시 미리보기 갱신 */
    function previewEditImg(input) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
          const preview = document.getElementById('editImgPreview');
          preview.src   = e.target.result;
          document.getElementById('editImgPreviewWrap').classList.remove('hidden');
          // 새 파일을 선택했으므로 삭제 플래그 해제
          document.getElementById('editRemoveImg').value = 'false';
        };
        reader.readAsDataURL(input.files[0]);
      }
    }

    /** 수정 모달 - 이미지 삭제 버튼: 서버에 removeImg=true 전달 */
    function removeEditImg() {
      document.getElementById('editImgFile').value = '';
      document.getElementById('editImgPreviewWrap').classList.add('hidden');
      document.getElementById('editImgPreview').src = '';
      // 서버에서 v_img를 비워달라는 신호
      document.getElementById('editRemoveImg').value = 'true';
    }

    /** 수정 모달 별점 설정 */
    function setEditRating(val) {
      document.getElementById('editRating').value = val;
      document.querySelectorAll('.edit-star-btn').forEach(btn => {
        btn.classList.toggle('text-yellow-400', val > 0 && btn.dataset.val <= val);
        btn.classList.toggle('text-gray-300',   val === 0 || btn.dataset.val > val);
      });
    }

    /** 수정 제출 */
    function submitEdit() {
      if (editTargetIdx === 0) return;
      const content   = document.getElementById('editContent').value.trim();
      const rating    = parseInt(document.getElementById('editRating').value);
      const msgEl     = document.getElementById('editMsg');
      const imgFile   = document.getElementById('editImgFile');
      const removeImg = document.getElementById('editRemoveImg').value;

      if (!rating)  { msgEl.textContent = '별점을 선택해주세요.'; msgEl.classList.remove('hidden'); return; }
      if (!content) { msgEl.textContent = '내용을 입력해주세요.';  msgEl.classList.remove('hidden'); return; }

      // 파일 크기 10MB 제한
      if (imgFile && imgFile.files.length > 0 && imgFile.files[0].size > 10 * 1024 * 1024) {
        msgEl.textContent = '이미지는 10MB 이하만 첨부할 수 있습니다.';
        msgEl.classList.remove('hidden');
        return;
      }

      // 파일 업로드가 있으므로 FormData로 전송 (write와 동일한 방식)
      const formData = new FormData();
      formData.append('revIdx',     editTargetIdx);
      formData.append('content',    content);
      formData.append('rating',     rating);
      formData.append('removeImg',  removeImg); // 'true' 이면 서버에서 이미지 삭제
      if (imgFile && imgFile.files.length > 0) {
        formData.append('imgFile', imgFile.files[0]);
      }

      const csrfToken  = document.querySelector('meta[name="_csrf"]').getAttribute('content');
      const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

      $.ajax({
        url:         CTX + '/review/update',
        type:        'POST',
        data:        formData,
        processData: false,
        contentType: false,
        beforeSend:  function(xhr) { xhr.setRequestHeader(csrfHeader, csrfToken); },
        dataType:    'json',
        success: function(res) {
          if (res.success) {
            closeEditModal();
            loadReviews(currentPage); // 현재 페이지 그대로 새로고침
          } else {
            msgEl.textContent = res.message || '수정에 실패했습니다.';
            msgEl.classList.remove('hidden');
          }
        },
        error: function() {
          msgEl.textContent = '서버 오류가 발생했습니다.';
          msgEl.classList.remove('hidden');
        }
      });
    }

    /* ──────────────────────────────────────────
       장기 계약 문의 제출
    ────────────────────────────────────────── */
    function submitContact() {
      const content    = document.getElementById('ctContent').value.trim();
      const startDate  = document.getElementById('ctStartDate').value;
      const duration   = document.getElementById('ctDuration').value;
      const headcount  = document.getElementById('ctHeadcount').value;
      const msgEl      = document.getElementById('contactMsg');

      // 필수 항목 체크 (서버에서도 검증하지만 UX를 위해 사전 체크)
      if (!content) {
        msgEl.textContent = '문의 내용을 입력해주세요.';
        msgEl.className = 'text-sm text-center text-red-400';
        msgEl.classList.remove('hidden');
        return;
      }

      $.ajax({
        url:      CTX + '/contact/write',
        type:     'POST',
        data: {
          brnIdx:       BRANCH_IDX,
          cntStartDate: startDate,
          cntDuration:  duration,
          cntHeadcount: headcount || 1, // 미입력 시 기본값 1
          cntContent:   content
        },
        dataType: 'json',
        success: function(res) {
          msgEl.textContent = res.message;
          if (res.success) {
            // 성공: 초록색 메시지 + 폼 초기화
            msgEl.className = 'text-sm text-center text-green-500';
            document.getElementById('ctContent').value   = '';
            document.getElementById('ctStartDate').value = '';
            document.getElementById('ctDuration').value  = '';
            document.getElementById('ctHeadcount').value = '';
          } else {
            msgEl.className = 'text-sm text-center text-red-400';
          }
          msgEl.classList.remove('hidden');
        },
        error: function() {
          msgEl.textContent = '서버 오류가 발생했습니다.';
          msgEl.className = 'text-sm text-center text-red-400';
          msgEl.classList.remove('hidden');
        }
      });
    }

    /* ────────────────────────────────────────────
       영업시간 파싱 → 현재 영업중/종료 뱃지 표시
       ──────────────────────────────────────────── */
    (function () {
      var badge = document.getElementById('hoursStatusBadge');
      if (!badge) return;

      // brnHours는 줄바꿈 포함 텍스트라 JS 문자열에 직접 주입하면 문법 오류 발생
      // → hoursStatusBadge의 data 속성에서 읽지 않고, 별도 hidden 요소의 textContent로 전달
      var dataEl = document.getElementById('branchHoursData');
      if (!dataEl) return;
      var hoursText = dataEl.textContent;
      if (!hoursText.trim()) return;

      var now   = new Date();
      var day   = now.getDay();          // 0=일, 1=월~5=금, 6=토
      var hhmm  = now.getHours() * 100 + now.getMinutes(); // e.g. 1430 = 14:30

      // ① 24시간 연중무휴 처리
      if (hoursText.indexOf('24시간') !== -1) {
        badge.innerHTML = '<span class="text-xs font-semibold text-green-600 bg-green-50 border border-green-200 rounded-full px-2 py-0.5">영업중</span>';
        return;
      }

      // ② 오늘 요일에 해당하는 줄을 찾아 시간 범위 파싱
      // 우선순위: 구체적 요일(토요일/일요일) > 평일/주말 > 접두어 없는 단독 시간
      var lines = hoursText.split('\n');

      // 오늘 요일 → 한글 키워드 매핑 (우선순위 순서)
      var keywords;
      if (day === 0)                       keywords = ['일요일', '주말'];
      else if (day >= 1 && day <= 5)       keywords = ['평일'];
      else                                 keywords = ['토요일', '주말'];

      var matched = null;

      // 우선순위 키워드 순서대로 매칭 시도
      for (var ki = 0; ki < keywords.length; ki++) {
        for (var li = 0; li < lines.length; li++) {
          if (lines[li].indexOf(keywords[ki]) !== -1) {
            matched = lines[li];
            break;
          }
        }
        if (matched) break;
      }

      // 키워드 매칭 실패 시, 요일 접두어 없이 시간만 있는 줄 시도 (예: "09:00 ~ 22:00")
      if (!matched) {
        var timeOnlyRe = /^\s*\d{2}:\d{2}\s*~\s*\d{2}:\d{2}\s*$/;
        for (var li2 = 0; li2 < lines.length; li2++) {
          if (timeOnlyRe.test(lines[li2])) {
            matched = lines[li2];
            break;
          }
        }
      }

      if (!matched) return; // 매칭 실패 → 뱃지 없음

      // ③ 휴무 체크
      if (matched.indexOf('휴무') !== -1) {
        badge.innerHTML = '<span class="text-xs font-semibold text-gray-500 bg-gray-100 border border-gray-200 rounded-full px-2 py-0.5">오늘 휴무</span>';
        return;
      }

      // ④ 시간 범위 추출: "HH:MM ~ HH:MM"
      var timeRe = /(\d{2}):(\d{2})\s*~\s*(\d{2}):(\d{2})/;
      var m = matched.match(timeRe);
      if (!m) return;

      var openTime  = parseInt(m[1]) * 100 + parseInt(m[2]);
      var closeTime = parseInt(m[3]) * 100 + parseInt(m[4]);
      var isOpen    = hhmm >= openTime && hhmm < closeTime;

      if (isOpen) {
        badge.innerHTML = '<span class="text-xs font-semibold text-green-600 bg-green-50 border border-green-200 rounded-full px-2 py-0.5">영업중</span>';
      } else {
        badge.innerHTML = '<span class="text-xs font-semibold text-red-500 bg-red-50 border border-red-200 rounded-full px-2 py-0.5">영업종료</span>';
      }
    })();

  </script>

  <script>
    // 첫 번째 스크립트에서도 사진이 없을 때 첫 번째 사진을 가져오도록 동일하게 수정했어!
    (function() {
      let recent = JSON.parse(localStorage.getItem('recentBranches')) || [];

      let currentBranch = {
        brnIdx: '${branch.brnIdx}',
        brnName: '${branch.brnName}',
        mainImgUrl: '${branch.mainImgUrl != null ? branch.mainImgUrl : (not empty branch.images ? branch.images[0].biUrl : "")}',
        brnAddress: '${branch.brnAddress}',
        // [추가] 최근 본 지점에도 아이콘이 뜨도록 시설 정보도 함께 저장합니다
        facWifi: '${branch.facWifi != null ? branch.facWifi : (not empty branch.spaces ? branch.spaces[0].facilities.facWifi : "0")}',
        facParking: '${branch.facParking != null ? branch.facParking : (not empty branch.spaces ? branch.spaces[0].facilities.facParking : "0")}',
        facCoffee: '${branch.facCoffee != null ? branch.facCoffee : (not empty branch.spaces ? branch.spaces[0].facilities.facCoffee : "0")}',
        facHours24: '${branch.facHours24 != null ? branch.facHours24 : (not empty branch.spaces ? branch.spaces[0].facilities.facHours24 : "0")}',
        facPet: '${branch.facPet != null ? branch.facPet : (not empty branch.spaces ? branch.spaces[0].facilities.facPet : "0")}'
      };

      if(!currentBranch.brnIdx) return;

<<<<<<< HEAD
      recent = recent.filter(b => b.brnIdx !== currentBranch.brnIdx);
=======
    let currentBranch = {
      brnIdx: '${branch.brnIdx}',
      brnName: '${branch.brnName}',
      mainImgUrl: '${branch.mainImgUrl != null ? branch.mainImgUrl : (not empty branch.images ? branch.images[0].biUrl : "")}',
      brnAddress: '${branch.brnAddress}',
      facWifi:     '${branch.facWifi     != null ? branch.facWifi     : (not empty branch.spaces ? branch.spaces[0].facilities.facWifi     : "0")}',
      facParking:  '${branch.facParking  != null ? branch.facParking  : (not empty branch.spaces ? branch.spaces[0].facilities.facParking  : "0")}',
      facCoffee:   '${branch.facCoffee   != null ? branch.facCoffee   : (not empty branch.spaces ? branch.spaces[0].facilities.facCoffee   : "0")}',
      facHours24:  '${branch.facHours24  != null ? branch.facHours24  : (not empty branch.spaces ? branch.spaces[0].facilities.facHours24  : "0")}',
      facPet:      '${branch.facPet      != null ? branch.facPet      : (not empty branch.spaces ? branch.spaces[0].facilities.facPet      : "0")}'
    };
>>>>>>> 232e2b3883b98d8c239dbd1817c6d050bb9cc5a8

      recent.unshift(currentBranch);

      if(recent.length > 5) {
        recent.pop();
      }

      localStorage.setItem('recentBranches', JSON.stringify(recent));
    })();
  </script>

  <script>
    <%-- 두 번째 중복 스크립트에도 똑같이 사진을 가져오는 코드를 넣어줬어! --%>
    (function() {
      let recent = JSON.parse(localStorage.getItem('recentBranches')) || [];

      let currentBranch = {
        brnIdx: '${branch.brnIdx}',
        brnName: '${branch.brnName}',
        mainImgUrl: '${branch.mainImgUrl != null ? branch.mainImgUrl : (not empty branch.images ? branch.images[0].biUrl : "")}',
        brnAddress: '${branch.brnAddress}',
        // [추가] 두 번째 스크립트에도 똑같이 시설 정보를 추가해서 저장합니다
        facWifi: '${branch.facWifi != null ? branch.facWifi : (not empty branch.spaces ? branch.spaces[0].facilities.facWifi : "0")}',
        facParking: '${branch.facParking != null ? branch.facParking : (not empty branch.spaces ? branch.spaces[0].facilities.facParking : "0")}',
        facCoffee: '${branch.facCoffee != null ? branch.facCoffee : (not empty branch.spaces ? branch.spaces[0].facilities.facCoffee : "0")}',
        facHours24: '${branch.facHours24 != null ? branch.facHours24 : (not empty branch.spaces ? branch.spaces[0].facilities.facHours24 : "0")}',
        facPet: '${branch.facPet != null ? branch.facPet : (not empty branch.spaces ? branch.spaces[0].facilities.facPet : "0")}'
      };

      if (!currentBranch.brnIdx) return;

      // 중복 제거 후 맨 앞에 추가
      recent = recent.filter(b => b.brnIdx !== currentBranch.brnIdx);
      recent.unshift(currentBranch);

      // 최대 4개 유지
      if (recent.length > 5) recent.pop();

      localStorage.setItem('recentBranches', JSON.stringify(recent));
    })();
  </script>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
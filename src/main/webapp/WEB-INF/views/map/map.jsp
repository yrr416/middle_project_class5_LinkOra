<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 공통 헤더 포함 --%>
<%@ include file="../layout/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Link Ora | 프리미엄 오피스 지도</title>

  <style>
    /* 지도 페이지 전체 레이아웃 설정 */
    html, body { height: 100%; margin: 0; padding: 0; overflow: hidden; }

    /* 헤더 높이를 제외한 지도 영역 (80px 기준) */
    .map-container {
      position: relative;
      width: 100%;
      height: calc(100vh - 80px) !important;
      background-color: #f8f9fa;
    }

    #mainMap { width: 100%; height: 100%; }

    /* [수정] 검색창 레이아웃: 가로 폭 확장 및 위치 조정 */
    .map-search-overlay {
      position: absolute;
      top: 40px !important; /* 헤더 아래 여유 공간 */
      left: 50%;
      transform: translateX(-50%);
      z-index: 10;
    }

    /* [수정] 검색 박스 크기 대폭 확대 */
    .search-box {
      display: flex;
      align-items: center;
      background: white;
      width: 500px; /* 기존보다 가로 폭을 늘림 */
      max-width: 90vw; /* 모바일 대응용 최대 폭 */
      padding: 12px 25px; /* 내부 여백을 늘려 높이감과 공간 확보 */
      border-radius: 40px; /* 더 둥글고 세련된 디자인 */
      box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }

    /* [수정] 입력창 글자 크기 및 여백 조정 */
    #mapSearchInput {
      flex: 1;
      border: none;
      outline: none;
      font-size: 15px; /* 글자 크기를 키움 */
      font-weight: 500;
      margin-left: 10px;
    }

    /* 검색 버튼 크기 조정 */
    #mapSearchBtn {
      background: #007A8A;
      color: white;
      border: none;
      padding: 8px 20px;
      border-radius: 25px;
      cursor: pointer;
      font-size: 14px;
      font-weight: bold;
      transition: 0.3s;
      white-space: nowrap; /* 버튼 글자 잘림 방지 */
    }

    #mapSearchBtn:hover { background: #005f6b; }
  </style>

  <%-- 지도 전용 CSS --%>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/map.css">
</head>
<body>

<main class="map-container">
  <div class="map-search-overlay">
    <div class="search-box">
      <i class="fa-solid fa-magnifying-glass" style="color: #007A8A; font-size: 18px;"></i>
      <input type="text" id="mapSearchInput" placeholder="지점명, 지역 또는 역 이름을 입력하세요">
      <button id="mapSearchBtn">검색</button>
    </div>
  </div>

  <div id="mainMap"></div>

  <div class="chatbot-bubble" id="chatbotBtn" style="position: absolute; bottom: 30px; right: 30px; z-index: 10; cursor: pointer;">
    <div class="chatbot-text" style="background: white; padding: 8px 15px; border-radius: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); font-size: 12px; margin-bottom: 5px; font-weight: bold; color: #2F4F4F;">도움이 필요하신가요?</div>
    <div class="chatbot-icon" style="background: #2F4F4F; color: white; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; margin-left: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.2);"><i class="fa-solid fa-comment-dots"></i></div>
  </div>
</main>

<%-- 카카오 지도 SDK 로드 --%>
<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=247139c78458523e2ad17488def871c6&libraries=services&autoload=false"></script>

<script type="text/javascript">
  /**
   * 1. 지도 로딩 제어
   */
  (function initMapLoader() {
    if (window.kakao && window.kakao.maps) {
      kakao.maps.load(function() {
        const mapScript = document.createElement('script');
        mapScript.src = "${pageContext.request.contextPath}/js/map.js";
        document.body.appendChild(mapScript);
      });
    } else {
      setTimeout(initMapLoader, 100);
    }
  })();

  /**
   * 2. 사이드바 및 아코디언 메뉴 강제 활성화 (지도 페이지 특수 대응)
   */
  window.addEventListener('load', () => {
    const hamburger = document.querySelector('#hamburgerBtn');
    const sidebar = document.querySelector('#sidebar');
    const overlay = document.querySelector('#sidebarOverlay');
    const closeBtn = document.querySelector('#closeSidebar');

    if (hamburger && sidebar) {
      hamburger.onclick = () => {
        sidebar.classList.add('active');
        overlay.classList.add('active');
      };
    }

    if (closeBtn && overlay) {
      [closeBtn, overlay].forEach(el => {
        el.onclick = () => {
          sidebar.classList.remove('active');
          overlay.classList.remove('active');
        };
      });
    }

    // 아코디언 메뉴 클릭 시 하위 메뉴 열기 로직
    document.querySelectorAll('.accordion-toggle').forEach(toggle => {
      toggle.addEventListener('click', function(e) {
        e.preventDefault();
        const content = this.nextElementSibling;
        if (content) {
          const isVisible = content.style.display === 'block';
          content.style.display = isVisible ? 'none' : 'block';

          const arrow = this.querySelector('.arrow-icon');
          if (arrow) arrow.style.transform = isVisible ? 'rotate(0deg)' : 'rotate(180deg)';
        }
      });
    });
  });
</script>

</body>
</html>
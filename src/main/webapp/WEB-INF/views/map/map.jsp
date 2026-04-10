<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Link Ora | 프리미엄 오피스 지도</title>

  <link rel="icon" href="data:,">

  <%-- [외부 자원] 폰트와 아이콘을 불러옴 --%>
  <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <%-- [설정] 프로젝트 공통 스타일과 지도 전용 스타일임 --%>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/map.css">

  <style>
    /* 화면 높이를 100%로 고정하여 지도가 꽉 차게 함 */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
    }

    /* 헤더를 제외한 나머지 영역을 지도로 꽉 채우는 바구니임 */
    .map-container {
      display: block;
      position: relative;
      width: 100%;
      height: calc(100vh - 70px) !important;
      min-height: 500px;
      background-color: #f8f9fa;
    }

    /* 실제 카카오맵이 그려지는 도화지임 */
    #mainMap {
      width: 100%;
      height: 100%;
      min-height: 500px;
    }
  </style>
</head>
<body>

<%-- ==================== 헤더 영역임 ==================== --%>
<header class="map-header" style="height: 70px; background: #fff; border-bottom: 1px solid #eee;">
  <div class="header-inner" style="display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 100%;">
    <div class="header-left" style="display: flex; align-items: center; gap: 15px;">

      <%-- 햄버거 버튼: 클릭 시 사이드바를 열어줌 --%>
      <div id="hamburgerBtn" class="hamburger-menu" style="cursor: pointer; font-size: 24px; color: #2F4F4F;">
        <i class="fa-solid fa-bars"></i>
      </div>

      <%-- 로고: 클릭 시 메인페이지로 이동함 --%>
      <div class="logo" style="cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/'">
        <svg class="logo__icon" viewBox="0 -10 160 80" fill="none" style="width: 150px; height: 60px; display: block;">
          <rect x="4"    y="21.5" width="26" height="26" stroke="#a3b8b8" stroke-width="1.5" transform="rotate(-25 17 35)"/>
          <rect x="28"   y="10"   width="26" height="26" fill="#2F4F4F" fill-opacity="0.1" stroke="#2F4F4F" stroke-width="1.5" transform="rotate(-25 41 23)"/>
          <rect x="50"   y="20"   width="26" height="26" stroke="#a3b8b8" stroke-width="1"   transform="rotate(-25 53 33)"/>
          <rect x="38.2" y="38.5" width="26" height="26" fill="#2F4F4F" fill-opacity="0.1" stroke="#2F4F4F" stroke-width="1.5" transform="rotate(-25 41 47)"/>
          <text x="95" y="35" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="#2a2a2a">link</text>
          <text x="95" y="55" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="#2F4F4F">ora</text>
        </svg>
      </div>
    </div>

    <div class="header-right" style="display: flex; gap: 10px;">
      <%-- 예약하기 버튼임 --%>
      <a href="${pageContext.request.contextPath}/reserve"
         class="btn-book"
         style="text-decoration: none; display: inline-block; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 13px; background: #2F4F4F; color: white;">
        예약하기
      </a>
      <%-- 로그인 버튼임 --%>
      <button class="login-btn"
              onclick="location.href='${pageContext.request.contextPath}/login'"
              style="background: none; border: 1px solid #ddd; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 13px;">
        LOGIN
      </button>
    </div>
  </div>
</header>

<%-- 사이드바 배경 오버레이임 --%>
<div id="sidebarOverlay" class="sidebar-overlay"></div>

<%-- 사이드바 영역임 --%>
<aside id="sidebar" class="sidebar">
  <div class="sidebar-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #eee;">
    <span class="menu-title" style="font-weight: bold; color: #2F4F4F;">MENU</span>
    <button id="closeSidebar" class="close-sidebar-btn" style="background: none; border: none; font-size: 24px; cursor: pointer;">&times;</button>
  </div>

  <ul class="sidebar-nav" style="list-style: none; padding: 0; margin: 0;">

    <%-- 아코디언 메뉴: 공간 소개임 --%>
    <li class="accordion-item">
      <a href="#" class="accordion-toggle"
         style="display: flex; justify-content: space-between; padding: 15px 20px; text-decoration: none; color: #333; border-bottom: 1px solid #f9f9f9;">
        <div class="nav-content">
          <i class="fa-solid fa-building" style="margin-right: 10px;"></i>
          <span>공간 소개</span>
        </div>
        <i class="fa-solid fa-chevron-down arrow-icon"></i>
      </a>
      <ul class="accordion-content" style="background: #fcfcfc; padding-left: 20px; list-style: none;">
        <li>
          <a href="${pageContext.request.contextPath}/map"
             style="display: block; padding: 10px; color: #007A8A; font-size: 14px; font-weight: bold; text-decoration: none;">
            <i class="fa-solid fa-map-location-dot" style="margin-right: 8px;"></i> 지도에서 찾기
          </a>
        </li>
        <li><a href="#" style="display: block; padding: 10px; color: #666; font-size: 14px; text-decoration: none;">프라이빗 오피스</a></li>
        <li><a href="#" style="display: block; padding: 10px; color: #666; font-size: 14px; text-decoration: none;">오픈 데스크</a></li>
      </ul>
    </li>

    <%-- 아코디언 메뉴: 고객 지원임 --%>
    <li class="accordion-item">
      <a href="#" class="accordion-toggle"
         style="display: flex; justify-content: space-between; padding: 15px 20px; text-decoration: none; color: #333;">
        <div class="nav-content">
          <i class="fa-solid fa-headset" style="margin-right: 10px;"></i>
          <span>고객 지원</span>
        </div>
        <i class="fa-solid fa-chevron-down arrow-icon"></i>
      </a>
      <ul class="accordion-content" style="background: #fcfcfc; padding-left: 20px; list-style: none;">
        <li><a href="${pageContext.request.contextPath}/notice/list" style="display: block; padding: 10px; color: #666; font-size: 14px; text-decoration: none;">공지사항</a></li>
        <li><a href="#" style="display: block; padding: 10px; color: #666; font-size: 14px; text-decoration: none;">자주 묻는 질문</a></li>
      </ul>
    </li>

  </ul>
</aside>

<%-- 메인 지도 영역임 --%>
<main class="map-container">

  <%-- 지도 검색창 오버레이임 --%>
  <div class="map-search-overlay">
    <div class="search-box"
         style="display: flex; align-items: center; background: white; padding: 10px 20px; border-radius: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.15);">
      <i class="fa-solid fa-magnifying-glass" style="color: #007A8A; margin-right: 10px;"></i>
      <input type="text" id="mapSearchInput"
             placeholder="지점명이나 지역, 역 이름을 입력하세요"
             style="flex: 1; border: none; outline: none; font-size: 14px;">
      <button id="mapSearchBtn"
              style="background: #007A8A; color: white; border: none; padding: 6px 15px; border-radius: 20px; cursor: pointer; font-size: 13px; font-weight: bold;">
        검색
      </button>
    </div>
  </div>

  <%-- 카카오맵 도화지임 --%>
  <div id="mainMap" style="width: 100%; height: 100%;"></div>

  <%-- 챗봇 말풍선 버튼임 --%>
  <div class="chatbot-bubble" id="chatbotBtn"
       style="position: absolute; bottom: 30px; right: 30px; z-index: 10; cursor: pointer;">
    <div class="chatbot-text"
         style="background: white; padding: 8px 15px; border-radius: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); font-size: 12px; margin-bottom: 5px; font-weight: bold; color: #2F4F4F;">
      도움이 필요하신가요?
    </div>
    <div class="chatbot-icon"
         style="background: #2F4F4F; color: white; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; margin-left: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
      <i class="fa-solid fa-comment-dots"></i>
    </div>
  </div>

</main>

<%-- [스크립트 연동] 카카오맵 SDK와 기능 로직 파일임 --%>
<script type="text/javascript"
        src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=7508bb04c356b05484667dca670ae0cc&libraries=services&autoload=false">
</script>
<script src="${pageContext.request.contextPath}/js/mp_script.js"></script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../layout/header.jsp" %>

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

  /* 검색창 레이아웃: 버튼 배치를 위해 flex 및 간격 설정 추가 */
  .map-search-overlay {
    position: absolute;
    top: 40px !important; /* 헤더 아래 여유 공간 */
    left: 50%;
    transform: translateX(-50%);
    z-index: 10;
    display: flex; /* 요소들을 가로로 나열함 */
    gap: 10px;    /* 검색창과 하트 버튼 사이의 간격 */
  }

  /* 검색 박스 크기 및 디자인 */
  .search-box {
    display: flex;
    align-items: center;
    background: white;
    width: 500px;
    max-width: 90vw;
    padding: 12px 25px;
    border-radius: 40px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
  }

  /* 찜한 지점 필터 버튼 스타일 설정 */
  .wish-filter-btn {
    width: 54px;
    height: 54px;
    background: white;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    transition: 0.3s;
  }

  /* 하트 필터가 활성화(클릭)되었을 때의 색상 변경 */
  .wish-filter-btn.active {
    background: #ff4757;
  }

  /* 필터 활성화 시 내부 하트 아이콘 색상 변경 */
  .wish-filter-btn.active i {
    color: white !important;
  }

  /* 입력창 글자 설정 */
  #mapSearchInput {
    flex: 1;
    border: none;
    outline: none;
    font-size: 15px;
    font-weight: 500;
    margin-left: 10px;
  }

  /* 검색 버튼 설정 */
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
    white-space: nowrap;
  }

  #mapSearchBtn:hover { background: #005f6b; }

  /* 푸터를 화면에서 보이지 않도록 숨김 처리 */
  footer, .footer, #footer {
    display: none !important;
  }

  /* 검색 결과 패널의 스크롤바를 스마트폰 앱처럼 얇고 둥글게 꾸미는 디자인 */
  #searchResultPanel::-webkit-scrollbar {
    width: 6px; /* 스크롤바의 두께를 얇게 설정 */
  }
  #searchResultPanel::-webkit-scrollbar-track {
    background: transparent; /* 스크롤바가 움직이는 길은 투명하게 설정 */
  }
  #searchResultPanel::-webkit-scrollbar-thumb {
    background: #cccccc; /* 평소 스크롤바 색상은 눈에 띄지 않는 연한 회색 */
    border-radius: 10px; /* 모서리를 둥글게 깎음 */
  }
  #searchResultPanel::-webkit-scrollbar-thumb:hover {
    background: #007A8A; /* 마우스를 올리면 우리 홈페이지 브랜드 색상으로 진해짐 */
  }
</style>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/map.css">

<main class="map-container">
  <div class="map-search-overlay">
    <div class="search-box">
      <i class="fa-solid fa-magnifying-glass" style="color: #007A8A; font-size: 18px;"></i>
      <input type="text" id="mapSearchInput" placeholder="지점명, 지역 또는 역 이름을 입력하세요">
      <button id="mapSearchBtn">검색</button>
    </div>

    <button id="wishFilterBtn" class="wish-filter-btn" title="내가 찜한 오피스만 보기">
      <i class="fa-solid fa-heart" style="color: #bbb; font-size: 20px;"></i>
    </button>
  </div>

  <div id="mainMap"></div>

</main>

<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=cd1f0f4ad9dcf4879bee2531dc5a0497&libraries=services&autoload=false"></script>

<script type="text/javascript">
  /**
   * 1. 지도 로딩 제어
   */
  (function initMapLoader() {
    if (window.kakao && window.kakao.maps) {
      kakao.maps.load(function() {
        const mapScript = document.createElement('script');
        mapScript.src = "${pageContext.request.contextPath}/static/js/map.js";
        document.body.appendChild(mapScript);
      });
    } else {
      setTimeout(initMapLoader, 100);
    }
  })();

  /**
   * 2. 사이드바 및 필터 버튼 이벤트 처리
   */
  window.addEventListener('load', () => {
    /* 하트 필터 버튼 클릭 시 작동하는 로직 추가 */
    const wishBtn = document.querySelector('#wishFilterBtn');
    if (wishBtn) {
      wishBtn.onclick = function() {
        this.classList.toggle('active'); // active 클래스를 껐다 켰다 함

        // map.js 파일 안에 정의될 필터 기능을 호출함
        if (typeof window.toggleWishFilter === 'function') {
          window.toggleWishFilter(this.classList.contains('active'));
        }
      };
    }

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

<%@ include file="../layout/footer.jsp" %>
<%-- [Link Ora] 통합 header.jsp - 지점 검색 전용 브랜드 녹색 헤더 적용 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 관심 지점 화면 주소(/branch/wishlist) 조건 추가 --%>
<c:set var="isSearchPage" value="${pageContext.request.requestURI.contains('/branch/search') || pageContext.request.requestURI.contains('/branch/wishlist') || pageContext.request.requestURI.contains('/api/wishlist/view')}" />
<%
    boolean loggedIn = request.getUserPrincipal() != null;
    boolean adminUser = request.isUserInRole("ROLE_ADMIN");
    boolean partnerUser = request.isUserInRole("ROLE_PARTNER");
    String mypageUrl = adminUser ?
        (request.getContextPath() + "/admin/dashboard")
            : partnerUser ?
        (request.getContextPath() + "/partner/mypage")
            : (request.getContextPath() + "/mypage");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Ora - Premium Workspace</title>

    <%-- 파비콘 404 에러 방지용 --%>
    <link rel="icon" href="data:,">

    <%-- css 경로 설정 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">

    <%-- 아이콘 도구 연결 (Font Awesome 6.4.0) --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%-- 폰트 연결 --%>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />

    <%-- js 경로 설정 --%>
    <script src="${pageContext.request.contextPath}/static/js/mp_script.js" defer></script>

    <style>

        /* 기본 햄버거 메뉴 색상 (진한 녹색) */
        .main-header .hamburger-menu {
            color: #2F4F4F !important;
            font-family: "Font Awesome 6 Free" !important;
            font-weight: 900 !important;
        }

        /* 지점 찾기 페이지 전용 스타일 */
        <c:if test="${isSearchPage}">
        .main-header {
            background-color: #2F4F4F !important;
            border-bottom: 1px solid rgba(255,255,255,0.1) !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3) !important;
        }

        /* 검색 페이지 햄버거 메뉴, 로그인 버튼 폰트 색상 */
        .main-header .hamburger-menu,
        .main-header .login-btn {
            color: #ffffff !important;
        }

        /* 예약하기 버튼 반전 효과 */
        .main-header .btn-book {
            background-color: #ffffff !important;
            color: #2F4F4F !important;
            border: none !important;
            font-weight: 700 !important;
        }
        </c:if>

        /* 사이드바 레이아웃 (푸터 하단 고정을 위한 flex 설정) */
        .sidebar {
            display: flex !important;
            flex-direction: column !important;
        }
        .sidebar-nav {
            flex-grow: 1 !important;
            overflow-y: auto !important;
            margin-bottom: 0 !important;
        }

        /* 사이드바 하단 약관 링크 푸터 스타일 */
        .sidebar-bottom-links {
            background-color: #f8f9fa;
            border-top: 1px solid #ebebeb;
            padding: 20px 0;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: auto;
        }
        .sidebar-bottom-links a {
            color: #888;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.2s;
        }
        .sidebar-bottom-links a:hover {
            color: #007A8A;
            font-weight: 700;
        }
        .sidebar-bottom-links .divider {
            color: #ddd;
            font-size: 12px;
        }
    </style>

    <%-- 전역 JS 변수 설정 --%>
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.userIdx = '${sessionScope.userIdx != null ? sessionScope.userIdx : "0"}';
    </script>
</head>
<body>

<%-- 배경 오버레이 --%>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<%-- 사이드바 영역 --%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h3>MENU</h3>
        <button class="close-sidebar-btn" id="closeSidebar"><i class="fa-solid fa-xmark"></i></button>
    </div>

    <%-- 메뉴 리스트 영역 --%>
    <ul class="sidebar-nav">
        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-circle-user"></i> 내 정보</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="${pageContext.request.contextPath}/inquiry/mylist">내 문의</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/wishlist">관심 지점 / 최근 본 지점</a></li>
            </ul>
        </li>

        <% if (loggedIn) { %>
        <li>
            <a href="${pageContext.request.contextPath}/reservation/mylist">
                <div class="acc-left"><i class="fa-regular fa-calendar-check"></i> 내 예약</div>
            </a>
        </li>
        <% } %>

        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-building"></i> 공간 소개</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li>
                    <a href="${pageContext.request.contextPath}/map" style="color: #007A8A; font-weight: 700;">
                        <i class="fa-solid fa-map-location-dot" style="margin-right: 8px;"></i> 지도에서 찾기
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/branch/search">전체 지점</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/search?type=INDIVIDUAL">프라이빗 오피스</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/search?type=GROUP">코워킹 스페이스</a></li>
            </ul>
        </li>

        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-circle-question"></i> 고객 지원</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="${pageContext.request.contextPath}/notice/list">주요소식</a></li>
                <li><a href="${pageContext.request.contextPath}/inquiry">1:1 문의</a></li>
            </ul>
        </li>

        <%-- 사업자 전용 메뉴 --%>
        <% if (partnerUser) { %>
        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-circle-question"></i> 사업자 전용</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="${pageContext.request.contextPath}/notice/list">고객 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/inquiry">오피스 관리</a></li>
                <li><a href="#">이벤트</a></li>
            </ul>
        </li>
        <% } %>
    </ul>

    <%-- 사이드바 하단 고정 영역 --%>
    <div class="sidebar-bottom-links">
        <a href="${pageContext.request.contextPath}/common/privacy">개인정보처리방침</a>
        <span class="divider">|</span>
        <a href="${pageContext.request.contextPath}/common/terms">이용약관</a>
    </div>
</aside>

<%-- 상단 헤더 영역 --%>
<header class="main-header">
    <div class="container header-content">

       <div class="header-left">
            <%-- 햄버거 메뉴 아이콘 --%>
            <i class="fa-solid fa-bars hamburger-menu" id="hamburgerBtn" style="cursor: pointer; z-index: 9999 !important; position: relative;"></i>

            <%-- 로고 영역 --%>
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <svg class="logo__icon" viewBox="0 -10 160 80" fill="none" style="width: 150px; height: 60px;">
                        <rect x="4" y="21.5" width="26" height="26" stroke="#a3b8b8" stroke-width="1.5" transform="rotate(-25 17 35)"/>
                        <rect x="28" y="10" width="26" height="26" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}" fill-opacity="0.1" stroke="${isSearchPage ? '#ffffff' : '#2F4F4F'}" stroke-width="1.5" transform="rotate(-25 41 23)"/>
                        <rect x="50" y="20" width="26" height="26" stroke="#a3b8b8" stroke-width="1" transform="rotate(-25 53 33)"/>
                        <rect x="38.2" y="38.5" width="26" height="26" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}" fill-opacity="0.1" stroke="${isSearchPage ? '#ffffff' : '#2F4F4F'}" stroke-width="1.5" transform="rotate(-25 41 47)"/>

                        <text x="95" y="35" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="${isSearchPage ? '#ffffff' : '#2a2a2a'}">link</text>
                        <text x="95" y="55" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}">ora</text>
                    </svg>
                </a>
            </div>
        </div>

        <%-- 헤더 우측 버튼 영역 --%>
        <div class="header-right">
            <% if (adminUser) { %>
            <button class="login-btn" onclick="location.href='<%= mypageUrl %>'">관리자페이지</button>
            <a href="${pageContext.request.contextPath}/logout" class="btn-book">로그아웃</a>

            <% } else if (partnerUser) { %>
            <button class="login-btn" onclick="location.href='<%= mypageUrl %>'">마이페이지</button>
            <a href="${pageContext.request.contextPath}/logoutNow" class="btn-book">로그아웃</a>

            <% } else { %>
            <a href="${pageContext.request.contextPath}/detail/list" class="btn-book">예약하기</a>

            <% if (loggedIn) { %>
            <button class="login-btn" onclick="location.href='<%= mypageUrl %>'">마이페이지</button>
            <% } else { %>
            <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login'">LOGIN</button>
            <% } %>
            <% } %>
        </div>
    </div>
</header>
</body>
</html>
<%-- [Link Ora] 통합 header.jsp - 지점 검색 전용 브랜드 녹색 헤더 적용 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [변경 사항] 현재 페이지가 지점 검색 페이지(/branch/search)인지 확인하는 변수입니다. --%>
<c:set var="isSearchPage" value="${pageContext.request.requestURI.contains('/branch/search')}" />

<%
    boolean loggedIn = request.getUserPrincipal() != null;
    boolean partnerUser = request.isUserInRole("ROLE_PARTNER");
    String mypageUrl = partnerUser ? (request.getContextPath() + "/partner/mypage")
            : (request.getContextPath() + "/mypage");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Ora - Premium Workspace</title>

    <%-- 공통 스타일 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

    <%-- 외부 자원 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />

    <%-- 스크립트 --%>
    <script src="${pageContext.request.contextPath}/js/mp_script.js" defer></script>

    <%-- [추가] 지점 찾기 페이지 전용 브랜드 녹색 헤더 스타일 --%>
    <style>
        /* 지점 찾기 페이지일 때만 적용되는 스타일 */
        <c:if test="${isSearchPage}">
        .main-header {
        <%-- [핵심 변경] 배경색을 원래 로고에 있던 녹색(#2F4F4F)으로 설정 --%>
            background-color: #2F4F4F !important;
            border-bottom: 1px solid rgba(255,255,255,0.1) !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3) !important;
        }

        /* 햄버거 메뉴 및 로그인 버튼 글자 흰색으로 반전 */
        .main-header .hamburger-menu,
        .main-header .login-btn {
            color: #ffffff !important;
        }

        /* 예약하기 버튼 포인트 색상 반전 (흰색 배경 + 녹색 텍스트) */
        .main-header .btn-book {
            background-color: #ffffff !important;
            color: #2F4F4F !important;
            border: none !important;
            font-weight: 700 !important;
        }

        .main-header .btn-book:hover {
            background-color: #f0f0f0 !important;
        }
        </c:if>
    </style>
</head>
<body>

<%-- [배경] --%>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<%-- [사이드바] --%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h3>MENU</h3>
        <button class="close-sidebar-btn" id="closeSidebar"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <ul class="sidebar-nav">
        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-building"></i> 공간 소개임</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li>
                    <a href="${pageContext.request.contextPath}/map" style="color: #007A8A; font-weight: 700;">
                        <i class="fa-solid fa-map-location-dot" style="margin-right: 8px;"></i> 지도에서 찾기
                    </a>
                </li>
                <li><a href="#">프라이빗 오피스</a></li>
                <li><a href="#">오픈 데스크</a></li>
            </ul>
        </li>

        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-circle-question"></i> 고객 지원</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="${pageContext.request.contextPath}/notice/list">공지사항</a></li>
                <li><a href="#">자주 묻는 질문</a></li>
            </ul>
        </li>
    </ul>
</aside>

<%-- [상단 헤더] 검색 페이지 여부에 따라 스타일 적용 (클래스 분기 대신 내부에 스타일 주입) --%>
<header class="main-header">
    <div class="container header-content">
        <div class="header-left">
            <%-- 햄버거 메뉴 --%>
            <i class="fa-solid fa-bars hamburger-menu" id="hamburgerBtn" style="cursor: pointer; z-index: 9999 !important; position: relative;"></i>

            <%-- 로고 --%>
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <svg class="logo__icon" viewBox="0 -10 160 80" fill="none" style="width: 150px; height: 60px;">
                        <rect x="4" y="21.5" width="26" height="26" stroke="#a3b8b8" stroke-width="1.5" transform="rotate(-25 17 35)"/>
                        <%-- 검색 페이지일 때 로고 박스 테두리 흰색으로 반전 --%>
                        <rect x="28" y="10" width="26" height="26" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}" fill-opacity="0.1" stroke="${isSearchPage ? '#ffffff' : '#2F4F4F'}" stroke-width="1.5" transform="rotate(-25 41 23)"/>
                        <rect x="50" y="20" width="26" height="26" stroke="#a3b8b8" stroke-width="1" transform="rotate(-25 53 33)"/>
                        <rect x="38.2" y="38.5" width="26" height="26" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}" fill-opacity="0.1" stroke="${isSearchPage ? '#ffffff' : '#2F4F4F'}" stroke-width="1.5" transform="rotate(-25 41 47)"/>

                        <%-- 검색 페이지일 때 로고 텍스트 'link ora' 흰색(#ffffff)으로 반전 --%>
                        <text x="95" y="35" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="${isSearchPage ? '#ffffff' : '#2a2a2a'}">link</text>
                        <text x="95" y="55" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="${isSearchPage ? '#ffffff' : '#2F4F4F'}">ora</text>
                    </svg>
                </a>
            </div>
        </div>

        <%-- 우측 버튼 --%>
        <div class="header-right">
            <a href="${pageContext.request.contextPath}/detail/list" class="btn-book">예약하기</a>
            <% if (loggedIn) { %>
            <button class="login-btn" onclick="location.href='<%= mypageUrl %>'">마이페이지</button>
            <% } else { %>
            <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login'">LOGIN</button>
            <% } %>
        </div>
    </div>
</header>
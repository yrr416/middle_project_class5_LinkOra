<%-- [Link Ora] 통합 header.jsp - 완결판임. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    boolean loggedIn = request.getUserPrincipal() != null;
    boolean partnerUser = request.isUserInRole("ROLE_PARTNER");
    String mypageUrl = partnerUser ? (request.getContextPath() + "/partner/mypage")
            : (request.getContextPath() + "/mypage");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%--    <link rel="icon" href="data:,">--%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Ora - Premium Workspace</title>

    <%-- [설정] 모든 페이지에서 공통으로 사용하는 스타일시트들임. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

    <%-- [외부 자원] 폰트어썸 아이콘과 프리텐다드 폰트를 불러옴. --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />

    <%-- [스크립트] 메인 기능을 담당하는 JS 파일을 연결함. --%>
    <script src="${pageContext.request.contextPath}/js/mp_script.js" defer></script>
</head>
<body>

<%-- [배경] 사이드바가 열릴 때 화면을 어둡게 덮어주는 요소임. --%>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<%-- [사이드바] 메뉴 목록과 아코디언 기능을 포함함. --%>
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

<%-- [상단 헤더] 로고와 주요 버튼들이 위치한 영역임. --%>
<header class="main-header">
    <div class="container header-content">
        <div class="header-left">
            <%-- [햄버거] 클릭 시 사이드바를 열어주는 버튼임. --%>
            <i class="fa-solid fa-bars hamburger-menu" id="hamburgerBtn" style="cursor: pointer; z-index: 9999 !important; position: relative;"></i>

            <%-- [로고] 메인 페이지로 이동하는 로고임. --%>
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <svg class="logo__icon" viewBox="0 -10 160 80" fill="none" style="width: 150px; height: 60px;">
                        <rect x="4" y="21.5" width="26" height="26" stroke="#a3b8b8" stroke-width="1.5" transform="rotate(-25 17 35)"/>
                        <rect x="28" y="10" width="26" height="26" fill="#2F4F4F" fill-opacity="0.1" stroke="#2F4F4F" stroke-width="1.5" transform="rotate(-25 41 23)"/>
                        <rect x="50" y="20" width="26" height="26" stroke="#a3b8b8" stroke-width="1" transform="rotate(-25 53 33)"/>
                        <rect x="38.2" y="38.5" width="26" height="26" fill="#2F4F4F" fill-opacity="0.1" stroke="#2F4F4F" stroke-width="1.5" transform="rotate(-25 41 47)"/>
                        <text x="95" y="35" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="#2a2a2a">link</text>
                        <text x="95" y="55" font-weight="bold" font-size="24" font-family="'Pretendard', sans-serif" fill="#2F4F4F">ora</text>
                    </svg>
                </a>
            </div>
        </div>

        <%-- [우측 버튼] 예약하기 및 로그인 버튼임. --%>
        <div class="header-right">
            <a href="${pageContext.request.contextPath}/reserve" class="btn-book">예약하기</a>
            <% if (loggedIn) { %>
            <button class="login-btn" onclick="location.href='<%= mypageUrl %>'">마이페이지</button>
            <% } else { %>
            <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login'">LOGIN</button>
            <% } %>
        </div>
    </div>
</header>

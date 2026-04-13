<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- [복구] 사이드바 배경 오버레이임. id="sidebarOverlay"가 mp_script.js와 연결됨. --%>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<%-- [복구] 사이드바 본체임. id="sidebar"가 mp_script.js와 연결됨. --%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h3>MENU</h3>
        <%-- [중요] id="closeSidebar"가 mp_script.js의 닫기 기능과 연결됨. --%>
        <button class="close-sidebar-btn" id="closeSidebar">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>

    <ul class="sidebar-nav">

        <%-- 1. 공간 소개 (아코디언 구조임) --%>
        <li class="accordion-item">
            <%-- [핵심] a 태그에 accordion-toggle 클래스가 있어야 클릭 시 펼쳐짐. --%>
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-building"></i> 공간 소개</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="#">프라이빗 오피스</a></li>
                <li><a href="#">오픈 데스크</a></li>
                <li><a href="#">미팅룸 & 스튜디오</a></li>
            </ul>
        </li>

        <%-- 2. 지점 찾기 (아코디언 구조 & Context Path 적용임) --%>
        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-solid fa-map-location-dot"></i> 지점 찾기임</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <%-- 모든 링크 앞에 ${pageContext.request.contextPath}를 붙여 /linkora 경로를 보장함. --%>
                <li><a href="${pageContext.request.contextPath}/branch/search">전체 지점 보기</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/search?keyword=강남">강남 / 서초권</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/search?keyword=종로">종로 / 중구권</a></li>
                <li><a href="${pageContext.request.contextPath}/branch/search?keyword=성수">성수 / 건대권</a></li>
            </ul>
        </li>

        <%-- 3. 회원 관리 (아코디언 구조임) --%>
        <li class="accordion-item">
            <a href="#" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-user"></i> 회원 관리</div>
                <i class="fa-solid fa-chevron-down acc-arrow"></i>
            </a>
            <ul class="accordion-content">
                <li><a href="#">내 정보 보기</a></li>
                <li><a href="#">예약 및 결제 내역</a></li>
                <li><a href="#">1:1 문의 내역</a></li>
            </ul>
        </li>

        <%-- 4. 마이페이지 (단일 메뉴임) --%>
        <li class="accordion-item">
            <a href="${pageContext.request.contextPath}/mypage" class="accordion-toggle">
                <div class="acc-left"><i class="fa-regular fa-circle-user"></i> 마이페이지</div>
            </a>
        </li>

    </ul>
</aside>

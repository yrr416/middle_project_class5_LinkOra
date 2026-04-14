<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- [공통 레이아웃 상단] --%>
<%@ include file="../layout/header.jsp" %>

<style>

    /* [1번 영역: 헤더 색상 반전 및 간격 제거 설정] */

    .main-header {

        background-color: #2a2a2a !important; /* 헤더 배경 어둡게 */

        border-bottom: 1px solid rgba(255, 255, 255, 0.1) !important;

        position: fixed;

        top: 0;

        left: 0;

        width: 100%;

        z-index: 1000;

    }


    /* 헤더 내 글자 및 아이콘 흰색으로 반전 */

    .main-header .hamburger-menu,
    .main-header .login-btn,
    .main-header .login-link {

        color: #ffffff !important;

    }


    /* 로고 SVG 텍스트 흰색으로 반전 */

    .main-header .logo__icon text {

        fill: #ffffff !important;

    }


    /* 예약하기 버튼 포인트 색상 반전 (흰색 배경 + 다크 텍스트) */

    .main-header .btn-book {

        background-color: #ffffff !important;

        color: #2a2a2a !important;

        border: none !important;

    }


    /* [중요] 헤더와 배너 사이의 흰색 간격을 없애기 위한 래퍼 설정 */

    .list-page-wrapper {

        margin-top: 0 !important;

        padding-top: 80px !important; /* 헤더 높이(80px)만큼만 띄워 배너와 밀착시킴 */

    }


    /* 서서히 올라오는 애니메이션 효과 */

    @keyframes fadeInUp {

        from {
            opacity: 0;
            transform: translateY(20px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }

    }

    .fade-in-up {

        animation: fadeInUp 0.8s ease-out forwards;

    }

</style>

<main class="list-page-wrapper">

    <%-- [2번 영역: 배너 - 원래 코드 스타일 유지] --%>
    <section class="list-header" style="
        background: linear-gradient(rgba(255,255,255,0.85), rgba(255,255,255,0.85)),
                    url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=80');
        background-size: cover;
        background-position: center;
        padding: 80px 0;
        text-align: center;
        border-bottom: 1px solid #eee;">

        <div class="container fade-in-up">
            <nav style="margin-bottom: 15px; font-size: 13px; color: #888; letter-spacing: 0.5px;">
                <a href="${pageContext.request.contextPath}/" style="color: #888; text-decoration: none;">HOME</a>
                <span style="margin: 0 8px;">&gt;</span>
                <span style="color: #007A8A; font-weight: 600;">FIND SPACES</span>
            </nav>

            <h2 style="font-size: 40px; font-weight: 900; color: #1a1a1a; margin-bottom: 15px; letter-spacing: -1.5px;">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        '<span style="color: #007A8A;">${keyword}</span>' 검색 결과
                    </c:when>
                    <c:otherwise>전체 공간 둘러보기</c:otherwise>
                </c:choose>
            </h2>

            <div style="width: 50px; height: 4px; background: #007A8A; margin: 0 auto 25px; border-radius: 2px;"></div>

            <p style="color: #555; font-size: 18px; font-weight: 400; line-height: 1.6; letter-spacing: -0.5px;">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        Link Ora가 엄선한 최적의 공간 <strong style="color: #007A8A;">${totalCount}</strong>개를 찾았습니다.
                    </c:when>
                    <c:otherwise>
                        성공적인 비즈니스를 위해 Link Ora가 제안하는 <br>
                        <strong>최상의 업무 환경</strong>을 지금 경험해 보세요.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </section>

    <div class="container" style="display: flex; gap: 30px; margin-top: 40px; margin-bottom: 60px;">

        <%-- [좌측: 상세 필터 영역 - 전체 유지] --%>
        <aside class="filter-sidebar"
               style="width: 280px; flex-shrink: 0; background: #fff; padding: 25px; border: 1px solid #eee; border-radius: 12px; height: fit-content; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
            <div class="filter-box">
                <h3 style="margin-bottom: 20px; font-size: 18px; border-bottom: 2px solid #007A8A; padding-bottom: 10px;">
                    상세 필터</h3>
                <form action="${pageContext.request.contextPath}/branch/search" method="get" id="sidebarFilterForm">
                    <input type="hidden" name="keyword" value="${keyword}">

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #333;">지역 선택</label>
                        <select id="sidebarCity" onchange="updateSidebarDistricts()"
                                style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd; margin-bottom: 8px;">
                            <option value="">시/도 선택</option>
                            <option value="서울">서울특별시</option>
                            <option value="인천">인천광역시</option>
                        </select>
                        <select name="region" id="sidebarDistrict"
                                style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd;"
                                disabled>
                            <option value="">상세 구 선택</option>
                        </select>
                    </div>

                    <div class="filter-group" style="margin-bottom: 25px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #333;">수용
                            인원</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 13px;">
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="" ${empty capacity ? 'checked' : ''}>
                                전체</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="1" ${capacity == 1 ? 'checked' : ''}> 1인
                                전용</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="5" ${capacity == 5 ? 'checked' : ''}>
                                ~5인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="10" ${capacity == 10 ? 'checked' : ''}>
                                ~10인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="20" ${capacity == 20 ? 'checked' : ''}>
                                ~20인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="21" ${capacity == 21 ? 'checked' : ''}>
                                20인+</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity"
                                                                  value="100" ${capacity == 100 ? 'checked' : ''}> 100인+</label>
                        </div>
                    </div>

                    <div class="filter-group" style="margin-bottom: 25px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #333;">편의
                            시설</label>
                        <div style="display: grid; gap: 10px; font-size: 14px; color: #555;">
                            <label style="cursor:pointer;"><input type="checkbox" name="facParking"
                                                                  value="1" ${facParking == 1 ? 'checked' : ''}> 주차
                                가능</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facHours24"
                                                                  value="1" ${facHours24 == 1 ? 'checked' : ''}> 24시간 운영</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facPet"
                                                                  value="1" ${facPet == 1 ? 'checked' : ''}> 반려동물
                                동반</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facWifi"
                                                                  value="1" ${facWifi == 1 ? 'checked' : ''}> 기가
                                와이파이</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facCoffee"
                                                                  value="1" ${facCoffee == 1 ? 'checked' : ''}> 무료 커피/간식</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facPrinter"
                                                                  value="1" ${facPrinter == 1 ? 'checked' : ''}> 프린터 이용</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facLocker"
                                                                  value="1" ${facLocker == 1 ? 'checked' : ''}> 개인
                                사물함</label>
                        </div>
                    </div>

                    <button type="submit"
                            style="width: 100%; padding: 12px; background: #007A8A; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">
                        필터 적용하기
                    </button>
                    <a href="${pageContext.request.contextPath}/branch/search"
                       style="display: block; text-align: center; margin-top: 15px; color: #999; font-size: 13px; text-decoration: none;">필터
                        초기화</a>
                </form>
            </div>
        </aside>

        <%-- [우측: 지점 리스트 영역] --%>
        <section class="branch-list-content" style="flex-grow: 1;">
            <div class="branch-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px;">
                <c:forEach var="branch" items="${branches}">
                    <div class="branch-card"
                         style="background: #fff; border: 1px solid #eee; border-radius: 12px; overflow: hidden; transition: 0.3s; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                        <div class="branch-img" style="height: 200px; background: #f0f0f0;">
                            <c:choose>
                                <c:when test="${not empty branch.mainImgUrl}">
                                    <%-- '/'로 시작하면 전체 경로, 아니면 파일명으로 처리 --%>
                                    <c:choose>
                                        <c:when test="${fn:startsWith(branch.mainImgUrl, '/')}">
                                            <img src="${pageContext.request.contextPath}${branch.mainImgUrl}"
                                                 style="width:100%; height:100%; object-fit:cover;"
                                                 onerror="this.src='https://placehold.jp/400x200.png?text=No+Image'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/static/upload/branch/${branch.mainImgUrl}"
                                                 style="width:100%; height:100%; object-fit:cover;"
                                                 onerror="this.src='https://placehold.jp/400x200.png?text=No+Image'">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://placehold.jp/400x200.png?text=No+Image"
                                         style="width:100%; height:100%; object-fit:cover;">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="branch-info" style="padding: 20px;">
                            <h3 style="margin: 0 0 10px 0; font-size: 20px; color: #333;">${branch.brnName}</h3>
                            <p style="color: #777; font-size: 14px; margin-bottom: 15px;">
                                <i class="fa-solid fa-location-dot" style="color: #007A8A;"></i> ${branch.brnAddress}
                            </p>

                                <%-- [아이콘 복구] 가시성을 위해 브랜드 컬러 강조 --%>
                            <div class="facility-icons"
                                 style="display: flex; gap: 12px; margin-bottom: 20px; font-size: 18px; color: #007A8A;">
                                <c:if test="${branch.facWifi == 1}"><i class="fa-solid fa-wifi" title="와이파이"></i></c:if>
                                <c:if test="${branch.facParking == 1}"><i class="fa-solid fa-car" title="주차"></i></c:if>
                                <c:if test="${branch.facCoffee == 1}"><i class="fa-solid fa-mug-hot"
                                                                         title="무료커피"></i></c:if>
                                <c:if test="${branch.facHours24 == 1}"><i class="fa-solid fa-clock"
                                                                          title="24시간"></i></c:if>
                                <c:if test="${branch.facPet == 1}"><i class="fa-solid fa-paw" title="반려동물"></i></c:if>
                                <c:if test="${branch.facPrinter == 1}"><i class="fa-solid fa-print"
                                                                          title="프린터"></i></c:if>
                                <c:if test="${branch.facLocker == 1}"><i class="fa-solid fa-vault"
                                                                         title="사물함"></i></c:if>
                            </div>

                            <a href="${pageContext.request.contextPath}/branch/detail?brnIdx=${branch.brnIdx}"
                               style="display: block; text-align: center; border: 1px solid #007A8A; color: #007A8A; padding: 10px; border-radius: 6px; text-decoration: none; font-weight: bold;">
                                상세보기 및 예약
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>
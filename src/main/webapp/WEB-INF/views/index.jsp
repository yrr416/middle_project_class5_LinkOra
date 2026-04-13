<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [공통 레이아웃 상단] --%>
<%@ include file="layout/header.jsp" %>

<main>
    <section class="hero-section">
        <div class="hero-overlay"></div>
        <div class="container hero-inner">
            <h1 class="hero-title">당신의 몰입을 완성하는 공간</h1>
            <style>
                /* 셀렉트 박스 디자인 및 레이아웃 최적화 */
                .search-item select {
                    -webkit-appearance: none !important;
                    -moz-appearance: none !important;
                    appearance: none !important;
                    background: transparent url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e") no-repeat right 5px center !important;
                    background-size: 16px !important;
                    padding-right: 25px !important;
                    border: none !important;
                    outline: none !important;
                    box-shadow: none !important;
                    cursor: pointer !important;
                    width: 100%;
                }
                /* 비활성화(disabled) 상태일 때의 스타일 */
                .search-item select:disabled {
                    background-color: #f5f5f5 !important;
                    cursor: not-allowed !important;
                    color: #ccc !important;
                }
                .search-bar-round {
                    max-width: 1000px !important;
                }
            </style>

            <div class="search-wrapper">
                <form action="${pageContext.request.contextPath}/branch/search" method="get" class="search-bar-round">
                    <%-- 1. 키워드 검색 --%>
                    <div class="search-item keyword-item">
                        <input type="text" name="keyword" id="keywordSearchInput"
                               value="${keyword}" placeholder="어떤 공간을 찾으시나요?">
                    </div>
                    <div class="search-divider"></div>

                    <%-- 2. 광역 지역 선택 (서울/인천) --%>
                    <div class="search-item">
                        <select id="citySelect" onchange="updateDistricts()">
                            <option value="">지역 전체</option>
                            <option value="서울">서울특별시</option>
                            <option value="인천">인천광역시</option>
                        </select>
                    </div>
                    <div class="search-divider"></div>

                    <%-- 3. 상세 구 선택 (지역 미선택 시 비활성화) --%>
                    <div class="search-item">
                        <select name="region" id="districtSelect" disabled>
                            <option value="">상세 지역</option>
                        </select>
                    </div>
                    <div class="search-divider"></div>

                    <%-- 4. 인원 필터 (세분화된 구간) --%>
                    <div class="search-item">
                        <select name="capacity">
                            <option value="">인원 전체</option>
                            <option value="1">1인</option>
                            <option value="5">~5인</option>
                            <option value="10">~10인</option>
                            <option value="20">~20인</option>
                            <option value="21">20인 이상</option>
                            <option value="100">100인 이상</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-search-round">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>

                <%-- 인기 검색어 영역 --%>
                <div class="hash-tags" style="margin-top: 25px;">
                    <span style="color: #eee; margin-right: 10px; font-size: 14px;">추천 키워드:</span>
                    <c:forEach var="tag" items="${topTags}">
                        <c:url var="tagSearchUrl" value="/branch/search">
                            <c:param name="keyword" value="${tag.keyword}" />
                        </c:url>
                        <a href="${tagSearchUrl}" style="color: white; text-decoration: none; margin-right: 12px; font-size: 14px; font-weight: 500;">
                            #${tag.keyword}
                        </a>
                    </c:forEach>
                    <c:if test="${empty topTags}">
                        <c:url var="s1" value="/branch/search"><c:param name="keyword" value="강남" /></c:url>
                        <c:url var="s2" value="/branch/search"><c:param name="facHours24" value="1" /></c:url>
                        <a href="${s1}" style="color: white; text-decoration: none; margin-right: 12px; font-size: 14px;">#강남</a>
                        <a href="${s2}" style="color: white; text-decoration: none; font-size: 14px;">#24시간오픈</a>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <%-- 광고 슬라이더 영역 --%>
        <div class="promo-slider-container" id="promoContainer" style="margin-top: 40px;">
            <button class="close-promo" id="closePromoBtn"><i class="fa-solid fa-xmark"></i></button>
            <div class="promo-track" id="promoTrack">
                <c:choose>
                    <c:when test="${not empty promos}">
                        <c:forEach var="p" items="${promos}">
                            <a href="${p.proLink}" class="promo-slide">
                                <div class="promo-image"><img src="${p.proImgPath}" alt="${p.proTitle}"></div>
                                <div class="promo-text"><h3>${p.proTitle}</h3></div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="promo-slide">
                            <div class="promo-image"><img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80"></div>
                            <div class="promo-text"><h3>1. 신규 하이엔드 라운지 오픈 특가</h3></div>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="promo-dots" id="promoDots">
                <div class="promo-dot active"></div><div class="promo-dot"></div><div class="promo-dot"></div>
            </div>
        </div>

        <section class="content-layout">
            <div class="content-left">
                <div class="section-header"><h2>공간 찾아보기</h2></div>
                <div class="category-grid">
                    <div class="category-card"><i class="fa-solid fa-door-closed"></i><div><h3>프라이빗 오피스</h3><p>독립된 개인 공간</p></div></div>
                    <div class="category-card"><i class="fa-solid fa-laptop"></i><div><h3>오픈 데스크</h3><p>자유로운 업무 환경</p></div></div>
                    <div class="category-card"><i class="fa-solid fa-users-viewfinder"></i><div><h3>미팅룸 대여</h3></div></div>
                    <div class="category-card"><i class="fa-solid fa-video"></i><div><h3>스튜디오</h3></div></div>
                </div>

                <div class="map-tab-header" style="display: flex !important; justify-content: space-between !important; align-items: center !important; margin-bottom: 20px;">
                    <div class="map-tab-container" style="display: flex !important; align-items: center !important; gap: 8px;">
                        <h2 class="tab-title active" id="tabNear" style="margin: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #2F4F4F;">주변 지점</h2>
                        <span class="tab-divider" style="font-size: 18px; color: #ddd; margin: 0 4px;">/</span>
                        <h2 class="tab-title inactive" id="tabFavorite" style="margin: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #bbb;">관심 지점</h2>
                    </div>
                    <a href="${pageContext.request.contextPath}/map" class="map-view-all" style="display: inline-block !important; font-size: 13px !important; font-weight: 700 !important; color: #007A8A !important; text-decoration: none !important; padding: 6px 14px !important; background-color: #f0f8f8 !important; border-radius: 20px !important;">
                        전체보기 <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i>
                    </a>
                </div>

                <div class="wework-map-left" style="position: relative; border-radius: 12px; height: 350px; overflow: hidden; border: 1px solid #eee;">
                    <div id="mainMap" style="width: 100%; height: 350px;"></div>
                </div>
            </div>

            <div class="wework-list-right">
                <div class="section-header"><h2>주요 소식</h2><a href="${pageContext.request.contextPath}/notice/list" class="more-link">전체 보기</a></div>
                <ul class="board-list">
                    <c:choose>
                        <c:when test="${not empty notices}">
                            <c:forEach var="n" items="${notices}">
                                <li>
                                    <span class="tag ${n.notCategory == 'EVENT' ? 'event' : 'notice'}">${n.notCategory}</span>
                                    <a href="${pageContext.request.contextPath}/notice/detail?notIdx=${n.notIdx}">${n.notTitle}</a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><span class="tag notice">NEW</span> <a href="#">프리미엄 라운지 강남점 오픈</a></li>
                            <li><span class="tag event">EVENT</span> <a href="#">신규 회원 1일 무료 체험권</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </section>
    </div>

    <%-- 지역 선택 자바스크립트 로직 (비활성화 제어 포함) --%>
    <script>
        const districtMap = {
            "서울": ["강남구", "서초구", "종로구", "마포구", "송파구", "영등포구", "성동구"],
            "인천": ["남동구", "연수구", "부평구", "미추홀구", "서구", "중구", "동구"]
        };

        function updateDistricts() {
            const city = document.getElementById('citySelect').value;
            const districtSelect = document.getElementById('districtSelect');

            // 1. 기존 옵션 초기화
            districtSelect.innerHTML = '<option value="">상세 지역</option>';

            // 2. 지역이 선택되었는지 확인
            if (city && districtMap[city]) {
                // 시/도 선택 시 상세 구 드롭다운 활성화
                districtSelect.disabled = false;
                districtMap[city].forEach(dist => {
                    const option = document.createElement('option');
                    option.value = dist;
                    option.textContent = dist;
                    districtSelect.appendChild(option);
                });
            } else {
                // '지역 전체' 등을 선택했을 시 다시 비활성화
                districtSelect.disabled = true;
            }
        }
    </script>

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=7508bb04c356b05484667dca670ae0cc&libraries=services&autoload=false"></script>
    <script src="${pageContext.request.contextPath}/js/mp_script.js"></script>
</main>

<%-- [중요!] 에러 해결 포인트: 하단은 header가 아닌 footer를 불러와야 중복 선언 에러가 나지 않습니다. --%>
<%@ include file="layout/footer.jsp" %>
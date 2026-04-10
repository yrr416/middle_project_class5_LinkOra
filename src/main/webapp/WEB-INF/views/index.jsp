<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [공통 레이아웃] --%>
<%@ include file="layout/header.jsp" %>

<main>
    <section class="hero-section">
        <div class="hero-overlay"></div>
        <div class="container hero-inner">
            <h1 class="hero-title">당신의 몰입을 완성하는 공간</h1>
            <style>
                /* 셀렉트 박스 디자인 설정임 */
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
                }
                .search-item select:focus {
                    outline: none !important;
                    box-shadow: none !important;
                }
            </style>

            <div class="search-wrapper">
                <form action="${pageContext.request.contextPath}/branch/search" method="get" class="search-bar-round">
                    <div class="search-item keyword-item">
                        <input type="text" name="keyword" id="keywordSearchInput"
                               value="${keyword}" placeholder="어떤 공간을 찾으시나요?">
                    </div>
                    <div class="search-divider"></div>
                    <div class="search-item">
                        <select name="region">
                            <option value="">지역 전체</option>
                            <option value="강남">강남 / 서초</option>
                            <option value="종로">종로 / 중구</option>
                            <option value="마포">마포 / 홍대</option>
                        </select>
                    </div>
                    <div class="search-divider"></div>
                    <div class="search-item">
                        <select name="capacity">
                            <option value="">인원 전체</option>
                            <option value="1">1인</option>
                            <option value="2">2인</option>
                            <option value="4">4인 이상</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-search-round">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>

                <%-- 인기 검색어 영역: SearchLogVO의 keyword 필드를 사용함 --%>
                <div class="hash-tags" style="margin-top: 25px;">
                    <span style="color: #eee; margin-right: 10px; font-size: 14px;">추천 키워드:</span>
                    <c:forEach var="tag" items="${topTags}">
                        <a href="${pageContext.request.contextPath}/branch/search?keyword=${tag.keyword}"
                           style="color: white; text-decoration: none; margin-right: 12px; font-size: 14px; font-weight: 500;">
                            #${tag.keyword}
                        </a>
                    </c:forEach>
                    <c:if test="${empty topTags}">
                        <a href="${pageContext.request.contextPath}/branch/search?keyword=강남"
                           style="color: white; text-decoration: none; margin-right: 12px; font-size: 14px;">#강남</a>
                        <a href="${pageContext.request.contextPath}/branch/search?capacity=1"
                           style="color: white; text-decoration: none; font-size: 14px;">#1인포커스룸</a>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <%-- 광고 슬라이더 영역임 --%>
        <div class="promo-slider-container" id="promoContainer" style="margin-top: 40px;">
            <button class="close-promo" id="closePromoBtn">
                <i class="fa-solid fa-xmark"></i>
            </button>
            <div class="promo-track" id="promoTrack">
                <c:choose>
                    <c:when test="${not empty promos}">
                        <c:forEach var="p" items="${promos}">
                            <a href="${p.proLink}" class="promo-slide">
                                <div class="promo-image">
                                    <img src="${p.proImgPath}" alt="${p.proTitle}">
                                </div>
                                <div class="promo-text"><h3>${p.proTitle}</h3></div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- [복구] 데이터가 없을 때 디자인 확인용으로 보여줄 임시 광고 3개임 --%>
                        <a href="#" class="promo-slide">
                            <div class="promo-image">
                                <img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80">
                            </div>
                            <div class="promo-text"><h3>1. 신규 하이엔드 라운지 오픈 특가</h3></div>
                        </a>
                        <a href="#" class="promo-slide">
                            <div class="promo-image">
                                <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80">
                            </div>
                            <div class="promo-text"><h3>2. 친구 초대하고 미팅룸 무료 체험</h3></div>
                        </a>
                        <a href="#" class="promo-slide">
                            <div class="promo-image">
                                <img src="https://images.unsplash.com/photo-1543269865-cbf427effbad?auto=format&fit=crop&w=800&q=80">
                            </div>
                            <div class="promo-text"><h3>3. 1인 포커스룸 첫 방문 50% 할인</h3></div>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="promo-dots" id="promoDots">
                <c:choose>
                    <c:when test="${not empty promos}">
                        <c:forEach var="p" items="${promos}" varStatus="status">
                            <div class="promo-dot ${status.first ? 'active' : ''}"></div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- [복구] 임시 광고 3개에 맞춘 점 3개임 --%>
                        <div class="promo-dot active"></div>
                        <div class="promo-dot"></div>
                        <div class="promo-dot"></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <section class="content-layout">
            <div class="content-left">
                <div class="section-header"><h2>공간 찾아보기</h2></div>

                <div class="category-grid">
                    <div class="category-card">
                        <i class="fa-solid fa-door-closed"></i>
                        <div><h3>프라이빗 오피스</h3><p>독립된 개인 공간</p></div>
                    </div>
                    <div class="category-card">
                        <i class="fa-solid fa-laptop"></i>
                        <div><h3>오픈 데스크</h3><p>대충 설명~~</p></div>
                    </div>
                    <div class="category-card">
                        <i class="fa-solid fa-users-viewfinder"></i>
                        <div><h3>미팅룸 대여</h3></div>
                    </div>
                    <div class="category-card">
                        <i class="fa-solid fa-video"></i>
                        <div><h3>스튜디오</h3></div>
                    </div>
                </div>

                <div class="map-tab-header" style="display: flex !important; flex-direction: row !important; justify-content: space-between !important; align-items: center !important; margin-bottom: 20px;">
                    <div class="map-tab-container" style="display: flex !important; flex-direction: row !important; align-items: center !important; gap: 8px;">
                        <h2 class="tab-title active" id="tabNear" style="margin: 0 !important; padding: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #2F4F4F;">주변 지점</h2>
                        <span class="tab-divider" style="font-size: 18px; color: #ddd; font-weight: 300; margin: 0 4px;">/</span>
                        <h2 class="tab-title inactive" id="tabFavorite" style="margin: 0 !important; padding: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #bbb;">관심 지점</h2>
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
                <div class="section-header">
                    <h2>주요 소식</h2>
                    <a href="${pageContext.request.contextPath}/notice/list" class="more-link">전체 보기</a>
                </div>

                <ul class="board-list">
                    <c:choose>
                        <c:when test="${not empty notices}">
                            <c:forEach var="n" items="${notices}">
                                <li>
                                    <span class="tag ${n.notCategory == 'EVENT' ? 'event' : 'notice'}">
                                        ${n.notCategory}
                                    </span>
                                    <a href="${pageContext.request.contextPath}/notice/detail?notIdx=${n.notIdx}">
                                        ${n.notTitle}
                                    </a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><span class="tag notice">NEW</span> <a href="#">강남 테헤란로 오픈 안내</a></li>
                            <li><span class="tag event">EVENT</span> <a href="#">신규 가입 무료 체험 이벤트</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <div class="section-header" style="margin-top: 30px; border-bottom: none;">
                    <h2>Stories</h2>
                    <div class="slider-arrows-mini">
                        <button id="prevReview"><i class="fa-solid fa-chevron-left"></i></button>
                        <button id="nextReview"><i class="fa-solid fa-chevron-right"></i></button>
                    </div>
                </div>

                <div class="review-slider-wrapper-mini">
                    <%-- [디자인 수정] JS의 transform 애니메이션이 먹히도록 가로 정렬(flex) 설정 추가함 --%>
                    <div class="review-track-mini" id="reviewTrack" style="display: flex; transition: transform 0.4s ease-in-out;">

                        <%-- 1. DB에서 가져온 실제 데이터들 (있을 때만 출력) --%>
                        <c:if test="${not empty reviews}">
                            <c:forEach var="r" items="${reviews}">
                                <div class="review-slide-mini" style="min-width: 100%; box-sizing: border-box;">
                                    <div class="review-card-modern ${empty r.revImg ? 'no-image' : ''}"
                                         onclick="location.href='${pageContext.request.contextPath}/review/detail?revIdx=${r.revIdx}'">
                                        <c:if test="${not empty r.revImg}">
                                            <div class="review-image-box">
                                                <img src="${r.revImg}" alt="후기 이미지">
                                            </div>
                                        </c:if>
                                        <div class="review-content-modern">
                                            <div class="review-rating">
                                                <span class="stars">
                                                    <c:forEach begin="1" end="${r.revRating}">★</c:forEach>
                                                </span>
                                                <strong class="score">${r.revRating}.0</strong>
                                            </div>
                                            <div class="review-author-info">
                                                <strong>${r.userNickname}</strong>
                                                <span>| ${r.revRegdate}</span>
                                            </div>
                                            <p>"${r.revContent}"</p>
                                            <div class="review-more-link"
                                                 style="margin-top: auto; align-self: flex-end; font-size: 12px; color: #007A8A; font-weight: 600;">
                                                자세히 보기 <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>

                        <%-- 2. [복구] 사진이 있는 버전 샘플 (디자인 확인을 위해 항상 보이게 밖으로 뺌) --%>
                        <div class="review-slide-mini" style="min-width: 100%; box-sizing: border-box;">
                            <div class="review-card-modern" onclick="location.href='#'">
                                <div class="review-image-box">
                                    <img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=300&q=80" alt="후기">
                                </div>
                                <div class="review-content-modern">
                                    <div class="review-rating">
                                        <span class="stars">★★★★★</span>
                                        <strong class="score">5.0</strong>
                                    </div>
                                    <div class="review-author-info">
                                        <strong>김몰입(샘플)</strong> <span>| 2026.04.05</span>
                                    </div>
                                    <p>"시설이 정말 깨끗하고 집중이 잘 됩니다! 사진보다 실물이 훨씬 좋네요."</p>
                                    <div class="review-more-link" style="margin-top: auto; align-self: flex-end; font-size: 12px; color: #007A8A; font-weight: 600;">
                                        자세히 보기 <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- 3. [복구] 사진이 없는 버전 샘플 (디자인 확인을 위해 항상 보이게 밖으로 뺌, no-image 적용) --%>
                        <div class="review-slide-mini" style="min-width: 100%; box-sizing: border-box;">
                            <div class="review-card-modern no-image" onclick="location.href='#'">
                                <div class="review-content-modern">
                                    <div class="review-rating">
                                        <span class="stars">★★★★★</span>
                                        <strong class="score">5.0</strong>
                                    </div>
                                    <div class="review-author-info">
                                        <strong>이집중(샘플)</strong> <span>| 2026.04.03</span>
                                    </div>
                                    <p>"집보다 집중이 훨씬 잘 돼서 자주 이용할 것 같아요. 특히 커피가 맛있습니다!"</p>
                                    <div class="review-more-link" style="margin-top: auto; align-self: flex-end; font-size: 12px; color: #007A8A; font-weight: 600;">
                                        자세히 보기 <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </section>
    </div>

    <script type="text/javascript"
            src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=7508bb04c356b05484667dca670ae0cc&libraries=services&autoload=false">
    </script>
    <script src="${pageContext.request.contextPath}/js/mp_script.js"></script>
</main>

<%@ include file="layout/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="layout/header.jsp" %> <main>
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
                /* 비활성화 상태일 때의 스타일 */
                .search-item select:disabled { background-color: #f5f5f5 !important; cursor: not-allowed !important; color: #ccc !important; }
                .search-bar-round { max-width: 1000px !important; }

                /* 이벤트 슬라이더 배경색 제거 및 테두리 추가 */
                .promo-slider-container {
                    position: relative;
                    overflow: hidden;
                    border-radius: 12px;
                    margin-top: 30px;
                    cursor: pointer;
                    background: #ffffff; /* 깔끔한 화이트 배경 */
                    border: 1px solid #e5e7eb; /* 연한 회색 테두리 */
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }
                .promo-track { display: flex; transition: transform 0.5s ease-in-out; }

                /* 슬라이드 내부 여백 및 텍스트 색상(검정색) 설정 */
                .promo-slide {
                    display: flex;
                    flex-direction: row;
                    align-items: center;
                    gap: 35px;
                    text-decoration: none;
                    color: #1f2937; /* 진한 회색 글자 */
                    padding: 24px 40px 24px 85px;
                    box-sizing: border-box;
                    position: relative;
                    border-radius: 12px;
                    background: #ffffff;
                }

                /* 배너 닫기 버튼(X) 스타일 */
                .promo-close {
                    position: absolute;
                    top: 15px;
                    right: 15px;
                    z-index: 30;
                    background: rgba(0,0,0,0.05);
                    border: none;
                    color: #9ca3af;
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 16px;
                    transition: 0.2s;
                }
                .promo-close:hover { background: #ef4444; color: white; }

                /* 배지 및 제목 스타일 */
                .promo-slide-badge {
                    display: inline-block;
                    font-size: 11px;
                    font-weight: 700;
                    letter-spacing: 1px;
                    background: #f3f4f6;
                    color: #374151;
                    border: 1px solid #d1d5db;
                    border-radius: 20px;
                    padding: 3px 12px;
                    margin-bottom: 10px;
                }
                .promo-slide-title {
                    font-size: 21px;
                    font-weight: 800;
                    margin: 0 0 8px 0;
                    line-height: 1.3;
                    color: #111827;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                    max-width: 500px;
                }
                .promo-slide-date { font-size: 13px; color: #6b7280; }
                .promo-slide-arrow { position: absolute; right: 35px; top: 50%; transform: translateY(-50%); font-size: 24px; color: #d1d5db; }

                /* 이미지 영역 크기 및 비율 유지 */
                .promo-slide-text { flex: 1; min-width: 0; order: 2; }
                .promo-slide-img-col {
                    flex-shrink: 0;
                    width: 200px;
                    height: 140px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    order: 1;
                    overflow: hidden;
                    border-radius: 8px;
                    background: #f9fafb;
                }
                .promo-slide-img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain; /* 글자 안 잘리게 비율 맞춰 전체 노출 */
                    display: block;
                }

                /* 슬라이더 이동 버튼 */
                .promo-nav { position: absolute; top: 50%; transform: translateY(-50%); z-index: 20; background: rgba(0,0,0,0.05); border: none; color: #4b5563; width: 36px; height: 36px; border-radius: 50%; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; }
                .promo-nav:hover { background: rgba(0,0,0,0.1); }
                .promo-nav.prev { left: 14px; }
                .promo-nav.next { right: 14px; }

                /* 도트 인디케이터 */
                .promo-dots-bar { display: flex; justify-content: center; gap: 8px; margin-top: 10px; }
                .promo-dot { width: 8px; height: 8px; border-radius: 50%; background-color: #d1d5db; cursor: pointer; transition: 0.3s; }
                .promo-dot.active { background-color: #4b5563; width: 20px; border-radius: 5px; }

                /* 후기 그리드 레이아웃 */
                .review-slider-wrapper { position: relative; padding: 10px 0; }
                .review-grid { display: flex; overflow-x: auto; gap: 20px; padding-bottom: 10px; scroll-behavior: smooth; scroll-snap-type: x mandatory; }
                .review-grid::-webkit-scrollbar { display: none; }

                /* 리뷰 카드 설정 */
                .review-card { flex: 0 0 calc(33.333% - 13.4px); height: 360px; scroll-snap-align: start; transition: transform 0.3s ease; display: flex; flex-direction: column; text-decoration: none; color: inherit; background: #fff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border: 1px solid #f0f0f0; overflow: hidden; }
                .review-card:hover { transform: translateY(-5px); }

                .rev-content-box { padding: 25px 20px; display: flex; flex-direction: column; flex-grow: 1; justify-content: center; }

                .review-arrow { background: #fff; color: #333; border: 1px solid #ddd; width: 32px; height: 32px; border-radius: 50%; cursor: pointer; font-size: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: 0.2s; }
                .review-arrow:hover { background: #f8f9fa; border-color: #bbb; color: #007A8A; }

                /* 비디오 영역 스타일 */
                .inline-video-container { position: relative; border-radius: 12px; overflow: hidden; margin-top: 25px; height: 350px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); background: #000; cursor: pointer; }
                .inline-video-container video { width: 100%; height: 100%; object-fit: cover; }
                .inline-video-container.playing video { object-fit: contain; }
                .inline-video-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); display: flex; flex-direction: column; align-items: center; justify-content: center; color: #fff; transition: 0.3s; }
                .inline-video-container:hover .inline-video-overlay { background: rgba(0,0,0,0.5); }
                .inline-video-container.playing .inline-video-overlay { display: none; }
                .play-icon-circle { width: 55px; height: 55px; background: rgba(255,255,255,0.2); border: 2px solid #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 12px; backdrop-filter: blur(4px); transition: 0.3s; }
                .inline-video-container:hover .play-icon-circle { background: #007A8A; border-color: #007A8A; transform: scale(1.1); }

                .category-link { text-decoration: none; color: inherit; display: block; }
                .category-link:hover .category-card { border-color: #007A8A; transform: translateY(-3px); transition: 0.3s; }
            </style>

            <div class="search-wrapper">
                <form action="${pageContext.request.contextPath}/branch/search" method="get" class="search-bar-round">
                    <div class="search-item keyword-item">
                        <input type="text" name="keyword" id="keywordSearchInput" value="${keyword}" placeholder="어떤 공간을 찾으시나요?">
                    </div>
                    <div class="search-divider"></div>

                    <div class="search-item">
                        <input type="hidden" name="region" id="actualRegion" value="${region}">
                        <select id="citySelect" onchange="updateDistricts()">
                            <option value="">지역 전체</option>
                            <c:forEach var="city" items="${regionMap.keySet()}">
                                <option value="${city}">${city}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="search-divider"></div>

                    <div class="search-item">
                        <select id="districtSelect" onchange="updateRegionInput()" disabled>
                            <option value="">상세 지역</option>
                        </select>
                    </div>

                    <div class="search-divider"></div>
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

        <div id="promoWrapper">
            <div class="promo-slider-container" id="promoContainer">

                <button type="button" class="promo-close" onclick="closePromoBanner()" title="닫기">
                    <i class="fa-solid fa-xmark"></i>
                </button>

                <div class="promo-track" id="promoTrack">
                    <c:choose>
                        <c:when test="${not empty eventList}">
                            <c:forEach var="ev" items="${eventList}">
                                <a href="${pageContext.request.contextPath}/notice/detail?ntcIdx=${ev.ntcIdx}"
                                   class="promo-slide">
                                    <c:if test="${not empty ev.ntcImg}">
                                        <div class="promo-slide-img-col">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(ev.ntcImg, 'http')}">
                                                    <img src="${ev.ntcImg}" alt="${ev.ntcTitle}" class="promo-slide-img">
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="fullName" value="${ev.ntcImg}" />
                                                    <c:set var="fileName" value="${fn:contains(fullName, '/') ? fn:split(fullName, '/')[fn:length(fn:split(fullName, '/'))-1] : fullName}" />
                                                    <img src="${pageContext.request.contextPath}/static/upload/notice/${fileName}" alt="${ev.ntcTitle}" class="promo-slide-img">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>

                                    <div class="promo-slide-text">
                                        <span class="promo-slide-badge">EVENT</span>
                                        <h3 class="promo-slide-title">${ev.ntcTitle}</h3>
                                        <p class="promo-slide-date">
                                            <c:if test="${not empty ev.ntcCreated and fn:length(ev.ntcCreated) >= 10}">
                                                ${fn:substring(ev.ntcCreated, 0, 10)}
                                            </c:if>
                                        </p>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/notice/list?activeFilter=1" class="promo-slide">
                                <div>
                                    <span class="promo-slide-badge">EVENT</span>
                                    <h3 class="promo-slide-title">진행 중인 이벤트를 확인하세요</h3>
                                    <p class="promo-slide-date">Link Ora 공지/이벤트 페이지</p>
                                </div>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <button class="promo-nav prev" id="promoPrev">&#8249;</button>
                <button class="promo-nav next" id="promoNext">&#8250;</button>

            </div>

            <div class="promo-dots-bar" id="promoDots">
                <c:choose>
                    <c:when test="${not empty eventList}">
                        <c:forEach var="ev" items="${eventList}" varStatus="st">
                            <div class="promo-dot ${st.first ? 'active' : ''}"></div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="promo-dot active"></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div> <script>
        /* 이벤트 배너 영역 숨김 처리 기능 (이제 promoWrapper 안에 있는 배너만 숨겨요!) */
        function closePromoBanner() {
            document.getElementById('promoWrapper').style.display = 'none';
        }

        (function() {
            var track = document.getElementById('promoTrack');
            if (!track) return;
            var slides = track.querySelectorAll('.promo-slide');
            var n = slides.length;
            if (n === 0) return;
            track.style.width = (n * 100) + '%';
            for (var i = 0; i < n; i++) {
                slides[i].style.width = (100 / n) + '%';
            }
        })();
        </script>

        <section class="content-layout">
            <div class="content-left">
                <div class="section-header"><h2>공간 찾아보기</h2></div>
                <div class="category-grid">
                    <a href="${pageContext.request.contextPath}/branch/search?type=INDIVIDUAL" class="category-link">
                        <div class="category-card">
                            <i class="fa-solid fa-door-closed"></i>
                            <div>
                                <h3>프라이빗 오피스</h3>
                                <p>개인을 위한 독립된 공간</p>
                            </div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/branch/search?type=GROUP" class="category-link">
                        <div class="category-card">
                            <i class="fa-solid fa-laptop"></i>
                            <div>
                                <h3>코워킹 스페이스</h3>
                                <p>자유로운 업무 환경 (회의실/오픈 오피스)</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="map-tab-header" style="display: flex !important; justify-content: space-between !important; align-items: center !important; margin-bottom: 20px;">
                    <div class="map-tab-container" style="display: flex !important; align-items: center !important; gap: 8px;">
                        <h2 class="tab-title active" id="tabNear" style="margin: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #2F4F4F;">주변 지점</h2>
                        <span class="tab-divider" style="font-size: 18px; color: #ddd; margin: 0 4px;">/</span>
                        <h2 class="tab-title inactive" id="tabFavorite" style="margin: 0 !important; font-size: 20px; font-weight: 800; cursor: pointer; color: #bbb;">관심 지점</h2>
                    </div>
                    <a href="${pageContext.request.contextPath}/map" class="map-view-all" style="display: inline-block !important; font-size: 13px !important; font-weight: 700 !important; color: #007A8A !important; text-decoration: none !important; padding: 6px 14px !important; background-color: #f0f8f8 !important; border-radius: 20px !important;">
                        지도로 크게 보기 <i class="fa-solid fa-map-location-dot" style="margin-left: 2px;"></i>
                    </a>
                </div>

                <div class="wework-map-left" style="position: relative; border-radius: 12px; height: 350px; overflow: hidden; border: 1px solid #eee;">
                    <div id="mainMap" style="width: 100%; height: 350px;"></div>
                </div>
            </div>

            <div class="wework-list-right">
                <div class="section-header"><h2>주요 소식</h2><a href="${pageContext.request.contextPath}/notice/list" class="more-link">자세히 보기</a></div>
                <ul class="board-list">
                    <c:choose>
                        <c:when test="${not empty noticeList}">
                            <c:forEach var="n" items="${noticeList}">
                                <li>
                                    <c:choose>
                                        <c:when test="${n.ntcActive % 2 == 1}">
                                            <span class="tag event">이벤트</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="tag notice">공지</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/notice/detail?ntcIdx=${n.ntcIdx}">${n.ntcTitle}</a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><span class="tag notice">공지</span> <a href="${pageContext.request.contextPath}/notice/list">등록된 공지/이벤트가 없습니다.</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <div class="inline-video-container" id="tourVideoContainer" onclick="playTourVideo()">
                    <video id="tourVideo" src="${pageContext.request.contextPath}/static/upload/video/office_tour.mp4" poster="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80" playsinline></video>

                    <div class="inline-video-overlay" id="tourVideoOverlay">
                        <div class="play-icon-circle"><i class="fa-solid fa-play" style="margin-left: 4px;"></i></div>
                        <h4 style="margin: 0; font-size: 18px; font-weight: 700; letter-spacing: 0.5px;">1분 랜선 투어 & 소개</h4>
                        <span style="font-size: 13px; opacity: 0.8; margin-top: 6px;">영상이 끝나면 소개 영상이 이어집니다</span>
                    </div>
                </div>
            </div>
        </section>

        <section class="review-section" style="margin-top: 60px; margin-bottom: 80px;">
            <div class="section-header" style="display: flex; justify-content: space-between; align-items: flex-end; border-bottom: 1px solid #222; padding-bottom: 15px; margin-bottom: 25px;">
                <div style="display: flex; flex-direction: column; gap: 5px;">
                    <h2 style="margin: 0; font-size: 22px; font-weight: 800; color: #222;">이용자들의 솔직한 후기</h2>
                    <span class="sub-title" style="color: #888; font-size: 13px;">실제 방문객들이 남긴 베스트 Review</span>
                </div>

                <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 5px;">
                    <a href="${pageContext.request.contextPath}/review/all" class="more-link" style="font-size: 14px; font-weight: 600; color: #007A8A; text-decoration: none; margin: 0;">
                        모든 리뷰 보기 <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
                    </a>

                    <div style="display: flex; gap: 8px; margin-left: 5px;">
                        <button class="review-arrow prev" onclick="scrollReview(-1)"><i class="fa-solid fa-chevron-left"></i></button>
                        <button class="review-arrow next" onclick="scrollReview(1)"><i class="fa-solid fa-chevron-right"></i></button>
                    </div>
                </div>
            </div>

            <div class="review-slider-wrapper">
                <div class="review-grid" id="reviewGrid">
                    <c:choose>
                        <c:when test="${not empty recentReviews}">
                            <c:forEach var="rev" items="${recentReviews}">
                                <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${rev.brnIdx}" class="review-card">
                                    <div class="rev-img-box" style="height: 180px; flex-shrink: 0; overflow: hidden;">
                                        <c:set var="revImgName" value="${rev.revImg}" />
                                        <c:set var="revImgOnly" value="${fn:contains(revImgName, '/') ? fn:split(revImgName, '/')[fn:length(fn:split(revImgName, '/'))-1] : revImgName}" />

                                        <c:choose>
                                            <c:when test="${not empty rev.revImg}">
                                                <img src="${pageContext.request.contextPath}/static/upload/review/${revImgOnly}" style="width: 100%; height: 100%; object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width:100%; height:100%; background:linear-gradient(135deg,#e8f0ef,#d1e1e1);
                                                            display:flex; align-items:center; justify-content:center;
                                                            color:#a3b8b8; font-size:2rem; font-weight:700; letter-spacing:2px; user-select:none;">
                                                    WS
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="rev-content-box">
                                        <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                            <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">
                                                [<c:out value="${rev.branchName}" default="지점명"/>]
                                            </span>
                                            <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                            <span style="font-weight: 700; font-size: 14px; color: #333;">${rev.revRating}</span>
                                        </div>
                                        <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                            "${rev.revContent}"
                                        </p>
                                        <div class="rev-info" style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                            <span style="font-weight: 700; font-size: 13px;">${rev.authorName}</span>
                                            <span style="color: #999; font-size: 12px;">${rev.revCreatedAt}</span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; justify-content: center; align-items: center; width: 100%; height: 200px; background: #f9f9f9; border: 1px dashed #ddd; border-radius: 12px;">
                                <p style="color: #999; font-size: 15px; margin: 0;">등록된 후기가 없습니다.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const tabNear = document.getElementById('tabNear');
            const tabFavorite = document.getElementById('tabFavorite');

            // 세션에서 로그인 상태를 확인해요
            const isLoggedIn = "${not empty sessionScope.userIdx || not empty sessionScope.user || not empty sessionScope.loginUser}";

            if(tabFavorite) {
                // 관심 지점 클릭 시 캡처링으로 먼저 가로채기
                tabFavorite.addEventListener('click', (e) => {
                    if (isLoggedIn === "false") {
                        e.preventDefault();
                        e.stopImmediatePropagation(); // 기존 맵 스크립트가 실행되는 걸 차단해요
                        alert("로그인이 필요한 서비스입니다.");
                        window.location.href = "${pageContext.request.contextPath}/loginPage"; // 로그인 창으로 이동
                    }
                }, true);
            }

            if(tabNear) {
                // 주변 지점 클릭 시 지도가 꼬이는 현상을 막기 위해 새로고침으로 완벽히 초기화해요
                tabNear.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopImmediatePropagation();

                    tabFavorite.classList.remove('active');
                    tabFavorite.classList.add('inactive');
                    tabFavorite.style.color = '#bbb';

                    tabNear.classList.remove('inactive');
                    tabNear.classList.add('active');
                    tabNear.style.color = '#2F4F4F';

                    // 0.05초 뒤에 메인 페이지로 다시 돌아오면서 지도를 초기 상태로 만들어요
                    setTimeout(() => {
                        window.location.href = "${pageContext.request.contextPath}/";
                    }, 50);
                }, true);
            }
        });
    </script>

    <script>
        function playTourVideo() {
            const video = document.getElementById('tourVideo');
            const container = document.getElementById('tourVideoContainer');
            if (video.paused) {
                video.controls = true;
                video.play();
                container.classList.add('playing');
            }
        }

        document.getElementById('tourVideo').onended = function() {
            const introSrc = "${pageContext.request.contextPath}/static/upload/video/link_ora.mp4";
            if (this.src.includes('office_tour.mp4')) {
                this.src = introSrc;
                this.play();
            }
        };

        function scrollReview(direction) {
            const grid = document.getElementById('reviewGrid');
            const card = grid.querySelector('.review-card');
            if(card) {
                const scrollAmount = card.offsetWidth + 20;
                grid.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
            }
        }

        const districtMap = {
            <c:forEach var="entry" items="${regionMap}" varStatus="status">
                "${entry.key}": [
                    <c:forEach var="dist" items="${entry.value}" varStatus="distStatus">
                        "${dist}"${!distStatus.last ? ',' : ''}
                    </c:forEach>
                ]${!status.last ? ',' : ''}
            </c:forEach>
        };

        function updateRegionInput() {
            const city = document.getElementById('citySelect').value;
            const district = document.getElementById('districtSelect').value;
            const actualRegion = document.getElementById('actualRegion');
            actualRegion.value = (city && district) ? city + " " + district : (city || "");
        }

        function updateDistricts() {
            const city = document.getElementById('citySelect').value;
            const districtSelect = document.getElementById('districtSelect');
            districtSelect.innerHTML = '<option value="">상세 지역</option>';
            if (city && districtMap[city]) {
                districtSelect.disabled = false;
                districtMap[city].forEach(dist => {
                    const option = document.createElement('option');
                    option.value = dist;
                    option.textContent = dist;
                    districtSelect.appendChild(option);
                });
            } else {
                districtSelect.disabled = true;
            }
            updateRegionInput();
        }

        document.addEventListener('DOMContentLoaded', () => {
            const savedRegion = "${region}";
            if (savedRegion) {
                const parts = savedRegion.split(' ');
                const citySelect = document.getElementById('citySelect');
                if (citySelect && [...citySelect.options].some(opt => opt.value === parts[0])) {
                    citySelect.value = parts[0];
                    updateDistricts();
                    if (parts[1]) document.getElementById('districtSelect').value = parts[1];
                }
            }
        });
    </script>

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=fec0b7e758b0fe490d54b99dbb1ad08c&libraries=services&autoload=false"></script>
    <script src="${pageContext.request.contextPath}/static/js/mp_script.js?v=9999"></script>

</main>

<%@ include file="layout/footer.jsp" %>
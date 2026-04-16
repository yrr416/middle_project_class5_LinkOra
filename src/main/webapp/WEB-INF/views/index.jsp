<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                .search-item select:disabled { background-color: #f5f5f5 !important; cursor: not-allowed !important; color: #ccc !important; }
                .search-bar-round { max-width: 1000px !important; }

                /* 광고 슬라이더 비율 및 높이 조정 */
                .promo-slider-container { position: relative; overflow: hidden; border-radius: 12px; border: 1px solid #eee; background: #fff; margin-top: 30px; height: 180px; }
                .promo-track { display: flex; transition: transform 0.5s ease-in-out; width: 300%; height: 100%; }
                .promo-slide { width: 33.333%; flex-shrink: 0; display: flex; align-items: center; text-decoration: none; color: inherit; height: 100%; padding: 15px; box-sizing: border-box; }

                /* 이미지 크기 축소 */
                .promo-image { flex: 0 0 250px; height: 100%; border-radius: 8px; overflow: hidden; }
                .promo-image img { width: 100%; height: 100%; object-fit: cover; }

                /* 텍스트 영역 확장 */
                .promo-text { flex: 1; padding: 0 25px; display: flex; flex-direction: column; justify-content: center; text-align: left; }
                .promo-text h3 { font-size: 20px; font-weight: 800; margin: 0 0 8px 0; color: #222; }
                .promo-text p { font-size: 14px; color: #666; line-height: 1.5; margin: 0; }

                /* 슬라이더 점 디자인 */
                .promo-dots { position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); display: flex; gap: 8px; z-index: 10; }
                .promo-dot { width: 10px; height: 10px; border-radius: 50%; background-color: #e0e0e0; cursor: pointer; transition: 0.3s; border: 1px solid #ddd; }
                .promo-dot.active { background-color: #007A8A; width: 25px; border-radius: 5px; border-color: #007A8A; }

                /* 후기 슬라이더 스타일 수정 */
                .review-slider-wrapper { position: relative; padding: 10px 0; }
                .review-grid { display: flex; overflow-x: auto; gap: 20px; padding-bottom: 10px; scroll-behavior: smooth; scroll-snap-type: x mandatory; }
                .review-grid::-webkit-scrollbar { display: none; }

                /* 모든 카드의 높이를 360px로 고정 */
                .review-card { flex: 0 0 calc(33.333% - 13.4px); height: 360px; scroll-snap-align: start; transition: transform 0.3s ease; display: flex; flex-direction: column; text-decoration: none; color: inherit; background: #fff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border: 1px solid #f0f0f0; overflow: hidden; }
                .review-card:hover { transform: translateY(-5px); }

                /* 텍스트 컨텐츠 박스 가운데 정렬 */
                .rev-content-box { padding: 25px 20px; display: flex; flex-direction: column; flex-grow: 1; justify-content: center; }

                .review-arrow { background: #fff; color: #333; border: 1px solid #ddd; width: 32px; height: 32px; border-radius: 50%; cursor: pointer; font-size: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: 0.2s; }
                .review-arrow:hover { background: #f8f9fa; border-color: #bbb; color: #007A8A; }

                /* 랜선 투어 인라인 비디오 스타일 */
                .inline-video-container { position: relative; border-radius: 12px; overflow: hidden; margin-top: 25px; height: 350px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); background: #000; cursor: pointer; }
                .inline-video-container video { width: 100%; height: 100%; object-fit: cover; }
                .inline-video-container.playing video { object-fit: contain; }
                .inline-video-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); display: flex; flex-direction: column; align-items: center; justify-content: center; color: #fff; transition: 0.3s; }
                .inline-video-container:hover .inline-video-overlay { background: rgba(0,0,0,0.5); }
                .inline-video-container.playing .inline-video-overlay { display: none; }
                .play-icon-circle { width: 55px; height: 55px; background: rgba(255,255,255,0.2); border: 2px solid #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 12px; backdrop-filter: blur(4px); transition: 0.3s; }
                .inline-video-container:hover .play-icon-circle { background: #007A8A; border-color: #007A8A; transform: scale(1.1); }
            </style>

            <div class="search-wrapper">
                <form action="${pageContext.request.contextPath}/branch/search" method="get" class="search-bar-round">
                    <div class="search-item keyword-item">
                        <input type="text" name="keyword" id="keywordSearchInput" value="${keyword}" placeholder="어떤 공간을 찾으시나요?">
                    </div>
                    <div class="search-divider"></div>
                    <div class="search-item">
                        <select id="citySelect" onchange="updateDistricts()">
                            <option value="">지역 전체</option>
                            <option value="서울">서울특별시</option>
                            <option value="인천">인천광역시</option>
                        </select>
                    </div>
                    <div class="search-divider"></div>
                    <div class="search-item">
                        <select name="region" id="districtSelect" disabled>
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
        <div class="promo-slider-container" id="promoContainer">
            <button class="close-promo" id="closePromoBtn" style="position: absolute; top: 12px; right: 15px; z-index: 10; font-size: 16px; color: #bbb; border: none; background: transparent; cursor: pointer;"><i class="fa-solid fa-xmark"></i></button>

            <div class="promo-track" id="promoTrack">
                <c:choose>
                    <c:when test="${not empty promos}">
                        <c:forEach var="p" items="${promos}">
                            <a href="${p.proLink}" class="promo-slide">
                                <div class="promo-image"><img src="${p.proImgPath}" alt="${p.proTitle}"></div>
                                <div class="promo-text">
                                    <h3>${p.proTitle}</h3>
                                    <p>클릭하여 상세 정보와 특별한 혜택을 확인해보세요.</p>
                                </div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="promo-slide">
                            <div class="promo-image"><img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=600&q=80"></div>
                            <div class="promo-text">
                                <h3>1. 신규 하이엔드 라운지 오픈 특가</h3>
                                <p>강남/송도 신규 지점 오픈 기념, 이번 달 한정 최대 30% 할인 혜택을 드립니다.</p>
                            </div>
                        </a>
                        <a href="#" class="promo-slide">
                            <div class="promo-image"><img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=600&q=80"></div>
                            <div class="promo-text">
                                <h3>2. 첫 예약 고객 5,000원 쿠폰 증정</h3>
                                <p>지금 가입하고 첫 미팅룸 이용 시 즉시 사용 가능한 할인 쿠폰을 받아보세요.</p>
                            </div>
                        </a>
                        <a href="#" class="promo-slide">
                            <div class="promo-image"><img src="https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2?auto=format&fit=crop&w=600&q=80"></div>
                            <div class="promo-text">
                                <h3>3. 기업 멤버십 프리미엄 패키지 안내</h3>
                                <p>우리 팀만의 전용 오피스, 가장 합리적인 조건으로 계약할 수 있는 기회입니다.</p>
                            </div>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="promo-dots" id="promoDots">
                <div class="promo-dot active"></div>
                <div class="promo-dot"></div>
                <div class="promo-dot"></div>
            </div>
        </div>

        <section class="content-layout">
            <div class="content-left">
                <div class="section-header"><h2>공간 찾아보기</h2></div>
                <div class="category-grid">
                    <div class="category-card">
                        <i class="fa-solid fa-door-closed"></i>
                        <div>
                            <h3>프라이빗 오피스</h3>
                            <p>개인을 위한 독립된 공간</p>
                        </div>
                    </div>

                    <div class="category-card">
                        <i class="fa-solid fa-laptop"></i>
                        <div>
                            <h3>코워킹 스페이스</h3>
                            <p>자유로운 업무 환경 (회의실/오픈 오피스)</p>
                        </div>
                    </div>
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
                            <li><span class="tag event">EVENT</span> <a href="#">신규 회원 1일 무료 체험권 증정</a></li>
                            <li><span class="tag notice">공지</span> <a href="#">2026년 상반기 멤버십 요금 안내</a></li>
                            <li><span class="tag notice">공지</span> <a href="#">홍대점 시설 점검에 따른 주말 휴관 안내</a></li>
                            <li><span class="tag event">EVENT</span> <a href="#">지인 추천 시 스타벅스 기프티콘 100% 당첨</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <div class="inline-video-container" id="tourVideoContainer" onclick="playTourVideo()">
                    <video id="tourVideo" src="${pageContext.request.contextPath}/static/upload/video/office_tour.mp4" poster="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80" playsinline></video>

                    <div class="inline-video-overlay" id="tourVideoOverlay">
                        <div class="play-icon-circle"><i class="fa-solid fa-play" style="margin-left: 4px;"></i></div>
                        <h4 style="margin: 0; font-size: 18px; font-weight: 700; letter-spacing: 0.5px;">1분 랜선 투어</h4>
                        <span style="font-size: 13px; opacity: 0.8; margin-top: 6px;">Link Ora 공간 미리보기</span>
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
                    <a href="${pageContext.request.contextPath}/detail/list" class="more-link" style="font-size: 14px; font-weight: 600; color: #007A8A; text-decoration: none; margin: 0;">
                        모든 지점 보러가기 <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
                    </a>

                    <div style="display: flex; gap: 8px; margin-left: 5px;">
                        <button class="review-arrow prev" onclick="scrollReview(-1)"><i class="fa-solid fa-chevron-left"></i></button>
                        <button class="review-arrow next" onclick="scrollReview(1)"><i class="fa-solid fa-chevron-right"></i></button>
                    </div>
                </div>
            </div>

            <div class="review-slider-wrapper">
                <div class="review-grid" id="reviewGrid">
                    <c:forEach var="rev" items="${recentReviews}">
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=${rev.revIdx}" class="review-card">
                            <div class="rev-img-box" style="height: 180px; flex-shrink: 0; overflow: hidden;">
                                <c:choose>
                                    <c:when test="${not empty rev.revImg}">
                                        <img src="${pageContext.request.contextPath}/static/upload/review/${rev.revImg}"
                                             style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/static/images/default_office.png"
                                             style="width: 100%; height: 100%; object-fit: cover;">
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

                    <c:if test="${empty recentReviews}">
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=1" class="review-card">
                            <div class="rev-content-box">
                                <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                    <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">[강남점]</span>
                                    <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                    <span style="font-weight: 700; font-size: 14px; color: #333;">4.5</span>
                                </div>
                                <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                    "회의실 예약이 간편해서 프로젝트 미팅할 때마다 여기만 이용합니다. 역이랑 가까워서 팀원들이 다 좋아해요!"
                                </p>
                                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 700; font-size: 13px;">Workholic</span>
                                    <span style="color: #999; font-size: 12px;">2026-04-10</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=2" class="review-card">
                            <div class="rev-img-box" style="height: 180px; flex-shrink: 0; overflow: hidden;">
                                <img src="https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=400&q=60" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div class="rev-content-box">
                                <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                    <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">[송도점]</span>
                                    <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                    <span style="font-weight: 700; font-size: 14px; color: #333;">5.0</span>
                                </div>
                                <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                    "인테리어가 카페 같아서 일할 맛이 나네요. 화상회의 부스도 따로 있어서 유용하게 썼습니다."
                                </p>
                                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 700; font-size: 13px;">디자인크루</span>
                                    <span style="color: #999; font-size: 12px;">2026-04-08</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=3" class="review-card">
                            <div class="rev-content-box">
                                <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                    <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">[홍대점]</span>
                                    <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                    <span style="font-weight: 700; font-size: 14px; color: #333;">4.0</span>
                                </div>
                                <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                    "프린터 이용이 무료라서 서류 작업할 때 아주 요긴합니다. 고층이라 시티뷰도 너무 예뻐요. 다음에도 여기로 예약할 예정입니다."
                                </p>
                                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 700; font-size: 13px;">코딩하는라이언</span>
                                    <span style="color: #999; font-size: 12px;">2026-04-05</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=4" class="review-card">
                            <div class="rev-img-box" style="height: 180px; flex-shrink: 0; overflow: hidden;">
                                <img src="https://images.unsplash.com/photo-1556761175-5973dc0f32b7?auto=format&fit=crop&w=400&q=60" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div class="rev-content-box">
                                <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                    <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">[여의도점]</span>
                                    <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                    <span style="font-weight: 700; font-size: 14px; color: #333;">5.0</span>
                                </div>
                                <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                    "라운지 공간이 넓고 쾌적해서 미팅 전후로 휴식하기 정말 좋습니다. 직원분들도 아주 친절하셔요."
                                </p>
                                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 700; font-size: 13px;">스타트업CEO</span>
                                    <span style="color: #999; font-size: 12px;">2026-04-03</span>
                                </div>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/review/detail?revIdx=5" class="review-card">
                            <div class="rev-content-box">
                                <div class="rev-stars" style="display: flex; align-items: center; margin-bottom: 12px;">
                                    <span style="background: #f0f4f4; color: #007A8A; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; margin-right: 8px;">[성수점]</span>
                                    <i class="fa-solid fa-star" style="color: #ffc107; margin-right: 4px;"></i>
                                    <span style="font-weight: 700; font-size: 14px; color: #333;">4.5</span>
                                </div>
                                <p style="font-size: 14px; color: #444; line-height: 1.6; height: 4.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; margin: 0;">
                                    "방음이 잘 되어서 화상회의 할 때 눈치 보이지 않고 편하게 할 수 있었어요. 모니터 대여도 가능해서 좋았습니다."
                                </p>
                                <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 700; font-size: 13px;">프리랜서개발자</span>
                                    <span style="color: #999; font-size: 12px;">2026-04-01</span>
                                </div>
                            </div>
                        </a>
                    </c:if>
                </div>
            </div>
        </section>

    </div>

    <script>
        // 랜선 투어 비디오 재생 처리 함수 (이건 겹치지 않아서 그대로 뒀어!)
        function playTourVideo() {
            const video = document.getElementById('tourVideo');
            const container = document.getElementById('tourVideoContainer');

            if (video.paused) {
                video.controls = true;
                video.play();
                container.classList.add('playing');
            }
        }

        // 리뷰 좌우 스크롤 기능 (이것도 HTML 전용 기능이라 그대로 뒀어!)
        function scrollReview(direction) {
            const grid = document.getElementById('reviewGrid');
            const card = grid.querySelector('.review-card');
            if(card) {
                const scrollAmount = card.offsetWidth + 20;
                grid.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
            }
        }

        // 지역 선택 기능 (마찬가지로 그대로 유지!)
        const districtMap = {
            "서울": ["강남구", "서초구", "종로구", "마포구", "송파구", "영등포구", "성동구"],
            "인천": ["남동구", "연수구", "부평구", "미추홀구", "서구", "중구", "동구"]
        };

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
        }
    </script>

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=cd1f0f4ad9dcf4879bee2531dc5a0497&libraries=services&autoload=false"></script>
    <script src="${pageContext.request.contextPath}/js/mp_script.js"></script>

</main>

<%@ include file="layout/footer.jsp" %>
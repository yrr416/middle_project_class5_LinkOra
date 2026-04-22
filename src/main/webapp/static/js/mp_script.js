/* mp_script.js - 모든 기능 통합 & 리뷰 슬라이드 및 지도 핀 복구 */

// 전역 알림 중복 방지 변수
window.isLoginAlertShown = false;

document.addEventListener('DOMContentLoaded', () => {

    // 1. 사이드바 및 아코디언 제어
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const sidebar = document.getElementById('sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');

    if (hamburgerBtn) hamburgerBtn.onclick = () => {
        sidebar.classList.add('active');
        sidebarOverlay.classList.add('active');
    };

    if (document.getElementById('closeSidebar'))
        document.getElementById('closeSidebar').onclick = () => {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        };

    if (sidebarOverlay) sidebarOverlay.onclick = () => {
        sidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
    };

    document.querySelectorAll('.accordion-toggle, .menu-header').forEach(header => {
        header.onclick = (e) => {
            if (header.tagName === 'A') e.preventDefault();
            header.parentElement.classList.toggle('active');
        };
    });

    document.querySelectorAll('.sidebar-nav a').forEach(link => {
        link.addEventListener('click', (e) => {
            if (!link.classList.contains('accordion-toggle') && link.getAttribute('href') !== '#') {
                sidebar.classList.remove('active');
                sidebarOverlay.classList.remove('active');
            }
        });
    });

    // 2. 프로모션(광고) 슬라이드 제어
    const promoContainer = document.getElementById('promoContainer');
    const promoTrack = document.getElementById('promoTrack');
    const promoDots = document.querySelectorAll('.promo-dot');
    const closePromoBtn = document.getElementById('closePromoBtn');

    if (promoContainer && promoTrack && promoDots.length > 0) {
        let currentSlide = 0;
        const totalSlides = promoDots.length;
        let slideInterval;

        const goToSlide = (index) => {
            promoTrack.style.transform = `translateX(-${index * 100}%)`;
            promoDots.forEach(dot => dot.classList.remove('active'));
            promoDots[index].classList.add('active');
            currentSlide = index;
        };

        const nextSlide = () => {
            let next = (currentSlide + 1) % totalSlides;
            goToSlide(next);
        };

        const startSlide = () => {
            clearInterval(slideInterval);
            slideInterval = setInterval(nextSlide, 3000);
        };
        const stopSlide = () => { clearInterval(slideInterval); };

        startSlide();
        promoContainer.addEventListener('mouseenter', stopSlide);
        promoContainer.addEventListener('mouseleave', startSlide);

        promoDots.forEach((dot, index) => {
            dot.addEventListener('click', () => {
                goToSlide(index);
                startSlide();
            });
        });

        // 좌우 화살표 버튼
        const promoPrevBtn = document.getElementById('promoPrev');
        const promoNextBtn = document.getElementById('promoNext');

        if (promoPrevBtn) {
            promoPrevBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                goToSlide((currentSlide - 1 + totalSlides) % totalSlides);
                startSlide();
            });
        }
        if (promoNextBtn) {
            promoNextBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                goToSlide((currentSlide + 1) % totalSlides);
                startSlide();
            });
        }

        if (closePromoBtn) {
            closePromoBtn.addEventListener('click', () => {
                promoContainer.style.display = 'none';
            });
        }
    }

    // 3. 리뷰(Stories) 슬라이드 제어
    const reviewTrack = document.getElementById('reviewTrack');
    const prevReview = document.getElementById('prevReview');
    const nextReview = document.getElementById('nextReview');

    if (reviewTrack && prevReview && nextReview) {
        let currentReviewIdx = 0;

        reviewTrack.style.display = 'flex';
        reviewTrack.style.transition = 'transform 0.4s ease-in-out';

        const reviewSlides = reviewTrack.querySelectorAll('.review-slide-mini');
        reviewSlides.forEach(slide => {
            slide.style.minWidth = '100%';
            slide.style.boxSizing = 'border-box';
        });

        const totalReviewSlides = reviewSlides.length;

        const moveReview = (direction) => {
            if (totalReviewSlides === 0) return;

            if (direction === 'next') {
                currentReviewIdx = (currentReviewIdx + 1) % totalReviewSlides;
            } else {
                currentReviewIdx = (currentReviewIdx - 1 + totalReviewSlides) % totalReviewSlides;
            }

            reviewTrack.style.transform = `translateX(-${currentReviewIdx * 100}%)`;
        };

        prevReview.addEventListener('click', () => moveReview('prev'));
        nextReview.addEventListener('click', () => moveReview('next'));
    }

    // 4. 카카오맵 설정
    const mapContainer = document.getElementById('mainMap');
    if (!mapContainer) {
        if (typeof bindSearchEvents === "function") bindSearchEvents();
        return;
    }

    const loadKakaoMap = () => {
        if (typeof window.kakao !== 'undefined' && window.kakao.maps) {
            if (window.kakao.maps.Map) {
                initMapProcess();
            } else {
                window.kakao.maps.load(initMapProcess);
            }
            return;
        }

        if (!document.querySelector('script[src*="dapi.kakao.com"]')) {
            const script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=f46b246e453c7ccbab5a79c4aa737bcc&libraries=services&autoload=false';
            script.onload = () => { window.kakao.maps.load(initMapProcess); };
            document.head.appendChild(script);
        } else {
            setTimeout(loadKakaoMap, 100);
        }
    };

    loadKakaoMap();

    function initMapProcess() {
        let centerLatLng = new window.kakao.maps.LatLng(37.4775, 126.6325);
        const mapOption = { center: centerLatLng, level: 4 };
        const map = new window.kakao.maps.Map(mapContainer, mapOption);

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition((position) => {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                const myPos = new window.kakao.maps.LatLng(lat, lng);

                map.setCenter(myPos);
                centerLatLng = myPos;

                window.loadBranches("", "all");
            }, (err) => {
                console.warn("GPS 획득 실패, 기본 위치로 로드함.");
                window.loadBranches("", "all");
            });
        } else {
            window.loadBranches("", "all");
        }

        setTimeout(() => { map.relayout(); map.setCenter(centerLatLng); }, 100);

        const resizeObserver = new ResizeObserver(() => {
            map.relayout();
            map.setCenter(centerLatLng);
        });
        resizeObserver.observe(mapContainer);

        let activeInfoOverlay = null;

        const tabNear = document.getElementById('tabNear');
        const tabFavorite = document.getElementById('tabFavorite');

        if (tabNear && tabFavorite) {
            tabNear.addEventListener('click', () => {
                tabNear.classList.add('active'); tabNear.classList.remove('inactive');
                tabFavorite.classList.add('inactive'); tabFavorite.classList.remove('active');
                if (activeInfoOverlay) activeInfoOverlay.setMap(null);
                window.loadBranches("", "all");
            });

            tabFavorite.addEventListener('click', () => {
                tabFavorite.classList.add('active'); tabFavorite.classList.remove('inactive');
                tabNear.classList.add('inactive'); tabNear.classList.remove('active');
                if (activeInfoOverlay) activeInfoOverlay.setMap(null);
                window.loadBranches("", "favorite");
            });
        }

        const pinImg = "data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 384 512'%3E%3Cpath fill='%232F4F4F' d='M215.7 499.2C267 435 384 279.4 384 192C384 86 298 0 192 0S0 86 0 192c0 87.4 117 243 168.3 307.2c12.3 15.3 35.1 15.3 47.4 0zM192 128a64 64 0 1 1 0 128 64 64 0 1 1 0-128z'/%3E%3C/svg%3E";
        const markerImage = new window.kakao.maps.MarkerImage(pinImg, new window.kakao.maps.Size(26, 34));

        let markers = [];
        let overlays = [];

        window.kakao.maps.event.addListener(map, 'click', () => {
            if (activeInfoOverlay) activeInfoOverlay.setMap(null);
        });

        window.loadBranches = function(keyword = "", type = "all") {

            markers.forEach(m => m.setMap(null));
            overlays.forEach(o => o.setMap(null));
            if (activeInfoOverlay) activeInfoOverlay.setMap(null);
            markers = []; overlays = [];

            const cp = window.contextPath || "";
            let fetchUrl = "";

            if (type === "favorite") {
                fetchUrl = `${cp}/api/wishlist/my`;
            } else if (!keyword || keyword.trim() === "") {
                fetchUrl = `${cp}/api/all-branches`;
            } else {
                fetchUrl = `${cp}/api/branches?keyword=${encodeURIComponent(keyword)}`;
                const isMapPage = location.pathname.includes('/map');
                if (centerLatLng && !isMapPage) {
                    fetchUrl += `&lat=${centerLatLng.getLat()}&lng=${centerLatLng.getLng()}`;
                }
            }

            fetch(fetchUrl)
                .then(res => {
                    if (!res.ok) throw new Error("API 서버 응답 에러: " + res.status);
                    return res.json();
                })
                .then(branches => {
                    if (branches.status === 'login_required') {
                        if (!window.isLoginAlertShown) {
                            alert("로그인이 필요한 서비스입니다.");
                            window.isLoginAlertShown = true;
                            setTimeout(() => { window.isLoginAlertShown = false; }, 1500);
                        }
                        return;
                    }

                    if (!Array.isArray(branches)) {
                        console.warn("데이터 형식이 올바르지 않습니다.");
                        return;
                    }

                    if (branches.length === 0) {
                        console.warn("표시할 지점이 없습니다.");
                        return;
                    }

                    branches.forEach(branch => {
                        if (branch.brnLatitude && branch.brnLongitude) {
                            const markerPos = new window.kakao.maps.LatLng(branch.brnLatitude, branch.brnLongitude);

                            const marker = new window.kakao.maps.Marker({ position: markerPos, image: markerImage, map: map });
                            markers.push(marker);

                            const labelWrap = document.createElement('div');
                            labelWrap.style.cssText = `display:flex; align-items:center; background:white; color:#2F4F4F; padding:6px 16px; border-radius:10px; border:2px solid #cccccc; box-shadow:0 4px 15px rgba(0,0,0,0.2); font-family:'Pretendard',sans-serif; font-size:14px; font-weight:800; white-space:nowrap; position:relative; cursor:pointer;`;
                            labelWrap.innerHTML = `
                                <div style="width:4px; height:14px; background:#d4af37; margin-right:10px; border-radius:2px;"></div>
                                ${branch.brnName}
                                <div style="position:absolute; bottom:-11px; left:50%; transform:translateX(-50%); width:0; height:0; border-left:8px solid transparent; border-right:8px solid transparent; border-top:10px solid #2F4F4F;"></div>
                            `;

                            const labelOverlay = new window.kakao.maps.CustomOverlay({ position: markerPos, content: labelWrap, yAnchor: 2.3, zIndex: 99 });
                            labelOverlay.setMap(map); overlays.push(labelOverlay);

                            const openInfoOverlay = () => {
                                if (activeInfoOverlay) activeInfoOverlay.setMap(null);

                                const contentWrap = document.createElement('div');
                                const descText = branch.brnDescription ? branch.brnDescription : '프리미엄 공유 오피스';

                                // 🚨 핵심 수정 부분! 올바른 주소 /linkora/detail/detail 로 100% 변경함!
                                contentWrap.innerHTML = `
                                    <div style="background:white; border-radius:12px; box-shadow:0 10px 25px rgba(0,0,0,0.2); width:210px; border:1px solid #eee; padding:15px; margin-bottom: 110px;">
                                        <div style="font-weight:800; font-size:15px; color:#2F4F4F; margin-bottom:5px;">${branch.brnName}</div>
                                        <div style="font-size:11px; color:#666; margin-bottom:4px; line-height:1.4;">${branch.brnAddress}</div>
                                        <div style="font-size:11px; color:#007bff; margin-bottom:12px; font-weight:600;">${descText}</div>
                                        <div style="display:flex; gap:8px;">
                                            <button class="detailBtn" style="flex:1; background:#2F4F4F; color:white; border:none; padding:8px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer;">상세보기</button>
                                            <button class="wishBtn wish-btn" style="width:42px; height:42px; background:white; border:1px solid #ddd; border-radius:10px; color:${branch.isWish ? '#ff4757' : '#bbb'}; cursor:pointer; display:flex; align-items:center; justify-content:center;">
                                                <i class="${branch.isWish ? 'fa-solid' : 'fa-regular'} fa-heart" style="pointer-events:none;"></i>
                                            </button>
                                        </div>
                                    </div>`;

                                // [수정된 부분] 알림창(alert)을 완전히 지우고 주소 이동만 남겼어!
                                contentWrap.querySelector('.detailBtn').addEventListener('click', () => {
                                    const contextPath = "/linkora"; // 사용자님의 context-path 설정값
                                    location.href = contextPath + "/detail/detail?brnIdx=" + branch.brnIdx;
                                });

                                const wishBtn = contentWrap.querySelector('.wishBtn');
                                wishBtn.addEventListener('click', function() { window.toggleWish(this, branch.brnIdx); });

                                activeInfoOverlay = new window.kakao.maps.CustomOverlay({
                                    position: markerPos,
                                    content: contentWrap,
                                    yAnchor: 1,
                                    zIndex: 100,
                                    clickable: true
                                });
                                activeInfoOverlay.setMap(map);
                                map.panTo(markerPos);
                            };

                            window.kakao.maps.event.addListener(marker, 'click', openInfoOverlay);
                            labelWrap.addEventListener('click', openInfoOverlay);
                        }
                    });

                    if (keyword && type === "all" && markers.length > 0) {
                        map.panTo(markers[0].getPosition());
                    }

                    if (type === "favorite" && markers.length > 0) {
                        map.panTo(markers[0].getPosition());
                    }
                }).catch(err => { console.error("지점 데이터 로드 중 오류 발생:", err); });
        };

        window.bindSearchEvents = function() {
            const sBtn = document.getElementById('mapSearchBtn') || document.querySelector('.btn-search-round');
            const sInput = document.getElementById('mapSearchInput') || document.getElementById('keywordSearchInput');
            if (sBtn && sInput) {
                sBtn.onclick = (e) => {
                    if (sInput.id === 'keywordSearchInput' && !location.pathname.includes('/map')) return;
                    e.preventDefault();
                    window.loadBranches(sInput.value, "all");
                };
            }
        };

        bindSearchEvents();
    }
});

// 5. 찜하기 전역 함수 수정
window.toggleWish = function (target, brnIdx) {
    let btn = target.classList && target.classList.contains('wish-btn') ? target : target.closest('.wish-btn');
    if (!btn) return;

    const icon = btn.querySelector('i');
    const cp = window.contextPath || "";

    fetch(`${cp}/api/wishlist/toggle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ "brnIdx": parseInt(brnIdx, 10) })
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                if (data.isAdded) {
                    btn.style.color = '#ff4757';
                    if (icon) icon.className = 'fa-solid fa-heart';
                } else {
                    btn.style.color = '#bbb';
                    if (icon) icon.className = 'fa-regular fa-heart';
                }
            } else if (data.status === 'login_required') {
                if (!window.isLoginAlertShown) {
                    alert("로그인이 필요한 서비스입니다.");
                    window.isLoginAlertShown = true;
                    setTimeout(() => { window.isLoginAlertShown = false; }, 1500);
                }
                location.href = `${cp}/login`;
            }
        })
        .catch(err => console.error("찜하기 통신 실패:", err));
};
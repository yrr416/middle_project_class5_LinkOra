// 전역 변수 선언
let map = null;
let geocoder = null;
let ps = null;
let markers = [];
let labelOverlays = [];
let activeOverlay = null;

let currentLat = null;
let currentLng = null;
let isWishFilterActive = false;

// [핵심 해결] 새로고침해도 하트가 절대 풀리지 않도록 내 찜 목록을 기억하는 공간
let myWishlist = new Set();

const brandColors = {
    "링크오라": "%23FF9500",
    "알파오피스": "%234682B4",
    "패스트파이브": "%23FF3B30"
};

let searchGroupedData = {};
let searchRegionPage = {};
let searchRegionOpen = {};
const ITEMS_PER_PAGE = 3;

// [핵심 해결] 엉뚱하게 나뉘는 지역명(서울시, 서울광역시 등)을 깔끔하게 하나로 통일!
function normalizeRegionName(address) {
    if (!address) return "기타 지역";
    let region = address.split(' ')[0];
    if (region.includes("서울")) return "서울특별시";
    if (region.includes("경기")) return "경기도";
    if (region.includes("인천")) return "인천광역시";
    if (region.includes("부산")) return "부산광역시";
    if (region.includes("제주")) return "제주특별자치도";
    return region;
}

// 초기화: 내 찜 목록을 먼저 기억하고, 그 다음 지도를 그립니다.
function initKakaoMapApp() {
    if (typeof kakao === 'undefined' || !kakao.maps) {
        console.error("카카오 지도 SDK가 로드되지 않았습니다.");
        return;
    }

    const container = document.getElementById('mainMap');
    if (!container) return;

    geocoder = new kakao.maps.services.Geocoder();
    ps = new kakao.maps.services.Places();

    // [수정] URL 파라미터 체크 로직: 메인페이지에서 'mode=wish'로 넘어왔는지 확인
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('mode') === 'wish') {
        isWishFilterActive = true;
    }

    // 1. 서버에서 내 찜 목록을 가져와서 기억장에 쏙쏙 넣음
    fetch('/linkora/api/wishlist/my')
        .then(res => res.json())
        .then(data => {
            if (Array.isArray(data)) {
                data.forEach(b => myWishlist.add(b.brnIdx));
            }
            startMapCreation(container);
        })
        .catch(err => {
            console.warn("찜 목록 동기화 실패. 지도를 먼저 엽니다.");
            startMapCreation(container);
        });

    const searchBtn = document.getElementById('mapSearchBtn');
    const searchInput = document.getElementById('mapSearchInput');

    if (searchBtn) {
        searchBtn.addEventListener('click', (e) => {
            e.preventDefault();
            executeSearch();
        });
    }

    if (searchInput) {
        searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                executeSearch();
            }
        });
    }
}

function startMapCreation(container) {
    // 찜 모드(?mode=wish)일 때는 내 위치를 찾는 GPS 로직을 건너뜁니다.
    if (isWishFilterActive) {
        createMapAndLoadData(container, 37.3947, 127.1111);
        return;
    }

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
            currentLat = position.coords.latitude;
            currentLng = position.coords.longitude;
            createMapAndLoadData(container, currentLat, currentLng);
        }, (error) => {
            createMapAndLoadData(container, 37.3947, 127.1111);
        }, { timeout: 5000 });
    } else {
        createMapAndLoadData(container, 37.3947, 127.1111);
    }
}

function createMapAndLoadData(container, lat, lng) {
    if (map) return;

    map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(lat, lng),
        level: 4
    });

    // [강력 추가] 연동 로직: 하트 버튼이 로딩될 때까지 감시했다가 준비되면 즉시 활성화
    const syncWishTab = setInterval(() => {
        const wishFilterBtn = document.getElementById('wishFilterBtn');
        if (wishFilterBtn) {
            if (isWishFilterActive) {
                wishFilterBtn.classList.add('active'); // 탭 색상 변경
                loadMapData(); // 데이터 로드 및 범위 조절
            }
            clearInterval(syncWishTab); // 연동 완료 후 감시 종료
        }
    }, 100);

    // 3초 후에는 무한 루프 방지를 위해 감시 강제 종료
    setTimeout(() => clearInterval(syncWishTab), 3000);

    kakao.maps.event.addListener(map, 'click', () => {
        if (activeOverlay) activeOverlay.setMap(null);
    });

    if (!isWishFilterActive) loadMapData();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initKakaoMapApp);
} else {
    initKakaoMapApp();
}

// 검색 로직 완벽 분리: 지역/이름 검색 vs 주소/지하철역 검색
function executeSearch() {
    if (!map) return;

    const keyword = document.getElementById('mapSearchInput').value.trim();
    if (!keyword) {
        loadMapData();
        return;
    }

    // 1. 오피스 이름이나 지역이 DB에 있는지 먼저 확인
    fetch(`/linkora/api/branches?keyword=${encodeURIComponent(keyword)}`)
        .then(res => res.json())
        .then(data => {
            let branches = Array.isArray(data) ? data : [];

            // [백엔드 버그 방어막] 이름이나 주소에 검색어가 진짜 들어간 것만 남김 (엉뚱한 결과 차단)
            let matchedBranches = branches.filter(b =>
                (b.brnName && b.brnName.includes(keyword)) ||
                (b.brnAddress && b.brnAddress.includes(keyword))
            );

            if (matchedBranches.length > 0) {
                // 오피스명 or 지역 검색 성공! -> 패널을 띄우는 함수로 연결
                handleKeywordMatch(keyword, matchedBranches);
            } else {
                // 2. DB에 없으면 지하철역이나 주소 검색으로 간주하고 카카오 API 출동!
                ps.keywordSearch(keyword, (data, status) => {
                    if (status === kakao.maps.services.Status.OK && map) {
                        handleLocationSearch(data[0].y, data[0].x);
                    } else {
                        geocoder.addressSearch(keyword, (result, status) => {
                            if (status === kakao.maps.services.Status.OK && map) {
                                handleLocationSearch(result[0].y, result[0].x);
                            } else {
                                // 찜 모드일 때 아무것도 못 찾으면
                                if (isWishFilterActive) {
                                    alert("해당 검색어에 저장된 오피스가 없습니다. 전체 지도로 전환합니다.");
                                    isWishFilterActive = false;
                                    const wishBtn = document.querySelector('#wishFilterBtn');
                                    if (wishBtn) wishBtn.classList.remove('active');
                                    loadMapData();
                                } else {
                                    alert("검색 결과가 없습니다.");
                                }
                            }
                        });
                    }
                });
            }
        })
        .catch(err => console.error("검색 오류"));
}

// 지역 또는 오피스명 검색 시 결과 처리 (패널 O)
function handleKeywordMatch(keyword, branches) {
    if (isWishFilterActive) {
        // 관심 지도 모드면 찜한 오피스만 걸러냄
        let wishedOnly = branches.filter(b => myWishlist.has(b.brnIdx) || b.isWish);

        if (wishedOnly.length === 0) {
            alert("해당 검색어에 저장된 오피스가 없습니다. 전체 지도로 전환합니다.");
            isWishFilterActive = false;
            const wishBtn = document.querySelector('#wishFilterBtn');
            if (wishBtn) wishBtn.classList.remove('active');

            // 찜 모드 풀고 전체 검색 결과로 보여줌
            showPanelAndMarkers(keyword, branches);
        } else {
            showPanelAndMarkers(keyword, wishedOnly);
        }
    } else {
        showPanelAndMarkers(keyword, branches);
    }
}

// 결과 패널을 띄우고 지도 범위를 맞추는 함수
function showPanelAndMarkers(keyword, branches) {
    closeResultPanel();
    removeMarkers();
    displayMarkers(branches);
    initResultList(branches, keyword);

    const bounds = new kakao.maps.LatLngBounds();
    let hasValidBounds = false;
    branches.forEach(b => {
        if (b.brnLatitude && b.brnLongitude) {
            bounds.extend(new kakao.maps.LatLng(b.brnLatitude, b.brnLongitude));
            hasValidBounds = true;
        }
    });
    if (hasValidBounds && map) {
        map.setBounds(bounds);
    }
}

// 지하철, 구청, 상세주소 검색 시 결과 처리 (패널 X, 위치만 이동)
function handleLocationSearch(lat, lng) {
    if (isWishFilterActive) {
        alert("해당 위치에는 저장된 오피스가 없어 전체 지도로 전환합니다.");
        isWishFilterActive = false;
        const wishBtn = document.querySelector('#wishFilterBtn');
        if (wishBtn) wishBtn.classList.remove('active');
    }

    closeResultPanel(); // 목록 패널은 무조건 닫음
    map.setCenter(new kakao.maps.LatLng(lat, lng));
    map.setLevel(4); // 위치를 딱 보기 좋은 줌 레벨로 이동

    // 이동한 상태에서 주변 핀들이 보이도록 기본 데이터만 로드 (지도 범위는 고정)
    loadMapData();
}

// 핀과 기본 데이터를 불러오는 공통 함수
function loadMapData() {
    let fetchUrl = isWishFilterActive ? `/linkora/api/wishlist/my` : `/linkora/api/all-branches`;
    closeResultPanel();

    fetch(fetchUrl)
        .then(res => res.json())
        .then(data => {
            if (data.status === 'login_required') {
                alert("로그인이 필요한 서비스입니다.");
                isWishFilterActive = false;
                const wishBtn = document.querySelector('#wishFilterBtn');
                if (wishBtn) wishBtn.classList.remove('active');
                loadMapData();
                return;
            }

            let branches = Array.isArray(data) ? data : [];

            if (branches.length === 0 && isWishFilterActive) {
                alert("아직 찜한 오피스가 없습니다.");
                isWishFilterActive = false;
                const wishBtn = document.querySelector('#wishFilterBtn');
                if (wishBtn) wishBtn.classList.remove('active');
                loadMapData();
                return;
            }

            removeMarkers();
            displayMarkers(branches);

            // [핵심] 관심 지도 모드일 때만 지도가 찜한 지점들을 다 보이게 알아서 줄어들거나 늘어남
            if (isWishFilterActive && branches.length > 0) {
                const bounds = new kakao.maps.LatLngBounds();
                let hasValidBounds = false;
                branches.forEach(b => {
                    if (b.brnLatitude && b.brnLongitude) {
                        bounds.extend(new kakao.maps.LatLng(b.brnLatitude, b.brnLongitude));
                        hasValidBounds = true;
                    }
                });
                if (hasValidBounds && map) {
                    map.setBounds(bounds); // 찜한 오피스들 위주로 화면 범위를 재설정함
                }
            }
        })
        .catch(err => console.error("데이터 로드 중 에러 발생", err));
}

function getBrandColor(brnName) {
    if (!brnName) return "%232F4F4F";
    const brand = brnName.split(' ')[0].trim();
    return brandColors[brand] || "%232F4F4F";
}

function displayMarkers(branches) {
    if (!map) return;

    branches.forEach(branch => {
        if (!branch.brnLatitude || !branch.brnLongitude) return;

        // [핵심] 서버 데이터와 상관없이 내 번호장(myWishlist)을 믿고 하트에 불을 켬
        const isWished = myWishlist.has(branch.brnIdx) || branch.isWish === true;

        const pos = new kakao.maps.LatLng(branch.brnLatitude, branch.brnLongitude);
        const brandColor = getBrandColor(branch.brnName);
        const pinImg = `data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 384 512'%3E%3Cpath fill='${brandColor}' d='M215.7 499.2C267 435 384 279.4 384 192C384 86 298 0 192 0S0 86 0 192c0 87.4 117 243 168.3 307.2c12.3 15.3 35.1 15.3 47.4 0zM192 128a64 64 0 1 1 0 128 64 64 0 1 1 0-128z'/%3E%3C/svg%3E`;
        const markerImage = new kakao.maps.MarkerImage(pinImg, new kakao.maps.Size(26, 34));

        const marker = new kakao.maps.Marker({ position: pos, image: markerImage, map: map });
        markers.push(marker);

        const labelWrap = document.createElement('div');
        labelWrap.style.cssText = `display:flex; align-items:center; background:white; color:#2F4F4F; padding:6px 16px; border-radius:10px; border:2px solid #cccccc; box-shadow:0 4px 15px rgba(0,0,0,0.2); font-family:'Pretendard',sans-serif; font-size:14px; font-weight:800; white-space:nowrap; position:relative; cursor:pointer;`;
        labelWrap.innerHTML = `
            <div style="width:4px; height:14px; background:${brandColor.replace('%23', '#')}; margin-right:10px; border-radius:2px;"></div>
            ${branch.brnName}
            <div style="position:absolute; bottom:-11px; left:50%; transform:translateX(-50%); width:0; height:0; border-left:8px solid transparent; border-right:8px solid transparent; border-top:10px solid #cccccc;"></div>
        `;

        const labelOverlay = new kakao.maps.CustomOverlay({
            position: pos,
            content: labelWrap,
            yAnchor: 2.3,
            zIndex: 99
        });
        labelOverlay.setMap(map);
        labelOverlays.push(labelOverlay);

        const openInfoOverlay = () => {
            if (activeOverlay) activeOverlay.setMap(null);

            const content = document.createElement('div');
            // isWished 값에 따라 하트 색상(빨간색/회색) 지정
            content.innerHTML = `
                <div class="info-window" style="background:white; border-radius:15px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,0.2); width:240px; position:relative; margin-bottom:100px;">
                    <button class="close-btn" style="position:absolute; top:15px; right:15px; background:transparent; border:none; font-size:18px; color:#999; cursor:pointer;">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                    <div style="font-weight:900; font-size:18px; color:#2F4F4F; margin-bottom:8px; padding-right:20px;">${branch.brnName}</div>
                    <div style="font-size:13px; color:#666; line-height:1.5; white-space:normal; word-break:keep-all; margin-bottom:15px;">${branch.brnAddress}</div>
                    <div style="display:flex; gap:10px;">
                        <button onclick="location.href='/linkora/branch/detail?brnIdx=${branch.brnIdx}'"
                            style="flex:1; background:#2F4F4F; color:white; border:none; padding:10px; border-radius:8px; font-weight:700; cursor:pointer;">
                            상세보기
                        </button>
                        <button class="wish-btn ${isWished ? 'active' : ''}"
                            data-branch-idx="${branch.brnIdx}"
                            style="width:45px; height:45px; border:1px solid ${isWished ? '#ff4757' : '#eee'};
                            background:white; border-radius:8px; cursor:pointer;
                            color:${isWished ? '#ff4757' : '#ccc'};">
                            <i class="${isWished ? 'fa-solid' : 'fa-regular'} fa-heart"
                               style="pointer-events: none;"></i>
                        </button>
                    </div>
                </div>`;

            content.querySelector('.close-btn').onclick = (e) => {
                e.stopPropagation();
                if (activeOverlay) activeOverlay.setMap(null);
            };

            const wishBtn = content.querySelector('.wish-btn');
            wishBtn.onclick = (e) => {
                e.stopPropagation();
                if (typeof window.toggleWish === 'function') {
                    window.toggleWish(wishBtn, branch.brnIdx);
                }
            };

            activeOverlay = new kakao.maps.CustomOverlay({
                content: content,
                position: pos,
                yAnchor: 1,
                clickable: true,
                zIndex: 100
            });
            activeOverlay.setMap(map);
            if (map) map.panTo(pos);
        };

        kakao.maps.event.addListener(marker, 'click', openInfoOverlay);
        labelWrap.onclick = openInfoOverlay;
    });
}

function removeMarkers() {
    markers.forEach(m => m.setMap(null));
    labelOverlays.forEach(o => o.setMap(null));
    if (activeOverlay) activeOverlay.setMap(null);
    markers = [];
    labelOverlays = [];
}

window.closeResultPanel = function() {
    const panel = document.getElementById('searchResultPanel');
    if (panel) panel.style.display = 'none';
};

function initResultList(branches, keyword) {
    let panel = document.getElementById('searchResultPanel');
    if (!panel) {
        panel = document.createElement('div');
        panel.id = 'searchResultPanel';
        panel.style.cssText = 'position:absolute; top:70px; left:50%; transform:translateX(-50%); width:340px; max-height:70vh; overflow-y:auto; background:white; border-radius:15px; box-shadow:0 10px 30px rgba(0,0,0,0.2); z-index:10; display:none; flex-direction:column; padding:20px;';
        document.querySelector('.map-container').appendChild(panel);
    }

    searchGroupedData = {};
    searchRegionPage = {};
    searchRegionOpen = {};

    branches.forEach(b => {
        const region = normalizeRegionName(b.brnAddress);

        if (!searchGroupedData[region]) {
            searchGroupedData[region] = [];
            searchRegionPage[region] = 0;
            searchRegionOpen[region] = true;
        }
        searchGroupedData[region].push(b);
    });

    renderResultPanel(keyword, branches.length);
    panel.style.display = 'flex';
}

function renderResultPanel(keyword, totalCount) {
    const panel = document.getElementById('searchResultPanel');
    if (!panel) return;

    let html = `<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; position:sticky; top:-20px; background:white; padding-top:20px; z-index:2;">
                    <strong style="color:#2F4F4F; font-size:16px;">'${keyword}' 검색 결과 (${totalCount}개)</strong>
                    <button onclick="closeResultPanel()" style="background:none; border:none; font-size:22px; cursor:pointer; color:#999;"><i class="fa-solid fa-xmark"></i></button>
                </div>`;

    for (const region in searchGroupedData) {
        const branches = searchGroupedData[region];
        const isOpen = searchRegionOpen[region];
        const currentPage = searchRegionPage[region];
        const totalPages = Math.ceil(branches.length / ITEMS_PER_PAGE);

        html += `<div style="margin-bottom:15px; border:1px solid #eee; border-radius:10px; overflow:hidden;">
                    <div style="display:flex; justify-content:space-between; align-items:center; background:#f8f9fa; padding:12px 15px; cursor:pointer;"
                         onclick="toggleRegion('${region}', '${keyword}', ${totalCount})">
                        <div style="font-size:14px; font-weight:900; color:#007A8A;">${region} <span style="color:#999; font-size:12px; font-weight:normal;">(${branches.length})</span></div>
                        <i class="fa-solid ${isOpen ? 'fa-chevron-up' : 'fa-chevron-down'}" style="color:#666;"></i>
                    </div>`;

        if (isOpen) {
            html += `<div style="padding:10px;">`;

            const startIndex = currentPage * ITEMS_PER_PAGE;
            const endIndex = startIndex + ITEMS_PER_PAGE;
            const currentBranches = branches.slice(startIndex, endIndex);

            currentBranches.forEach(b => {
                const brandColor = getBrandColor(b.brnName).replace('%23', '#');
                html += `<div class="result-item" style="padding:12px; border-radius:10px; cursor:pointer; border:1px solid #eee; margin-bottom:8px; display:flex; align-items:center; gap:12px;"
                              onmouseover="this.style.background='#f8f9fa'; this.style.borderColor='#ddd'" 
                              onmouseout="this.style.background='white'; this.style.borderColor='#eee'"
                              onclick="moveToBranch(${b.brnLatitude}, ${b.brnLongitude})">
                            <div style="width:14px; height:14px; border-radius:50%; background:${brandColor}; flex-shrink:0;"></div>
                            <div>
                                <div style="font-size:15px; font-weight:800; color:#333; margin-bottom:4px;">${b.brnName}</div>
                                <div style="font-size:12px; color:#777;">${b.brnAddress}</div>
                            </div>
                         </div>`;
            });

            if (totalPages > 1) {
                html += `<div style="display:flex; justify-content:center; align-items:center; gap:20px; margin-top:12px; padding-bottom:5px;">
                            <button onclick="changePage('${region}', -1, '${keyword}', ${totalCount})" 
                                    style="background:none; border:none; font-size:16px; cursor:${currentPage > 0 ? 'pointer' : 'not-allowed'}; color:${currentPage > 0 ? '#2F4F4F' : '#ddd'};"
                                    ${currentPage === 0 ? 'disabled' : ''}>
                                <i class="fa-solid fa-circle-chevron-left"></i>
                            </button>
                            <span style="font-size:13px; font-weight:bold; color:#666;">${currentPage + 1} / ${totalPages}</span>
                            <button onclick="changePage('${region}', 1, '${keyword}', ${totalCount})" 
                                    style="background:none; border:none; font-size:16px; cursor:${currentPage < totalPages - 1 ? 'pointer' : 'not-allowed'}; color:${currentPage < totalPages - 1 ? '#2F4F4F' : '#ddd'};"
                                    ${currentPage === totalPages - 1 ? 'disabled' : ''}>
                                <i class="fa-solid fa-circle-chevron-right"></i>
                            </button>
                         </div>`;
            }

            html += `</div>`;
        }
        html += `</div>`;
    }

    panel.innerHTML = html;
}

window.toggleRegion = function(region, keyword, totalCount) {
    searchRegionOpen[region] = !searchRegionOpen[region];
    renderResultPanel(keyword, totalCount);
};

window.changePage = function(region, step, keyword, totalCount) {
    const branches = searchGroupedData[region];
    const totalPages = Math.ceil(branches.length / ITEMS_PER_PAGE);
    let newPage = searchRegionPage[region] + step;

    if (newPage >= 0 && newPage < totalPages) {
        searchRegionPage[region] = newPage;
        renderResultPanel(keyword, totalCount);
    }
};

window.moveToBranch = function(lat, lng) {
    if (map) {
        const pos = new kakao.maps.LatLng(lat, lng);
        map.setCenter(pos);
        map.setLevel(3);
    }
};

// 메인 하트 버튼 누를 때
window.toggleWishFilter = function(isActive) {
    if (!map) return;

    isWishFilterActive = isActive;
    const searchInput = document.getElementById('mapSearchInput');
    if (searchInput) {
        searchInput.value = "";
    }
    loadMapData();
};

// 하트(찜) 클릭 시 DB 연동 및 번호장(myWishlist) 업데이트
window.toggleWish = function (target, brnIdx) {
    const icon = target.querySelector('i');
    const bIdx = parseInt(brnIdx, 10);

    fetch('/linkora/api/wishlist/toggle', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ "brnIdx": bIdx })
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                if (data.isAdded) {
                    myWishlist.add(bIdx); // 내 번호장에도 추가!
                    target.style.borderColor = '#ff4757';
                    target.style.color = '#ff4757';
                    if (icon) icon.className = 'fa-solid fa-heart';
                    target.classList.add('active');
                } else {
                    myWishlist.delete(bIdx); // 찜 해제 시 번호장에서도 삭제!
                    target.style.borderColor = '#eee';
                    target.style.color = '#ccc';
                    if (icon) icon.className = 'fa-regular fa-heart';
                    target.classList.remove('active');

                    // 찜 모드에서 취소했다면 바로 화면 갱신
                    if (isWishFilterActive) {
                        loadMapData();
                    }
                }
            } else if (data.status === 'login_required') {
                alert("로그인이 필요한 서비스입니다.");
                location.href = "/linkora/login";
            }
        })
        .catch(err => console.error("찜하기 통신 실패:", err));
};
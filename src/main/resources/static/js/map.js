// 전역 변수 선언
let map, geocoder, ps, markers = [], labelOverlays = [], activeOverlay = null;
let currentLat = null;
let currentLng = null;

// 브랜드별 색상 사전
const brandColors = {
    "링크오라": "%23FF9500",    // 오렌지색
    "알파오피스": "%234682B4",  // 차분한 파란색
    "패스트파이브": "%23FF3B30"
};

// [추가됨] 검색 목록창의 상태를 기억하는 수첩 (페이지, 접기/펴기)
let searchGroupedData = {}; // 지역별 데이터를 담아둘 바구니
let searchRegionPage = {};  // 지역별 현재 페이지 번호
let searchRegionOpen = {};  // 지역별 폴더가 열렸는지 닫혔는지
const ITEMS_PER_PAGE = 3;   // 한 페이지에 보여줄 지점 개수 (마음대로 바꿔도 돼!)

document.addEventListener("DOMContentLoaded", () => {
    const container = document.getElementById('mainMap');
    if (!container) return;

    // 위치 정보 가져오기 및 지도 초기화
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
            currentLat = position.coords.latitude;
            currentLng = position.coords.longitude;
            const locPosition = new kakao.maps.LatLng(currentLat, currentLng);

            map = new kakao.maps.Map(container, {
                center: locPosition,
                level: 4
            });
            geocoder = new kakao.maps.services.Geocoder();
            ps = new kakao.maps.services.Places();

            kakao.maps.event.addListener(map, 'click', () => {
                if (activeOverlay) activeOverlay.setMap(null);
            });

            fetchBranchData("");
        }, (error) => {
            console.error("GPS 정보를 불러올 수 없음");
            createDefaultMap(container);
        });
    } else {
        createDefaultMap(container);
    }

    // 검색 이벤트 설정
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
});

// 기본 지도 생성
function createDefaultMap(container) {
    currentLat = 37.3947;
    currentLng = 127.1111;
    map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(currentLat, currentLng),
        level: 4
    });
    geocoder = new kakao.maps.services.Geocoder();
    ps = new kakao.maps.services.Places();

    kakao.maps.event.addListener(map, 'click', () => {
        if (activeOverlay) activeOverlay.setMap(null);
    });

    fetchBranchData("");
}

// 검색 실행 로직
function executeSearch() {
    const keyword = document.getElementById('mapSearchInput').value.trim();
    if (!keyword) {
        fetchBranchData("");
        return;
    }

    // 우리 DB 먼저 검색
    fetch(`/api/branches?keyword=${encodeURIComponent(keyword)}`)
        .then(res => res.json())
        .then(branches => {
            if (branches && branches.length > 0) {
                fetchBranchData(keyword);
            } else {
                // DB에 없으면 카카오 지도 검색
                ps.keywordSearch(keyword, (data, status) => {
                    if (status === kakao.maps.services.Status.OK) {
                        map.panTo(new kakao.maps.LatLng(data[0].y, data[0].x));
                        fetchBranchData(keyword, data[0].y, data[0].x);
                    } else {
                        geocoder.addressSearch(keyword, (result, status) => {
                            if (status === kakao.maps.services.Status.OK) {
                                map.panTo(new kakao.maps.LatLng(result[0].y, result[0].x));
                                fetchBranchData(keyword, result[0].y, result[0].x);
                            } else {
                                alert("검색 결과가 없습니다.");
                            }
                        });
                    }
                });
            }
        })
        .catch(err => console.error("검색 오류"));
}

// 지점 데이터 요청 및 렌더링
function fetchBranchData(keyword, lat = null, lng = null) {
    let fetchUrl = "";
    if (!keyword || keyword === "") {
        fetchUrl = `/api/all-branches`;
        closeResultPanel();
    } else {
        fetchUrl = `/api/branches?keyword=${encodeURIComponent(keyword)}`;
        if (lat !== null && lng !== null) {
            fetchUrl += `&lat=${lat}&lng=${lng}`;
        }
    }

    fetch(fetchUrl)
        .then(res => res.json())
        .then(branches => {
            if (!branches || branches.length === 0) {
                if (keyword !== "") alert("검색 결과가 없습니다. 😥");
                removeMarkers();
                closeResultPanel();
                return;
            }
            removeMarkers();
            displayMarkers(branches);

            // 검색어가 있을 때 목록창 처리
            if (keyword && keyword !== "") {
                initResultList(branches, keyword); // 데이터를 세팅함

                if (lat === null && lng === null) {
                    const bounds = new kakao.maps.LatLngBounds();
                    branches.forEach(b => {
                        if (b.brnLatitude && b.brnLongitude) {
                            bounds.extend(new kakao.maps.LatLng(b.brnLatitude, b.brnLongitude));
                        }
                    });
                    map.setBounds(bounds);
                }
            }
        })
        .catch(err => console.error("데이터 로드 중 에러 발생"));
}

// 브랜드 색상 가져오기
function getBrandColor(brnName) {
    if (!brnName) return "%232F4F4F";
    const brand = brnName.split(' ')[0].trim();
    return brandColors[brand] || "%232F4F4F";
}

// 마커 및 정보창 렌더링
function displayMarkers(branches) {
    branches.forEach(branch => {
        if (!branch.brnLatitude || !branch.brnLongitude) return;

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
            content.innerHTML = `
                <div class="info-window" style="background:white; border-radius:15px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,0.2); width:240px; position:relative; margin-bottom:100px;">
                    <button class="close-btn" style="position:absolute; top:15px; right:15px; background:transparent; border:none; font-size:18px; color:#999; cursor:pointer;">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                    <div style="font-weight:900; font-size:18px; color:#2F4F4F; margin-bottom:8px; padding-right:20px;">${branch.brnName}</div>
                    <div style="font-size:13px; color:#666; line-height:1.5; white-space:normal; word-break:keep-all; margin-bottom:15px;">${branch.brnAddress}</div>
                    <div style="display:flex; gap:10px;">
                        <button onclick="location.href='/branch/detail?brnIdx=${branch.brnIdx}'"
                            style="flex:1; background:#2F4F4F; color:white; border:none; padding:10px; border-radius:8px; font-weight:700; cursor:pointer;">
                            상세보기
                        </button>
                        <button class="wish-btn ${branch.isWish ? 'active' : ''}"
                            data-branch-idx="${branch.brnIdx}"
                            style="width:45px; height:45px; border:1px solid ${branch.isWish ? '#ff4757' : '#eee'};
                            background:white; border-radius:8px; cursor:pointer;
                            color:${branch.isWish ? '#ff4757' : '#ccc'};">
                            <i class="${branch.isWish ? 'fa-solid' : 'fa-regular'} fa-heart"
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
            map.panTo(pos);
        };

        kakao.maps.event.addListener(marker, 'click', openInfoOverlay);
        labelWrap.onclick = openInfoOverlay;
    });
}

// 마커 지우기
function removeMarkers() {
    markers.forEach(m => m.setMap(null));
    labelOverlays.forEach(o => o.setMap(null));
    if (activeOverlay) activeOverlay.setMap(null);
    markers = [];
    labelOverlays = [];
}

// ===============================================
// [완전 업그레이드] 지역별 접기/펴기 & 페이징(넘기기) 기능
// ===============================================

// 목록창 닫기
window.closeResultPanel = function() {
    const panel = document.getElementById('searchResultPanel');
    if (panel) panel.style.display = 'none';
};

// 1. 처음 데이터를 받았을 때 지역별로 분류하고 수첩(상태)을 초기화함
function initResultList(branches, keyword) {
    let panel = document.getElementById('searchResultPanel');
    if (!panel) {
        panel = document.createElement('div');
        panel.id = 'searchResultPanel';
        panel.style.cssText = 'position:absolute; top:70px; left:50%; transform:translateX(-50%); width:340px; max-height:70vh; overflow-y:auto; background:white; border-radius:15px; box-shadow:0 10px 30px rgba(0,0,0,0.2); z-index:10; display:none; flex-direction:column; padding:20px;';
        document.querySelector('.map-container').appendChild(panel);
    }

    // 수첩 비우기
    searchGroupedData = {};
    searchRegionPage = {};
    searchRegionOpen = {};

    // 지역별로 묶어주기
    branches.forEach(b => {
        const region = b.brnAddress.split(' ')[0] || "기타 지역";
        if (!searchGroupedData[region]) {
            searchGroupedData[region] = [];
            searchRegionPage[region] = 0;    // 처음엔 무조건 1페이지(0)
            searchRegionOpen[region] = true; // 처음엔 무조건 폴더 열어두기
        }
        searchGroupedData[region].push(b);
    });

    // 화면 그리기 함수 호출
    renderResultPanel(keyword, branches.length);
    panel.style.display = 'flex';
}

// 2. 수첩(상태)을 보고 화면을 예쁘게 그리는 함수
function renderResultPanel(keyword, totalCount) {
    const panel = document.getElementById('searchResultPanel');
    if (!panel) return;

    let html = `<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; position:sticky; top:-20px; background:white; padding-top:20px; z-index:2;">
                    <strong style="color:#2F4F4F; font-size:16px;">'${keyword}' 검색 결과 (${totalCount}개)</strong>
                    <button onclick="closeResultPanel()" style="background:none; border:none; font-size:22px; cursor:pointer; color:#999;"><i class="fa-solid fa-xmark"></i></button>
                </div>`;

    // 각 지역별로 반복해서 그림
    for (const region in searchGroupedData) {
        const branches = searchGroupedData[region];
        const isOpen = searchRegionOpen[region];
        const currentPage = searchRegionPage[region];
        const totalPages = Math.ceil(branches.length / ITEMS_PER_PAGE);

        // 지역 이름 바(Bar) - 클릭하면 접고 펴짐
        html += `<div style="margin-bottom:15px; border:1px solid #eee; border-radius:10px; overflow:hidden;">
                    <div style="display:flex; justify-content:space-between; align-items:center; background:#f8f9fa; padding:12px 15px; cursor:pointer;"
                         onclick="toggleRegion('${region}', '${keyword}', ${totalCount})">
                        <div style="font-size:14px; font-weight:900; color:#007A8A;">${region} <span style="color:#999; font-size:12px; font-weight:normal;">(${branches.length})</span></div>
                        <i class="fa-solid ${isOpen ? 'fa-chevron-up' : 'fa-chevron-down'}" style="color:#666;"></i>
                    </div>`;

        // 폴더가 열려있을 때만 목록을 그림
        if (isOpen) {
            html += `<div style="padding:10px;">`;

            // 현재 페이지에 해당하는 3개(ITEMS_PER_PAGE)만 잘라냄
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

            // 3개가 넘어가서 페이지가 여러 개일 때만 화살표 버튼을 보여줌
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

// 지역 폴더 접기/펴기 스위치
window.toggleRegion = function(region, keyword, totalCount) {
    searchRegionOpen[region] = !searchRegionOpen[region]; // 열림 <-> 닫힘 반전
    renderResultPanel(keyword, totalCount); // 화면 다시 그리기
};

// 방향키 눌렀을 때 페이지 넘기기
window.changePage = function(region, step, keyword, totalCount) {
    const branches = searchGroupedData[region];
    const totalPages = Math.ceil(branches.length / ITEMS_PER_PAGE);
    let newPage = searchRegionPage[region] + step; // 이전(-1) 또는 다음(+1)

    // 페이지가 허용된 범위 안에 있을 때만 이동
    if (newPage >= 0 && newPage < totalPages) {
        searchRegionPage[region] = newPage;
        renderResultPanel(keyword, totalCount); // 화면 다시 그리기
    }
};

// 목록 클릭 시 지점 위치로 이동
window.moveToBranch = function(lat, lng) {
    const pos = new kakao.maps.LatLng(lat, lng);
    map.setCenter(pos);
    map.setLevel(3); // 약간 확대해서 보여줌
};
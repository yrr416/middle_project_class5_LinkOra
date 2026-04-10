// [map.js] 지도의 핵심 로직임.
let map, geocoder, ps, markers = [], nameLabels = [], activeOverlay = null;
let currentLat = null; // 현재 위도 저장
let currentLng = null; // 현재 경도 저장

document.addEventListener("DOMContentLoaded", () => {
    const container = document.getElementById('mainMap'); // 지도 컨테이너 요소
    if (!container) return;

    // GPS 위치 획득 및 지도 초기화
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

            fetchBranchData("", currentLat, currentLng);
        }, (error) => {
            console.error("GPS 정보를 불러올 수 없음");
            createDefaultMap(container);
        });
    } else {
        createDefaultMap(container);
    }

    // 검색 이벤트 바인딩
    const searchBtn = document.getElementById('mapSearchBtn');
    const searchInput = document.getElementById('mapSearchInput');
    if (searchBtn) searchBtn.onclick = executeSearch;
    if (searchInput) {
        searchInput.onkeypress = (e) => { if (e.key === 'Enter') executeSearch(); };
    }
});

// GPS 실패 시 판교를 기준으로 기본 지도 생성
function createDefaultMap(container) {
    currentLat = 37.3947;
    currentLng = 127.1111;
    map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(currentLat, currentLng),
        level: 4
    });
    geocoder = new kakao.maps.services.Geocoder();
    ps = new kakao.maps.services.Places();
    fetchBranchData("", currentLat, currentLng);
}

// 키워드 및 주소 검색 실행
function executeSearch() {
    const keyword = document.getElementById('mapSearchInput').value.trim();
    if (!keyword) return;

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
                    alert("검색 결과가 존재하지 않습니다."); // 에러 방지용 알림
                }
            });
        }
    });
}

// API로 지점 데이터 요청 및 마커 렌더링
function fetchBranchData(keyword, lat = null, lng = null) {
    let fetchUrl = `/linkora/api/branches?keyword=${encodeURIComponent(keyword)}`;
    if (lat !== null && lng !== null) {
        fetchUrl += `&lat=${lat}&lng=${lng}`;
    }

    fetch(fetchUrl)
        .then(res => res.json())
        .then(branches => {
            // 빈 데이터에 대한 방어 로직 추가
            if (!branches || branches.length === 0) {
                if (keyword !== "") alert("해당 지역에는 등록된 오피스가 없습니다. 😥");
                else console.warn("표시할 주변 지점이 없습니다.");
                removeMarkers();
                return;
            }
            removeMarkers();
            displayMarkers(branches);
        })
        .catch(err => console.error("API 로드 실패:", err));
}

// 지도상에 마커 및 오버레이 표시
function displayMarkers(branches) {
    branches.forEach(branch => {
        // brnLongitude 속성이 자바 VO에서 제대로 넘어와야 위치가 찍힘
        if (!branch.brnLatitude || !branch.brnLongitude) return;

        const pos = new kakao.maps.LatLng(branch.brnLatitude, branch.brnLongitude);
        const marker = new kakao.maps.Marker({ position: pos, map: map });
        markers.push(marker);

        kakao.maps.event.addListener(marker, 'click', () => {
            if (activeOverlay) activeOverlay.setMap(null);
            const content = document.createElement('div');

            content.innerHTML = `
                <div class="info-window" style="background:white; border-radius:15px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,0.2); width:240px;">
                    <div style="font-weight:900; font-size:18px; color:#2F4F4F; margin-bottom:8px;">${branch.brnName}</div>
                    <div style="font-size:13px; color:#666; line-height:1.5; white-space:normal; word-break:keep-all; margin-bottom:15px;">${branch.brnAddress}</div>
                    <div style="display:flex; gap:10px;">
                        <button onclick="location.href='/linkora/branch/detail?brnIdx=${branch.brnIdx}'"
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

            const wishBtn = content.querySelector('.wish-btn');
            wishBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                const btn = e.target.closest('.wish-btn');
                if (!btn) return;

                // mp_script.js에 정의된 전역 함수 사용
                if (typeof window.toggleWish === 'function') {
                    window.toggleWish(btn, branch.brnIdx);
                }
            });

            activeOverlay = new kakao.maps.CustomOverlay({
                content: content,
                position: pos,
                yAnchor: 1.4
            });
            activeOverlay.setMap(map);
            map.panTo(pos);
        });
    });
}

// 기존 마커 초기화
function removeMarkers() {
    markers.forEach(m => m.setMap(null));
    if (activeOverlay) activeOverlay.setMap(null);
    markers = [];
}
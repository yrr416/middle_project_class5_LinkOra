<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../layout/header.jsp" %>

<style>
    /* 1번 영역: 헤더 상단 고정 및 색상 설정 */
    .main-header {
        background-color: #2a2a2a !important;
        border-bottom: 1px solid rgba(255,255,255,0.1) !important;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 1000;
    }

    /* 헤더 요소 흰색 반전 */
    .main-header .hamburger-menu,
    .main-header .login-btn,
    .main-header .login-link {
        color: #ffffff !important;
    }

    /* 로고 SVG 텍스트 흰색 설정 */
    .main-header .logo__icon text {
        fill: #ffffff !important;
    }

    /* 예약하기 버튼 디자인 */
    .main-header .btn-book {
        background-color: #ffffff !important;
        color: #2a2a2a !important;
        border: none !important;
    }

    /* 헤더 높이만큼 본문 밀어내기 */
    .list-page-wrapper {
        margin-top: 0 !important;
        padding-top: 80px !important;
        background-color: #fcfcfc; /* 배경을 순백색보다 약간 낮춤 */
    }

    /* 애니메이션 효과 */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up {
        animation: fadeInUp 0.8s ease-out forwards;
    }

    /* WS 박스 스타일 (채도를 낮춰 차분하게 수정) */
    .no-img-box {
        width: 100%;
        height: 180px;
        background: linear-gradient(to bottom right, #f1f3f2, #e2e5e4);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #a3b0ae;
        font-size: 40px;
        font-weight: 800;
        user-select: none;
    }

    /* 카드 디자인: 포인트 컬러를 #2F4F4F로 변경 */
    .branch-card {
        background: #fff;
        border: 1px solid #ececec;
        border-radius: 12px;
        overflow: hidden;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        display: flex;
        flex-direction: column;
    }

    .branch-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 20px rgba(0,0,0,0.1);
    }

    /* 지점 이름 및 텍스트 톤 다운 */
    .branch-info h3 {
        color: #222;
        font-weight: 700;
    }

    .branch-info .location-text {
        color: #666;
        font-size: 13px;
    }

    /* 아이콘 색상 변경 (쨍한 민트 -> 차분한 다크 슬레이트) */
    .facility-icons i {
        color: #2F4F4F !important;
    }

    /* 버튼 색상 변경: 홈페이지 로고톤과 맞춘 #2F4F4F */
    .btn-reservation {
        display: block;
        text-align: center;
        background: #2F4F4F;
        color: white !important;
        padding: 12px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: background 0.3s;
        margin-top: auto;
    }

    .btn-reservation:hover {
        background: #1e3333;
    }

    /* 사이드바 필터 버튼 */
    .btn-filter {
        width: 100%;
        padding: 12px;
        background: #2F4F4F;
        color: white;
        border: none;
        border-radius: 6px;
        font-weight: bold;
        cursor: pointer;
    }

    /* 페이징 버튼 액티브 색상 */
    .page-btn.active {
        background: #2F4F4F !important;
        border-color: #2F4F4F !important;
    }

    /* [추가/수정] 찜 버튼 스타일: 지도 페이지 하트 버튼과 통일감 유지 */
    .search-wish-btn {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 22px;
        transition: transform 0.2s ease, color 0.2s ease;
        padding: 5px;
        line-height: 1;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .search-wish-btn:hover {
        transform: scale(1.15);
    }
    .search-wish-btn i {
        pointer-events: none; /* 아이콘 클릭 시 부모 버튼이 클릭되도록 설정 */
    }
</style>

<main class="list-page-wrapper">

    <section class="list-header" style="
        background: linear-gradient(rgba(42, 42, 42, 0.4), rgba(42, 42, 42, 0.4)),
                    url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=80');
        background-size: cover;
        background-position: center;
        padding: 100px 0;
        text-align: center;">

        <div class="container fade-in-up">
            <nav style="margin-bottom: 15px; font-size: 13px; color: #ddd; letter-spacing: 0.5px;">
                <a href="${pageContext.request.contextPath}/" style="color: #fff; text-decoration: none;">HOME</a>
                <span style="margin: 0 8px;">&gt;</span>
                <span style="color: #fff; font-weight: 600;">FIND SPACES</span>
            </nav>

            <h2 style="font-size: 42px; font-weight: 900; color: #fff; margin-bottom: 15px; letter-spacing: -1.5px;">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        '<span style="color: #f1f1f1;">${keyword}</span>' 검색 결과
                    </c:when>
                    <c:otherwise>전체 공간 둘러보기</c:otherwise>
                </c:choose>
            </h2>

            <div style="width: 50px; height: 3px; background: #fff; margin: 0 auto 25px; border-radius: 2px;"></div>

            <p style="color: #fff; font-size: 18px; font-weight: 300; line-height: 1.6; letter-spacing: -0.5px; opacity: 0.9;">
                Link Ora가 엄선한 최상의 업무 환경을 경험해 보세요.
            </p>
        </div>
    </section>

    <div class="container" style="display: flex; gap: 30px; margin-top: 50px; margin-bottom: 80px;">

        <aside class="filter-sidebar" style="width: 280px; flex-shrink: 0; background: #fff; padding: 25px; border: 1px solid #eee; border-radius: 12px; height: fit-content;">
            <div class="filter-box">
                <h3 style="margin-bottom: 25px; font-size: 18px; border-bottom: 2px solid #2F4F4F; padding-bottom: 12px; color: #222;">상세 필터</h3>
                <form action="${pageContext.request.contextPath}/branch/search" method="get" id="sidebarFilterForm">

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #444;">키워드 검색</label>
                        <input type="text" name="keyword" value="${keyword}" placeholder="오피스 이름, 키워드"
                               style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd; box-sizing: border-box; outline: none;">
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #444;">지역 선택</label>

                        <input type="hidden" name="region" id="actualRegion" value="${region}">

                        <select id="sidebarCity" onchange="updateSidebarDistricts()" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd; margin-bottom: 8px;">
                            <option value="">시/도 선택</option>
                            <c:forEach var="entry" items="${regionMap}">
                                <option value="${entry.key}">${entry.key}</option>
                            </c:forEach>
                        </select>

                        <select id="sidebarDistrict" onchange="updateSidebarRegionInput()" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd;" disabled>

                            <option value="">상세 구 선택</option>
                        </select>
                        <input type="hidden" name="region" id="actualSidebarRegion" value="${region}">
                    </div>

                    <div class="filter-group" style="margin-bottom: 25px;">
                        <label style="display: block; margin-bottom: 12px; font-weight: bold; color: #444;">수용 인원</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 13px; color: #666;">
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="" ${empty capacity ? 'checked' : ''}> 전체</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="1" ${capacity == 1 ? 'checked' : ''}> 1인 전용</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="5" ${capacity == 5 ? 'checked' : ''}> ~5인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="10" ${capacity == 10 ? 'checked' : ''}> ~10인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="20" ${capacity == 20 ? 'checked' : ''}> ~20인</label>
                            <label style="cursor:pointer;"><input type="radio" name="capacity" value="21" ${capacity == 21 ? 'checked' : ''}> 20인+</label>
                        </div>
                    </div>

                    <div class="filter-group" style="margin-bottom: 30px;">
                        <label style="display: block; margin-bottom: 12px; font-weight: bold; color: #444;">편의 시설</label>
                        <div style="display: grid; gap: 12px; font-size: 14px; color: #666;">
                            <label style="cursor:pointer;"><input type="checkbox" name="facParking" value="1" ${facParking == 1 ? 'checked' : ''}> 주차 가능</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facHours24" value="1" ${facHours24 == 1 ? 'checked' : ''}> 24시간 운영</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facPet" value="1" ${facPet == 1 ? 'checked' : ''}> 반려동물 동반</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facWifi" value="1" ${facWifi == 1 ? 'checked' : ''}> 기가 와이파이</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facCoffee" value="1" ${facCoffee == 1 ? 'checked' : ''}> 무료 커피/간식</label>

                            <label style="cursor:pointer;"><input type="checkbox" name="facCafe" value="1" ${facCafe == 1 ? 'checked' : ''}> 카페테리아</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facKitchen" value="1" ${facKitchen == 1 ? 'checked' : ''}> 공용 주방</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facWater" value="1" ${facWater == 1 ? 'checked' : ''}> 정수기</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facPrinter" value="1" ${facPrinter == 1 ? 'checked' : ''}> 프린터/복사기</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facLocker" value="1" ${facLocker == 1 ? 'checked' : ''}> 개인 사물함</label>
                            <label style="cursor:pointer;"><input type="checkbox" name="facLounge" value="1" ${facLounge == 1 ? 'checked' : ''}> 휴식 라운지</label>
                        </div>
                    </div>

                    <button type="submit" class="btn-filter">필터 적용하기</button>
                    <a href="${pageContext.request.contextPath}/branch/search" style="display: block; text-align: center; margin-top: 15px; color: #999; font-size: 13px; text-decoration: none;">필터 초기화</a>
                </form>
            </div>
        </aside>

        <section class="branch-list-content" style="flex-grow: 1;">

            <c:choose>
                <c:when test="${empty branches}">
                    <div style="
                        text-align: center;
                        padding: 100px 20px;
                        background-color: #f5f5f5;
                        border-radius: 12px;
                        min-height: 400px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-direction: column;">

                        <div>
                            <i class="fa-solid fa-magnifying-glass" style="font-size: 40px; color: #999; margin-bottom: 20px;"></i>
                            <h3 style="color: #333; font-size: 26px; font-weight: bold; margin-bottom: 15px;">검색 결과와 일치하는 오피스가 없습니다.</h3>
                            <p style="color: #666; font-size: 16px;">선택하신 조건이나 검색어를 변경하여 다시 검색해 보세요.</p>
                        </div>

                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="branch-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px;">
                        <c:forEach var="branch" items="${branches}">
                            <div class="branch-card" style="box-shadow: 0 4px 10px rgba(0,0,0,0.03);">

                                <div class="branch-img" style="height: 180px; background: #f0f0f0;">
                                    <c:choose>
                                        <c:when test="${not empty branch.mainImgUrl}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(branch.mainImgUrl, '/')}">
                                                    <img src="${pageContext.request.contextPath}${branch.mainImgUrl}"
                                                         alt="${branch.brnName}"
                                                         style="width:100%; height:100%; object-fit:cover;"
                                                         onerror="this.parentElement.innerHTML='<div class=\'no-img-box\'>WS</div>'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/static/upload/branch/${branch.mainImgUrl}"
                                                         alt="${branch.brnName}"
                                                         style="width:100%; height:100%; object-fit:cover;"
                                                         onerror="this.parentElement.innerHTML='<div class=\'no-img-box\'>WS</div>'">
                                                </c:otherwise>

                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-img-box">WS</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="branch-info" style="padding: 20px; flex-grow: 1; display: flex; flex-direction: column;">
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                        <h3 style="margin: 0; font-size: 20px;">${branch.brnName}</h3>
                                        <button class="search-wish-btn"
                                                data-brn-idx="${branch.brnIdx}"
                                                onclick="toggleSearchWish(this, '${branch.brnIdx}')"
                                                style="color: ${branch.isWish ? '#ff4757' : '#ccc'};">
                                            <i class="${branch.isWish ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
                                        </button>
                                    </div>

                                    <p class="location-text" style="margin-bottom: 15px;">
                                        <i class="fa-solid fa-location-dot" style="color: #2F4F4F; margin-right: 5px;"></i> ${branch.brnAddress}
                                    </p>

                                    <div class="facility-icons" style="display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 20px; font-size: 18px;">
                                        <c:if test="${branch.facWifi == 1}"><i class="fa-solid fa-wifi" title="와이파이"></i></c:if>
                                        <c:if test="${branch.facParking == 1}"><i class="fa-solid fa-car" title="주차"></i></c:if>
                                        <c:if test="${branch.facCoffee == 1}"><i class="fa-solid fa-mug-hot" title="무료커피"></i></c:if>
                                        <c:if test="${branch.facHours24 == 1}"><i class="fa-solid fa-clock" title="24시간"></i></c:if>
                                        <c:if test="${branch.facPet == 1}"><i class="fa-solid fa-paw" title="반려동물"></i></c:if>
                                        <c:if test="${branch.facCafe == 1}"><i class="fa-solid fa-utensils" title="카페테리아"></i></c:if>
                                        <c:if test="${branch.facKitchen == 1}"><i class="fa-solid fa-kitchen-set" title="공용주방"></i></c:if>
                                        <c:if test="${branch.facWater == 1}"><i class="fa-solid fa-bottle-water" title="정수기"></i></c:if>
                                        <c:if test="${branch.facPrinter == 1}"><i class="fa-solid fa-print" title="프린터/복사기"></i></c:if>
                                        <c:if test="${branch.facLocker == 1}"><i class="fa-solid fa-vault" title="개인사물함"></i></c:if>
                                        <c:if test="${branch.facLounge == 1}"><i class="fa-solid fa-couch" title="휴식 라운지"></i></c:if>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${branch.brnIdx}" class="btn-reservation"
                                       onmouseover="this.style.background='#1e3333'"
                                       onmouseout="this.style.background='#2F4F4F'">
                                         오피스 보러가기
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${totalPages > 0}">
                        <div class="pagination" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 50px;">
                            <c:if test="${currentPage > 1}">
                                <button type="button" onclick="goPage(${currentPage - 1})" style="padding: 8px 12px; border: 1px solid #ddd; background: #fff; border-radius: 6px; cursor: pointer; color: #555;">&lt;</button>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <button type="button" onclick="goPage(${i})"
                                        class="page-btn ${i == currentPage ? 'active' : ''}"
                                        style="padding: 8px 14px; border: 1px solid ${i == currentPage ? '#2F4F4F' : '#ddd'}; background: ${i == currentPage ? '#2F4F4F' : '#fff'}; color: ${i == currentPage ? '#fff' : '#555'}; border-radius: 6px; cursor: pointer; font-weight: bold;">
                                    ${i}
                                </button>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <button type="button" onclick="goPage(${currentPage + 1})" style="padding: 8px 12px; border: 1px solid #ddd; background: #fff; border-radius: 6px; cursor: pointer; color: #555;">&gt;</button>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<script>
    // 지역 선택 데이터 (서버에서 가져온 값을 자바스크립트 객체로 매핑)
    const districtMap = {
        <c:forEach var="entry" items="${regionMap}" varStatus="status">
            "${entry.key}": [
                <c:forEach var="dist" items="${entry.value}" varStatus="distStatus">
                    "${dist}"${!distStatus.last ? ',' : ''}
                </c:forEach>
            ]${!status.last ? ',' : ''}
        </c:forEach>
    };

    function syncWishlistUI() {
        fetch('/linkora/api/wishlist/my')
            .then(res => res.json())
            .then(wishedList => {
                if (Array.isArray(wishedList)) {
                    // API에서 받아온 brnIdx 목록만 추출
                    const wishedIds = wishedList.map(item => String(item.brnIdx));

                    // 화면에 있는 모든 찜 버튼을 확인하여 동기화
                    document.querySelectorAll('.search-wish-btn').forEach(btn => {
                        const brnIdx = btn.getAttribute('data-brn-idx');
                        const icon = btn.querySelector('i');

                        if (wishedIds.includes(brnIdx)) {
                            // 찜 목록에 있으면 빨간 하트 활성화
                            btn.style.color = '#ff4757';
                            if (icon) icon.className = 'fa-solid fa-heart';
                        } else {
                            // 찜 목록에 없으면 회색 하트 비활성화
=======
                            btn.style.color = '#ff4757';
                            if (icon) icon.className = 'fa-solid fa-heart';
                        } else {
>>>>>>> origin/dev
                            btn.style.color = '#ccc';
                            if (icon) icon.className = 'fa-regular fa-heart';
                        }
                    });
                }
            })
            .catch(err => console.warn("찜 목록 동기화 실패:", err));
    }

    // [수정] 페이지 로드 시 찜 목록 동기화 및 기존에 선택했던 지역 값을 세팅
    document.addEventListener('DOMContentLoaded', () => {
        syncWishlistUI();

        // 서버에서 전달받은 지역 값(예: "서울특별시 강남구" 또는 "서울특별시")
        const savedRegion = "${region}";

        if (savedRegion) {
            // 공백을 기준으로 시/도 와 구/군을 분리
            const parts = savedRegion.split(' ');
            const savedCity = parts[0];
            const savedDistrict = parts.length > 1 ? parts[1] : '';

            const citySelect = document.getElementById('sidebarCity');

            // 시/도 select box에 저장된 값 세팅
            if (citySelect && [...citySelect.options].some(opt => opt.value === savedCity)) {
                citySelect.value = savedCity;
                // 해당 시/도에 맞는 상세 구 목록 렌더링
                updateSidebarDistricts();

                // 상세 구 select box에 저장된 값 세팅
                if (savedDistrict) {
                    const districtSelect = document.getElementById('sidebarDistrict');
                    if (districtSelect && [...districtSelect.options].some(opt => opt.value === savedDistrict)) {
                        districtSelect.value = savedDistrict;
                    }
                }
            }
        }
    });


    window.toggleSearchWish = function(target, brnIdx) {
        const icon = target.querySelector('i');

        fetch('/linkora/api/wishlist/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ "brnIdx": parseInt(brnIdx, 10) })
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                if (data.isAdded) {
                if (data.isAdded) {
                    target.style.color = '#ff4757';
                    icon.className = 'fa-solid fa-heart'; // 꽉 찬 하트
                } else {
                    // 찜 해제 성공 시: 하트를 다시 회색 테두리로 바꿉니다.
                    target.style.color = '#ccc';
                    icon.className = 'fa-regular fa-heart'; // 빈 하트
                }
            } else if (data.status === 'login_required') {
                // 비로그인 시 경고창 띄우고 로그인 페이지로 유도합니다.
                alert("로그인이 필요한 서비스입니다.");
                location.href = "/linkora/login";
            }
        })
        .catch(err => console.error("찜하기 통신 중 에러 발생:", err));
    };

    function goPage(page) {
        const form = document.getElementById('sidebarFilterForm');
        let pageInput = form.querySelector('input[name="page"]');
        if (!pageInput) {
            pageInput = document.createElement('input');
            pageInput.type = 'hidden'; pageInput.name = 'page';
            form.appendChild(pageInput);
        }
        pageInput.value = page;
        form.submit();
    }



    function updateSidebarDistricts() {
        const city = document.getElementById('sidebarCity').value;
        const districtSelect = document.getElementById('sidebarDistrict');
        districtSelect.innerHTML = '<option value="">상세 구 선택</option>';

        if (city && districtMap[city]) {
            districtSelect.disabled = false;
            districtMap[city].forEach(dist => {
                const option = document.createElement('option');
                option.value = dist; option.textContent = dist;
                districtSelect.appendChild(option);
            });
        } else {
            districtSelect.disabled = true;
        }
        updateSidebarRegionInput();
    }

    function updateSidebarRegionInput() {
        const city = document.getElementById('sidebarCity').value;
        const district = document.getElementById('sidebarDistrict').value;
        const actualInput = document.getElementById('actualSidebarRegion');

        if (city && district) {
            actualInput.value = city + " " + district;
        } else if (city) {
            actualInput.value = city;
        } else {
            actualInput.value = "";
        }
    }

    // 페이지 로드 시 기존 선택값 복구
    document.addEventListener('DOMContentLoaded', () => {
        const savedRegion = "${region}";
        if (savedRegion) {
            const parts = savedRegion.split(' ');
            const savedCity = parts[0];
            const savedDistrict = parts.length > 1 ? parts[1] : '';

            const citySelect = document.getElementById('sidebarCity');
            if (citySelect && [...citySelect.options].some(opt => opt.value === savedCity)) {
                citySelect.value = savedCity;
                updateSidebarDistricts();

                if (savedDistrict) {
                    const districtSelect = document.getElementById('sidebarDistrict');
                    if (districtSelect && [...districtSelect.options].some(opt => opt.value === savedDistrict)) {
                        districtSelect.value = savedDistrict;
                        updateSidebarRegionInput();
                    }
                }
            }
        }
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
  <title>내 관심 오피스</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

  <style>
    /* 화면 전체 높이 설정 및 푸터 하단 고정 */
    html, body {
      margin: 0;
      min-height: 100vh;
    }

    body {
      display: flex;
      flex-direction: column;
    }

    /* header.jsp 수정 없이 여기서 헤더를 강제로 녹색(검색페이지 스타일)으로 덮어씌움 */
    .main-header {
      flex-shrink: 0;
      background-color: #2F4F4F !important;
      border-bottom: 1px solid rgba(255,255,255,0.1) !important;
      box-shadow: 0 2px 10px rgba(0,0,0,0.3) !important;
    }

    /* 햄버거 메뉴, 로그인 버튼 흰색으로 */
    .main-header .hamburger-menu,
    .main-header .login-btn {
      color: #ffffff !important;
    }

    /* 예약 버튼 색상 반전 */
    .main-header .btn-book {
      background-color: #ffffff !important;
      color: #2F4F4F !important;
      border: none !important;
    }
    .main-header .btn-book:hover {
      background-color: #f0f0f0 !important;
    }

    /* 로고 색상 강제 흰색 변경 */
    .main-header .logo__icon rect:nth-child(2),
    .main-header .logo__icon rect:nth-child(4) {
      fill: #ffffff !important;
      stroke: #ffffff !important;
    }
    .main-header .logo__icon text {
      fill: #ffffff !important;
    }
    /* ----------------------------------------------------- */

    /* 윗부분 여백을 줄여서 덜 휑해 보이게 함 */
    .main-content {
      flex: 1;
      background-color: #ffffff;
      padding-top: 20px;
    }

    /* 제목 섹션의 여백도 확 줄여줌 */
    .title-section {
      background-color: #f4f7f6;
      padding: 30px 0;
      text-align: center;
      margin-bottom: 30px;
      border-bottom: 1px solid #e8f0ef;
    }

    .page-title {
      font-size: 32px;
      font-weight: 800;
      color: #2F4F4F;
      letter-spacing: -1px;
      margin-bottom: 10px;
    }

    .page-subtitle {
      color: #7a9e9e;
      font-size: 15px;
    }

    /* 탭 메뉴 디자인 */
    .tab-menu {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-bottom: 30px;
    }

    .tab-btn {
      padding: 10px 30px;
      font-size: 16px;
      font-weight: 700;
      border: 1px solid #d1e1e1;
      background-color: #ffffff;
      color: #4f8080;
      border-radius: 50px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .tab-btn.active {
      background-color: #2F4F4F;
      color: #ffffff;
      border-color: #2F4F4F;
    }

    .tab-content {
      display: none;
    }

    .tab-content.active {
      display: block;
      animation: fadeIn 0.4s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px);
      }
      to { opacity: 1; transform: translateY(0);
      }
    }

    /* 카드 그리드 설정 */
    .wish-grid, .recent-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
      margin-bottom: 40px;
    }

    @media (max-width: 1024px) {
      .wish-grid, .recent-grid { grid-template-columns: repeat(2, 1fr);
      }
    }
    @media (max-width: 768px) {
      .wish-grid, .recent-grid { grid-template-columns: 1fr;
      }
    }

    /* 지점 카드 세부 디자인 */
    .branch-card {
      background: #fff;
      border: 1px solid #e8f0ef;
      border-radius: 16px;
      overflow: hidden;
      transition: all 0.3s ease;
      display: flex;
      flex-direction: column;
      height: 100%;
      box-shadow: 0 4px 10px rgba(0,0,0,0.03);
    }

    .branch-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(47, 79, 79, 0.08);
    }

    /* [수정] WS 박스 폰트 크기를 키워서 더 잘 보이게 했어요 */
    .no-img-box {
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #f4f7f6, #d1e1e1);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #a3b8b8;
      font-size: 40px;
      font-weight: 800;
    }

    .branch-info h3 { color: #2F4F4F; font-weight: 700;
    }
    .facility-icons i { color: #a3b8b8 !important;
    }

    .btn-reservation {
      display: block;
      text-align: center;
      background: #2F4F4F;
      color: white !important;
      padding: 12px;
      border-radius: 10px;
      text-decoration: none;
      font-weight: 700;
      transition: background 0.3s;
      margin-top: auto;
    }
    .btn-reservation:hover { background: #1e3333; }

    /* 하트 모양을 원래의 깔끔한 빨간색으로 되돌림 */
    .search-wish-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 24px;
      color: #ff4757;
      padding: 0;
      transition: transform 0.2s ease;
    }
    .search-wish-btn:hover { transform: scale(1.15); }

    /* 안내 문구 박스 스타일 */
    .info-wrapper {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 15px;
    }

    .info-message {
      background-color: #ffffff;
      color: #4f8080;
      padding: 8px 14px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 6px;
      border: 1px solid #a3b8b8;
    }

    /* 데이터 없을 때의 빈 화면 디자인 */
    .empty-state {
      grid-column: 1 / -1;
      text-align: center;
      padding: 60px 20px;
      background-color: #ffffff;
      border-radius: 16px;
      border: 2px dashed #d1e1e1;
      margin: 10px 0;
    }

    .empty-icon {
      font-size: 50px;
      color: #a3b8b8;
      margin-bottom: 20px;
      opacity: 0.5;
    }

    .empty-state h3 { font-size: 22px; color: #2F4F4F; margin-bottom: 10px;
    }
    .empty-state p { color: #7a9e9e; margin-bottom: 25px;
    }

    .btn-go-search {
      display: inline-block;
      background-color: #2F4F4F;
      color: #ffffff;
      padding: 12px 35px;
      border-radius: 10px;
      text-decoration: none;
      font-weight: 700;
      transition: transform 0.2s;
    }
    .btn-go-search:hover { transform: scale(1.05);
    }

    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-top: 30px;
      margin-bottom: 50px;
    }
    .page-btn {
      padding: 8px 14px;
      border: 1px solid #ddd;
      background: #fff;
      color: #555;
      border-radius: 6px;
      cursor: pointer;
      font-weight: bold;
      transition: all 0.2s;
    }
    .page-btn:hover { background: #f0f0f0; }
    .page-btn.active {
      background: #2F4F4F !important;
      border-color: #2F4F4F !important;
      color: #fff !important;
    }
    .page-arrow {
      padding: 8px 12px;
      border: 1px solid #ddd;
      background: #fff;
      border-radius: 6px;
      cursor: pointer;
      color: #555;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="main-content">
  <section class="title-section">
    <div class="container">
      <h2 class="page-title">나의 관심 공간</h2>
      <p class="page-subtitle">찜한 지점과 최근 방문한 지점을 한눈에 확인하세요.</p>
    </div>
  </section>

  <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">

    <div class="tab-menu">
      <button class="tab-btn active" id="btn-wish" onclick="switchTab('wish')">관심 지점</button>
      <button class="tab-btn" id="btn-recent" onclick="switchTab('recent')">최근 본 지점</button>
    </div>

    <div id="content-wish" class="tab-content active">
      <c:if test="${empty wishList}">

        <div class="empty-state">
          <div class="empty-icon"><i class="fa-regular fa-heart"></i></div>
          <h3>아직 찜한 공간이 없어요</h3>
          <p>Link Ora의 프리미엄 오피스들을 둘러보시겠어요?</p>
          <a href="${pageContext.request.contextPath}/branch/search" class="btn-go-search">지점 찾기</a>
        </div>
      </c:if>

      <c:if test="${not empty wishList}">
        <div class="wish-grid">

          <c:forEach var="branch" items="${wishList}">
            <div class="branch-card" id="wish-card-${branch.brnIdx}">
              <div class="branch-img" style="height: 180px;"> <c:choose>
                <c:when test="${not empty branch.mainImgUrl}">
                  <c:choose>
                    <c:when test="${fn:startsWith(branch.mainImgUrl, '/')}">
                      <img src="${pageContext.request.contextPath}${branch.mainImgUrl}"
                           alt="${branch.brnName}"
                           style="width:100%; height:100%; object-fit:cover;"
                           onerror="this.parentElement.innerHTML='<div class=\'no-img-box\'>WS</div>'">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/static/upload/partner/${branch.mainImgUrl}"
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

              <div class="branch-info" style="padding: 20px;
 flex-grow: 1; display: flex; flex-direction: column;">
                <div style="display: flex;
 justify-content: space-between; align-items: center; margin-bottom: 10px;">
                  <h3 style="margin: 0;
 font-size: 20px;">${branch.brnName}</h3>
                  <button class="search-wish-btn" onclick="removeWish('${branch.brnIdx}')">
                    <i class="fa-solid fa-heart"></i>
                  </button>
                </div>
                <p class="location-text" style="margin-bottom: 15px;
 font-size: 13px; color: #666;">
                  <i class="fa-solid fa-location-dot" style="color: #2F4F4F;
 margin-right: 5px;"></i> ${branch.brnAddress}
                </p>
                <div class="facility-icons" style="display: flex; flex-wrap: wrap;
 gap: 12px; margin-bottom: 20px; font-size: 16px;">
                  <c:if test="${branch.facWifi != null and branch.facWifi == 1}"><i class="fa-solid fa-wifi" title="와이파이"></i></c:if>
                  <c:if test="${branch.facParking != null and branch.facParking == 1}"><i class="fa-solid fa-car" title="주차"></i></c:if>
                  <c:if test="${branch.facCoffee != null and branch.facCoffee == 1}"><i class="fa-solid fa-mug-hot" title="무료커피"></i></c:if>
                  <c:if test="${branch.facHours24 != null and branch.facHours24 == 1}"><i class="fa-solid fa-clock" title="24시간"></i></c:if>
                  <c:if test="${branch.facPet != null and branch.facPet == 1}"><i class="fa-solid fa-paw" title="반려동물"></i></c:if>

                  <c:if test="${branch.facCafe != null and branch.facCafe == 1}"><i class="fa-solid fa-utensils" title="카페테리아"></i></c:if>
                  <c:if test="${branch.facKitchen != null and branch.facKitchen == 1}"><i class="fa-solid fa-kitchen-set" title="공용주방"></i></c:if>
                  <c:if test="${branch.facWater != null and branch.facWater == 1}"><i class="fa-solid fa-bottle-water" title="정수기"></i></c:if>
                  <c:if test="${branch.facPrinter != null and branch.facPrinter == 1}"><i class="fa-solid fa-print" title="프린터/복사기"></i></c:if>
                  <c:if test="${branch.facLounge != null and branch.facLounge == 1}"><i class="fa-solid fa-couch" title="휴식 라운지"></i></c:if>
                </div>
                <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${branch.brnIdx}" class="btn-reservation">상세보기</a>
              </div>
            </div>
          </c:forEach>
        </div>

        <c:if test="${totalPages > 1}">
          <div class="pagination">
            <c:if test="${currentPage > 1}">
              <button type="button" onclick="goPage(${currentPage - 1})" class="page-arrow">&lt;</button>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
              <button type="button" onclick="goPage(${i})"
                      class="page-btn ${i == currentPage ? 'active' : ''}">
                  ${i}
              </button>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
              <button type="button" onclick="goPage(${currentPage + 1})" class="page-arrow">&gt;</button>
            </c:if>
          </div>
        </c:if>

      </c:if>
    </div>

    <div id="content-recent" class="tab-content">
      <div class="info-wrapper">
        <div class="info-message">
          <i class="fa-solid fa-circle-info"></i> 최근 본 지점은 최대 5개까지 기록됩니다.
        </div>
      </div>
      <div id="recent-grid" class="recent-grid"></div>
    </div>

  </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  const ctxPath = '${pageContext.request.contextPath}';

  function goPage(page) {
    location.href = ctxPath + '/branch/wishlist?page=' + page;
  }

  function switchTab(tabName) {
    document.getElementById('btn-wish').classList.remove('active');
    document.getElementById('btn-recent').classList.remove('active');
    document.getElementById('content-wish').classList.remove('active');
    document.getElementById('content-recent').classList.remove('active');

    if(tabName === 'wish') {
      document.getElementById('btn-wish').classList.add('active');
      document.getElementById('content-wish').classList.add('active');
    } else if(tabName === 'recent') {
      document.getElementById('btn-recent').classList.add('active');
      document.getElementById('content-recent').classList.add('active');
    }
  }

  function removeWish(brnIdx) {
    fetch(ctxPath + '/api/wishlist/toggle', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ "brnIdx": parseInt(brnIdx, 10) })
    })
            .then(res => res.json())
            .then(data => {
              if (data.status === 'success') {
                const card = document.getElementById('wish-card-' + brnIdx);
                if(card) card.style.display = 'none';
                setTimeout(() => location.reload(), 300);
              } else if (data.status === 'login_required') {
                alert("로그인이 필요한 서비스입니다.");
                location.href = ctxPath + "/login";
              }
            })
            .catch(err => console.error("Wishlist Error:", err));
  }

  function loadRecentBranches() {
    const recent = JSON.parse(localStorage.getItem('recentBranches')) || [];
    const grid = document.getElementById('recent-grid');
    if (recent.length === 0) {
      grid.innerHTML = '<div class="empty-state"><div class="empty-icon"><i class="fa-regular fa-clock"></i></div><h3>최근 본 공간이 없어요</h3><p>다양한 프리미엄 오피스를 먼저 둘러보세요.</p><a href="' + ctxPath + '/branch/search" class="btn-go-search">지점 둘러보기</a></div>';
      return;
    }

    let html = '';
    recent.forEach(b => {
      let imgSrc = '';
      if (b.mainImgUrl) {
        imgSrc = b.mainImgUrl.startsWith('/') ? ctxPath + b.mainImgUrl : ctxPath + '/static/upload/partner/' + b.mainImgUrl;
      }

      /* [핵심 수정] 최근 본 지점에서도 onerror 처리를 해서 사진이 깨지면 WS 박스가 나오게 했어요 */
      let imgTag = imgSrc ? '<img src="' + imgSrc + '" style="width:100%; height:100%; object-fit:cover;" onerror="this.parentElement.innerHTML=\'<div class=\\\'no-img-box\\\'>WS</div>\'">' : '<div class="no-img-box">WS</div>';

      html += '<div class="branch-card">';
      html += '<div class="branch-img" style="height: 180px;">' + imgTag + '</div>';
      html += '<div class="branch-info" style="padding: 20px; flex-grow: 1; display: flex; flex-direction: column;">';
      html += '<h3 style="margin:0 0 10px 0; font-size:20px;">' + b.brnName + '</h3>';
      html += '<p class="location-text" style="margin-bottom: 15px; font-size: 13px; color:#666;"><i class="fa-solid fa-location-dot" style="color: #2F4F4F; margin-right: 5px;"></i> ' + b.brnAddress + '</p>';

      html += '<div class="facility-icons" style="display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 20px; font-size: 16px;">';
      if(b.facWifi == 1 || b.facWifi == '1') html += '<i class="fa-solid fa-wifi" title="와이파이"></i>';
      if(b.facParking == 1 || b.facParking == '1') html += '<i class="fa-solid fa-car" title="주차"></i>';
      if(b.facCoffee == 1 || b.facCoffee == '1') html += '<i class="fa-solid fa-mug-hot" title="무료커피"></i>';
      if(b.facHours24 == 1 || b.facHours24 == '1') html += '<i class="fa-solid fa-clock" title="24시간"></i>';
      if(b.facPet == 1 || b.facPet == '1') html += '<i class="fa-solid fa-paw" title="반려동물"></i>';
      if(b.facCafe == 1 || b.facCafe == '1') html += '<i class="fa-solid fa-utensils" title="카페테리아"></i>';
      if(b.facKitchen == 1 || b.facKitchen == '1') html += '<i class="fa-solid fa-kitchen-set" title="공용주방"></i>';
      if(b.facWater == 1 || b.facWater == '1') html += '<i class="fa-solid fa-bottle-water" title="정수기"></i>';
      if(b.facPrinter == 1 || b.facPrinter == '1') html += '<i class="fa-solid fa-print" title="프린터/복사기"></i>';
      if(b.facLounge == 1 || b.facLounge == '1') html += '<i class="fa-solid fa-couch" title="휴식 라운지"></i>';
      html += '</div>';

      html += '<a href="' + ctxPath + '/detail/detail?brnIdx=' + b.brnIdx + '" class="btn-reservation">상세보기</a>';
      html += '</div></div>';
    });
    grid.innerHTML = html;
  }

  document.addEventListener('DOMContentLoaded', loadRecentBranches);
</script>
</body>
</html>
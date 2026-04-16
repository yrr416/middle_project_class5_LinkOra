<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
  <title>내 관심 오피스</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

  <style>
    /* 화면 전체를 유연한 상자로 만들어서 푸터를 맨 아래로 고정 */
    html, body {
      height: 100%;
      margin: 0;
    }
    body {
      display: flex;
      flex-direction: column;
    }

    .main-content {
      flex: 1;
      background-color: #fcfcfc;
      padding-top: 80px;
      padding-bottom: 80px;
    }

    /* 탭 버튼 디자인 설정 */
    .tab-menu {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-bottom: 40px;
    }

    .tab-btn {
      padding: 15px 40px;
      font-size: 18px;
      font-weight: 700;
      border: 2px solid #2F4F4F;
      background-color: transparent;
      color: #2F4F4F;
      border-radius: 30px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .tab-btn.active {
      background-color: #2F4F4F;
      color: #ffffff;
    }

    .tab-content {
      display: none;
    }

    .tab-content.active {
      display: block;
      animation: fadeIn 0.4s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* [수정] 관심 오피스와 최근 본 오피스의 크기를 똑같이 3열로 맞춤 */
    .wish-grid, .recent-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 25px;
    }

    @media (max-width: 1024px) {
      .wish-grid, .recent-grid { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 768px) {
      .wish-grid, .recent-grid { grid-template-columns: 1fr; }
    }

    /* 카드 공통 스타일 */
    .branch-card {
      background: #fff;
      border: 1px solid #ececec;
      border-radius: 12px;
      overflow: hidden;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      display: flex;
      flex-direction: column;
      height: 100%;
    }
    .branch-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 20px rgba(0,0,0,0.1);
    }

    .no-img-box {
      width: 100%;
      height: 100%;
      background: linear-gradient(to bottom right, #f1f3f2, #e2e5e4);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #a3b0ae;
      font-size: 40px;
      font-weight: 800;
    }

    .branch-info h3 { color: #222; font-weight: 700; }
    .branch-info .location-text { color: #666; font-size: 13px; }
    .facility-icons i { color: #2F4F4F !important; }

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
    .btn-reservation:hover { background: #1e3333; }

    .search-wish-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 22px;
      color: #ff4757;
      transition: transform 0.2s ease;
    }
    .search-wish-btn:hover { transform: scale(1.15); }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="main-content">
  <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">

    <h2 style="font-size: 32px; font-weight: bold; margin-bottom: 30px; color: #2F4F4F; text-align: center;">나의 관심 공간</h2>

    <div class="tab-menu">
      <button class="tab-btn active" id="btn-wish" onclick="switchTab('wish')">내 관심 오피스</button>
      <button class="tab-btn" id="btn-recent" onclick="switchTab('recent')">최근 본 오피스</button>
    </div>

    <div id="content-wish" class="tab-content active">
      <c:if test="${empty wishList}">
        <div style="text-align: center; padding: 60px 0; border: 1px dashed #ccc; border-radius: 12px;">
          <i class="fa-regular fa-heart" style="font-size: 50px; color: #ccc; margin-bottom: 20px;"></i>
          <p style="color: #666; font-size: 18px;">아직 찜한 오피스가 없습니다.</p>
        </div>
      </c:if>

      <c:if test="${not empty wishList}">
        <div class="wish-grid">
          <c:forEach var="branch" items="${wishList}">
            <div class="branch-card" id="wish-card-${branch.brnIdx}">
              <div class="branch-img" style="height: 180px; background: #f0f0f0;">
                <c:choose>
                  <c:when test="${not empty branch.mainImgUrl}">
                    <c:choose>
                      <c:when test="${fn:startsWith(branch.mainImgUrl, '/')}">
                        <img src="${pageContext.request.contextPath}${branch.mainImgUrl}" alt="${branch.brnName}" style="width:100%; height:100%; object-fit:cover;">
                      </c:when>
                      <c:otherwise>
                        <img src="${pageContext.request.contextPath}/static/upload/branch/${branch.mainImgUrl}" alt="${branch.brnName}" style="width:100%; height:100%; object-fit:cover;">
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
                  <button class="search-wish-btn" onclick="removeWish('${branch.brnIdx}')">
                    <i class="fa-solid fa-heart"></i>
                  </button>
                </div>
                <p class="location-text" style="margin-bottom: 15px;">
                  <i class="fa-solid fa-location-dot" style="color: #2F4F4F; margin-right: 5px;"></i> ${branch.brnAddress}
                </p>
                <div class="facility-icons" style="display: flex; gap: 12px; margin-bottom: 20px; font-size: 18px;">
                  <c:if test="${branch.facWifi == 1}"><i class="fa-solid fa-wifi"></i></c:if>
                  <c:if test="${branch.facParking == 1}"><i class="fa-solid fa-car"></i></c:if>
                  <c:if test="${branch.facCoffee == 1}"><i class="fa-solid fa-mug-hot"></i></c:if>
                  <c:if test="${branch.facHours24 == 1}"><i class="fa-solid fa-clock"></i></c:if>
                  <c:if test="${branch.facPet == 1}"><i class="fa-solid fa-paw"></i></c:if>
                </div>
                <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${branch.brnIdx}" class="btn-reservation">상세보기</a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:if>
    </div>

    <div id="content-recent" class="tab-content">
      <div id="recent-grid" class="recent-grid"></div>
    </div>

  </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  const ctxPath = '${pageContext.request.contextPath}';

  // 탭 변경
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

  // 찜 해제
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
              } else if (data.status === 'login_required') {
                alert("로그인이 필요한 서비스입니다.");
                location.href = ctxPath + "/login";
              }
            })
            .catch(err => console.error("Wishlist Error:", err));
  }

  // [수정] 최근 본 지점 불러오기 로직 (관심 오피스와 똑같은 디자인 적용)
  function loadRecentBranches() {
    const recent = JSON.parse(localStorage.getItem('recentBranches')) || [];
    const grid = document.getElementById('recent-grid');

    if (recent.length === 0) {
      grid.innerHTML = '<p style="color:#999; grid-column: 1 / -1; text-align: center; padding: 60px 0; background: transparent; border-radius: 12px; border: 1px dashed #ccc;">최근 본 지점이 없습니다.</p>';
      return;
    }

    let html = '';
    recent.forEach(b => {
      let imgSrc = '';
      if (b.mainImgUrl) {
        imgSrc = b.mainImgUrl.startsWith('/') ? ctxPath + b.mainImgUrl : ctxPath + '/static/upload/branch/' + b.mainImgUrl;
      }
      let imgTag = imgSrc ? '<img src="' + imgSrc + '" style="width:100%; height:100%; object-fit:cover;">' : '<div class="no-img-box" style="font-size:24px;">WS</div>';

      html += '<div class="branch-card">';
      // 사진 높이를 180px로 변경해서 관심 오피스와 맞춤
      html += '<div class="branch-img" style="height: 180px; background: #f0f0f0;">' + imgTag + '</div>';
      // 내부 여백과 글자 크기도 똑같이 맞춤
      html += '<div class="branch-info" style="padding: 20px; flex-grow: 1; display: flex; flex-direction: column;">';
      html += '<h3 style="margin:0 0 10px 0; font-size:20px;">' + b.brnName + '</h3>';
      html += '<p class="location-text" style="margin-bottom: 15px;"><i class="fa-solid fa-location-dot" style="color: #2F4F4F; margin-right: 5px;"></i> ' + b.brnAddress + '</p>';
      // 상세보기 버튼을 바닥에 붙이기 위한 빈 공간
      html += '<div style="margin-bottom: 20px;"></div>';
      html += '<a href="' + ctxPath + '/detail/detail?brnIdx=' + b.brnIdx + '" class="btn-reservation">상세보기</a>';
      html += '</div></div>';
    });
    grid.innerHTML = html;
  }

  document.addEventListener('DOMContentLoaded', loadRecentBranches);
</script>
</body>
</html>
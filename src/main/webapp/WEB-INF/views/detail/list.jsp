<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<script src="https://cdn.tailwindcss.com"></script>
<%-- CDN 로드 후에 config를 설정해야 tailwind 객체가 존재함 --%>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          indigo: {
            50:  '#f4f7f6',
            100: '#e8f0ef',
            200: '#d1e1e1',
            300: '#a3b8b8',
            400: '#7a9e9e',
            500: '#4f8080',
            600: '#2F4F4F',
            700: '#1e3333',
            800: '#162828',
            900: '#0e1c1c',
          }
        }
      }
    }
  }
</script>

<main>
<div class="max-w-6xl mx-auto px-4 py-10">
  <h1 class="text-2xl font-bold text-gray-800 mb-2">공유오피스 지점 목록</h1>
  <p class="text-sm text-gray-400 mb-8">원하는 지점을 선택하고 공간을 예약하세요</p>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:forEach var="branch" items="${branchList}">
      <div class="bg-white rounded-2xl shadow hover:shadow-md transition overflow-hidden">

        <%-- 지점 대표 이미지 --%>
        <c:choose>
          <c:when test="${not empty branch.images}">
            <img src="${pageContext.request.contextPath}${branch.images[0].biUrl}"
                 alt="${branch.brnName}"
                 class="w-full h-44 object-cover"
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="w-full h-44 bg-gradient-to-br from-indigo-50 to-indigo-100
                        flex items-center justify-center text-indigo-300 text-4xl font-bold select-none"
                 style="display:none;">
              WS
            </div>
          </c:when>
          <c:otherwise>
            <div class="w-full h-44 bg-gradient-to-br from-indigo-50 to-indigo-100
                        flex items-center justify-center text-indigo-300 text-4xl font-bold select-none">
              WS
            </div>
          </c:otherwise>
        </c:choose>

        <div class="p-5">
          <%-- 파트너 배지 --%>
          <span class="text-xs font-semibold text-indigo-600 bg-indigo-50 px-2.5 py-0.5 rounded-full">
            ${branch.partnerName}
          </span>

          <h2 class="text-base font-bold text-gray-800 mt-2 mb-1">${branch.brnName}</h2>

          <c:if test="${not empty branch.brnAddress}">
            <p class="text-xs text-gray-400 mb-3">
              <i class="fa-solid fa-location-dot mr-1" style="color:#2F4F4F;"></i>${branch.brnAddress}
            </p>
          </c:if>

          <a href="${pageContext.request.contextPath}/detail/detail?brnIdx=${branch.brnIdx}"
             class="block text-center bg-indigo-600 hover:bg-indigo-700
                    text-white text-sm font-semibold py-2 rounded-xl transition">
            지점 상세보기
          </a>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty branchList}">
      <p class="text-gray-400 col-span-3 text-center py-20">등록된 지점이 없습니다.</p>
    </c:if>
  </div>
</div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

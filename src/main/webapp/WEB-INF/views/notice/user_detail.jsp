<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<%-- Tailwind CSS --%>
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          brand: {
            50:  '#f4f7f6',
            100: '#e8f0ef',
            200: '#d1e1e1',
            300: '#a3b8b8',
            400: '#7a9e9e',
            500: '#4f8080',
            600: '#2F4F4F',
            700: '#1e3333',
          }
        }
      }
    }
  }
</script>

<style>
  main { padding-top: 80px; }

  /* CKEditor 에서 작성한 HTML 본문 스타일 초기화 방지 */
  .notice-content {
    line-height: 1.8;
    color: #374151;
    font-size: 0.95rem;
  }
  .notice-content p  { margin-bottom: 0.8em; }
  .notice-content ul { list-style: disc; padding-left: 1.5em; margin-bottom: 0.8em; }
  .notice-content ol { list-style: decimal; padding-left: 1.5em; margin-bottom: 0.8em; }
  .notice-content img { max-width: 100%; border-radius: 8px; margin: 12px 0; }
  .notice-content h2 { font-size: 1.2em; font-weight: 700; margin: 1em 0 0.4em; }
  .notice-content h3 { font-size: 1.05em; font-weight: 700; margin: 1em 0 0.4em; }
  .notice-content a  { color: #2F4F4F; text-decoration: underline; }

  /* 이전글/다음글 행 */
  .nav-row { transition: background 0.15s; }
  .nav-row:hover { background-color: #f4f7f6; }
</style>

<main>
<div class="max-w-3xl mx-auto px-4 py-10">

  <%-- ── 빵부스러기 / 상단 링크 ── --%>
  <div class="text-xs text-gray-400 mb-6 flex items-center gap-1">
    <a href="${pageContext.request.contextPath}/" class="hover:text-brand-600">홈</a>
    <i class="fa-solid fa-chevron-right text-gray-300 text-[10px]"></i>
    <a href="${pageContext.request.contextPath}/notice/list?nowPage=${nowPage}"
       class="hover:text-brand-600">공지/이벤트</a>
    <i class="fa-solid fa-chevron-right text-gray-300 text-[10px]"></i>
    <span class="text-gray-500 truncate max-w-xs">${notice.ntcTitle}</span>
  </div>

  <%-- ── 공지 본문 카드 ── --%>
  <div class="bg-white rounded-2xl shadow overflow-hidden">

    <%-- 헤더 영역 --%>
    <div class="px-7 py-6 border-b border-gray-100">

      <%-- 고정 공지 배지 --%>
      <c:if test="${notice.ntcActive == '1'}">
        <span class="inline-flex items-center gap-1 text-xs font-semibold
                     text-brand-600 bg-brand-50 border border-brand-200
                     rounded-full px-3 py-0.5 mb-3">
          <i class="fa-solid fa-thumbtack text-[10px]"></i> 고정 공지
        </span>
      </c:if>

      <%-- 제목 --%>
      <h1 class="text-xl font-bold text-gray-800 leading-snug mb-3">
        ${notice.ntcTitle}
      </h1>

      <%-- 메타 정보 (작성일 / 수정일) --%>
      <div class="flex items-center gap-4 text-xs text-gray-400">
        <span>
          <i class="fa-regular fa-calendar mr-1"></i>
          작성일
          <c:choose>
            <c:when test="${not empty notice.ntcCreated and fn:length(notice.ntcCreated) >= 10}">
              ${fn:substring(notice.ntcCreated, 0, 10)}
            </c:when>
            <c:otherwise>-</c:otherwise>
          </c:choose>
        </span>
        <c:if test="${not empty notice.ntcUpdated}">
          <span class="text-gray-300">|</span>
          <span>
            <i class="fa-regular fa-pen-to-square mr-1"></i>
            수정일 ${fn:substring(notice.ntcUpdated, 0, 10)}
          </span>
        </c:if>
      </div>
    </div>

    <%-- 본문 영역 --%>
    <div class="px-7 py-8">

      <%-- 대표 이미지 (등록된 경우에만 표시) --%>
      <c:if test="${not empty notice.ntcImg}">
        <div class="mb-6">
          <img src="${notice.ntcImg}" alt="대표 이미지"
               class="w-full rounded-xl object-cover"
               style="max-height:420px;">
        </div>
      </c:if>

      <%-- 공지 내용 (CKEditor HTML 그대로 렌더링) --%>
      <div class="notice-content">
        ${notice.ntcContent}
      </div>
    </div>
  </div>

  <%-- ── 이전글 / 다음글 네비게이션 ── --%>
  <div class="mt-4 bg-white rounded-2xl shadow overflow-hidden divide-y divide-gray-100">

    <%-- 다음글 (더 최신 공지) --%>
    <c:choose>
      <c:when test="${not empty nextNotice}">
        <a href="${pageContext.request.contextPath}/notice/detail?ntcIdx=${nextNotice.ntcIdx}&nowPage=${nowPage}"
           class="nav-row flex items-center gap-3 px-6 py-3">
          <span class="text-xs font-semibold text-gray-400 w-14 flex-shrink-0 flex items-center gap-1">
            <i class="fa-solid fa-chevron-up text-[10px]"></i> 다음글
          </span>
          <span class="text-sm text-gray-700 truncate hover:text-brand-600">
            ${nextNotice.ntcTitle}
          </span>
        </a>
      </c:when>
      <c:otherwise>
        <div class="flex items-center gap-3 px-6 py-3">
          <span class="text-xs font-semibold text-gray-300 w-14 flex-shrink-0 flex items-center gap-1">
            <i class="fa-solid fa-chevron-up text-[10px]"></i> 다음글
          </span>
          <span class="text-sm text-gray-300">마지막 공지입니다.</span>
        </div>
      </c:otherwise>
    </c:choose>

    <%-- 이전글 (더 오래된 공지) --%>
    <c:choose>
      <c:when test="${not empty prevNotice}">
        <a href="${pageContext.request.contextPath}/notice/detail?ntcIdx=${prevNotice.ntcIdx}&nowPage=${nowPage}"
           class="nav-row flex items-center gap-3 px-6 py-3">
          <span class="text-xs font-semibold text-gray-400 w-14 flex-shrink-0 flex items-center gap-1">
            <i class="fa-solid fa-chevron-down text-[10px]"></i> 이전글
          </span>
          <span class="text-sm text-gray-700 truncate hover:text-brand-600">
            ${prevNotice.ntcTitle}
          </span>
        </a>
      </c:when>
      <c:otherwise>
        <div class="flex items-center gap-3 px-6 py-3">
          <span class="text-xs font-semibold text-gray-300 w-14 flex-shrink-0 flex items-center gap-1">
            <i class="fa-solid fa-chevron-down text-[10px]"></i> 이전글
          </span>
          <span class="text-sm text-gray-300">첫 번째 공지입니다.</span>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- ── 목록으로 버튼 ── --%>
  <div class="mt-6 flex justify-center">
    <a href="${pageContext.request.contextPath}/notice/list?nowPage=${nowPage}&searchWord=${param.searchWord}"
       class="inline-flex items-center gap-2 px-7 py-2.5 bg-brand-600 hover:bg-brand-700
              text-white text-sm font-semibold rounded-xl shadow transition">
      <i class="fa-solid fa-list"></i> 목록으로
    </a>
  </div>

</div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

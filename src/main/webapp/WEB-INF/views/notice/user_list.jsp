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
  /* 헤더 아래 여백 */
  main { padding-top: 80px; }
  /* 고정 공지 행 배경 — 연한 앰버/골드 계열로 강조 */
  .pin-row { background: linear-gradient(90deg, #fffbeb 0%, #fef9e7 100%); border-left: 3px solid #f59e0b; }
  /* NEW 배지 */
  .badge-new {
    display: inline-block;
    font-size: 10px;
    font-weight: 700;
    color: #fff;
    background: #e53e3e;
    border-radius: 4px;
    padding: 1px 5px;
    margin-left: 6px;
    vertical-align: middle;
  }
  /* 카테고리 배지 */
  .badge-cat {
    display: inline-block;
    font-size: 11px;
    font-weight: 600;
    border-radius: 9999px;
    padding: 2px 10px;
  }
</style>

<main>
<div class="max-w-4xl mx-auto px-4 py-10">

  <%-- ── 페이지 제목 ── --%>
  <div class="mb-8">
    <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
      <i class="fa-solid fa-bullhorn text-brand-600"></i> 공지/이벤트
    </h1>
    <p class="text-sm text-gray-400 mt-1">Link Ora의 새로운 소식을 확인하세요.</p>
  </div>

  <%--
    ── 카테고리 탭 ──
    activeFilter="" → 전체
    activeFilter="0" → 공지  (n_active % 2 == 0)
    activeFilter="1" → 이벤트 (n_active % 2 == 1)
  --%>
  <div class="flex gap-2 flex-wrap mb-5">

    <%-- 전체 탭 --%>
    <a href="${pageContext.request.contextPath}/notice/list?searchWord=${noticeVO.searchWord}"
       class="px-4 py-1.5 rounded-full text-sm font-semibold transition
              ${empty noticeVO.activeFilter
                ? 'bg-brand-600 text-white shadow'
                : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}">
      전체
    </a>

    <%-- 공지 탭 --%>
    <a href="${pageContext.request.contextPath}/notice/list?activeFilter=0&searchWord=${noticeVO.searchWord}"
       class="px-4 py-1.5 rounded-full text-sm font-semibold transition
              ${noticeVO.activeFilter == '0'
                ? 'bg-brand-600 text-white shadow'
                : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}">
      공지
    </a>

    <%-- 이벤트 탭 --%>
    <a href="${pageContext.request.contextPath}/notice/list?activeFilter=1&searchWord=${noticeVO.searchWord}"
       class="px-4 py-1.5 rounded-full text-sm font-semibold transition
              ${noticeVO.activeFilter == '1'
                ? 'bg-brand-600 text-white shadow'
                : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}">
      이벤트
    </a>

  </div>

  <%-- ── 검색 폼 ── --%>
  <form method="get" action="${pageContext.request.contextPath}/notice/list"
        class="flex gap-2 mb-6">
    <input type="text" name="searchWord"
           value="${noticeVO.searchWord}"
           placeholder="제목으로 검색"
           class="flex-1 border border-gray-200 rounded-xl px-4 py-2 text-sm
                  focus:outline-none focus:ring-2 focus:ring-brand-300" />
    <button type="submit"
            class="px-5 py-2 bg-brand-600 text-white text-sm font-semibold
                   rounded-xl hover:bg-brand-700 transition">
      <i class="fa-solid fa-magnifying-glass"></i> 검색
    </button>
    <c:if test="${not empty noticeVO.searchWord}">
      <a href="${pageContext.request.contextPath}/notice/list"
         class="px-4 py-2 bg-gray-100 text-gray-500 text-sm font-semibold
                rounded-xl hover:bg-gray-200 transition">
        초기화
      </a>
    </c:if>
  </form>

  <%-- ── 공지 목록 테이블 ── --%>
  <div class="bg-white rounded-2xl shadow overflow-hidden">

    <%-- 검색 결과 수 --%>
    <div class="px-5 py-3 border-b border-gray-100 text-xs text-gray-400">
      총 <span class="font-semibold text-gray-600">${totalRecord}</span>건
      <c:if test="${not empty noticeVO.searchWord}">
        — "<span class="text-brand-600">${noticeVO.searchWord}</span>" 검색 결과
      </c:if>
    </div>

    <c:choose>
      <c:when test="${empty noticeList}">
        <div class="py-20 text-center text-gray-300">
          <i class="fa-regular fa-folder-open text-4xl mb-3 block"></i>
          등록된 공지/이벤트가 없습니다.
        </div>
      </c:when>
      <c:otherwise>
        <ul class="divide-y divide-gray-100">
          <c:forEach var="notice" items="${noticeList}">

            <%--
              7일 이내 작성된 공지인지 확인: NoticeVO를 직접 캐스팅해서 날짜 비교
            --%>
            <%
              org.study.project05.notice.vo.NoticeVO currentNotice =
                  (org.study.project05.notice.vo.NoticeVO) pageContext.findAttribute("notice");
              boolean isNewNotice = false;
              if (currentNotice != null && currentNotice.getNtcCreated() != null
                      && currentNotice.getNtcCreated().length() >= 10) {
                  try {
                      java.time.LocalDate createdDate =
                          java.time.LocalDate.parse(currentNotice.getNtcCreated().substring(0, 10));
                      isNewNotice = !createdDate.isBefore(java.time.LocalDate.now().minusDays(7));
                  } catch (Exception ignored) {}
              }
              pageContext.setAttribute("isNew", isNewNotice);
            %>

            <%-- n_active >= 2 이면 고정 행 강조 --%>
            <li class="${notice.ntcActive >= 2 ? 'pin-row' : ''}">
              <a href="${pageContext.request.contextPath}/notice/detail?ntcIdx=${notice.ntcIdx}&nowPage=${nowPage}"
                 class="flex items-center gap-3 px-5 py-4 hover:bg-brand-50 transition group">

                <%--
                  공지 / 이벤트 배지
                  n_active % 2 == 1 → 이벤트 (n_active=1 또는 3)
                  n_active % 2 == 0 → 공지   (n_active=0 또는 2)
                --%>
                <c:choose>
                  <c:when test="${notice.ntcActive % 2 == 1}">
                    <span class="flex-shrink-0 text-xs font-semibold px-2 py-0.5 rounded-full
                                 bg-yellow-100 text-yellow-700 border border-yellow-300">
                      이벤트
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="flex-shrink-0 text-xs font-semibold px-2 py-0.5 rounded-full
                                 bg-brand-100 text-brand-700 border border-brand-200">
                      공지
                    </span>
                  </c:otherwise>
                </c:choose>

                <%-- 제목 + NEW 배지 --%>
                <span class="flex-1 text-sm font-medium text-gray-700 group-hover:text-brand-600 truncate">
                  ${notice.ntcTitle}
                  <c:if test="${isNew}">
                    <span class="badge-new">N</span>
                  </c:if>
                </span>

                <%-- 작성일 --%>
                <span class="text-xs text-gray-400 flex-shrink-0">
                  <c:choose>
                    <c:when test="${not empty notice.ntcCreated and fn:length(notice.ntcCreated) >= 10}">
                      ${fn:substring(notice.ntcCreated, 0, 10)}
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </span>

                <i class="fa-solid fa-chevron-right text-gray-300 text-xs flex-shrink-0"></i>
              </a>
            </li>
          </c:forEach>
        </ul>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- ── 페이징 ── --%>
  <c:if test="${totalPage > 1}">
    <div class="flex justify-center gap-1 mt-8">

      <%-- 이전 블록 --%>
      <c:if test="${beginBlock > 1}">
        <a href="${pageContext.request.contextPath}/notice/list?nowPage=${beginBlock - 1}&searchWord=${noticeVO.searchWord}"
           class="px-3 py-1.5 rounded-lg text-sm text-gray-500 hover:bg-gray-100 transition">
          <i class="fa-solid fa-chevron-left"></i>
        </a>
      </c:if>

      <%-- 페이지 번호 --%>
      <c:forEach begin="${beginBlock}" end="${endBlock}" var="p">
        <c:choose>
          <c:when test="${p == nowPage}">
            <span class="px-3 py-1.5 rounded-lg text-sm font-bold
                         bg-brand-600 text-white shadow">
              ${p}
            </span>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/notice/list?nowPage=${p}&searchWord=${noticeVO.searchWord}"
               class="px-3 py-1.5 rounded-lg text-sm text-gray-600 hover:bg-gray-100 transition">
              ${p}
            </a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <%-- 다음 블록 --%>
      <c:if test="${endBlock < totalPage}">
        <a href="${pageContext.request.contextPath}/notice/list?nowPage=${endBlock + 1}&searchWord=${noticeVO.searchWord}"
           class="px-3 py-1.5 rounded-lg text-sm text-gray-500 hover:bg-gray-100 transition">
          <i class="fa-solid fa-chevron-right"></i>
        </a>
      </c:if>
    </div>
  </c:if>

</div>
</main>

<%-- 푸터 포함 --%>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

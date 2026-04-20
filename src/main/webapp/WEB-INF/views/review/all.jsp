<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<script src="https://cdn.tailwindcss.com"></script>

<div class="max-w-5xl mx-auto px-4 py-10">

    <%-- 상단 타이틀 --%>
    <div class="mb-8">
        <h1 class="text-2xl font-bold text-gray-800">이용 후기</h1>
        <p class="text-sm text-gray-400 mt-1">링크오피스를 이용한 고객들의 생생한 후기입니다. (총 <span class="text-teal-600 font-semibold">${total}</span>건)</p>
    </div>

    <%-- 리뷰 카드 그리드 --%>
    <c:choose>
        <c:when test="${not empty reviewList}">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                <c:forEach var="r" items="${reviewList}">
                    <a href="${ctx}/detail/detail?brnIdx=${r.brnIdx}"
                       class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 flex flex-col gap-3 hover:shadow-md hover:border-teal-200 transition cursor-pointer no-underline">

                        <%-- 지점 / 공간 --%>
                        <div class="text-xs text-gray-400">
                            <span class="text-teal-600 font-semibold">${r.branchName}</span>
                            &nbsp;·&nbsp;${r.spaceName}
                        </div>

                        <%-- 별점 --%>
                        <div class="flex items-center gap-0.5">
                            <c:forEach begin="1" end="5" var="i">
                                <span class="${i <= r.revRating ? 'text-yellow-400' : 'text-gray-200'} text-base">★</span>
                            </c:forEach>
                            <span class="text-xs text-gray-400 ml-1">${r.revRating}.0</span>
                        </div>

                        <%-- 이미지 (있을 때만) --%>
                        <c:if test="${not empty r.revImg}">
                            <img src="${ctx}/static/upload/review/${r.revImg}"
                                 alt="리뷰 이미지"
                                 class="w-full h-36 object-cover rounded-xl border border-gray-100">
                        </c:if>

                        <%-- 본문 --%>
                        <p class="text-sm text-gray-700 leading-relaxed line-clamp-4 flex-1">${r.revContent}</p>

                        <%-- 작성자 / 날짜 --%>
                        <div class="flex items-center justify-between text-xs text-gray-400 pt-2 border-t border-gray-50">
                            <span class="font-medium text-gray-500">${r.authorName}</span>
                            <fmt:formatDate value="${r.revCreatedAt}" pattern="yyyy.MM.dd"/>
                        </div>
                    </a>
                </c:forEach>
            </div>

            <%-- 페이징 --%>
            <div class="flex justify-center items-center gap-1 mt-10 flex-wrap">
                <%-- 이전 블록 --%>
                <c:if test="${paging.beginBlock > 1}">
                    <a href="?page=${paging.beginBlock - 1}"
                       class="px-3 py-1.5 rounded-lg border border-gray-200 text-sm text-gray-500 hover:bg-gray-50">&laquo;</a>
                </c:if>

                <%-- 페이지 번호 --%>
                <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="p">
                    <a href="?page=${p}"
                       class="px-3 py-1.5 rounded-lg border text-sm transition
                              ${p == paging.nowPage
                                ? 'bg-teal-600 text-white border-teal-600 font-semibold'
                                : 'border-gray-200 text-gray-600 hover:bg-gray-50'}">${p}</a>
                </c:forEach>

                <%-- 다음 블록 --%>
                <c:if test="${paging.endBlock < paging.totalPage}">
                    <a href="?page=${paging.endBlock + 1}"
                       class="px-3 py-1.5 rounded-lg border border-gray-200 text-sm text-gray-500 hover:bg-gray-50">&raquo;</a>
                </c:if>
            </div>
        </c:when>

        <c:otherwise>
            <div class="text-center py-24 text-gray-400">
                <p class="text-5xl mb-4">💬</p>
                <p class="text-sm">아직 작성된 후기가 없습니다.</p>
                <a href="${ctx}/detail/list"
                   class="mt-4 inline-block text-sm text-teal-600 hover:underline">오피스 둘러보기</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
    .line-clamp-4 {
        display: -webkit-box;
        -webkit-line-clamp: 4;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    a.no-underline { text-decoration: none; color: inherit; display: flex; flex-direction: column; }
</style>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

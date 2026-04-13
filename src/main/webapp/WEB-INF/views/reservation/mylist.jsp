<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 예약 목록 — LinkOra</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

<%-- 네비게이션 --%>
<nav class="bg-white border-b border-gray-200 sticky top-0 z-30">
    <div class="max-w-4xl mx-auto px-4 h-14 flex items-center justify-between">
        <a href="${pageContext.request.contextPath}/detail/list"
           class="text-lg font-bold text-indigo-600">LinkOra</a>
        <div class="flex items-center gap-3 text-sm">
            <span class="text-gray-600">${sessionScope.loginUser.name}님</span>
            <a href="${pageContext.request.contextPath}/logoutNow"
               class="text-gray-400 hover:text-gray-600">로그아웃</a>
        </div>
    </div>
</nav>

<div class="max-w-4xl mx-auto px-4 py-10">
    <h1 class="text-2xl font-bold text-gray-800 mb-2">내 예약 목록</h1>
    <p class="text-sm text-gray-400 mb-8">${sessionScope.loginUser.name}님의 예약 내역입니다.</p>

    <%-- 취소 완료 알림 --%>
    <c:if test="${not empty cancelMsg}">
        <div class="bg-green-50 border border-green-300 text-green-700 text-sm rounded-xl px-4 py-3 mb-6">
            ${cancelMsg}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty reservationList}">
            <div class="space-y-4">
                <c:forEach var="r" items="${reservationList}">
                    <div class="bg-white rounded-2xl shadow-sm p-5">
                        <div class="flex items-start justify-between flex-wrap gap-3">

                            <%-- 왼쪽: 예약 정보 --%>
                            <div>
                                <div class="flex items-center gap-2 mb-1">
                                    <%-- 상태 배지 --%>
                                    <c:choose>
                                        <c:when test="${r.resStatus eq 'PENDING'}">
                                            <span class="text-xs font-semibold text-amber-600 bg-amber-50 px-2 py-0.5 rounded-full">대기중</span>
                                        </c:when>
                                        <c:when test="${r.resStatus eq 'CONFIRMED'}">
                                            <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-0.5 rounded-full">확정</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-xs font-semibold text-gray-400 bg-gray-100 px-2 py-0.5 rounded-full">취소됨</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="font-semibold text-gray-800">${r.branchName}</span>
                                </div>
                                <p class="text-sm text-gray-500 mb-2">${r.spaceName}</p>

                                <div class="text-sm text-gray-600 space-y-1">
                                    <p>📅 ${fn:substring(r.resStartTime, 0, 16)} ~ ${fn:substring(r.resEndTime, 0, 16)}</p>
                                    <c:if test="${r.resHeadcount > 0}">
                                        <p>👥 ${r.resHeadcount}명</p>
                                    </c:if>
                                    <p class="font-semibold text-indigo-600">
                                        💳 예상 결제: ${r.resTotalPrice}원
                                    </p>
                                </div>
                            </div>

                            <%-- 오른쪽: 취소 버튼 (PENDING만) --%>
                            <c:if test="${r.resStatus eq 'PENDING'}">
                                <form action="${pageContext.request.contextPath}/reservation/cancel"
                                      method="post"
                                      onsubmit="return confirm('예약을 취소하시겠습니까?')">
                                    <input type="hidden" name="resIdx" value="${r.resIdx}">
                                    <button type="submit"
                                            class="text-sm text-red-500 hover:text-red-700 border border-red-300
                                                   hover:border-red-500 px-4 py-2 rounded-xl transition">
                                        예약 취소
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-20">
                <p class="text-gray-400 text-sm mb-4">아직 예약 내역이 없습니다.</p>
                <a href="${pageContext.request.contextPath}/detail/list"
                   class="inline-block bg-indigo-600 hover:bg-indigo-700 text-white
                          font-semibold px-6 py-2.5 rounded-xl transition">
                    공간 둘러보기
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>

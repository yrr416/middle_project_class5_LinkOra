<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<script src="https://cdn.tailwindcss.com"></script>
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

<div class="max-w-xl mx-auto px-4 py-20 text-center">
    <div class="bg-white rounded-2xl shadow p-10">
        <div class="text-5xl mb-4">❌</div>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">결제에 실패했습니다</h1>

        <%-- 실패 사유 출력 (토스 또는 서버에서 넘겨준 메시지) --%>
        <c:choose>
            <c:when test="${not empty errorMsg}">
                <p class="text-red-500 text-sm mb-6">${errorMsg}</p>
            </c:when>
            <c:otherwise>
                <p class="text-gray-500 text-sm mb-6">결제가 취소되었거나 오류가 발생했습니다.</p>
            </c:otherwise>
        </c:choose>

        <p class="text-gray-400 text-xs mb-8">
            예약은 잠시 보류 상태로 유지됩니다.<br>
            다시 시도하거나 공간 목록으로 돌아가세요.
        </p>

        <div class="flex gap-3 justify-center">
            <button onclick="history.back()"
                    class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-6 py-3 rounded-xl transition">
                다시 시도
            </button>
            <a href="${pageContext.request.contextPath}/detail/list"
               class="bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold px-6 py-3 rounded-xl transition">
                공간 목록으로
            </a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

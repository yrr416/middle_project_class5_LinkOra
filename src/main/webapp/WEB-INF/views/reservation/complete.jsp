<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 완료</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

<div class="max-w-xl mx-auto px-4 py-20 text-center">
    <div class="bg-white rounded-2xl shadow p-10">
        <div class="text-5xl mb-4">✅</div>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">예약이 신청되었습니다</h1>
        <p class="text-gray-500 text-sm mb-8">담당자 확인 후 CONFIRMED 상태로 변경됩니다.</p>

        <c:if test="${not empty reservation}">
            <div class="text-left bg-gray-50 rounded-xl p-5 text-sm text-gray-700 mb-8 space-y-2">
                <p><span class="font-medium">시작 시간:</span> ${fn:substring(reservation.resStartTime, 0, 16)}</p>
                <p><span class="font-medium">종료 시간:</span> ${fn:substring(reservation.resEndTime, 0, 16)}</p>
                <c:if test="${reservation.resHeadcount > 0}">
                    <p><span class="font-medium">예약 인원:</span> ${reservation.resHeadcount}명</p>
                </c:if>
                <p><span class="font-medium">총 결제 예정 금액:</span>
                    <span class="text-indigo-600 font-bold">${reservation.resTotalPrice}원</span></p>
            </div>
        </c:if>

        <div class="flex gap-3 justify-center flex-wrap">
            <a href="${pageContext.request.contextPath}/detail/list"
               class="inline-block bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-8 py-3 rounded-xl transition">
                공간 목록으로
            </a>
            <a href="${pageContext.request.contextPath}/reservation/mylist"
               class="inline-block bg-white border border-indigo-600 text-indigo-600 hover:bg-indigo-50 font-semibold px-8 py-3 rounded-xl transition">
                내 예약 확인
            </a>
        </div>
    </div>
</div>

</body>
</html>

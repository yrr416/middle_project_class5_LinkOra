<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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

<%-- 토스페이먼츠 JS SDK --%>
<script src="https://js.tosspayments.com/v1/payment"></script>

<div class="max-w-xl mx-auto px-4 py-20 text-center">
    <div class="bg-white rounded-2xl shadow p-10">
        <div class="text-5xl mb-4">💳</div>
        <h1 class="text-2xl font-bold text-gray-800 mb-2">결제하기</h1>
        <p class="text-gray-500 text-sm mb-8">아래 버튼을 눌러 결제를 진행해주세요.</p>

        <div class="text-left bg-gray-50 rounded-xl p-5 text-sm text-gray-700 mb-8 space-y-2">
            <p><span class="font-medium">공간명:</span> ${spaceName}</p>
            <p><span class="font-medium">이용 시작:</span> ${fn:substring(startTime, 0, 16)}</p>
            <p><span class="font-medium">이용 종료:</span> ${fn:substring(endTime, 0, 16)}</p>
            <p><span class="font-medium">결제 금액:</span>
                <span class="text-indigo-600 font-bold">${amount}원</span>
            </p>
            <p><span class="font-medium">주문번호:</span> ${orderId}</p>
        </div>

        <button id="payBtn"
                class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-8 py-3 rounded-xl transition">
            결제하기
        </button>
    </div>
</div>

<script>
    const tossPayments = TossPayments("${clientKey}");

    document.getElementById("payBtn").addEventListener("click", function () {
        tossPayments.requestPayment("카드", {
            amount:       ${amount},
            orderId:      "${orderId}",
            orderName:    "${spaceName}",
            customerName: "${sessionScope.loginUser.name}",
            successUrl:   location.origin + "${pageContext.request.contextPath}/payment/success",
            failUrl:      location.origin + "${pageContext.request.contextPath}/payment/fail",
        });
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

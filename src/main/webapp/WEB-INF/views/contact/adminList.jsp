<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장기 계약 문의 관리 — LinkOra</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="bg-gray-50">

<nav class="bg-white border-b border-gray-200 sticky top-0 z-30">
  <div class="max-w-5xl mx-auto px-4 h-14 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/detail/list"
       class="text-lg font-bold text-indigo-600">LinkOra</a>
    <span class="text-sm text-gray-500">관리자 — 장기 계약 문의</span>
  </div>
</nav>

<div class="max-w-5xl mx-auto px-4 py-8">
  <h1 class="text-xl font-bold text-gray-800 mb-6">장기 계약 문의 목록</h1>

  <c:choose>
    <c:when test="${not empty contactList}">
      <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 text-gray-500 text-xs">
            <tr>
              <th class="px-4 py-3 text-left">번호</th>
              <th class="px-4 py-3 text-left">지점</th>
              <th class="px-4 py-3 text-left">문의자</th>
              <th class="px-4 py-3 text-left">시작일</th>
              <th class="px-4 py-3 text-left">기간</th>
              <th class="px-4 py-3 text-left">인원</th>
              <th class="px-4 py-3 text-left">내용</th>
              <th class="px-4 py-3 text-left">상태</th>
              <th class="px-4 py-3 text-left">접수일</th>
              <th class="px-4 py-3 text-left">처리</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <c:forEach var="ct" items="${contactList}">
              <tr class="hover:bg-gray-50">
                <td class="px-4 py-3 text-gray-400">${ct.cntIdx}</td>
                <td class="px-4 py-3 font-medium text-gray-700">${ct.branchName}</td>
                <td class="px-4 py-3 text-gray-600">${ct.userName}</td>
                <td class="px-4 py-3 text-gray-600">${ct.cntStartDate}</td>
                <td class="px-4 py-3 text-gray-600">${ct.cntDuration}</td>
                <td class="px-4 py-3 text-gray-600">${ct.cntHeadcount}명</td>
                <td class="px-4 py-3 text-gray-600 max-w-xs truncate">${ct.cntContent}</td>
                <td class="px-4 py-3">
                  <%-- 상태에 따라 배지 색상 변경 --%>
                  <c:choose>
                    <c:when test="${ct.cntStatus eq 'PENDING'}">
                      <span class="text-xs font-semibold text-yellow-600 bg-yellow-50 px-2 py-0.5 rounded-full">접수</span>
                    </c:when>
                    <c:when test="${ct.cntStatus eq 'REPLIED'}">
                      <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-0.5 rounded-full">답변완료</span>
                    </c:when>
                    <c:otherwise>
                      <span class="text-xs font-semibold text-gray-400 bg-gray-100 px-2 py-0.5 rounded-full">종료</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="px-4 py-3 text-gray-400">
                  <fmt:formatDate value="${ct.cntCreatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                </td>
                <td class="px-4 py-3">
                  <select class="status-select text-xs border border-gray-200 rounded-lg px-2 py-1"
                          data-cnt-idx="${ct.cntIdx}"
                          onchange="changeStatus(this)">
                    <option value="PENDING"  ${ct.cntStatus eq 'PENDING'  ? 'selected' : ''}>접수</option>
                    <option value="REPLIED"  ${ct.cntStatus eq 'REPLIED'  ? 'selected' : ''}>답변완료</option>
                    <option value="CLOSED"   ${ct.cntStatus eq 'CLOSED'   ? 'selected' : ''}>종료</option>
                  </select>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:when>
    <c:otherwise>
      <p class="text-center text-gray-400 py-16">접수된 문의가 없습니다.</p>
    </c:otherwise>
  </c:choose>
</div>

<script>
  const CTX = '${pageContext.request.contextPath}';

  /* 상태 드롭다운 변경 시 AJAX로 처리 */
  function changeStatus(sel) {
    const cntIdx = sel.dataset.cntIdx;
    const status = sel.value;

    $.post(CTX + '/contact/admin/status', { cntIdx: cntIdx, status: status })
      .done(function(res) {
        if (!res.success) {
          alert(res.message || '상태 변경에 실패했습니다.');
        }
      })
      .fail(function() {
        alert('서버 오류가 발생했습니다.');
      });
  }
</script>
</body>
</html>

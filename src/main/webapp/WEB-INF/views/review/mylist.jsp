<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<script src="https://cdn.tailwindcss.com"></script>

<div class="max-w-4xl mx-auto px-4 py-10">
    <h1 class="text-2xl font-bold text-gray-800 mb-2">내 리뷰 관리</h1>
    <p class="text-sm text-gray-400 mb-8">${sessionScope.loginUser.name}님이 작성한 리뷰 목록입니다.</p>

    <c:choose>
        <c:when test="${not empty reviewList}">
            <div class="space-y-4" id="reviewContainer">
                <c:forEach var="r" items="${reviewList}">
                    <div class="bg-white rounded-2xl shadow-md border border-gray-200 p-5" id="review-${r.revIdx}">
                        <div class="flex items-start justify-between flex-wrap gap-3">

                            <%-- 왼쪽: 리뷰 정보 --%>
                            <div class="flex-1">
                                <%-- 지점명 / 공간명 --%>
                                <div class="text-xs text-gray-400 mb-1">
                                    <a href="${ctx}/detail/detail?brnIdx=${r.brnIdx}"
                                       class="text-teal-600 font-semibold hover:underline">${r.branchName}</a>
                                    &nbsp;·&nbsp;${r.spaceName}
                                </div>

                                <%-- 별점 --%>
                                <div class="flex gap-0.5 mb-2">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="${i <= r.revRating ? 'text-yellow-400' : 'text-gray-300'} text-lg">★</span>
                                    </c:forEach>
                                    <span class="text-sm text-gray-500 ml-1">${r.revRating}점</span>
                                </div>

                                <%-- 내용 --%>
                                <p class="text-sm text-gray-700 leading-relaxed">${r.revContent}</p>

                                <%-- 이미지 --%>
                                <c:if test="${not empty r.revImg}">
                                    <img src="${ctx}/static/upload/review/${r.revImg}"
                                         alt="리뷰 이미지"
                                         class="mt-3 w-40 h-28 object-cover rounded-xl border border-gray-200">
                                </c:if>

                                <%-- 작성일 --%>
                                <p class="text-xs text-gray-400 mt-2">
                                    <fmt:formatDate value="${r.revCreatedAt}" pattern="yyyy.MM.dd"/>
                                </p>
                            </div>

                            <%-- 오른쪽: 버튼 --%>
                            <div class="flex flex-col gap-2 min-w-[80px]">
                                <button onclick="openEditModal(${r.revIdx}, '${r.revContent.replace("'", "\\'")}', ${r.revRating}, '${r.revImg != null ? r.revImg : ''}')"
                                        class="text-sm px-4 py-2 rounded-xl border border-teal-500 text-teal-600 hover:bg-teal-50 transition">
                                    수정
                                </button>
                                <button onclick="deleteReview(${r.revIdx})"
                                        class="text-sm px-4 py-2 rounded-xl border border-red-300 text-red-500 hover:bg-red-50 transition">
                                    삭제
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-20 text-gray-400">
                <p class="text-4xl mb-4">✏️</p>
                <p class="text-sm">작성한 리뷰가 없습니다.</p>
                <a href="${ctx}/detail/list" class="mt-4 inline-block text-sm text-teal-600 hover:underline">오피스 둘러보기</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- 수정 모달 --%>
<div id="editModal" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-6">
        <h2 class="text-lg font-bold text-gray-800 mb-4">리뷰 수정</h2>

        <%-- 별점 선택 --%>
        <div class="flex gap-1 mb-3" id="editStars">
            <c:forEach begin="1" end="5" var="i">
                <span class="text-2xl cursor-pointer text-gray-300 star" data-val="${i}"
                      onclick="setRating(${i})">★</span>
            </c:forEach>
        </div>

        <%-- 내용 입력 --%>
        <textarea id="editContent" rows="4"
                  class="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-teal-400"
                  placeholder="리뷰 내용을 입력하세요"></textarea>

        <%-- 이미지 --%>
        <div class="mt-3">
            <div id="editImgPreviewWrap" class="mb-2 hidden">
                <img id="editImgPreview" src="" alt="현재 이미지" class="w-32 h-24 object-cover rounded-xl border border-gray-200">
                <button type="button" onclick="removeEditImg()"
                        class="text-xs text-red-500 mt-1 hover:underline block">이미지 삭제</button>
            </div>
            <input type="file" id="editImgFile" accept="image/*" class="text-xs text-gray-500">
        </div>

        <input type="hidden" id="editRevIdx">
        <input type="hidden" id="editRating" value="0">
        <input type="hidden" id="editRemoveImg" value="false">

        <div class="flex justify-end gap-2 mt-5">
            <button onclick="closeEditModal()"
                    class="px-4 py-2 text-sm rounded-xl border border-gray-300 text-gray-600 hover:bg-gray-50">취소</button>
            <button onclick="submitEdit()"
                    class="px-4 py-2 text-sm rounded-xl bg-teal-600 text-white hover:bg-teal-700">저장</button>
        </div>
    </div>
</div>

<script>
    const CTX        = '${ctx}';
    const csrfToken  = document.querySelector('meta[name="_csrf"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

    /* ── 수정 모달 열기 ── */
    function openEditModal(revIdx, content, rating, img) {
        document.getElementById('editRevIdx').value   = revIdx;
        document.getElementById('editContent').value  = content;
        document.getElementById('editRating').value   = rating;
        document.getElementById('editRemoveImg').value = 'false';
        setRating(rating);

        // 기존 이미지 표시
        const previewWrap = document.getElementById('editImgPreviewWrap');
        if (img) {
            document.getElementById('editImgPreview').src = CTX + '/static/upload/review/' + img;
            previewWrap.classList.remove('hidden');
        } else {
            previewWrap.classList.add('hidden');
        }

        document.getElementById('editImgFile').value = '';
        document.getElementById('editModal').classList.remove('hidden');
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }

    /* ── 별점 선택 ── */
    function setRating(val) {
        document.getElementById('editRating').value = val;
        document.querySelectorAll('#editStars .star').forEach(s => {
            s.classList.toggle('text-yellow-400', parseInt(s.dataset.val) <= val);
            s.classList.toggle('text-gray-300',   parseInt(s.dataset.val) >  val);
        });
    }

    /* ── 이미지 삭제 ── */
    function removeEditImg() {
        document.getElementById('editRemoveImg').value = 'true';
        document.getElementById('editImgPreviewWrap').classList.add('hidden');
    }

    /* ── 수정 제출 ── */
    function submitEdit() {
        const revIdx    = document.getElementById('editRevIdx').value;
        const content   = document.getElementById('editContent').value.trim();
        const rating    = document.getElementById('editRating').value;
        const removeImg = document.getElementById('editRemoveImg').value;
        const imgFile   = document.getElementById('editImgFile');

        if (!content) { alert('내용을 입력해주세요.'); return; }
        if (rating == 0) { alert('별점을 선택해주세요.'); return; }

        const formData = new FormData();
        formData.append('revIdx',    revIdx);
        formData.append('content',   content);
        formData.append('rating',    rating);
        formData.append('removeImg', removeImg);
        if (imgFile.files.length > 0) formData.append('imgFile', imgFile.files[0]);

        fetch(CTX + '/review/update', { method: 'POST', headers: { [csrfHeader]: csrfToken }, body: formData })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    alert('수정되었습니다.');
                    location.reload();
                } else {
                    alert(data.message || '수정에 실패했습니다.');
                }
            });
    }

    /* ── 삭제 ── */
    function deleteReview(revIdx) {
        if (!confirm('리뷰를 삭제하시겠습니까?')) return;

        const formData = new FormData();
        formData.append('revIdx', revIdx);

        fetch(CTX + '/review/delete', { method: 'POST', headers: { [csrfHeader]: csrfToken }, body: formData })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('review-' + revIdx).remove();
                    // 리뷰가 하나도 없으면 페이지 새로고침으로 빈 화면 표시
                    if (!document.querySelector('#reviewContainer [id^="review-"]')) {
                        location.reload();
                    }
                } else {
                    alert(data.message || '삭제에 실패했습니다.');
                }
            });
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

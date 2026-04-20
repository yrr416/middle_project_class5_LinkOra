<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 매물 관리 - 파트너 센터</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f6f9; }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position: sticky; top: 0; }
        .sidebar .nav-link { color: rgba(255,255,255,.75); padding: 10px 20px; border-radius: 6px; margin: 2px 8px; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right: 8px; }
        .sidebar-brand { color: #fff; font-size: 1.2rem; font-weight: 700; padding: 20px; border-bottom: 1px solid rgba(255,255,255,.1); }
        .main-content { padding: 24px; }
        .page-header { background: #fff; border-radius: 10px; padding: 20px 24px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .branch-card { background: #fff; border-radius: 12px; box-shadow: 0 1px 6px rgba(0,0,0,.08); margin-bottom: 20px; overflow: hidden; border: 1px solid #e9ecef; }
        .branch-card-header { padding: 20px 24px; display: flex; align-items: center; gap: 20px; }
        .branch-thumb { width: 100px; height: 80px; object-fit: cover; border-radius: 8px; background: #dee2e6; flex-shrink: 0; }
        .branch-thumb-empty { width: 100px; height: 80px; border-radius: 8px; background: #e9ecef; display: flex; align-items: center; justify-content: center; flex-shrink: 0; color: #adb5bd; font-size: 1.8rem; }
        .branch-info { flex: 1; min-width: 0; }
        .branch-name { font-size: 1.1rem; font-weight: 700; color: #212529; margin-bottom: 4px; }
        .branch-addr { font-size: .85rem; color: #6c757d; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .badge-pending  { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d1fae5; color: #065f46; }
        .badge-inactive { background: #e9ecef; color: #495057; }
        .space-row { display: flex; align-items: center; padding: 12px 24px; border-top: 1px solid #f1f3f5; gap: 12px; font-size: .875rem; }
        .space-row:last-child { border-bottom: none; }
        .space-thumb { width: 48px; height: 38px; object-fit: cover; border-radius: 6px; background: #dee2e6; flex-shrink: 0; }
        .space-thumb-empty { width: 48px; height: 38px; border-radius: 6px; background: #e9ecef; display: flex; align-items: center; justify-content: center; flex-shrink: 0; color: #adb5bd; font-size: 1rem; }
        .space-name { font-weight: 600; min-width: 120px; }
        .meta-chip { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 20px; padding: 2px 10px; font-size: .78rem; color: #495057; white-space: nowrap; }
        .space-actions { margin-left: auto; display: flex; gap: 6px; flex-shrink: 0; }
        .branch-footer { background: #f8f9fa; padding: 10px 24px; display: flex; gap: 8px; border-top: 1px solid #e9ecef; }
        .toggle-btn { font-size: .8rem; }
        .empty-state { text-align: center; padding: 60px 20px; color: #6c757d; }
        .empty-state i { font-size: 3rem; margin-bottom: 16px; display: block; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- 사이드바 -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-shop me-2"></i>파트너 센터</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">파트너 메뉴</span>
            <a class="nav-link" href="${ctx}/partner/reservation/list">
                <i class="bi bi-calendar2-check"></i>예약 관리
            </a>
            <a class="nav-link" href="${ctx}/partner/register/step1">
                <i class="bi bi-building-add"></i>매물 등록
            </a>
            <a class="nav-link active" href="${ctx}/partner/manage">
                <i class="bi bi-building-gear"></i>내 매물 관리
            </a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/partner/mypage">
                <i class="bi bi-person-circle"></i>마이페이지
            </a>
            <a class="nav-link" href="${ctx}/" target="_blank">
                <i class="bi bi-house"></i>홈페이지 이동
            </a>
            <a class="nav-link text-danger" href="${ctx}/logoutNow">
                <i class="bi bi-box-arrow-right"></i>로그아웃
            </a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-building-gear me-2 text-primary"></i>내 매물 관리</h5>
                <small class="text-muted">등록한 오피스와 공간을 관리합니다.</small>
            </div>
            <a href="${ctx}/partner/register/step1" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-circle me-1"></i>새 오피스 등록
            </a>
        </div>

        <!-- 알림 메시지 -->
        <div id="alertBox" class="alert alert-dismissible fade show d-none mb-3" role="alert">
            <span id="alertMsg"></span>
            <button type="button" class="btn-close" onclick="hideAlert()"></button>
        </div>

        <!-- 매물 없을 때 -->
        <c:if test="${empty branches}">
            <div class="branch-card">
                <div class="empty-state">
                    <i class="bi bi-building"></i>
                    <h6 class="fw-bold">등록된 매물이 없습니다</h6>
                    <p class="small mb-3">첫 번째 오피스를 등록해 보세요.</p>
                    <a href="${ctx}/partner/register/step1" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus-circle me-1"></i>오피스 등록 시작
                    </a>
                </div>
            </div>
        </c:if>

        <!-- 지점 카드 목록 -->
        <c:forEach var="b" items="${branches}">
            <div class="branch-card" id="branch-${b.brnIdx}">

                <!-- 카드 헤더 -->
                <div class="branch-card-header">
                    <!-- 대표 이미지 -->
                    <c:choose>
                        <c:when test="${not empty b.brnUrl}">
                            <img src="${ctx}${b.brnUrl}" class="branch-thumb" alt="대표사진"
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                            <div class="branch-thumb-empty" style="display:none"><i class="bi bi-image"></i></div>
                        </c:when>
                        <c:otherwise>
                            <div class="branch-thumb-empty"><i class="bi bi-image"></i></div>
                        </c:otherwise>
                    </c:choose>

                    <!-- 지점 정보 -->
                    <div class="branch-info">
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="branch-name">${b.brnName}</span>
                            <c:choose>
                                <c:when test="${b.brnActive == 0}">
                                    <span class="badge badge-pending">심사중</span>
                                </c:when>
                                <c:when test="${b.brnActive == 1}">
                                    <span class="badge badge-approved">승인완료</span>
                                </c:when>
                                <c:when test="${b.brnActive == 2}">
                                    <span class="badge badge-inactive">비활성</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="branch-addr"><i class="bi bi-geo-alt me-1"></i>${b.brnAddress}</div>
                        <div class="mt-1 small text-muted">
                            <span class="me-3"><i class="bi bi-door-open me-1"></i>공간 ${b.spaceCount}개</span>
                            <c:if test="${not empty b.brnHours}">
                                <span><i class="bi bi-clock me-1"></i>${b.brnHours}</span>
                            </c:if>
                        </div>
                    </div>

                    <!-- 우측 버튼 -->
                    <div class="d-flex flex-column gap-2 flex-shrink-0">
                        <c:if test="${b.brnActive == 1 or b.brnActive == 2}">
                            <button class="btn btn-outline-secondary btn-sm toggle-btn"
                                    onclick="toggleBranch(${b.brnIdx}, this)">
                                <i class="bi bi-${b.brnActive == 1 ? 'pause-circle' : 'play-circle'} me-1"></i>
                                <span>${b.brnActive == 1 ? '비활성화' : '활성화'}</span>
                            </button>
                        </c:if>
                        <button class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="collapse"
                                data-bs-target="#spaces-${b.brnIdx}">
                            <i class="bi bi-grid me-1"></i>공간 목록
                        </button>
                    </div>
                </div>

                <!-- 공간 목록 (collapse) -->
                <div class="collapse" id="spaces-${b.brnIdx}">
                    <div style="background:#f8f9fa; padding:10px 24px 6px; border-top:1px solid #e9ecef;">
                        <span class="small fw-semibold text-muted">공간 목록</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty b.spaces}">
                            <div class="text-center py-4 text-muted small border-top">
                                <i class="bi bi-door-open me-1"></i>등록된 공간이 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${b.spaces}">
                                <div class="space-row" id="space-${s.spcIdx}">
                                    <!-- 공간 이미지 -->
                                    <c:choose>
                                        <c:when test="${not empty s.spcImg}">
                                            <img src="${ctx}${s.spcImg}" class="space-thumb" alt="공간이미지"
                                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                            <div class="space-thumb-empty" style="display:none"><i class="bi bi-image"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="space-thumb-empty"><i class="bi bi-image"></i></div>
                                        </c:otherwise>
                                    </c:choose>

                                    <span class="space-name">${s.spcName}</span>

                                    <span class="meta-chip">
                                        <c:choose>
                                            <c:when test="${s.spcType == 'INDIVIDUAL'}">개인실</c:when>
                                            <c:when test="${s.spcType == 'GROUP'}">단체실</c:when>
                                            <c:otherwise>${s.spcType}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="meta-chip"><i class="bi bi-people me-1"></i>${s.spcMaxCapacity}명</span>
                                    <span class="meta-chip"><i class="bi bi-currency-won"></i><fmt:formatNumber value="${s.spcPrice}" pattern="#,###"/>/h</span>

                                    <!-- 상태 배지 -->
                                    <c:choose>
                                        <c:when test="${s.spcActive == 0}">
                                            <span class="badge badge-pending">심사중</span>
                                        </c:when>
                                        <c:when test="${s.spcActive == 1}">
                                            <span class="badge badge-approved">활성</span>
                                        </c:when>
                                        <c:when test="${s.spcActive == 2}">
                                            <span class="badge badge-inactive">비활성</span>
                                        </c:when>
                                    </c:choose>

                                    <!-- 토글 버튼 (심사중은 제외) -->
                                    <div class="space-actions">
                                        <c:if test="${s.spcActive == 1 or s.spcActive == 2}">
                                            <button class="btn btn-outline-secondary btn-sm py-0 px-2 toggle-btn"
                                                    onclick="toggleSpace(${s.spcIdx}, this)">
                                                <i class="bi bi-${s.spcActive == 1 ? 'pause' : 'play'} me-1"></i>
                                                <span>${s.spcActive == 1 ? '비활성화' : '활성화'}</span>
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <!-- 공간 추가 버튼 영역 -->
                    <div class="branch-footer">
                        <a href="${ctx}/partner/register/initForBranch?brnIdx=${b.brnIdx}" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-plus me-1"></i>공간 추가
                        </a>
                        <a href="${ctx}/partner/register/step4" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-images me-1"></i>사진 관리
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>

    </div><!-- /main-content -->
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const ctx = '${ctx}';

function showAlert(msg, type) {
    const box = document.getElementById('alertBox');
    box.className = 'alert alert-' + type + ' alert-dismissible fade show mb-3';
    document.getElementById('alertMsg').textContent = msg;
    setTimeout(() => box.classList.add('d-none'), 4000);
}
function hideAlert() {
    document.getElementById('alertBox').classList.add('d-none');
}

function toggleBranch(brnIdx, btn) {
    fetch(ctx + '/partner/manage/toggleBranch', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'brnIdx=' + brnIdx
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            showAlert(data.message, 'success');
            const icon = btn.querySelector('i');
            const label = btn.querySelector('span');
            const wasActive = icon.classList.contains('bi-pause-circle'); // true=비활성화 클릭

            // 지점 버튼 갱신
            icon.className = 'bi me-1 ' + (wasActive ? 'bi-play-circle' : 'bi-pause-circle');
            label.textContent = wasActive ? '활성화' : '비활성화';

            // 지점 상태 배지 갱신
            const card = document.getElementById('branch-' + brnIdx);
            const branchBadge = card.querySelector('.branch-name').nextElementSibling;
            if (wasActive) {
                branchBadge.className = 'badge badge-inactive'; branchBadge.textContent = '비활성';
            } else {
                branchBadge.className = 'badge badge-approved'; branchBadge.textContent = '승인완료';
            }

            // 소속 공간 배지·버튼 전체 갱신 (심사중 제외)
            card.querySelectorAll('[id^="space-"]').forEach(function(row) {
                const spaceBadge = row.querySelector('.badge');
                if (!spaceBadge || spaceBadge.textContent.trim() === '심사중') return;

                const spaceToggleBtn = row.querySelector('.space-actions button');

                if (wasActive) {
                    // 비활성화
                    spaceBadge.className = 'badge badge-inactive'; spaceBadge.textContent = '비활성';
                    if (spaceToggleBtn) {
                        const si = spaceToggleBtn.querySelector('i');
                        const sl = spaceToggleBtn.querySelector('span');
                        si.className = 'bi me-1 bi-play';
                        sl.textContent = '활성화';
                    }
                } else {
                    // 활성화
                    spaceBadge.className = 'badge badge-approved'; spaceBadge.textContent = '활성';
                    if (spaceToggleBtn) {
                        const si = spaceToggleBtn.querySelector('i');
                        const sl = spaceToggleBtn.querySelector('span');
                        si.className = 'bi me-1 bi-pause';
                        sl.textContent = '비활성화';
                    }
                }
            });
        } else {
            showAlert(data.message, 'warning');
        }
    })
    .catch(() => showAlert('요청 중 오류가 발생했습니다.', 'danger'));
}

function toggleSpace(spcIdx, btn) {
    fetch(ctx + '/partner/manage/toggleSpace', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'spcIdx=' + spcIdx
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            showAlert(data.message, 'success');
            const icon = btn.querySelector('i');
            const label = btn.querySelector('span');
            const isPause = icon.classList.contains('bi-pause');
            icon.className = 'bi me-1 ' + (isPause ? 'bi-play' : 'bi-pause');
            label.textContent = isPause ? '활성화' : '비활성화';

            // 상태 배지 갱신
            const row = document.getElementById('space-' + spcIdx);
            const badge = row.querySelector('.badge');
            if (isPause) {
                badge.className = 'badge badge-inactive'; badge.textContent = '비활성';
            } else {
                badge.className = 'badge badge-approved'; badge.textContent = '활성';
            }
        } else {
            showAlert(data.message, 'warning');
        }
    })
    .catch(() => showAlert('요청 중 오류가 발생했습니다.', 'danger'));
}
</script>
</body>
</html>

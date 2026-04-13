<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        body { background-color:#f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position:sticky; top:0; }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; transition:.2s; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:24px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .summary-card { background:#fff; border-radius:12px; padding:20px 24px; box-shadow:0 1px 4px rgba(0,0,0,.06); border-left:4px solid transparent; transition:.2s; }
        .summary-card:hover { transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,.1); }
        .summary-card .icon-wrap { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:1.4rem; }
        .summary-card .big-num { font-size:1.8rem; font-weight:700; line-height:1.2; }
        .summary-card .sub-text { font-size:.8rem; color:#6c757d; margin-top:2px; }
        .card-blue{border-left-color:#0d6efd;} .card-green{border-left-color:#198754;}
        .card-orange{border-left-color:#fd7e14;} .card-purple{border-left-color:#6f42c1;}
        .icon-blue{background:#e8f0fe;color:#0d6efd;} .icon-green{background:#d1fae5;color:#198754;}
        .icon-orange{background:#fff3cd;color:#fd7e14;} .icon-purple{background:#e8daff;color:#6f42c1;}
        .chart-card { background:#fff; border-radius:12px; padding:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .chart-card .card-title { font-size:.95rem; font-weight:600; margin-bottom:16px; color:#212529; }
        .heatmap-grid { display:grid; grid-template-columns:repeat(7,1fr); gap:4px; }
        .heatmap-day-label { text-align:center; font-size:.75rem; font-weight:600; color:#6c757d; padding:4px 0; }
        .heatmap-cell { aspect-ratio:1; border-radius:4px; cursor:default; }
        .heat-0{background:#e9ecef;} .heat-1{background:#bdd7f5;} .heat-2{background:#84b9ee;}
        .heat-3{background:#4b9be3;} .heat-4{background:#1a7fdb;} .heat-5{background:#0d5fad;}
        .list-card { background:#fff; border-radius:12px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; }
        .list-card .list-header { padding:16px 20px; border-bottom:1px solid #f0f0f0; font-weight:600; font-size:.95rem; }
        .list-item { padding:12px 20px; border-bottom:1px solid #f8f9fa; display:flex; align-items:center; gap:12px; }
        .list-item:last-child { border-bottom:none; }
        .list-item:hover { background:#f8faff; }
        .badge-reserve{background:#dbeafe;color:#1d4ed8;} .badge-using{background:#d1fae5;color:#065f46;}
        .badge-done{background:#e5e7eb;color:#374151;} .badge-cancel{background:#fee2e2;color:#991b1b;}
        .alert-item { display:flex; align-items:center; justify-content:space-between; padding:14px 20px; border-bottom:1px solid #f0f0f0; }
        .alert-item:last-child { border-bottom:none; }
        .user-avatar { width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg,#667eea,#764ba2); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:.85rem; flex-shrink:0; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- 사이드바 -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link active" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-speedometer2 me-2 text-primary"></i>대시보드</h5>
                <small class="text-muted">전체 현황을 한눈에 확인합니다.</small>
            </div>
            <div class="small text-muted" id="currentDateTime"></div>
        </div>

        <!-- 요약 카드 4개 -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-blue">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">오늘 예약 건수</div>
                            <div class="big-num text-primary">${summary.todayReserveCnt}<span class="fs-6 fw-normal ms-1">건</span></div>
                            <div class="mt-2" style="font-size:.8rem;">전일 대비&nbsp;
                                <c:choose>
                                    <c:when test="${reserveChangeRate > 0}"><span class="text-success fw-bold">▲ ${reserveChangeRate}%</span></c:when>
                                    <c:when test="${reserveChangeRate < 0}"><span class="text-danger fw-bold">▼ ${reserveChangeRate}%</span></c:when>
                                    <c:otherwise><span class="text-muted">— 동일</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="icon-wrap icon-blue"><i class="bi bi-calendar-check"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-green">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">전체 회원 수</div>
                            <div class="big-num text-success">${summary.totalUserCnt}<span class="fs-6 fw-normal ms-1">명</span></div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">이번달 신규&nbsp;<strong class="text-success">+${summary.newUserCnt}명</strong></div>
                        </div>
                        <div class="icon-wrap icon-green"><i class="bi bi-people"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-orange">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">이번달 누적 매출</div>
                            <div class="big-num text-warning">₩ <span id="monthlyRevenue">${summary.monthlyRevenue}</span></div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">공간 예약 매출 합계</div>
                        </div>
                        <div class="icon-wrap icon-orange"><i class="bi bi-cash-stack"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="summary-card card-purple">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <div class="sub-text mb-1">현재 이용 중인 공간</div>
                            <div class="big-num" style="color:#6f42c1">${summary.activeSpaceCnt}<span class="fs-6 fw-normal ms-1">개</span></div>
                            <div class="mt-2 text-muted" style="font-size:.8rem;">오늘 기준 이용중 상태</div>
                        </div>
                        <div class="icon-wrap icon-purple"><i class="bi bi-building-check"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 차트 행 -->
        <div class="row g-3 mb-4">
            <div class="col-lg-8">
                <div class="chart-card" style="height:320px;">
                    <div class="card-title"><i class="bi bi-bar-chart-line me-2 text-primary"></i>월별 매출 추이 <small class="text-muted fw-normal">(최근 6개월)</small></div>
                    <canvas id="monthlySalesChart" style="max-height:260px;"></canvas>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="chart-card" style="height:320px;">
                    <div class="card-title"><i class="bi bi-pie-chart me-2 text-success"></i>공간별 이용률 <small class="text-muted fw-normal">(최근 3개월)</small></div>
                    <div class="d-flex justify-content-center" style="height:250px;">
                        <canvas id="spaceUsageChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- 히트맵 -->
        <div class="row g-3 mb-4">
            <div class="col-12">
                <div class="chart-card">
                    <div class="card-title">
                        <i class="bi bi-grid-3x3 me-2 text-warning"></i>요일별 예약 히트맵 <small class="text-muted fw-normal">(이번달)</small>
                        <span class="float-end d-flex align-items-center gap-1" style="font-size:.75rem;">
                            <span>적음</span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#e9ecef;display:inline-block;"></span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#4b9be3;display:inline-block;"></span>
                            <span style="width:14px;height:14px;border-radius:3px;background:#0d5fad;display:inline-block;"></span>
                            <span>많음</span>
                        </span>
                    </div>
                    <div class="heatmap-grid mb-2">
                        <div class="heatmap-day-label text-danger">일</div>
                        <div class="heatmap-day-label">월</div><div class="heatmap-day-label">화</div>
                        <div class="heatmap-day-label">수</div><div class="heatmap-day-label">목</div>
                        <div class="heatmap-day-label">금</div>
                        <div class="heatmap-day-label text-primary">토</div>
                    </div>
                    <div id="heatmapGrid"></div>
                    <div class="text-muted small mt-2" id="heatmapCaption"></div>
                </div>
            </div>
        </div>

        <!-- 최근 현황 -->
        <div class="row g-3">
            <div class="col-lg-7">
                <div class="list-card">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2 text-primary"></i>최근 예약 현황</span>
                        <a href="${ctx}/admin/reservation/list" class="btn btn-outline-primary btn-sm py-0">전체 보기</a>
                    </div>
                    <c:if test="${empty recentReserves}">
                        <div class="text-center text-muted py-4"><i class="bi bi-inbox fs-4 d-block mb-1"></i>최근 예약 내역이 없습니다.</div>
                    </c:if>
                    <c:forEach var="r" items="${recentReserves}">
                        <div class="list-item">
                            <div class="text-muted small" style="width:36px;flex-shrink:0;">#${r.resIdx}</div>
                            <div class="flex-grow-1">
                                <div class="fw-semibold">${r.userName}</div>
                                <div class="text-muted small">${r.spcName}</div>
                            </div>
                            <div class="text-muted small">${r.resDate}</div>
                            <div class="fw-semibold small">₩ <span class="res-price">${r.resPrice}</span></div>
                            <div>
                                <c:choose>
                                    <c:when test="${r.resStatus=='USING'}"><span class="badge badge-using px-2 py-1 rounded-pill">이용중</span></c:when>
                                    <c:when test="${r.resStatus=='COMPLETED'}"><span class="badge badge-done px-2 py-1 rounded-pill">완료</span></c:when>
                                    <c:when test="${r.resStatus=='CANCELLED'}"><span class="badge badge-cancel px-2 py-1 rounded-pill">취소</span></c:when>
                                    <c:when test="${r.resStatus=='CONFIRMED'}"><span class="badge badge-reserve px-2 py-1 rounded-pill">확정</span></c:when>
                                    <c:otherwise><span class="badge badge-reserve px-2 py-1 rounded-pill">대기</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="list-card mb-3">
                    <div class="list-header"><i class="bi bi-bell-fill me-2 text-warning"></i>처리 대기 알림</div>
                    <div class="alert-item">
                        <div class="d-flex align-items-center gap-2"><i class="bi bi-chat-left-dots text-info fs-5"></i><span>미처리 문의</span></div>
                        <span class="badge bg-info text-white rounded-pill px-3">${summary.pendingInquiryCnt}건</span>
                    </div>
                    <div class="alert-item">
                        <div class="d-flex align-items-center gap-2"><i class="bi bi-flag text-danger fs-5"></i><span>대기 중인 신고</span></div>
                        <span class="badge bg-danger rounded-pill px-3">${summary.pendingReportCnt}건</span>
                    </div>
                </div>
                <div class="list-card">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person-plus me-2 text-success"></i>신규 가입 회원</span>
                        <a href="${ctx}/admin/customer/list" class="btn btn-outline-success btn-sm py-0">전체 보기</a>
                    </div>
                    <c:if test="${empty newUsers}">
                        <div class="text-center text-muted py-3">신규 회원이 없습니다.</div>
                    </c:if>
                    <c:forEach var="u" items="${newUsers}">
                        <div class="list-item">
                            <div class="user-avatar">${fn:substring(u.userName,0,1)}</div>
                            <div class="flex-grow-1">
                                <div class="fw-semibold">${u.userName}</div>
                                <div class="text-muted small">${u.userEmail}</div>
                            </div>
                            <div class="text-end">
                                <span class="badge bg-secondary">${u.userRole}</span>
                                <div class="text-muted" style="font-size:.75rem;">${u.userCreated}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

    </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const CTX = '${ctx}';

/* 현재 시간 표시 */
(function(){
    const el=document.getElementById('currentDateTime');
    const days=['일','월','화','수','목','금','토'];
    function fmt(){ const d=new Date(), pad=n=>String(n).padStart(2,'0');
        el.textContent=d.getFullYear()+'년 '+(d.getMonth()+1)+'월 '+d.getDate()+'일 ('+days[d.getDay()]+') '+pad(d.getHours())+':'+pad(d.getMinutes()); }
    fmt(); setInterval(fmt,60000);
})();

/* 금액 포맷 */
(function(){
    const el=document.getElementById('monthlyRevenue');
    if(el) el.textContent=parseInt(el.textContent.trim(),10).toLocaleString('ko-KR');
    document.querySelectorAll('.res-price').forEach(e=>{ e.textContent=parseInt(e.textContent.trim(),10).toLocaleString('ko-KR'); });
})();

/* 월별 매출 막대그래프 */
new Chart(document.getElementById('monthlySalesChart'),{
    type:'bar',
    data:{ labels:${monthLabelsJson}, datasets:[{ label:'매출 (₩)', data:${monthRevenuesJson},
        backgroundColor:'rgba(13,110,253,0.7)', borderColor:'rgba(13,110,253,1)', borderWidth:1, borderRadius:6 }] },
    options:{ responsive:true, maintainAspectRatio:false,
        plugins:{ legend:{display:false}, tooltip:{callbacks:{label:c=>'₩ '+c.parsed.y.toLocaleString('ko-KR')}} },
        scales:{ y:{ beginAtZero:true, ticks:{callback:v=>'₩ '+v.toLocaleString('ko-KR')} } } }
});

/* 공간별 이용률 도넛 */
(function(){
    const labels=${spaceLabelsJson}, counts=${spaceCountsJson};
    const pal=['#0d6efd','#198754','#fd7e14','#6f42c1','#0dcaf0','#ffc107','#d63384','#20c997'];
    new Chart(document.getElementById('spaceUsageChart'),{
        type:'doughnut',
        data:{ labels, datasets:[{ data:counts, backgroundColor:labels.map((_,i)=>pal[i%pal.length]), borderWidth:2, borderColor:'#fff' }] },
        options:{ responsive:true, plugins:{ legend:{position:'bottom',labels:{font:{size:11},padding:8}},
            tooltip:{callbacks:{label:c=>c.label+': '+c.parsed+'건'}} }, cutout:'60%' }
    });
})();

/* 요일별 히트맵 */
(function(){
    const raw=${heatmapJson};
    const maxCnt=raw.reduce((m,d)=>Math.max(m,Number(d.reservecnt||0)),0);
    const map={};
    raw.forEach(d=>{ map[d.weeknum+'-'+d.dayofweek]=Number(d.reservecnt||0); });
    const maxWeek=raw.reduce((m,d)=>Math.max(m,Number(d.weeknum||0)),0)||5;
    function heatLevel(cnt){ if(!cnt)return 0; const r=cnt/maxCnt; return r<=.2?1:r<=.4?2:r<=.6?3:r<=.8?4:5; }
    const dayNames=['','일','월','화','수','목','금','토'];
    const grid=document.getElementById('heatmapGrid');
    let html='';
    if(raw.length===0){ grid.innerHTML='<div class="text-center text-muted py-3">이번달 예약 데이터가 없습니다.</div>'; return; }
    for(let w=1;w<=maxWeek;w++){
        html+='<div class="heatmap-grid mb-1">';
        for(let d=1;d<=7;d++){
            const cnt=map[w+'-'+d]||0;
            html+='<div class="heatmap-cell heat-'+heatLevel(cnt)+'" title="'+w+'주차 '+dayNames[d]+'요일: '+cnt+'건"></div>';
        }
        html+='</div>';
    }
    grid.innerHTML=html;
    const total=raw.reduce((s,d)=>s+Number(d.reservecnt||0),0);
    const now=new Date();
    document.getElementById('heatmapCaption').textContent=now.getFullYear()+'년 '+(now.getMonth()+1)+'월 총 '+total+'건의 예약';
})();
</script>
</body>
</html>

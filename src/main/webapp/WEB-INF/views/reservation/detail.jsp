<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%-- 편의 변수 --%>
<c:set var="s" value="${rvo.resStatus}"/>
<c:set var="isPending"   value="${s == 'PENDING'}"/>
<c:set var="isConfirmed" value="${s == 'CONFIRMED'}"/>
<c:set var="isUsing"     value="${s == 'USING'}"/>
<c:set var="isCompleted" value="${s == 'COMPLETED'}"/>
<c:set var="isCancelled" value="${s == 'CANCELLED'}"/>
<c:set var="canAction"   value="${s == 'PENDING' or s == 'CONFIRMED' or s == 'USING'}"/>

<%-- 고객 등급 --%>
<c:choose>
    <c:when test="${rvo.userResCnt >= 20}"><c:set var="grade" value="VIP"/><c:set var="gradeCss" value="bg-warning text-dark"/></c:when>
    <c:when test="${rvo.userResCnt >= 10}"><c:set var="grade" value="Gold"/><c:set var="gradeCss" value="bg-warning text-dark"/></c:when>
    <c:when test="${rvo.userResCnt >=  5}"><c:set var="grade" value="Silver"/><c:set var="gradeCss" value="bg-secondary"/></c:when>
    <c:otherwise><c:set var="grade" value="Bronze"/><c:set var="gradeCss" value="bg-danger bg-opacity-75"/></c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 상세 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .info-card { background:#fff; border-radius:10px; padding:22px 24px; box-shadow:0 1px 4px rgba(0,0,0,.06); margin-bottom:18px; }
        .card-title { font-size:.9rem; font-weight:700; color:#374151; margin-bottom:14px; padding-bottom:8px; border-bottom:2px solid #e5e7eb; }
        .info-row { display:flex; margin-bottom:10px; font-size:.875rem; }
        .info-label { width:130px; min-width:130px; color:#6b7280; }
        .info-value { color:#111827; font-weight:500; }
        .badge-pending   { background:#fef9c3; color:#854d0e; }
        .badge-confirmed { background:#dbeafe; color:#1e40af; }
        .badge-using     { background:#d1fae5; color:#065f46; }
        .badge-completed { background:#f3f4f6; color:#374151; }
        .badge-cancelled { background:#fee2e2; color:#991b1b; }
        .star-filled { color:#f59e0b; }
        .star-empty  { color:#d1d5db; }
        .action-card { position:sticky; top:24px; }
        .res-number { font-size:1.1rem; font-weight:700; color:#1a3a5c; letter-spacing:.5px; }
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
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link active" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building"></i>오피스 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
            <span class="nav-link text-white-50 small px-3 pb-1">파트너 페이지</span>
            <a class="nav-link" href="${ctx}/partner/register/step1"><i class="bi bi-person-badge me-1"></i>파트너 등록</a>
            <a class="nav-link" href="${ctx}/partner/reservation/list"><i class="bi bi-calendar2-check me-1"></i>파트너 예약 관리</a>
            <hr class="border-secondary mx-3">
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold"><i class="bi bi-calendar-check me-2 text-primary"></i>예약 상세</h5>
                <small class="text-muted res-number">${rvo.resCode}</small>
            </div>
            <a href="${ctx}/admin/reservation/list?nowPage=${nowPage}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <%-- 액션 결과 알림 --%>
        <c:if test="${not empty alertMsg}">
            <div class="alert alert-${alertType eq 'success' ? 'success' : 'warning'} alert-dismissible fade show mb-3">
                <i class="bi bi-${alertType eq 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
                ${alertMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-3">

            <!-- ══════ 좌측 콘텐츠 ══════ -->
            <div class="col-lg-8">

                <!-- 1. 예약 기본 정보 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-info-circle me-2 text-primary"></i>예약 기본 정보</div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">예약 번호</span>
                                <span class="info-value text-primary fw-bold">${rvo.resCode}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">예약 상태</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${isPending}">  <span class="badge badge-pending   px-2 py-1 rounded-pill">대기중</span></c:when>
                                        <c:when test="${isConfirmed}"><span class="badge badge-confirmed px-2 py-1 rounded-pill">확정</span></c:when>
                                        <c:when test="${isUsing}">    <span class="badge badge-using     px-2 py-1 rounded-pill">이용중</span></c:when>
                                        <c:when test="${isCompleted}"><span class="badge badge-completed px-2 py-1 rounded-pill">완료</span></c:when>
                                        <c:when test="${isCancelled}"><span class="badge badge-cancelled px-2 py-1 rounded-pill">취소</span></c:when>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">예약 신청일시</span>
                                <span class="info-value">${rvo.resCreated}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">최종 수정일시</span>
                                <span class="info-value">${rvo.resUpdated}</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">이용 시작</span>
                                <span class="info-value">${rvo.resStartTime}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">이용 종료</span>
                                <span class="info-value">${rvo.resEndTime}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">총 이용 시간</span>
                                <span class="info-value" id="totalHours">계산 중...</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">예약 인원</span>
                                <span class="info-value">${rvo.resHeadcount}명</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. 예약자 정보 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-person me-2 text-success"></i>예약자 정보</div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">고객명</span>
                                <span class="info-value">
                                    ${rvo.userName}
                                    <span class="badge ${gradeCss} ms-1" style="font-size:.7rem;">${grade}</span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">이메일</span>
                                <span class="info-value">${rvo.userEmail}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">전화번호</span>
                                <span class="info-value">${rvo.userPhone}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">총 예약 건수</span>
                                <span class="info-value">${rvo.userResCnt}건</span>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <a href="${ctx}/admin/customer/detail?userIdx=${rvo.userIdx}"
                               class="btn btn-outline-success btn-sm">
                                <i class="bi bi-person-lines-fill me-1"></i>고객 상세 보기
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 3. 공간 정보 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-building me-2 text-info"></i>공간 정보</div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">지점(오피스)</span>
                                <span class="info-value">${empty rvo.brnName ? '정보 없음' : rvo.brnName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">공간명</span>
                                <span class="info-value">${rvo.spcName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">공간 타입</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${rvo.spcType == 'MEETING'}">회의실</c:when>
                                        <c:when test="${rvo.spcType == 'FOCUS'}">집중석</c:when>
                                        <c:when test="${rvo.spcType == 'LOUNGE'}">라운지</c:when>
                                        <c:otherwise>${rvo.spcType}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">시간당 가격</span>
                                <span class="info-value">
                                    ₩ <fmt:formatNumber value="${rvo.spcPrice}" type="number"/>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <a href="${ctx}/admin/space/list"
                               class="btn btn-outline-info btn-sm">
                                <i class="bi bi-building me-1"></i>오피스 관리 이동
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 4. 결제 정보 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-credit-card me-2 text-warning"></i>결제 정보</div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">기본 금액</span>
                                <span class="info-value">₩ <fmt:formatNumber value="${rvo.spcPrice}" type="number"/> × <span id="hoursForCalc">-</span>시간</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">최종 결제 금액</span>
                                <span class="info-value fw-bold text-danger fs-6">
                                    ₩ <fmt:formatNumber value="${rvo.resTotalPrice}" type="number"/>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <span class="info-label">결제 수단</span>
                                <span class="info-value text-muted">정보 없음</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">결제 상태</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${isCancelled}">
                                            <span class="badge bg-warning text-dark px-2 py-1">환불 대기</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success px-2 py-1">결제 완료</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 6. 취소 정보 (CANCELLED만) --%>
                <c:if test="${isCancelled}">
                    <div class="info-card border border-danger border-opacity-25">
                        <div class="card-title text-danger"><i class="bi bi-x-circle me-2"></i>취소 정보</div>
                        <div class="info-row">
                            <span class="info-label">취소 처리 일시</span>
                            <span class="info-value">${rvo.resUpdated}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">취소 사유</span>
                            <span class="info-value">${empty rvo.resContent ? '-' : rvo.resContent}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">환불 금액</span>
                            <span class="info-value">₩ <fmt:formatNumber value="${rvo.resTotalPrice}" type="number"/> (대상)</span>
                        </div>
                    </div>
                </c:if>

                <%-- 7. 리뷰 정보 (COMPLETED + 리뷰 존재할 때) --%>
                <c:if test="${isCompleted and rvo.revIdx > 0}">
                    <div class="info-card border border-warning border-opacity-25">
                        <div class="card-title text-warning"><i class="bi bi-star-fill me-2"></i>리뷰 정보</div>
                        <div class="info-row">
                            <span class="info-label">별점</span>
                            <span class="info-value">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="bi bi-star-fill ${i <= rvo.revRating ? 'star-filled' : 'star-empty'}"></i>
                                </c:forEach>
                                <span class="ms-1 text-muted small">(${rvo.revRating}/5)</span>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">리뷰 내용</span>
                            <span class="info-value">${rvo.revContent}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">작성 일시</span>
                            <span class="info-value">${rvo.revCreatedAt}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">블라인드 상태</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${rvo.revActive == '1' or rvo.revActive == 'Y'}">
                                        <span class="badge bg-danger px-2">블라인드 처리됨</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success px-2">정상 노출</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="mt-2">
                            <a href="${ctx}/admin/review/list" class="btn btn-outline-warning btn-sm">
                                <i class="bi bi-eye-slash me-1"></i>리뷰 관리 페이지에서 처리
                            </a>
                        </div>
                    </div>
                </c:if>

                <!-- 8. 같은 고객의 최근 예약 이력 -->
                <div class="info-card">
                    <div class="card-title"><i class="bi bi-clock-history me-2 text-secondary"></i>같은 고객의 최근 예약 이력</div>
                    <c:choose>
                        <c:when test="${empty recentList}">
                            <p class="text-muted small mb-0">다른 예약 이력이 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-sm table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>예약번호</th>
                                            <th>공간 / 지점</th>
                                            <th>이용 기간</th>
                                            <th>금액</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${recentList}">
                                            <tr style="cursor:pointer;"
                                                onclick="location.href='${ctx}/admin/reservation/view?resIdx=${r.resIdx}'">
                                                <td class="text-primary fw-semibold">${r.resCode}</td>
                                                <td>
                                                    <div class="fw-semibold small">${r.spcName}</div>
                                                    <div class="text-muted small">${r.brnName}</div>
                                                </td>
                                                <td class="small">
                                                    <div>${r.resStartTime}</div>
                                                    <div class="text-muted">~ ${r.resEndTime}</div>
                                                </td>
                                                <td class="small">₩ <fmt:formatNumber value="${r.resTotalPrice}" type="number"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.resStatus == 'PENDING'}">  <span class="badge badge-pending   rounded-pill small">대기</span></c:when>
                                                        <c:when test="${r.resStatus == 'CONFIRMED'}"><span class="badge badge-confirmed rounded-pill small">확정</span></c:when>
                                                        <c:when test="${r.resStatus == 'USING'}">    <span class="badge badge-using     rounded-pill small">이용중</span></c:when>
                                                        <c:when test="${r.resStatus == 'COMPLETED'}"><span class="badge badge-completed rounded-pill small">완료</span></c:when>
                                                        <c:when test="${r.resStatus == 'CANCELLED'}"><span class="badge badge-cancelled rounded-pill small">취소</span></c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div><!-- /col-lg-8 -->

            <!-- ══════ 우측: 관리자 액션 ══════ -->
            <div class="col-lg-4">
                <div class="info-card action-card">
                    <div class="card-title"><i class="bi bi-gear me-2 text-secondary"></i>관리자 액션</div>

                    <%-- 숨김 파라미터 (searchVO 유지용) --%>
                    <c:set var="searchParams"
                           value="&nowPage=${nowPage}&startDate=${searchVO.startDate}&endDate=${searchVO.endDate}&statusFilter=${searchVO.statusFilter}&spaceFilter=${searchVO.spaceFilter}&searchWord=${searchVO.searchWord}"/>

                    <%-- 예약 확정 (PENDING) --%>
                    <c:if test="${isPending}">
                        <form method="post" action="${ctx}/admin/reservation/confirm" class="mb-2">
                            <input type="hidden" name="resIdx"     value="${rvo.resIdx}">
                            <input type="hidden" name="nowPage"    value="${nowPage}">
                            <input type="hidden" name="fromDetail" value="true">
                            <input type="hidden" name="startDate"    value="${searchVO.startDate}">
                            <input type="hidden" name="endDate"      value="${searchVO.endDate}">
                            <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">
                            <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">
                            <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">
                            <button type="submit" class="btn btn-primary w-100"
                                    onclick="return confirm('이 예약을 확정하시겠습니까?')">
                                <i class="bi bi-check-circle me-2"></i>예약 확정
                            </button>
                        </form>
                    </c:if>

                    <%-- 이용 완료 (CONFIRMED / USING) --%>
                    <c:if test="${isConfirmed or isUsing}">
                        <form method="post" action="${ctx}/admin/reservation/complete" class="mb-2">
                            <input type="hidden" name="resIdx"     value="${rvo.resIdx}">
                            <input type="hidden" name="nowPage"    value="${nowPage}">
                            <input type="hidden" name="fromDetail" value="true">
                            <input type="hidden" name="startDate"    value="${searchVO.startDate}">
                            <input type="hidden" name="endDate"      value="${searchVO.endDate}">
                            <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">
                            <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">
                            <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">
                            <button type="submit" class="btn btn-success w-100"
                                    onclick="return confirm('이용 완료 처리하시겠습니까?')">
                                <i class="bi bi-flag-fill me-2"></i>이용 완료
                            </button>
                        </form>
                    </c:if>

                    <%-- 강제 취소 (COMPLETED 제외 전 상태) --%>
                    <c:if test="${canAction}">
                        <button type="button" class="btn btn-outline-danger w-100 mb-2"
                                data-bs-toggle="modal" data-bs-target="#cancelModal">
                            <i class="bi bi-x-circle me-2"></i>강제 취소
                        </button>
                    </c:if>

                    <%-- 환불 처리 (CANCELLED) --%>
                    <c:if test="${isCancelled}">
                        <form method="post" action="${ctx}/admin/reservation/cancel" class="mb-2">
                            <input type="hidden" name="resIdx"       value="${rvo.resIdx}">
                            <input type="hidden" name="cancelReason" value="${rvo.resContent}">
                            <input type="hidden" name="refundChecked" value="true">
                            <input type="hidden" name="nowPage"      value="${nowPage}">
                            <input type="hidden" name="fromDetail"   value="true">
                            <input type="hidden" name="startDate"    value="${searchVO.startDate}">
                            <input type="hidden" name="endDate"      value="${searchVO.endDate}">
                            <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">
                            <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">
                            <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">
                            <button type="submit" class="btn btn-warning w-100"
                                    onclick="return confirm('환불 처리를 완료로 기록하시겠습니까?')">
                                <i class="bi bi-arrow-counterclockwise me-2"></i>환불 완료 처리
                            </button>
                        </form>
                    </c:if>

                    <%-- 액션 없는 상태 --%>
                    <c:if test="${isCompleted}">
                        <div class="text-center text-muted small py-3">
                            <i class="bi bi-check-all fs-4 d-block mb-1 text-success"></i>
                            이용이 완료된 예약입니다.
                        </div>
                    </c:if>

                    <hr class="my-3">
                    <div class="small text-muted">
                        <div class="mb-1"><i class="bi bi-calendar3 me-1"></i>예약 생성: ${rvo.resCreated}</div>
                        <div><i class="bi bi-arrow-repeat me-1"></i>최종 변경: ${rvo.resUpdated}</div>
                    </div>
                </div>
            </div><!-- /col-lg-4 -->

        </div><!-- /row -->
    </div><!-- /main-content -->
</div>
</div>

<!-- 강제 취소 모달 -->
<div class="modal fade" id="cancelModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title text-danger"><i class="bi bi-exclamation-triangle me-2"></i>예약 강제 취소</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${ctx}/admin/reservation/cancel">
                <div class="modal-body">
                    <input type="hidden" name="resIdx"     value="${rvo.resIdx}">
                    <input type="hidden" name="nowPage"    value="${nowPage}">
                    <input type="hidden" name="fromDetail" value="true">
                    <input type="hidden" name="startDate"    value="${searchVO.startDate}">
                    <input type="hidden" name="endDate"      value="${searchVO.endDate}">
                    <input type="hidden" name="statusFilter" value="${searchVO.statusFilter}">
                    <input type="hidden" name="spaceFilter"  value="${searchVO.spaceFilter}">
                    <input type="hidden" name="searchWord"   value="${searchVO.searchWord}">

                    <div class="alert alert-warning py-2 small">
                        <i class="bi bi-info-circle me-1"></i>
                        취소 후에는 되돌릴 수 없습니다. 신중하게 처리해주세요.
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">취소 사유 <span class="text-danger">*</span></label>
                        <textarea name="cancelReason" class="form-control" rows="3"
                                  placeholder="취소 사유를 입력하세요" required></textarea>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="refundChecked"
                               value="true" id="refundCheck">
                        <label class="form-check-label" for="refundCheck">
                            환불 처리 완료 확인 (체크 시 환불 완료로 기록)
                        </label>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-x-circle me-1"></i>강제 취소 실행
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const startStr = '${rvo.resStartTime}';
        const endStr   = '${rvo.resEndTime}';
        if (!startStr || !endStr) return;

        const start = new Date(startStr.replace(' ', 'T'));
        const end   = new Date(endStr.replace(' ', 'T'));
        const diffMs = end - start;
        if (isNaN(diffMs) || diffMs <= 0) return;

        const hours   = Math.floor(diffMs / 3600000);
        const minutes = Math.floor((diffMs % 3600000) / 60000);

        const label = hours > 0
            ? (minutes > 0 ? hours + '시간 ' + minutes + '분' : hours + '시간')
            : minutes + '분';

        document.getElementById('totalHours').textContent = label;
        document.getElementById('hoursForCalc').textContent =
            (diffMs / 3600000).toFixed(1);
    })();
</script>
</body>
</html>

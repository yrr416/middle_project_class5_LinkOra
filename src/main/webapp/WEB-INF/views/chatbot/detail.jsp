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
    <title>챗봇 상담 상세 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }

        /* ── 사이드바 ── */
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position:sticky; top:0; }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }

        /* ── 레이아웃 ── */
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }

        /* ── 정보 카드 ── */
        .info-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); padding:22px 24px; margin-bottom:20px; }
        .info-label { font-size:.8rem; color:#6c757d; margin-bottom:2px; }
        .info-value { font-size:.95rem; font-weight:600; color:#212529; }

        /* ── 채팅 말풍선 ── */
        .chat-area { display:flex; flex-direction:column; gap:20px; }
        .chat-turn { display:flex; flex-direction:column; gap:8px; }

        /* 사용자 메시지 (우측) */
        .bubble-user-wrap { display:flex; justify-content:flex-end; align-items:flex-start; gap:10px; }
        .bubble-user {
            background:#0d6efd;
            color:#fff;
            border-radius:18px 18px 4px 18px;
            padding:12px 16px;
            max-width:70%;
            word-break:break-word;
            font-size:.92rem;
            line-height:1.5;
        }
        .bubble-user.unresolved {
            background:#fff;
            color:#212529;
            border:2px solid #dc3545;
        }

        /* AI 응답 (좌측) */
        .bubble-ai-wrap { display:flex; justify-content:flex-start; align-items:flex-start; gap:10px; }
        .bubble-ai-icon {
            width:36px; height:36px; border-radius:50%;
            background:linear-gradient(135deg,#667eea,#764ba2);
            color:#fff; display:flex; align-items:center; justify-content:center;
            font-size:1rem; flex-shrink:0;
        }
        .bubble-ai {
            background:#fff;
            color:#212529;
            border-radius:18px 18px 18px 4px;
            padding:12px 16px;
            max-width:70%;
            word-break:break-word;
            font-size:.92rem;
            line-height:1.5;
            box-shadow:0 1px 3px rgba(0,0,0,.08);
        }

        /* 사용자 아바타 */
        .user-avatar {
            width:36px; height:36px; border-radius:50%;
            background:linear-gradient(135deg,#0d6efd,#0a58ca);
            color:#fff; display:flex; align-items:center; justify-content:center;
            font-size:.85rem; font-weight:700; flex-shrink:0;
        }

        /* intent 배지 */
        .intent-badge { font-size:.72rem; background:#e8f0fe; color:#1a73e8; border-radius:20px; padding:2px 10px; display:inline-block; }
        .page-badge   { font-size:.72rem; background:#f0f4f8; color:#5a6a7e; border-radius:20px; padding:2px 10px; display:inline-block; }

        /* 미해결 아이콘 */
        .unresolved-icon { color:#dc3545; font-size:.85rem; }

        /* 채팅 섹션 카드 */
        .chat-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); padding:24px; }
        .chat-date-divider {
            text-align:center; position:relative; margin:16px 0;
            color:#6c757d; font-size:.78rem;
        }
        .chat-date-divider::before {
            content:''; position:absolute; top:50%; left:0; right:0;
            height:1px; background:#e9ecef; z-index:0;
        }
        .chat-date-divider span {
            background:#fff; padding:0 12px; position:relative; z-index:1;
        }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ── 사이드바 ────────────────────────────────────────────── -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/reservation/list"><i class="bi bi-calendar-check"></i>예약 관리</a>
            <a class="nav-link" href="${ctx}/admin/space/list"><i class="bi bi-building"></i>오피스 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link active" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <a class="nav-link" href="${ctx}/partner/register/step1"><i class="bi bi-person-badge me-1"></i>파트너 등록</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
        </nav>
    </div>

    <!-- ── 메인 콘텐츠 ────────────────────────────────────────── -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1 fw-bold">
                    <i class="bi bi-robot me-2 text-info"></i>
                    챗봇 상담 상세 <span class="text-muted fw-normal fs-6">#${sessionInfo.chatSession}</span>
                </h5>
                <small class="text-muted">세션별 대화 내역을 확인합니다.</small>
            </div>
            <!-- 목록으로 돌아가기 (필터 파라미터 유지) -->
            <a href="${ctx}/admin/chatbot/list?nowPage=${nowPage}&numPerPage=${numPerPage}&statusFilter=${statusFilter}&searchWord=${searchWord}&dateFrom=${dateFrom}&dateTo=${dateTo}"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <!-- ── 고객 정보 + 상담 메타 ────────────────────────────── -->
        <div class="row g-3 mb-3">
            <!-- 고객 정보 패널 -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="fw-bold mb-3"><i class="bi bi-person-circle me-2 text-primary"></i>고객 정보</div>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="info-label">이름</div>
                            <div class="info-value">${sessionInfo.userName}</div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">이메일</div>
                            <div class="info-value">${sessionInfo.userEmail}</div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">역할</div>
                            <div class="info-value">
                                <span class="badge bg-secondary">${sessionInfo.userRole}</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">가입일</div>
                            <div class="info-value">${sessionInfo.userCreated}</div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 상담 메타 패널 -->
            <div class="col-md-6">
                <div class="info-card h-100">
                    <div class="fw-bold mb-3"><i class="bi bi-bar-chart-line me-2 text-success"></i>상담 정보</div>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="info-label">상담 시작일</div>
                            <div class="info-value">${sessionInfo.startTime}</div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">상담 종료일</div>
                            <div class="info-value">${sessionInfo.endTime}</div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">총 대화수</div>
                            <div class="info-value">${sessionInfo.msgCount}회</div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">미해결 메시지</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${sessionInfo.unresolvedCount > 0}">
                                        <span class="text-danger fw-bold">
                                            <i class="bi bi-exclamation-circle me-1"></i>${sessionInfo.unresolvedCount}건
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-success">
                                            <i class="bi bi-check-circle me-1"></i>없음
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── 대화 내역 ────────────────────────────────────────── -->
        <div class="chat-card">
            <div class="fw-bold mb-4">
                <i class="bi bi-chat-dots me-2 text-info"></i>대화 내역
                <span class="badge bg-light text-muted fw-normal ms-1">${sessionInfo.msgCount}개</span>
            </div>

            <div class="chat-area">
                <c:choose>
                    <c:when test="${empty messageList}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                            대화 내역이 없습니다.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:set var="prevDate" value=""/>
                        <c:forEach var="msg" items="${messageList}">
                            <!-- 날짜 구분선 -->
                            <c:if test="${msg.chatTime != prevDate}">
                                <div class="chat-date-divider">
                                    <span>${msg.chatTime}</span>
                                </div>
                                <c:set var="prevDate" value="${msg.chatTime}"/>
                            </c:if>

                            <c:set var="isUnresolved" value="${empty msg.chatResponse}"/>

                            <div class="chat-turn">
                                <!-- 사용자 메시지 (우측) -->
                                <div class="bubble-user-wrap">
                                    <div>
                                        <!-- intent / page 뱃지 -->
                                        <div class="text-end mb-1">
                                            <c:if test="${not empty msg.chatIntent}">
                                                <span class="intent-badge me-1">
                                                    <i class="bi bi-lightbulb me-1"></i>${msg.chatIntent}
                                                </span>
                                            </c:if>
                                            <c:if test="${not empty msg.chatPage}">
                                                <span class="page-badge">
                                                    <i class="bi bi-link-45deg me-1"></i>${msg.chatPage}
                                                </span>
                                            </c:if>
                                        </div>
                                        <!-- 미해결 아이콘 표시 -->
                                        <c:if test="${isUnresolved}">
                                            <div class="text-end mb-1">
                                                <span class="unresolved-icon">
                                                    <i class="bi bi-exclamation-circle-fill"></i> 미해결
                                                </span>
                                            </div>
                                        </c:if>
                                        <div class="bubble-user ${isUnresolved ? 'unresolved' : ''}">
                                            ${msg.chatMessage}
                                        </div>
                                    </div>
                                    <div class="user-avatar">
                                        <c:choose>
                                            <c:when test="${not empty sessionInfo.userName}">
                                                ${fn:substring(sessionInfo.userName, 0, 1)}
                                            </c:when>
                                            <c:otherwise>U</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- AI 응답 (좌측) - 응답이 있는 경우만 표시 -->
                                <c:if test="${not empty msg.chatResponse}">
                                    <div class="bubble-ai-wrap">
                                        <div class="bubble-ai-icon">
                                            <i class="bi bi-robot"></i>
                                        </div>
                                        <div class="bubble-ai">
                                            ${msg.chatResponse}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div><!-- /.chat-area -->
        </div><!-- /.chat-card -->

        <!-- 하단 목록으로 버튼 -->
        <div class="mt-3">
            <a href="${ctx}/admin/chatbot/list?nowPage=${nowPage}&numPerPage=${numPerPage}&statusFilter=${statusFilter}&searchWord=${searchWord}&dateFrom=${dateFrom}&dateTo=${dateTo}"
               class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>목록으로 돌아가기
            </a>
        </div>

    </div><!-- /.main-content -->
</div><!-- /.row -->
</div><!-- /.container-fluid -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

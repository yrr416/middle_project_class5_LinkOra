<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="reportListSize" value="0"/>
<c:forEach var="_r" items="${reportList}">
    <c:set var="reportListSize" value="${reportListSize + 1}"/>
</c:forEach>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 상세 - 오피스 예약 플랫폼</title>
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

        /* ── 섹션 카드 ── */
        .section-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); overflow:hidden; margin-bottom:20px; }
        .section-header { padding:14px 20px; border-bottom:1px solid #f0f0f0; display:flex; align-items:center; gap:8px; }
        .section-body { padding:20px; }

        /* ── 별점 ── */
        .stars-lg { color:#f59e0b; font-size:1.6rem; letter-spacing:2px; }
        .stars-sm  { color:#f59e0b; font-size:1rem; }
        .stars-empty { color:#d1d5db; }

        /* ── 상태 배지 ── */
        .badge-normal  { background:#d1fae5; color:#065f46; }
        .badge-blind   { background:#fee2e2; color:#991b1b; }
        .badge-pending { background:#fef9c3; color:#854d0e; }
        .badge-blinded { background:#fee2e2; color:#991b1b; }
        .badge-dismissed { background:#e5e7eb; color:#374151; }

        /* ── 리뷰 원문 박스 ── */
        .review-content-box {
            background:#f8f9fa; border-radius:8px; padding:16px 20px;
            font-size:.95rem; line-height:1.8; border-left:4px solid #0d6efd;
            white-space:pre-wrap; word-break:break-all;
        }

        /* ── 신고 박스 ── */
        .report-item { background:#fffbeb; border-radius:8px; padding:14px 18px; border-left:4px solid #f59e0b; margin-bottom:10px; }
        .report-item.dismissed { background:#f9fafb; border-left-color:#9ca3af; opacity:.75; }
        .report-item.blinded   { background:#fef2f2; border-left-color:#ef4444; }

        /* ── 관리자 답글 박스 ── */
        .reply-box { background:#eff6ff; border-radius:8px; padding:14px 18px; border-left:4px solid #3b82f6; }

        /* ── 이미지 갤러리 ── */
        .img-thumb { width:120px; height:90px; object-fit:cover; border-radius:6px; cursor:pointer;
                     border:2px solid #e5e7eb; transition:border-color .2s; }
        .img-thumb:hover { border-color:#0d6efd; }

        /* ── 액션 버튼 영역 ── */
        .action-bar { background:#f8f9fa; border-radius:10px; padding:16px 20px; margin-bottom:20px;
                      display:flex; flex-wrap:wrap; gap:10px; align-items:center; }
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
            <a class="nav-link active" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지/이벤트 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h5 class="fw-bold mb-1">
                    <i class="bi bi-star-fill me-2 text-warning"></i>리뷰 상세
                </h5>
                <small class="text-muted">리뷰 #${review.revIdx} 상세 정보 및 관리</small>
            </div>
            <a href="${ctx}/admin/review/list?nowPage=${nowPage}&ratingFilter=${reviewVO.ratingFilter}&blindFilter=${reviewVO.blindFilter}&searchWord=${reviewVO.searchWord}"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>목록으로
            </a>
        </div>

        <!-- ═══════════════════════════════════════════
             [1] 기본 정보 요약 카드
             ═══════════════════════════════════════════ -->
        <div class="section-card">
            <div class="section-header">
                <i class="bi bi-info-circle text-primary"></i>
                <span class="fw-bold">기본 정보</span>
                <!-- 상태 배지 -->
                <c:choose>
                    <c:when test="${review.revActive == '2'}">
                        <span class="badge badge-blind rounded-pill ms-2">블라인드</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-normal rounded-pill ms-2">정상</span>
                    </c:otherwise>
                </c:choose>
                <c:if test="${review.reportCnt > 0}">
                    <span class="badge bg-danger rounded-pill ms-1">${review.reportCnt}건 신고</span>
                </c:if>
            </div>
            <div class="section-body">
                <div class="row g-4">
                    <!-- 별점 (크게) -->
                    <div class="col-md-3 text-center border-end">
                        <div class="text-muted small mb-1">별점</div>
                        <div class="stars-lg">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= review.revRating}">★</c:when>
                                    <c:otherwise><span class="stars-empty">★</span></c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <div class="fw-bold text-warning fs-4 mt-1">${review.revRating}<small class="text-muted fs-6">점</small></div>
                    </div>
                    <!-- 기본 정보 -->
                    <div class="col-md-9">
                        <div class="row g-3">
                            <div class="col-sm-4">
                                <div class="text-muted small">작성자</div>
                                <div class="fw-semibold">${review.userName}
                                    <small class="text-muted">(#${review.userIdx})</small>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">공간명</div>
                                <div class="fw-semibold">${review.spcName}</div>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">이용 일시</div>
                                <div class="fw-semibold">${review.revTime}</div>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">작성일</div>
                                <div>${review.revCreatedAt}</div>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">최종 수정일</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${not empty review.revUpdatedAt}">${review.revUpdatedAt}</c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="text-muted small">신고 횟수</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${review.reportCnt > 0}">
                                            <span class="text-danger fw-bold">${review.reportCnt}건</span>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">없음</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             [2] 리뷰 원문 + 첨부 이미지
             ═══════════════════════════════════════════ -->
        <div class="section-card">
            <div class="section-header">
                <i class="bi bi-chat-square-text text-primary"></i>
                <span class="fw-bold">리뷰 원문</span>
            </div>
            <div class="section-body">
                <div class="review-content-box">${review.revContent}</div>

                <!-- 첨부 이미지 -->
                <c:if test="${not empty review.revImg}">
                    <div class="mt-3">
                        <div class="text-muted small mb-2"><i class="bi bi-image me-1"></i>첨부 이미지</div>
                        <img src="${review.revImg}" alt="리뷰 이미지" class="img-thumb"
                             onclick="openImgModal('${review.revImg}')">
                    </div>
                </c:if>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             [3] 신고 이력
             ═══════════════════════════════════════════ -->
        <div class="section-card">
            <div class="section-header">
                <i class="bi bi-flag-fill text-warning"></i>
                <span class="fw-bold">신고 이력</span>
                <span class="badge bg-secondary rounded-pill ms-1">${reportListSize}건</span>
            </div>
            <div class="section-body">
                <c:choose>
                    <c:when test="${empty reportList}">
                        <div class="text-center py-3 text-muted">
                            <i class="bi bi-check-circle fs-4 d-block mb-1 text-success"></i>
                            신고 이력이 없습니다.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rp" items="${reportList}">
                            <div class="report-item ${rp.rvrStatus == 'DISMISSED' ? 'dismissed' : ''} ${rp.rvrStatus == 'BLINDED' ? 'blinded' : ''}">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <span class="fw-semibold">${rp.userName}</span>
                                        <span class="text-muted small ms-2">신고자 #${rp.userIdx}</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-2">
                                        <small class="text-muted">${rp.rvrCreated}</small>
                                        <c:choose>
                                            <c:when test="${rp.rvrStatus == 'PENDING'}">
                                                <span class="badge badge-pending rounded-pill">미처리</span>
                                            </c:when>
                                            <c:when test="${rp.rvrStatus == 'BLINDED'}">
                                                <span class="badge badge-blinded rounded-pill">블라인드완료</span>
                                            </c:when>
                                            <c:when test="${rp.rvrStatus == 'DISMISSED'}">
                                                <span class="badge badge-dismissed rounded-pill">반려</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="small">
                                    <span class="text-muted">신고 사유:</span>
                                    <span class="ms-1">${rp.rvrReason}</span>
                                </div>
                                <c:if test="${not empty rp.rvrAdminReply}">
                                    <div class="small mt-1 text-primary">
                                        <i class="bi bi-reply-fill me-1"></i>
                                        <span class="text-muted">처리 메시지:</span>
                                        <span class="ms-1">${rp.rvrAdminReply}</span>
                                    </div>
                                </c:if>
                                <!-- PENDING 신고만 처리 버튼 표시 -->
                                <c:if test="${rp.rvrStatus == 'PENDING'}">
                                    <div class="mt-2 d-flex gap-2">
                                        <button class="btn btn-sm btn-danger py-0 px-2"
                                                onclick="openReportModal('${rp.rvrIdx}','${review.revIdx}','${rp.rvrReason}','${rp.userName}')">
                                            <i class="bi bi-eye-slash me-1"></i>블라인드 처리
                                        </button>
                                        <button class="btn btn-sm btn-outline-secondary py-0 px-2"
                                                onclick="openDismissModal('${rp.rvrIdx}','${rp.rvrReason}','${rp.userName}')">
                                            <i class="bi bi-x-circle me-1"></i>반려
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             [4] 관리자 액션 버튼
             ═══════════════════════════════════════════ -->
        <div class="action-bar">
            <span class="fw-semibold text-muted me-2">관리 액션:</span>

            <!-- 블라인드 처리 / 해제 -->
            <c:choose>
                <c:when test="${review.revActive == '2'}">
                    <form method="post" action="${ctx}/admin/review/unblind" class="d-inline">
                        <input type="hidden" name="revIdx"      value="${review.revIdx}">
                        <input type="hidden" name="nowPage"     value="${nowPage}">
                        <input type="hidden" name="fromDetail"  value="1">
                        <button type="submit" class="btn btn-success btn-sm"
                                onclick="return confirm('블라인드를 해제하시겠습니까?')">
                            <i class="bi bi-eye me-1"></i>블라인드 해제
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${ctx}/admin/review/blind" class="d-inline">
                        <input type="hidden" name="revIdx"      value="${review.revIdx}">
                        <input type="hidden" name="nowPage"     value="${nowPage}">
                        <input type="hidden" name="fromDetail"  value="1">
                        <button type="submit" class="btn btn-warning btn-sm"
                                onclick="return confirm('이 리뷰를 블라인드 처리하시겠습니까?')">
                            <i class="bi bi-eye-slash me-1"></i>블라인드 처리
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>

            <!-- 리뷰 삭제 -->
            <form method="post" action="${ctx}/admin/review/delete" class="d-inline">
                <input type="hidden" name="revIdx"  value="${review.revIdx}">
                <input type="hidden" name="nowPage" value="${nowPage}">
                <button type="submit" class="btn btn-danger btn-sm"
                        onclick="return confirm('리뷰를 완전히 삭제하시겠습니까?\n삭제된 리뷰는 복구할 수 없습니다.')">
                    <i class="bi bi-trash me-1"></i>리뷰 삭제
                </button>
            </form>
        </div>

<%--        <!-- ═══════════════════════════════════════════--%>
<%--             [5] 관리자 답글 섹션--%>
<%--             ═══════════════════════════════════════════ -->--%>
        <div class="section-card">
            <div class="section-header">
                <i class="bi bi-reply-fill text-primary"></i>
                <span class="fw-bold">관리자 답글</span>
                <c:if test="${not empty review.adminReply}">
                    <span class="badge bg-primary rounded-pill ms-1">등록됨</span>
                </c:if>
            </div>
            <div class="section-body">

<%--                <!-- 답글 있는 경우: 기존 답글 표시 + 수정/삭제 -->--%>
                <c:choose>
                    <c:when test="${not empty review.adminReply}">
                        <div class="reply-box mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="fw-semibold text-primary">
                                    <i class="bi bi-shield-fill me-1"></i>관리자
                                </span>
                                <small class="text-muted">${review.adminReplyAt}</small>
                            </div>
                            <div style="white-space:pre-wrap; font-size:.92rem;">${review.adminReply}</div>
                        </div>

<%--                        <!-- 수정 폼 (접기/펼치기) -->--%>
                        <button class="btn btn-outline-primary btn-sm mb-2" type="button"
                                data-bs-toggle="collapse" data-bs-target="#replyEditForm">
                            <i class="bi bi-pencil me-1"></i>답글 수정
                        </button>
                        <form method="post" action="${ctx}/admin/review/replyUpdate"
                              class="collapse" id="replyEditForm">
                            <input type="hidden" name="revIdx"  value="${review.revIdx}">
                            <input type="hidden" name="nowPage" value="${nowPage}">
                            <textarea name="reply_content" class="form-control mb-2" rows="4"
                                      required>${review.adminReply}</textarea>
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="bi bi-check-circle me-1"></i>수정 저장
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm ms-1"
                                    data-bs-toggle="collapse" data-bs-target="#replyEditForm">
                                취소
                            </button>
                        </form>

<%--                        <!-- 답글 삭제 -->--%>
                        <form method="post" action="${ctx}/admin/review/replyDelete" class="d-inline ms-2">
                            <input type="hidden" name="revIdx"  value="${review.revIdx}">
                            <input type="hidden" name="nowPage" value="${nowPage}">
                            <button type="submit" class="btn btn-outline-danger btn-sm"
                                    onclick="return confirm('관리자 답글을 삭제하시겠습니까?')">
                                <i class="bi bi-trash me-1"></i>답글 삭제
                            </button>
                        </form>
                    </c:when>

<%--                    <!-- 답글 없는 경우: 작성 폼 바로 표시 -->--%>
                    <c:otherwise>
                        <p class="text-muted small mb-3">
                            <i class="bi bi-info-circle me-1"></i>
                            등록된 관리자 답글이 없습니다. 고객에게 표시될 답글을 작성하세요.
                        </p>
                        <form method="post" action="${ctx}/admin/review/reply">
                            <input type="hidden" name="revIdx"      value="${review.revIdx}">
                            <input type="hidden" name="nowPage"     value="${nowPage}">
                            <input type="hidden" name="fromDetail"  value="1">
                            <textarea name="reply_content" class="form-control mb-2" rows="5" required
                                      placeholder="고객에게 표시될 관리자 답글을 입력하세요.&#10;예) 불편을 드려 죄송합니다. 해당 사항을 검토하여 개선하겠습니다."></textarea>
                            <button type="submit" class="btn btn-primary btn-sm">
                                <i class="bi bi-check-circle me-1"></i>답글 등록
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div><!-- /main-content -->
</div>
</div>

<!-- 이미지 확대 모달 -->
<div class="modal fade" id="imgModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content bg-transparent border-0">
            <div class="text-end mb-2">
                <button type="button" class="btn btn-sm btn-light" data-bs-dismiss="modal">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <img id="imgModalSrc" src="" alt="리뷰 이미지" class="img-fluid rounded shadow">
        </div>
    </div>
</div>

<!-- 신고 블라인드 처리 모달 -->
<div class="modal fade" id="reportBlindModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger-subtle">
                <h6 class="modal-title fw-bold">
                    <i class="bi bi-eye-slash me-2 text-danger"></i>신고 블라인드 처리
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${ctx}/admin/review/reportBlind">
                <input type="hidden" name="rvrIdx"  id="blind_rr_idx">
                <input type="hidden" name="revIdx"  value="${review.revIdx}">
                <input type="hidden" name="nowPage" value="${nowPage}">
                <input type="hidden" name="fromDetail" value="1">
                <div class="modal-body">
                    <p class="small mb-1 text-muted">신고자: <strong id="blind_reporter"></strong></p>
                    <p class="small mb-3 text-muted">사유: <strong id="blind_reason"></strong></p>
                    <label class="form-label fw-semibold">신고자에게 전달할 처리 결과 <span class="text-danger">*</span></label>
                    <textarea name="rvrAdminReply" class="form-control" rows="4" required
                              placeholder="예) 해당 리뷰를 검토한 결과 커뮤니티 정책 위반으로 블라인드 처리하였습니다."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-danger btn-sm">
                        <i class="bi bi-eye-slash me-1"></i>블라인드 처리
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 신고 반려 모달 -->
<div class="modal fade" id="reportDismissModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title fw-bold">
                    <i class="bi bi-x-circle me-2 text-secondary"></i>신고 반려 처리
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${ctx}/admin/review/reportDismiss">
                <input type="hidden" name="rvrIdx"  id="dismiss_rr_idx">
                <input type="hidden" name="nowPage" value="${nowPage}">
                <div class="modal-body">
                    <p class="small mb-1 text-muted">신고자: <strong id="dismiss_reporter"></strong></p>
                    <p class="small mb-3 text-muted">사유: <strong id="dismiss_reason"></strong></p>
                    <label class="form-label fw-semibold">신고자에게 전달할 처리 결과 <span class="text-danger">*</span></label>
                    <textarea name="rvrAdminReply" class="form-control" rows="4" required
                              placeholder="예) 검토 결과 이용 약관 위반 사항이 없어 반려 처리하였습니다."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-secondary btn-sm">
                        <i class="bi bi-x-circle me-1"></i>반려 처리
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 이미지 확대 모달
    function openImgModal(src) {
        document.getElementById('imgModalSrc').src = src;
        new bootstrap.Modal(document.getElementById('imgModal')).show();
    }

    // 신고 블라인드 처리 모달
    function openReportModal(rvrIdx, revIdx, reason, reporter) {
        document.getElementById('blind_rr_idx').value    = rvrIdx;
        document.getElementById('blind_reason').textContent   = reason;
        document.getElementById('blind_reporter').textContent = reporter;
        new bootstrap.Modal(document.getElementById('reportBlindModal')).show();
    }

    // 신고 반려 모달
    function openDismissModal(rvrIdx, reason, reporter) {
        document.getElementById('dismiss_rr_idx').value       = rvrIdx;
        document.getElementById('dismiss_reason').textContent  = reason;
        document.getElementById('dismiss_reporter').textContent = reporter;
        new bootstrap.Modal(document.getElementById('reportDismissModal')).show();
    }
</script>
</body>
</html>

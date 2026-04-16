<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>설정 - 오피스 예약 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f4f6f9; }
        .sidebar { min-height:100vh; background:linear-gradient(180deg,#1a3a5c 0%,#0d2137 100%); position:sticky; top:0; }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:10px 20px; border-radius:6px; margin:2px 8px; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .sidebar .nav-link i { margin-right:8px; }
        .sidebar-brand { color:#fff; font-size:1.2rem; font-weight:700; padding:20px; border-bottom:1px solid rgba(255,255,255,.1); }
        .main-content { padding:24px; }
        .page-header { background:#fff; border-radius:10px; padding:20px 24px; margin-bottom:20px; box-shadow:0 1px 4px rgba(0,0,0,.06); }

        /* ── 설정 탭 ── */
        .settings-nav .nav-link { color:#495057; border-radius:8px; padding:10px 18px; font-weight:500; }
        .settings-nav .nav-link.active { background:#1a3a5c; color:#fff; }
        .settings-nav .nav-link i { margin-right:6px; }

        /* ── 섹션 카드 ── */
        .set-card { background:#fff; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,.06); padding:28px; margin-bottom:20px; }
        .set-card h6 { font-weight:700; color:#1a3a5c; border-bottom:2px solid #e9ecef; padding-bottom:10px; margin-bottom:18px; }

        /* ── 로그 테이블 ── */
        .log-table thead th { background:#f8f9fa; font-size:.82rem; font-weight:600; color:#495057; }
        .log-table td { font-size:.85rem; vertical-align:middle; }

        /* ── 토글 스위치 ── */
        .form-switch .form-check-input { width:2.5em; height:1.3em; cursor:pointer; }

        /* ── 템플릿 항목 ── */
        .template-item { border:1px solid #e9ecef; border-radius:8px; padding:14px 16px; margin-bottom:10px; }
        .template-item:hover { border-color:#0d6efd; background:#f8f9ff; }

        /* ── 페이지네이션 ── */
        .pagination .page-link { color:#1a3a5c; font-size:.85rem; }
        .pagination .page-item.active .page-link { background:#1a3a5c; border-color:#1a3a5c; }

        /* ── CKEditor 높이 ── */
        .ck-editor__editable { min-height:280px; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
<div class="row g-0">

    <!-- ── 사이드바 ─────────────────────────────────────────────── -->
    <div class="col-auto sidebar" style="width:230px;">
        <div class="sidebar-brand"><i class="bi bi-building me-2"></i>오피스 예약</div>
        <nav class="nav flex-column mt-2">
            <span class="nav-link text-white-50 small px-3 pt-3 pb-1">관리자 메뉴</span>
            <a class="nav-link" href="${ctx}/admin/dashboard"><i class="bi bi-speedometer2"></i>대시보드</a>
            <a class="nav-link" href="${ctx}/admin/customer/list"><i class="bi bi-people"></i>고객 관리</a>
            <a class="nav-link" href="${ctx}/admin/review/list"><i class="bi bi-star"></i>리뷰 관리</a>
            <a class="nav-link" href="${ctx}/admin/notice/list"><i class="bi bi-bell"></i>공지 관리</a>
            <a class="nav-link" href="${ctx}/admin/inquiry/list"><i class="bi bi-chat-left-text"></i>문의 내역</a>
            <a class="nav-link" href="${ctx}/admin/chatbot/list"><i class="bi bi-robot me-1"></i>챗봇상담내역</a>
            <hr class="border-secondary mx-3">
                        <a class="nav-link" href="${ctx}/" target="_blank"><i class="bi bi-house"></i>홈페이지 이동</a>
            <a class="nav-link active" href="${ctx}/admin/settings"><i class="bi bi-gear"></i>설정</a>
            <a class="nav-link text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right"></i>로그아웃</a>
        </nav>
    </div>

    <!-- ── 메인 콘텐츠 ─────────────────────────────────────────── -->
    <div class="col main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h5 class="mb-1 fw-bold"><i class="bi bi-gear me-2 text-secondary"></i>설정</h5>
            <small class="text-muted">플랫폼 운영에 필요한 각종 설정을 관리합니다.</small>
        </div>

        <!-- 완료 메시지 -->
        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show mb-3">
                <i class="bi bi-check-circle me-1"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- ── 설정 탭 내비게이션 ──────────────────────────────── -->
        <ul class="nav settings-nav gap-2 mb-4" id="settingsTabs">
            <li class="nav-item">
                <a class="nav-link ${tab == 'account' || tab == '' ? 'active' : ''}"
                   href="${ctx}/admin/settings?tab=account">
                    <i class="bi bi-person-circle"></i>계정 관리
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${tab == 'policy' ? 'active' : ''}"
                   href="${ctx}/admin/settings?tab=policy">
                    <i class="bi bi-shield-check"></i>서비스 정책
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${tab == 'service' ? 'active' : ''}"
                   href="${ctx}/admin/settings?tab=service">
                    <i class="bi bi-sliders"></i>서비스 설정
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${tab == 'system' ? 'active' : ''}"
                   href="${ctx}/admin/settings?tab=system">
                    <i class="bi bi-cpu"></i>시스템
                </a>
            </li>
        </ul>

        <!-- ══════════════════════════════════════════════════════
             TAB 1: 계정 관리
             ══════════════════════════════════════════════════════ -->
        <c:if test="${tab == 'account' || tab == ''}">

            <!-- 비밀번호 변경 완료/오류 메시지 -->
            <c:if test="${not empty pwdMsg}">
                <div class="alert ${pwdMsg.contains('변경되었습니다') ? 'alert-success' : 'alert-danger'} alert-dismissible fade show mb-3">
                    <i class="bi bi-${pwdMsg.contains('변경되었습니다') ? 'check' : 'exclamation'}-circle me-1"></i>${pwdMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- 관리자 계정 정보 -->
            <div class="set-card">
                <h6><i class="bi bi-person me-2"></i>관리자 계정 정보</h6>
                <form method="post" action="${ctx}/admin/settings/account">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">관리자 ID</label>
                            <!-- ID는 변경 불가, 읽기 전용 -->
                            <input type="text" class="form-control" value="${adminInfo.aId}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">이름 <span class="text-danger">*</span></label>
                            <input type="text" name="aName" class="form-control"
                                   value="${adminInfo.admName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">이메일 <span class="text-danger">*</span></label>
                            <input type="email" name="aEmail" class="form-control"
                                   value="${adminInfo.aEmail}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">연락처</label>
                            <input type="text" name="aPhone" class="form-control"
                                   value="${adminInfo.aPhone}">
                        </div>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-check-lg me-1"></i>정보 저장
                        </button>
                    </div>
                </form>
            </div>

            <!-- 비밀번호 변경 -->
            <div class="set-card">
                <h6><i class="bi bi-lock me-2"></i>비밀번호 변경</h6>
                <form method="post" action="${ctx}/admin/settings/password">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <div class="row g-3" style="max-width:480px;">
                        <div class="col-12">
                            <label class="form-label fw-semibold small">현재 비밀번호</label>
                            <input type="password" name="currentPwd" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small">새 비밀번호</label>
                            <input type="password" name="newPwd" id="newPwd" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small">새 비밀번호 확인</label>
                            <input type="password" name="newPwdConfirm" id="newPwdConfirm"
                                   class="form-control" oninput="checkPwdMatch()" required>
                            <small id="pwdMatchMsg" class="text-muted"></small>
                        </div>
                    </div>
                    <div class="d-flex justify-content-start mt-3">
                        <button type="submit" class="btn btn-outline-danger btn-sm">
                            <i class="bi bi-shield-lock me-1"></i>비밀번호 변경
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════
             TAB 2: 서비스 정책
             ══════════════════════════════════════════════════════ -->
        <c:if test="${tab == 'policy'}">
            <form method="post" action="${ctx}/admin/settings/policy">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                <!-- 등급 기준 -->
                <div class="set-card">
                    <h6><i class="bi bi-trophy me-2"></i>등급 기준 설정</h6>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">실버 최소 예약 횟수</label>
                            <div class="input-group">
                                <input type="number" name="grade_silver_count" class="form-control"
                                       value="${settings.grade_silver_count}" min="1">
                                <span class="input-group-text">회</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">골드 최소 예약 횟수</label>
                            <div class="input-group">
                                <input type="number" name="grade_gold_count" class="form-control"
                                       value="${settings.grade_gold_count}" min="1">
                                <span class="input-group-text">회</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">실버 최소 누적 금액</label>
                            <div class="input-group">
                                <input type="number" name="grade_silver_amount" class="form-control"
                                       value="${settings.grade_silver_amount}" min="0">
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">골드 최소 누적 금액</label>
                            <div class="input-group">
                                <input type="number" name="grade_gold_amount" class="form-control"
                                       value="${settings.grade_gold_amount}" min="0">
                                <span class="input-group-text">원</span>
                            </div>
                        </div>
                    </div>
                    <small class="text-muted mt-2 d-block">
                        <i class="bi bi-info-circle me-1"></i>
                        예약 횟수 <strong>또는</strong> 누적 금액 중 하나를 충족하면 해당 등급으로 승급됩니다.
                    </small>
                </div>

                <!-- 포인트 정책 -->
                <div class="set-card">
                    <h6><i class="bi bi-coin me-2"></i>포인트 정책</h6>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">예약 완료 시 적립률</label>
                            <div class="input-group">
                                <input type="number" name="point_rate" class="form-control"
                                       value="${settings.point_rate}" min="0" max="100">
                                <span class="input-group-text">%</span>
                            </div>
                            <small class="text-muted">예약 금액의 N%를 포인트로 적립</small>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">최소 사용 포인트</label>
                            <div class="input-group">
                                <input type="number" name="point_min_use" class="form-control"
                                       value="${settings.point_min_use}" min="0">
                                <span class="input-group-text">원</span>
                            </div>
                            <small class="text-muted">이 금액 이상 보유해야 사용 가능</small>
                        </div>
                    </div>
                </div>

                <!-- 예약 취소 정책 -->
                <div class="set-card">
                    <h6><i class="bi bi-x-circle me-2"></i>예약 취소 정책</h6>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">취소 가능 기간</label>
                            <div class="input-group">
                                <input type="number" name="cancel_period" class="form-control"
                                       value="${settings.cancel_period}" min="0">
                                <span class="input-group-text">시간 전까지</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">전액 환불 비율</label>
                            <div class="input-group">
                                <input type="number" name="refund_rate_full" class="form-control"
                                       value="${settings.refund_rate_full}" min="0" max="100">
                                <span class="input-group-text">%</span>
                            </div>
                            <small class="text-muted">취소 가능 기간 내 취소 시</small>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">부분 환불 비율</label>
                            <div class="input-group">
                                <input type="number" name="refund_rate_half" class="form-control"
                                       value="${settings.refund_rate_half}" min="0" max="100">
                                <span class="input-group-text">%</span>
                            </div>
                            <small class="text-muted">취소 가능 기간 초과 시</small>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i>정책 저장
                    </button>
                </div>
            </form>
        </c:if>

        <!-- ══════════════════════════════════════════════════════
             TAB 3: 서비스 설정
             ══════════════════════════════════════════════════════ -->
        <c:if test="${tab == 'service'}">

            <!-- 운영 시간 + 팝업 + 알림 -->
            <form method="post" action="${ctx}/admin/settings/service">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <!-- 운영 시간 -->
                <div class="set-card">
                    <h6><i class="bi bi-clock me-2"></i>운영 시간 설정</h6>
                    <div class="row g-3 align-items-center">
                        <div class="col-auto">
                            <label class="form-label small fw-semibold">시작 시간</label>
                            <input type="time" name="op_start_time" class="form-control"
                                   value="${settings.op_start_time}">
                        </div>
                        <div class="col-auto pt-4">~</div>
                        <div class="col-auto">
                            <label class="form-label small fw-semibold">종료 시간</label>
                            <input type="time" name="op_end_time" class="form-control"
                                   value="${settings.op_end_time}">
                        </div>
                    </div>
                    <small class="text-muted mt-2 d-block">
                        <i class="bi bi-info-circle me-1"></i>개별 공간 시간은 오피스 관리에서 별도 설정합니다.
                    </small>
                </div>

                <!-- 공지 자동 팝업 -->
                <div class="set-card">
                    <h6><i class="bi bi-window me-2"></i>공지 자동 팝업</h6>
                    <div class="row g-3">
                        <div class="col-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="popupToggle"
                                       name="popup_enabled" value="1"
                                       ${settings.popup_enabled == '1' ? 'checked' : ''}
                                       onchange="togglePopupOptions(this.checked)">
                                <label class="form-check-label fw-semibold" for="popupToggle">
                                    로그인 시 팝업 공지 사용
                                </label>
                            </div>
                        </div>
                        <!-- 팝업 on 시 세부 옵션 -->
                        <div id="popupOptions" class="${settings.popup_enabled == '1' ? '' : 'd-none'} col-12">
                            <div class="row g-3 ms-1">
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">노출 공지 번호</label>
                                    <input type="number" name="popup_notice_idx" class="form-control form-control-sm"
                                           value="${settings.popup_notice_idx}" placeholder="n_idx 입력">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">노출 종료일</label>
                                    <input type="date" name="popup_end_date" class="form-control form-control-sm"
                                           value="${settings.popup_end_date}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 알림 설정 -->
                <div class="set-card">
                    <h6><i class="bi bi-envelope me-2"></i>이메일 알림 설정</h6>
                    <div class="d-flex flex-column gap-3">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="emailReservation"
                                   name="email_reservation" value="1"
                                   ${settings.email_reservation == '1' ? 'checked' : ''}>
                            <label class="form-check-label" for="emailReservation">
                                신규 예약 발생 시 이메일 알림
                            </label>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="emailInquiry"
                                   name="email_inquiry" value="1"
                                   ${settings.email_inquiry == '1' ? 'checked' : ''}>
                            <label class="form-check-label" for="emailInquiry">
                                신규 문의 등록 시 이메일 알림
                            </label>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="emailReport"
                                   name="email_report" value="1"
                                   ${settings.email_report == '1' ? 'checked' : ''}>
                            <label class="form-check-label" for="emailReport">
                                신규 리뷰 신고 발생 시 이메일 알림
                            </label>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end mb-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i>서비스 설정 저장
                    </button>
                </div>
            </form>

        </c:if>

        <!-- ══════════════════════════════════════════════════════
             TAB 4: 시스템
             ══════════════════════════════════════════════════════ -->
        <c:if test="${tab == 'system'}">
            <form method="post" action="${ctx}/admin/settings/system">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                <!-- 수수료율 -->
                <div class="set-card">
                    <h6><i class="bi bi-percent me-2"></i>수수료율 설정</h6>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">플랫폼 수수료율</label>
                            <div class="input-group">
                                <input type="number" name="commission_rate" class="form-control"
                                       value="${settings.commission_rate}" min="0" max="100" step="0.1">
                                <span class="input-group-text">%</span>
                            </div>
                            <small class="text-muted">파트너 정산 시 공제되는 수수료</small>
                        </div>
                    </div>
                </div>

                <!-- 이용약관 -->
                <div class="set-card">
                    <h6><i class="bi bi-file-text me-2"></i>이용약관</h6>
                    <div id="termsEditor">${settings.terms_content}</div>
                    <input type="hidden" name="terms_content" id="terms_content_hidden">
                </div>

                <!-- 개인정보처리방침 -->
                <div class="set-card">
                    <h6><i class="bi bi-shield-lock me-2"></i>개인정보처리방침</h6>
                    <div id="privacyEditor">${settings.privacy_content}</div>
                    <input type="hidden" name="privacy_content" id="privacy_content_hidden">
                </div>

                <div class="d-flex justify-content-end mb-4">
                    <button type="button" class="btn btn-primary" onclick="submitSystem()">
                        <i class="bi bi-check-lg me-1"></i>시스템 설정 저장
                    </button>
                </div>
            </form>

            <!-- 관리자 활동 로그 -->
            <div class="set-card">
                <h6><i class="bi bi-clock-history me-2"></i>관리자 활동 로그</h6>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <small class="text-muted">전체 ${totalLog}건</small>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover log-table align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width:160px;">일시</th>
                                <th style="width:100px;">관리자</th>
                                <th style="width:140px;">작업</th>
                                <th>상세 내용</th>
                                <th style="width:120px;">IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty logList}">
                                    <tr>
                                        <td colspan="5" class="text-center py-3 text-muted">
                                            <i class="bi bi-inbox me-1"></i>활동 로그가 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${logList}">
                                        <tr>
                                            <td class="text-muted">${log.alogCreated}</td>
                                            <td>${log.admName}</td>
                                            <td>
                                                <span class="badge bg-secondary">${log.alogAction}</span>
                                            </td>
                                            <td class="text-muted">${log.alogDetail}</td>
                                            <td class="text-muted">${log.alogIp}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- 활동 로그 페이지네이션 -->
                <div class="d-flex justify-content-center py-3">
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <c:if test="${logPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${ctx}/admin/settings?tab=system&logPage=${logPage - 1}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPage}" var="p">
                                <li class="page-item ${p == logPage ? 'active' : ''}">
                                    <a class="page-link" href="${ctx}/admin/settings?tab=system&logPage=${p}">${p}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${logPage < totalPage}">
                                <li class="page-item">
                                    <a class="page-link" href="${ctx}/admin/settings?tab=system&logPage=${logPage + 1}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </c:if>

    </div><!-- /.main-content -->
</div><!-- /.row -->
</div><!-- /.container-fluid -->

<!-- CKEditor 5 (시스템 탭에서만 로드) -->
<c:if test="${tab == 'system'}">
    <script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
</c:if>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ── 비밀번호 일치 확인 ───────────────────────────────────────
    function checkPwdMatch() {
        const p1  = document.getElementById('newPwd')?.value;
        const p2  = document.getElementById('newPwdConfirm')?.value;
        const msg = document.getElementById('pwdMatchMsg');
        if (!msg) return;
        if (p2.length === 0) { msg.textContent = ''; return; }
        if (p1 === p2) {
            msg.textContent = '✔ 비밀번호가 일치합니다.';
            msg.className   = 'text-success';
        } else {
            msg.textContent = '✘ 비밀번호가 일치하지 않습니다.';
            msg.className   = 'text-danger';
        }
    }

    // ── 팝업 옵션 표시/숨김 ─────────────────────────────────────
    function togglePopupOptions(show) {
        const el = document.getElementById('popupOptions');
        if (el) el.classList.toggle('d-none', !show);
    }

    // ── 템플릿 모달 열기 (등록 or 수정) ────────────────────────
    function openTemplateModal(tIdx, tTitle, tContent) {
        const isEdit = !!tIdx;
        document.getElementById('templateModalTitle').textContent = isEdit ? '템플릿 수정' : '템플릿 등록';
        document.getElementById('templateModalBtn').textContent   = isEdit ? '수정' : '등록';
        document.getElementById('modal_t_idx').value    = tIdx    || '';
        document.getElementById('modal_t_title').value  = tTitle  || '';
        document.getElementById('modal_t_content').value = tContent || '';
        new bootstrap.Modal(document.getElementById('templateModal')).show();
    }

    // ── 시스템 폼 제출 (CKEditor 내용 복사 후 submit) ──────────
    <c:if test="${tab == 'system'}">
    let termsEditor, privacyEditor;
    ClassicEditor.create(document.querySelector('#termsEditor'))
        .then(e => { termsEditor = e; })
        .catch(console.error);
    ClassicEditor.create(document.querySelector('#privacyEditor'))
        .then(e => { privacyEditor = e; })
        .catch(console.error);

    function submitSystem() {
        document.getElementById('terms_content_hidden').value   = termsEditor?.getData()   || '';
        document.getElementById('privacy_content_hidden').value = privacyEditor?.getData() || '';
        document.querySelector('form[action="${ctx}/admin/settings/system"]').submit();
    }
    </c:if>
</script>
</body>
</html>

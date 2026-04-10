<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [공통 레이아웃] --%>
<%@ include file="../layout/header.jsp" %>

<main class="list-page-wrapper">
    <%-- [상단 타이틀 영역] --%>
    <section class="list-header" style="background-color: #f4f7f6; padding: 40px 0; text-align: center;">
        <div class="container">
            <c:choose>
                <c:when test="${not empty keyword}">
                    <h2>'<span style="color: #007A8A;">${keyword}</span>' 검색 결과임</h2>
                    <p>총 <strong>${branches.size()}</strong>개의 공간을 찾았습니다.</p>
                </c:when>
                <c:otherwise>
                    <h2>전체 지점 보기임</h2>
                    <p>Link Ora의 프리미엄 공간들을 만나보세요.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <div class="container" style="display: flex; gap: 30px; margin-top: 40px; margin-bottom: 60px;">

        <%-- [좌측: 상세 필터 영역] --%>
        <aside class="filter-sidebar" style="width: 280px; flex-shrink: 0; background: #fff; padding: 25px; border: 1px solid #eee; border-radius: 12px; height: fit-content; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
            <div class="filter-box">
                <h3 style="margin-bottom: 20px; font-size: 18px; border-bottom: 2px solid #007A8A; padding-bottom: 10px;">상세 필터임</h3>
                <form action="${pageContext.request.contextPath}/branch/search" method="get">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <input type="hidden" name="region" value="${region}">

                    <div class="filter-group" style="margin-bottom: 25px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #333;">수용 인원임</label>
                        <select name="capacity" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #ddd;">
                            <option value="">인원 전체</option>
                            <option value="1" ${capacity == 1 ? 'selected' : ''}>1인 (집중석)</option>
                            <option value="2" ${capacity == 2 ? 'selected' : ''}>2인 (커플/협업)</option>
                            <option value="4" ${capacity == 4 ? 'selected' : ''}>4인 이상 (미팅룸)</option>
                        </select>
                    </div>

                    <div class="filter-group" style="margin-bottom: 25px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #333;">편의 시설임</label>
                        <div style="display: grid; gap: 10px; color: #555; font-size: 14px;">
                            <%-- [수정] 필터 파라미터 이름을 컨트롤러와 매퍼에 맞게 fac 접두어로 변경함 --%>
                            <label><input type="checkbox" name="facParking" value="1" ${facParking == 1 ? 'checked' : ''}> 주차 가능</label>
                            <label><input type="checkbox" name="facH24" value="1" ${facH24 == 1 ? 'checked' : ''}> 24시간 운영</label>
                            <label><input type="checkbox" name="facPet" value="1" ${facPet == 1 ? 'checked' : ''}> 반려동물 동반</label>
                            <label><input type="checkbox" name="facWifi" value="1" ${facWifi == 1 ? 'checked' : ''}> 기가 와이파이</label>
                            <label><input type="checkbox" name="facCoffee" value="1" ${facCoffee == 1 ? 'checked' : ''}> 무료 커피/간식</label>
                            <label><input type="checkbox" name="facPrinter" value="1" ${facPrinter == 1 ? 'checked' : ''}> 프린터 이용</label>
                            <label><input type="checkbox" name="facLocker" value="1" ${facLocker == 1 ? 'checked' : ''}> 개인 사물함</label>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="width: 100%; padding: 12px; background: #007A8A; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">필터 적용하기임</button>
                    <a href="${pageContext.request.contextPath}/branch/search" style="display: block; text-align: center; margin-top: 15px; color: #999; font-size: 13px; text-decoration: none;">필터 초기화임</a>
                </form>
            </div>
        </aside>

        <%-- [우측: 지점 리스트 출력 영역] --%>
        <section class="branch-list-content" style="flex-grow: 1;">
            <c:choose>
                <c:when test="${empty branches}">
                    <div class="no-result" style="text-align: center; padding: 80px 20px; border: 2px dashed #eee; border-radius: 12px;">
                        <i class="fa-regular fa-circle-question" style="font-size: 50px; color: #ddd; margin-bottom: 20px;"></i>
                        <h3 style="color: #666;">검색 조건에 맞는 지점이 없습니다.</h3>
                        <p style="color: #999;">다른 검색어나 필터를 선택해 보세요.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="branch-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px;">
                        <c:forEach var="branch" items="${branches}">
                            <div class="branch-card" style="background: #fff; border: 1px solid #eee; border-radius: 12px; overflow: hidden; transition: transform 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">

                                <%-- [수정] branch.b_file -> branch.brnFile 로 변경함 --%>
                                <div class="branch-img" style="height: 200px; background: #f0f0f0; position: relative;">
                                    <c:choose>
                                        <c:when test="${not empty branch.brnFile}">
                                            <img src="${branch.brnFile}" style="width: 100%; height: 100%; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #ccc;">
                                                <i class="fa-solid fa-image" style="font-size: 30px;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span style="position: absolute; top: 15px; left: 15px; background: rgba(0,122,138,0.8); color: white; padding: 4px 10px; border-radius: 20px; font-size: 12px;">영업중임</span>
                                </div>

                                <div class="branch-info" style="padding: 20px;">
                                    <%-- [수정] branch.b_name -> branch.brnName 로 변경함 --%>
                                    <h3 style="margin: 0 0 10px 0; font-size: 20px; color: #333;">${branch.brnName}</h3>
                                    <%-- [수정] branch.b_address -> branch.brnAddress 로 변경함 --%>
                                    <p style="color: #777; font-size: 14px; margin-bottom: 15px; display: flex; align-items: center; gap: 5px;">
                                        <i class="fa-solid fa-location-dot" style="color: #007A8A;"></i> ${branch.brnAddress}
                                    </p>

                                    <%-- 시설 아이콘 영역 [수정] f_wifi -> facWifi 처럼 모든 시설명을 fac 접두어로 변경함 --%>
                                    <div class="facility-icons" style="display: flex; gap: 10px; margin-bottom: 20px; color: #bbb; font-size: 16px;">
                                        <c:if test="${branch.facWifi == 1}"><i class="fa-solid fa-wifi" title="와이파이" style="color: #007A8A;"></i></c:if>
                                        <c:if test="${branch.facParking == 1}"><i class="fa-solid fa-car" title="주차가능" style="color: #007A8A;"></i></c:if>
                                        <c:if test="${branch.facCoffee == 1}"><i class="fa-solid fa-mug-hot" title="무료커피" style="color: #007A8A;"></i></c:if>
                                        <c:if test="${branch.facH24 == 1}"><i class="fa-solid fa-clock" title="24시간" style="color: #007A8A;"></i></c:if>
                                        <c:if test="${branch.facPet == 1}"><i class="fa-solid fa-paw" title="반려동물" style="color: #007A8A;"></i></c:if>
                                    </div>

                                    <%-- [수정] b_idx -> brnIdx 로 파라미터명을 변경함 --%>
                                    <a href="${pageContext.request.contextPath}/branch/detail?brnIdx=${branch.brnIdx}" class="btn-detail" style="display: block; text-align: center; border: 1px solid #007A8A; color: #007A8A; padding: 10px; border-radius: 6px; text-decoration: none; font-weight: bold; transition: all 0.3s;">
                                        상세보기 및 예약임
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </div>
</main>

<style>
    .branch-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
    .btn-detail:hover { background: #007A8A; color: white !important; }
</style>

<%@ include file="../layout/footer.jsp" %>

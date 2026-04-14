

# 프로젝트 규칙


## 절대 수정 금지 폴더/파일
- src/main/webapp/WEB-INF/views/auth/
- src/main/webapp/WEB-INF/views/member/ → 팀원 A 담당
- src/main/webapp/WEB-INF/views/partner/
- src/main/webapp/WEB-INF/views/layout/
- src/main/webapp/WEB-INF/views/common/
- src/main/webapp/WEB-INF/views/branch/
- src/main/webapp/WEB-INF/views/map/ 
- src/main/resources/static/→ 팀원 B 담당


## 내가 담당하는 영역
- src/main/webapp/WEB-INF/views/detail/
- src/main/java/org.study.project05/reservation/user/
- src/main/java/org.study.project05/review/
- src/main/java/org.study.project05/branch/controller/spaceController
- src/main/java/org.study.project05/branch/mapper/BranchImgMapper
- src/main/java/org.study.project05/branch/mapper/FacilityMapper
- src/main/java/org.study.project05/branch/mapper/SpaceBranchMapper
- src/main/java/org.study.project05/space/
- src/main/java/org.study.project05/common/badword
-src/main/resources/mappers/UserReservationMapper.xml
-src/main/resources/mappers/SpaceBranchMapper.xml 
-src/main/resources/mappers/ReviewMapper.xml
-src/main/resources/mappers/BranchMapper.xml 에서 getAllBranches 부분만
-src/main/resources/mappers/FacilityMapper.xml
-src/main/resources/mappers/BranchImgMapper.xml
-src/main/resources/mappers/ContactMapper.xml

## 코드 규칙
- Java 파일 수정 후 반드시 알려줄 것
- DB 스키마는 절대 변경하지 말 것

## 사용자 설명
3개월정도 배우고 처음 클로드코드를 혼자 써보다가 이제막 팀원과협업하는상태 어렵다 판단되는 코드일경우 상세한주석 필요
현재 프로젝트를 합치는 상황인데 필요한경우 planmode로 팀원과 내 프로젝트를 합치는게 가능함 
추가적으로 결제기능과 예약완료시 푸싱 메시지나 이메일을 보내는 기능을 구현하고싶음



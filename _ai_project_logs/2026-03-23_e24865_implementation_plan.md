# Implement Review List Page

The user wants to add a "See All Reviews" link to the review section and create a dedicated "이용후기" (Review List) page based on a reference design (`review_list.html`).

## Proposed Changes

### [Backend] IndexController.java

#### [MODIFY] [IndexController.java](file:///d:/dev/springmvc/myproject102/src/main/java/org/study/myproject102/IndexController.java)
- Add `@GetMapping("/review-list")` mapping to return "review_list".

### [UI] index.jsp

#### [MODIFY] [index.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/index.jsp)
- Add "전체 후기 보기" link next to the "Members' Reviews" title.
- Link it to `${pageContext.request.contextPath}/review-list`.

### [UI] review_list.jsp [NEW]

#### [NEW] [review_list.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/review_list.jsp)
- Design a premium Review List page matching the project's aesthetic (Dark Green/Teal):
    - **Rating Summary**: Visual score (4.8) and star breakdown.
    - **Keyword Chips**: Styled tags for common praise.
    - **Filter/Sort Options**: Clean tabs and dropdowns.
    - **Photo Gallery**: Featured photo reviews in a grid.
    - **Review List**: Detailed cards with user icons, ratings, and locations.
    - **Footer**: Unified project footer.

## Verification Plan

### Automated Tests
- Navigate to `/review-list` and verify UI consistency.
- Check navigation from `index.jsp` to `review_list.jsp`.
- Verify the layout responsiveness (desktop/mobile).

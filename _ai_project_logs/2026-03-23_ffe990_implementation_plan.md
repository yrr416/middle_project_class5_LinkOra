# Implementation Plan - Login Page

Create a premium, modern login page for the WorkSpace project.

## Proposed Changes

### [Backend]
#### [MODIFY] [IndexController.java](file:///d:/dev/springmvc/myproject102/src/main/java/org/study/myproject102/IndexController.java)
- Add a `@GetMapping("/login")` method mapping to the `login` view.

### [Frontend]
#### [NEW] [login.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/login.jsp)
- Create a new JSP file with a split-screen layout.
- Use Tailwind CSS and existing `index.css` design tokens.
- Include:
  - WorkSpace logo.
  - Email/Password form with floating labels.
  - "Remember Me" checkbox.
  - "Find Password" and "Sign Up" links.
  - Social login placeholders (Google, Kakao).
  - A beautiful background image from Unsplash.

#### [MODIFY] [index.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/index.jsp)
#### [MODIFY] [desk_office.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/desk_office.jsp)
#### [MODIFY] [review_list.jsp](file:///d:/dev/springmvc/myproject102/src/main/webapp/WEB-INF/views/review_list.jsp)
- Update the "로그인" (Login) buttons to point to `${pageContext.request.contextPath}/login`.

## Verification Plan
- Access `/login` in the browser.
- Check the layout on different screen sizes (responsive).
- Verify that navigation from other pages correctly leads to the login page.

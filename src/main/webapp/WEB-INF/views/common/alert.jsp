<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알림</title>
    <script>
        alert('${msg}');
        location.href = '${pageContext.request.contextPath}${url}';
    </script>
</head>
<body>
</body>
</html>

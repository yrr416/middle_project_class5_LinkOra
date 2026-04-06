<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Project 05 - Home</title>
<style>
    body { font-family: 'Malgun Gothic', 'Arial', sans-serif; background-color: #f4f7f6; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
    .container { text-align: center; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border: 1px solid #e0e0e0; }
    h1 { color: #2c3e50; margin-bottom: 20px; font-weight: bold; }
    p { color: #7f8c8d; font-size: 1.1em; line-height: 1.6; }
    .badge { display: inline-block; padding: 8px 16px; background-color: #3498db; color: white; border-radius: 50px; font-size: 0.9em; margin-top: 15px; }
</style>
</head>
<body>
    <div class="container">
        <h1>🚀 Project 05 Start!</h1>
        <p>Shared Office Service Project가 성공적으로 시작되었습니다.</p>
        <div class="badge">Team 5 - Core Project Environment Hooked</div>
    </div>

    <!-- 챗봇 컴포넌트 포함 -->
    <jsp:include page="common/chatbot.jsp" />
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String x = (String)(session.getAttribute("x") == null);
		if(result.equals("success")) {
	%>
		<div>로그인 상태에서 보이는 페이지</div>
	<%
		} else {
	%>
		<div>비로그인 상태에서 보이는 페이지</div>
	<%			
		}
	%>
	
	
</body>
</html>
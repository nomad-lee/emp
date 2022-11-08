<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; clear:right; padding-top:50px; font-size:84px;}
	body { background-color:#196F3D;}
	td { color:white;}
</style>
</head>
<body>
	<h1>INDEX</h1>
	<ol>
		<li><img src="<%=request.getContextPath()%>/img/starbucks.png"></button></li>
		<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></li>
	</ol>
</body>
</html>
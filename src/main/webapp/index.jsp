<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Index</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; clear:right; padding-top:50px; font-size:84px;}
	body { background-color:#196F3D;}
	img { transition: all 0.5s linear; display:block; margin:auto; width:250px;}
	img:hover { transform: rotateY( 180deg )} /* CSS 애니메이션 */
	a:link { color:black; text-decoration: none; font-family: 'Gowun Dodum', sans-serif;}
</style>
</head>

<body>
	<div class="container">
	 	<img class="pt-3" src="<%=request.getContextPath()%>/img/starbucks.png"/>
	</div>
	<h1 class="text-center">INDEX</h1>
	<ol class="list-group px-5 fw-bold"> <!-- list-group-numbered 넘버링 가능 -->
		<li class="list-group-item list-group-item-action list-group-item-dark text-center">
			<a class="btn btn-sm text-dark fs-4" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a>
		</li>
	</ol>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Department</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; clear:right; padding-top:50px;}
	body { background-color:#196F3D;}
	td { color:white;}
	input { width:300px; }
</style>
</head>
<body>
	<h1 class="text-center">INSERT LIST</h1>
	<div class="container">
		<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
			<table class = "table">
				<tr>
					<td class = "col-md-2 text-center">부서번호</td>
					<td class = "col-md-8"><input type="text" name="deptNo" placeholder="4자리 이내 입력"></td>
				</tr>
				<tr>
					<td class = "col-md-2 text-center">부서이름</td>
					<td class = "col-md-8"><input type="text" name="deptName"></td>
				</tr>			
				<tr>
					<td class="text-center" colspan="2">
						<button class="btn btn-dark btn-lg" type="submit">부서추가</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>
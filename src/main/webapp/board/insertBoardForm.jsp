<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Board</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; clear:right; padding-top:50px; font-size: 40px;}
	body { background-color:#196F3D;}
	input { width:300px;}
</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="text-center mb-5" >POSTING</h1>
	<!-- msg parameter값이 있으면 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<div><%=request.getParameter("msg")%></div> <!-- 제목을 입력하시오, 내용을 입력하시오 -->
	<%
		}
	%>
	
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table class = "table">
				<div class="form-floating mb-3">
				  <input type="text" class="form-control" id="floatingInput" placeholder="제목을 입력하시오" name="boardTitle">
				  <label for="floatingInput">제목</label>
				</div>
				<div class="form-floating mb-3">
				  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="boardContent"></textarea>
				  <label for="floatingTextarea">내용</label>
				</div>
				<div class="row g-2">
					<div class="form-floating col-md-8">
					  <input type="text" class="form-control" id="floatingInput" placeholder="Writer"  name="boardWriter">
					  <label for="floatingInput">작성자</label>
					</div>
					<div class="form-floating col-md">
					  <input type="password" class="form-control" id="floatingInput" placeholder="Password" name="boardPw">
					  <label for="floatingInput">비밀번호</label>
					</div>
				</div>
			</table>
			<div class="text-center">
				<button class="btn btn-light btn-lg center" type="submit">작성완료</button>
			</div>			
		</form>
	</div>
</body>
</html>
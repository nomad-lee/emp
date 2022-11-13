<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	String createdate = request.getParameter("createdate");
	System.out.println(boardNo+""+commentNo+""+createdate+"수정삭제");
%>    
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
	#msg { color:red; font-size: 20px;}
</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="text-center mb-5" >UPDATE OR DELETE COMMENT</h1>
	<!-- msg parameter값이 있으면 출력 -->
	<%
		String msg = request.getParameter("commentMsg");
		if(msg != null) {
	%>
			<div class="text-red text-center" id="msg"><%=msg%></div>
	<%
		}
	%>
	
	<div class="container">	
		<form name="form" method="post">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
			<table class = "table">
				<div class="form-floating my-3">
				  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="commentContent"><%=commentContent%></textarea>
				  <label for="floatingTextarea">내용</label>
				</div>
				<div class="row g-2">
					<div class="form-floating col-md">
						<input type="text" class="form-control" id="floatingInput" placeholder="Today" name="createdate" value="<%=createdate%>" readonly>
						<label for="floatingInput">생성날짜</label>
					</div>					
					<div class="form-floating col-md">
						<input type="password" class="form-control" id="floatingInput" placeholder="password" name="commentPw">
						<label for="floatingInput">비밀번호</label>
					</div>
				</div>					
				<div class="mt-3 text-center">
					<input class="btn btn-dark btn-lg center" type="submit" value="수정" onclick="javascript: form.action='<%=request.getContextPath()%>/board/updateCommentAction.jsp';"/>
   					<input class="btn btn-danger btn-lg center" type="submit" value="삭제" onclick="javascript: form.action='<%=request.getContextPath()%>/board/deleteCommentAction.jsp';"/>
				</div>
			</table>
		</form>
	</div>
</body>
</html>



		
					
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*"%>

<%
	//1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg"); // 수정실패 시 리다이렉트 때에는 null값이 아니고 메세지 있음

	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BoardOne</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; padding-top:50px; font-size: 40px;}
	body { background-color:#196F3D;}
	#msg { color:red; font-size: 20px;}

</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="text-center mb-5">DELETE POST</h1>
	<%
		if(msg != null) {
	%>
		<div class="text-red text-center" id="msg"><%=msg%></div>
	<%      
		}
	%>	
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
			<table class = "table">
				<div class="row g-2">
					<div class="form-floating col-md-2">
					  <input type="text" class="form-control" id="floatingInput" placeholder="Num"  name="boardNo" value="<%=board.boardNo%>" readonly>
					  <label for="floatingInput">번호</label>
					</div>
					<div class="form-floating col-md">
					  <input type="text" class="form-control" id="floatingInput" placeholder="제목을 입력하시오" name="boardTitle" value="<%=board.boardTitle%>" readonly>
					  <label for="floatingInput">제목</label>
					</div>
				</div>
				<div class="form-floating my-3">
				  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="boardContent" readonly><%=board.boardContent%></textarea>
				  <label for="floatingTextarea">내용</label>
				</div>
				<div class="row g-2">
					<div class="form-floating col-md-8">
					  <input type="text" class="form-control" id="floatingInput" placeholder="Writer" name="boardWriter" value="<%=board.boardWriter%>" readonly>
					  <label for="floatingInput">작성자</label>
					</div>
					<div class="form-floating col-md">
					  <input type="password" class="form-control" id="floatingInput" placeholder="Password" name="boardPw">
					  <label for="floatingInput">비밀번호</label>
					</div>
				</div>
			</table>
			<div class="text-center">
				<button type="submit" class="btn btn-light btn-lg center">삭제확정</button>
			</div>
		</form>
	</div>
</body>
</html>
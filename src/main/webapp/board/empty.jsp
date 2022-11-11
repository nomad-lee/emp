<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "vo.*"%>

<%
	//1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	System.out.println(board.boardNo+"ONE"); //디버깅 코드
	
	/* 이슈) 댓글도 페이징 필요 LIMIT ?, ? */
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	//3

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
	h2 { font-family: 'Nanum Gothic Coding', monospace; color:white; padding-top:50px; font-size: 30px;}
	body { background-color:#196F3D;}
	th { font-family: 'Nanum Gothic Coding', monospace; color:white;}
	td { color:white;}
	button#insertcomment {vertical-align: middle;} /* 폼 컨트롤 글자 수직 가운데 정렬 이슈 */

</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="text-center mb-5">POST DETAIL</h1>
	
	<div class="container">
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
				  <input type="text" class="form-control" id="floatingInput" placeholder="Today" name="today" value="<%=board.createdate%>" readonly>
				  <label for="floatingInput">생성날짜</label>
				</div>
			</div>
		</table>
		<div class="text-center">
			<a class="btn btn-dark btn-lg center" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
			<a class="btn btn-danger btn-lg center" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a>
		</div>
		<!-- 댓글 -->
		<div class="container">
			<h2 class="text-center mb-3">댓글입력</h2>			
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<table class = "table">
					<div class="form-floating my-3">
					  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="commentContent"></textarea>
					  <label for="floatingTextarea">내용</label>
					</div>
					<div class="row g-2">
						<div class="form-floating col-md">
						  <input type="text" class="form-control" id="floatingInput" placeholder="password" name="commentPw">
						  <label for="floatingInput">비밀번호</label>
						</div>						
						<div class="form-floating col-md-2 text-center">
							<button class="form-control btn btn-dark btn-lg" id="insertcomment" type="submit">댓글입력</button>
						</div>
					</div>
				</table>
			</form>
		</div>		
		<!-- ------------------------------------------------------------------ -->
		<div>
			<div class = "container">		
				<h2 class="text-center mb-3">댓글목록</h2>
				<table class="table">
					<tr class = "bg-dark text-center">
						<th class="col-md-1">번호</th>
						<th>제목</th>
					</tr>
					<%
						for(Comment c : commentList) {
					%>
					<tr>
						<td class="text-center fw-bold"><%=c.commentNo%></td>
						<td><%=c.commentContent%></td>
					</tr>
					<%
						}
					%>
					
				</table>
			</div>		
		</div>
	</div>
</body>
</html>
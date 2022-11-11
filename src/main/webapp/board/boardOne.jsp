<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*"%>
<%
	//1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int currentPage = 1; //댓글 페이징에 사용할 현재 페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2	
	final int ROW_PER_PAGE = 5; // 상수 선언 문법
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
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
	

	// 2-1 페이징
	String cntSql = "SELECT COUNT(*) cnt FROM comment WHERE board_no = ?";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, board.boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); //Math.ceil올림
		
	//2-2
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, board.boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, ROW_PER_PAGE);
	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		c.createdate = boardRs.getString("createdate");
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
		<!-- 댓글입력 -->
		<div class="container">
			<h2 class="text-center mb-3">댓글입력</h2>			
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<table class = "table">
					<div class="form-floating my-3">
					  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="commentContent"></textarea>
					  <label for="floatingTextarea">내용</label>
					</div>
					<div class="row g-2">
						<div class="form-floating col-md">
						  <input type="password" class="form-control" id="floatingInput" placeholder="password" name="commentPw">
						  <label for="floatingInput">비밀번호</label>
						</div>						
						<div class="form-floating col-md-2 text-center">
							<button class="form-control btn btn-dark btn-lg" id="insertcomment" type="submit">댓글입력</button>
						</div>
					</div>
				</table>
			</form>			
		<!-- msg parameter값이 있으면 출력 -->
		<%
			if(request.getParameter("commentMsg") != null) {
		%>
				<div><%=request.getParameter("commentMsg")%></div>
		<%
			}
		%>
		</div>		
		<!-- 댓글목록 -->
		<div>
			<div class = "container">		
				<h2 class="text-center mb-3">댓글목록</h2>				
				<!-- msg parameter값이 있으면 출력 -->
				<%
					if(request.getParameter("commentDeleteMsg") != null) {
				%>
						<div><%=request.getParameter("commentDeleteMsg")%></div>
				<%
					}
				%>
				<table class="table">
					<tr class = "bg-dark text-center">
						<th class="col-md-1">번호</th>
						<th>내용</th>
						<th class="col-md-1">작성일</th>
						<th class="col-md-1">삭제</th>
					</tr>
					<%
						for(Comment c : commentList) {
					%>
					<tr>
						<td class="text-center fw-bold"><%=c.commentNo%></td>
						<td><%=c.commentContent%></td>
						<td><%=c.createdate%></td>
						<td><a type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteCommentModal" href="<%=request.getContextPath()%>/board/deleteCommentAction?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">삭제</a></td>
						<!-- 팝업으로 댓글삭제 처리 -->
						<div class="modal fade" id="deleteCommentModal" aria-hidden="true">
						  <div class="modal-dialog">
						    <div class="modal-content">
						      <div class="modal-header">
						        <h5 class="modal-title" id="deleteCommentLabel">비밀번호 확인 : &nbsp;</h5>
						        
						        <form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
						          <div>
									<input type="hidden" name="commentNo" value="<%=c.commentNo%>">
						            <input type="password" class="form-control" id="floatingInput" placeholder="Password" name="commentPw"> <!-- 비번 -->
						          </div>
						        </form>
						        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						      </div>
						      <div class="modal-footer">
						        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
						        <button type="button" class="btn btn-primary">확인</button>
						      </div>
						    </div>
						  </div>
						</div>						
						<!--  -->
					</tr>
					<%
						}
					%>
					
				</table>
			</div>				
			<div class = "container">
				<!--3.2 페이징코드 -->
				<nav aria-label="pagiantion">
			  		<ul class="pagination justify-content-center">
			  			<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.boardNo%>&currentPage=1%>">처음으로</a>
						</li>
						<%
							if(currentPage > 1) {
						%>
							<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.boardNo%>&currentPage=<%=currentPage-1%>">이전</a>		
							</li>
						<%
							}
							if(currentPage < lastPage) {
						%>
							<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.boardNo%>&currentPage=<%=currentPage+1%>">다음</a>		
							</li>
						<%
							}
						%>
						<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.boardNo%>&currentPage=<%=lastPage%>">마지막</a>
						</li>
					</ul>
				</nav>		
			</div>
		</div>
	</div>
	<script> //아직 미구현
		const btn = document.querySelector('#insertcomment')
		btn.addEventListener('click',function(){
	 	 window.scrollBy({left:0, bottom:0})
	})
	</script>
</body>
</html>
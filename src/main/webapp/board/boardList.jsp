<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 상수 선언 문법
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	// 2-1
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); //Math.ceil올림
		
	// 2-2
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	while(listRs.next()) {
		Board board = new Board();
		board.boardNo = listRs.getInt("boardNo");
		board.boardTitle = listRs.getString("boardTitle");
		boardList.add(board);
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; padding-top:50px; font-size: 40px;}
	th { font-family: 'Nanum Gothic Coding', monospace; color:white;}
	body { background-color:#196F3D;}
	td { color:white;}
	a#board1:link { color:white;} /* id선택자 #으로 사용 */
	a#board1:visited { color:white;}

</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class = "container">		
		<h1 class="text-center">GENERAL FORUM</h1>
		<div align="right">
			<a class="btn btn-secondary" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">게시글 추가</a>
		</div>	
		<!-- 3. 모델데이터(ArrayList<Board>) 출력 -->
		<table class="table">
			<tr class = "bg-dark text-center">
				<th class="col-sm-2">번호</th>
				<th>제목</th>
			</tr>
			<%
				for(Board board : boardList){
			%>
			<tr>
				<td class="text-center fw-bold"><%=board.boardNo%></td>
				<!-- 제목 클릭시 상세보기 이동 -->
				<td>
					<a class="text-decoration-none" id="board1" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=board.boardNo%>">
						<%=board.boardTitle%>
					</a>						
				</td>
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
				<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1%>">처음으로</a>
				</li>
				<%
					if(currentPage > 1) {
				%>
					<li class="page-item">
					<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>		
					</li>
				<%
					}
					if(currentPage < lastPage) {
				%>
					<li class="page-item">
					<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>		
					</li>
				<%
					}
				%>
				<li class="page-item">
				<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
				</li>
			</ul>
		</nav>		
	</div>
</body>
</html>
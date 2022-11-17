<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//1. 요청분석
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색	
	request.setCharacterEncoding("UTF-8");
	String word = null;
	if(request.getParameter("word") == null){
		word = "";
		System.out.println(word+"null");
	} else {
		word = request.getParameter("word");
		System.out.println(word+"값");
	}
	
	//오름차순, 내림차순
	String sort = "ASC";
	if(request.getParameter("sort") !=null && request.getParameter("sort").equals("DESC")) {
		sort = "DESC";
	}
	//2.
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	int cnt = 0;	// 전체 행 개수

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	// 2-1. 마지막 페이지 구하기 위한 쿼리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null){	// null -> 전체 데이터 개수
		cntSql = "SELECT COUNT(*) cnt FROM board ORDER BY board_no ASC";
		if(sort.equals("DESC")) {
			cntSql = "SELECT COUNT(*) cnt FROM board ORDER BY board_no DESC";
		}
		cntStmt = conn.prepareStatement(cntSql);
	} else {	// 내용에 searchContent를 포함하는 게시글 개수 
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ? ORDER BY board_no ASC";
		if(sort.equals("DESC")) {
			cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ? ORDER BY board_no DESC";
		}
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}

	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = 0;
	if(cnt == 0){
		lastPage = 1;
	} else {
		lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	}
	System.out.println("현재 페이지 : " + currentPage);
	System.out.println("board 행의 수 : " + cnt);
	System.out.println("lastPage : " + lastPage);
	//현재 출력 된 내용 증 정렬
	// 2-2. 불러오기
	String listSql = null;
	PreparedStatement listStmt = null;
	if(word == null){ // null -> 전체 출력
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		if(sort.equals("DESC")) {
			listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?, ?";
		}
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	
	}else {	// 내용에 searchContent를 포함하는 게시글만 출력 
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		if(sort.equals("DESC")) {
			listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_content LIKE ? ORDER BY board_no DESC LIMIT ?, ?";
		}
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	ResultSet listRs = listStmt.executeQuery();

	//Board.class가 없다면
	ArrayList<HashMap<String, Object>> boardList = new ArrayList<HashMap<String, Object>>();
	while(listRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("boardNo", listRs.getInt("boardNo"));
		m.put("boardTitle", listRs.getString("boardTitle"));
		boardList.add(m);
	}
	
	/* 도메인 타입
	ResultSet listRs = listStmt.executeQuery();	// model source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // model new data
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}  */
	
	//메뉴눌러 접속 후 정렬 시 검색어에 null값 방지
	
	listRs.close();
	listStmt.close();
	conn.close(); //연결 종료
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
	td, div#currentPageNum, div#cntSearchRow { color:white;}
	a#board1:link, a#board1:visited { color:white;} /* id선택자 #으로 사용 */
	input#word { width:250px;}
	svg {color : red;}
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
				<th class="col-sm-2">번호
				<%
					if(sort.equals("ASC")){
				%>						
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage%>&sort=DESC&word=<%=word%>">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-sort-up" viewBox="0 0 16 16">
							<path d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.498.498 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707V12.5zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zM7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1h-3zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1z"/>
							</svg>
						</a>
				<%	
					} else {
				%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage%>&sort=ASC&word=<%=word%>">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-sort-down" viewBox="0 0 16 16">
							<path d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293V2.5zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zM7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1h-3zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1z"/>
							</svg>
						</a>
				<%	
					}
				%>
				</th>
				<th>제목</th>
			</tr>
			<%
				for(HashMap<String, Object> m : boardList){
			%>
			<tr>
				<td class="text-center fw-bold"><%=m.get("boardNo")%></td>
				<!-- 제목 클릭시 상세보기 이동 -->
				<td>
					<a class="text-decoration-none" id="board1" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=m.get("boardNo")%>">
						<%=m.get("boardTitle")%>
					</a>						
				</td>
			</tr>
			<%
				}
			%>
			
		</table>
	</div>
	<div class = "container">
		<div class="row">
			<div class="col text-start" id="currentPageNum">현재 페이지 : <%=currentPage%></div>
			<div class="col-7 text-end" id="cntSearchRow">검색결과를 포함한 행의 수 : <%=cnt%></div>
		</div>
		<!--3.2 페이징코드 -->
		<nav aria-label="pagiantion">
	  		<ul class="pagination justify-content-center mt-3">
	  		<%
	  			if(word == null){
	  		%>	  			
		  			<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&sort=<%=sort%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&sort=<%=sort%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&sort=<%=sort%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&sort=<%=sort%>">마지막</a>
					</li>
			<%
	  			} else {
	  		%>
	  				<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>&sort=<%=sort%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>&sort=<%=sort%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>&sort=<%=sort%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>&sort=<%=sort%>">마지막</a>
					</li>
	  		<%	  				
	  			}
			%>
			</ul>
		</nav>
		<!-- 부서명 검색창 -->
		<div class="d-flex justify-content-center mt-4">
			<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
				<div class="row">
					<div class="form-floating col-auto d-grid mx-auto">
					<%
						if (word == null) {
					%>
								<input type="text" class="form-control-sm" name="word" id="word" placeholder="찾을 내용을 입력">
			
					<%
						} else {
					%>
								<input type="text" class="form-control-sm" name="word" id="word" placeholder="찾을 내용을 입력" value="<%=word%>">
					<%
						}
					%>
					</div>
					<div class="col-auto">
			        	<button type="submit" class="btn btn-primary">검색</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
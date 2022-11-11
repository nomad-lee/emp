<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	//링크로 호출하지 않고 폼 주소창에 직접 호출 시 null값이 된다.
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, board_pw boardPw FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	
	ResultSet rs = stmt.executeQuery(); // 0행 or 1행
	
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
	}
	System.out.println(boardNo + "FORM"); //디버깅 코드
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Board</title>
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
	<h1 class="text-center mb-5" >UPDATE POST</h1>
	<!-- msg parameter값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div><%=msg%></div> <!-- 제목을 입력하시오, 내용을 입력하시오 -->
	<%
		}
	%>
	
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
			<table class = "table">				
				<div class="row g-2">
					<div class="form-floating col-md-2">
					  <input type="text" class="form-control" id="floatingInput" placeholder="Num"  name="boardNo" value="<%=boardNo%>" readonly>
					  <label for="floatingInput">번호</label>
					</div>
					<div class="form-floating col-md">
					  <input type="text" class="form-control" id="floatingInput" placeholder="제목을 입력하시오" name="boardTitle" value="<%=board.boardTitle%>">
					  <label for="floatingInput">제목</label>
					</div>
				</div>
				<div class="form-floating my-3">
				  <textarea class="form-control" id="floatingTextarea" style="height: 300px" placeholder="내용을 입력하시오" name="boardContent"><%=board.boardContent%></textarea>
				  <label for="floatingTextarea">내용</label>
				</div>
				<div class="row g-2">
					<div class="form-floating col-md-8">
					  <input type="text" class="form-control" id="floatingInput" placeholder="Writer"  name="boardWriter" value="<%=board.boardWriter%>">
					  <label for="floatingInput">작성자</label>
					</div>
					<div class="form-floating col-md">
					  <input type="password" class="form-control" id="floatingInput" placeholder="Password" name="boardPw">
					  <label for="floatingInput">비밀번호</label>
					</div>
				</div>
			</table>
			<div class="text-center">
				<button type="submit" class="btn btn-light btn-lg center">수정완료</button>
			</div>			
		</form>
	</div>
</body>
</html>
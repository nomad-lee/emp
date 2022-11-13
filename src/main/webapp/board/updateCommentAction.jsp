<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	String createdate = request.getParameter("createdate");
	System.out.println(commentNo+"수정액션");
	String commentPw = request.getParameter("commentPw");
	System.out.println(commentPw+"수정액션");
	// 링크로 호출하지 않고 폼 주소창에 직접 호출 시 null값이 된다.
	if(commentContent == null || commentPw == null || commentContent.equals("") || commentPw.equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?");
		return;
	}
	Comment c = new Comment();
	c.boardNo = boardNo;
	c.commentNo = commentNo;
	c.commentContent = commentContent;
	c.createdate = createdate;
	c.commentPw = commentPw;
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	String sql = "UPDATE comment SET comment_content=? WHERE (comment_no = ? AND comment_pw = ?)";
	PreparedStatement stmt = conn.prepareStatement(sql); //? 바인드 변수, 보안 및 성능에 도움
	stmt.setString(1, c.commentContent);
	stmt.setInt(2, c.commentNo);
	stmt.setString(3, c.commentPw);
	
	int row = stmt.executeUpdate(); // 반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+c.boardNo);
		System.out.println("수정성공");
	} else {
		String commentMsg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateDeleteCommentForm.jsp?boardNo="+c.boardNo+"&commentNo="+c.commentNo+"&commentContent="+c.commentContent+"&createdate="+c.createdate+"&commentMsg="+commentMsg);
		System.out.println("수정실패");
	}
	// 3. 결과
%>
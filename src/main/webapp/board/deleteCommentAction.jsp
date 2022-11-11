<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	String sql = "DELETE FROM comment WHERE (comment_no = ? AND comment_pw = ?)";
	//쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql); //? 바인드 변수, 보안 및 성능에 도움
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	
	System.out.println(request.getParameter("commentNo"));
	System.out.println(commentPw);
	
	//쿼리 실행결과
	int row = stmt.executeUpdate(); // 반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
	    response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+commentNo+"commentPw"+commentPw);
		System.out.println("삭제성공");
	} else {
		String commentDeleteMsg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+commentNo+"&commentDeleteMsg="+commentDeleteMsg+"commentPw"+commentPw);
		System.out.println("삭제실패");
	}
	// 3. 결과
%>
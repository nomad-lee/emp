<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%

	// 1. 요청분석
	//null값 방지, 입력 페이지로 다시 이동
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	Calendar createdate = Calendar.getInstance();
	
	if(boardTitle == null || boardContent == null || boardTitle.equals("") || boardContent.equals("")) {
		String msg = URLEncoder.encode("제목과 내용을 입력하시오", "utf-8"); //미입력 방지, get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	System.out.println(boardTitle);

	// 2. 요청처리
	//이미 존재하는 key(dept_no)와 동일 값이 입력되면 에러 발생 -> 
	
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	//String sql = "sql문"과 PreparedStatement로 분리될 필요가 있음
	String sql = "insert into board(board_title, board_content, board_writer, board_pw, createdate) values(?,?,?,?,curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql); //? 바인드 변수, 보안 및 성능에 도움
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate(); //반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>
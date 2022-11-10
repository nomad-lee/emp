<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String boardNo = request.getParameter("boardNo");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardNo + boardPw + "ACTION");
	// 링크로 호출하지 않고 폼 주소창에 직접 호출 시 null값이 된다.
	if(boardTitle == null || boardContent == null || boardWriter == null || boardPw == null || boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("") || boardPw.equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo); //dqptNo 정보가 없으면 Form에서 null값 입력됨
		return;
	}
	Board board = new Board();
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	board.boardWriter = boardWriter;
	board.boardPw = boardPw;
	
	//System.out.println(board.boardTitle);
	/* 예외 사항 발생 시 이전화면이나 알림 기능 추가*/
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	//비밀번호 체크
	String sql1 = "SELECT board_pw FROM board WHERE board_pw = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, board.boardPw);
	ResultSet rs = stmt1.executeQuery();
	
	if(rs.next()){ //rs객체에 저장된 데이터의 next 다음라인 값, boolean값 -> 존재유무 확인
	} else {
		String msg = URLEncoder.encode("비밀번호가 다릅니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo+"&boardPw="+boardPw); //여러 정보 동시에 전달 가능
		return;
	}
	
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	String sql2 = "UPDATE board SET board_title=?, board_content=?, board_writer=? where board_no=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2); //? 바인드 변수, 보안 및 성능에 도움
	stmt2.setString(1, board.boardTitle);
	stmt2.setString(2, board.boardContent);
	stmt2.setString(3, board.boardWriter);
	stmt2.setInt(4, board.boardNo);
	
	int row = stmt2.executeUpdate(); // 반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	// 3. 결과
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); /* getContextPath 플젝 경로 */
%>
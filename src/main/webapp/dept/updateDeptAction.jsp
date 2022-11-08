<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println(deptNo);
	/* 지정된 길이보다 길 경우, null 입력 등 예외 사항 발생 시 롤백이나 알림 기능 추가*/
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	PreparedStatement stmt = conn.prepareStatement("update departments set dept_name=? where dept_no=?"); //? 바인드 변수, 보안 및 성능에 도움
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate(); // 반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	// 3. 결과
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); /* getContextPath 플젝 경로 */
%>
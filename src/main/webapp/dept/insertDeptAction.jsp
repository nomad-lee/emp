<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%

	// 1. 요청분석
	//null값 방지, 입력 페이지로 다시 이동
	if(request.getParameter("deptNo") == null 
		|| request.getParameter("deptName") == null) {
		
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}
	
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println(deptNo);
	/* 지정된 길이보다 길 경우 롤백이나 알림 기능 추가*/

	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	PreparedStatement stmt = conn.prepareStatement("insert into departments(dept_no, dept_name) values(?,?)"); //? 바인드 변수, 보안 및 성능에 도움
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	int row = stmt.executeUpdate(); //반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.util.*" %> <!-- HashMap<키, 값>, ArrayList<요소> -->
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.util.ArrayList" %>
<%
	// 1) 요청분석
	// 페이징 currentPage
	
	// 2) 요청처리
	// 페이징 rowPerPage
	// db연결 -> 모델생성
	final int rowPerPage = 10;
	int beginRow = 0;
	Class.forName("org.mariadb.jdbc.Driver"); //driver
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // 프로토콜://주소:포트번호, db아이디, db비번
	String sql = "SELECT s.emp_no empNo, s.from_date fromDate, CONCAT(e.first_name, e.last_name) FROM salaries s INNER JOIN employees e ON s.emp_no=e.emp_no ORSER BY ASC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<String, Object> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("enumNo", rs.getInt("empNo"));
		m.put("fromDate", rs.getInt("fromDate"));
		m.put("name", rs.getInt("name"));
				
	}
	rs.close();
	stmt.close();
	conn.close(); //연결 종료
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>salaryMapList</title>
</head>
<body>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//요청처리// 자바프로그램--JDBC API--JDBC DRIVER--RDBMS
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // DB 연결
	System.out.println(conn); // 연결 확인용 디버깅
	
	//요청처리// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	PreparedStatement stmt = conn.prepareStatement("select dept_no deptNo, dept_name deptName from departments order by dept_no desc limit 0, 20");
	//출력// 쿼리 실행--반환된 데이터 저장
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { //ResultSet의 API를 알아야 사용 가능한 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Department List</title>
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
	img { display:block; margin:auto; width:120px; float:left; padding-top:5px; position:absolute;}
</style>

</head>
<body>
	<div class = "container">
	<div>
		<img src="<%=request.getContextPath()%>/img/starbucks.png">
	</div>
	<h1 class="text-center">DEPT LIST</h1>
	<div align="right">
		<a class="btn btn-light" href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
	</div>		
		<table class = "table">
			<tr class = "bg-dark text-center">
				<th class = "col-md-2">부서번호</th>
				<th class = "col-md-8">부서이름</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		<%
			for(Department d : list) { // 자바문법에서 제공하는 foreach문
		%>
				<tr>
					<td class="fw-bold text-center"><%=d.deptNo%></td>
					<td><%=d.deptName%></td>
					<td><a class="btn btn-dark me-0" style="float:right;" href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
					<td><a class="btn btn-danger" style="float:right;" href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
				</tr>
		<%	
			}
		%>
		</table>
	</div>
	<footer class="footer text-center mt-4" style="color:white">
		<span>ⓒ 2022 Starbucks Coffee Company. All Rights Reserved.</span>
	</footer>
</body>
</html>
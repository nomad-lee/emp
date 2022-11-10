<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//2
	int rowPerPage = 10;
	
	
	
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String countSql = "select count(*) from employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("count(*)");
	}
	
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage++;
	}
	
	//한 페이지당 출력할 emp목록
	String empSql = "select emp_no empNo, first_name firstName, last_name lastName from employees order by emp_no asc limit ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee List</title>
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
	a.page-item:visited { color:white;}

</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class = "container">
		
		<h1 class="text-center">EMPLOYEES LIST</h1>
		
		<div class="text-white">현재 페이지 : <%=currentPage %></div>
		
		<table class = "table">
			<div class="row justify-content-md-center">
			<tr class = "bg-dark text-center">
				<th class = "col-3">사원이름</th>
				<th>퍼스트네임</th>
				<th>라스트네임</th>
			</tr>
			</div>
			<%
				for(Employee e : empList) {
			%>
					<tr>
						<td class = "text-center"><%=e.empNo %></td>
						<td><a href=""><%=e.firstName %></a></td>
						<td><%=e.lastName %></td>
					</tr>
			<%
				}
			%>
		</table>
	</div>
	
	<div class = "container">
		<!-- 페이징코드 -->
		<nav aria-label="pagiantion">
  		<ul class="pagination justify-content-center">
  			<li class="page-item">
			<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1%>">처음으로</a>
			</li>
			<%
				if(currentPage > 1) {
			%>
				<li class="page-item">
				<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>		
				</li>
			<%
				}
				if(currentPage < lastPage) {
			%>
				<li class="page-item">
				<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>		
				</li>
			<%
				}
			%>
			<li class="page-item">
			<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
			</li>
		</ul>
		</nav>		
	</div>
</body>
</html>
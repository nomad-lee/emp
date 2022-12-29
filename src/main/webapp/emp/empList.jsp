<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//1. 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	//페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println(request.getParameter("currentPage"));
	}
	// 2
	int rowPerPage = 10;
	int cnt = 0;
	
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null){
		cntSql = "SELECT COUNT(*) cnt FROM employees";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt from employees WHERE first_name LIKE ? OR last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}	
	
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0) {
		lastPage++;
	}

	//2.2
	String empSql = null;
	PreparedStatement empStmt = null;
	if(word == null) {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage - 1));
		empStmt.setInt(2, rowPerPage);
		System.out.println(word+"참참");
	} else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setString(2, "%"+word+"%");
		empStmt.setInt(3, rowPerPage * (currentPage - 1));
		empStmt.setInt(4, rowPerPage);
		System.out.println(word+"거짓");
	}
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	} 
	/* 도메인 타입
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}  */	
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
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; padding-top:50px; padding-bottom:40px; font-size: 40px;}
	th { font-family: 'Nanum Gothic Coding', monospace; color:white;}
	body { background-color:#196F3D;}
	td, div#currentPageNum, div#cntSearchRow  { color:white;}
	a.page-item:visited { color:white;}
	input#word { width:250px;}
</style>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class = "container">		
		<h1 class="text-center">EMPLOYEES LIST</h1>		
		<table class = "table">
			<tr class = "bg-dark text-center">
				<th class = "col-2">사원번호</th>
				<th>퍼스트네임</th>
				<th>라스트네임</th>
			</tr>
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
		<div class="row">
			<div class="col text-start" id="currentPageNum">현재 페이지 : <%=currentPage%></div>
			<div class="col-7 text-end" id="cntSearchRow">검색결과를 포함한 행의 수 : <%=cnt%></div>
		</div>
		<!-- 페이징코드 -->
		<nav aria-label="pagiantion">
  			<ul class="pagination justify-content-center mt-3">
	  		<%
	  			if(word == null){
	  		%>	  			
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
			<%
	  			} else {
	  		%>
	  				<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
					</li>
	  		<%	  				
	  			}
			%>
			</ul>
		</nav>
		<!-- 사원번호 검색창 -->
		<div class="d-flex justify-content-center mt-4">
			<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
				<div class="row">
					<div class="form-floating col-auto d-grid mx-auto">
					<%
						if (word == null) {
					%>
								<input type="text" class="form-control-sm" name="word" id="word" placeholder="찾을 사원의 이름을 입력">
			
					<%
						} else {
					%>
								<input type="text" class="form-control-sm" name="word" id="word" placeholder="찾을 사원의 이름을 입력" value="<%=word%>">
			
					<%
						}
					%>
					</div>
					<div class="col-auto">
			        	<button type="submit" class="btn btn-primary">검색</button>
					</div>
				</div>
			</form>
		</div>	
	</div>
</body>
</html>
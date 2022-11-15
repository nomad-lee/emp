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
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	} else {		
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e. last_name LIKE ?";
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
	String salSql = null;
	PreparedStatement salStmt = null;
	if(word == null) {
		salSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		salStmt = conn.prepareStatement(salSql);
		salStmt.setInt(1, rowPerPage * (currentPage - 1));
		salStmt.setInt(2, rowPerPage);
		System.out.println(word+"참참");
	} else {
		salSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		salStmt = conn.prepareStatement(salSql);
		salStmt.setString(1, "%"+word+"%");
		salStmt.setString(2, "%"+word+"%");
		salStmt.setInt(3, rowPerPage * (currentPage - 1));
		salStmt.setInt(4, rowPerPage);
		System.out.println(word+"거짓");
	}
	ResultSet salRs = salStmt.executeQuery();
	
	ArrayList<Salary> salList = new ArrayList<Salary>();
	while(salRs.next()){
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = salRs.getInt("empNo"); //외래키라 객체에 넣어야
		s.salary = salRs.getInt("salary");
		s.fromDate = salRs.getString("fromDate");
		s.toDate = salRs.getString("toDate");
		s.emp.firstName = salRs.getString("firstName");
		s.emp.lastName = salRs.getString("lastName");
		salList.add(s);
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
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; padding-top:50px; padding-bottom:40px; font-size: 40px;}
	th { font-family: 'Nanum Gothic Coding', monospace; color:white;}
	body { background-color:#196F3D;}
	td, div#currentPageNum, div#cntSearchRow  { color:white; text-align:center;}
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
		<h1 class="text-center">SALARIES LIST</h1>		
		<table class = "table">
			<tr class = "bg-dark text-center">
				<th class = "col-2">사원번호</th>
				<th>연봉($)</th>
				<th>계약일자</th>
				<th>만료일자</th>
				<th>이름</th>
				<th>성</th>
			</tr>
			<%
				for(Salary s : salList) {
			%>
					<tr>
						<td><%=s.emp.empNo %></td>
						<td><%=s.salary %></td>
						<td><%=s.fromDate %></td>
						<td><%=s.toDate %></td>
						<td><%=s.emp.firstName %></td>
						<td><%=s.emp.lastName %></td>
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
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">마지막</a>
					</li>
			<%
	  			} else {
	  		%>
	  				<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
					</li>
	  		<%	  				
	  			}
			%>
			</ul>
		</nav>
		<!-- 사원 검색창 -->
		<div class="d-flex justify-content-center mt-4">
			<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
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
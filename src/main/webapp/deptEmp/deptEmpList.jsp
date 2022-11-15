<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "vo.*" %>
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
	//2-1
	final int rowPerPage = 10;
	int beginRow = 0;
	int cnt = 0;
	
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null){
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
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
	String deSql = null;
	PreparedStatement deStmt = null;
	if(word == null) {
		deSql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no	INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
		deStmt = conn.prepareStatement(deSql);
		deStmt.setInt(1, rowPerPage * (currentPage - 1));
		deStmt.setInt(2, rowPerPage);
		System.out.println(word+"참참");
	} else {
		deSql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		deStmt = conn.prepareStatement(deSql);
		deStmt.setString(1, "%"+word+"%");
		deStmt.setInt(2, rowPerPage * (currentPage - 1));
		deStmt.setInt(3, rowPerPage);
		System.out.println(word+"거짓");
	}
	ResultSet deRs = deStmt.executeQuery();

	//DeptEmp.class가 없다면
	ArrayList<HashMap<String, Object>> deList = new ArrayList<HashMap<String, Object>>();
	while(deRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", deRs.getInt("empNo"));
		m.put("firstName", deRs.getString("firstName"));
		m.put("deptName", deRs.getString("deptName"));
		m.put("fromDate", deRs.getString("fromDate"));
		m.put("toDate", deRs.getString("toDate"));
		deList.add(m);
	}
	/*
	//도메인 타입
	ArrayList<DeptEmp> deList = new ArrayList<DeptEmp>();
	while(deRs.next()){
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.dept = new Department();
		de.emp.empNo = deRs.getInt("empNo"); //외래키라 객체에 넣어야
		de.emp.firstName = deRs.getString("firstName"); //de테이블에 없는 데이터 가져오기 위함
		de.dept.deptName = deRs.getString("deptName"); //외래키라 객체에 넣어야
		de.fromDate = deRs.getString("fromDate");
		de.toDate = deRs.getString("toDate");
		deList.add(de);  
	}	*/
	
	deRs.close();
	deStmt.close();
	conn.close(); //연결 종료
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptEmpList</title>
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
		<h1 class="text-center">DEPT & EMPLOYEE LIST</h1>		
		<table class = "table">
			<tr class = "bg-dark text-center">
				<th class = "col-2">부서번호</th>
				<th>사원이름</th>
				<th>부서명</th>
				<th>계약일자</th>
				<th>만료일자</th>
			</tr>
			<%
				for(HashMap<String, Object> m : deList) {
			%>
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("firstName")%></td>
						<td><%=m.get("deptName")%></td>
						<td><%=m.get("fromDate")%></td>
						<td><%=m.get("toDate")%></td>
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
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막</a>
					</li>
			<%
	  			} else {
	  		%>
	  				<li class="page-item">
						<a id=pnav1 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음으로</a>
					</li>
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a id=pnav2 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>		
						</li>
					<%
						}
						if(currentPage < lastPage) {
					%>
						<li class="page-item">
							<a id=pnav3 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>		
						</li>
					<%
						}
					%>
					<li class="page-item">
						<a id=pnav4 class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
					</li>
	  		<%	  				
	  			}
			%>
			</ul>
		</nav>
		<!-- 사원번호 검색창 -->
		<div class="d-flex justify-content-center mt-4">
			<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post">
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	//링크로 호출하지 않고 폼 주소창에 직접 호출 시 null값이 된다.
	if(deptNo == null){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	PreparedStatement stmt = conn.prepareStatement("select dept_name deptName from departments where dept_no = ?");
	stmt.setString(1, request.getParameter("deptNo"));
	
	ResultSet rs = stmt.executeQuery(); // 0행 or 1행
	
	Department d = null;
	if(rs.next()) {
		d = new Department();
		d.deptNo = deptNo;
		d.deptName = rs.getString("deptName");
	}
	/* 
	if(rs.next()) {
		deptNo = rs.getString("deptNo");
		deptName = rs.getString("deptName");
	} */
	
	// 3. 출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Department</title>
	<!-- 구글 글꼴 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap" rel="stylesheet">
	<!-- 부트스트랩5 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h1 { font-family: 'Nanum Gothic Coding', monospace; color:white; clear:right; padding-top:50px; font-size: 40px;}
	body { background-color:#196F3D;}
	td { color:white;}
	input { width:300px; }
</style>
</head>
<body>	
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="text-center">UPDATE LIST</h1>
	<!-- msg parameter값이 있으면 출력 -->
	<%
		if(request.getParameter("msg") != null) {
	%>
			<div><%=request.getParameter("msg")%></div>
	<%
		}
	%>
	
	<div class="container">
		<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
			<table class = "table">
				<tr>
					<td class = "col-md-2 text-center">부서번호</td>
					<td class = "col-md-8"><input type="text" name="deptNo" value="<%=d.deptNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td class = "col-md-2 text-center">부서이름</td>
					<td class = "col-md-8"><input type="text" name="deptName" value="<%=d.deptName%>"></td>
				</tr>
			</table>			
			<div class="text-center">
				<button class="btn btn-dark btn-lg" type="submit">수정</button>
			</div>
		</form>
	</div>
</body>
</html>
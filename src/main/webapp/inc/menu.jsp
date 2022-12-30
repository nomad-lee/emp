<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
   	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	body { background-color:#196F3D;}
	a.nav-link:link { color:white;}
	a.nav-link:visited { color:white;}
	a.nav-link:hover { color:red;}
</style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a id="nav1" href="<%=request.getContextPath()%>/index.jsp" class="nav-link">홈으로</a>
	<!-- patitial jsp 페이지 -->
		<ul class="nav justify-content-end tx-white">
			<li class="nav-item">
				<a id="nav2" class="nav-link" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
			</li>
			<li class="nav-item">
				<a id="nav3" class="nav-link" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
			</li>	
			<li class="nav-item">
				<a id="nav4" class="nav-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp">연봉관리</a>
			</li>
			<li class="nav-item">
				<a id="nav5" class="nav-link" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
			</li>
			<li class="nav-item">
				<a id="nav6" class="nav-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">부서&사원 목록</a>
			</li>
		</ul>    
  </div>
</nav>



<nav id="navbar-example2" class="navbar bg-light px-3 mb-3">
  <a class="navbar-brand" href="#">Navbar</a>
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a class="nav-link" href="#scrollspyHeading1">First</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#scrollspyHeading2">Second</a>
    </li>
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Dropdown</a>
      <ul class="dropdown-menu">
        <li><a class="dropdown-item" href="#scrollspyHeading3">Third</a></li>
        <li><a class="dropdown-item" href="#scrollspyHeading4">Fourth</a></li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item" href="#scrollspyHeading5">Fifth</a></li>
      </ul>
    </li>
  </ul>
</nav>
</body>
</html>

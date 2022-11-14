<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "vo.Studnet" %>
<%
   // 1
   int currentPage = 1;
   if(request.getParameter("currentPage") != null) {
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   
   // 2
   int rowPerPage = 10;
   int beginRow = 0;
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
   /*
   SELECT s.emp_no empNo
      , s.salary salary
      , s.from_date fromDate
      , s.to_date toDate
      , e.first_name firstName 
      , e.last_name lastName
   from
   salaries s INNER JOIN employees e 
   ON s.emp_no = e.emp_no
   LIMIT ?, ?
   */
   String sql = "SELECT s.emp_mp empNo, s.salary salary, s.from_Date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
   PreparedStatement countStmt = conn.prepareStatement(sql);
   ResultSet rs = countStmt.executeQuery();
   ArrayList<Salary> salaryList = new ArrayList<>();
   while(rs.next()) {
      Salary s = new Salary();
      s.emp = new Employee(); // ☆☆☆☆☆
      s.emp.empNo = rs.getInt("empNo");
      s.salary = rs.getInt("salary");
      s.fromDate = rs.getString("fromDate");
      s.toDate = rs.getString("toDate");
      s.emp.firstName = rs.getString("firstName");
      s.emp.lastName = rs.getString("lastName");
      salaryList.add(s);
      
   }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<%
			for(salary s : salaryList){
		%>
			<tr>
				<td><%=s.emp.empNo %></td>
				<td><%=s.slary %></td>
				<td><%=fromDate %></td>
				<td><%=toDate %></td>
				<td><%=s.emp.firstName %></td>
				<td><%=s.emp.lastName %></td>
				<td><%= %></td>
			</tr>
		
		<%
			}
		%>
	</table>
   
</body>
</html>
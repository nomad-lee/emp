<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
   <h1>로그인</h1>
   <form action="<%=request.getContextPath()%>/loginAction.jsp">
      <table border="1">
         <tr>
            <td>ID</td>
            <td><input type="text" name="id"></td>
         </tr>
         <tr>
            <td>PW</td>
            <td><input type="password" name="pw"></td>
         </tr>
      </table>
      <button type="submit">로그인</button>
   </form>
</body>
</html>
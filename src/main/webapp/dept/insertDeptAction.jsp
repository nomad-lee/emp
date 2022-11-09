<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%

	// 1. 요청분석
	//null값 방지, 입력 페이지로 다시 이동
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하시오", "utf-8"); //미입력 방지, get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	System.out.println(deptNo);
	/* 지정된 길이보다 길 경우 롤백이나 알림 기능 추가*/

	// 2. 요청처리
	//이미 존재하는 key(dept_no)와 동일 값이 입력되면 에러 발생 -> 
	
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	//String sql = "sql문"과 PreparedStatement로 분리될 필요가 있음
	//부서이름, 부서번호 중복 방지
	String sql1 = "select * FROM departments where dept_no = ? OR dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){
		String msg = URLEncoder.encode("부서번호나 부서이름이 중복되었습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}	
	
	String sql3 = "insert into departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt3 = conn.prepareStatement(sql3); //? 바인드 변수, 보안 및 성능에 도움
	stmt3.setString(1, deptNo);
	stmt3.setString(2, deptName);
	
	int row = stmt3.executeUpdate(); //반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
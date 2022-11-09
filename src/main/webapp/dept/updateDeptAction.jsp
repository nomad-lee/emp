<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.Department" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // post방식에서 필수
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	// 링크로 호출하지 않고 폼 주소창에 직접 호출 시 null값이 된다.
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?deptNo="+deptNo); //dqptNo 정보가 없으면 Form에서 null값 입력됨
		return;
	}
	Department d = new Department();
	d.deptNo = deptNo;
	d.deptName = deptName;
	
	System.out.println(d.deptNo);
	/* 지정된 길이보다 길 경우, null 입력 등 예외 사항 발생 시 이전화면이나 알림 기능 추가*/
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	//부서이름 중복 방지
	String sql1 = "select dept_name FROM departments where dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, d.deptName);
	ResultSet rs = stmt1.executeQuery();
	
	if(rs.next()){ //rs객체에 저장된 데이터의 next 다음라인 값, boolean값 -> 존재유무 확인
		String msg = URLEncoder.encode("부서이름 중복", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg+"&deptNo="+d.deptNo+"&deptName="+d.deptName); //여러 정보 동시에 전달 가능
		return;
	}
	
	// 값 할당을 위해 (쿼리를)미리 준비하는 역할
	String sql2 = "update departments set dept_name=? where dept_no=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2); //? 바인드 변수, 보안 및 성능에 도움
	stmt2.setString(1, d.deptName);
	stmt2.setString(2, d.deptNo);
	
	int row = stmt2.executeUpdate(); // 반환되는 데이터가 0 or 1이라 row가 변경 되었는지 확인
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	// 3. 결과
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); /* getContextPath 플젝 경로 */
%>
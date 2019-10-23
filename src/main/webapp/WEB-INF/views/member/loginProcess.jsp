<%@page import="com.exam.dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// post 파라미터값 한글처리
request.setCharacterEncoding("utf-8");

// 파라미터값 가져오기 "id" "passwd" "rememberMe"
String id = request.getParameter("id");
String passwd = request.getParameter("passwd");
// checkbox 또는 radio 타입은 선택안하면  null을 리턴
String rememberMe = request.getParameter("rememberMe");

// DAO 객체 준비
MemberDao memberDao = MemberDao.getInstance();
// 사용자 확인 메소드 호출
int check = memberDao.userCheck(id, passwd);
// check == 1 로그인 인증(세션값생성 "id"). index.jsp로 이동
// check == 0 "패스워드틀림" 뒤로이동
// check == -1 "아이디없음" 뒤로이동
if (check == 1) {
	// 로그인 인증
	session.setAttribute("id", id);
	
	// 로그인 상태유지 여부확인 후
	// 쿠키객체 생성해서 응답시 보내기
	if (rememberMe != null && rememberMe.equals("true")) {
		Cookie cookie = new Cookie("id", id);
		cookie.setMaxAge(60*10); // 초단위. 10분 = 60초 * 10 = 600초
		cookie.setPath("/");
		response.addCookie(cookie); // 응답객체에 추가
	}
	
	
	// index.jsp로 이동
	response.sendRedirect("../index.jsp");
} else if (check == 0) {
	%>
	<script>
		alert('패스워드가 다릅니다.');
		history.back();
	</script>
	<%
} else { // check == -1
	%>
	<script>
		alert('없는 아이디 입니다.');
		history.back();
	</script>
	<%
}


%>
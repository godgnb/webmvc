package com.exam.controller.board;


import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.controller.Action;
import com.exam.controller.ActionForward;
import com.exam.dao.BoardDao;

public class DeleteAction implements Action {

	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("DeleteAction");
		
		// 파라미터값 가져오기
		String pageNum = request.getParameter("pageNum");
		int num = Integer.parseInt(request.getParameter("num"));
		
		// passwd 파라미터값은 로그인 사용자일경우 null
		String passwd = request.getParameter("passwd");
		
		// DAO 객체 준비
		BoardDao boardDao = BoardDao.getInstance();
		
		// 패스워드가 다를때는 "글패스워드 다름" 뒤로가기
		if (!boardDao.isPasswdEqual(num, passwd)) {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('글 패스워드가 다릅니다.')");
			out.println("history.back();");
			out.println("</script>");
			out.close();
			return null;
		}
		
		// 게시글 삭제하기 메소드 호출
		boardDao.deleteBoard(num);// 글 삭제처리
		
		//삭제처리 후 글목록 notice.jsp로 이동
		ActionForward forward = new ActionForward();
		forward.setPath("notice.do?pageNum=" + pageNum);
		forward.setRedirect(true);
		return forward;
	}

}

package com.exam.controller.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.controller.Action;
import com.exam.controller.ActionForward;
import com.exam.dao.MemberDao;

public class JoinIdDupCheckAction implements Action {

	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("JoinIdDupCheckAction");
		
		
		
		// "userid" 중복확인할 아이디 파라미터값 가져오기
		String userid = request.getParameter("userid");
		
		// DAO 객체 준비
		MemberDao memberDao = MemberDao.getInstance();
		// 아이디 중복확인 메소드 호출
		boolean isIdDup = memberDao.isIdDuplicated(userid);
		
		// request 영역에 데이터 저장(싣기)
		request.setAttribute("isIdDup", isIdDup); // -> Boolean b = (Boolean) request.getAttribute("isIdDup");
		request.setAttribute("userid", userid);
		
		ActionForward forward = new ActionForward();
		forward.setPath("member/joinIdDupCheck");
		forward.setRedirect(false);
		return forward;
	}

}

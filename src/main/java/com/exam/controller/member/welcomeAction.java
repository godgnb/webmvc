package com.exam.controller.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.controller.Action;
import com.exam.controller.ActionForward;

public class welcomeAction implements Action {

	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("welcomeAction");
		
		ActionForward forward = new ActionForward();
		forward.setPath("company/welcome");
		forward.setRedirect(false);
		return forward;
	}

}

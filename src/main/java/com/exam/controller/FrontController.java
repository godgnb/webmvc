package com.exam.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.controller.member.MemberJoinAction;
import com.exam.controller.member.MemberJoinFormAction;
import com.exam.controller.member.MemberLoginFormAction;

@WebServlet("*.do")
public class FrontController extends HttpServlet {    

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doGet");
		
		//*프론트 컨트롤러 역할 및 수행단계 
		// 1) 요청정보(명령어) 추출
		
		// http://localhost:80/webmvc/memberJoinForm.do
		
		String requestURI = request.getRequestURI();
		System.out.println("요청URI주소: " + requestURI);
		// 요청URI주소: /webmvc/memberJoinForm.do
		
		String ContextPath = request.getContextPath();
		System.out.println("contextpath: " + ContextPath);
		// contextpath: /webmvc
		
		String command = requestURI.substring(ContextPath.length());
		System.out.println("command: " + command);
		// command: /memberJoinForm.do
		
		
		// 2) 요청정보(명령어)에 대응하는 코드 실행
		Action action = null;
		ActionForward forward = null;
		ActionFactory factory = ActionFactory.getInstance();
		
		action = factory.getAction(command);
		try {
			forward = action.execute(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 3) 화면정보를 가진 뷰(JSP)를 선택해서 실행
		// URL 주소(sendRedirect 방식 이동. "*.do" 명령어로 재요청할)
		// 또는 jsp파일명(dispatch 방식 이동)
		
		if (forward != null) { // 이동정보가 있으면
			if (forward.isRedirect()) { // redirect 방식 이동
				response.sendRedirect(forward.getPath());
			} else { // dispatch 방식 이동
				String path = "WEB-INF/views/" + forward.getPath() + ".jsp" ;
				
				RequestDispatcher dispatcher
				 = request.getRequestDispatcher(path);
				dispatcher.forward(request, response);
			}
		}
		
	} // doGet method


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doPost");
		// post 요청정보 한글처리
		request.setCharacterEncoding("utf-8");
		// doGet()메소드 호출
		doGet(request, response);
		
		
	} // doPost method

}

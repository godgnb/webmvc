package com.exam.controller.board;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.VO.BoardVO;
import com.exam.controller.Action;
import com.exam.controller.ActionForward;
import com.exam.dao.BoardDao;

public class UpdateAction implements Action {

	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("UpdateAction");
		
		String pageNum = request.getParameter("pageNum");
		
		// 자바빈 객체 생성
		BoardVO boardVO = new BoardVO();
		
		boardVO.setNum(Integer.parseInt(request.getParameter("num")));
		boardVO.setUsername(request.getParameter("username"));
		boardVO.setPasswd(request.getParameter("passwd"));
		boardVO.setSubject(request.getParameter("subject"));
		boardVO.setContent(request.getParameter("content"));
		
		// DAO 객체 준비
		BoardDao boardDao = BoardDao.getInstance();
		
		boolean isPasswdEqual = boardDao.isPasswdEqual(boardVO.getNum(), boardVO.getPasswd());
		if (!isPasswdEqual) { //boardVO.getPasswd().equals(dbBoardVO.getpasswd());
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('글 패스워드가 다릅니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
			return null;
		}
		
		// 게시글 수정하기 메소드 호출
		boardDao.updateBoard(boardVO);
		
		// 글목록 notice.do로 리다이렉트 이동
//		ActionForward forward = new ActionForward();
//		forward.setPath("content.do?num= " + boardVO.getNum() + "&pageNum=" + pageNum + "';");
//		forward.setRedirect(true);
//		return forward;
		System.out.println("num"+boardVO.getNum() );
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("alert('글 수정 성공!');");
		out.println("location.href = 'content.do?num=" + boardVO.getNum() + "&pageNum=" + pageNum + "';");
		out.println("</script>");
		out.close();
		return null;
	}

}

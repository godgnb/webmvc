package com.exam.controller.board;

import java.sql.Timestamp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exam.VO.BoardVO;
import com.exam.controller.Action;
import com.exam.controller.ActionForward;
import com.exam.dao.BoardDao;

public class ReWriteAction implements Action {

	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("ReWriteAction");
		
		// BoardVO 자바빈 객체 생성
		BoardVO boardVO = new BoardVO();
		
		// 파라미터 가져와서 VO에 저장
		boardVO.setUsername(request.getParameter("username"));
		boardVO.setPasswd(request.getParameter("passwd"));
		boardVO.setSubject(request.getParameter("subject"));
		boardVO.setContent(request.getParameter("content"));
		boardVO.setReRef(Integer.parseInt(request.getParameter("reRef")));
		boardVO.setReLev(Integer.parseInt(request.getParameter("reLev")));
		boardVO.setReSeq(Integer.parseInt(request.getParameter("reSeq")));
		
		// 글등록날짜, IP주소 값 저장
		boardVO.setRegDate(new Timestamp(System.currentTimeMillis()));
		boardVO.setIp(request.getRemoteAddr());
		
		// BoardDao 객체 준비
		BoardDao boardDao = BoardDao.getInstance();
		
		//게시글 번호 생성하는 메소드 호출
		int num = boardDao.nextBoardNum();
		//생성된 번호를 자바빈 글번호 필드에 설정
		boardVO.setNum(num);
		boardVO.setReadcount(0); // 조회수 0
		
		// 답글쓰기 메소드 호출
		boardDao.reInsertBoard(boardVO);
		
		ActionForward forward = new ActionForward();
		forward.setPath("notice.do");
		forward.setRedirect(true);
		return forward;
	}

}

<%@page import="com.exam.dao.BoardDao"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.exam.VO.BoardVO"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.UUID"%>
<%@page import="com.exam.VO.AttachVO"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.exam.dao.AttachDao"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//COS 라이브러리를 이용한 파일업로드
//MultipartRequest 생성자 호출시에 파일업로드가 완료됨

//필요한 매개값 5개
//1 request
//2 saveDirectory (업로드할경로)
String realPath = application.getRealPath("/upload");
System.out.println("realPath : " + realPath);

//3 최대 업로드 파일크기
int maxSize = 1024 * 1024 * 10; // 10MB

//4 파일이름 한글처리 "utf-8"

//5 파일이름 중복처리

//파일업로드 수행 완료
MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, "utf-8", new DefaultFileRenamePolicy());




// 세션값 가져오기 (로그인 여부 확인)
String id = (String) session.getAttribute("id");


// 수정할 글번호num, 패스워드passwd, pageNum 파라미터 가져오기
String pageNum = multi.getParameter("pageNum");
int num = Integer.parseInt(multi.getParameter("num"));
String passwd = multi.getParameter("passwd");

//BoardDao 객체 준비
BoardDao boardDao = BoardDao.getInstance();

// 로그인 안한 사용자(글 패스워드값이 있는 사용자)는
// [패스워드 일치 여부]를 확인 후 일치하면 글 수정하고,
// 일치하지 않으면 "글패스워드 다름" 뒤로가기
if (id == null) { // boardVO.getPasswd() != null
	boolean isPasswdEqual = boardDao.isPasswdEqual(num, passwd);
	if (!isPasswdEqual) { //boardVO.getPasswd().equals(dbBoardVO.getpasswd());
		%>
		<script>
			alert('글 패스워드가 다릅니다.');
			history.back();
		</script>
		<%
		return;
	}
}



//===================== 게시판 글 수정 처리 시작 ===================== 

//자바빈 BoardVO 객체 생성
BoardVO boardVO = new BoardVO();

//파라미터 찾아서 자바빈에 저장
boardVO.setNum(num); // 수정할 글번호 저장
boardVO.setSubject(multi.getParameter("subject"));
boardVO.setContent(multi.getParameter("content"));


//게시글 수정하는 메소드 호출 updateBoard(boardVO)
boardDao.updateBoard(boardVO);

//===================== 게시판 글 등록 처리 종료 =====================



//===================== 첨부파일 DB등록 처리 시작 =====================

// AttachDao 준비
AttachDao attachDao = AttachDao.getInstance();

// Enumeration 열거형. file의 파라미터 이름들을 가집
// 자바의 Iterator와 사용방법이 동일함
Enumeration<String> enu = multi.getFileNames();
while (enu.hasMoreElements()) { // 다음요소가 있으면
	String str = enu.nextElement();
	System.out.println(str);
	
	// 파라미터 이름으로 실제로 업로드된 파일이름 구하기
	// 해당 파라미터 이름을 업로드에 사용 안했으면 null이 리턴
	String realFileName = multi.getFilesystemName(str);
	// 파일 업로드 여부확인.
	if (realFileName != null) {
		
		// 자바빈 AttachVO 객체 생성
		AttachVO attachVO = new AttachVO();
		
		UUID uuid = UUID.randomUUID();
		attachVO.setUuid(uuid.toString());
		attachVO.setFilename(realFileName); // 실제 생성된 파일이름
		attachVO.setBno(num); // 게시글 번호


		// 이미지 파일여부 확인
		File file = new File(realPath, realFileName);
		String contentType = Files.probeContentType(file.toPath());
		boolean isImage = contentType.startsWith("image");
		if(isImage) {
			attachVO.setFiletype("I"); // Image File
		} else {
			attachVO.setFiletype("O"); // Other
		}
			
		// 첨부파일정보 한개 등록하는 메소드 호출
		attachDao.insertAttach(attachVO);
	}
} // while

//===================== 첨부파일 DB등록 처리 종료 =====================



//===================== 삭제할 파일 삭제작업 시작 ===================== 

// 삭제할 파일정보 파라미터 가져오기
String[] delFiles = multi.getParameterValues("delFiles");
if (delFiles != null) {
	for (String str : delFiles) {
		String[] strArr = str.split("_");
		String uuid = strArr[0];
		String delFilename = strArr[1];
		System.out.println("uuid : " + uuid);
		System.out.println("delFilename : " + delFilename);
		
		// 파일 삭제하기
		File delFile = new File(realPath, delFilename);
		if (delFile.exists()) { // 해당경로에 파일이 존재하면
			delFile.delete(); // 파일 삭제
		}
		
		// attach 테이블에 해당 uuid 레코드 삭제
		attachDao.deleteAttach(uuid);		
	} // for
} // if

//===================== 삭제할 파일 삭제작업 종료 =====================



// 이동 fnotice.jsp
response.sendRedirect("fnotice.jsp?pageNum=" + pageNum);
%>
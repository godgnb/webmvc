<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.exam.VO.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="com.exam.dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt %>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>Welcome to Fun Web</title>
<link href="../css/default.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/subpage.css" rel="stylesheet" type="text/css"  media="all">
<link href="../css/print.css" rel="stylesheet" type="text/css"  media="print">
<link href="../css/iphone.css" rel="stylesheet" type="text/css" media="screen">
<!--[if lt IE 9]>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js" type="text/javascript"></script>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/ie7-squish.js" type="text/javascript"></script>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
<![endif]-->


<!--[if IE 6]>
 <script src="../script/DD_belatedPNG.js"></script>
 <script>
   /* EXAMPLE */
   DD_belatedPNG.fix('#wrap');
   DD_belatedPNG.fix('#sub_img');   
   DD_belatedPNG.fix('#sub_img_center'); 
   DD_belatedPNG.fix('#sub_img_member'); 

 </script>
 <![endif]--> 

</head>

<body>
<div id="wrap">
	<!-- 헤더 영역 -->
	<jsp:include page="../include/header.jsp" />
	  
	  
	<div class="clear"></div>
	<div id="sub_img_center"></div>
	<div class="clear"></div>

 	<!-- nav 영역 -->
 	<jsp:include page="../include/nav_center.jsp" />
 	
<article>
    
<h1>Notice [전체글개수 : ${pageInfoMap.count }]</h1>
    
<table id="notice">
  <tr>
    <th scope="col" class="tno">no.</th>
    <th scope="col" class="ttitle">title</th>
    <th scope="col" class="twrite">writer</th>
    <th scope="col" class="tdate">date</th>
    <th scope="col" class="tread">read</th>
  </tr>
  
  <c:choose>
  	<c:when test="${pageInfoMap.count gt 0}"><%-- ${not empty boardList} --%>
  		
  		<c:forEach var="board" items="${boardList }">
  			<tr onclick="location.href='content.jsp?num=${board.num }&pageNum=${pageNum }';">
		  	<td>${board.num }</td>
		  	<td class="left">
		  		<c:if test="${board.reLev gt 0 }"><%--답글일때 --%>
		  			<c:set var="level" value="${board.reLev * 10}" />
		  			
		  			<img src="../images/center/level.gif" width="${level }" height="13" />
		  			<img src="../images/center/icon_re.gif" />
		  		</c:if>
  				${board.subject }
		  	</td>
		  	<td>${board.username }</td>
		  	<td><fmt:formatDate value="${board.regDate }" pattern="yyyy.MM.dd"/></td>
		  	<td>${board.readcount }</td>
		  </tr>
  		</c:forEach>
  	
  	</c:when>
  	<c:otherwise>
  		<tr>
	  		<td colspan="5">게시판 글이 없습니다.</td>
	  	</tr>
  	</c:otherwise>
  </c:choose>

</table>

<div id="table_search">
	<input type="button" value="글쓰기" class="btn" onclick="location.href='write.jsp';"/>
</div>

<form action="notice.jsp" method="get">
<div id="table_search">
	<input type="text" name="search" value="${search }" class="input_box">
	<input type="submit" value="제목검색" class="btn">
</div>
</form>

 <div class="clear"></div>
 
<div id="page_control">

<c:if test="${pageInfoMap.count gt 0 }">
	<%--[이전] 출력 --%>
	<c:if test="${pageInfoMap.startPage gt pageInfoMap.pageBlock }">
		<a href="notice.jsp?pageNum=${pageInfoMap.startPage - pageInfoMap.pageBlock }&search=${search}">[이전]</a>
	</c:if>
	
	<%--페이지블록 페이지5개 출력 --%>
	<c:forEach var="i" begin="${pageInfoMap.startPage }" end="${pageInfoMap.endPage }" step="1">
		<a href="notice.jsp?pageNum=${i }&search=${search">
		<c:choose>
			<c:when test="${i eq pageNum}">
				<span style="font-weight: bold;">[${i}]</span>				
			</c:when>
			<c:otherwise>
				<span>${i}</span>
			</c:otherwise>
		</c:choose>
		</a>
	</c:forEach>
	
	<%--[다음] 출력 --%>
	
	
</c:if>





<%
if (count > 0) {
	// 총 페이지 개수 구하기
	//	전체 글개수 / 한페이지당 글개수 (+ 1 : 나머지 있을때)
	int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
	
	// 페이지블록 수 설정
	int pageBlock = 5;
	
	// 시작페이지번호 구하기
	// pageNum값이 1~5 사이면 -> 시작페이지는 항상 1이 나와야 함
	
	// ((1 - 1) / 5) * 5 + 1 -> 1
	// ((2 - 1) / 5) * 5 + 1 -> 1
	// ((3 - 1) / 5) * 5 + 1 -> 1
	// ((4 - 1) / 5) * 5 + 1 -> 1
	// ((5 - 1) / 5) * 5 + 1 -> 1
	
	// ((6 - 1) / 5) * 5 + 1 -> 6
	// ((7 - 1) / 5) * 5 + 1 -> 6
	// ((8 - 1) / 5) * 5 + 1 -> 6
	// ((9 - 1) / 5) * 5 + 1 -> 6
	// ((10 - 1) / 5) * 5 + 1 -> 6
	int startPage = ((pageNum - 1) / pageBlock) * pageBlock + 1;
	
	// 끝페이지번호 endPage 구하기
	int endPage = startPage + pageBlock - 1;
	if (endPage > pageCount) {
		endPage = pageCount;
	}
	
	// [이전] 출력
	if (startPage > pageBlock) {
		%>
		<a href="notice.jsp?pageNum=<%=startPage - pageBlock %>&search=<%=search %>">[이전]</a>
		<%
	}
	
	// 페이지블록 페이지5개 출력
	for (int i = startPage; i <= endPage; i++) {
		%>
		<a href="notice.jsp?pageNum=<%=i %>&search=<%=search %>">
		<%
		if (i == pageNum) {
			%>
			<span style="font-weight: bold;">[<%=i %>]</span>
			<%
		} else {
			%>
			<%=i %><%
		}
		%>
		</a>
		<%

	}
	
	// [다음] 출력
	if (endPage < pageCount) {
		%>
		<a href="notice.jsp?pageNum=<%=startPage + pageBlock %>&search=<%=search %>">[다음]</a>
		<%
	}
}
%>
</div>	    
</article>
    
     <div class="clear"></div>
    
    <!-- 푸터 영역 -->
    <jsp:include page="../include/footer.jsp" />
    
    
    
</div>

</body>
</html>   


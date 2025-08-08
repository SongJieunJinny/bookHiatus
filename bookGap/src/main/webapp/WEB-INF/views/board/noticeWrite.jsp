<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
<title>noticeWrite</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/notice.css"/>
</head>
<body>
<sec:authorize access="isAuthenticated()">
  <script>
    const isLoggedIn = true;
  </script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
  <jsp:include page="/WEB-INF/views/include/header.jsp" /> 
  <section>
  	<div id="noticeMain">
      <div id="notice">공지사항</div>
      <form action="noticeWriteOk.do" method="POST">
	      <div id="noticeWrite">
	        <div id="noticeWriteTable">
	          <div id="noticeWriteTableTitle">
	            <div id="title">제목</div>
	            <input id="userIdNoticeWriteOkForm" type="hidden" name="userId">
	            <input id="boardTypeNoticeWriteOkForm" type="hidden" name="boardType" value="1">
	            <input id="titleMemo" type="text" name="boardTitle">
	          </div>
	          <br>
	          <div id="noticeWriteTableContent">
	            <div id="content">내용</div>
	            <textarea id="contentMemo" name="boardContent"></textarea>
	          </div>
	        </div>
	      </div>
	    	<div id="noticeWriteButton">
	    	<button id="write" type="submit">등록하기</button>&nbsp;&nbsp;&nbsp;
	    	<button id="reset" type="button">취소하기</button>
	    	</div>
    	</form>
    </div>
  </section>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  <script>
  // 장바구니 개수 업데이트 함수
  $(document).ready(function() {
	  updateCartCount(); // 장바구니 개수 업데이트
    initHeaderEvents();
  });
  
	</script>
	<script>
	$(document).ready(function() {
		$('#reset').click(function() {
		  window.location.href = '<%=request.getContextPath()%>/noticeList.do';
		});
	});
	</script>
</body>
</html>
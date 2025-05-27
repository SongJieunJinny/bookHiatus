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
	    	<br>
	    	<button id="write" type="submit">등록하기</button>&nbsp;&nbsp;&nbsp;
	    	<button id="reset" type="button">취소하기</button>
    	</form>
    </div>
  </section>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  <script>
  // 장바구니 개수 업데이트 함수
	function updateCartCount() {
		let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
		let cartCount = cartItems.length;
		let cartCountElement = document.getElementById("cart-count");

		if (cartCountElement) {
				cartCountElement.textContent = cartCount;
				cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
		}
	}
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
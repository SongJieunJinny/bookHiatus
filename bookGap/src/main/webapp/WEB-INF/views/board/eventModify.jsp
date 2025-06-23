<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>eventModify</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/event.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="eventMain">
      <div id="event">EVENT</div>
      <form action="eventModifyOk.do" method="POST">
	      <div id="eventWrite">
		      <div id="eventWriteTable">
			      <div id="eventWriteTitleTable">
			        <div id="title">제목</div>
		          <input id="boardNoNoticeWriteOkForm" type="hidden" name="boardNo" value="${vo.boardNo}">
		          <input id="userIdNoticeWriteOkForm" type="hidden" name="userId" value="${vo.userId}">
		          <input id="boardTypeNoticeWriteOkForm" type="hidden" name="boardType" value="3">
		          <input id="titleMemo" type="text" name="boardTitle" value="${vo.boardTitle}">
			      </div>
		        <div id="eventWriteContentTable">
		          <div id="content">내용</div>
		          <textarea id="contentMemo" name="boardContent">${vo.boardContent}</textarea>
		        </div>
	      	</div>
		      <div id="eventButtonDiv">
		        <button id="eventModifyButton" type="submit">수정하기</button>&nbsp;&nbsp;&nbsp;
		        <button id="resetButton" type="button">취소하기</button>
		    	</div>
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
		  $("#eventModifyButton").click(function() {
		    $("form").submit(); // 제출 버튼 클릭 시 정상 제출
		  });
		$('#resetButton').click(function() {
		  window.location.href = '<%=request.getContextPath()%>/eventList.do';
		});
	});
	</script>
</body>
</html>
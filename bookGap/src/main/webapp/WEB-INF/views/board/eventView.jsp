<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>eventView</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/event.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<div id="navEvent">
      <div id="eventHead">
        <div id="event">QnA</div>
      </div>
      <div id="eventMid">
        <div id="eventViewTable">
          <div id="titleViewDiv">
            <div id="titleView">${vo.boardTitle}</div>
          </div>
          <div id="writeRrdateViewDiv">
            <span id="writerView">${vo.userId}</span>
            <span id="rdateView">
            	<fmt:formatDate value="${vo.boardRdate}" pattern="yyyy-MM-dd" />
            </span>
          </div>
          <div id="contentViewDiv">
            <div id="contentView">${vo.boardContent}</div>
          </div>
        </div><br>
				<div id="eventViewBtn">
					<!-- 어드민 -->
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_ADMIN'}">
				    <form id="eventViewwriteForm" name="deletefrm" action="qnaDelete.do" method="post" style="display: inline-flex;">
				      <input type="hidden" name="boardNo" value="${vo.boardNo}">
				      <button id="writeView" onclick="return confirmDelete();">삭제하기</button>&nbsp;&nbsp;&nbsp;
				    </form>
				  </c:if>

					<!-- 모두가 -->
				  <a href="<%= request.getContextPath() %>/eventList.do?boardType=3">    
					  <button id="listView">목록으로</button>
					</a>
				</div>
			</div>

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
</body>
</html>
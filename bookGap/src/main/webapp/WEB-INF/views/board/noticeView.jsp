<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
<title>noticeView</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/notice.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="noticeMain">
	    <div id="notice">공지사항</div>
	    <div id="noticeMid">
	      <table id="noticeViewTable">
	        <thead>
	          <tr>
	            <td id="noticeViewtitle">${vo.boardTitle}</td>
	          </tr>
	          <tr>
	            <td id="noticeViewwriter">${vo.userId}</td>
	            <td id="noticeViewrdate">
	            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	            	<fmt:formatDate value="${vo.boardRdate}" pattern="yyyy-MM-dd" />
	            </td>
	          </tr>
	        </thead>
	        <tbody>
	          <tr>
	            <td id="noticeViewcontent">${vo.boardContent}</td>
	          </tr>
	        </tbody>
	      </table><br>
	      <div id="noticeViewBtn">
	      	<c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_ADMIN'}">
		        <button id="noticeViewwrite" onclick="confirmDelete();">삭제하기</button>&nbsp;&nbsp;&nbsp;
		        <form id="noticeViewwriteForm" name="deletefrm" action="noticeDelete.do" method="post">
							<input id="noticeViewwriteFormInput" type="hidden" name="boardNo" value="${vo.boardNo}">
						</form>
		        <a href="noticeModify.do?boardNo=${vo.boardNo}" style="text-decoration: none;">
		        	<button id="noticeViewmodify">수정하기</button>&nbsp;&nbsp;&nbsp;
		        </a>
		        <button id="noticeViewlist" >목록으로</button>
	        </c:if>
					<c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_USER'}">
		        <button id="noticeViewlist" style="margin-left: 70%;">목록으로</button>
	        </c:if>
	      </div>
	    </div>
    </div>
  	<br>
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
  function confirmDelete() {
    let isConfirmed = confirm("정말 삭제하시겠습니까?"); 
    if (isConfirmed) {
      document.deletefrm.submit(); // 삭제 요청 실행
    }
  }
	</script>
  <script>
	$(document).ready(function() {
		$('#noticeViewmodify').click(function() {
			  window.location.href = '<%=request.getContextPath()%>/noticeModify.do';
		});
		$('#noticeViewlist').click(function() {
			  window.location.href = '<%=request.getContextPath()%>/noticeList.do';
		});
	});
	</script>
</body>
</html>
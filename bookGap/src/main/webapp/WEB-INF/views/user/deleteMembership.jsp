<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteMembership</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/mypage.css"/>
</head>
<body>
	<!-- header part -->
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="deleteMembershipNav">
      <div id="deleteMembershipHead">
        <div id="deleteMembershipHeadDiv">
          <div id="deleteMembership">THANK YOU</div>
        </div>
      </div>
      <div id="deleteMembershipMid">
        <div id="deleteMembershipMidDiv1">
          그동안 BOOK틈을 사랑해 주셔서 감사합니다.
        </div><br>
        <div id="deleteMembershipMidDiv2">
          앞으로도 더 다양하고 흥미로운 책들을 소개할 수 있는 공간이 되기위해 노력하겠습니다.
        </div><br>
      </div>
      <div id="deleteMembershipEnd">
        <div id="deleteMembershipEndDiv">
          <button id="deleteMembershipBtn" onclick="location.href='<%=request.getContextPath()%>/'">메인화면으로</button>
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
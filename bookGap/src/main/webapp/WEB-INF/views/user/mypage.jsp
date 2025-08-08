<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mypage</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/mypage.css"/>
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
  <!-- header part -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="navMypage">
    	<form action="${pageContext.request.contextPath}/user/mypage.do" method="post">
    		<sec:csrfInput />
	      <div id="mypageHead">
	        <div id="mypage">My Page</div>
	      </div>
	      <div id="mypageMid">
	        <div id="mypageDiv">
	          <div id="mypageContainer">
	            <span id="title">ID</span>
	            <input id="mypageId" type="text" name="USER_ID" required>
	          </div>
	          <div id="mypageContainer">
	            <span id="title">PW</span>
	            <input id="mypagePw" type="password" name="USER_PW" required>
	          </div>
	        </div>
	      </div>
	      <div id="mypageEnd">
				  <button id="mypageBtn" type="submit">본인확인</button>
				  <!-- 에러 메시지 출력 -->
				  <c:if test="${not empty error}">
				    <script>
				        alert("${error}");
				    </script>
					</c:if>
	      </div>
      </form>
    </div>
  </section>
  <!-- footer part -->
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
	<script>
  $(document).ready(function() {
   updateCartCount(); // 장바구니 개수 업데이트
    initHeaderEvents();
  });
  
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bookSearch</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/bookSearch.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <h2 class="search-title">
    '<span class="keyword">${searchKeyword}</span>' 검색 결과
  </h2>
  <c:choose><%-- 검색 결과가 있을 때 --%>
	  <c:when test="${not empty bookList}">
	    <div class="book-grid">
        <c:forEach var="book" items="${bookList}">
	        <div class="book-item">
	          <a href="<c:url value='/product/bookView.do?isbn=${book.isbn}'/>">
	             <img src="${book.image}" alt="${book.title}">
	             <p class="book-title">${book.title}</p>
	          </a>
	          <p class="book-price"><fmt:formatNumber value="${book.discount}" pattern="#,###" />원</p>
	        </div>
        </c:forEach>
	    </div>
	  </c:when>

	  <c:otherwise><%-- 검색 결과가 없을 때 --%>
	    <p class="no-results">
	      '${searchKeyword}'에 대한 검색 결과가 없습니다.
	    </p>
	  </c:otherwise>
  </c:choose>
</section>
	<div class="pagination">
		<%-- 이전 페이지 링크 --%>
		<c:if test="${paging.startPage > 1}">
			<a href="bookSearch.do?nowpage=${paging.startPage - 1}&searchValue=${searchKeyword}">&lt;</a>
		</c:if>
	
		<%-- 페이지 번호 링크 --%>
		<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
			<c:choose>
				<c:when test="${paging.nowPage eq cnt}">
					<a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
				</c:when>
				<c:otherwise>
					<a href="bookSearch.do?nowpage=${cnt}&searchValue=${searchKeyword}">${cnt}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	
		<%-- 다음 페이지 링크 --%>
		<c:if test="${paging.endPage < paging.lastPage}">
			<a href="bookSearch.do?nowpage=${paging.endPage + 1}&searchValue=${searchKeyword}">&gt;</a>
		</c:if>
	</div>
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BOOK</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/bookList.css?v=2"/>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- 책 목록 -->
	<section class="bookList">
		<div class="bookAll">
			
			<div class="bookTitleName">${empty category ? '모든 책' : category}</div>
			
			<div class="bookTitleSelect">
				<select>
					<option>인기상품</option>
					<option>최신상품</option>
				</select>
			</div>
		</div>
		    <div class="bookItems">
		    <c:forEach items="${selectBookList}" var="vo">
			       <div class="bookItem">
				       <input type="hidden" name="isbn" value="${vo.isbn}">
				       <div class="bookImg" >
						  <a href="./bookView.do"><img src="${vo.image}" alt="${vo.title}"  style="height: 260px;"/></a>
						</div>
						<div class="bookTitle">${vo.title}</div>
						<div class="bookPrice">${vo.discount}원</div>
					</div>
		        </c:forEach>
		    </div>
	</section>
 		<div class="pagination">
		    <c:if test="${paging.startPage > 1}">
		        <a href="bookList.do?nowpage=${paging.startPage - 1}
		            &searchType=${searchType}&searchValue=${searchValue}
		            &category=${category}">&lt;</a>
		    </c:if>
		
		    <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
		        <c:choose>
		            <c:when test="${paging.nowPage eq cnt}">
		                <a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
		            </c:when>
		            <c:otherwise>
		                <a href="bookList.do?nowpage=${cnt}
		                    &searchType=${searchType}&searchValue=${searchValue}
		                    &category=${category}">${cnt}</a>
		            </c:otherwise>
		        </c:choose>
		    </c:forEach>
		
		    <c:if test="${paging.endPage < paging.lastPage}">
		        <a href="bookList.do?nowpage=${paging.endPage + 1}
		            &searchType=${searchType}&searchValue=${searchValue}
		            &category=${category}">&gt;</a>
		    </c:if>
		</div>
 		
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
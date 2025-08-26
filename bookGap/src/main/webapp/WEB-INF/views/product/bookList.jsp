<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<sec:authorize access="isAuthenticated()">
  <script>
    const isLoggedIn = true;
  </script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- 책 목록 -->
	<section class="bookList">
		<div class="bookAll">
			<div class="bookTitleName">${empty category ? '모든 책' : category}</div>
			<div class="bookTitleSelect">
				<form id="sortForm" method="get" action="bookList.do">
			      <input type="hidden" name="category" value="${category}"/>
			      <input type="hidden" name="searchType" value="${searchType}"/>
			      <input type="hidden" name="searchValue" value="${searchValue}"/>
			      <select name="sort" onchange="document.getElementById('sortForm').submit();">
			        <option value="recent" ${param.sort == 'recent' || empty param.sort ? 'selected' : ''}>최신상품</option>
					<option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>인기상품</option>
			      </select>
			    </form>
			</div>
		</div>
	    <div class="${selectBookList.size() <= 2 ? 'bookItems centered' : 'bookItems'}">
	    	<c:forEach items="${selectBookList}" var="vo">
		    	<div class="bookItem">
			    	<input type="hidden" name="isbn" value="${vo.isbn}">
			    	<div class="bookImg" >
					  	<a href="<%= request.getContextPath() %>/product/bookView.do?isbn=${vo.isbn}"><img src="${vo.image}" alt="${vo.title}"  style="height: 350px;"/></a>
						</div>
					<div class="bookTitle">
					  <c:out value="${fn:replace(vo.title, '(', '<br>(')}" escapeXml="false"/>
					</div>
					<div class="bookPrice">${vo.discount}원</div>
					</div>
	    	</c:forEach> 
	    </div>
	</section>
	<div class="pagination">
		<!-- 이전 페이지 버튼 -->
		<c:if test="${paging.startPage > 1}">
			<a href="bookList.do?nowpage=${paging.startPage - 1}
				&searchType=${searchType}&searchValue=${searchValue}
				&category=${category}&sort=${sort}">&lt;</a>
		</c:if>
	
		<!-- 페이지 번호 -->
		<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
			<c:choose>
				<c:when test="${paging.nowPage eq cnt}">
					<a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
				</c:when>
				<c:otherwise>
					<a href="bookList.do?nowpage=${cnt}
						&searchType=${searchType}&searchValue=${searchValue}
						&category=${category}&sort=${sort}">${cnt}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	
		<!-- 다음 페이지 버튼 -->
		<c:if test="${paging.endPage < paging.lastPage}">
			<a href="bookList.do?nowpage=${paging.endPage + 1}
				&searchType=${searchType}&searchValue=${searchValue}
				&category=${category}&sort=${sort}">&gt;</a>
		</c:if>
	</div>

<script>
// 장바구니 개수 업데이트 함수
  $(document).ready(function() {
	updateCartCount(); // 장바구니 개수 업데이트
	initHeaderEvents();
  });

</script>
</body>
</html>
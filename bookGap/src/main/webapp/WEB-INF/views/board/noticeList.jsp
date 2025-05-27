<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>noticeList</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/notice.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<div id="noticeMain">
      <div id="notice">공지사항</div>
      <div id="noticeList">
      	<div id="noticeSearchFormDiv">
          <div id="noticeSearchForm">
            <form action="<%=request.getContextPath()%>/noticeList.do" method="GET">
              <input id="noticeSearchInput" type="text" name="searchValue" placeholder="제목 검색">
              <input type="hidden" name="searchType" value="board_title">
              <button id="noticeSearchButton"  type="submit">검색</button>
            </form>
          </div>
        </div>
        <br>
        <table id="noticeTable"> 
          <thead>
            <tr>
              <td id="line">글번호</td>
              <td id="line">제목</td>
              <td id="line">조회</td>
              <td id="line">등록일</td>
            </tr>
          </thead>
          <tbody>
          <c:forEach items="${list}" var="vo">
            <tr>
              <td>${vo.displayNo}</td>
              <td>
              	<a href="noticeView.do?boardNo=${vo.boardNo}&boardType=${param.boardType}">${vo.boardTitle}</a>
              </td>
              <td>${vo.boardHit}</td>
              <td><fmt:formatDate value="${vo.boardRdate}" pattern="yyyy-MM-dd" /></td>
            </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
      <sec:authorize access="hasAuthority('ROLE_ADMIN')">
      	<button id="writeButton">등록하기</button>&nbsp;&nbsp;&nbsp;
      </sec:authorize>
			<!-- 페이징 영역 -->
			<div class="pagination">
			  <c:if test="${paging.startPage > 1}">
			    <a href="noticeList.do?nowpage=${paging.startPage - 1}
			      &boardType=${param.boardType}
			      &searchType=${param.searchType}
			      &searchValue=${param.searchValue}">&lt;</a>
			  </c:if>
			
			  <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
			    <c:if test="${paging.nowPage eq cnt}">
			      <a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
			    </c:if>
			    <c:if test="${paging.nowPage ne cnt}">
			      <a href="noticeList.do?nowpage=${cnt}
			        &boardType=${param.boardType}
			        &searchType=${param.searchType}
			        &searchValue=${param.searchValue}">${cnt}</a>
			    </c:if>
			  </c:forEach>
			
			  <c:if test="${paging.endPage < paging.lastPage}">
			    <a href="noticeList.do?nowpage=${paging.endPage + 1}
			      &boardType=${param.boardType}
			      &searchType=${param.searchType}
			      &searchValue=${param.searchValue}">&gt;</a>
			  </c:if>
			</div>
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
		$('#writeButton').click(function() {
		  window.location.href = '<%=request.getContextPath()%>/noticeWrite.do';
		});
	});
	</script>
</body>
</html>
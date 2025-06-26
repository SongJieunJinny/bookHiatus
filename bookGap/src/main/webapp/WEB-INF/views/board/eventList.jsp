<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>eventList</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/event.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="eventMain">
      <div id="event">EVENT</div>
      <div id="eventList">
      	<div id="eventSearchFormDiv">
          <div id="eventSearchForm">
            <form id="eventSearchListForm" action="<%=request.getContextPath()%>/eventList.do" method="GET">
              <input id="eventSearchInput" type="text" name="searchValue" placeholder="제목 검색">
              <input type="hidden" name="searchType" value="board_title">
              <button id="eventSearchButton" type="submit">검색</button>
            </form>
          </div>
        </div>
        <br>
        <table id="eventTable">
          <thead>
            <tr>
              <td class="line">글번호</td>
              <td class="line">제목</td>
              <td class="line">조회수</td>
              <td class="line">등록일</td>
            </tr>
          </thead>
          <tbody>
          	<c:forEach items="${eventList}" var="evo">
            <tr>
              <td>${evo.displayNo}</td>
              <td>
              	<a href="eventView.do?boardNo=${evo.boardNo}&boardType=3">${evo.boardTitle}
	              	<c:if test="${evo.eCommentCount > 0}">
										<span style="color:#FF5722;">(${evo.eCommentCount })</span>
									</c:if>
								</a>
              </td>
              <td>${evo.boardHit}</td>
              <td><fmt:formatDate value="${evo.boardRdate}" pattern="yyyy-MM-dd"/></td>
            </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
      <sec:authorize access="hasAuthority('ROLE_ADMIN')">
      	<button id="write">등록하기</button>&nbsp;&nbsp;&nbsp;
      </sec:authorize>
      
      <!-- 페이징 영역 -->
			<div class="pagination">
			  <c:if test="${paging.startPage > 1}">
			    <a href="eventList.do?nowpage=${paging.startPage - 1}
			      &boardType=1
			      &searchType=${param.searchType}
			      &searchValue=${param.searchValue}">&lt;</a>
			  </c:if>
			
			  <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
			    <c:if test="${paging.nowPage eq cnt}">
			      <a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
			    </c:if>
			    <c:if test="${paging.nowPage ne cnt}">
			      <a href="eventList.do?nowpage=${cnt}
			        &boardType=1
			        &searchType=${param.searchType}
			        &searchValue=${param.searchValue}">${cnt}</a>
			    </c:if>
			  </c:forEach>
			
			  <c:if test="${paging.endPage < paging.lastPage}">
			    <a href="eventList.do?nowpage=${paging.endPage + 1}
			      &boardType=1
			      &searchType=${param.searchType}
			      &searchValue=${param.searchValue}">&gt;</a>
			  </c:if>
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
	<script>
	$(document).ready(function() {
		$('#write').click(function() {
		  window.location.href = '<%=request.getContextPath()%>/eventWrite.do?boardType=3';
		});
	});
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>qnaList</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/qna.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<div id="QnaMain">
      <div id="qna">QnA</div>
      <div id="QnaList">
        <div id="QnaSearchFormDiv">
          <div id="QnaSearchForm">
            <form id="QnaSearchListForm" action="<%=request.getContextPath()%>/qnaList.do" method="GET">
              <input id="QnaSearchInput" type="text" name="searchValue" placeholder="제목 검색">
              <input type="hidden" name="searchType" value="board_title">
              <button id="QnaSearchButton"  type="submit">검색</button>
            </form>
          </div>
        </div>
        <br>
        <table id="QnaTable">
          <thead>
            <tr>
              <td class="line">글번호</td>
              <td class="line">제목</td>
              <td class="line">글쓴이</td>
              <td class="line">등록일</td>
            </tr>
          </thead>
          <tbody>
          	<c:forEach items="${qanList}" var="qanVo">
	            <tr>
	              <td>${qanVo.displayNo}</td>
	              <td>
	              	<a href="qnaView.do?boardNo=${qanVo.boardNo}&boardType=2">${qanVo.boardTitle}
	              		<c:if test="${qanVo.qCommentCount > 0}">
											<span style="color:#FF5722;">(${qanVo.qCommentCount })</span>
										</c:if>
									</a>
	              </td>
	              <td>${qanVo.userId}</td>
	              <td><fmt:formatDate value="${qanVo.boardRdate}" pattern="yyyy-MM-dd" /></td>
	            </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
      <button id="writeButton">등록하기</button>&nbsp;&nbsp;&nbsp;
      <!-- 페이징 영역 -->
			<div class="pagination">
			  <c:if test="${paging.startPage > 1}">
			    <a href="qnaList.do?nowpage=${paging.startPage - 1}
			      &boardType=2
			      &searchType=${param.searchType}
			      &searchValue=${param.searchValue}">&lt;</a>
			  </c:if>
			
			  <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
			    <c:if test="${paging.nowPage eq cnt}">
			      <a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
			    </c:if>
			    <c:if test="${paging.nowPage ne cnt}">
			      <a href="qnaList.do?nowpage=${cnt}
			        &boardType=2
			        &searchType=${param.searchType}
			        &searchValue=${param.searchValue}">${cnt}</a>
			    </c:if>
			  </c:forEach>
			
			  <c:if test="${paging.endPage < paging.lastPage}">
			    <a href="qnaList.do?nowpage=${paging.endPage + 1}
			      &boardType=2
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
		$('#writeButton').click(function() {
			  window.location.href = '<%=request.getContextPath()%>/qnaWrite.do?boardType=2';
		});
	});
	
	</script>

</body>
</html>
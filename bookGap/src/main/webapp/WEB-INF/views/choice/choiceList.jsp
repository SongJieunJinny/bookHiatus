<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>choiceList</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/choiceList.css?v=2"/>
<style>
.filterButtons button {
    margin-right: 10px;
}
.bookRecommendType, .bookRecommendComment {
    margin-top: 5px;
    font-size: 14px;
    color: #666;
}
/* 추천 타입 셀렉트박스 영역 정렬 */
.selectBoxWrapper {
    display: flex;
    justify-content: flex-end;  /* 오른쪽 정렬 */
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
}
</style>
</head>
<body>
	<body>
    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <!-- 추천 도서 영역 -->
    <section class="bookList">
        <div class="bookAll">
            <div class="bookTitleName">
                추천 도서 
                <c:choose>
                    <c:when test="${recommendType eq ''}">(전체)</c:when>
                    <c:otherwise>(${recommendType})</c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 추천 타입 필터 버튼 -->
      <div class="filterButtons selectBoxWrapper">
		  <label for="recommendTypeSelect">추천 타입 선택:</label>
		  <select id="recommendTypeSelect" class="form-select" style="width: 150px;  height: 30px;">
		    <option value="" ${recommendType eq '' ? 'selected' : ''}>전체</option>
		    <option value="BASIC" ${recommendType eq 'BASIC' ? 'selected' : ''}>BASIC</option>
		    <option value="SEASON" ${recommendType eq 'SEASON' ? 'selected' : ''}>SEASON</option>
		    <option value="THEME" ${recommendType eq 'THEME' ? 'selected' : ''}>THEME</option>
		  </select>
		</div>
        <!-- 도서 목록 -->
        <div class="bookItems">
            <c:forEach items="${selectBookList}" var="vo">
                <div class="bookItem">
				  <input type="hidden" name="isbn" value="${vo.isbn}">
				  <div class="bookImg">
				    <a href="../product/bookView.do?isbn=${vo.isbn}">
				      <img src="${vo.image}" alt="${vo.title}" />
				    </a>
				  </div>
				  <div class="bookContent">
				    <div class="bookTitle">
				      <c:out value="${fn:replace(vo.title, '(', '<br>(')}" escapeXml="false"/>
				    </div>
				    <div class="bookPrice">${vo.discount}원</div>
				    <div class="bookRecommendType">[추천 종류] ${vo.recommendType}</div>
				    <c:if test="${not empty vo.recommendComment}">
				      <div class="bookRecommendComment">${vo.recommendComment}</div>
				    </c:if>
				  </div>
				</div>
            </c:forEach>
        </div>
    </section>

    <!-- 페이지네이션 -->
    <div class="pagination">
        <c:if test="${paging.startPage > 1}">
            <a href="choiceList.do?nowpage=${paging.startPage - 1}&recommendType=${recommendType}">&lt;</a>
        </c:if>

        <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="cnt">
            <c:choose>
                <c:when test="${paging.nowPage eq cnt}">
                    <a id="default" style="color:#FF5722; cursor:default;">${cnt}</a>
                </c:when>
                <c:otherwise>
                    <a href="choiceList.do?nowpage=${cnt}&recommendType=${recommendType}">${cnt}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${paging.endPage < paging.lastPage}">
            <a href="choiceList.do?nowpage=${paging.endPage + 1}&recommendType=${recommendType}">&gt;</a>
        </c:if>
    </div>
<script>
function filterType(type){
    window.location.href = 'choiceList.do?recommendType=' + type;
}

$(document).ready(function() {
    updateCartCount();
    initHeaderEvents();

    // 셀렉트박스 이벤트 바인딩
    $('#recommendTypeSelect').on('change', function(){
        const selected = $(this).val();
        filterType(selected);
    });
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myOrder</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/order.css"/>
</head>
<body>
<sec:authorize access="isAuthenticated()"> <script>const isLoggedIn = true;</script> </sec:authorize>
<sec:authorize access="isAnonymous()"> <script>const isLoggedIn = false;</script> </sec:authorize>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div id="navOrderDetails">
    <div id="orderDetailsHead">
      <div id="orderDetailsDiv">
        <div id="myInfo"><a href="<%=request.getContextPath()%>/user/mypageInfo.do">My Info</a></div>
          &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="orderDetails"><a href="<%=request.getContextPath()%>/order/myOrder.do">My Order</a></div>
      </div>
    </div>
    <div id="orderDetailsMid">
      <div class="orderDetailsDivLine"></div>
      <div class="orderDetailsDiv">
        <div class="orderDateInfo">
          <input class="orderWeekButton" type="button" value="오늘">
          <input class="orderWeekButton" type="button" value="1주일">
          <input class="orderWeekButton" type="button" value="1개월">
          <input class="orderWeekButton" type="button" value="3개월">
        </div>
        <div class="orderDateInfo">
          <input class="orderDate" id="myOrderStartDate" type="date" value="${startDate}">
          &nbsp;<div class="orderDateSign">～</div>&nbsp;
          <input class="orderDate" id="myOrderEndDate" type="date" value="${endDate}">
          &nbsp;&nbsp;&nbsp;
          <input class="orderDateButton" type="button" value="조회">
        </div>
      </div>
      <c:if test="${empty orderList}">
        <div class="orderMsg" style="display:block;">
          <c:choose>
            <c:when test="${not empty startDate or not empty endDate}"> 해당 기간의 주문내역이 없습니다. </c:when>
            <c:otherwise> 주문내역이 없습니다. </c:otherwise>
          </c:choose>
        </div>
      </c:if>
    </div><br>
    <div id="orderDetailsEnd">
      <c:forEach var="order" items="${orderList}">
      	<!-- 하나의 주문을 감싸는 컨테이너 -->
        <div class="orderContainer" data-order-date="<fmt:formatDate value='${order.orderDate}' pattern='yyyy-MM-dd'/>">
          <div class="orderHeader">
          
            <!-- ✅ 상세 페이지 이동 -->
            <div class="orderPayComplLine" 
                 onclick="goOrderDetailsView(${order.orderId})">주문상세>></div>
          	
          	<!-- 상품들 -->
            <c:forEach var="detail" items="${order.orderDetails}">
						  <div class="orderPayCompl">
						    <img class="orderThumb" 
								     src="<c:out value='${empty detail.book.image ? "/resources/img/no_image.png" : detail.book.image}'/>" 
								     alt="${detail.book.title}"/>
								     
						    <div class="orderInfo">
							    <div class="orderPayDate">
		                <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd" />
		                (주문번호: ${order.orderId})
	                </div>
						      <div class="orderTitle">[${detail.book.bookCategory}] ${detail.book.title}</div>
						      <div class="orderMeta">${detail.book.author} 저자 | ${detail.book.publisher} 출판</div>
						      <div class="orderPrice">
						        <fmt:formatNumber value="${detail.orderPrice}" pattern="#,###"/>원 (수량: ${detail.orderCount}개)
						      </div>
						    </div>
						    
						    <!-- 배송/환불 상태 -->
								<span class="orderShip">
								  <c:choose>
								    <c:when test="${not empty order.refundStatus}">
								      <c:choose>
								        <c:when test="${order.refundStatus == 1 and order.orderStatus == 1}">주문취소 요청</c:when>
				                <c:when test="${order.refundStatus == 1}">환불요청</c:when>
				                <c:when test="${order.refundStatus == 2}">환불처리중</c:when>
				                <c:when test="${order.refundStatus == 3}">환불완료</c:when>
				                <c:when test="${order.refundStatus == 4}">환불거절</c:when>
								      </c:choose>
								    </c:when>
								    <c:otherwise>
								      <c:choose>
								        <c:when test="${order.orderStatus == 1}">배송준비중</c:when>
								        <c:when test="${order.orderStatus == 2}">배송중</c:when>
								        <c:when test="${order.orderStatus == 3}">배송완료</c:when>
								        <c:when test="${order.orderStatus == 4}">주문취소</c:when>
								        <c:when test="${order.orderStatus == 5}">교환 및 반품</c:when>
								      </c:choose>
								    </c:otherwise>
								  </c:choose>
								</span>
						  </div>
						</c:forEach>
          </div>
        </div>
      </c:forEach>
    </div>
    
    <!-- 페이징 -->
		<c:if test="${paging.lastPage > 1}">
		  <div class="paging">
		    <ul class="pagination">
		
		      <!-- « 처음 -->
		      <li class="${paging.nowPage == 1 ? 'disabled' : ''}">
		        <c:url var="firstPageUrl" value="/order/myOrder.do">
		          <c:param name="page" value="1"/>
		          <c:if test="${not empty startDate}"><c:param name="startDate" value="${startDate}"/></c:if>
		          <c:if test="${not empty endDate}"><c:param name="endDate" value="${endDate}"/></c:if>
		        </c:url>
		        <a href="${firstPageUrl}">«</a>
		      </li>
		
		      <!-- ‹ 이전 -->
		      <li class="${paging.nowPage == 1 ? 'disabled' : ''}">
		        <c:url var="prevPageUrl" value="/order/myOrder.do">
		          <c:param name="page" value="${paging.nowPage - 1}"/>
		          <c:if test="${not empty startDate}"><c:param name="startDate" value="${startDate}"/></c:if>
		          <c:if test="${not empty endDate}"><c:param name="endDate" value="${endDate}"/></c:if>
		        </c:url>
		        <a href="${prevPageUrl}">&lt;</a>
		      </li>
		
		      <!-- 숫자 -->
		      <c:forEach var="p" begin="${paging.startPage}" end="${paging.endPage}">
		        <li class="${p == paging.nowPage ? 'active' : ''}">
		          <c:url var="pageUrl" value="/order/myOrder.do">
		            <c:param name="page" value="${p}"/>
		            <c:if test="${not empty startDate}"><c:param name="startDate" value="${startDate}"/></c:if>
		            <c:if test="${not empty endDate}"><c:param name="endDate" value="${endDate}"/></c:if>
		          </c:url>
		          <a href="${pageUrl}">${p}</a>
		        </li>
		      </c:forEach>
		
		      <!-- › 다음 -->
		      <li class="${paging.nowPage == paging.lastPage ? 'disabled' : ''}">
		        <c:url var="nextPageUrl" value="/order/myOrder.do">
		          <c:param name="page" value="${paging.nowPage + 1}"/>
		          <c:if test="${not empty startDate}"><c:param name="startDate" value="${startDate}"/></c:if>
		          <c:if test="${not empty endDate}"><c:param name="endDate" value="${endDate}"/></c:if>
		        </c:url>
		        <a href="${nextPageUrl}">&gt;</a>
		      </li>
		
		      <!-- » 마지막 -->
		      <li class="${paging.nowPage == paging.lastPage ? 'disabled' : ''}">
		        <c:url var="lastPageUrl" value="/order/myOrder.do">
		          <c:param name="page" value="${paging.lastPage}"/>
		          <c:if test="${not empty startDate}"><c:param name="startDate" value="${startDate}"/></c:if>
		          <c:if test="${not empty endDate}"><c:param name="endDate" value="${endDate}"/></c:if>
		        </c:url>
		        <a href="${lastPageUrl}">»</a>
		      </li>
		
		    </ul>
		  </div>
		</c:if>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script>
$(function () {
	updateCartCount();
	initHeaderEvents();

  function updateDateRange(label){ const today = new Date();
																   let start = new Date();
																   if(label === "오늘") start = new Date();
																   else if(label === "1주일") start.setDate(today.getDate()-7);
																   else if(label === "1개월") start.setMonth(today.getMonth()-1);
																   else if(label === "3개월") start.setMonth(today.getMonth()-3);
																   $("#myOrderStartDate").val(start.toISOString().split("T")[0]);
																   $("#myOrderEndDate").val(today.toISOString().split("T")[0]); }
	
  $(".orderWeekButton").on("click", function(){
	  $(".orderWeekButton").removeClass("selected").css({backgroundColor:"white", color:"black"});
	  $(this).addClass("selected").css({backgroundColor:"black", color:"white"});
	  updateDateRange($(this).val());
	});
	
	//'조회' 버튼 클릭 시, 올바른 URL로 페이지 이동
  $(".orderDateButton").on("click", function(){
    const s = $("#myOrderStartDate").val();
    const e = $("#myOrderEndDate").val();
    if(!s || !e){ alert("조회할 시작일과 종료일을 모두 선택해주세요."); return; }
    location.href = "<%=request.getContextPath()%>/order/myOrder.do?page=1&startDate=" + s + "&endDate=" + e;
  });
});

//✅ 상세 페이지 이동 함수
function goOrderDetailsView(orderId) {
	location.href = "<%=request.getContextPath()%>/order/orderDetailsView.do?orderId=" + orderId;
}
</script>
</body>
</html>
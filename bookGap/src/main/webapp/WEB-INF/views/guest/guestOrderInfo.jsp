<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>guestOrderInfo</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/guest/guest.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div id="guestDeliveryInfoNav">
    <div id="guestDeliveryInfoHeadDiv">
      <div id="guestDeliveryInfo">GUEST DELIVERY INFO</div>
    </div>
    <c:forEach var="order" items="${guestOrders}">
	    <div id="guestDeliveryInfoMid">
	      <div class="guestDeliveryInfoDiv1">
	        <div class="guestDeliveryInfoDivLine"></div>
	        <div class="guestDeliveryInfoDiv2">
	          <div class="guestOrderInfo">[주문자 정보]
	            <div class="guestOrderInfo1">${order.guestName}</div>
	            <div class="guestOrderInfo2">${order.guestPhone}</div>
	            <div class="guestOrderInfo3">${order.guestEmail}</div>
	          </div>                        
	        </div>
	      </div>
	      <div class="guestDeliveryInfoDiv1">
	        <div class="guestDeliveryInfoDivLine"></div>
	        <div class="guestDeliveryInfoDiv2">
	          <div class="guestOrderInfo">[배송 정보]
	            <div class="guestOrderInfo1">${order.receiverName}</div>
	            <div class="guestOrderInfo2">${order.receiverPhone}</div>
	            <div class="guestOrderInfo3">${order.receiverRoadAddress} ${order.receiverDetailAddress} (${order.receiverPostCode})</div>
	          </div>                        
	        </div>
	      </div>
	      <div class="guestDeliveryInfoDiv1">
	        <div class="guestDeliveryInfoDivLine"></div>
	        <div class="guestDeliveryInfoDiv2">
	          <div class="guestOrderNum">[주문번호: ${order.orderId}]
	            <div class="guestOrderNumInfo">
	              <span class="orderQuantity"><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/></span>
	              <span class="orderStatus">
									<c:choose>
				            <c:when test="${order.orderStatus == 1}">배송준비중</c:when>
				            <c:when test="${order.orderStatus == 2}">배송중</c:when>
				            <c:when test="${order.orderStatus == 3}">배송완료</c:when>
				            <c:when test="${order.orderStatus == 4}">취소</c:when>
				            <c:when test="${order.orderStatus == 5}">교환/반품</c:when>
				          </c:choose>
								</span>
	            </div>
	          </div>                        
	        </div>
	      </div>
	    </div>
	    <div id="guestDeliveryInfoEnd">
	      <div class="guestOrderPayComplDiv1">
	        <div class="guestOrderPayComplDiv2">
	        <c:forEach var="item" items="${order.orderDetails}">
	          <img id="guestOrderPayComplImg" src="${item.bookImg}">
	          <div class="guestOrderPayCompl">
	            <div class="guestOrderPayComplInfoDiv1">
	              <div class="guestOrderPayComplInfo"><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/></div>
	              <div class="guestOrderPayComplInfo"> ${item.title} | ${item.orderCount} </div>
	              <div class="guestOrderPayComplInfo"> ${item.author} 저자 | ${item.publisher} 출판 </div>
	              <div class="guestOrderPayComplInfo"><fmt:formatNumber value="${order.totalPrice}" type="currency"/></div>
	            </div>
	          </div> 
	          </c:forEach>                       
	        </div>
	      </div>
	    </div>
    </c:forEach>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
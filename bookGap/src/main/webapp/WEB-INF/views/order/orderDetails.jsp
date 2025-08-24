<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderDetails</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/order.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div id="navOrderDetails">
    <div id="orderDetailsHead">
      <div id="orderDetailsDiv">
        <div id="myInfo"><a href="<%=request.getContextPath()%>/user/mypageInfo.do">My Info</a></div>
          &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="orderDetails"><a href="<%=request.getContextPath()%>/order/orderDetails.do">Order Details</a></div>
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
          <input class="orderDate" id="orderDateStart" type="date">
          &nbsp;<div class="orderDateSign">～</div>&nbsp;
          <input class="orderDate" id="orderDateLast" type="date">
          &nbsp;&nbsp;&nbsp;
          <input class="orderDateButton" type="button" value="조회">
        </div>
      </div>
      <div class="orderMsg">조회할 기간을 선택해주세요.</div>
    </div><br>
    <div id="orderDetailsEnd">
    	<c:if test="${empty orderList}">
				<div class="orderMsg" style="display:block;">주문내역이 없습니다.</div>
      </c:if>
      
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
								        <c:when test="${order.orderStatus == 4}">배송취소</c:when>
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
		      <!-- 처음/이전 묶음 -->
		      <li class="${paging.startPage == 1 ? 'disabled' : ''}">
		        <a href="<c:url value='/order/orderDetails.do'><c:param name='page' value='1'/></c:url>">«</a>
		      </li>
		      <c:forEach var="p" begin="${paging.startPage}" end="${paging.endPage}">
		        <li class="${p == paging.nowPage ? 'active' : ''}">
		          <a href="<c:url value='/order/orderDetails.do'><c:param name='page' value='${p}'/></c:url>">
		            ${p}
		          </a>
		        </li>
		      </c:forEach>
		      <!-- 끝/다음 묶음 -->
		      <li class="${paging.endPage == paging.lastPage ? 'disabled' : ''}">
		        <a href="<c:url value='/order/orderDetails.do'><c:param name='page' value='${paging.lastPage}'/></c:url>">»</a>
		      </li>
		    </ul>
		  </div>
		</c:if>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
$(function () {
	let isbn = $("#isbn").val(); // <input type="hidden" id="isbn" value="...">
	if (!isbn) {
	  const m = location.search.match(/[?&]isbn=([^&]+)/);
	  if (m) isbn = decodeURIComponent(m[1]);
	}
	if (!isbn) {
	  isbn = "${bookDetail.isbn}";
	}
	if (!isbn) {
	  isbn = "${bookDetail.productInfo != null ? bookDetail.productInfo.isbn : ''}";
	}

	// 이제만 호출
	if (isbn) {
	  loadComment(isbn);
	} else {
	  console.error("isbn이 비어 있어 댓글을 불러올 수 없습니다.");
	}
	
  updateCartCount();
  initHeaderEvents();

  //✅ 기간 필터링
  function filterAndDisplayOrders() {
    const s = $("#orderDateStart").val();
    const e = $("#orderDateLast").val();
    if (!s || !e) {
      $(".orderContainer").hide();
      $(".orderMsg").text("조회할 기간을 선택해주세요.").show();
      return;
    }
    const start = new Date(s);
    const end = new Date(e); end.setHours(23,59,59,999);
    let found = 0;
    $(".orderContainer").each(function(){
      const d = $(this).data("order-date");
      if (!d) return;
      const od = new Date(d);
      const hit = od >= start && od <= end;
      $(this).toggle(hit);
      if (hit) found++;
    });
    $(".orderMsg").toggle(found === 0)
                  .text(found === 0 ? "해당 기간의 주문내역이 없습니다." : "");
  }

  function updateDateRange(v){
    const label = String(v).trim();
    const today = new Date();
    let start = new Date();
    if (label === "오늘") start = new Date();
    else if (label === "1주일") start.setDate(today.getDate() - 7);
    else if (label === "1개월") start.setMonth(today.getMonth() - 1);
    else if (label === "3개월") start.setMonth(today.getMonth() - 3);

    $("#orderDateStart").val(start.toISOString().split("T")[0]);
    $("#orderDateLast").val(today.toISOString().split("T")[0]);
  }

  //초기 상태: 아무 값도 세팅하지 않고, 버튼 선택도 없음
  $("#orderDateStart, #orderDateLast").val("");
	$(".orderWeekButton").removeClass("selected").css({backgroundColor:"white", color:"black"});
	$(".orderContainer").hide();                           // ← 초기엔 안 보이게
	$(".orderMsg").text("조회할 기간을 선택해주세요.").show();
	
	// 주문 없으면 메시지만 바꾸고 필터 UI 숨김(선택)
	if ($(".orderContainer").length === 0) {
	  $(".orderMsg").text("주문내역이 없습니다.");
	  $("#orderDetailsMid .orderDetailsDiv").hide();
	}

  $(".orderWeekButton").on("click", function(){
	  $(".orderWeekButton").removeClass("selected").css({backgroundColor:"white", color:"black"});
	  $(this).addClass("selected").css({backgroundColor:"black", color:"white"});
	  updateDateRange($(this).val());
	  filterAndDisplayOrders();  // 버튼 누르면 즉시 필터
	});

	$(".orderDateButton").on("click", filterAndDisplayOrders);
	
  // 버튼 스타일 & 동작
  $(".orderWeekButton").on("mouseenter", function(){
    if (!$(this).hasClass("selected")) $(this).css({backgroundColor:"black", color:"white"});
  }).on("mouseleave", function(){
    if (!$(this).hasClass("selected")) $(this).css({backgroundColor:"white", color:"black"});
  });

});

//✅ 상세 페이지 이동 함수
function goOrderDetailsView(orderId) {
	location.href = "<%=request.getContextPath()%>/order/orderDetailsView.do?orderId=" + orderId;
}

//✅ 장바구니 수량 업데이트
function updateCartCount() {
  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
  let cartCountElement = $("#cart-count"); // jQuery 셀렉터 사용
  if (cartCountElement.length) {
    cartCountElement.text(cartItems.length).css("visibility", cartItems.length > 0 ? "visible" : "hidden");
  }
}
</script>
</body>
</html>
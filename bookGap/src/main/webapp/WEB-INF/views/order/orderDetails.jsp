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
            <input class="orderWeekButton" type="button" value="1주일 ">
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
            
            <!-- 주문 정보 헤더 (주문일, 주문번호, 배송상태) -->
            <div class="orderHeader">
              <div class="orderPayDate">
                <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd" />
                (주문번호: ${order.orderId})
              </div>
              <div class="orderStatus">
                <c:choose>
                  <c:when test="${order.orderStatus == 1}">배송준비중</c:when>
                  <c:when test="${order.orderStatus == 2}">배송중</c:when>
                  <c:when test="${order.orderStatus == 3}">배송완료</c:when>
                  <c:when test="${order.orderStatus == 4}">주문취소</c:when>
                  <c:when test="${order.orderStatus == 5}">교환/반품</c:when>
                  <c:otherwise>상태미정</c:otherwise>
                </c:choose>
              </div>
            </div>
            
            <!-- 주문에 포함된 상품 목록 -->
            <c:forEach var="detail" items="${order.orderDetails}">
              <div class="orderPayComplDiv">
                <img class="orderPayComplImg" src="${detail.book.image}" alt="${detail.book.title}">
                <div class="orderPayCompl">
                  <div class="orderPayComplInfoDiv1">
                    <div class="orderPayComplInfo">[${detail.book.bookCategory}] ${detail.book.title}</div>
                    <div class="orderPayComplInfo">${detail.book.author} 저자 | ${detail.book.publisher} 출판</div>
                    <div class="orderPayComplInfo">
                        <fmt:formatNumber value="${detail.orderPrice}" pattern="#,###" />원 (수량: ${detail.orderCount}개)
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:forEach>
      </div>

      <!--페이징-->
      <c:if test="${not empty orderList and fn:length(orderList) > 3}">
	      <div class="paging">
	        <ul class="pagination">
		        <li class="disabled"><a href="#">«</a></li>
		        <li class="active"><a href="#">1</a></li>
		        <li><a href="#">2</a></li>
		        <li><a href="#">3</a></li>
		        <li><a href="#">4</a></li>
		        <li><a href="#">5</a></li>
		        <li><a href="#">»</a></li>
	        </ul>
	      </div>
      </c:if>
    </div>
  </section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
   $(document).ready(function () {
		updateCartCount(); // 장바구니 개수 업데이트
		initHeaderEvents();		
		
		function filterAndDisplayOrders() {
	        let startDateString = $("#orderDateStart").val();
	        let endDateString = $("#orderDateLast").val();

	        if(!startDateString || !endDateString) {
	            $(".orderContainer").show(); // 날짜 선택 안했으면 모든 주문 컨테이너를 보여줌
	            $(".orderMsg").hide();
	            return;
	        }

	        let startDate = new Date(startDateString);
	        let endDate = new Date(endDateString);
	        endDate.setHours(23, 59, 59, 999);

	        let foundOrders = 0;
	        $(".orderContainer").hide(); // 모든 주문 컨테이너를 숨김

	        $(".orderContainer").each(function () {
	            // ▼▼▼ [수정] data-order-date 속성에서 날짜를 읽어옴 ▼▼▼
	            let dateText = $(this).data("order-date");
	            if(dateText) {
	                let orderDate = new Date(dateText);
	                if(orderDate >= startDate && orderDate <= endDate){
	                    $(this).show();
	                    foundOrders++;
	                }
	            }
	        });

	        if(foundOrders > 0){
	            $(".orderMsg").hide();
	        } else {
	            $(".orderMsg").text("해당 기간의 주문내역이 없습니다.").show();
	        }
	    }

	    // 날짜 범위 설정 함수 (수정 없음)
	    function updateDateRange(value) { /* ... */ }
	    
	    // 페이지 로드 시 초기 상태 설정 (개선된 버전)
	    if ($(".orderContainer").length > 0) {
	        // 주문 내역이 있으면 '1개월' 버튼을 기본으로 클릭하고 조회
	        $(".orderWeekButton[value='1개월']").click(); 
	        filterAndDisplayOrders();
	    } else {
	        // 주문 내역이 없으면 메시지 표시
	        $(".orderMsg").text("주문내역이 없습니다.").show();
	        $("#orderDetailsMid .orderDetailsDiv").hide(); // 날짜 필터 자체를 숨김
	    }
		
	    // ... (이벤트 핸들러는 기존과 동일) ...
	});
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
$(document).ready(function () {
	// 날짜를 기준으로 주문을 필터링하고 결과를 표시하는 함수
  function filterAndDisplayOrders() {
    let startDateString = $("#orderDateStart").val();
    let endDateString = $("#orderDateLast").val();

    // 날짜가 하나라도 설정되지 않았다면 함수 종료
    if(!startDateString || !endDateString){
	    $(".orderPayComplDiv").show();
	    $(".orderMsg").hide(); // 날짜가 없을땐 메시지를 숨겨야함
	    return;
	  }

    let startDate = new Date(startDateString);
    let endDate = new Date(endDateString);
    // 종료 날짜의 시간을 23:59:59로 설정하여 해당일 전체를 포함하도록 함
    endDate.setHours(23, 59, 59, 999);

    let foundOrders = 0;
    $(".orderPayComplDiv").hide(); // 우선 모든 주문내역을 숨김

    $(".orderPayComplDiv").each(function () {
    	let dateText = $(this).find(".orderPayDate").text().trim().split('(')[0].trim();
      let orderDate = new Date(dateText);

      // 주문 날짜가 선택된 범위 내에 있는지 확인
      if(orderDate >= startDate && orderDate <= endDate){
        $(this).show(); // 조건에 맞으면 표시
        foundOrders++;
      }
    });

    // 조회된 주문이 있으면 메시지를 숨기고, 없으면 '주문내역이 없습니다'를 표시
    if(foundOrders > 0){
      $(".orderMsg").hide();
    }else{
      $(".orderMsg").text("해당 기간의 주문내역이 없습니다.").show();
    }
  }

  // 날짜 범위를 설정하는 함수
  function updateDateRange(value) {
    let today = new Date();
    let startDate = new Date(today.getTime()); // 새로운 객체 복사
    
    const cleanValue = value.trim(); 

    if(value === "오늘"){
      startDate = new Date(today.getTime());
    }else if(value === "1주일"){
      startDate.setDate(today.getDate() - 7);
    }else if(value === "1개월"){
      startDate.setMonth(today.getMonth() - 1);
    }else if(value === "3개월"){
      startDate.setMonth(today.getMonth() - 3);
    }

    let todayStr = today.toISOString().split("T")[0];
    let startDateStr = startDate.toISOString().split("T")[0];

    console.log("클릭된 버튼:", value);
    console.log("시작 날짜:", startDateStr);
    console.log("오늘 날짜:", todayStr);

    $("#orderDateStart").val(startDateStr);
    $("#orderDateLast").val(todayStr);
  }
  
  //페이지 로드 시 초기 상태 설정
  $("#orderDateStart").val("");
  $("#orderDateLast").val("");
  $(".orderMsg").hide(); // 메시지만 숨깁니다.
  if($(".orderPayComplDiv").length === 0){
      $(".orderMsg").text("주문내역이 없습니다.").show();
  }

  //기간 버튼에 대한 호버(hover) 이벤트
  $(".orderWeekButton").hover(
	  function() { $(this).css({backgroundColor: "black", color: "white"}); },
	  function() { if (!$(this).hasClass("selected")) $(this).css({backgroundColor: "white", color: "black"}); }
	);
  
	$(".orderWeekButton").click(function () {
	  $(".orderWeekButton").removeClass("selected").css({backgroundColor: "white", color: "black"});
	  $(this).addClass("selected").css({backgroundColor: "black", color: "white"});
	  updateDateRange($(this).val());
	});
	
	$(".orderDateButton").click(filterAndDisplayOrders);
});
</script>
</body>
</html>
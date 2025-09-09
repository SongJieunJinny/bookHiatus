<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderDetailsView</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/order.css"/>
</head>
<body>
<sec:authorize access="isAuthenticated()"> <script> const isLoggedIn = true; </script> </sec:authorize>
<sec:authorize access="isAnonymous()"> <script>const isLoggedIn = false;</script> </sec:authorize>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div class="orderDetailView">
    <div class="orderDetailViewTitle">Order Details</div>

    <!-- 주문 주문 정보 -->
    <div class="orderDetailTitle">주문 정보</div>
    <div class="orderInfoBox">
      <p><strong>주문번호 : </strong>${order.orderKey}</p>
      <p><strong>주문일 : </strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
     <p><strong>결제수단 : </strong>
		  <c:choose>
			  <c:when test="${not empty order.payment && order.payment.paymentMethod == 1}">TossPay</c:when>
			  <c:when test="${not empty order.payment && order.payment.paymentMethod == 2}">KakaoPay</c:when>
			  <c:otherwise>결제수단 정보 없음</c:otherwise>
		  </c:choose>
     </p>
    </div>
    
    <!-- 배송 정보 -->
		<div class="orderDetailTitle">배송 정보</div>
    <div class="deliveryInfoBox">
      <p><strong>수령인 : </strong> ${order.receiverName}</p>
      <p><strong>연락처 : </strong> ${order.receiverPhone}</p>
      <p><strong>주소 : </strong> ${order.receiverRoadAddress} ${order.receiverDetailAddress} (${order.receiverPostCode})</p>
      <c:if test="${not empty order.courier}"> <p><strong>택배사 : </strong> ${order.courier}</p> </c:if>
      <c:if test="${not empty order.invoice}"> <p><strong>송장번호 : </strong> ${order.invoice}</p> </c:if>
      <p><strong>배송상태 : </strong>
        <span id="deliveryStatusText" class="status-refund-${order.refundStatus}">
          <c:choose>
            <c:when test="${not empty order.refundStatus and order.refundStatus > 0}">
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
      </p>
    </div>

    <!-- 상품 내역 -->
    <div class="orderDetailTitle">상품 내역</div>
    <table class="orderTable">
      <thead>
        <tr>
          <th>상품 이미지</th>
          <th>제목</th>
          <th>저자 / 출판사</th>
          <th>수량</th>
          <th>가격</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="item" items="${order.orderDetails}">
          <tr>
            <td><img src="<c:out value='${empty item.book.image ? "/resources/img/no_image.png" : item.book.image}'/>" alt="${item.book.title}" style="width:80px;"/></td>
            <td>${item.book.title}</td>
            <td>${item.book.author} / ${item.book.publisher}</td>
            <td>${item.orderCount}개</td>
            <td><fmt:formatNumber value="${item.orderPrice}" pattern="#,###"/>원</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- 취소/환불 영역 -->
    <div class="orderDetailTitle">
	    <c:choose>
        <c:when test="${order.orderStatus == 1}"> 주문 취소 </c:when>
        <c:otherwise> 환불 신청 </c:otherwise>
	    </c:choose>
		</div>
		
		<c:if test="${order.orderStatus != 4 && (order.refundStatus == null or order.refundStatus == 0)}">
			<form class="refundForm" id="refundForm" method="POST" action="<%=request.getContextPath()%>/refund/apply.do">
				<div class="refundFormLine">
				  <!-- 서버 값 전달 -->
				  <input type="hidden" name="orderId" value="${order.orderId}">
				  <input type="hidden" name="paymentNo" value="${not empty order.payment ? order.payment.paymentNo : order.paymentNo}">
	
				  <label>
	          <c:choose>
	            <c:when test="${order.orderStatus == 1}"> 취소 이유 </c:when>
	            <c:otherwise> 환불 사유 </c:otherwise>
		        </c:choose>
          </label>
				  <textarea class="refundFormReason" name="refundReason" required ></textarea>
				  
				  <label>환불 및 취소 안내</label>
				  <div class="refundInfoForm">
				  - 상품취소 시 취소수수료가 부과될 경우 환불될 금액에서 차감 후 나머지 금액을 환불 해 드립니다.<br>
				  - 단, 사용된 결제수단에 따라 예치금으로 환불 될 수 있습니다.<br>
				  - 카드이용 후 취소요청 시 카드사 정책에 따라 환불기간 소요될 수 있습니다.<br>
				  - 부분취소로 무료배송 기준 금액이 미만일 경우 배송비가 발생할 수 있으며 이 경우 배송비를 제한 후 환불 됩니다.<br>
				  - 반품/교환 시 단순변심에 의한 배송비 발생 시 해당 배송비를 제한 후 환불 됩니다.
				  </div>
				  
					<button class="refundFormButton" type="submit">
            <c:choose>
              <c:when test="${order.orderStatus == 1}"> 주문 취소하기 </c:when>
              <c:otherwise> 환불 신청하기 </c:otherwise>
            </c:choose>
          </button>
        </div>
      </form>
    </c:if>
		
		<!-- 상태 표시 박스 (알림창 대신 화면에 표시) -->
		<div id="refundStatusBox">
      상태 : <strong id="refundStatusText"></strong>
    </div>
    <button id="backMyOrder">주문화면 돌아가기</button>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
$(document).ready(function () {
  updateCartCount();
  initHeaderEvents();

  const orderStatus = "${order.orderStatus}";
  const refundStatus = "${order.refundStatus}";

  // ---------------------페이지 로딩 시 초기 상태 설정--------------------- //
  if(refundStatus && refundStatus > 0){
    showStatus(getRefundStatusText(Number(refundStatus), orderStatus));
    $("#refundForm").hide();
  }else{
    $("#refundStatusBox").hide();
  }

  // ---------------------주문 목록으로 돌아가기--------------------- //
  $('#backMyOrder').on('click', function () { window.location.href = "<%= request.getContextPath() %>/order/myOrder.do"; });

  // ---------------------"주문취소"와 "환불신청" 로직을 하나로 통합--------------------- //
  $("#refundForm").on("submit", function (e) {
    e.preventDefault();

    const $form = $(this);
    const $button = $form.find('button[type="submit"]');
    const originalButtonText = $button.text(); // 원래 버튼 텍스트 저장

    const paymentNo = $form.find('input[name="paymentNo"]').val();
    if(!paymentNo || paymentNo === '0'){
      alert("결제 정보가 유효하지 않아 신청할 수 없습니다.");
      return;
    }

    const confirmMessage = (orderStatus == 1) 
      ? "주문을 취소하시겠습니까? 관리자 확인 후 처리됩니다." 
      : "정말로 환불을 신청하시겠습니까?";
        
    if (!confirm(confirmMessage)) return;

    $button.prop('disabled', true).text('처리 중...');
    const formData = new URLSearchParams(new FormData(this)).toString();
    
    // 어떤 경우든 항상 '/refund/apply.do' API를 호출
    fetch(this.action, { method: this.method,
								         headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
								         body: formData })
    .then(res => res.text())
    .then(result => {
      if(result === "success"){
        alert("신청이 정상적으로 접수되었습니다.");
        $form.hide();
        const newStatusText = (orderStatus == 1) ? "주문취소 요청" : "환불요청";
        showStatus(newStatusText);
      }else{
        alert("신청 실패: " + result);
        $button.prop('disabled', false).text(originalButtonText); 
      }
    })
    .catch(err => {
      alert("처리 중 오류가 발생했습니다: " + err.message);
      $button.prop('disabled', false).text(originalButtonText);
    });
  });
});

//---------------------공통 함수들 (기존 코드와 동일)--------------------- //
function showStatus(text) {
  $("#deliveryStatusText").text(text);
  
  $("#refundStatusText").text(text);
  $("#refundStatusBox").show();
}

function getRefundStatusText(status, orderStatus) {

	if(status === 1 && orderStatus == 1){ return "주문취소 요청"; }

  switch (status) {
    case 1: return "환불요청";
    case 2: return "환불처리중";
    case 3: return "환불완료";
    case 4: return "환불거절";
    default: return "상태 미확인";
  }
}
</script>
</body>
</html>
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
    <c:forEach var="order" items="${guestOrders}" varStatus="status">
	    <div id="guestDeliveryInfoMid">
	      <!-- 주문자 정보 -->
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
	      <!-- 배송 정보 -->
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
	      <!-- 주문 정보 -->
	      <div class="guestDeliveryInfoDiv1">
	        <div class="guestDeliveryInfoDivLine"></div>
	        <div class="guestDeliveryInfoDiv2">
	          <div class="guestOrderNum">[주문번호: ${order.orderId}]
	            <div class="guestOrderInfo2">주문일시 : <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/></div>
	            <div class="guestOrderNumInfo">
								<span class="orderStatus" 
                      data-order-id="${order.orderId}" 
								      onclick="openGuestRefundModal('${order.orderId}', '${order.paymentNo}')">
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
	          </div>
	        </div>
	      </div>
	    </div>
	    <!-- 주문 상품 목록 -->
	    <div id="guestDeliveryInfoEnd">
	      <div class="guestOrderPayComplDiv1">
	        <div class="guestOrderPayComplDiv2" data-order-idx="${status.index}">
	          <div class="orderPayComplLine">주문상세>></div>
		        <c:forEach var="item" items="${order.orderDetails}" varStatus="s">
		          <div class="orderItem" data-price="${item.orderPrice}" 
													           data-qty="${item.orderCount}" 
													           data-order-idx="${status.index}" 
													           data-idx="${s.index}">
			           <img id="guestOrderPayComplImg" 
                      src="<c:out value='${empty item.book.productInfo.image ? "/resources/img/no_image.png" : item.book.productInfo.image}'/>" 
                      alt="${item.book.productInfo.title}">
			          <div class="guestOrderPayCompl">
			            <div class="guestOrderPayComplInfoDiv1">
			              <div class="guestOrderPayComplInfo"> ${item.book.productInfo.title} | ${item.orderCount}권 </div>
			              <div class="guestOrderPayComplInfo"> ${item.book.productInfo.author} 저자 | ${item.book.productInfo.publisher} 출판 </div>
			              <div class="guestOrderPayComplInfo orderLineTotal" id="orderLineTotal-${status.index}-${s.index}"></div>
			              <div class="guestOrderPayComplInfo orderTotal" id="orderTotal-${status.index}"  style="margin-top:15px; font-weight:bold;"></div>
			            </div>
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
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();

  $(".guestOrderPayComplDiv2").each(function() {
    let orderIdx = $(this).data("order-idx");
    let productTotal = 0;

    $(this).find(".orderItem").each(function() {
      let price = parseInt($(this).data("price"));
      let qty = parseInt($(this).data("qty"));
      let idx = $(this).data("idx");

      let lineTotal = price * qty;
      productTotal += lineTotal;

      // ✅ 상품별 합계 표시
      $("#orderLineTotal-" + orderIdx + "-" + idx).html(
        new Intl.NumberFormat('ko-KR').format(price) + "원 × " + qty + " = " +
        "<strong>" + new Intl.NumberFormat('ko-KR').format(lineTotal) + "원</strong>"
      );
    });

    // ✅ 주문별 배송비/총액 계산
    let deliveryFee = (productTotal >= 50000) ? 0 : 3000;
    let finalTotal = productTotal + deliveryFee;

    $("#orderTotal-" + orderIdx).html(
      "주문합계: " + new Intl.NumberFormat('ko-KR').format(productTotal) + "원" +
      " + 배송비 " + new Intl.NumberFormat('ko-KR').format(deliveryFee) + "원" +
      " = <strong>" + new Intl.NumberFormat('ko-KR').format(finalTotal) + "원</strong>"
    );
  });
});
</script>
<!-- 환불 신청 모달 -->
<div id="guestRefundModal" class="guestRefundModal">
  <div class="guestRefundModalContent">
    <span class="close" onclick="closeGuestRefundModal()">&times;</span>
    <h3>환불 신청</h3>
    <form id="guestRefundForm">
      <input type="hidden" name="orderId" id="guestRefundOrderId">
      <input type="hidden" name="paymentNo" id="guestRefundPaymentNo">

      <label>환불 사유</label><br>
      <textarea name="refundReason" required style="min-height:80px;"></textarea><br><br>

      <label>사진 첨부</label><br>
      <input type="file" name="refundImage"><br><br>

      <label>이메일</label><br>
      <input type="email" name="refundMail" required><br><br>

      <button type="button" onclick="submitGuestRefund()">신청하기</button>
    </form>

    <!-- 환불 상태 표시 -->
    <div id="guestRefundStatusBox"></div>
  </div>
</div>
<script>
/* 환불 모달 열기 (비회원) */
function openGuestRefundModal(orderId, paymentNo) {
  document.getElementById("guestRefundOrderId").value = orderId;
  document.getElementById("guestRefundPaymentNo").value = paymentNo;
  document.getElementById("guestRefundModal").style.display = "block";

  // 기존 환불 정보 조회
  fetch("<%=request.getContextPath()%>/refund/status.do?orderId=" + orderId + "&paymentNo=" + paymentNo)
  .then(res => res.json())
  .then(refund => {
    const form = document.getElementById("guestRefundForm");
    const box = document.getElementById("guestRefundStatusBox");

    if (refund) {
	    form.querySelector("textarea[name='refundReason']").value = refund.refundReason;
	    form.querySelector("textarea[name='refundReason']").readOnly = true;
	    form.querySelector("textarea[name='refundReason']").classList.add("readonly");
	
	    form.querySelector("input[name='refundMail']").value = refund.refundMail;
	    form.querySelector("input[name='refundMail']").readOnly = true;
	    form.querySelector("input[name='refundMail']").classList.add("readonly");
	
	    form.querySelector("button").style.display = "none";
	
	    let statusText = getRefundStatusText(refund.refundStatus);
	    box.innerText = "현재 상태: " + statusText;
	    box.className = "status-refund-" + refund.refundStatus;
    } else {
	    form.reset();
	    form.querySelector("textarea[name='refundReason']").readOnly = false;
	    form.querySelector("textarea[name='refundReason']").classList.remove("readonly");
	    form.querySelector("input[name='refundMail']").readOnly = false;
	    form.querySelector("input[name='refundMail']").classList.remove("readonly");
	    form.querySelector("button").style.display = "inline-block";
	    box.innerText = "";
	    box.className = "";
    }
  });
}

/* 환불 상태 텍스트/색상 */
function getRefundStatusText(status) {
  switch (status) {
    case 1: return "환불요청";
    case 2: return "환불처리중";
    case 3: return "환불완료";
    case 4: return "환불거절";
    default: return "-";
  }
}

/* 환불 신청 (비회원) */
function submitGuestRefund() {
  const form = document.getElementById("guestRefundForm");
  const formData = new FormData(form);

  fetch("<%=request.getContextPath()%>/refund/apply.do", {
    method: "POST",
    body: formData
  })
  .then(res => res.text())
  .then(result => {
    if (result === "success") {
      alert("환불 신청이 완료되었습니다.");
      document.getElementById("guestRefundModal").style.display = "none";

      // 화면 상태 갱신
      const orderId = form.querySelector("input[name='orderId']").value;
      const paymentNo = form.querySelector("input[name='paymentNo']").value;
      updateGuestOrderStatus(orderId, paymentNo);
    } else {
      alert("환불 신청에 실패했습니다.");
    }
  });
}

/* 환불 상태 갱신 (비회원) */
function updateGuestOrderStatus(orderId, paymentNo) {
  fetch("<%=request.getContextPath()%>/refund/status.do?orderId=" + orderId + "&paymentNo=" + paymentNo)
    .then(res => res.json())
    .then(refund => {
      if (refund) {
        let statusText = getRefundStatusText(refund.refundStatus);
        document.querySelectorAll(".orderStatus[data-order-id='" + orderId + "']")
          .forEach(el => {
            el.innerText = statusText;
            el.className = "orderStatus status-refund-" + refund.refundStatus;
          });
      }
    });
}

/* 모달 닫기 */
function closeGuestRefundModal() {
  document.getElementById("guestRefundModal").style.display = "none";
}
</script>
</body>
</html>
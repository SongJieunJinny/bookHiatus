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
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div class="orderDetailView">
    <div class="orderDetailViewTitle">Order Details</div>

    <!-- 주문 기본 정보 -->
    <div class="orderDetailTitle">주문 정보</div>
    <div class="orderInfoBox">
      <p><strong>주문번호 : </strong> ${order.orderId}</p>
      <p><strong>주문일 : </strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
      <p><strong>결제번호 : </strong> ${order.paymentNo}</p>
    </div>
    
    <!-- 주문 상품 목록 -->
		<div class="orderDetailTitle">배송 정보</div>
		<div class="deliveryInfoBox">
			<p><strong>수령인 : </strong> ${order.receiverName}</p>
			<p><strong>연락처 : </strong> ${order.receiverPhone}</p>
			<p><strong>주소 : </strong> ${order.receiverRoadAddress} ${order.receiverDetailAddress} (${order.receiverPostCode})</p>
			<c:if test="${not empty order.courier}">
	      <p><strong>택배사 : </strong> ${order.courier}</p>
	    </c:if>
	    <c:if test="${not empty order.invoice}">
	      <p><strong>송장번호 : </strong> ${order.invoice}</p>
	    </c:if>
			<p><strong>주문상태 : </strong>
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
			</p>
		</div>

    <!-- 주문 상세 상품 목록 -->
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
            <td>
              <img src="<c:out value='${empty item.book.image ? "/resources/img/no_image.png" : item.book.image}'/>"
                   alt="${item.book.title}" style="width:80px;"/>
            </td>
            <td>${item.book.title}</td>
            <td>${item.book.author} / ${item.book.publisher}</td>
            <td>${item.orderCount}개</td>
            <td><fmt:formatNumber value="${item.orderPrice}" pattern="#,###"/>원</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- 환불 신청 폼 -->
    <div class="orderDetailTitle">환불 신청</div>
		<form class="refundForm" id="refundForm" method="POST" action="<%=request.getContextPath()%>/refund/apply.do">
			<div class="refundFormLine">
			  <input type="hidden" name="orderId" value="${order.orderId}">
			  <input type="hidden" name="paymentNo" value="${not empty order.payment ? order.payment.paymentNo : order.paymentNo}">
			  
			  <label>메일 입력</label>
			  <br><input class="refundFormMail" type="email" name="refundMail" required><br>
			  
			  <label>환불 사유</label>
			  <textarea class="refundFormReason" name="refundReason" required ></textarea>
			  <button class="refundFormButton" type="submit">환불 신청하기</button>
			</div>
		  
		</form>
		<div id="refundStatusBox">
      환불 신청 상태 : <strong id="refundStatusText"></strong>
    </div>
    <button id="backMyOrder">주문화면 돌아가기</button>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();
  checkExistingRefund(); // 페이지 로드 시, 기존 환불 신청 내역 확인

  $('#backMyOrder').click(function() {
	  window.location.href = '<%=request.getContextPath()%>/order/myOrder.do';
  });
  
  $("#refundForm").submit(function(e) {
    e.preventDefault(); 
    
    const paymentNo = $(this).find('input[name="paymentNo"]').val();
    if (!paymentNo || paymentNo === '0') {
      alert('결제 정보가 유효하지 않아 환불을 신청할 수 없습니다.');
      return;
    }

    if (!confirm("정말로 환불을 신청하시겠습니까?")) { return; }

    const formData = new URLSearchParams(new FormData(this)).toString();

    fetch(this.action, { // form 태그의 action 속성 값을 URL로 사용
      method: this.method, // form 태그의 method 속성 값(POST)을 사용
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: formData 
    })
    .then(response => {
      if (response.ok) {
        return response.text();
      } else {
        return response.text().then(text => {
          throw new Error(text || '서버 오류가 발생했습니다.');
        });
      }
    })
    .then(result => {
      if (result === "success") {
        alert("환불 신청이 성공적으로 완료되었습니다. 주문 목록 페이지로 이동합니다.");
        location.href = "<%=request.getContextPath()%>/order/myOrder.do";
      } else {
        alert("환불 신청에 실패했습니다: " + result);
      }
    })
    .catch(err => {
      console.error("환불 신청 처리 중 오류:", err);
      alert("처리 중 오류가 발생했습니다: " + err.message);
    });
  });
});

function checkExistingRefund() {
  const orderId = "${order.orderId}";
  const paymentNo = "${not empty order.payment ? order.payment.paymentNo : order.paymentNo}";

  if (!orderId || !paymentNo || paymentNo === '0') { $("#refundForm").hide(); return; }
  
  fetch(`<%=request.getContextPath()%>/refund/status.do?orderId=\${orderId}&paymentNo=\${paymentNo}`)
    .then(res => res.text())
    .then(text => {
      if(text) { // 응답 내용이 있을 때만 JSON으로 파싱합니다.
        try {
          const refund = JSON.parse(text);
          if(refund && refund.refundStatus) {
            $("#refundForm").hide();
            const statusText = getRefundStatusText(refund.refundStatus);
            $("#refundStatusText").text(statusText);
            $("#refundStatusBox").show();
          }
        } catch (e) {
          console.error("JSON 파싱 오류:", e);
        }
      }
  });
}

function getRefundStatusText(status) {
  switch (status) {
    case 1: return "환불요청";
    case 2: return "환불처리중";
    case 3: return "환불완료";
    case 4: return "환불거절";
    default: return "상태 미확인";
  }
}

// ✅ 장바구니 수량 업데이트 (기존 코드와 동일)
function updateCartCount() {
  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
  let cartCountElement = $("#cart-count");
  if (cartCountElement.length) {
    cartCountElement.text(cartItems.length).css("visibility", cartItems.length > 0 ? "visible" : "hidden");
  }
}
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>guestOrderDetailsView</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/guest/guest.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div class="orderDetailView">
    <div class="orderDetailViewTitle">Guest Order Details</div>

    <!-- 주문 기본 정보 -->
    <div class="guestOrderDetailsTitle">주문 정보</div>
    <div class="orderInfoBox">
      <p><strong>주문번호 :</strong> ${order.orderId}</p>
      <p><strong>주문일 :</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
      <p><strong>결제번호 :</strong> ${order.payment.paymentNo}</p>
      <p><strong>이메일 :</strong> ${order.guestEmail}</p>
    </div>

    <!-- 주문 상품 목록 -->
		<div class="guestOrderDetailsTitle">배송 정보</div>
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

    <!-- 주문 상품 목록 -->
    <div class="guestOrderDetailsTitle">상품 내역</div>
    <table class="orderTable">
      <thead>
        <tr>
          <th>상품 이미지</th>
          <th>제목</th>
          <th>저자/출판사</th>
          <th>수량</th>
          <th>가격</th>
        </tr>
      </thead>
      <tbody>
      <c:forEach var="item" items="${order.orderDetails}">
			  <tr>
			    <td>
			      <img src="<c:out value='${empty item.book.productInfo.image ? "/resources/img/no_image.png" : item.book.productInfo.image}'/>"
			           alt="${item.book.productInfo.title}" style="width:80px;"/>
			    </td>
			    <td>${item.book.productInfo.title}</td>
			    <td>${item.book.productInfo.author} / ${item.book.productInfo.publisher}</td>
			    <td>${item.orderCount}개</td>
			    <td><fmt:formatNumber value="${item.orderPrice}" pattern="#,###"/>원</td>
			  </tr>
			</c:forEach>
      </tbody>
    </table>

    <!-- 환불 신청 폼 -->
    <div class="guestOrderDetailsTitle">환불 신청</div>
    <input type="hidden" id="guestEmailForRedirect" value="${guestEmail}">
    <input type="hidden" id="orderPasswordForRedirect" value="${orderPassword}">
    <form class="guestRefundForm" id="guestRefundForm" method="POST" action="<%=request.getContextPath()%>/refund/apply.do">
    <div class="guestRefundFormLine">
		  <input type="hidden" name="orderId" value="${order.orderId}">
		  <input type="hidden" name="paymentNo" value="${not empty order.payment ? order.payment.paymentNo : order.paymentNo}">
		
		  <label>환불 사유</label><br>
		  <textarea class="guestRefundFormReason" name="refundReason" required></textarea><br><br>
		
		  <label>이메일</label><br>
		  <input class="guestRefundFormMail" type="email" name="refundMail" required><br><br>
			<button class="guestRefundFormButton" type="submit">환불 신청하기</button>
		</div> 
		  
		</form>
		<div id="refundStatusBox" style="display: none;">
      환불 신청 상태 : <strong id="refundStatusText"></strong>
    </div>
    <button id="backGuestOrderInfo">주문화면 돌아가기</button>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();
  checkExistingRefund();
  
  $('#backGuestOrderInfo').click(function() {
	  submitPostRedirect();
  });  
  
  $("#guestRefundForm").submit(function(e){
    e.preventDefault(); 
    if (!confirm("정말로 환불을 신청하시겠습니까?")) { return; }
    const formData = new URLSearchParams(new FormData(this)).toString();
    fetch(this.action, {
      method: "POST",
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: formData 
    })
    .then(response => {
      if (!response.ok) throw new Error('Server responded with an error.');
      return response.text();
    })
    .then(result => {
      if(result === "success") {
        alert("✅ 환불 신청이 완료되었습니다. 비회원 주문조회 페이지로 이동합니다.");
        submitPostRedirect();
      } else {
        alert("❌ 환불 신청에 실패했습니다: " + result);
      }
    })
    .catch(err => {
      console.error("환불 신청 오류:", err);
      alert("처리 중 오류가 발생했습니다: " + err.message);
    });
  });
});

function submitPostRedirect() {
	const guestEmail = document.getElementById('guestEmailForRedirect').value;
	const orderPassword = document.getElementById('orderPasswordForRedirect').value;

	const form = document.createElement('form');
  form.method = 'POST';
  form.action = '<%=request.getContextPath()%>/guest/guestOrderInfo.do';
  const emailInput = document.createElement('input');
  emailInput.type = 'hidden';
  emailInput.name = 'guestEmail';
  emailInput.value = guestEmail;
  const passwordInput = document.createElement('input');
  passwordInput.type = 'hidden';
  passwordInput.name = 'orderPassword';
  passwordInput.value = orderPassword;
  form.appendChild(emailInput);
  form.appendChild(passwordInput);
  document.body.appendChild(form);
  form.submit();
}

function checkExistingRefund() {
  const orderId = "${order.orderId}";
  const paymentNo = "${not empty order.payment ? order.payment.paymentNo : order.paymentNo}";

  if (!orderId || !paymentNo || paymentNo === '0') return;
  
  fetch(`<%=request.getContextPath()%>/refund/status.do?orderId=\${orderId}&paymentNo=\${paymentNo}`)
    .then(res => res.text()) 
    .then(text => {
      if(text) {
        try {
          const refund = JSON.parse(text);
          if(refund && refund.refundStatus) {
            $("#guestRefundForm").hide();
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
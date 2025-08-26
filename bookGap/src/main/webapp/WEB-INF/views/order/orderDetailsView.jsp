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
    <div class="orderInfoBox">
      <p><strong>주문번호 : </strong> ${order.orderId}</p>
      <p><strong>주문일 : </strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
      <p><strong>결제번호 : </strong> ${order.paymentNo}</p>
      <p>
        <strong>현재 상태 : </strong>
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
    <h3>상품 내역</h3>
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
    <h3>환불 신청</h3>
		<form class="refundForm" id="refundForm"  method="POST" action="<%=request.getContextPath()%>/refund/apply.do" enctype="multipart/form-data">
			<div class="refundFormLine">
			  <input type="hidden" name="orderId" value="${order.orderId}">
			  <input type="hidden" name="paymentNo" value="${order.payment.paymentNo}">
			  
			  <label>메일 입력</label>
			  <br><input class="refundFormMail" type="email" name="refundMail" required><br>
			
			  <label>사진 첨부(선택)</label><br>
			  <input class="refundFormImage" type="file" name="refundImage"><br>
			  
			  <label>환불 사유</label>
			  <textarea class="refundFormReason" name="refundReason" required ></textarea>
			  
			</div>
		  <button class="refundFormButton" type="submit">환불 신청하기</button>
		</form>
		<div id="refundStatusBox">
        이미 환불을 신청한 주문입니다. 현재 상태: <strong id="refundStatusText"></strong>
    </div>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();
  checkExistingRefund(); // 페이지 로드 시, 기존 환불 신청 내역 확인

  // form의 submit 이벤트를 가로채서 AJAX로 처리
  $("#refundForm").submit(function(e) {
	  e.preventDefault(); // 기본 폼 제출(새로고침)을 막습니다.
	  
	  if (!confirm("환불을 신청하시겠습니까?")) {
      return;
    }

    const formData = new FormData(this);

    fetch(this.action, { // form의 action 속성을 URL로 사용
      method: this.method,
      body: formData
    })
    .then(response => {
      if (response.ok) return response.text(); // HTTP 200-299 상태 코드면 성공
      throw new Error('Server Error'); // 그 외에는 에러 발생
    })
    .then(result => {
      if (result === "success") {
          alert("환불 신청이 완료되었습니다. 주문 목록 페이지로 이동합니다.");
          // ✅ [수정] 성공 시, GET 방식의 주문 목록 페이지로 안전하게 이동
          location.href = "<%=request.getContextPath()%>/order/myOrder.do";
      } else {
          alert("환불 신청에 실패했습니다. 다시 시도해주세요.");
      }
    })
    .catch(err => {
      console.error("환불 신청 처리 중 오류:", err);
      alert("처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
	  });
  });
});

function checkExistingRefund() {
  const orderId = "${order.orderId}";
  const paymentNo = "${order.payment.paymentNo}";

  // orderId나 paymentNo가 없으면 함수를 실행하지 않음
  if (!orderId || !paymentNo) return;
  
  fetch(`<%=request.getContextPath()%>/refund/status.do?orderId=\${orderId}&paymentNo=\${paymentNo}`)
  .then(res => res.text()) // 결과가 비어있을 수 있으므로 먼저 text로 받음
  .then(text => {
    if(text) { // 응답 내용이 있을 때만 JSON으로 파싱
      const refund = JSON.parse(text);
      if(refund && refund.refundStatus) {
        // 환불 정보가 있으면, 신청 폼을 숨기고 상태 메시지를 표시
        $("#refundForm").hide();
        const statusText = getRefundStatusText(refund.refundStatus);
        $("#refundStatusText").text(statusText).addClass('status-refund-' + refund.refundStatus);
        $("#refundStatusBox").show();
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
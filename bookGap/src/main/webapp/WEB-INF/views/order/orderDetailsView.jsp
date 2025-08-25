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
      <p><strong>주문번호:</strong> ${order.orderId}</p>
      <p><strong>주문일:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
      <p><strong>결제번호:</strong> ${order.paymentNo}</p>
      <p>
        <strong>현재 상태:</strong>
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
          <th>저자/출판사</th>
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
		<form class="refundForm" id="refundForm" enctype="multipart/form-data">
		  <input type="hidden" name="orderId" value="${order.orderId}">
		  <input type="hidden" name="paymentNo" value="${order.paymentNo}">
		
		  <label>환불 사유</label>
		  <textarea name="refundReason" required style="width:100%; font-size: 15px; padding: 0.5%; min-height:80px; resize: none; border:1px solid black; border-radius:8px;"></textarea>
		
		  <label>사진 첨부</label>
		  <input type="file" name="refundImage"><br>
		
		  <button type="button" onclick="submitRefund()" style=" background-color: black;
    color: white;
    border: 1px solid black;
    border-radius: 8px;
    width: 15%;
    height: 45px;
    font-size: 18px;
    text-align: center;
    margin-left: 45%;">환불 신청하기</button>
		</form>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();
}
//장바구니 수량 업데이트
function updateCartCount() {
  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
  let cartCountElement = $("#cart-count"); // jQuery 셀렉터 사용
  if (cartCountElement.length) {
    cartCountElement.text(cartItems.length).css("visibility", cartItems.length > 0 ? "visible" : "hidden");
  }
}

function submitRefund() {
  const form = document.getElementById("refundForm");
  const formData = new FormData(form);

  fetch("<%=request.getContextPath()%>/refund/apply.do", {
    method: "POST",
    body: formData
  })
  .then(res => res.text())
  .then(result => {
    if (result === "success") {
      alert("환불 신청이 완료되었습니다.");
      // ✅ 신청 성공 후 → 주문 목록으로 이동
      location.href = "<%=request.getContextPath()%>/order/myOrder.do";
    } else {
      alert("환불 신청에 실패했습니다. 다시 시도해주세요.");
    }
  })
  .catch(err => {
    console.error("환불 신청 오류:", err);
    alert("서버 오류가 발생했습니다.");
  });
}
</script>
</body>
</html>
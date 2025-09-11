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
      <p><strong>주문자명 :</strong> ${order.guestName}</p>
      <p><strong>주문자 연락처 :</strong> ${order.guestPhone}</p>
      <p><strong>주문자 이메일 :</strong> ${order.guestEmail}</p>
      <p><strong>주문번호 :</strong> ${order.orderKey}</p>
      <p><strong>주문일 :</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
      <p><strong>결제수단 : </strong>
			  <c:choose>
				  <c:when test="${not empty order.payment && order.payment.paymentMethod == 1}">TossPay</c:when>
				  <c:when test="${not empty order.payment && order.payment.paymentMethod == 2}">KakaoPay</c:when>
				  <c:otherwise>결제수단 정보 없음</c:otherwise>
			  </c:choose>
      </p>
    </div>

    <!-- 주문 상품 목록 -->
		<div class="guestOrderDetailsTitle">배송 정보</div>
		<div class="deliveryInfoBox">
			<p><strong>수령인 : </strong> ${order.receiverName}</p>
			<p><strong>연락처 : </strong> ${order.receiverPhone}</p>
			<p><strong>주소 : </strong> ${order.receiverRoadAddress} ${order.receiverDetailAddress} (${order.receiverPostCode})</p>
			<c:if test="${not empty order.courier}"><p><strong>택배사 : </strong> ${order.courier}</p></c:if>
	    <c:if test="${not empty order.invoice}"><p><strong>송장번호 : </strong> ${order.invoice}</p></c:if>
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
			    <td><img src="<c:out value='${empty item.book.productInfo.image ? "/resources/img/no_image.png" : item.book.productInfo.image}'/>" alt="${item.book.productInfo.title}" style="width:80px;"/></td>
			    <td>${item.book.productInfo.title}</td>
			    <td>${item.book.productInfo.author} / ${item.book.productInfo.publisher}</td>
			    <td>${item.orderCount}개</td>
			    <td><fmt:formatNumber value="${item.orderPrice}" pattern="#,###"/>원</td>
			  </tr>
			</c:forEach>
      </tbody>
    </table>

    <!-- 환불 신청 폼 -->
    <div class="guestOrderDetailsTitle">
	    <c:choose>
	      <c:when test="${order.orderStatus == 1}"> 주문 취소 </c:when>
	      <c:otherwise> 환불 신청 </c:otherwise>
	    </c:choose>
    </div>
    
    <c:if test="${order.orderStatus != 4 && (order.refundStatus == null or order.refundStatus == 0)}">
	    <input type="hidden" id="guestEmailForRedirect" value="${guestEmail}">
	    <input type="hidden" id="orderPasswordForRedirect" value="${orderPassword}">
	    <form class="guestRefundForm" id="guestRefundForm" method="POST" action="<%=request.getContextPath()%>/refund/apply.do">
	    <div class="guestRefundFormLine">
			  <input type="hidden" name="orderId" value="${order.orderId}">
			  <input type="hidden" name="paymentNo" value="${not empty order.payment ? order.payment.paymentNo : order.paymentNo}">
			
			  <label>
			    <c:choose>
	          <c:when test="${order.orderStatus == 1}"> 취소 이유 </c:when>
	          <c:otherwise> 환불 사유 </c:otherwise>
		      </c:choose>
			  </label><br>
			  <textarea class="guestRefundFormReason" name="refundReason" required></textarea><br><br>
	
				<label>환불 및 취소 안내</label>
				  <div class="guestRefundInfoForm">
				  - 상품취소 시 취소수수료가 부과될 경우 환불될 금액에서 차감 후 나머지 금액을 환불 해 드립니다.<br>
				  - 단, 사용된 결제수단에 따라 예치금으로 환불 될 수 있습니다.<br>
				  - 카드이용 후 취소요청 시 카드사 정책에 따라 환불기간 소요될 수 있습니다.<br>
				  - 부분취소로 무료배송 기준 금액이 미만일 경우 배송비가 발생할 수 있으며 이 경우 배송비를 제한 후 환불 됩니다.<br>
				  - 반품/교환 시 단순변심에 의한 배송비 발생 시 해당 배송비를 제한 후 환불 됩니다.
				  </div>
	
					<button class="guestRefundFormButton" type="submit">
	          <c:choose>
	            <c:when test="${order.orderStatus == 1}"> 주문 취소하기 </c:when>
	            <c:otherwise> 환불 신청하기 </c:otherwise>
	          </c:choose>
	        </button>
	      </div>
	    </form>
	  </c:if>

		<div id="refundStatusBox">
      상태 : <strong id="refundStatusText"></strong>
    </div>
    <button id="backGuestOrderInfo">메인화면으로 돌아가기</button>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();
  
  const orderStatus = "${order.orderStatus}";
  const refundStatus = "${order.refundStatus}";
  
  //---------------------페이지 로딩 시 초기 상태 설정--------------------- //
  if(refundStatus && Number(refundStatus) > 0){
    showStatus(getRefundStatusText(Number(refundStatus), orderStatus));
    $("#guestRefundForm").hide();
  }else{
    $("#refundStatusBox").hide();
  }
  
  //---------------------주문 목록으로 돌아가기--------------------- //
  $('#backGuestOrderInfo').on('click', function () { window.location.href = "<%= request.getContextPath() %>"; });  
  
  //---------------------"주문취소"와 "환불신청" 로직을 하나로 통합--------------------- //
  $("#guestRefundForm").submit(function(e){
    e.preventDefault(); 
    
    const $form = $(this);
    const $button = $form.find('.guestRefundFormButton');
    const originalButtonText = $button.text();

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
    
    fetch(this.action, { method: this.method,
									       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
									       body: formData  })
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

// ---------------------공통 헬퍼(Helper) 함수들--------------------- //
function submitPostRedirect() {
	const guestEmail = document.getElementById('guestEmailForRedirect').value;
	const orderPassword = document.getElementById('orderPasswordForRedirect').value;
	const form = document.createElement('form');
  form.method = 'POST';
  form.action = `${contextPath}/guest/guestOrderInfo.do`;
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
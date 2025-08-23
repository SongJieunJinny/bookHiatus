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
            <div class="orderPayComplLine">주문상세>></div>
          	<!-- 주문에 포함된 상품 목록 -->
            <c:forEach var="detail" items="${order.orderDetails}">
						  
						  <div class="orderPayCompl">
						    <img class="orderThumb" 
								     src="<c:out value='${empty detail.book.image ? "/resources/img/no_image.png" : detail.book.image}'/>" 
								     alt="${detail.book.title}"/>
								<!-- 가운데: 도서 정보 -->
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
						    <!-- 오른쪽: 배송/환불 상태 -->
								<span class="orderShip" data-order-id="${order.orderId}"
								      onclick="openRefundModal('${order.orderId}', '${order.paymentNo}')">
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
      const d = $(this).data("order-date"); // yyyy-MM-dd
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
    const label = String(v).trim();        // 혹시 모를 공백 방지
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

  // 버튼 스타일 & 동작
  $(".orderWeekButton").on("mouseenter", function(){
    if (!$(this).hasClass("selected")) $(this).css({backgroundColor:"black", color:"white"});
  }).on("mouseleave", function(){
    if (!$(this).hasClass("selected")) $(this).css({backgroundColor:"white", color:"black"});
  });

  $(".orderWeekButton").on("click", function(){
	  $(".orderWeekButton").removeClass("selected").css({backgroundColor:"white", color:"black"});
	  $(this).addClass("selected").css({backgroundColor:"black", color:"white"});
	  updateDateRange($(this).val());
	  filterAndDisplayOrders();  // 버튼 누르면 즉시 필터
	});

	$(".orderDateButton").on("click", filterAndDisplayOrders);
});
</script>
<!-- 환불 신청 모달 -->
<div id="refundModal" class="refundModal">
  <div class="refundModalContent">
    <span class="close" onclick="closeRefundModal()">&times;</span>
    <h3>환불 신청</h3>
    <form id="refundForm">
      <input type="hidden" name="orderId" id="refundOrderId">
      <input type="hidden" name="paymentNo" id="refundPaymentNo">

      <label>환불 사유</label><br>
      <textarea name="refundReason" required style="min-height:80px;"></textarea><br><br>

      <label>사진 첨부</label><br>
      <input type="file" name="refundImage"><br><br>

      <label>이메일</label><br>
      <input type="email" name="refundMail" required><br><br>

      <button type="button" onclick="submitRefund()">신청하기</button>
    </form>

    <!-- 환불 상태 표시 -->
    <div id="refundStatusBox"></div>
  </div>
</div>
<script>
/* 환불 모달 열기 */
function openRefundModal(orderId, paymentNo) {
  document.getElementById("refundOrderId").value = orderId;
  document.getElementById("refundPaymentNo").value = paymentNo;
  document.getElementById("refundModal").style.display = "block";

  // 기존 환불 정보 조회
  fetch("<%=request.getContextPath()%>/refund/status.do?orderId=" + orderId + "&paymentNo=" + paymentNo)
    .then(res => res.json())
    .then(refund => {
      const form = document.getElementById("refundForm");
      const box = document.getElementById("refundStatusBox");

      if (refund) {
        // 이미 환불 신청된 경우 → 값 채우고 수정 불가 처리
        form.querySelector("textarea[name='refundReason']").value = refund.refundReason;
        form.querySelector("input[name='refundMail']").value = refund.refundMail;
        form.querySelector("textarea[name='refundReason']").readOnly = true;
        form.querySelector("input[name='refundMail']").readOnly = true;
        form.querySelector("button").style.display = "none";

        let statusText = "";
        switch (refund.refundStatus) {
          case 1: statusText = "환불요청"; break;
          case 2: statusText = "환불처리중"; break;
          case 3: statusText = "환불완료"; break;
          case 4: statusText = "환불거절"; break;
        }
        box.innerText = "현재 상태: " + statusText;
      } else {
        // 환불 신청 전 → 새 신청 가능
        form.reset();
        form.querySelector("textarea[name='refundReason']").readOnly = false;
        form.querySelector("input[name='refundMail']").readOnly = false;
        form.querySelector("button").style.display = "inline-block";
        box.innerText = "";
      }
    });
}

/* 환불 신청 */
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
      document.getElementById("refundModal").style.display = "none";

      // 화면 상태 갱신
      const orderId = form.querySelector("input[name='orderId']").value;
      const paymentNo = form.querySelector("input[name='paymentNo']").value;
      updateOrderShip(orderId, paymentNo);
    } else {
      alert("환불 신청에 실패했습니다.");
    }
  });
}

/* 환불 상태 갱신 */
function updateOrderShip(orderId, paymentNo) {
  fetch("<%=request.getContextPath()%>/refund/status.do?orderId=" + orderId + "&paymentNo=" + paymentNo)
    .then(res => res.json())
    .then(refund => {
      if (refund) {
        let statusText = "";
        switch (refund.refundStatus) {
          case 1: statusText = "환불요청"; break;
          case 2: statusText = "환불처리중"; break;
          case 3: statusText = "환불완료"; break;
          case 4: statusText = "환불거절"; break;
        }
        document.querySelectorAll(".orderShip[data-order-id='" + orderId + "']")
        .forEach(el => el.innerText = statusText);
      }
    });
}

/* 모달 닫기 */
function closeRefundModal() {
  document.getElementById("refundModal").style.display = "none";
}
</script>
</body>
</html>
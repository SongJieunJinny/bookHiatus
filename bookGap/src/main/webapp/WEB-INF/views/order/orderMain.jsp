<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderMain</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/order"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
    <section>
    <div id="orderMainHead">
      <div id="order">ORDER</div>
    </div>
    <div id="orderMain">
      <div id="orderMainNav">
        <div class="orderMainCategory">DELIVERY INFO</div>
        <div id="deliveryInfoDiv">
          <div class="deliveryContainer">
            <div class="orderMainDelivery">DELIVERY</div>
            <div class="deliveryAddress">
              <!-- 컨트롤러에서 받은 기본 배송지 정보를 동적으로 출력 -->
              <c:choose>
                <c:when test="${not empty defaultAddress}">
		              <div class="deliveryAddress1">
		                <div class="deliveryAddressName">
		                  <img id="addressImg" src="<%=request.getContextPath()%>/resources/img/icon/marker.png"> 
		                  <span class="deliveryInfoAddressNickname">${defaultAddress.addressName}</span>
		                </div>
		                <button id="deliveryAddressBtn">변경</button>  
		              </div>
		              <div class="deliveryAddress2">
		                ${defaultAddress.userName} / ${defaultAddress.userPhone}
		              </div>
		              <div class="deliveryAddress3">
		                [${defaultAddress.postCode}] ${defaultAddress.roadAddress} ${defaultAddress.detailAddress}
		              </div>
                </c:when>
                <c:otherwise>
                <%-- 기본 배송지가 없을 경우 --%>
                  <div class="deliveryAddress1">
                    <div class="deliveryAddressName">
                      <img id="addressImg" src="<%=request.getContextPath()%>/resources/img/icon/marker.png">
                      <span class="deliveryInfoAddressNickname">배송지를 등록해주세요.</span>
                    </div>
                    <button id="deliveryAddressBtn">배송지 관리</button>
                  </div>
                  <div class="deliveryAddress2"></div>
                  <div class="deliveryAddress3"></div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="requestContainer">
            <div class="orderMainRequest">REQUEST</div>
            <input class="orderMainRequestInput" type="text" placeholder="REQUEST">
          </div>
          <div class="deliveryInfoContainer">
            <div id="deliveryInfo">※ 제주 및 도서 산간 지역의 배송은 추가 배송비가 발생할 수 있습니다.</div>
          </div>
        </div>
      </div>
      <div id="orderMainSection">
        <div id="orderDetailSection">
          <div class="orderMainTableTitle">ORDER DETAILS</div>
          <div class="orderMainTableLayout">
            <div class="orderDetail">
							<!-- 컨트롤러에서 받은 단일 'book' 객체 정보를 직접 출력 -->
              <div class="orderDetailDiv">
                <input type="hidden" id="orderIsbn" value="${book.isbn}">
                <input type="hidden" id="orderQuantity" value="${quantity}">
                <img class="orderImg" src="${book.image}" alt="${book.title}">
                <div class="orderDetails">
                  <div class="orderDetailsTitle">${book.title}</div>
                  <div class="orderDetailsContainer">
                    <span class="orderCount">${quantity}개</span>
                    <span class="orderSlash">/</span>
                    <!-- 수량을 곱한 가격을 표시 -->
                    <span class="orderPrice"><fmt:formatNumber value="${book.discount * quantity}" pattern="#,###" />원</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="orderTotalPrice">총 합계: 0원</div>
          </div>
        </div>
      </div>
      <div id="orderMainAside">
        <div id="paymentMathodAside">
          <div class="orderMainTableTitle">PAYMENT METHOD</div>
          <div class="orderMainTableLayout">
            <div class="paymentMathodContainer">
              <div class="paymentMathodIcon">
                <div class="paymentMathodKakao"><img class="paymentMathodKakaoimg" src="<%=request.getContextPath()%>/resources/img/kakaopay.jpg"></div>
              </div>
              <div class="paymentMathodIcon">
                <div class="paymentMathodToss"><img class="paymentMathodTossimg" src="<%=request.getContextPath()%>/resources/img/tosspay.png"></div>
              </div>
            </div>
          </div>
        </div>
        <div id="paymentAside">
          <div class="orderMainTableTitle">PAYMENT</div>
          <div class="orderMainTableLayout">
            <div class="paymentLayout">
              <div class="paymentContainer">
                <div class="paymentPriceDelivery">
                  <div class="paymentPrice">상품금액</div><div class="Price"></div>
                </div>
                <div class="paymentPriceDelivery">
                  <div class="paymentPrice">배송비</div><div class="deliveryFee"></div>
                </div>
              </div>
              <div class="paymentContainer">
                <div class="paymentLine"></div>
              </div>
              <div class="paymentContainer">
                <div class="LastPaymentPrice">최종결제금액</div>
                <div class="finalPaymentPrice"></div>
              </div>
            </div>
          </div>
        </div>
        <div id="orderMainPayBtnContainer">
          <div class="orderMainPayBtnDiv">
            <button class="orderMainPayBtn">결제하기</button>
          </div>
        </div>
      </div>
    </div>
  </section>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  
  <div id="firstModal" class="modal">
    <div class="modalContent">
      <span class="close" id="closeFirstModal">&times;</span>
      <h2>ADDRESS</h2>
      <button id="addAddressBtn">+ 배송지 추가</button>
      <div id="addressList">
        <c:forEach var="addr" items="${addressList}">
	        <div class="addressItem">
	          <label>
	            <input type="radio" name="address" 
	                   ${addr.isDefault == 1 ? 'checked' : ''}
	                   data-address-id="${addr.userAddressId}"
	                   data-address-name="${addr.addressName}"
	                   data-user-name="${addr.userName}"
	                   data-phone="${addr.userPhone}"
	                   data-post-code="${addr.postCode}"
	                   data-road-address="${addr.roadAddress}"
	                   data-detail-address="${addr.detailAddress}">
	            <span>${addr.addressName}</span>
	            <c:if test="${addr.isDefault == 1}">
	              <span class="defaultTag">[기본배송지]</span>
	            </c:if>
	          </label>
	          <p>${addr.userName} / ${addr.userPhone}</p>
	          <p>[${addr.postCode}] ${addr.roadAddress} ${addr.detailAddress}</p>
	          <button class="deleteAddress" data-address-id="${addr.userAddressId}">삭제</button>
	        </div>
	      </c:forEach>
      </div>
    </div>
  </div>

  <div id="secondModal" class="modal">
    <div class="modalContent">
      <span class="close" id="closeSecondModal">&times;</span>
      <h2>ADD NEW ADDRESS</h2>
      <form id="addressForm">
        <input type="text" id="addressName" placeholder="배송지 이름 (예: 집, 회사)">
        <input type="text" id="recipient" placeholder="받는 사람">
        <input type="text" id="userPhone" placeholder="연락처 ('-' 없이 입력)">
        <div style="display: flex; gap: 10px;">
	        <input type="text" id="zipcode" placeholder="우편번호" readonly>
	        <button id="searchAddress" style="width: 30%; padding: 10px; margin: 8px 0;">주소 검색</button>
        </div>
        <input type="text" id="address" placeholder="주소" readonly>
        <input type="text" id="addressDetail" placeholder="상세 주소">
        <button id="saveAddress">저장</button>
      </form> 
    </div>
  </div>
  
<!-- 카카오 주소 검색 API 추가 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
$(document).ready(function () {
  // --- 초기화 ---
  updateCartCount();
  calculateTotal(); // 페이지 로딩 시 JSP가 렌더링한 가격으로 최초 계산
  
  // --- 이벤트 핸들러 ---
  
  // '변경' 버튼 -> 주소 목록 모달 열기
  $("#deliveryAddressBtn").on("click", () => $("#firstModal").css("display", "flex"));

  // '+ 배송지 추가' 버튼 -> 주소 입력 모달 열기
  $("#addAddressBtn").on("click", () => {
    $("#secondModal").css("display", "flex");
    $("#addressForm").show();
  });

  // '주소 검색' 버튼 -> 카카오 주소 API
  $("#searchAddress").on("click", function(e) {
    e.preventDefault();
    new daum.Postcode({
      oncomplete: function (data) {
        $("#zipcode").val(data.zonecode);
        $("#address").val(data.roadAddress);
        $("#addressDetail").focus();
      }
    }).open();
  });

  // '저장' 버튼 -> 새 주소 추가
  $("#saveAddress").on("click", function (event) {
    event.preventDefault();

		// 서버로 보낼 데이터를 객체로 만듭니다.
		let newAddressData = {
		  addressName: $("#addressName").val(),
		  recipient: $("#recipient").val(),
		  userPhone: $("#userPhone").val(), // [수정] id와 key를 userPhone으로 변경
		  postCode: $("#zipcode").val(),
		  roadAddress: $("#address").val(),
		  detailAddress: $("#addressDetail").val()
		  // userId는 서버 세션에서 처리하는 것이 안전합니다.
		};

		// TODO: 여기에 newAddressData 객체를 서버로 보내는 AJAX 로직을 구현합니다.
		console.log("서버로 전송할 새 주소 데이터:", newAddressData);
		alert("AJAX를 통해 주소 저장 로직 구현이 필요합니다.");
	});

  // 라디오 버튼 변경 시 배송지 정보 업데이트
  $(document).on("change", "input[name='address']", updateDeliveryInfo);

  // 주소 '삭제' 버튼 클릭
  $(document).on("click", ".deleteAddress", function () {
    const addressId = $(this).data("address-id");
    if (confirm("이 배송지를 정말 삭제하시겠습니까?")) {
        // TODO: 여기에 AJAX를 사용하여 서버에 주소 삭제를 요청하는 로직을 구현해야 합니다.
        // 성공 시, 화면에서 해당 .addressItem을 제거합니다.
        alert("AJAX를 통해 " + addressId + "번 주소 삭제 로직 구현이 필요합니다.");
    }
  });

  // '결제하기' 버튼 클릭
  $(".orderMainPayBtn").on("click", function () {
    let selectedAddress = $("input[name='address']:checked");

    if (selectedAddress.length === 0) {
      alert("배송지를 선택해주세요.");
      return;
    }

    // JSP에 심어둔 hidden input에서 주문 정보를 가져옵니다.
    let orderData = {
      userAddressId: selectedAddress.data("address-id"),
      orderPrice: parseInt($('.finalPaymentPrice').text().replace(/[^0-9]/g, '')),
      items: [
        {
          isbn: $("#orderIsbn").val(),
          quantity: $("#orderQuantity").val()
        }
      ]
    };

    // TODO: 이 orderData 객체를 서버로 보내 결제 프로세스를 시작하는 AJAX 호출
    console.log("결제 요청 데이터:", orderData);
    alert("결제가 진행됩니다.");
  });

  // --- 모달 관리 ---
  $(".close").on("click", function() { $(this).closest(".modal").hide(); });
  $(window).on("keydown", (e) => { if (e.key === "Escape") $(".modal").hide(); });
  $(window).on("click", (e) => { if ($(e.target).is(".modal")) $(e.target).hide(); });
});

	// --- 전역 함수 ---

	// 장바구니 수량 업데이트
	function updateCartCount() {
	  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	  let cartCountElement = $("#cart-count"); // jQuery 셀렉터 사용
	  if (cartCountElement.length) {
	    cartCountElement.text(cartItems.length).css("visibility", cartItems.length > 0 ? "visible" : "hidden");
	  }
	}

	// 총 금액 계산 및 표시 함수
	function calculateTotal() {
	  let totalPrice = 0;
	  $('.orderPrice').each(function () {
	    totalPrice += parseInt($(this).text().replace(/[^0-9]/g, ''), 10);
	  });

	  const deliveryFee = totalPrice >= 50000 ? 0 : 3000;
	  $('.orderTotalPrice').text(`총 합계: ${totalPrice.toLocaleString()}원`);
	  $('.Price').text(`${totalPrice.toLocaleString()}원`);
	  $('.deliveryFee').text(`${deliveryFee.toLocaleString()}원`);
	  $('.finalPaymentPrice').text(`${(totalPrice + deliveryFee).toLocaleString()}원`);
	}

	// 배송지 정보 업데이트 함수
	function updateDeliveryInfo() {
	  let selected = $("input[name='address']:checked");
	  if (selected.length > 0) {
	    const data = selected.data(); // data-* 속성을 객체로 가져옴
	    
	    // [수정] JSP에서 data-phone으로 지정했으므로, JS에서는 data.phone으로 접근해야 합니다.
	    const phone = data.phone; 
	    
	    $(".deliveryInfoAddressNickname").text(data.addressName);
	    $(".deliveryAddress2").text(`${data.userName} / ${phone}`); // 수정된 phone 변수 사용
	    $(".deliveryAddress3").text(`[${data.postCode}] ${data.roadAddress} ${data.detailAddress}`);
	  } else {
	    $(".deliveryInfoAddressNickname").text("배송지를 선택해주세요");
	    $(".deliveryAddress2").text("");
	    $(".deliveryAddress3").text("");
	  }
	}
</script>
</body>
</html>
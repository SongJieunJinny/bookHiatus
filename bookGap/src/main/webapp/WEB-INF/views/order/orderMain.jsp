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
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/order.css"/>
<script src="https://js.tosspayments.com/v1/payment-widget"></script>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="orderMainHead">
      <div id="order">ORDER</div>
    </div>

    <div id="orderMain">
      <div id="orderMainNav">
        <div class="orderMainTableTitle">DELIVERY INFO</div>
        <div id="deliveryInfoDiv">
          <div class="deliveryContainer">
            <div class="orderMainDelivery">DELIVERY</div>
            <div class="deliveryAddress">

							<c:choose>    <%-- 컨트롤러에서 받은 기본 배송지 정보를 동적으로 출력 --%>
							  <c:when test="${not empty userAddressId}">
							    <c:forEach var="addr" items="${addressList}">
							      <c:if test="${addr.userAddressId == userAddressId}">
							        <div class="deliveryAddress1">
							          <div class="deliveryAddressName">
							            <img id="addressImg" src="<%=request.getContextPath()%>/resources/img/icon/marker.png"> 
							            <span class="deliveryInfoAddressNickname">${addr.addressName}</span>
							          </div>
							          <button id="deliveryAddressBtn">변경</button>  
							        </div>
							        <div class="deliveryAddress2">
							          ${addr.userName} / ${addr.userPhone}
							        </div>
							        <div class="deliveryAddress3">
							          [${addr.postCode}] ${addr.roadAddress} ${addr.detailAddress}
							        </div>
							      </c:if>
							    </c:forEach>
							  </c:when>
							  <c:otherwise>    <%-- 기본 배송지가 없는 경우 --%>
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
			    <div class="orderDetailLayout">
			    
			      <c:choose>
			        <c:when test="${not empty orderItems}"><%-- orderItems 리스트가 비어있지 않은 경우 (장바구니 또는 단일 주문 성공) --%>
			          <c:forEach var="item" items="${orderItems}"><%-- forEach를 사용하여 리스트의 모든 상품을 반복 출력 --%>
			          <div class="orderDetail">
			            <div class="orderDetailDiv">
			              <input type="hidden" class="orderItemIsbn" value="${item.book.isbn}">
                    <input type="hidden" class="orderItemQuantity" value="${item.quantity}">
			              <img class="orderImg" src="${item.book.productInfo.image}" alt="${item.book.productInfo.title}">
			              <div class="orderDetails">
			                <div class="orderDetailsTitle">${item.book.productInfo.title}</div>
                      <div class="orderDetailsContainer">
			                  <span class="orderCount">${item.quantity}개</span>
			                  <span class="orderSlash">/</span>
			                  <span class="orderPrice">
			                    <fmt:formatNumber value="${item.book.productInfo.discount * item.quantity}" pattern="#,###" />원
			                  </span>
			                </div>
			              </div>
			            </div>
			          </div>
			          </c:forEach>
			        </c:when>
			        <c:otherwise>
			          <div style="padding: 20px; text-align: center; color: #666;">
			            선택된 상품이 없습니다.<br>
			            <a href="${pageContext.request.contextPath}/" style="color: #007bff;">메인으로 돌아가기</a>
			          </div>
			        </c:otherwise>
			      </c:choose>
			      
			      <div class="orderTotalPrice">총 합계: 0원</div>
			    </div>
			  </div>
			  <div id="paymentMethodAside">
          <div class="orderMainTableTitle">PAYMENT METHOD</div>
          <div class="paymentMethodLayout">
            <div class="paymentMethodContainer">
              <div class="paymentMethodIcon" data-pay="kakaopay">
                <div class="paymentMethodKakao"><img class="paymentMethodKakaoimg" src="<%=request.getContextPath()%>/resources/img/kakaopay.jpg"></div>
              </div>
              <div class="paymentMethodIcon" data-pay="tosspay">
                <div class="paymentMethodToss"><img class="paymentMethodTossimg" src="<%=request.getContextPath()%>/resources/img/tosspay.png"></div>
              </div>
            </div>
            <div id="paymentMethodSelected">결제 수단을 선택해주세요.</div>
          </div>
        </div>
			</div>
			
      <div id="orderMainAside">
        <div id="paymentAside">
          <div class="orderMainTableTitle">PAYMENT</div>
          <div class="paymentTableLayout">
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
        <div id="agreeTable">
          <div class="asideAgree">
            <div class="agree1Div">
              <input class="agreeRadio1" type="checkbox" id="agreeAll">
              <label for="agreeAll">전체동의</label>
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
            <div class="agree4Div">
              <input class="agreeRadio4" type="checkbox" id="agreeAge">
              <label for="agreeAge">만 14세이상입니다.</label>
              <button class="agreeToggleBtn" data-target="guideAgeText"></button>
              <div class="guideText" id="guideAgeText">
                <p>14세 미만의 어린이 회원은 비회원으로 주문이 불가합니다.</p>
                <p>회원 가입을 통해 법정대리인 동의를 진행 후, 주문해주세요.</p>
              </div>
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
            <div class="agree2Div">
              <input class="agreeRadio2" type="checkbox" id="agreeOrderInfo">
              <label for="agreeOrderInfo">주문상품 정보동의</label>
              <button class="agreeToggleBtn" data-target="guideOrderInfoText"></button>
              <div class="guideText" id="guideOrderInfoText">
                <p>주문할 상품의 상품명, 가격, 배송정보 등을 최종 확인하였으며, 구매에 동의하십니까?</p>
                <p>(전자상거래법 제 8조 2항)</p>
              </div>
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
          </div>
        </div>
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
			               value="${addr.userAddressId}"
			               <c:if test="${addr.userAddressId == userAddressId}">checked</c:if>
			               data-address-id="${addr.userAddressId}"
			               data-address-name="${addr.addressName}"
			               data-user-name="${addr.userName}"
			               data-user-phone="${addr.userPhone}"
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
        <div style="display: flex; gap: 10px; width: 90%; margin-left: 10px;">
	        <input type="text" id="zipcode" placeholder="우편번호" readonly>
	        <button id="searchAddress" style="width: 35%; padding: 10px; margin: 6px 0;">주소 검색</button>
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
let selectedPaymentMethod;

const currentUserId = "<c:out value='${currentUserId}' />";
const currentUserName = "<c:out value='${currentUserName}' />";

$(document).ready(function () {
  // --- 초기화 ---
  initHeaderEvents();
  updateCartCount();
  calculateTotal();
  initializeToggleButtons();
  
  // '변경' 버튼 -> 주소 목록 모달 열기
  $("#deliveryAddressBtn").on("click", () => $("#firstModal").css("display", "flex"));

  // '+ 배송지 추가' 버튼 -> 주소 입력 모달 열기
  $("#addAddressBtn").on("click", () => {
    $("#secondModal").css("display", "flex");
    $("#addressForm")[0].reset(); // 폼 초기화
    $("#addressForm").show();
  });

  //'주소 검색' 버튼 -> 카카오 주소 API
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
  
  //결제 수단 아이콘 클릭
  $(".paymentMethodIcon").on("click", function() {
    $(".paymentMethodIcon").removeClass("selected");
    $(this).addClass("selected");

    selectedPaymentMethod = $(this).data("pay");
    
    let paymentMethodText = selectedPaymentMethod === 'kakaopay' ? '카카오페이' : '토스페이';
    $("#paymentMethodSelected")
      .text(paymentMethodText + "로 결제합니다.")
      .css({'color':'blue', 'font-weight':'bold'});
  });
  
  // '결제하기' 버튼 클릭
  $(".orderMainPayBtn").on("click", function() {

    const selectedAddress = $("input[name='address']:checked");
    
    if(selectedAddress.length === 0){
      alert("배송지를 선택해주세요.");
      return;
    }
    
    if(!$(".agreeRadio2").is(":checked") || !$(".agreeRadio4").is(":checked")){
      alert("필수 동의 항목에 체크해 주세요.");
      return;
    }
    
    if(!selectedPaymentMethod){ 
      alert("결제 수단을 선택해주세요.");
      return;
    }

    const orderItems = [];
    $("#orderDetailSection .orderDetail").each(function(){
      orderItems.push({
        isbn: $(this).find(".orderItemIsbn").val(),
        quantity: parseInt($(this).find(".orderItemQuantity").val())
      });
    });

    if(orderItems.length === 0){
      alert("주문할 상품이 없습니다.");
      return;
    }
    
    let orderName = $(".orderDetailsTitle").first().text();
    const remainingItems = $(".orderDetail").length - 1;
    if (remainingItems > 0) {
        orderName += " 외 " + remainingItems + "건";
    }

    const orderData = { userId: currentUserId, 
								        userAddressId: selectedAddress.data("address-id"),
								        
								        orderPrice: parseInt($('.Price').text().replace(/[^0-9]/g, ''), 10),
								        deliveryRequest: $('.orderMainRequestInput').val(),
								        deliveryFee: parseInt($('.deliveryFee').text().replace(/[^0-9]/g, ''), 10),
								        totalPrice: parseInt($('.finalPaymentPrice').text().replace(/[^0-9]/g, ''), 10),
								        
								        paymentMethod: selectedPaymentMethod,
								        orderItems: orderItems, // 방금 위에서 만든 상품 배열을 여기에 담습니다.
								        orderName: orderName
    };

    $.ajax({
        type: "POST",
        url: contextPath + "/payment/prepare", // ★ 새로 만든 API 주소로 변경
        contentType: "application/json",
        data: JSON.stringify(orderData),
        success: function(response) {
            if (response.status === 'SUCCESS') {
                const tossPayments = TossPayments('test_ck_ZLKGPx4M3MG0eMKOzG94rBaWypv1');
                tossPayments.requestPayment('카드', {
                    amount: response.amount,
                    orderId: "BG_" + response.paymentNo + "_" + new Date().getTime(),
                    orderName: response.orderName,
                    customerName: response.customerName,
                    customerKey: response.customerKey,
                    successUrl: window.location.origin + contextPath + "/payment/success",
                    failUrl: window.location.origin + contextPath + "/payment/fail"
                }).catch(function (error) {
                    if (error.code !== 'USER_CANCEL') {
                      alert('결제에 실패하였습니다. 오류: ' + error.message);
                    }
                });
            } else {
                alert("결제 준비 중 오류 발생: " + response.message);
            }
        },
        error: function(xhr) {
            alert("서버 통신 오류가 발생했습니다.");
            console.error("Error:", xhr.responseText);
        }
    });
});

  //전체동의 로직 (주석 처리된 agree3Div 고려)
  $("#agreeAll").click(function () {
    const isChecked = $(this).prop("checked");
    $(".agreeRadio2, .agreeRadio4").prop("checked", isChecked);
  });
  $(".agreeRadio2, .agreeRadio4").click(function () {
    const allChecked = $(".agreeRadio2").prop("checked") && $(".agreeRadio4").prop("checked");
    $("#agreeAll").prop("checked", allChecked);
  });

  // '저장' 버튼 -> 새 주소 추가
  $("#saveAddress").on("click", function(event){
    event.preventDefault();
		const newAddressData = { addressName: $("#addressName").val(),
											       userName: $("#recipient").val(), // 서버 VO의 필드명과 일치
											       userPhone: $("#userPhone").val(),
											       postCode: $("#zipcode").val(),
											       roadAddress: $("#address").val(),
											       detailAddress: $("#addressDetail").val() };
		
		if(!newAddressData.addressName || !newAddressData.userName || !newAddressData.userPhone || !newAddressData.postCode){
	    alert("배송지 이름, 받는 사람, 연락처, 주소는 필수 항목입니다.");
	    return; // 함수 실행 중단
	  }

		$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/order/addAddress.do",
	    contentType: "application/json; charset=utf-8", // 보내는 데이터 타입
	    data: JSON.stringify(newAddressData), // 데이터를 JSON 문자열로 변환
	    success: function (response) {
					    	 if (response === "SUCCESS") {
					         alert("새 배송지가 추가되었습니다.");  // 성공 시, 페이지를 새로고침하여 목록을 갱신합니다.
					         location.reload(); 
					    	 }else{
					         alert("주소 추가에 실패했습니다.");
					         console.log("주소 추가에 실패했습니다. 오류: " + response);
					       }
							},
	    error: function (xhr) {
		           alert("서버 통신 오류가 발생했습니다.");
		         }
		});
	});

  // 주소 '삭제' 버튼 클릭
  $(document).on("click", ".deleteAddress", function(){
	  const addressId = $(this).data("address-id");
	  const addressItem = $(this).closest(".addressItem"); // 삭제할 DOM 요소
	
	  if (confirm("이 배송지를 정말 삭제하시겠습니까?")) {
	    $.ajax({ type: "POST",
					     url: "<%=request.getContextPath()%>/order/deleteAddress.do",
					     data: { userAddressId: addressId }, // 폼 데이터 형식으로 전송
					     success: function(response){
								          if(response === "SUCCESS"){
								            alert("배송지가 삭제되었습니다.");
								            addressItem.fadeOut(function() { $(this).remove(); }); // 부드럽게 제거
								          }else{
								            alert("삭제에 실패했습니다: " + response);
								          }
								        },
					     error: function(){
					              alert("서버 통신 중 오류가 발생했습니다.");
					            }
	    });
	  }
	});
  
  // 라디오 버튼 변경 시 배송지 정보 업데이트
  $(document).on("change", "input[name='address']", updateDeliveryInfo);

  // --- 모달 관리 ---
  $(".close").on("click", function() { $(this).closest(".modal").hide(); });
  $(window).on("keydown", (e) => { if (e.key === "Escape") $(".modal").hide(); });
  $(window).on("click", (e) => { if ($(e.target).is(".modal")) $(e.target).hide(); });
});

function proceedToRealPayment(orderData) {
  const paymentMethod = orderData.paymentMethod;
  let orderName = $(".orderDetailsTitle").first().text();
  const remainingItems = $(".orderDetail").length - 1;
  if (remainingItems > 0) {
    orderName += " 외 " + remainingItems + "건";
  }

  if (paymentMethod === 'kakaopay') {
    $.ajax({
        type: "POST",
        url: contextPath + "/payment/ready/kakaopay", // Controller에 만든 API 주소
        contentType: "application/json",
        data: JSON.stringify({
        	  partner_order_id: String(orderData.orderId),  // Controller와 VO에 맞게 파라미터 전달
            partner_user_id: orderData.userId,
            item_name: orderName,
            quantity: orderData.orderItems.reduce((acc, item) => acc + item.quantity, 0),
            total_amount: orderData.totalPrice
        }),
        success: function(response) {
            // 2. 성공 시, 응답으로 받은 URL로 리다이렉트하여 결제창 열기
            window.location.href = response.next_redirect_pc_url;
        },
        error: function() {
            alert("카카오페이 결제 준비에 실패했습니다.");
        }
    });

  } 
}

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
    totalPrice += parseInt($(this).text().replace(/[^0-9]/g, '')) || 0; 
  });
  const deliveryFee = totalPrice >= 50000 ? 0 : 3000;
  $('.orderTotalPrice').text('총 합계: ' + totalPrice.toLocaleString() + '원');
  $('.Price').text(totalPrice.toLocaleString() + '원');
  $('.deliveryFee').text(deliveryFee.toLocaleString() + '원');
  $('.finalPaymentPrice').text((totalPrice + deliveryFee).toLocaleString() + '원');
}

// 배송지 정보 업데이트 함수
function updateDeliveryInfo() {
  const selected = $("input[name='address']:checked");
  if(selected.length > 0){
    const data = selected.data();

    $(".deliveryInfoAddressNickname").text(data.addressName);
    $(".deliveryAddress2").text(data.userName + ' / ' + data.userPhone);
    $(".deliveryAddress3").text('[' + data.postCode + '] ' + data.roadAddress + ' ' + data.detailAddress);
  } else {
    $(".deliveryInfoAddressNickname").text("배송지를 선택해주세요");
    $(".deliveryAddress2").text("");
    $(".deliveryAddress3").text("");
  }
}

//약관 펼쳐보기/접기 버튼 초기화 함수
function initializeToggleButtons() {
  document.querySelectorAll(".agreeToggleBtn").forEach(function (btn) {
    const targetId = btn.getAttribute("data-target");
    if (!targetId) return;
    const target = document.getElementById(targetId);
    if (!target) return;

    setToggleButton(btn, false);
    btn.addEventListener("click", function (e) {
      e.preventDefault(); // button의 기본 동작 방지
      const isExpanded = target.classList.contains("expanded");
      target.classList.toggle("expanded");
      setToggleButton(btn, !isExpanded);
    });
  });
}

//토글 버튼 내용 설정 함수
function setToggleButton(button, isExpanded) {
  // 3. 함수 내의 잘못된 JSP 코드 삭제
  button.innerHTML = "";
  const label = document.createElement("span");
  label.textContent = isExpanded ? "접기" : "펼쳐보기";
  label.style.cssText = "display:inline-block; text-align:center;";
  button.appendChild(label);
  const iconImg = document.createElement("img");
  // 전역 변수 contextPath 사용
  iconImg.src = contextPath + "/resources/img/icon/" + (isExpanded ? "collapse" : "expand") + ".png";
  iconImg.style.cssText = "width:18px; height:10px; vertical-align:middle;";
  button.appendChild(iconImg);
}

</script>
</body>
</html>
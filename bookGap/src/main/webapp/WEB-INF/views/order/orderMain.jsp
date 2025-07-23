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
			    <div class="orderDetailLayout">
			      <c:choose>
			        <c:when test="${book != null}">
			          <div class="orderDetail">
			            <div class="orderDetailDiv">
			              <input type="hidden" id="orderIsbn" value="${book.isbn}">
			              <input type="hidden" id="orderQuantity" value="${quantity}">
			              <img class="orderImg" src="${book.image}" alt="${book.title}">
			              <div class="orderDetails">
			                <div class="orderDetailsTitle">${book.title}</div>
			                <div class="orderDetailsContainer">
			                  <span class="orderCount">${quantity}개</span>
			                  <span class="orderSlash">/</span>
			                  <span class="orderPrice">
			                    <fmt:formatNumber value="${book.discount * quantity}" pattern="#,###" />원
			                  </span>
			                </div>
			              </div>
			            </div>
			          </div>
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
              <div class="paymentMethodIcon">
                <div class="paymentMethodKakao"><img class="paymentMethodKakaoimg" src="<%=request.getContextPath()%>/resources/img/kakaopay.jpg"></div>
              </div>
              <div class="paymentMethodIcon">
                <div class="paymentMethodToss"><img class="paymentMethodTossimg" src="<%=request.getContextPath()%>/resources/img/tosspay.png"></div>
              </div>
            </div>
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
            <!--  <div class="agree3Div">
              <input class="agreeRadio3" type="checkbox" id="agreePrivacyInfo">
              <label for="agreePrivacy">비회원 개인정보 수집 및 이용동의</label>
              <button class="agreeToggleBtn" data-target="descriptionText"></button>
              <div class="guideText" id="guidePrivacyText">
                <p>
                  수집하는 개인정보의 항목<br>
                  ① “BOOK틈”은 비회원구매, 원활한 고객상담, 각종 서비스의 제공을 위해 비회원 주문 이용 시 아래와 같은 개인정보를 수집하고 있습니다.<br>
                  - 필수수집항목 : 주문자 정보 (이름, 연락처, SMS수신여부, 이메일, 주문 비밀번호), 배송지 정보 (배송방법, 배송주소, 수신자 이름, 휴대폰번호, 영수증)<br>
                  - 선택수집항목: 주문자연락처, 수신자명, 수신자연락처(수신자 다를시)<br>
                  - 수집목적 : 상품배송을 위한 배송지 확인<br>
                  - 보유 및 이용기간 : 배송완료시점(단, 관계법령에 따름)<br>
                  - 서비스 이용과정이나 사업처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.<br>
                  - IP Address, 쿠키, 방문 일시, OS종류, 브라우져 종류 서비스 이용 기록, 불량 이용 기록<br>
                  ③ 부가 서비스 및 맞춤식 서비스 이용 또는 이벤트 응모 과정에서 해당 서비스의 이용자에 한해서만 아래와 같은 정보들이 수집될 수 있습니다.<br>
                  - 개인정보 추가 수집에 대해 동의를 받는 경우<br>
                  ④ 유료 서비스 이용 과정에서 아래와 같은 정보들이 수집될 수 있습니다.<br>
                  - 신용카드 결제 시 : 카드사명, 카드번호 등<br>
                  - 휴대전화 결제 시 : 이동전화번호, 통신사, 결제승인번호, 이메일주소 등<br>
                  - 계좌이체 시 : 은행명, 계좌번호 등<br>
                  - 상품권 이용 시 : 상품권 번호<br>
                  - 환불시 : 환불계좌정보(은행명, 계좌번호, 예금주명)<br>
                  개인정보의 수집 및 이용목적<br>
                </p>
                <p>
                  “BOOK틈”은 수집한 개인정보를 다음의 목적을 위해 활용합니다. 이용자가 제공한 모든 정보는 하기 목적에 필요한 용도 이외로는 사용되지 않으며, 이용 목적이 변경될 시에는 사전동의를 구할 것입니다.<br>
                  ① 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br>
                  - 컨텐츠 제공, 특정 맞춤 서비스 제공, 물품배송 또는 청구서 등 발송, 금융거래 본인 인증 및 금융 서비스, 구매 및 요금 결제, 요금추심 등<br>
                  ② 비회원 관리<br>
                  - 비회원 구매 서비스 이용에 따른 본인 확인, 개인 식별, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달 <br>
                </p>
                <p>
                  개인정보 보유 및 이용기간<br>
                  이용자의 개인정보는 원칙적으로 회원탈퇴 시 지체없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.<br>
                  ① 회사 내부 방침에 의한 정보보유 사유<br>
                  - 보존 항목 : 아이디(ID), 회원번호<br>
                  - 보존 근거 : 서비스 이용의 혼선 방지<br>
                  - 보존 기간 : 영구<br>
                  ② 관계 법령에 의한 정보보유 사유<br>
                  ‘상법’, ‘전자상거래 등에서의 소비자보호에 관한 법률’ 등 관계 법령의 규정에 의하여 보존할 필요가 있는 경우 관계 법령에서 정한 일정한 기간 동안 개인정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존 기간은 아래와 같습니다.<br>
                  1. 계약 또는 청약철회 등에 관한 기록<br>
                  - 보존 근거 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
                  - 보존 기간 : 5년<br>
                  2. 대금결제 및 재화 등의 공급에 관한 기록<br>
                  - 보존 근거 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
                  - 보존 기간 : 5년<br>
                  3. 소비자의 불만 또는 분쟁처리에 관한 기록<br>
                  - 보존 근거 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
                  - 보존 기간 : 3년<br>
                  4. 웹사이트 방문기록<br>
                  - 보존 근거 : 통신비밀보호법<br>
                  - 보존 기간 : 3개월<br>
                  ※ 개인정보수집 이용에 거부하실 수 있으며, 거부 시 주문이 불가함을 안내드립니다.
                </p>
              </div>
            </div>-->
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
	                   ${addr.isDefault == 1 ? 'checked' : ''}
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
const contextPath = '<%= request.getContextPath() %>';

$(document).ready(function () {
  // --- 초기화 ---
  updateCartCount();
  calculateTotal(); // 페이지 로딩 시 JSP가 렌더링한 가격으로 최초 계산
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
  
  //'결제하기' 버튼 클릭
  $(".orderMainPayBtn").on("click", function(){
    let selectedAddress = $("input[name='address']:checked");

    // 동의 항목 체크 여부 검사
    if(!$(".agreeRadio2").is(":checked") || !$(".agreeRadio4").is(":checked")){ // agreeRadio3에 해당하는 #agreePrivacyInfo는 주석처리됨
      alert("필수 동의 항목에 체크해 주세요.");
      return;
    }
    
  	if(selectedAddress.length === 0){
      alert("배송지를 선택해주세요.");
      return;
    }
  	
    let orderData = { userAddressId: selectedAddress.data("address-id"),
								      orderPrice: parseInt($('.finalPaymentPrice').text().replace(/[^0-9]/g, '')),
								      deliveryFee: parseInt($('.deliveryFee').text().replace(/[^0-9]/g, '')),
								      items: [ { isbn: $("#orderIsbn").val(), quantity: $("#orderQuantity").val() } ] };

    console.log("결제 요청 데이터:", orderData);
    alert("이제 이 데이터를 가지고 실제 결제 API 연동을 진행하거나, 서버에 주문 정보를 저장합니다.");

    // 예시: 서버에 주문 정보 저장 AJAX
    $.ajax({
      type: "POST",
      url: "<%=request.getContextPath()%>/order/processOrder.do",
      contentType: "application/json",
      data: JSON.stringify(orderData),
      success: function(response){
				         if(response.status === 'SUCCESS'){
				           alert("주문이 성공적으로 완료되었습니다. 주문번호: " + response.orderId); // 결제 완료 페이지로 이동
				           window.location.href = "<%=request.getContextPath()%>/order/orderComplete.do?orderId=" + response.orderId;  
				         }else{
				           alert("주문 처리 중 오류가 발생했습니다: " + response.message);
				         }
               },
      error: function(){
			         alert("주문 요청에 실패했습니다. 네트워크를 확인해주세요.");
			       }
    });
	});
  
  //전체동의 로직 (주석 처리된 agree3Div 고려)
  $("#agreeAll").click(function () {
    const isChecked = $(this).prop("checked");
    $(".agreeRadio2, .agreeRadio4").prop("checked", isChecked); // agreeRadio3 제외
  });
  $(".agreeRadio2, .agreeRadio4").click(function () {
    const allChecked = $(".agreeRadio2").prop("checked") && $(".agreeRadio4").prop("checked");
    $("#agreeAll").prop("checked", allChecked);
  });

  // '저장' 버튼 -> 새 주소 추가
  $("#saveAddress").on("click", function(event){
    event.preventDefault();

		// 서버로 보낼 데이터를 객체로 만듭니다.
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
	    $.ajax({
	      type: "POST",
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

    /*
     * 이 부분을 주석 처리하여 '자동 숨김' 기능을 비활성화합니다.
    if(target.scrollHeight <= 160){
      btn.style.display = "none";
      return;
    }
    */
    
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
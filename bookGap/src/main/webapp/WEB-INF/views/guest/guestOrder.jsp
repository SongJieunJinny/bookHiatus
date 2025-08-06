<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>guestOrder</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/guest/guest.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div id="guestOrderHead">
    <div id="order">ORDER</div>
  </div>
  <form id="guestOrderForm">
	  <div id="guestOrderFormDiv">
	    <div id="guestOrderNav">
	      <div class="guestInfoTable">
	        <div class="tableCategory">GUEST INFO</div>
          <div id="guestInfoTableDiv">
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">NAME</div>
              <input class="guestInfoTableInput" type="text" id="ordererName" placeholder="NAME">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PHONE</div>
              <input class="guestInfoTableInput" type="text" id="ordererPhone" placeholder="PHONE">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PW</div>
              <input class="guestInfoTableInput" type="password" id="orderPassword" placeholder="PW">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PW CHECK</div>
              <input class="guestInfoTableInput" type="password" id="orderPasswordCheck" placeholder="PW CHECK">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">E MAIL</div>
              <input class="guestInfoTableInput" type="email" id="ordererEmail" placeholder="E MAIL">
            </div>
          </div>
        </div><br>
        <div id="deliveryInfoTable">
          <div class="tableCategory">DELIVERY INFO</div>
          <div class="guestInfoTableDiv">
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">NAME</div>
              <input class="guestInfoTableInput" type="text" id="receiverName" placeholder="NAME">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PHONE</div>
              <input class="guestInfoTableInput" type="text" id="receiverPhone" placeholder="PHONE">
            </div>
            <div class="guestInfoTableAddressContainer">
            	<div class="guestInfoTableAddressContainerDiv">
              	<div class="guestInfoCategory">POST NO</div>
              	<input class="guestInfoTablePostInput" type="text" id="receiverPostCode" placeholder="POST NO">
              </div>
              <input class="guestInfoTablePostButton" type="button" id="searchAddress" value="검색">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategoryAddress">ADDRESS</div>
              <div class="guestInfoCategoryAddressDiv">
              	<input class="guestInfoTableAddress1" type="text" id="receiverRoadAddress" placeholder="ADDRESS">
              	<input class="guestInfoTableAddress2" type="text" id="receiverDetailAddress" placeholder="ADDRESS">
              </div>
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">REQUEST</div>
              <input class="guestInfoTableInput" type="text" id="deliveryRequest" placeholder="REQUEST">
            </div>
            <div class="guestInfoTableContainer">
              <div id="deliveryInfo">※ 제주 및 도서 산간 지역의 배송은 추가 배송비가 발생할 수 있습니다.</div>
            </div>
            <br>
          </div>
        </div>
      </div>
	    <div id="guestOrderSection">
	      <div id="orderTable">
	        <div class="SectionTitle">ORDER DETAILS</div>
	        <div class="layout">
	          <div class="orderDetail">
	            <div class="orderDetailDiv">
	                <img class="orderImg" src="${book.image}" alt="${book.title}">
	                <div class="orderDetails">
	                    <div class="orderDetailsTitle">${book.title}</div>
	                    <div class="orderDetailsContainer">
	                        <span class="orderCount">${quantity}개</span>
	                        <span class="orderSlash">/</span>
	                        <span class="orderPrice"><fmt:formatNumber value="${book.discount * quantity}" pattern="#,###"/>원</span>
	                    </div>
	                </div>
	            </div>
            </div>
	          <div class="orderTotalPrice">총 합계: <fmt:formatNumber value="${book.discount * quantity}" pattern="#,###"/>원</div>
	        </div>
	      </div>
	      <div id="payMathodTable">
	        <div class="SectionTitle">PAYMENT METHOD</div>
	        <div class="layout">
	          <div class="payContainer">
	            <div class="payIcon">
	              <div class="kakao"><img class="kakaoimg" src="<%=request.getContextPath()%>/resources/img/kakaopay.jpg"></div>
	            </div>
	            <div class="payIcon">
	              <div class="toss"><img class="tossimg" src="<%=request.getContextPath()%>/resources/img/tosspay.png"></div>
	            </div>
	          </div>
	        </div>
	      </div>
	    </div>
	    <div id="guestOrderAside">
        <div id="paymentAside">
	        <div class="SectionTitle">PAYMENT</div>
	        <div class="layout">
	          <c:set var="totalBookPrice" value="${book.discount * quantity}" />
	          <c:set var="deliveryFee" value="${totalBookPrice >= 50000 ? 0 : 3000}" />
	          <c:set var="finalPrice" value="${totalBookPrice + deliveryFee}" />
	          <div class="asideDivLayout">
	            <div class="asideDiv">
	              <div class="asideTextPrice">
	                <div class="asideText1">상품금액</div><div class="Price"><fmt:formatNumber value="${totalBookPrice}" pattern="#,###"/>원</div>
	              </div>
	              <div class="asideTextPrice">
	                <div class="asideText1">배송비</div><div class="deliveryFee"><fmt:formatNumber value="${deliveryFee}" pattern="#,###"/>원</div>
	              </div>
	            </div>
              <div class="asideDiv">
                <div class="asideLine"></div>
              </div>
              <div class="asideDiv">
                <div class="asideText2">최종결제금액</div>
                <div class="finalPrice" data-price="${finalPrice}"><fmt:formatNumber value="${finalPrice}" pattern="#,###"/>원</div>
              </div>
	        	</div>
	      	</div>
	      </div>
	      <div id="agreeTable">
	        <div class="asideAgree">
	          <div class="agree1Div">
	            <input class="agreeRadio1" type="checkbox" id="agreeAll">
	            <label for="agreeAll">전체동의</label>
	          </div>
	          <div class="agree4Div">
	            <input class="agreeRadio4 req-agree" type="checkbox" id="agreeAge">
	            <div class="label-toggle-wrapper">
	            	<label for="agreeAge">만 14세이상입니다.</label>
	            	<button class="agreeToggleBtn" data-target="guideAgeText"></button>
	            </div>
	          </div>
	          <div class="guideText" id="guideAgeText">
	              <p>14세 미만의 어린이 회원은 비회원으로 주문이 불가합니다.</p>
	              <p>회원 가입을 통해 법정대리인 동의를 진행 후, 주문해주세요.</p>
	            </div>
	          <div class="agree2Div">
	            <input class="agreeRadio2 req-agree" type="checkbox" id="agreeItem">
	            <div class="label-toggle-wrapper">
	            	<label for="agreeItem">주문상품 정보동의</label>
	            	<button class="agreeToggleBtn" data-target="guideOrderInfoText"></button>
	            </div>
	          </div>
	          <div class="guideText" id="guideOrderInfoText">
	              <p>주문할 상품의 상품명, 가격, 배송정보 등을 최종 확인하였으며, 구매에 동의하십니까?</p>
	              <p>(전자상거래법 제 8조 2항)</p>
	            </div>
	          <div class="agree3Div">
	            <input class="agreeRadio3 req-agree" type="checkbox" id="agreePrivacy">
	            <div class="label-toggle-wrapper">
	            	<label for="agreePrivacy">비회원 개인정보 수집 및 이용동의</label>
	            	<button class="agreeToggleBtn" data-target="guidePrivacyText"></button>
	            </div>
	          </div>
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
	        </div>
	        <div class="payBtnDiv">
	          <button type="button"  class="payBtn">결제하기</button>
	        </div>
		    </div>
      </div>
	  </div>
  </form>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
const contextPath = '<%= request.getContextPath() %>';

$(document).ready(function() {
  initHeaderEvents();
  initializeToggleButtons();
  calculateTotal();

  // '주소 검색' 버튼 클릭 이벤트
  $('#searchAddress').on('click', function(){
    new daum.Postcode({
      oncomplete: function(data) {
        $('#receiverPostCode').val(data.zonecode);
        $('#receiverRoadAddress').val(data.roadAddress);
        $('#receiverDetailAddress').focus();
      }
    }).open();
  });
  
  // '주문자 정보와 동일' 체크박스 이벤트
  $('#sameAsOrderer').on('change', function(){
    if($(this).is(':checked')){
      $('#receiverName').val($('#ordererName').val());
      $('#receiverPhone').val($('#ordererPhone').val());
    }else{
      $('#receiverName').val('');
      $('#receiverPhone').val('');
    }
  });
  
  // 약관 동의 체크박스 이벤트
  $('#agreeAll').on('click', function() {
    const isChecked = $(this).prop('checked');
    $('.req-agree').prop('checked', isChecked); // req-agree 클래스를 가진 모든 항목을 제어
  });
  
  //개별 필수 동의 항목 클릭 시
  $('.req-agree').on('click', function() {
    const totalCount = $('.req-agree').length;
    const checkedCount = $('.req-agree:checked').length;
    $('#agreeAll').prop('checked', totalCount === checkedCount); // 모두 체크되면 '전체동의'도 체크
  });
  
  // '결제하기' 버튼 클릭 시 AJAX 전송
  $('.payBtn').on('click', function(){

    if (!$('#ordererName').val().trim()) { alert("주문자 이름을 입력해주세요."); $('#ordererName').focus(); return; }
    if (!$('#ordererPhone').val().trim()) { alert("주문자 연락처를 입력해주세요."); $('#ordererPhone').focus(); return; }
    if (!$('#orderPassword').val().trim()) { alert("주문조회용 비밀번호를 입력해주세요."); $('#orderPassword').focus(); return; }
    if ($('#orderPassword').val() !== $('#orderPasswordCheck').val()) { alert("비밀번호가 일치하지 않습니다."); $('#orderPasswordCheck').focus(); return; }
    if (!$('#ordererEmail').val().trim()) { alert("주문자 이메일을 입력해주세요."); $('#ordererEmail').focus(); return; }
    if (!$('#receiverName').val().trim()) { alert("받는 분 이름을 입력해주세요."); $('#receiverName').focus(); return; }
    if (!$('#receiverPhone').val().trim()) { alert("받는 분 연락처를 입력해주세요."); $('#receiverPhone').focus(); return; }
    if (!$('#receiverPostCode').val().trim()) { alert("배송지 주소를 검색해주세요."); $('#searchAddress').focus(); return; }
    
    // 동의 항목 체크 여부 검사 (개선된 버전)
    if ($('.req-agree').length !== $('.req-agree:checked').length) {
      alert("필수 동의 항목에 모두 체크해 주세요.");
      return;
    }

    const guestOrderData = { bookNo: parseInt('${book.bookNo}'),
									    	     isbn: "${book.isbn}",
									    	     quantity: parseInt('${quantity}'),
									    	     priceAtPurchase: parseInt('${book.discount}'),
									    	     totalPrice: parseInt($('.finalPrice').data('price')),
											        
									    	     ordererName: $('#ordererName').val(),
								    	       ordererPhone: $('#ordererPhone').val(),
								    	       orderPassword: $('#orderPassword').val(),
								    	       ordererEmail: $('#ordererEmail').val(),

								    	       receiverName: $('#receiverName').val(),
								    	       receiverPhone: $('#receiverPhone').val(),
								    	       receiverPostCode: $('#receiverPostCode').val(),
								    	       receiverRoadAddress: $('#receiverRoadAddress').val(),
								    	       receiverDetailAddress: $('#receiverDetailAddress').val(),
								    	       deliveryRequest: $('#deliveryRequest').val() };
    
    console.log("서버로 전송할 데이터:", guestOrderData);

    // --- 3. AJAX로 서버에 주문 요청 전송 ---
    $.ajax({ type: "POST",
			       url: contextPath + "/order/guest/processOrder.do",
			       contentType: "application/json",
			       data: JSON.stringify(guestOrderData),
			       success: function(response){
						            if(response.status === 'Success'){
						              alert(response.message);
						              window.location.href = contextPath + "/";
						            }else{
						              alert("주문 실패: " + response.message);
						            }
						        	},
			       error: function(xhr){
					            alert("죄송합니다. 서버와 통신하는 중 오류가 발생했습니다.");
					            console.error("AJAX Error:", xhr.responseText);
					        	}
    });
  });
});

//총 금액 계산 및 표시 함수
function calculateTotal() {
  let totalPrice = 0;
  $('.orderPrice').each(function() {
    totalPrice += parseInt($(this).text().replace(/[^0-9]/g, '')) || 0;
  });
  const deliveryFee = totalPrice >= 50000 ? 0 : 3000;
  const finalPrice = totalPrice + deliveryFee;
  
  $('.orderTotalPrice').text('총 합계: ' + totalPrice.toLocaleString() + '원');
  $('.Price').text(totalPrice.toLocaleString() + '원');
  $('.deliveryFee').text(deliveryFee.toLocaleString() + '원');
  $('.finalPrice').text(finalPrice.toLocaleString() + '원'); 
  $('.finalPrice').data('price', finalPrice);
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
  //함수 내의 잘못된 JSP 코드 삭제
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
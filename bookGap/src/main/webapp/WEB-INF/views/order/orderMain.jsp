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
    <div id="guestOrderHead">
      <duv id="order">ORDER</duv>
    </div>
    <div id="guestOrder">
      <div id="orderNav">
        <div class="orderTableCategory">DELIVERY INFO</div>
        <div id="deliveryInfoTable">
          <div class="guestInfoTableContainer">
            <div class="guestInfoCategory">DELIVERY</div>
            <div class="deliveryInfoAddress">
              <div class="deliveryInfoAddress1">
                <div class="deliveryInfoAddressName"><img id="addressImg" src="marker.png"> <span class="deliveryInfoAddressNickname">자취방</span></div>
                <button id="deliveryInfoAddressBtn">변경</button>  
              </div>
              <div class="deliveryInfoAddress2">
                유저이 / 010-0000-0002
              </div>
              <div class="deliveryInfoAddress3">
                [50248] 전북특별자치도 전주시 덕진구 3길 8 상상주택 505호
              </div>
            </div>
          </div>
          <div class="guestInfoTableContainer">
            <div class="guestInfoCategory">REQUEST</div>
            <input class="deliveryInfoTableInput" type="text" placeholder="REQUEST">
          </div>
          <div class="guestInfoTableContainer">
            <div id="deliveryInfo">※ 제주 및 도서 산간 지역의 배송은 추가 배송비가 발생할 수 있습니다.</div>
          </div>
        </div>
      </div>
      <div id="orderSection">
        <div id="orderTable">
          <div class="sectionTitle">ORDER DETAILS</div>
          <div class="layout">
            <div class="orderDetail"></div>
            <div class="orderTotalPrice">총 합계: 0원</div>
          </div>
        </div>
      </div>
      <div id="orderAside">
        <div id="payMathodTable">
          <div class="sectionTitle">PAYMENT METHOD</div>
          <div class="layout">
            <div class="payContainer">
              <div class="payIcon">
                <div class="kakao"><img class="kakaoimg" src="kakaopay.jpg"></div>
              </div>
              <div class="payIcon">
                <div class="toss"><img class="tossimg" src="tosspay.png"></div>
              </div>
            </div>
          </div>
        </div>
        <div id="paymentTable">
          <div class="sectionTitle">PAYMENT</div>
          <div class="layout">
            <div class="asideDivLayout">
              <div class="asideDiv">
                <div class="asideTextPrice">
                  <div class="asideText1">상품금액</div><div class="Price"></div>
                </div>
                <div class="asideTextPrice">
                  <div class="asideText1">배송비</div><div class="deliveryFee">3,000</div>
                </div>
              </div>
              <div class="asideDiv">
                <div class="asideLine"></div>
              </div>
              <div class="asideDiv">
                <div class="asideText2">최종결제금액</div>
                <div class="finalPrice"></div>
              </div>
            </div>
          </div>
        </div>
        <div id="agreeTable">
          <div class="orderPayBtnDiv">
            <button class="payBtn">결제하기</button>
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
        <!-- 기본 배송지 -->
        <div class="addressItem">
          <label>
            <input type="radio" name="address" checked>
            <span>자취방 <span class="defaultTag">[기본배송지]</span></span>
          </label>
          <p>유저이 / 010-0000-0002</p>
          <p>[50248] 전북특별자치도 전주시 덕진구 3길 8 상상주택 805호</p>
          <button class="deleteAddress">삭제</button>
        </div>
        <!-- 추가 배송지 -->
        <div class="addressItem">
          <label>
            <input type="radio" name="address">
            <span>학교</span>
          </label>
          <p>유저이 / 010-0000-0002</p>
          <p>[50248] 전북특별자치도 전주시 백제대로585 이전학교 503호</p>
          <button class="deleteAddress">삭제</button>
        </div>
      </div>
    </div>
  </div>

  <div id="secondModal" class="modal">
    <div class="modalContent">
      <span class="close" id="closeSecondModal">&times;</span>
      <!-- 배송지 입력 폼 -->
      <form>
        <div id="addressForm" style="display: none;">
          <input type="text" id="addressName" placeholder="배송지 이름">
          <input type="text" id="recipient" placeholder="받는 사람">
          <input type="text" id="phone" placeholder="연락처">
          <input type="text" id="zipcode" placeholder="우편번호">
          <input type="text" id="address" placeholder="주소">
          <input type="text" id="addressDetail" placeholder="상세 주소">
          <button id="searchAddress">주소 검색</button>
          <button id="saveAddress">저장</button>
        </div>
      </form>  
    </div>
  </div>
<script>
   $(document).ready(function () {
		updateCartCount(); // 장바구니 개수 업데이트
		initHeaderEvents();		
	});
	// 장바구니 개수 업데이트 함수
	function updateCartCount() {
		let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
		let cartCount = cartItems.length;
		let cartCountElement = document.getElementById("cart-count");

		if (cartCountElement) {
				cartCountElement.textContent = cartCount;
				cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
		}
	}
</script>
</body>
</html>
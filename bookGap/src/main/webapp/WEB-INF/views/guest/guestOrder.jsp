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
      <div id="Order">ORDER</div>
    </div>
    <div id="guestOrder">
      <div id="guestOrderNav">
        <div class="guestInfoTable">
          <div class="TableCategory">GUEST INFO</div>
          <div id="guestInfoTableDiv">
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">NAME</div>
              <input type="hidden" name="guestId">
              <input class="guestInfoTableInput" type="text" name="guestName" placeholder="NAME">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PHONE</div>
              <input class="guestInfoTableInput" type="text" name="guestPhone" placeholder="PHONE">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PW</div>
              <input class="guestInfoTableInput" type="text" placeholder="PW">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PW CHECK</div>
              <input class="guestInfoTableInput" type="text" placeholder="PW CHECK">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">E MAIL</div>
              <input class="guestInfoTableInput" type="text" name="guestEmail" placeholder="E MAIL">
            </div>
          </div>
        </div><br><br>
        <div id="deliveryInfoTable">
          <div class="TableCategory">DELIVERY INFO</div>
          <div class="guestInfoTableDiv">
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">NAME</div>
              <input class="guestInfoTableInput" type="text" placeholder="NAME">
              <input type="hidden" name="guestId">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">PHONE</div>
              <input class="guestInfoTableInput" type="text" placeholder="PHONE">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">POST NO</div>
              <input class="guestInfoTablePostInput" type="text" name="guestPostCode" placeholder="POST NO">
              <input class="guestInfoTablePostButton" type="button" value="검색">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">ADDRESS</div>
              <input class="guestInfoTableAddress1" type="text" name="guestRoadAddress" placeholder="ADDRESS">
            </div>
            <div class="guestInfoTableContainer">
              <input class="guestInfoTableAddress2" type="text" name="guestDetailAddress" placeholder="ADDRESS">
            </div>
            <div class="guestInfoTableContainer">
              <div class="guestInfoCategory">REQUEST</div>
              <input class="guestInfoTableInput" type="text" placeholder="REQUEST">
            </div>
            <div class="guestInfoTableContainer">
              <div id="deliveryInfo">※ 제주 및 도서 산간 지역의 배송은 추가 배송비가 발생할 수 있습니다.</div>
            </div>
          </div>
        </div>
      </div>
      <div id="guestOrderSection">
        <div id="orderTable">
          <div class="SectionTitle">ORDER DETAILS</div>
          <div class="layout">
            <div class="orderDetail"></div>
            <div class="orderTotalPrice">총 합계: 0원</div>
          </div>
        </div>
      </div>
      <div id="guestOrderAside">
        <div id="payMathodTable">
          <div class="SectionTitle">PAYMENT METHOD</div>
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
          <div class="SectionTitle">PAYMENT</div>
          <div class="layout">
            <div class="asideDivLayout">
              <div class="asideDiv">
                <div class="asideTextPrice">
                  <div class="asideText1">상품금액</div><div class="Price"></div>
                </div>
                <div class="asideTextPrice">
                  <div class="asideText1">배송비</div><div class="deliveryFee">3,000</div>
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
        </div>
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
              <input class="agreeRadio4" type="checkbox" id="agreeItem">
              <label for="agreeAge">만 14세이상입니다.</label>
              <img class="agreeIcon1" src="펼쳐보기.png">
              <div class="guideText">
                <p>14세 미만의 어린이 회원은 비회원으로 주문이 불가합니다.</p>
                <p>회원 가입을 통해 법정대리인 동의를 진행 후, 주문해주세요.</p>
              </div>
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
            <div class="agree2Div">
              <input class="agreeRadio2" type="checkbox" id="agreeItem">
              <label for="agreeItem">주문상품 정보동의</label>
              <img class="agreeIcon1" src="펼쳐보기.png">
              <div class="guideText">
                <p>주문할 상품의 상품명, 가격, 배송정보 등을 최종 확인하였으며, 구매에 동의하십니까?</p>
                <p>(전자상거래법 제 8조 2항)</p>
              </div>
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
            <div class="agree3Div">
              <input class="agreeRadio3" type="checkbox" id="agreePrivacy">
              <label for="agreePrivacy">비회원 개인정보 수집 및 이용동의</label>
              <img class="agreeIcon2" src="펼쳐보기.png">
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
              <br>
              <div class="agreeLine"></div>
              <br>
            </div>
          </div>
          <div class="payBtnDiv">
            <button class="payBtn">결제하기</button>
          </div>
        </div>
      </div>
    </div>
  </section>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(document).ready(function() {

  updateCartCount(); // 장바구니 개수 업데이트
  initHeaderEvents();
    	
  // 카카오 주소 검색 API
  $(".guestInfoTablePostButton").click(function () {
    new daum.Postcode({
      oncomplete: function (data) {
      // 선택한 주소 정보를 입력 필드에 넣기
        $(".guestInfoTablePostInput").val(data.zonecode); // 우편번호
        $(".guestInfoTableAddress1").val(data.address); // 기본 주소
        $(".guestInfoTableAddress2").focus(); // 상세주소 입력란에 포커스 이동
      }
    }).open();
  });
});
    
function updateCartCount() {
	let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	let cartCount = cartItems.length;
	let cartCountElement = document.getElementById("cart-count");

	if (cartCountElement) {
			cartCountElement.textContent = cartCount;
			cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	}
}
    
    
// 모든 orderCount와 orderPrice 요소를 선택합니다
const orderCountElements = document.querySelectorAll('.orderCount');
const orderPriceElements = document.querySelectorAll('.orderPrice');

// 수량 및 가격 단위 추가
orderCountElements.forEach(countElement => {
  if (!countElement.textContent.includes('개')) {
    countElement.textContent += '개';
  }
});

orderPriceElements.forEach(priceElement => {
  if (!priceElement.textContent.includes('원')) {
    priceElement.textContent += '원';
  }
});

// 책 데이터 배열
const bookData = [
  { title: '인생의 의미', count: 1, price: 18000, imgSrc: '인생의의미.jpg' },
  { title: '소년이 온다', count: 1, price: 15000, imgSrc: '소년이온다.jpg' },
];

// 책 추가 함수
function addBook(book) {
  const bookHtml = `
    <div class="orderDetailDiv">
      <img class="orderImg" src="${book.imgSrc}" alt="${book.title}">
      <div class="orderDetails">
        <div class="orderDetailsTitle">${book.title}</div>
        <div class="orderDetailsContainer">
          <span class="orderCount">${book.count}개</span>
          <span class="orderSlash">/</span>
          <span class="orderPrice">${book.price.toLocaleString()}원</span>
        </div>
      </div>
    </div>
  `;
  $('.orderDetail').append(bookHtml);
}

// 총 금액 계산 및 표시 함수
function calculateTotal() {
  let totalPrice = 0;

  $('.orderPrice').each(function () {
    const priceValue = parseInt($(this).text().replace(/[^0-9]/g, ''), 10);
    totalPrice += priceValue;
  });

  $('.orderTotalPrice').text(`총 합계: ${totalPrice.toLocaleString()}원`);

  const deliveryFee = totalPrice >= 50000 ? 0 : 3000; // 배송비 계산
  $('.Price').text(`${totalPrice.toLocaleString()}원`);
  $('.deliveryFee').text(`${deliveryFee.toLocaleString()}원`);
  $('.finalPrice').text(`${(totalPrice + deliveryFee).toLocaleString()}원`);
}

// 초기화 및 책 추가 실행
$(document).ready(function () {
  bookData.forEach(addBook);
  calculateTotal();
});
    
//agree동의체크표시
$(document).ready(function () {
  // 전체동의 클릭 시 모든 체크박스 선택/해제 및 텍스트 색상 변경
  $(".agreeRadio1").click(function () {
    let isChecked = $(this).prop("checked"); // 현재 상태 확인

    // 모든 동의 체크 상태 변경
    $(".agreeRadio2, .agreeRadio3, .agreeRadio4").prop("checked", isChecked);

    // 선택 여부에 따라 텍스트 색상 변경
    $(".agree1Div, .agree2Div, .agree3Div, .agree4Div").css("color", isChecked ? "black" : "");
  });

  // 개별 체크박스 클릭 시 전체동의 상태 조정 및 텍스트 색상 변경
  $(".agreeRadio2, .agreeRadio3, .agreeRadio4").click(function () {
    let allChecked = $(".agreeRadio2").prop("checked") && $(".agreeRadio3").prop("checked");
    $(".agreeRadio1").prop("checked", allChecked);

    // 개별 선택된 경우 해당 항목 텍스트 색상 변경
    $(this).closest("div").css("color", $(this).prop("checked") ? "black" : "");
  });
});

//결제완료 버튼 누를때 alert창
$(document).ready(function () {
  $(".payBtn").click(function () {
    let isAgreeItemChecked = $(".agreeRadio2").prop("checked");
    let isAgreePrivacyChecked = $(".agreeRadio3").prop("checked");
    let isAgreeAllChecked = $(".agreeRadio1").prop("checked");
    let isAgreeAgeChecked = $(".agreeRadio4").prop("checked");

    if (!isAgreeItemChecked || !isAgreePrivacyChecked || !isAgreeAllChecked || !isAgreeAgeChecked) {
      alert("필수 동의 항목에 체크해 주세요.");
      return;
    }

    let isEmpty = false;
    $(".guestInfoTableInput, .guestInfoTablePostInput, .guestInfoTableAddress1, .guestInfoTableAddress2").each(function () {
      if ($(this).val().trim() === "") {
          isEmpty = true;
      }
    });

    if (isEmpty) {
      alert("주문정보 입력란에 입력해주세요.");
      return;
    }
    alert("결제가 진행됩니다."); // 실제 결제 프로세스를 여기에 추가
  });
});
</script>
<script>
$(document).ready(function () {
  $(".agreeIcon1").click(function () {
    // 안내 글 토글
    $(this).siblings(".guideText").slideToggle(200); // 200ms 동안 슬라이드 업/다운
  });
  // agreeIcon2 클릭 시 안내 글 토글
  $(".agreeIcon2").click(function () {
    $(this).siblings(".guideText").slideToggle(200); // 안내 글 업/다운
  });
});
</script>
</body>
</html>
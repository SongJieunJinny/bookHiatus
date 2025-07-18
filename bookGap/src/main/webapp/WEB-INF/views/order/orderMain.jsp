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
      <duv id="order">ORDER</duv>
    </div>
    <div id="orderMain">
      <div id="orderMainNav">
        <div class="orderMainCategory">DELIVERY INFO</div>
        <div id="deliveryInfoDiv">
          <div class="deliveryContainer">
            <div class="orderMaindelivery">DELIVERY</div>
            <div class="deliveryAddress">
              <div class="deliveryAddress1">
                <div class="deliveryAddressName"><img id="addressImg" src="marker.png"> <span class="deliveryInfoAddressNickname">자취방</span></div>
                <button id="deliveryAddressBtn">변경</button>  
              </div>
              <div class="deliveryAddress2">
                유저이 / 010-0000-0002
              </div>
              <div class="deliveryAddress3">
                [50248] 전북특별자치도 전주시 덕진구 3길 8 상상주택 505호
              </div>
            </div>
          </div>
          <div class="requestContainer">
            <div class="orderMainrequest">REQUEST</div>
            <input class="orderMainrequestInput" type="text" placeholder="REQUEST">
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
            <div class="orderDetail"></div>
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
                <div class="paymentMathodKakao"><img class="paymentMathodKakaoimg" src="kakaopay.jpg"></div>
              </div>
              <div class="paymentMathodIcon">
                <div class="paymentMathodToss"><img class="paymentMathodTossimg" src="tosspay.png"></div>
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
                  <div class="paymentPrice">배송비</div><div class="deliveryFee">3,000</div>
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
<!-- 카카오 주소 검색 API 추가 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 모달 관련  -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const firstModal = document.getElementById("firstModal");
    const deliveryInfoAddressBtn = document.getElementById("deliveryInfoAddressBtn");
    const closeFirstModalBtn = document.getElementById("closeFirstModal");

    const secondModal = document.getElementById("secondModal");
    const addAddressBtn = document.getElementById("addAddressBtn");
    const closeSecondModalBtn = document.getElementById("closeSecondModal");
    const saveAddress = document.getElementById("saveAddress");

    // 페이지 로드 시 모달을 숨김
    firstModal.style.display = "none";
    secondModal.style.display = "none";

    // 첫 번째 모달 열기 버튼 클릭 시
    deliveryInfoAddressBtn.addEventListener("click", function () {
      firstModal.style.display = "flex";  // display: flex 적용하여 가운데 정렬
    });

    // 첫 번째 모달 닫기 버튼 클릭 시
    closeFirstModalBtn.addEventListener("click", function () {
      firstModal.style.display = "none";
    });

    // 두 번째 모달 열기 버튼 클릭 시
    addAddressBtn.addEventListener("click", function () {
      secondModal.style.display = "flex";
    });

    // 두 번째 모달 닫기 버튼 클릭 시
    saveAddress.addEventListener("click", function () {
      secondModal.style.display = "none";
    });

    // 두 번째 모달 닫기 버튼 클릭 시
    closeSecondModalBtn.addEventListener("click", function () {
      secondModal.style.display = "none";
    });

    // ESC 키를 누르면 모달 닫기
    window.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
          firstModal.style.display = "none";
          secondModal.style.display = "none";
      }
    });

    // 모달 바깥을 클릭하면 닫힘
    window.addEventListener("click", function (event) {
      if (event.target === firstModal) {
          firstModal.style.display = "none";
      }
      if (event.target === secondModal) {
          secondModal.style.display = "none";
      }
    });
  });
  
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
    $(".agreeRadio2, .agreeRadio3").prop("checked", isChecked);

    // 선택 여부에 따라 텍스트 색상 변경
    $(".agree1Div, .agree2Div, .agree3Div").css("color", isChecked ? "black" : "");
  });

  // 개별 체크박스 클릭 시 전체동의 상태 조정 및 텍스트 색상 변경
  $(".agreeRadio2, .agreeRadio3").click(function () {
    let allChecked = $(".agreeRadio2").prop("checked") && $(".agreeRadio3").prop("checked");
    $(".agreeRadio1").prop("checked", allChecked);

    // 개별 선택된 경우 해당 항목 텍스트 색상 변경
    $(this).closest("div").css("color", $(this).prop("checked") ? "black" : "");
  });
});

//결제완료 버튼 누를때 alert창
$(document).ready(function () {
  $(".payBtn").click(function () {
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

// 삭제 기능
document.addEventListener("click", function(event) {
  if (event.target.classList.contains("deleteAddress")) {
    event.target.closest(".addressItem").remove();
  }
});

$(document).ready(function () {
  $("#addressModal").hide();

  // 배송지 추가 버튼 클릭 시 입력 폼 표시
  $("#addAddressBtn").click(() => $("#addressForm").show());

  // 카카오 주소 검색 API 연동
  $("#searchAddress").click(function (event) {
    event.preventDefault();
    new daum.Postcode({
      oncomplete: function (data) {
        $("#zipcode").val(data.zonecode);
        $("#address").val(data.roadAddress);
        $("#addressDetail").focus();
        $("#addressForm").show();
      }
    }).open();
  });

  $(document).ready(function () {
  // 배송지 업데이트 함수
    function updateDeliveryInfo() {
      let selectedAddress = $("input[name='address']:checked").closest(".addressItem");

      if (selectedAddress.length > 0) {
        let addressNickname = selectedAddress.find("span").first().text().trim();
        let recipientInfo = selectedAddress.find("p").eq(0).text().trim();
        let fullAddress = selectedAddress.find("p").eq(1).text().trim();

        // 각 부분을 업데이트
        $(".deliveryInfoAddressNickname").text(addressNickname);
        $(".deliveryInfoAddress2").text(recipientInfo);
        $(".deliveryInfoAddress3").text(fullAddress);
      } else {
        $(".deliveryInfoAddressNickname").text("배송지를 선택해주세요");
        $(".deliveryInfoAddress2").text("");
        $(".deliveryInfoAddress3").text("");
      }
    }

    // 라디오 버튼이 변경될 때마다 배송지 업데이트
    $(document).on("change", "input[name='address']", function () {
      updateDeliveryInfo();
    });

    // 새로운 배송지 추가 시 배송지 목록에 반영
    $(document).on("click", "#saveAddress", function (event) {
      event.preventDefault();

      let name = $("#addressName").val();
      let recipient = $("#recipient").val();
      let phone = $("#phone").val();
      let zipcode = $("#zipcode").val();
      let address = $("#address").val();
      let detail = $("#addressDetail").val();

      if (!name || !recipient || !phone || !zipcode || !address || !detail) {
        alert("모든 정보를 입력해주세요.");
        return;
      } 

      let newAddress = `
        <div class="addressItem">
            <label>
                <input type="radio" name="address">
                <span>${name}</span>
            </label>
            <p>${recipient} / ${phone}</p>
            <p>[${zipcode}] ${address} ${detail}</p>
            <button class="deleteAddress">삭제</button>
        </div>
      `;

      $("#addressList").append(newAddress);
      $("#addressForm").hide();
      $("#addressName, #recipient, #phone, #zipcode, #address, #addressDetail").val("");

      // 새로 추가한 배송지를 선택한 상태로 만들기
      $("#addressList .addressItem:last-child input[type='radio']").prop("checked", true);
      updateDeliveryInfo();
    });

    // 삭제 기능 (이벤트 위임 방식)
    $(document).on("click", ".deleteAddress", function () {
      let parentItem = $(this).closest(".addressItem");
      let wasChecked = parentItem.find("input[name='address']").prop("checked");

      parentItem.remove();

      // 삭제된 주소가 선택된 주소라면 기본 배송지로 변경
      if (wasChecked) {
        $("input[name='address']").first().prop("checked", true);
        updateDeliveryInfo();
      }
    });

    // 페이지 로드 시 기본 배송지 설정
    updateDeliveryInfo();
  });
});
</script>
</body>
</html>
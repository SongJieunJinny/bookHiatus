<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>cart</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/cart.css?v=2"/>
</head>
<body>
<div id="wrap">
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<section>
			<div class="cartInfoInnerList">
				<div class="cartInfoInner">
					<h3 id="cartCountTitle">장바구니 ()</h3>
					<div class="cartInfoButton"><button type="button" id="cartInfoBtn"><img src="<%= request.getContextPath() %>/resources/img/icon/address.png"> 기본배송지</button></div>
				</div>
				<div><p class="emptyCartMessage">장바구니가 비어 있습니다.</p></div>
				<div class="cartContainer">
					<div class="cartInfoCheck">
						<label><input type="checkbox" name="cartItems" value="selectall" onclick='selectAll(this)'> <b>전체 선택</b></label>
					</div>
					<div class="paymentsInfoInner">
						<div class="paymentRow"><span>상품금액 :</span> <span id="totalProductPrice">0원</span></div>
						<div class="paymentRow"><span>배송비 :</span> <span id="shippingFee">0원</span></div>
						<div class="paymentRowFinal"><span>총 결제 금액 :</span> <h4 id="finalPrice">0원</h4></div>
						<button id="orderBtn">주문하기(0)</button>
					</div>
				</div>
			</div>
			<div class="cartInfoNote">
				<br>
				<h2>장바구니 유의사항</h2>
				<p>상품별 배송일정이 서로 다를시 가장 늦은 일정의 상품 기준으로 모두 함께 배송됩니다.</p>
				<p>배송지 수정시 예상일이 변경 될 수 있으며, 주문서에서 배송일정을 꼭 확인하시기 바랍니다.</p>
				<br>
			</div>
		</section>
		<template id="deliveryInfoTemplate">
		  <div class="deliveryInfo">
		    <p class="deliveryStatus">배송지 등록 필요</p>
		  </div>
		</template>
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
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script>
  const contextPath = '<%= request.getContextPath() %>';
</script>
<script>
function getCartItemsFromLocalStorage() {
	  const raw = localStorage.getItem("cartItems");
	  let cartItems = [];
	  try {
	    const parsed = JSON.parse(raw);
	    if (Array.isArray(parsed)) {
	      cartItems = parsed;
	    } else if (typeof parsed === 'object' && parsed !== null) {
	      cartItems = Object.values(parsed).filter(item => typeof item === 'object');
	    }
	  } catch (e) {
	    console.error("localStorage 파싱 오류", e);
	  }
	  return cartItems;
	}

function updateCartCount() {
	  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	  if (!Array.isArray(cartItems)) {
	    cartItems = Object.values(cartItems).filter(item => typeof item === 'object');
	  }

	  const cartCount = cartItems.length;
	  const cartCountElement = document.getElementById("cart-count");
	  
	  document.getElementById("cartCountTitle").textContent = "장바구니(" +cartCount + ")";

	  if (cartCountElement) {
	    cartCountElement.textContent = cartCount;
	    cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	  }
	}

function updateCartMessage() {
	let cartItemCount = document.querySelectorAll(".cartItem").length;
	let emptyMessages = document.querySelectorAll(".emptyCartMessage"); // 모든 메시지를 배열로 가져옴
	let selectAllCheckbox = document.querySelector('input[name="cartItems"][value="selectall"]');
	let selectAllLabel = selectAllCheckbox?.closest("label");

	emptyMessages.forEach(msg => {  // 모든 emptyCartMessage 처리
			if (cartItemCount === 0) {
					msg.style.display = "block"; // 장바구니가 비었으면 메시지 표시
			} else {
					msg.style.display = "none"; // 상품이 있으면 숨김
			}
	});

	if (selectAllCheckbox) {
		selectAllLabel.style.display = cartItemCount > 0 ? "inline-block" : "none";
	}
}

function updateTotalPayment() {
	  let totalPayment = 0;
	  let totalBookCount = 0;
	  let hasCheckedItems = false; // 체크된 항목 유무

	  document.querySelectorAll(".cartItem").forEach(cartItem => {
	    const checkbox = cartItem.querySelector('.cartItemCheckbox');
	    const quantity = parseInt(cartItem.querySelector(".num").value, 10);
	    const bookPrice = parseInt(cartItem.getAttribute("dataPrice"), 10);

	    if (checkbox.checked) {
	      totalPayment += bookPrice * quantity;
	      totalBookCount += quantity;
	      hasCheckedItems = true; // 체크된 항목 있음 표시
	    }
	  });

	  // 체크된 항목이 없으면 배송비도 0
	  const shippingCost = !hasCheckedItems ? 0 : (totalPayment > 50000 ? 0 : 3000);

	  document.getElementById("totalProductPrice").textContent = totalPayment.toLocaleString() + "원";
	  document.getElementById("shippingFee").textContent = shippingCost.toLocaleString() + "원";
	  document.getElementById("finalPrice").textContent = (totalPayment + shippingCost).toLocaleString() + "원";
	  document.getElementById("orderBtn").textContent = "주문하기(" + totalBookCount + ")";
}

function escapeHtml(str) {
	  if (!str) return "";
	  return str.replace(/&/g, "&amp;")
	            .replace(/</g, "&lt;")
	            .replace(/>/g, "&gt;")
	            .replace(/"/g, "&quot;")
	            .replace(/'/g, "&#039;");
}

function renderCartItems() {
	  console.log("renderCartItems() 실행됨");

	  const cartItems = getCartItemsFromLocalStorage();
	  console.log("가져온 cartItems:", cartItems);

	  const cartContainer = document.querySelector(".cartInfoCheck");

	  // '전체 선택' 라벨 유지
	  const selectAllLabel = cartContainer.querySelector("label");
	  cartContainer.innerHTML = "";
	  if (selectAllLabel) {
	    cartContainer.appendChild(selectAllLabel);
	  }

	  if (!cartItems || cartItems.length === 0) {
	    console.warn("장바구니 비어 있음");
	    document.getElementById("cartCountTitle").textContent = "장바구니 (0)";
	    updateCartMessage();
	    return;
	  }

	  cartItems.forEach((item, index) => {
	    const price = Number(item.price);
	    const quantity = Number(item.quantity);
	    const validPrice = isNaN(price) ? 0 : price;
	    const validQty = isNaN(quantity) ? 1 : quantity;
	    const total = validPrice * validQty;
	    const totalPriceStr = total.toLocaleString();

	    console.log(`[${index}]`, item.title, validPrice, validQty, totalPriceStr);

	    const itemWrapper = document.createElement("div");
	    itemWrapper.classList.add("cartItem");
	    itemWrapper.setAttribute("dataPrice", validPrice);
	    itemWrapper.setAttribute("data-id", item.id);

	    // 체크박스
	    const checkbox = document.createElement("input");
	    checkbox.type = "checkbox";
	    checkbox.name = "cartItems";
	    checkbox.className = "cartItemCheckbox";
	    checkbox.checked = true;

	    // 이미지
	    const img = document.createElement("img");
	    img.src = encodeURI(item.image || "https://via.placeholder.com/80x100?text=No+Image");
	    img.className = "bookImg";
	    img.onerror = function () {
	      this.onerror = null;
	      this.src = "https://via.placeholder.com/80x100?text=No+Image";
	    };
	    // 제목
	    const bookTitleDiv = document.createElement("div");
	    bookTitleDiv.className = "bookTitle";
	    const titleP = document.createElement("p");
	    titleP.textContent = (item.title || "제목 없음").replace(/\n/g, "").trim();
	    bookTitleDiv.appendChild(titleP);

	    // 수량/가격
	    const bookQuantityDiv = document.createElement("div");
	    bookQuantityDiv.className = "bookQuantity";

	    const totalPriceDiv = document.createElement("div");
	    totalPriceDiv.className = "totalPrice";
	    totalPriceDiv.textContent = `${totalPriceStr}원`;

	    const quantityDiv = document.createElement("div");
	    quantityDiv.className = "quantity";

	    const minusBtn = document.createElement("button");
	    minusBtn.className = "minus";
	    minusBtn.textContent = "−";

	    const quantityInput = document.createElement("input");
	    quantityInput.type = "text";
	    quantityInput.value = validQty;
	    quantityInput.className = "num";

	    const plusBtn = document.createElement("button");
	    plusBtn.className = "plus";
	    plusBtn.textContent = "+";

	    quantityDiv.appendChild(minusBtn);
	    quantityDiv.appendChild(quantityInput);
	    quantityDiv.appendChild(plusBtn);

	    bookQuantityDiv.appendChild(totalPriceDiv);
	    bookQuantityDiv.appendChild(quantityDiv);

	    // 배송지
	    const deliveryInfoTemplate = document.getElementById("deliveryInfoTemplate");
		const clone = deliveryInfoTemplate.content.cloneNode(true);  // <div class="deliveryInfo">...</div>
		

	    // 삭제 버튼
	    const removeBtn = document.createElement("button");
	    removeBtn.className = "removeBtn";
	    removeBtn.textContent = "✖";

	    // 조립
	    itemWrapper.appendChild(checkbox);
	    itemWrapper.appendChild(img);
	    itemWrapper.appendChild(bookTitleDiv);
	    itemWrapper.appendChild(bookQuantityDiv);
	    itemWrapper.appendChild(clone);
	    itemWrapper.appendChild(removeBtn);

	    cartContainer.appendChild(itemWrapper);
	  });

	  updateCartMessage();
	  updateCartCount();
	  bindCartEvents();

	  // 첫 렌더링 시 가격 누락 방지 위해 강제 갱신
	  setTimeout(() => {
	    document.querySelectorAll(".cartItem").forEach(cartItem => {
	      const bookPrice = parseInt(cartItem.getAttribute("dataPrice"), 10);
	      const totalPriceEl = cartItem.querySelector(".totalPrice");
	      const quantity = parseInt(cartItem.querySelector(".num").value, 10);
	      if (totalPriceEl && !isNaN(bookPrice) && !isNaN(quantity)) { 
	        const total = bookPrice * quantity;
	        totalPriceEl.textContent = total.toLocaleString() + "원";
	      }
	    });
	  }, 0);
	  // 결제 정보 갱신
	  updateTotalPayment();
	 
}
function bindCartEvents() {
	  document.querySelectorAll(".cartItem").forEach(cartItem => {
	    const minusBtn = cartItem.querySelector(".minus");
	    const plusBtn = cartItem.querySelector(".plus");
	    const numInput = cartItem.querySelector(".num");
	    const totalPriceEl = cartItem.querySelector(".totalPrice");
	    const checkbox = cartItem.querySelector(".cartItemCheckbox");
	    const removeBtn = cartItem.querySelector(".removeBtn");
	    const bookPrice = parseInt(cartItem.getAttribute("dataPrice"), 10);

	    // 수량 및 가격 갱신 함수
	    function updateTotalPrice() {
	      let quantity = parseInt(numInput.value);
	      if (isNaN(quantity) || quantity < 1) {
	        quantity = 1;
	        numInput.value = quantity;
	      }
	      const total = bookPrice * quantity;
	      totalPriceEl.textContent = total.toLocaleString() + "원";
	      updateTotalPayment();
	    }

	    // − 버튼 클릭
	    minusBtn?.addEventListener("click", () => {
	      let currentValue = parseInt(numInput.value);
	      if (currentValue > 1) {
	        numInput.value = currentValue - 1;
	        updateTotalPrice();
	      }
	    });

	    // + 버튼 클릭
	    plusBtn?.addEventListener("click", () => {
	      let currentValue = parseInt(numInput.value);
	      numInput.value = currentValue + 1;
	      updateTotalPrice();
	    });

	    // 숫자 직접 입력 시
	    numInput?.addEventListener("input", () => {
	      numInput.value = numInput.value.replace(/[^0-9]/g, '');
	      updateTotalPrice();
	    });

	    // blur 시 기본값 보정
	    numInput?.addEventListener("blur", () => {
	      if (!numInput.value || isNaN(numInput.value) || parseInt(numInput.value) < 1) {
	        numInput.value = "1";
	        updateTotalPrice();
	      }
	    });

	    // 체크박스 변화 감지 → 결제 정보 갱신
	    checkbox?.addEventListener("change", updateTotalPayment);

	    // 삭제 버튼 클릭 시
	    removeBtn?.addEventListener("click", () => {
	      const itemId = cartItem.getAttribute("data-id");
	      let cartItems = getCartItemsFromLocalStorage();
	      cartItems = cartItems.filter(item => item.id !== itemId);
	      localStorage.setItem("cartItems", JSON.stringify(cartItems));
	      cartItem.remove();
	      updateCartCount();
	      updateCartMessage();
	      updateTotalPayment();
	    });
	  });

	  // 전체 선택 체크박스 이벤트
	  const selectAllCheckbox = document.querySelector('input[name="cartItems"][value="selectall"]');
	  if (selectAllCheckbox) {
	    selectAllCheckbox.addEventListener("change", function () {
	      const checked = this.checked;
	      document.querySelectorAll(".cartItemCheckbox").forEach(cb => {
	        cb.checked = checked;
	      });
	      updateTotalPayment();
	    });
	  }
	}

	$(document).ready(function () {
	  updateCartCount();
	  renderCartItems();

	  // 주문 버튼 클릭 시
	  $("#orderBtn").on("click", function () {
	    const selectedCount = $(".cartItemCheckbox:checked").length;
	    if (selectedCount < 1) {
	      alert("주문할 상품을 선택해주세요.");
	    } else {
	      window.location.href = "./login.do";
	    }
	  });
	});
// 초기 실행
$(document).ready(function () {
  if (document.getElementById("loginBtn")) {
    initHeaderEvents();
  }
  updateCartCount();
  renderCartItems();
  setTimeout(updateCartMessage, 100);
});
</script>
<script>		
			
document.addEventListener("DOMContentLoaded", function () {
      const firstModal = document.getElementById("firstModal");
      const cartInfoBtn = document.getElementById("cartInfoBtn");
      const closeFirstModalBtn = document.getElementById("closeFirstModal");

      const secondModal = document.getElementById("secondModal");
      const addAddressBtn = document.getElementById("addAddressBtn");
      const saveAddress = document.getElementById("saveAddress");
			const closeSecondModalBtn = document.getElementById("closeSecondModal");

      // 페이지 로드 시 모달을 숨김
      firstModal.style.display = "none";
      secondModal.style.display = "none";

      // 첫 번째 모달 열기 버튼 클릭 시
      cartInfoBtn.addEventListener("click", function () {
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

			// 첫 번째 모달 닫기 버튼 클릭 시
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

        // 배송지 업데이트 함수
        function updateDeliveryInfo() {
		  const selectedAddress = $("input[name='address']:checked").closest(".addressItem");
		
		  let addressText = "배송지 등록 필요";
		  if (selectedAddress.length > 0) {
		    addressText =
		      selectedAddress.find("p:nth-child(2)").text() + "\n" +
		      selectedAddress.find("p:nth-child(3)").text();
		  }
		
		  // 템플릿 가져오기
		  const template = document.getElementById("deliveryInfoTemplate");
		
		  document.querySelectorAll(".cartItem").forEach(cartItem => {
		    // 기존 deliveryInfo 제거
		    const oldDelivery = cartItem.querySelector(".deliveryInfo");
		    if (oldDelivery) oldDelivery.remove();
		
		    // 새 템플릿 복제
		    const clone = template.content.cloneNode(true);
		    const statusElement = clone.querySelector(".deliveryStatus");
		    statusElement.textContent = addressText;
		
		    // cartItem 하위에 삽입 (삭제 버튼 바로 앞에 넣는 구조라면 이 줄 조정 가능)
		    cartItem.insertBefore(clone, cartItem.querySelector(".removeBtn"));
		  });
		}

        // 페이지 로드 시 기본 배송지 설정
        updateDeliveryInfo();

        // 배송지가 변경될 때마다 업데이트
        $(document).on("change", "input[name='address']", function () {
            updateDeliveryInfo();
        });

         // 저장 버튼 클릭 시 새로운 배송지 추가
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
        });

        // 삭제 기능 (이벤트 위임 방식)
        $(document).on("click", ".deleteAddress", function () {
            $(this).closest(".addressItem").remove();
            updateDeliveryInfo(); // 삭제 후 배송지 업데이트
        });

        // 기본 배송지가 변경될 때마다 업데이트
        $(document).on("change", "input[name='address']", function () {
            updateDeliveryInfo();
        });
    	});
  </script>
</body>
</html>
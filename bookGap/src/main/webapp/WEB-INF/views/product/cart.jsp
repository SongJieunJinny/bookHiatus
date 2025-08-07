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
<sec:authorize access="isAuthenticated()">
  <div id="cart-data" data-json='${fn:escapeXml(cartItemsJson)}'></div>
  <c:set var="userId" value="${pageContext.request.userPrincipal.name}" />
  <script>window.isLoggedIn = true;</script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <div id="cart-data" data-json='[]'></div>
  <script>window.isLoggedIn = false;</script>
</sec:authorize>

<div id="wrap">
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<section>
			<div class="cartInfoInnerList">
				<div class="cartInfoInner">
					<h3 id="cartCountTitle">장바구니 ()</h3>
					  <div class="cartInfoButton">
					    <button type="button" id="cartInfoBtn">
					      <img src="<%= request.getContextPath() %>/resources/img/icon/address.png"> 기본배송지
					    </button>
					  </div>
				</div>
				<div><p class="emptyCartMessage">장바구니가 비어 있습니다.</p></div>
				<div class="cartContainer">
					<div class="cartInfoCheck">
						<label><input type="checkbox" name="cartItems" value="selectall" > <b>전체 선택</b></label>
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
		  <div id="addressList"></div>
	    </div>
	  </div>
	   <!-- 모달: 배송지 추가 -->
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
	  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</div>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script>

const cartDataEl = document.getElementById("cart-data");
let dbCartItems = [];
try {
    const rawJson = cartDataEl ? cartDataEl.dataset.json : "[]";
    const parsed = JSON.parse(rawJson);
    dbCartItems = Array.isArray(parsed) ? parsed : Object.values(parsed);
    //console.log("[디버그] DB에서 받은 cartItems:", dbCartItems);
} catch (e) {
   // console.error("[에러] JSON 파싱 실패:", e);
    dbCartItems = [];
}

function getCartItemsFromLocalStorage() {
    const raw = localStorage.getItem("cartItems");
    if (!raw) return [];
    try {
        const parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : Object.values(parsed).filter(i => typeof i === 'object');
    } catch (e) {
       // console.error("localStorage 파싱 오류", e);
        return [];
    }
}

function normalizeCartItems(items) {
    const merged = {};
    items.forEach(item => {
        const key = item.bookNo || item.isbn || item.id;
        const quantity = Number(item.quantity || item.count || 1);

        if (quantity < 1) return; // 0개는 렌더링 안 함

        if (!merged[key]) {
            merged[key] = { ...item, quantity: quantity };
        } else {
            merged[key].quantity += quantity;
        }
    });
    return Object.values(merged);
    
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
    //console.error("localStorage 파싱 오류", e);
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
    const cartCountTitle = document.getElementById("cartCountTitle");

    if (cartCountTitle) {
        cartCountTitle.textContent = "장바구니(" + cartCount + ")";
    }

    if (cartCountElement) {
        cartCountElement.textContent = cartCount;
        cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
    }
}

function updateCartMessage() {
    const cartItemCount = document.querySelectorAll(".cartItem").length;
    const emptyMessages = document.querySelectorAll(".emptyCartMessage");
    const selectAllCheckbox = document.querySelector('input[name="cartItems"][value="selectall"]');
    const selectAllLabel = selectAllCheckbox?.closest("label");

    emptyMessages.forEach(msg => {
        msg.style.display = cartItemCount === 0 ? "block" : "none";
    });
    if (selectAllCheckbox) {
        selectAllLabel.style.display = cartItemCount > 0 ? "inline-block" : "none";
    }
}

function updateTotalPayment() {
    let totalPayment = 0;
    let totalBookCount = 0;
    let hasCheckedItems = false;

    document.querySelectorAll(".cartItem").forEach(cartItem => {
        const checkbox = cartItem.querySelector('.cartItemCheckbox');
        const quantity = parseInt(cartItem.querySelector(".num").value, 10);
        const bookPrice = parseInt(cartItem.getAttribute("dataPrice"), 10);

        if (checkbox.checked) {
            totalPayment += bookPrice * quantity;
            totalBookCount += quantity;
            hasCheckedItems = true;
        }
    });

    const shippingCost = !hasCheckedItems ? 0 : (totalPayment > 50000 ? 0 : 3000);

    document.getElementById("totalProductPrice").textContent = totalPayment.toLocaleString() + "원";
    document.getElementById("shippingFee").textContent = shippingCost.toLocaleString() + "원";
    document.getElementById("finalPrice").textContent = (totalPayment + shippingCost).toLocaleString() + "원";
    document.getElementById("orderBtn").textContent = "주문하기(" + totalBookCount + ")";
}

function renderCartItems() {
    let cartItems = isLoggedIn ? dbCartItems : getCartItemsFromLocalStorage();
   // console.log("[디버그] renderCartItems() 호출됨. isLoggedIn:", isLoggedIn, "cartItems:", cartItems);
    cartItems = normalizeCartItems(cartItems); // 중복 항목 합쳐서 quantity 누적
   // console.log("[디버그] normalizeCartItems 결과:", cartItems);

    if (!isLoggedIn) {
        // 비회원이면 합쳐진 결과를 다시 localStorage 저장
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
    }

  //  console.log("렌더링할 cartItems:", cartItems);

    const cartContainer = document.querySelector(".cartInfoCheck");
    const selectAllLabel = cartContainer.querySelector("label");
    cartContainer.innerHTML = "";
    if (selectAllLabel) cartContainer.appendChild(selectAllLabel);

    if (!cartItems.length) {
        document.getElementById("cartCountTitle").textContent = "장바구니 (0)";
        updateCartMessage();
        return;
    }

    cartItems.forEach(item => {
    	const price = Number(item.price || 0);
        const quantity = Number(item.quantity || item.count || 1);
        const totalPrice = price * quantity;
        const imageUrl = item.image ? encodeURI(item.image) : "https://via.placeholder.com/80x100?text=No+Image";
        const uniqueId = isLoggedIn ? item.cartNo : (item.bookNo || item.isbn || item.id || "");

        const itemWrapper = document.createElement("div");
        itemWrapper.classList.add("cartItem");
        itemWrapper.setAttribute("dataPrice", price);
        itemWrapper.setAttribute("data-id", uniqueId);
        itemWrapper.setAttribute("data-isbn", item.isbn || "");

        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.className = "cartItemCheckbox";
        checkbox.checked = true;

        const img = document.createElement("img");
        img.src = imageUrl;
        img.className = "bookImg";
        img.onerror = function () {
            this.src = "https://via.placeholder.com/80x100?text=No+Image";
        };

        const titleDiv = document.createElement("div");
        titleDiv.className = "bookTitle";
        const titleP = document.createElement("p");
        titleP.textContent = (item.title || "제목 없음").trim();
        titleDiv.appendChild(titleP);

        const bookQuantityDiv = document.createElement("div");
        bookQuantityDiv.className = "bookQuantity";

        const totalPriceDiv = document.createElement("div");
        totalPriceDiv.className = "totalPrice";
        totalPriceDiv.textContent = `${totalPrice.toLocaleString()}원`;

        const quantityDiv = document.createElement("div");
        quantityDiv.className = "quantity";

        const minusBtn = document.createElement("button");
        minusBtn.className = "minus";
        minusBtn.textContent = "−";

        const quantityInput = document.createElement("input");
        quantityInput.type = "text";
        quantityInput.value = quantity;
        quantityInput.className = "num";

        const plusBtn = document.createElement("button");
        plusBtn.className = "plus";
        plusBtn.textContent = "+";

        quantityDiv.append(minusBtn, quantityInput, plusBtn);
        bookQuantityDiv.append(totalPriceDiv, quantityDiv);

        const deliveryInfoTemplate = document.getElementById("deliveryInfoTemplate");
        const clone = deliveryInfoTemplate.content.cloneNode(true);

        const removeBtn = document.createElement("button");
        removeBtn.className = "removeBtn";
        removeBtn.textContent = "✖";

        itemWrapper.append(checkbox, img, titleDiv, bookQuantityDiv, clone, removeBtn);
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
        const itemId = cartItem.getAttribute("data-id"); // bookNo, isbn 또는 id

        function updateTotalPrice() {
            let quantity = parseInt(numInput.value);
            if (isNaN(quantity) || quantity < 1) {
                quantity = 1;
                numInput.value = quantity;
            }

            const total = bookPrice * quantity;
            totalPriceEl.textContent = total.toLocaleString() + "원";
            updateTotalPayment();

            // 로그인한 사용자일 경우 서버에 수량 업데이트 요청
            if (isLoggedIn) {
                $.post(contextPath + "/product/updateCart.do", {
                    cartNo: itemId,
                    count: quantity
                })
                .done(res => {
                    if (res === "DB_UPDATED") {
                        console.log("장바구니 수량 서버 반영 완료");
                    } else {
                        console.warn("장바구니 수량 반영 실패:", res);
                    }
                })
                .fail(err => {
                    console.error("수량 변경 중 서버 통신 실패", err);
                });
            }
        }

        minusBtn?.addEventListener("click", () => {
            let currentValue = parseInt(numInput.value);
            if (currentValue > 1) {
                numInput.value = currentValue - 1;
                updateTotalPrice();
            }
        });

        plusBtn?.addEventListener("click", () => {
            let currentValue = parseInt(numInput.value);
            numInput.value = currentValue + 1;
            updateTotalPrice();
        });

        numInput?.addEventListener("input", () => {
            numInput.value = numInput.value.replace(/[^0-9]/g, '');
            updateTotalPrice();
        });

        numInput?.addEventListener("blur", () => {
            if (!numInput.value || isNaN(numInput.value) || parseInt(numInput.value) < 1) {
                numInput.value = "1";
                updateTotalPrice();
            }
        });

        checkbox?.addEventListener("change", updateTotalPayment);

        // --- 삭제 버튼 로직 (DB + LocalStorage 동기화) ---
        removeBtn?.addEventListener("click", () => {
            if (isLoggedIn) {
                // DB 삭제 (cartNo 또는 bookNo 기준)
                $.post(contextPath + "/product/deleteCart.do", { cartNo: itemId })
                    .done(response => {
                        //console.log("[디버그] DB 삭제 결과:", response);
                        if (response === "DB_DELETED") {
                            cartItem.remove();
                            let localItems = getCartItemsFromLocalStorage();
                            localItems = localItems.filter(item => item.cartNo !== itemId);
                            localStorage.setItem("cartItems", JSON.stringify(localItems));
                            fetchAndUpdateCart(); // 최신 DB 기준으로 다시 렌더링
                        } else {
                            alert("삭제 실패: 다시 시도해주세요.");
                        }
                    })
                    .fail(xhr => {
                        //console.error("[에러] 서버 삭제 실패", xhr.responseText);
                        alert("서버와의 통신 오류로 삭제할 수 없습니다.");
                    });
            } else {
                // 비회원 → 로컬스토리지에서만 삭제
                let cartItems = getCartItemsFromLocalStorage();
                cartItems = cartItems.filter(item => 
                    (item.bookNo || item.isbn || item.id) != itemId
                );
                localStorage.setItem("cartItems", JSON.stringify(cartItems));
                cartItem.remove();
                updateCartCount();
                updateCartMessage();
                updateTotalPayment();
            }
        });
    });

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

// DB 기준으로 장바구니 최신화
function fetchAndUpdateCart() {
    $.get(contextPath + "/product/getCartByUser.do", function (data) {
        dbCartItems = Array.isArray(data) ? data : [];
        renderCartItems(); // 최신 데이터로 다시 렌더링
    });
}

$(document).ready(function () {
    if (document.getElementById("loginBtn")) {
        initHeaderEvents();
    }
    if (isLoggedIn) {
        syncLocalCartToDB(); // 로그인 시 로컬 장바구니 DB 동기화
    }
    renderCartItems();
    updateCartCount();
    setTimeout(updateCartMessage, 100);


});

	  // 장바구니 렌더링
	  updateCartCount();
	  renderCartItems();

	  // 장바구니 비어있는 경우 메시지 표시
	  setTimeout(updateCartMessage, 100);
	  
		//주문하기 버튼 
	 $("#orderBtn").on("click", function () {
    const selectedItems = $(".cartItemCheckbox:checked");

    if (selectedItems.length < 1) {
        alert("주문할 상품을 선택해주세요.");
        return;
    }

    if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
        const form = document.createElement("form");
        form.method = "POST";
        form.action = contextPath + "/order/orderMain.do";

        // 총 결제 금액
        const totalPriceText = $("#finalPrice").text().replace(/[^0-9]/g, "");
        const inputTotal = document.createElement("input");
        inputTotal.type = "hidden";
        inputTotal.name = "totalPrice";
        inputTotal.value = totalPriceText;
        form.appendChild(inputTotal);

        // userId (서버에서 세션으로도 처리 가능하나, 확실히 넘기려면 포함)
        const inputUser = document.createElement("input");
        inputUser.type = "hidden";
        inputUser.name = "userId";
        inputUser.value = "<c:out value='${userId}'/>";
        form.appendChild(inputUser);

        // 배송지 ID
        const selectedAddress = $("input[name='address']:checked").val();
        if (!selectedAddress) {
            alert("배송지를 선택해주세요.");
            return;
        }
        const inputAddr = document.createElement("input");
        inputAddr.type = "hidden";
        inputAddr.name = "userAddressId";
        inputAddr.value = selectedAddress;
        console.log("selectedAddress:", selectedAddress);
        form.appendChild(inputAddr);

        // 선택된 장바구니 항목들 추가
        selectedItems.each(function () {
            const cartItem = $(this).closest(".cartItem");
            const isbn = cartItem.data("isbn");
            const cartNo = cartItem.data("id");
            const quantity = cartItem.find(".num").val();

            if (isbn && quantity) {
                form.appendChild($("<input>", { type: "hidden", name: "isbns", value: isbn })[0]);
                form.appendChild($("<input>", { type: "hidden", name: "quantities", value: quantity })[0]);
                form.appendChild($("<input>", { type: "hidden", name: "cartNos", value: cartNo })[0]);
            }
        });

        document.body.appendChild(form);
        form.submit();
    } else {
        alert("로그인이 필요합니다.");
        $("#menuLogin").click();
    }
});

</script>
<script>		
//========== 모달 열기/닫기 ==========
document.addEventListener("DOMContentLoaded", function () {
    const firstModal = document.getElementById("firstModal");
    const secondModal = document.getElementById("secondModal");
    const cartInfoBtn = document.getElementById("cartInfoBtn");
    const closeFirst = document.getElementById("closeFirstModal");
    const closeSecond = document.getElementById("closeSecondModal");

    if (firstModal) firstModal.style.display = "none";
    if (secondModal) secondModal.style.display = "none";

    // 배송지 목록 모달 열기
     if (cartInfoBtn) {
        cartInfoBtn.addEventListener("click", function () {
            if (!window.isLoggedIn) {
                alert("로그인이 필요한 기능입니다.");
                const loginBtn = document.getElementById("menuLogin");
                if (loginBtn) {
                    loginBtn.click(); // 로그인 버튼 강제 클릭
                } else {
                    location.href = contextPath + "/member/login.do"; // 로그인 페이지로 이동
                }
                return;
            }

            if (firstModal) {
                firstModal.style.display = "flex";
                loadAddressList();
            } else {
                console.error("firstModal 요소를 찾을 수 없습니다.");
            }
        });
    }

     if (closeFirst) {
         closeFirst.addEventListener("click", function () {
             firstModal.style.display = "none";
             updateDeliveryInfo();
         });
     }

    // 배송지 추가 모달 열기
     if (document.getElementById("addAddressBtn")) {
        document.getElementById("addAddressBtn").addEventListener("click", function () {
            if (secondModal) {
                secondModal.style.display = "flex";
                $("#addressForm").show();
            }
        });
    }

     if (closeSecond) {
         closeSecond.addEventListener("click", function () {
             secondModal.style.display = "none";
             $("#addressForm").hide();
         });
     }
});
//========== 배송지 목록 불러오기 (회원 전용) ==========
let isAddressLoading = false; 

function loadAddressList() {
  if (isAddressLoading) {
   // console.warn("이미 주소 리스트 로딩 중입니다.");
    return;
  }

  const list = document.getElementById("addressList");
  if (!list) {
    //console.error(" addressList 요소를 찾을 수 없습니다.");
    return;
  }

  isAddressLoading = true;
  list.innerHTML = "";  
 // console.log("배송지 정보 요청 시작...");

  fetch("/controller/address/list.do")
    .then(res => {
      if (!res.ok) throw new Error(" 서버 응답 실패: " + res.status);
      return res.json();
    })
    .then(addresses => {
      console.log("서버 응답 데이터:", addresses);

      if (!Array.isArray(addresses)) {
        list.innerHTML = "<p>잘못된 형식의 데이터입니다.</p>";
        return;
      }

      if (addresses.length === 0) {
        list.innerHTML = "<p>등록된 배송지가 없습니다.</p>";
        return;
      }

      let selectedAddressText = "";

      addresses.forEach(addr => {

        const isDefault = Number(addr.isDefault) === 1;
        const wrapper = document.createElement("div");
        wrapper.className = "addressItem";
        wrapper.dataset.id = addr.userAddressId;

        // 라벨과 라디오 버튼
        const label = document.createElement("label");
        const radio = document.createElement("input");
        radio.type = "radio";
        radio.name = "address";
        radio.value = addr.userAddressId;
        if (isDefault) radio.checked = true;

        const nameSpan = document.createElement("span");
        nameSpan.textContent = addr.addressName || "배송지";

        label.appendChild(radio);
        label.appendChild(nameSpan);

        if (isDefault) {
          const defaultTag = document.createElement("span");
          defaultTag.className = "defaultTag";
          defaultTag.textContent = "[기본배송지]";
          label.appendChild(defaultTag);
        }

        // 수령인 정보
        const userInfo = document.createElement("p");
        userInfo.textContent = "수령인: " + [addr.userName, addr.userPhone].join(" / ");
       

        //  주소 정보
        const addressInfo = document.createElement("p");
        try {
          const postCode = (addr.postCode ?? "").trim();
          const road = (addr.roadAddress ?? "").trim();
          const detail = (addr.detailAddress ?? "").trim();
          const composedAddress = "[" + String(postCode).trim() + "] " + String(road).trim() + " " + String(detail).trim();
          addressInfo.textContent = composedAddress;
        } catch (err) {
          console.error("주소 구성 중 오류 발생:", err);
          addressInfo.textContent = "[주소 불러오기 실패]";
        }

        // 삭제 버튼
        const deleteBtn = document.createElement("button");
        deleteBtn.className = "deleteAddress";
        deleteBtn.textContent = "삭제";
        deleteBtn.addEventListener("click", () => {
          deleteAddress(addr.userAddressId);
        });

        // 조립 및 출력
        wrapper.append(label, userInfo, addressInfo, deleteBtn);
        list.appendChild(wrapper);
      });

      updateDeliveryInfoWithText(selectedAddressText);
    })
    .catch(err => {
      console.error("배송지 로딩 중 오류 발생:", err);
      list.innerHTML = "<p>배송지 정보를 불러오지 못했습니다.</p>";
    })
    .finally(() => {
      isAddressLoading = false; 
    });
}

document.addEventListener("DOMContentLoaded", function () {
    const cartInfoBtn = document.getElementById("cartInfoBtn");
    if (!cartInfoBtn) {
        console.error(" cartInfoBtn이 존재하지 않습니다!");
        return;
    }

    cartInfoBtn.addEventListener("click", function () {
        console.log("배송지 모달 버튼 클릭됨");
        firstModal.style.display = "flex";
        loadAddressList(); 
        console.log("loadAddressList 호출됨")
    });
});
// ========== 배송지 추가 (회원 전용) ==========
$("#saveAddress").on("click", function (event) {
    event.preventDefault();

    const payload = {
        addressName: $("#addressName").val(),
        userName: $("#recipient").val(),
        userPhone: $("#userPhone").val(),
        postCode: $("#zipcode").val(),
        roadAddress: $("#address").val(),
        detailAddress: $("#addressDetail").val(),
        isDefault: 0
    };

    $.ajax({
        url: contextPath + "/address/add.do",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function(res) {
            if (res === "SUCCESS") {
                alert("배송지가 추가되었습니다.");
                $("#addressForm").trigger("reset").hide();
                loadAddressList();
                $("#secondModal").hide();
            } else {
                alert("배송지 추가 실패: " + res);
            }
        }
    });
});

// ========== 카카오 주소 검색 API ==========
$("#searchAddress").on("click", function (event) {
    event.preventDefault();
    new daum.Postcode({
        oncomplete: function (data) {
            $("#zipcode").val(data.zonecode);
            $("#address").val(data.roadAddress);
            $("#addressDetail").focus();
            $("#addressForm").show(); // 검색 후 폼 자동 표시
        }
    }).open();
});

// ========== 배송지 삭제 (회원 전용) ==========
$(document).on("click", ".deleteAddress", function () {
    const addressId = $(this).closest(".addressItem").data("id");
    if (!confirm("이 배송지를 삭제하시겠습니까?")) return;

    $.post(contextPath + "/address/delete.do", { addressId }, function (res) {
        if (res === "SUCCESS") {
            alert("삭제되었습니다.");
            loadAddressList();
        } else {
            alert("삭제 실패: " + res);
        }
    });
});

// ========== 배송지 선택 시 UI 업데이트 ==========
function updateDeliveryInfo() {
    const selectedAddress = $("input[name='address']:checked").closest(".addressItem");
    let addressText = "배송지 등록 필요";

    if (selectedAddress.length > 0) {
        addressText =
          selectedAddress.find("p:nth-child(2)").text() + "\n" +
          selectedAddress.find("p:nth-child(3)").text();
    }

    const template = document.getElementById("deliveryInfoTemplate");
    document.querySelectorAll(".cartItem").forEach(cartItem => {
        const oldDelivery = cartItem.querySelector(".deliveryInfo");
        if (oldDelivery) oldDelivery.remove();
        const clone = template.content.cloneNode(true);
        clone.querySelector(".deliveryStatus").textContent = addressText;
        cartItem.insertBefore(clone, cartItem.querySelector(".removeBtn"));
    });
}
function updateDeliveryInfoWithText(addressText) {
    const template = document.getElementById("deliveryInfoTemplate");
    document.querySelectorAll(".cartItem").forEach(cartItem => {
        const oldDelivery = cartItem.querySelector(".deliveryInfo");
        if (oldDelivery) oldDelivery.remove();
        const clone = template.content.cloneNode(true);
        clone.querySelector(".deliveryStatus").textContent = addressText;
        cartItem.insertBefore(clone, cartItem.querySelector(".removeBtn"));
    });
}

</script>
<script>
function syncLocalCartToDB() {
	if (sessionStorage.getItem("cartSynced")) {
        return; // 이미 동기화한 경우 다시 실행 안 함
    }
    const localItems = getCartItemsFromLocalStorage();

    if (!localItems.length) {
        localStorage.setItem("cartItems", JSON.stringify(dbCartItems || []));
        updateCartCount();
        renderCartItems();
        return Promise.resolve();
    }

    const payload = localItems
        .filter(i => (i.quantity || i.count || 1) > 0)
        .map(i => ({
            userId: i.userId || '',
            bookNo: i.bookNo,
            count: i.quantity || i.count || 1
        }));

    return $.ajax({
        url: contextPath + "/product/syncCart.do",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function () {
           // console.log("[디버그] 동기화 성공 → DB 기준으로 덮어쓰기");

            // 중복 방지: 로컬스토리지 초기화 후 DB 데이터로만 채움
            localStorage.removeItem("cartItems");
            localStorage.setItem("cartItems", JSON.stringify(dbCartItems || []));

            updateCartCount();
            renderCartItems();
        },
        error: function (xhr) {
            console.error("[에러] 동기화 실패", xhr.responseText);
        }
    });
}
</script>
</body>
</html>
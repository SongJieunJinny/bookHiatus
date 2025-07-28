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
  <script>const isLoggedIn = true;</script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <div id="cart-data" data-json='[]'></div>
  <script>const isLoggedIn = false;</script>
</sec:authorize>

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
	      <div id="addressList">
	      </div>
	    </div>
	  </div>
	   <!-- 모달: 배송지 추가 -->
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
	  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</div>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script>
  const contextPath = '<%= request.getContextPath() %>';
</script>
<script>

const cartDataEl = document.getElementById("cart-data");
let dbCartItems = [];
try {
    const rawJson = cartDataEl ? cartDataEl.dataset.json : "[]";
    const parsed = JSON.parse(rawJson);
    dbCartItems = Array.isArray(parsed) ? parsed : Object.values(parsed);
    console.log("[디버그] DB에서 받은 cartItems:", dbCartItems);
} catch (e) {
    console.error("[에러] JSON 파싱 실패:", e);
    dbCartItems = [];
}

function getCartItemsFromLocalStorage() {
    const raw = localStorage.getItem("cartItems");
    if (!raw) return [];
    try {
        const parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : Object.values(parsed).filter(i => typeof i === 'object');
    } catch (e) {
        console.error("localStorage 파싱 오류", e);
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
    console.log("[디버그] renderCartItems() 호출됨. isLoggedIn:", isLoggedIn, "cartItems:", cartItems);
    cartItems = normalizeCartItems(cartItems); // 중복 항목 합쳐서 quantity 누적
    console.log("[디버그] normalizeCartItems 결과:", cartItems);

    if (!isLoggedIn) {
        // 비회원이면 합쳐진 결과를 다시 localStorage 저장
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
    }

    console.log("렌더링할 cartItems:", cartItems);

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
                        console.log("[디버그] DB 삭제 결과:", response);
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
                        console.error("[에러] 서버 삭제 실패", xhr.responseText);
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

    // 주문 버튼 클릭 이벤트
    $("#orderBtn").on("click", function () {
        const selectedCount = $(".cartItemCheckbox:checked").length;
        if (selectedCount < 1) {
            alert("주문할 상품을 선택해주세요.");
            return;
        }

        if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
            const quantity = $(".num").val();
            const isbn = "${bookDetail.isbn}"; 
            window.location.href = `/controller/order/orderMain.do?isbn=${isbn}&quantity=${quantity}`;
        } else {
            const menuLogin = document.getElementById("menuLogin");
            if (menuLogin) {
                menuLogin.click();
            } else {
                alert("로그인 모달을 열 수 없습니다.");
            }
        }
    });
});

	  // 장바구니 렌더링
	  updateCartCount();
	  renderCartItems();

	  // 장바구니 비어있는 경우 메시지 표시
	  setTimeout(updateCartMessage, 100);

	  // 주문 버튼 클릭
	  $("#orderBtn").on("click", function () {
	    // selectedCount -> selectedItems로 변수명을 수정하고, 먼저 선언합니다.
	    const selectedItems = $(".cartItemCheckbox:checked"); 

	    if (selectedItems.length < 1) { // .length로 개수를 확인합니다.
	      alert("주문할 상품을 선택해주세요.");
	      return;
	    }

	    if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
        // --- 로그인 상태: 선택된 상품 정보를 URL로 만들기 ---
        let params = []; 

        // 위에서 선언한 selectedItems 변수를 사용합니다.
        selectedItems.each(function() {
            const item = $(this).closest(".cartItem");
            const isbn = item.data("id");
            const quantity = item.find(".num").val();
            
            params.push("isbns=" + encodeURIComponent(isbn));
            params.push("quantities=" + encodeURIComponent(quantity));
        });
        
        const contextPath = '<%= request.getContextPath() %>';
        const queryString = params.join('&');
        const finalUrl = contextPath + "/order/orderMain.do?" + queryString;
        
        window.location.href = finalUrl;

	    } else {
	      // 비로그인 상태
	      alert("로그인이 필요합니다.");
	      const menuLogin = document.getElementById("menuLogin");
	      if (menuLogin) {
	        menuLogin.click();
	      }
	    }
		});

</script>
<script>		
//========== 배송지 목록 불러오기 (회원 전용) ==========
function loadAddressList() {
    $.get(contextPath + "/address/list.do", function(addresses) {
        const list = $("#addressList");
        list.empty();

        if (!addresses || addresses.length === 0) {
            list.append("<p>등록된 배송지가 없습니다.</p>");
            return;
        }

        addresses.forEach(addr => {
            const isDefaultTag = addr.isDefault ? '<span class="defaultTag">[기본배송지]</span>' : '';
            list.append(`
                <div class="addressItem" data-id="${addr.userAddressId}">
                  <label>
                    <input type="radio" name="address" ${addr.isDefault ? "checked" : ""}>
                    <span>${addr.addressName || "배송지"}</span> ${isDefaultTag}
                  </label>
                  <p>${addr.userName} / ${addr.userPhone}</p>
                  <p>[${addr.postCode}] ${addr.roadAddress} ${addr.detailAddress}</p>
                  <button class="deleteAddress">삭제</button>
                </div>
            `);
        });

        updateDeliveryInfo();
    });
}

// ========== 배송지 추가 (회원 전용) ==========
$("#saveAddress").on("click", function (event) {
    event.preventDefault();

    const payload = {
        addressName: $("#addressName").val(),
        userName: $("#recipient").val(),
        userPhone: $("#phone").val(),
        postCode: $("#zipcode").val(),
        roadAddress: $("#address").val(),
        detailAddress: $("#addressDetail").val(),
        isDefault: 0
    };

    $.ajax({
        url: contextPath + "/address/add",
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

    $.post(contextPath + "/address/delete", { addressId }, function (res) {
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

// ========== 모달 열기/닫기 ==========
document.addEventListener("DOMContentLoaded", function () {
    const firstModal = document.getElementById("firstModal");
    const secondModal = document.getElementById("secondModal");
    const cartInfoBtn = document.getElementById("cartInfoBtn");
    const closeFirst = document.getElementById("closeFirstModal");
    const closeSecond = document.getElementById("closeSecondModal");

    firstModal.style.display = "none";
    secondModal.style.display = "none";

    // 배송지 목록 모달 열기
    cartInfoBtn.addEventListener("click", function () {
        firstModal.style.display = "flex";
        loadAddressList();
    });

    closeFirst.addEventListener("click", function () {
        firstModal.style.display = "none";
    });

    // 배송지 추가 모달 열기
    document.getElementById("addAddressBtn").addEventListener("click", function () {
        secondModal.style.display = "flex";
        $("#addressForm").show();
    });

    closeSecond.addEventListener("click", function () {
        secondModal.style.display = "none";
        $("#addressForm").hide();
    });
});
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
            console.log("[디버그] 동기화 성공 → DB 기준으로 덮어쓰기");

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
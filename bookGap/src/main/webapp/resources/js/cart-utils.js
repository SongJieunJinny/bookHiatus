// cart-utils.js


function updateGlobalCartCount() {
    const cartCountElement = document.getElementById("cart-count");
    if (!cartCountElement) return;

    if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
        $.get(contextPath + "/product/getCartByUser.do", function (data) {
            if (Array.isArray(data)) {
                cartCountElement.textContent = data.length;
                cartCountElement.style.visibility = data.length > 0 ? "visible" : "hidden";
            }
        });
    } else {
        const raw = localStorage.getItem("cartItems");
        let cartItems = [];
        try {
            const parsed = JSON.parse(raw);
            cartItems = Array.isArray(parsed) ? parsed : Object.values(parsed).filter(i => typeof i === "object");
        } catch (e) {
            cartItems = [];
        }
        cartCountElement.textContent = cartItems.length;
        cartCountElement.style.visibility = cartItems.length > 0 ? "visible" : "hidden";
    }
}
document.addEventListener("DOMContentLoaded", function () {
$("#header").load(contextPath + "/include/header", function () {
  updateCartCount();
  initHeaderEvents();
});

function initHeaderEvents() {
  const loginModal = document.getElementById("loginModal");
  const menuLogin = document.getElementById("menuLogin");
  const closeLoginModal = document.getElementById("closeLoginModal");

  if (!loginModal || !menuLogin || !closeLoginModal) {
    console.error("모달 또는 버튼 요소를 찾을 수 없음!");
    return;
  }

  // 🔥 이벤트 중복 등록 방지: 기존 이벤트 제거 후 추가
  menuLogin.removeEventListener("click", openLoginModal);
  menuLogin.addEventListener("click", openLoginModal);

  closeLoginModal.removeEventListener("click", closeLoginModalFunc);
  closeLoginModal.addEventListener("click", closeLoginModalFunc);

  document.removeEventListener("click", outsideClickClose);
  document.addEventListener("click", outsideClickClose);
  
  window.removeEventListener("keydown", escKeyClose);
  window.addEventListener("keydown", escKeyClose);
}

function openLoginModal(event) {
  event.stopPropagation();
  const loginModal = document.getElementById("loginModal");
  
  
  console.log("모달 표시됨!");
  loginModal.classList.add("show"); // ✨ 모달을 화면에 표시!
}

function closeLoginModalFunc() {
  const loginModal = document.getElementById("loginModal");
  
  if (!loginModal) return;

  loginModal.classList.remove("show"); // 🔥 모달 숨김
}

function outsideClickClose(event) {
  const loginModal = document.getElementById("loginModal");
  if (event.target === loginModal) {
    loginModal.classList.remove("show");
  }
}

function escKeyClose(event) {
  if (event.key === "Escape") {
    document.getElementById("loginModal").classList.remove("show");
  }
}

});
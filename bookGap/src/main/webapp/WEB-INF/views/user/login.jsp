<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/login.css"/>
</head>
<body>
 <!-- header part -->
  <div id="header"></div>
  <section>
    <div id="loginMenu">
      <div id="loginMenuDiv">
        <div id="login"><a href="/loginOk.do">LOGIN</a></div>
        &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="guest"><a href="./guest.html">GUEST</a></div>
      </div>
    </div>
    <div id="loginMain">
      <div id="loginMainDiv">
        <div id="loginInput">
          <input id="loginId" type="text" placeholder="아이디"><br>
          <input id="loginPw" type="password" placeholder="비밀번호">
        </div>
        <button id="loginBtn"><a href="./index.html">LOGIN</a></button>
      </div>
      <div id="joinNpw">
        <div id="findPw"><a href="./findPw.html">비밀번호 찾기</a></div>
        &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="join"><a href="join.do">회원가입</a></div>
      </div>
      <div id="kakaoLogin">카카오 간편 로그인</div>
      <div id="guestOrder"><a href="./guestOrder.html">비회원 주문하기</a></div>
    </div>
  </section>
  <!-- footer part -->
  <div id="footer"></div>
	<script>
	$(document).ready(function () {
		// 헤더 & 푸터 로드
		$("#header").load("<%= request.getContextPath() %>/include/header", function () {
			updateCartCount(); // 장바구니 개수 업데이트
			initHeaderEvents();		
		});
		$("#footer").load("<%= request.getContextPath() %>/include/footer");
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

    $("#loginBtn").click(function() {
      var loginId = $("#loginId").val();
      var loginPw = $("#loginPw").val();

      if (!loginId || !loginPw) {
        alert('아이디와 비밀번호를 다시 확인해주세요.');
        return;
      }

      // 아이디형식에 맞게 입력받기 (소문자, 특수문자, 숫자 허용)
      var idPattern = /^[a-z0-9_.+-]+$/;
      if (!idPattern.test(loginId)) {
        alert("아이디는 소문자 영어, 특수문자(_ . + -), 숫자만 사용할 수 있습니다");
        $('#loginId').val("");
        return false;
      }
      if (loginPw.length < 6) {
        alert("비밀번호를 다시 확인해주세요.");
        return;
      }
      // 비밀번호를 "예시비밀번호1234"로 설정하여 비교
      if (loginPw !== "1234") {
        alert("로그인에 실패하셨습니다.");
        window.location.href = "./login.html";
      } else {
        // 비밀번호가 올바른 경우 로그인 성공 처리
        window.location.href = "./index.html";
      }
    });
  </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>join</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/join.css"/>
</head>
<body>
  <!-- header part -->
  <div id="header"></div>
  <section>
  <form action="joinOk.do" method="post">
    <div id="navJoin">
      <div id="joinHead">
        <div id="join">회원가입</div>
      </div>
      <div id="joinMid">
        <div id="joinDiv">
          <div id="userId">
            <span id="title">ID * </span>
            <input id="userIdInput" name="USER_ID" type="text">
          </div>
          <div id="userEmail">
            <span id="title">E-MAIL * </span>
            <input id="userEmailInput" name="USER_EMAIL" type="email">
          </div>
          <div id="userName">
            <span id="title">NAME * </span>
            <input id="userNameInput" name="USER_NAME" type="text" placeholder="한글이름만 입력">
          </div>
          <div id="userPw">
            <span id="title">PW * </span>
            <input id="userPwInput" name="USER_PW" type="password" placeholder="최소6자 이상 입력">
          </div>
          <div id="userPwCheck">
            <span id="title">PW CHECK * </span>
            <input id="userPwCheckInput" name="USER_PW_CHECK" type="password">
          </div>
          <div id="userPhone">
            <span id="title">PHONE * </span>
            <input id="userPhoneInput" name="USER_PHONE" type="tel" placeholder="숫자만 입력">
          </div>
          <div id="userAddressCode">
            <span id="titlePost">POST NO</span>
            <div id="userAddressCodeDiv">
              <input id="userAddressCodeInput" name="USER_ADDRESS_CODE" type="text">
              <input id="userAddressCodeButton" name="USER_ADDRESS_BUTTON" type="button" value="검색">
            </div>
          </div>
          <div id="userAddress">
            <div id="userAddressDiv1">
              <span id="titleAddress">ADDRESS</span>
              <input id="userAddress1Input" name="USER_ADDRESS_1" type="text">
            </div>
            <div id="userAddressDiv2">
              <input id="userAddress2Input" name="USER_ADDRESS_2" type="text">
            </div>
          </div>
        </div>
      </div>
      <div id="joinEnd">
        <div id="btnDiv">
          <button id="JoinBtn">회원가입</button>&nbsp;&nbsp;&nbsp;
          <button id="JoinCancelBtn">취소</button>
        </div>
      </div>
    </div>
    </form>
  </section>
  <!-- footer part -->
  <div id="footer"></div>
    <!-- 카카오 주소 검색 API 추가 -->
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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

      // 카카오 주소 검색 API
      $("#userAddressCodeButton").click(function () {
        new daum.Postcode({
          oncomplete: function (data) {
          // 선택한 주소 정보를 입력 필드에 넣기
            $("#userAddressCodeInput").val(data.zonecode); // 우편번호
            $("#userAddress1Input").val(data.address); // 기본 주소
            $("#userAddress2Input").focus(); // 상세주소 입력란에 포커스 이동
          }
        }).open();
      });

      $('#JoinBtn').click(function() {
        var userId = $('#userIdInput').val().trim();
        var userEmail = $('#userEmailInput').val().trim();
        var userName = $('#userNameInput').val().trim();
        var userPw = $('#userPwInput').val().trim();
        var userPwCheck = $('#userPwCheckInput').val().trim();
        var userPhone = $('#userPhoneInput').val().trim();

        if (!userId || !userEmail || !userName || !userPw || !userPwCheck || !userPhone) {
          alert('모든 필수 항목을 입력해 주세요.');
          return;
        }

        // 아이디형식에 맞게 입력받기 (소문자, 특수문자, 숫자 허용)
        var idPattern = /^[a-z0-9_.+-]+$/;
        if (!idPattern.test(userId)) {
          alert("아이디는 소문자 영어, 특수문자(_ . + -), 숫자만 사용할 수 있습니다");
          $('#userIdInput').val("");
          return false;
        }

        // 이메일 형식 검사 (영문 대소문자, 숫자, . + - @ 영문 대소문자 . 영문 대소문자)
        var emailPattern = /^[a-z0-9_.+-]+@[a-zA-Z]+\.[a-zA-Z]+$/;
        if (!emailPattern.test(userEmail)) {
            alert("유효한 이메일 주소를 입력하세요");
            $('#userEmailInput').val("");
            return false;
        }

        // 이름에 한글만 입력받기
        var namePattern = /^[가-힣]+$/;
        if( !namePattern.test(userName) ){
          alert("한글만 입력해주세요");
          $('#userNameInput').val("");
          return false;
        }
        if (userPw.length < 6) {
          alert("비밀번호는 최소 6자 이상이어야 합니다");
          return;
        }
        if (userPw !== userPwCheck) {
          alert('비밀번호가 일치하지 않습니다.');
          return;
        }

        // 한국의 전화번호 11자리 입력 (예: 01012345678)
        var telPattern = /^\d{11}$/;
        if (!telPattern.test(userPhone)) {
            alert("유효한 전화번호를 입력해주세요. 예) 01012345678");
            return;
        }
        alert('회원가입이 완료되었습니다!');
        window.location.href = "./index.html";
      });

      $('#JoinCancelBtn').click(function() {
        if (confirm('정말 회원가입을 포기하시겠습니까?')) {
          window.location.href = 'index.html';
        }
      });
	</script>
</body>
</html>
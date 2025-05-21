<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>mypageInfo</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<!-- 카카오 주소 검색 API 추가 -->
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/mypage.css"/>
</head>
<body>
  <!-- header part -->
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<form action="${pageContext.request.contextPath}/user/mypageInfo.do" method="post">
	    <div id="navMyInfo">
	      <div id="myInfoHead">
	        <div id="myInfoDiv">
	          <div id="myInfo"><a href="<%= request.getContextPath() %>/user/mypage">My Info</a></div>
	          &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
	          <div id="orderDetails"><a href="./orderDetails.html">Order Details</a></div>
	        </div>
	      </div>
	      <div id="myInfoMid">
	        <div id="myInfoInput">
	          <div id="userName">
	            <span id="title">NAME</span>
	            <input type="hidden" name="userId" value="${user.userId}" />
	            <input id="userNameInput" name="userName" value="${user.userName}" type="text">
	          </div>
	          <div id="userPhone">
	            <span id="title">PHONE</span>
	            <input id="userPhoneInput" name="userPhone" value="${user.userPhone}" type="tel">
	          </div>
	          <div id="userEmail">
	            <span id="title">E-MAIL</span>
	            <input id="userEmailInput" name="userEmail" value="${user.userEmail}" type="email">
	          </div>
	          <div id="userAddressCode">
	            <span id="titleAddressCode">POST NO</span>
	            <div id="userAddressCodeDiv">
	              <input id="userAddressCodeInput" name="postCode" value="${user.postCode}" type="text">
	              <button id="userAddressCodeBtn" type="button">검색</button>
	            </div>
	          </div>
	          <div id="userAddress">
	            <div id="userAddressDiv1">
	              <span id="titleAddress">ADDRESS</span>
	              <input id="userAddress1Input" name="roadAddress" value="${user.roadAddress}" type="text">
	            </div>
	            <div id="userAddressDiv2">
	              <input id="userAddress2Input" name="detailAddress" value="${user.detailAddress}" type="text">
	            </div>
	          </div>
	        </div>
	        <div id="changePw">
	          <input id="changePwBtn" type="submit" value="Change PW" />
	          <!-- 에러 메시지 출력 -->
					  <c:if test="${not empty error}">
					    <script>
					        alert("${error}");
					    </script>
						</c:if>
	        </div>
	      </div>
	      <div id="myInfoEnd">
	        <div id="myInfoBtnDiv">
	          <button id="myInfoBtn" type="submit" >변경사항 저장</button>&nbsp;&nbsp;&nbsp;
	          <button id="myInfoCancelBtn" type="submit" >회원탈퇴</button>
	        </div>
	      </div>
	    </div>
  	</form>
  </section>
  <!-- footer part -->
  <div id="footer">
	  <div id="changePwModal" class="modal">
	    <div class="modal-content">
	      <span class="close">&times;</span>
	      <h2>Change PW</h2>
	      <div id="modalEmail">
	        <div id="changePwModalEmail">
	          <div id="emailDiv">E MAIL</div>
	          <input id="emailInput" type="email">
	          <button id="emailBtn">발송</button>
	        </div>
	        <div id="changePwModalEmailCheck">
	          <div id="emailCheckDiv">CHECK</div>
	          <input id="code" name="code" type="text">
	          <button id="emailCheckBtn">인증</button>
	        </div>
	        <div id="msg"></div>
	        <div id="changePwModalNewPw">
	          <div id="newPwDiv">NEW PW</div>
	          <input id="newPwInput" type="password">
	        </div>
	        <div id="changePwModalNewPwCheck">
	          <div id="newPwCheckDiv">PW CHECK</div>
	          <input id="newPwCheckInput" type="password">
	        </div>
	      </div>
	      <button id="changePasswordBtn" disabled>변경</button>
	    </div>
	  </div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
<script>
  $(document).ready(function() {
	  console.log("DOM ready!"); // 페이지가 정상적으로 로드되었는지 확인
		updateCartCount(); // 장바구니 개수 업데이트

		$(document).on("click", "#userAddressCodeBtn", function() {
		  console.log("버튼 클릭됨!"); // 콘솔 확인용
		  new daum.Postcode({
		    oncomplete: function(data) {
		      console.log("주소 검색 완료!"); // 우편번호 검색 결과 확인용
		      $("#userAddressCodeInput").val(data.zonecode);
		      $("#userAddress1Input").val(data.address);
		      $("#userAddress2Input").focus();
		    }
		  }).open();
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

    $('#myInfoBtn').click(function() {
      var userName = $('#userNameInput').val().trim();
      var userPhone = $('#userPhoneInput').val().trim();
      var userEmail = $('#userEmailInput').val().trim();
      var userPost = $('#userAddressCodeInput').val().trim();
      var userAddress1 = $('#userAddress1Input').val().trim();
      var userAddress2 = $('#userAddress2Input').val().trim();

	    if (!userName || !userPhone || !userEmail || !userPost || !userAddress1 || !userAddress2) {
	      alert('모든 항목을 입력해 주세요.');
	      return;
	    }
	    // 이름에 한글만 입력받기
	    var namePattern = /^[가-힣]+$/;
	    if( !namePattern.test(userName) ){
	      alert("한글만 입력해주세요");
	      $('#userNameInput').val("");
	      return false;
	    }

      // 한국의 전화번호 11자리 입력 (예: 01012345678)
      var telPattern = /^\d{11}$/;
      if (!telPattern.test(userPhone)) {
          alert("유효한 전화번호를 입력해주세요. 예) 01012345678");
          return;
      }

      // 이메일 형식 검사 (영문 대소문자, 숫자, . + - @ 영문 대소문자 . 영문 대소문자)
      var emailPattern = /^[a-z0-9_.+-]+@[a-zA-Z]+\.[a-zA-Z]+$/;
      if (!emailPattern.test(userEmail)) {
          alert("유효한 이메일 주소를 입력하세요");
          $('#userEmailInput').val("");
          return false;
      } 

      // 우편번호 형식에 맞게 입력받기 (숫자만 허용)
      var postPattern = /^[0-9]+$/;
      if (!postPattern.test(userPost)) {
        alert("우편번호는 숫자만 사용할 수 있습니다");
        $('#userAddressCodeInput').val("");
        return false;
      }
      
      // 우편번호 5자리 입력 (예: 12345)
      var postPattern = /^\d{5}$/;
      if (!postPattern.test(userPost)) {
          alert("우편번호는 5자로 이뤄져있습니다.. 예) 12345");
          return;
      }
              
      alert('정보수정이 완료되었습니다!');
      window.location.href = "./myInfo.html";
    });

    $('#myInfoCancelBtn').click(function() {
      if (confirm('정말 탈퇴하시겠습니까?')) {
        window.location.href = 'deleteMembership.html';
      }
    });
    
    let verificationCode = "";

    $('#emailBtn').click(function() {
      verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
      alert("인증번호가 발송되었습니다: " + verificationCode);
    });
    
    $('#emailCheckBtn').click(function() {
      if ($('#code').val() === verificationCode) {
        $('#msg').text('인증 완료').css('color', 'green');
        $('#changePasswordBtn').prop('disabled', false);
      } else {
        $('#msg').text('인증 실패, 다시 확인하세요.').css('color', 'red');
      }
    });
    
    $('#changePasswordBtn').click(function() {
      let newPassword = $('#newPwInput').val().trim();
      let newPasswordCheck = $('#newPwCheckInput').val().trim();
      
      if (!newPassword || !newPasswordCheck) {
        alert('비밀번호를 입력해주세요.');
        return;
      }
      if (newPassword !== newPasswordCheck) {
        alert('비밀번호가 일치하지 않습니다. 다시 확인해주세요.');
        return;
      }
      if (newPassword.length < 8) {
        alert('비밀번호는 최소 8자리 이상이어야 합니다.');
        return;
      }
      alert('비밀번호 변경이 완료되었습니다!');
      $('#changePwModal').hide();
    });
    
    $('#changePwBtn').click(() => $('#changePwModal').show());
    $('.close').click(() => $('#changePwModal').hide());
    $(window).click(event => { if (event.target.id === 'changePwModal') $('#changePwModal').hide(); });
  });   
</script>
</html>
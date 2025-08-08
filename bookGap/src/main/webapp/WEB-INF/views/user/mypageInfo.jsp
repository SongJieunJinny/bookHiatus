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
	<script>
	function openPwChangeModal(){
		$("#changePwModal").fadeIn();
		// 모달 창 보이게 하기
		$("#modal").fadeIn(); 
	}
	function closePwChangeModal() {
  	$("#changePwModal").fadeOut(); // 모달 숨기기
	}
	</script>
	<script>
	let code = "";
	function sendMail(){	     	 
		var userEmail = $('#emailInput').val();
		if(userEmail == ''){
		console.log("userEmail:"+userEmail);
			alert("이메일을 입력해주세요.");
			return false;
		}
		
		$.ajax({
			type : "POST",
			url : '<%= request.getContextPath() %>/user/mypageInfo/sendMail.do',
			data : {userEmail : userEmail},
			success : function(data){console.log("userEmail:"+userEmail);
															 alert("인증번호가 발송되었습니다.");
															 code = data; /*인증번호*/},
			error: function(data){
				alert("메일 발송에 실패했습니다.");
			}
		}); 
	}
			
	function codeCheck() {
		const checkNum = $('#code').val(); 
		const $resultMsg = $('#msg');
			
		if(checkNum === code){
			$resultMsg.html('인증번호가 일치합니다.');
			$resultMsg.css('color','green');
			$('#emailInput').attr('readonly',true);
		}else{
			$resultMsg.html('인증번호가 불일치 합니다. 다시 확인해주세요!.');
			$resultMsg.css('color','red');
		}
	}
	</script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/mypage.css"/>
</head>
<body>
<sec:authorize access="isAuthenticated()">
  <script>
    const isLoggedIn = true;
  </script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
  <!-- header part -->
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<form action="${pageContext.request.contextPath}/user/mypageInfo.do" method="post">
	    <div id="navMyInfo">
	      <div id="myInfoHead">
	        <div id="myInfoDiv">
	          <div id="myInfo"><a href="<%=request.getContextPath()%>/user/mypageInfo.do">My Info</a></div>
	          &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
	          <div id="orderDetails"><a href="<%=request.getContextPath()%>/order/orderDetails.do">Order Details</a></div>
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
	            <span id="titleAddress">ADDRESS</span>
	          <div id="userAddressDiv">
	            <input id="userAddress1Input" name="roadAddress" value="${user.roadAddress}" type="text"><p style="margin:1%;"></p>
	            <input id="userAddress2Input" name="detailAddress" value="${user.detailAddress}" type="text">
	          </div>
	          </div>
	        </div>
	        <sec:authorize access="hasRole('ROLE_USER')">
	        <div id="changePw"> 
	          <button id="changePwBtn" type="button" onclick="openPwChangeModal();">Change PW</button>
	          <!-- 에러 메시지 출력 -->
					  <c:if test="${not empty error || not empty message}">
						  <script>
						    <c:if test="${not empty error}">
						      alert("<c:out value='${error}'/>");
						    </c:if>
						    <c:if test="${not empty message}">
						      alert("<c:out value='${message}'/>");
						    </c:if>
						  </script>
						</c:if>
	        </div>
	        </sec:authorize>
	      </div>
	      <div id="myInfoEnd">
	        <div id="myInfoBtnDiv">
	          <button id="myInfoBtn" type="submit" >변경사항 저장</button>&nbsp;&nbsp;&nbsp;
	          <button id="myInfoCancelBtn" type="button" onclick="deleteMembership();">회원탈퇴</button>
	        </div>
	      </div>
	    </div>
  	</form>
  </section>
  <!-- footer part -->
  <div id="footer">
	  <div id="changePwModal" class="modal">
	    <div class="modal-content">
	      <span class="close" onclick="closePwChangeModal();">&times;</span>
	      <h2>Change PW</h2>
	      <div id="modalEmail">
	      	<input type="hidden" name="userId" id="userIdInput" value="${user.userId}">
	        <div id="changePwModalEmail">
	          <div id="emailDiv">E MAIL</div>
	          <input id="emailInput" type="email" name="userEmail">
	          <button id="emailBtn" type="button" onclick="sendMail();">발송</button>
	        </div>
	        <div id="changePwModalEmailCheck">
	          <div id="emailCheckDiv">CHECK</div>
	          <input id="code" type="text" name="code" placeholder="인증코드 확인" maxlength="6">
	          <button id="emailCheckBtn" type="button" onclick="codeCheck();">인증</button>
	        </div>
	        <div id="msg"></div>
	        <div id="changePwModalNewPw">
	          <div id="newPwDiv">NEW PW</div>
	          <input id="newPwInput" type="password" name="userPw">
	        </div>
	        <div id="changePwModalNewPwCheck">
	          <div id="newPwCheckDiv">PW CHECK</div>
	          <input id="newPwCheckInput" type="password" name="userPwCheck">
	        </div>
	      </div>
	      <button id="changePasswordBtn" type="button" onclick="pwChange();">변경</button>
	    </div>
	  </div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	<script>
  $(document).ready(function() {
	  console.log("DOM ready!"); // 페이지가 정상적으로 로드되었는지 확인
		updateCartCount(); // 장바구니 개수 업데이트
		initHeaderEvents();
		

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
      window.location.href = "<%=request.getContextPath()%>/user/mypageInfo.do";
    });

    $('#myInfoCancelBtn').click(function() {
      if (confirm('정말 탈퇴하시겠습니까?')) {
    	  window.location.href = '<%=request.getContextPath()%>/deleteMembership.do';
      }
    });
  });   
	</script>
	<script>
	function pwChange(){
	  if($("#newPwInput").val() == "") {
	    alert("비밀번호를 입력해주세요.");
	    $("#newPwInput").focus();
	    return false;
	  }

	  if($("#newPwCheckInput").val() == "") {
	    alert("새비밀번호를 입력해주세요.");
	    $("#newPwCheckInput").focus();
	    return false;
	  }

	  if($("#newPwCheckInput").val() != $("#newPwInput").val()) {
	    alert("비밀번호가 일치하지 않습니다");
	    $("#newPwCheckInput").focus();
	    return false;
	  }

	  // 여기까지 통과했으면 AJAX 실행
	  $.ajax({
	    url : "<%= request.getContextPath() %>/user/mypageInfo/pwChange.do",
	    type : "post",
	    data : {userId: $("#userIdInput").val(),  // 필요시 제거 가능 (Controller에서는 Principal 사용하므로)
	      			userEmail: $("#emailInput").val(),
	      			userPw: $("#newPwInput").val() },
	    success : function(result) {result = result.trim();
						      switch(result) {case "success": alert("비밀번호 변경에 성공했습니다.");
						      								closePwChangeModal(); // 원하는 다음 동작
						          						break;
						        							case "error": alert("비밀번호 재설정에 실패하셨습니다.");
						        							break;
						         							default: alert("서버와의 연결에 실패했습니다. 나중에 다시 시도해 주세요.");
						         							break;}
	    					 },
	    error : function() {alert("서버 통신 중 오류가 발생했습니다.");}
	  });
	}
  </script>
</body>
</html>
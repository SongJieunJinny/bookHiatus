<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>findPw</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user/findPw.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <div id="findPwNav">
    <div id="findPwHead">
      <div id="findPwHeadDiv">
        <div id="findPw">비밀번호 변경</div>
      </div>
    </div>
    <div id="findPwMid">
      <div id="findPwMidDiv">
        <div id="findPwInput">
          <input id="findPwId" type="text" placeholder="아이디"><br>
          <input id="findPwEmail" type="email" placeholder="이메일">
        </div>
        <button id="findPwBtn">이메일보내기</button>
      </div>
    </div>
    <div id="findPwEnd">
      <div id="findPwInfoDiv">
        <div id="findPwInfo1">※ 회원가입시 기재한 이메일주소를 입력해주세요.</div>
      </div>
    </div>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
$(document).ready(function() {
  updateCartCount();
  initHeaderEvents();

  $("#findPwBtn").click(function() {
    const userId = $("#findPwId").val().trim();
    const userEmail = $("#findPwEmail").val().trim();

    if (!userId || !userEmail) {
      alert("아이디와 이메일을 모두 입력해주세요.");
      return;
    }

    $("#sendCodeBtn").text("발송 중...").prop("disabled", true);

    $.ajax({ url: "<%=request.getContextPath()%>/findPw/sendVerificationCode.do",
			      type: "POST",
			      data: { userId: userId,
			        			userEmail: userEmail },
			      success: function(response) {
							        if (response.success) {
							          alert("인증번호가 이메일로 발송되었습니다.");
							          $("#step1").hide();
							          $("#step2").show(); // 2단계 UI 보여주기
							        } else {
							          alert(response.message || "정보가 일치하지 않거나 메일 전송에 실패했습니다.");
							        }
			              },
			      error: function() {
			        			alert("서버와 통신 중 오류가 발생했습니다.");
			             },
			      complete: function() {
			        					$("#sendCodeBtn").text("인증메일 발송").prop("disabled", false);
			                }
    });
  });

  // ---비밀번호 변경 버튼 클릭 ---
  $("#resetPwBtn").click(function() {
    const code = $("#verificationCode").val().trim();
    const newPassword = $("#newPassword").val().trim();
    const confirmPassword = $("#confirmPassword").val().trim();

    if (!code || !newPassword || !confirmPassword) {
        alert("모든 항목을 입력해주세요.");
        return;
    }

    if (newPassword.length < 6) {
        $("#password-feedback").text("비밀번호는 6자 이상이어야 합니다.");
        return;
    }
    
    if (newPassword !== confirmPassword) {
      $("#password-feedback").text("비밀번호가 일치하지 않습니다.");
      return;
    }
    $("#password-feedback").text(""); // 오류 메시지 초기화
    
    $("#resetPwBtn").text("처리 중...").prop("disabled", true);
    
    $.ajax({ url: "<%=request.getContextPath()%>/findPw/resetPassword.do",
				      type: "POST",
				      data: { code: code,
				        			newPassword: newPassword },
				      success: function(response) {
								        if(response.success){
								          alert("비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.");
								          window.location.href = "<%=request.getContextPath()%>/login.do";
								        } else {
								          alert(response.message || "인증번호가 틀렸거나 오류가 발생했습니다.");
								        }
				             },
				      error: function() {
				        			alert("서버와 통신 중 오류가 발생했습니다.");
				             },
				      complete: function() {
				        					$("#resetPwBtn").text("비밀번호 변경").prop("disabled", false);
				                }
    });
  });
});

function updateCartCount() {
	let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	let cartCount = cartItems.length;
	let cartCountElement = document.getElementById("cart-count");

	if(cartCountElement){
		cartCountElement.textContent = cartCount;
		cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	}
}
</script>
</body>
</html>
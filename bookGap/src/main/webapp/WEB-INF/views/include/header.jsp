<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<sec:authorize access="isAnonymous()"> 
<!-- 로그인 전 -->
<header>
	<div id="menuDiv">
	  <!-- 로고 -->
	  <div id="menuLogo">
			<img id="menuLogoImg" src="<%=request.getContextPath()%>/resources/img/icon/logo.png" alt="로고">
		</div>
		<!-- 메뉴 -->
		<div id="menu">
			<div id="menuBook" class="menuItem">BOOK
				<!-- BOOK카테고리 메뉴 -->
				<div id="bookCategory">
				  <a href="${pageContext.request.contextPath}/product/bookList.do">모든 책</a>
				  <c:forEach var="category" items="${bookCategories}">
				    <a href="${pageContext.request.contextPath}/product/bookList.do?category=${category}">
				      ${category}
				    </a>
			  	</c:forEach>
				</div>
			</div>
			
			<div id="menuAbout" class="menuItem"><!--0322상화 추가시작--><a href="<%=request.getContextPath()%>/about.do">ABOUT</a><!--0322상화 추가끝--></div>
			<div id="menuEvent" class="menuItem"><!--0221지은 추가시작--><a href="<%=request.getContextPath()%>/eventList.do">EVENT</a><!--0221지은 추가끝--></div>
			<div id="menuChoice" class="menuItem"><!--0322상화 추가시작--><a href="<%=request.getContextPath()%>/choice/choiceList.do">CHOICE</a><!--0322상화 추가끝--></div>
			<div id="menuCommunity" class="menuItem">COMMUNITY
				<!-- COMMUNITY카테고리 메뉴 -->
				<div id="communityCategory">
					<a href="<%= request.getContextPath() %>/noticeList.do">공지사항</a>
					<a href="<%= request.getContextPath() %>/qnaList.do?boardType=2">Q&A</a>
				</div>
			</div>
			
			<div id="menuSearch" class="menuItem">
			  <form id="searchForm" action="${pageContext.request.contextPath}/product/bookSearch.do" method="get">
			    <span id="searchSwitchBtn">
			      <span id="searchText">SEARCH</span>
			    </span>
			    <input type="text" id="searchInput" name="searchValue" placeholder="도서 검색" value="${searchKeyword}">
			    <span id="searchImgIcon">
			      <button type="submit" id="searchBtn" style="background:none; border:none; padding:0;">
			        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png" alt="검색">
			      </button>
			    </span>
			  </form>
			</div>
			<div id="menuLogin" class="menuItem">
			  <img id="loginImg" src="<%=request.getContextPath()%>/resources/img/icon/login.png">
			</div>
			<div id="menuCart" class="menuItem">
		      <a href="<%=request.getContextPath()%>/product/cart.do"><img id="cartImg" src="<%=request.getContextPath()%>/resources/img/icon/cart.png"></a>
		      <span id="cart-count">0</span>
			</div>
		</div>
	</div>
	<div id="menuHr"><hr></div>
</header>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
 <!-- 로그인 후 -->
<header>
	<div id="menuDiv">
	  <!-- 로고 -->
	  <div id="menuLogo">
			<img id="menuLogoImg" src="<%=request.getContextPath()%>/resources/img/icon/logo.png" alt="로고">
		</div>
		<!-- 메뉴 -->
		<div id="menu">
			<div id="menuBook" class="menuItem">BOOK
				<!-- BOOK카테고리 메뉴 -->
				<div id="bookCategory">
				   <a href="${pageContext.request.contextPath}/product/bookList.do">모든 책</a>
				  <c:forEach var="category" items="${bookCategories}">
				    <a href="${pageContext.request.contextPath}/product/bookList.do?category=${category}">
				      ${category}
				    </a>
			  	</c:forEach>
				</div>
			</div>
			
			<div id="menuAbout" class="menuItem"><!--0322상화 추가시작--><a href="<%=request.getContextPath()%>/about.do">ABOUT</a><!--0322상화 추가끝--></div>
			<div id="menuEvent" class="menuItem"><!--0221지은 추가시작--><a href="<%=request.getContextPath()%>/eventList.do">EVENT</a><!--0221지은 추가끝--></div>
			<div id="menuChoice" class="menuItem"><!--0322상화 추가시작--><a href="<%=request.getContextPath()%>/choice/choiceList.do">CHOICE</a><!--0322상화 추가끝--></div>
			<div id="menuCommunity" class="menuItem">COMMUNITY
				<!-- COMMUNITY카테고리 메뉴 -->
				<div id="communityCategory">
					<a href="<%= request.getContextPath() %>/noticeList.do">공지사항</a>
					<a href="<%= request.getContextPath() %>/qnaList.do?boardType=2">Q&A</a>
				</div>
			</div>
			
			<div id="menuSearch" class="menuItem">
			  <form id="searchForm" action="${pageContext.request.contextPath}/product/bookSearch.do" method="get">
			    <span id="searchSwitchBtn">
			      <span id="searchText">SEARCH</span>
			    </span>
			    <input type="text" id="searchInput" name="searchValue" placeholder="도서 검색" value="${searchKeyword}">
			    <span id="searchImgIcon">
			      <button type="submit" id="searchBtn" style="background:none; border:none; padding:0;">
			        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png" alt="검색">
			      </button>
			    </span>
			  </form>
			</div>
			<div id="menuLogout" class="menuItem">
			  <a href="#" id="kakaoLogoutBtn">
			    <img id="loginImg" src="<%=request.getContextPath()%>/resources/img/icon/logout.png">
			  </a>
			</div>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
			  <!-- 관리자일 경우: 설정 아이콘 -->
			  <div id="menuMypage" class="menuItem">
			    <a href="<%=request.getContextPath()%>/admin/adminIndex.do">
			      <img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/icon/setting.png" alt="설정">
			    </a>
			  </div>
			</sec:authorize>   
			<sec:authorize access="hasRole('ROLE_USER_KAKAO')">
			  <div id="menuMypage" class="menuItem">
			    <a href="<%=request.getContextPath()%>/user/mypageInfo.do">
			      <img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/icon/edit.png" alt="마이페이지">
			    </a>
			  </div>
			</sec:authorize>
			<!-- 일반 로그인 사용자 (ROLE_USER) -->
			<sec:authorize access="hasRole('ROLE_USER') and !hasRole('ROLE_USER_KAKAO')">
			  <div id="menuMypage" class="menuItem">
			    <a href="<%=request.getContextPath()%>/mypage.do">
			      <img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/icon/edit.png" alt="마이페이지">
			    </a>
			  </div>
			</sec:authorize>
			<div id="menuCart" class="menuItem">
		      <a href="<%=request.getContextPath()%>/product/cart.do"><img id="cartImg" src="<%=request.getContextPath()%>/resources/img/icon/cart.png"></a>
		      <span id="cart-count">0</span>
			</div>
		</div>
	</div>
	<div id="menuHr"><hr></div>
</header>
</sec:authorize>

<!-- 로그인 모달창 -->
<div id="loginModal">
 	<div id="loginModalDiv">
   	<span id="closeLoginModal">&times;</span>
    <div id="loginMenu">
      <div id="loginMenuDiv">
        <div id="login"  class="tab active">LOGIN</div>
        &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="guest" class="tab">GUEST</div>
      </div>
    </div>
    <div id="loginMain" class="tabContent">
      <div id="loginMainDiv">
      	<form id="loginForm" method="post" action="${pageContext.request.contextPath}/loginOk.do">
        	<div id="loginInput">
          	<input id="loginId" type="text" name="USER_ID" placeholder="아이디"><br>
          	<input id="loginPw" type="password" name="USER_PW" placeholder="비밀번호">
        	</div>
        	<button id="loginBtn" type="submit">LOGIN</button>
        </form>
      </div>
      <div id="joinNpw">
        <div id="findPw"><a href="<%=request.getContextPath()%>/findPw.do">비밀번호 찾기</a></div>
        &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="join"><a href="<%=request.getContextPath()%>/join.do">회원가입</a></div>
      </div>
      <div id="loginOption">
	      <div id="kakaoLogin">카카오 간편 로그인</div>
	      <div id="guestOrder">비회원 주문하기</div>
      </div>
    </div>
    <div id="guestMain" class="tabContent" style="display:none;">
 			<form id="guestForm" method="post" action="${pageContext.request.contextPath}/guestOrderInfo.do">
		 		<div id="guestMain">
		      <div id="guestMainDiv">
		        <div id="guestInput">
		          <input id="orderPassword" type="password" name="orderPassword" placeholder="주문 비밀번호"><br>
		          <input id="guestEmail" type="email" name="guestEmail" placeholder="주문 이메일">
		        </div>
		        <button id="guestBtn" type="submit">CHECK</button>
		      </div>
		    </div>
		    <div id="guestInfoDiv">
		      <div id="guestInfo1">※ 메일로 보내드린 주문번호를 정확히 기재해 주세요.</div>
		      <div id="guestInfo2">※ 비회원 주문내역, 결제 취소등 확인 가능합니다.</div>
		    </div>
    	</form>
 		</div>
 	</div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript">
const contextPath = '<%=request.getContextPath()%>';

function initHeaderEvents() {
  function performSearch() {
	  const searchInput = document.getElementById("searchInput");
	  const keyword = searchInput.value.trim();

	  if (!keyword) {
	    alert("검색어를 입력해주세요.");
	    searchInput.focus();
	    return;
	  }

	  // [중요!] 아래 URL을 컨트롤러의 RequestMapping 경로와 똑같이 맞춰줍니다.
	  const url = contextPath + "/product/bookSearch.do?searchValue=" + encodeURIComponent(keyword);
	  window.location.href = url;
	}
  
  const menuBook = document.getElementById("menuBook");
  const menuCommunity = document.getElementById("menuCommunity");
  const bookCategory = document.getElementById("bookCategory");
  const communityCategory = document.getElementById("communityCategory");
  const searchInput = document.getElementById("searchInput");
  const searchText = document.getElementById("searchText");
  const searchImgIcon = document.getElementById("searchImgIcon");
  const searchSwitchBtn = document.getElementById("searchSwitchBtn");

  // BOOK 메뉴 클릭 이벤트
  if (menuBook && bookCategory && menuCommunity && communityCategory) {
    menuBook.addEventListener("click", function (event) {
      event.stopPropagation();
      bookCategory.style.display = bookCategory.style.display === "block" ? "none" : "block";
      menuBook.classList.toggle("active");
      communityCategory.style.display = "none";
      menuCommunity.classList.remove("active");
    });

    menuCommunity.addEventListener("click", function (event) {
      event.stopPropagation();
      communityCategory.style.display = communityCategory.style.display === "block" ? "none" : "block";
      menuCommunity.classList.toggle("active");
      bookCategory.style.display = "none";
      menuBook.classList.remove("active");
    });
  }

  // 검색 버튼 클릭 이벤트
  if(searchSwitchBtn && searchInput && searchText && searchImgIcon){
    searchSwitchBtn.addEventListener("click", function(event){
      event.stopPropagation();
      if(searchInput.style.display === "none" || searchInput.style.display === ""){
        searchText.style.display = "none";
        searchImgIcon.style.display = "inline";
        searchInput.style.display = "inline-block";
        searchInput.focus();
      }else{
        searchText.style.display = "inline";
        searchImgIcon.style.display = "none";
        searchInput.style.display = "none";
      }
    });
    
    searchImgIcon.addEventListener("click", performSearch);
    
    searchInput.addEventListener("keydown", function(event){
      if(event.key === 'Enter'){
        event.preventDefault(); // 폼의 기본 제출 동작 방지
        performSearch();
      }
    });
  }

  // 화면 클릭 시 메뉴와 검색창 닫기
  document.addEventListener("click", function (event) {
    if (bookCategory && menuBook &&
        !bookCategory.contains(event.target) && !menuBook.contains(event.target)) {
      bookCategory.style.display = "none";
      menuBook.classList.remove("active");
    }
    if (communityCategory && menuCommunity &&
        !communityCategory.contains(event.target) && !menuCommunity.contains(event.target)) {
      communityCategory.style.display = "none";
      menuCommunity.classList.remove("active");
    }
    if (searchInput && menuSearch &&
        !searchInput.contains(event.target) && !menuSearch.contains(event.target)) {
      searchText.style.display = "inline";
      searchImgIcon.style.display = "none";
      searchInput.style.display = "none";
    }
  });

  // 로그인 모달 열기
  const menuLogin = document.getElementById("menuLogin");
  const loginModal = document.getElementById("loginModal");
  if (menuLogin && loginModal) {
    menuLogin.onclick = function () {
      loginModal.classList.add("show");
    };
  }

  // 모달 닫기
  const closeLoginModal = document.getElementById("closeLoginModal");
  if (loginModal && closeLoginModal) {
    window.addEventListener("click", function (event) {
      if (event.target.id === "loginModal" || event.target.id === "closeLoginModal") {
        loginModal.classList.remove("show");
      }
    });
  }

  // 모달 탭 전환
  const loginTab = document.getElementById("login");
  const guestTab = document.getElementById("guest");
  const loginMain = document.getElementById("loginMain");
  const guestMain = document.getElementById("guestMain");

  if (loginTab && guestTab && loginMain && guestMain) {
    loginTab.addEventListener("click", function () {
      loginMain.style.display = "block";
      guestMain.style.display = "none";
      loginTab.classList.add("active");
      guestTab.classList.remove("active");
    });

    guestTab.addEventListener("click", function () {
      loginMain.style.display = "none";
      guestMain.style.display = "block";
      guestTab.classList.add("active");
      loginTab.classList.remove("active");
    });
  }

  // 로그인 입력값 검증
  const loginBtn = document.getElementById("loginBtn");
  if (loginBtn) {
    loginBtn.addEventListener("click", function (event) {
      const loginId = document.getElementById("loginId")?.value;
      const loginPw = document.getElementById("loginPw")?.value;

      if (!loginId || !loginPw) {
        alert("아이디와 비밀번호를 입력해주세요.");
        event.preventDefault();
        return;
      }

      const idPattern = /^[a-z0-9_.+-]+$/;
      if (!idPattern.test(loginId)) {
        alert("아이디는 소문자 영어, 특수문자(_ . + -), 숫자만 사용할 수 있습니다");
        event.preventDefault();
        return;
      }

      if (loginPw.length < 6) {
        alert("비밀번호는 6자 이상이어야 합니다.");
        event.preventDefault();
        return;
      }
      
      const currentUrl = window.location.pathname + window.location.search;
      $.post(contextPath + "/auth/saveRedirect.do", { redirectUrl: currentUrl })
        .fail(function (xhr, status, error) {
          console.error("redirect 저장 실패:", status, error);
        });
      
    });
  }
}
  
document.getElementById("guestOrder").addEventListener("click", function () {
	  const isbnInput = document.getElementById("isbn");
	  const quantityInput = document.querySelector(".num");

	  // ① 상품 상세 페이지인 경우: isbn input 존재
	  if (isbnInput) {
	    const isbn = isbnInput.value;
	    const quantity = quantityInput?.value || 1;

	    if (!isbn) {
	      alert("상품 정보가 없습니다. 비회원 주문은 상품 상세 페이지와 장바구니에서만 가능합니다.");
	      return;
	    }

	    const url = contextPath + "/guest/guestOrder.do?isbn=" + encodeURIComponent(isbn)
	                + "&quantity=" + encodeURIComponent(quantity);
	    window.location.href = url;
	    return;
	  }

	  // ② 장바구니 페이지인 경우: 체크된 상품 목록 처리
	  const selectedItems = document.querySelectorAll(".cartItemCheckbox:checked");

	  if (selectedItems.length === 0) {
	    alert("주문할 상품을 선택해주세요.");
	    return;
	  }

	  const url = new URL(contextPath + "/guest/guestOrder.do", window.location.origin);

	  selectedItems.forEach(item => {
	    const cartItem = item.closest(".cartItem");
	    const isbn = cartItem.getAttribute("data-isbn");
	    const quantity = cartItem.querySelector(".num")?.value || 1;
	    console.log("추출된 ISBN:", isbn, "수량:", quantity);
	    
	    if (isbn) {
	      url.searchParams.append("isbns", isbn);
	      url.searchParams.append("quantities", quantity);
	    }
	  });
		
	  window.location.href = url.toString();
	  console.log("비회원 주문 이동 URL:", url.toString());
	});
</script>
<script type="text/javascript">
$('#menuLogoImg').on('click', function() {
    window.location.href = '<%=request.getContextPath()%>';
});
</script>
<script type="text/javascript">
Kakao.init('56c7bb3d435c0c4f0d2b67bfa7d4407e');

document.getElementById("kakaoLogin").addEventListener("click", function () {
  Kakao.Auth.setAccessToken(null); 

  Kakao.Auth.login({
    scope: 'profile_nickname',
    throughTalk: false,
    persistAccessToken: false,
    success: function (authObj) {

      Kakao.API.request({
        url: '/v2/user/me',
        success: function (res) {

          const kakaoId = res.id;
          const nickname = res.kakao_account.profile.nickname;
          const accessToken = authObj.access_token;

          fetch('${pageContext.request.contextPath}/kakaoLoginCallback.do', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ kakaoId, nickname, accessToken })
          })
          .then(res => res.json())
          .then(result => {
            console.log("로그인  서버 응답:", result);
            if (result.status === 'success') {
              alert("로그인에 성공하셨습니다.");
              window.location.href = "<%=request.getContextPath()%>/";
            } else {
              alert("로그인에 실패하셨습니다.");
            }
          });
        },
        fail: function (error) {
          console.error("로그인 사용자 정보 요청 실패:", error);
          alert("사용자 정보 요청에  실패하셨습니다.");
        }
      });
    },
    fail: function (err) {
      console.error("로그인 카카오 로그인 실패:", err);
      alert("카카오 로그인에  실패하셨습니다.");
    }
  });
});

function kakaoLogout() {
  fetch('<%=request.getContextPath()%>/kakaoServerLogout.do', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }
  })
  .then(() => {
    Kakao.Auth.setAccessToken(null); // SDK 토큰 제거

    const clientId = '56c7bb3d435c0c4f0d2b67bfa7d4407e';
    const redirectUri = window.location.origin + '<%=request.getContextPath()%>/';

    window.location.href =
      'https://kauth.kakao.com/oauth/logout?client_id=' + clientId +
      '&logout_redirect_uri=' + encodeURIComponent(redirectUri);
  })
  .catch(err => {
    console.error("로그아웃 에러:", err);
    window.location.href = '<%=request.getContextPath()%>/';
  });
}

document.addEventListener("DOMContentLoaded", function () {
  const logoutBtn = document.getElementById("kakaoLogoutBtn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", function (e) {
      e.preventDefault();
      kakaoLogout(); 
    });
  }
});
function updateCartCount() {
	  const cartCountElement = document.getElementById("cart-count");
	  const cartCountTitle = document.getElementById("cartCountTitle");

	  if (!cartCountElement && !cartCountTitle) return;

	  if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
	    $.get(contextPath + "/product/getCartCount.do", function(count) {
	      console.log("서버에서 받은 장바구니 개수:", count);
	      const cartCount = parseInt(count, 10) || 0;

	      if (cartCountElement) {
	        cartCountElement.textContent = cartCount;
	        cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	      }

	      if (cartCountTitle) {
	        cartCountTitle.textContent = "장바구니(" + cartCount + ")";
	      }
	    }).fail(function(err) {
	      console.error("장바구니 개수 불러오기 실패", err);
	    });
	  } else {
	    let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	    if (!Array.isArray(cartItems)) {
	      cartItems = Object.values(cartItems).filter(item => typeof item === 'object');
	    }
	    const cartCount = cartItems.length;

	    if (cartCountElement) {
	      cartCountElement.textContent = cartCount;
	      cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	    }

	    if (cartCountTitle) {
	      cartCountTitle.textContent = "장바구니(" + cartCount + ")";
	    }
	  }
	}

</script>
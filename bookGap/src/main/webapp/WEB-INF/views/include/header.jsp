<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<sec:authorize access="isAnonymous()"> <!-- 로그인 전 -->
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
	      <span id="searchSwitchBtn">
	        <span id="searchText">SEARCH</span>
	      </span>
	      <input type="text" id="searchInput" placeholder="검색어 입력">
	      <span id="searchImgIcon">
	        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png">
	      </span>
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

<sec:authorize access="isAuthenticated()"> <!-- 로그인 후 -->
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
	      <span id="searchSwitchBtn">
	        <span id="searchText">SEARCH</span>
	      </span>
	      <input type="text" id="searchInput" placeholder="검색어 입력...">
	      <span id="searchImgIcon">
	        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png">
	      </span>
	    </div>
			<div id="menuLogout" class="menuItem">
			  <a href="#" id="kakaoLogoutBtn">
			    <img id="loginImg" src="<%=request.getContextPath()%>/resources/img/icon/logout.png">
			  </a>
			</div>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
			  <!-- 관리자일 경우: 설정 아이콘 -->
			  <div id="menuMypage" class="menuItem">
			    <a href="admin/adminIndex.do">
			      <img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/icon/setting.png" alt="설정">
			    </a>
			  </div>
			</sec:authorize> 
			
			<sec:authorize access="!hasRole('ROLE_ADMIN')">
			 <!-- 일반 사용자일 경우: 마이페이지 아이콘 -->
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
        <div id="findPw"><a href="./findPw.html">비밀번호 찾기</a></div>
        &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
        <div id="join"><a href="<%=request.getContextPath()%>/join.do">회원가입</a></div>
      </div>
      <div id="loginOption">
	      <div id="kakaoLogin">카카오 간편 로그인</div>
	      <div id="guestOrder"><a href="./guestOrder.html">비회원 주문하기</a></div>
      </div>
    </div>
    <div id="guestMain" class="tabContent" style="display:none;">
 			<form id="guestForm" method="post" action="${pageContext.request.contextPath}/guestOrder.do">
		 		<div id="guestMain">
		      <div id="guestMainDiv">
		        <div id="guestInput">
		          <input id="guestId" type="text" name="GUEST_ID" placeholder="주문번호"><br>
		          <input id="guestPw" type="password" name="GUEST_PW" placeholder="비밀번호">
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
  <script>
  function initHeaderEvents() {
	  const menuBook = document.getElementById("menuBook");
	  const menuCommunity = document.getElementById("menuCommunity");
	  const bookCategory = document.getElementById("bookCategory");
	  const communityCategory = document.getElementById("communityCategory");
	  const searchInput = document.getElementById("searchInput");
	  const searchText = document.getElementById("searchText");
	  const searchImgIcon = document.getElementById("searchImgIcon");
	  const searchSwitchBtn = document.getElementById("searchSwitchBtn");
	  const menuSearch = document.getElementById("menuSearch");

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
	  if (searchSwitchBtn && searchInput && searchText && searchImgIcon) {
	    searchSwitchBtn.addEventListener("click", function (event) {
	      event.stopPropagation();
	      if (searchInput.style.display === "none" || searchInput.style.display === "") {
	        searchText.style.display = "none";
	        searchImgIcon.style.display = "inline";
	        searchInput.style.display = "inline-block";
	        searchInput.focus();
	      } else {
	        searchText.style.display = "inline";
	        searchImgIcon.style.display = "none";
	        searchInput.style.display = "none";
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
	    });
	  }
	}

  </script>
  <script>
  $('#menuLogoImg').on('click', function() {
	    window.location.href = '<%=request.getContextPath()%>';
	});
  </script>
  <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
Kakao.init('56c7bb3d435c0c4f0d2b67bfa7d4407e');


// 카카오 로그인 버튼 클릭 이벤트
document.getElementById("kakaoLogin").addEventListener("click", function () {
  // 자동 로그인 방지: 남아있는 토큰 초기화
  if (Kakao.Auth.getAccessToken()) {
    Kakao.Auth.setAccessToken(null);
  }

  Kakao.Auth.login({
    scope: 'profile_nickname',
    success: function (authObj) {
      Kakao.API.request({
        url: '/v2/user/me',
        success: function (res) {
          const kakaoId = res.id;
          const nickname = res.kakao_account.profile.nickname;

          fetch('${pageContext.request.contextPath}/kakaoLoginCallback.do', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ kakaoId, nickname })
          })
          .then(res => res.json())
          .then(result => {
            if (result.status === 'success') {
              alert("로그인에 성공하셨습니다.");
              window.location.href = "<%=request.getContextPath()%>/";
            } else {
              alert("로그인에 실패하셨습니다.");
            }
          });
        },
        fail: function (error) {
          alert("사용자 정보 요청 실패");
        }
      });
    },
    fail: function (err) {
      alert("카카오 로그인 실패");
    }
  });
});

// 카카오 로그아웃 함수
function kakaoLogout() {
  const accessToken = Kakao.Auth.getAccessToken();
  if (accessToken) {
    // 서버로 토큰 전달해 카카오 서버 로그아웃 요청
    fetch('${pageContext.request.contextPath}/kakaoServerLogout.do', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ accessToken })
    })
    .then(res => res.json())
    .then(result => {
      console.log(result.message || result);
      // SDK 토큰 제거
      Kakao.Auth.setAccessToken(null);
      // Spring Security 로그아웃도 실행
      window.location.href = '${pageContext.request.contextPath}/logout.do';
    })
    .catch(err => {
      console.error("카카오 서버 로그아웃 실패:", err);
      // 실패해도 Spring Security 로그아웃은 진행
      window.location.href = '${pageContext.request.contextPath}/logout.do';
    });
  } else {
    // 토큰이 없으면 바로 Spring Security 로그아웃
    window.location.href = '${pageContext.request.contextPath}/logout.do';
  }
}

document.addEventListener("DOMContentLoaded", function () {
  const logoutBtn = document.getElementById("kakaoLogoutBtn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", function (e) {
      e.preventDefault();  // a 태그 기본 이동 막기
      kakaoLogout();
    });
  }
});
</script>

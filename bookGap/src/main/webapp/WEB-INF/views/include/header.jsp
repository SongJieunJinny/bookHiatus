<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<sec:authorize access="isAnonymous()"> <!-- 로그인 전 -->
<header>
	<div id="menu">
	  <!-- 메뉴1 -->
		<div id="menu1">
			<div id="menuBook" class="menuItem">BOOK</div>
			<div id="menuAbout" class="menuItem"><!--0322상화 추가시작--><a href="about.html">ABOUT</a><!--0322상화 추가끝--></div>
			<div id="menuEvent" class="menuItem"><!--0221지은 추가시작--><a href="eventList.html">EVENT</a><!--0221지은 추가끝--></div>
			<div id="menuChoice" class="menuItem"><!--0322상화 추가시작--><a href="choice.html">CHOICE</a><!--0322상화 추가끝--></div>
			<div id="menuCommunity" class="menuItem">COMMUNITY</div>
		</div>
	  <!-- 로고 -->
		<div id="menuLogo">
			<div> <a href="<%=request.getContextPath()%>"><img id="menuLogoImg" src="<%=request.getContextPath()%>/resources/img/icon/logo.png" alt="로고"></a></div>
		</div>
	  <!-- 메뉴2 -->
		<div id="menu2">
			<div id="menuSearch" class="menuItem">
	      <span id="searchSwichBtn">
	        <span id="searchText">SEARCH</span>
	      </span>
	      <input type="text" id="searchInput" placeholder="검색어 입력...">
	      <span id="searchImgIcon">
	        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png">
	      </span>
	    </div>
			<div id="menuLogin" class="menuItem">
			  <img id="loginImg" src="<%=request.getContextPath()%>/resources/img/icon/login.png">
			</div>
      <div id="menuMypage" class="menuItem">
        <a href="./mypage.html"><img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/icon/edit.png"></a>
      </div>
			<div id="menuCart" class="menuItem">
	      <a href="./cart.html"><img id="cartImg" src="<%=request.getContextPath()%>/resources/img/icon/cart.png"></a>
	      <span id="cart-count">0</span>
      </div>
		</div>
	</div>
	<!-- BOOK카테고리 메뉴 -->
	<div id="bookCategory">
	  <a href="./bookList.html">모든 책</a>
	  <a href="./bookList.html">인문학</a>
	  <a href="./bookList.html">철학</a>
	  <a href="./bookList.html">언어학</a>
	  <a href="./bookList.html">미학</a>
	  <a href="./bookList.html">종교학</a>
	  <a href="./bookList.html">윤리학</a>
	  <a href="./bookList.html">심리학</a>
	</div>
	<!-- COMMUNITY카테고리 메뉴 -->
	<div id="communityCategory">
		<a href="<%= request.getContextPath() %>/noticeList.do">공지사항</a>
		<a href="./qnaList.html">Q&A</a>
	</div>
	<div id="menuHr"><hr></div>
</header>
</sec:authorize>

<sec:authorize access="isAuthenticated()"> <!-- 로그인 후 -->
<header>
	<div id="menu">
	  <!-- 메뉴1 -->
		<div id="menu1">
			<div id="menuBook" class="menuItem">BOOK</div>
			<div id="menuAbout" class="menuItem"><!--0322상화 추가시작--><a href="about.html">ABOUT</a><!--0322상화 추가끝--></div>
			<div id="menuEvent" class="menuItem"><!--0221지은 추가시작--><a href="eventList.html">EVENT</a><!--0221지은 추가끝--></div>
			<div id="menuChoice" class="menuItem"><!--0322상화 추가시작--><a href="choice.html">CHOICE</a><!--0322상화 추가끝--></div>
			<div id="menuCommunity" class="menuItem">COMMUNITY</div>
		</div>
	  <!-- 로고 -->
		<div id="menuLogo">
			<div> <a href="<%=request.getContextPath()%>"><img id="menuLogoImg" src="<%=request.getContextPath()%>/resources/img/icon/logo.png" alt="로고"></a></div>
		</div>
	  <!-- 메뉴2 -->
		<div id="menu2">
			<div id="menuSearch" class="menuItem">
	      <span id="searchSwichBtn">
	        <span id="searchText">SEARCH</span>
	      </span>
	      <input type="text" id="searchInput" placeholder="검색어 입력...">
	      <span id="searchImgIcon">
	        <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/icon/search.png">
	      </span>
	    </div>
			<div id="menuLogout" class="menuItem">
			  <a href="<%= request.getContextPath() %>/logout.do">
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
	      <a href="./cart.html"><img id="cartImg" src="<%=request.getContextPath()%>/resources/img/icon/cart.png"></a>
	      <span id="cart-count">0</span>
      </div>
		</div>
	</div>
	<!-- BOOK카테고리 메뉴 -->
	<div id="bookCategory">
	  <a href="./bookList.html">모든 책</a>
	  <a href="./bookList.html">인문학</a>
	  <a href="./bookList.html">철학</a>
	  <a href="./bookList.html">언어학</a>
	  <a href="./bookList.html">미학</a>
	  <a href="./bookList.html">종교학</a>
	  <a href="./bookList.html">윤리학</a>
	  <a href="./bookList.html">심리학</a>
	</div>
	<!-- COMMUNITY카테고리 메뉴 -->
	<div id="communityCategory">
		<a href="<%= request.getContextPath() %>/noticeList.do">공지사항</a>
		<a href="./qnaList.html">Q&A</a>
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
		        <button id="guestBtn" type="submit">확인</button>
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
  <script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
  <script>
  function initHeaderEvents(){
	  const menuBook = document.getElementById("menuBook");
	  const menuCommunity = document.getElementById("menuCommunity");
	  const bookCategory = document.getElementById("bookCategory");
	  const communityCategory = document.getElementById("communityCategory");
	  const searchInput = document.getElementById("searchInput");
	  const searchText = document.getElementById("searchText");
	  const searchImgIcon = document.getElementById("searchImgIcon");
	  const searchSwichBtn = document.getElementById("searchSwichBtn"); // 오타 수정

    // BOOK 버튼 클릭 시 카테고리 메뉴 토글
    menuBook.addEventListener("click", function(event){
      event.stopPropagation();
      bookCategory.style.display = bookCategory.style.display === "block" ? "none" : "block";
      menuBook.classList.toggle("active");
      communityCategory.style.display = "none"; // 다른 메뉴 닫기
      menuCommunity.classList.remove("active");
    });

    // COMMUNITY 버튼 클릭 시 커뮤니티 메뉴 토글
    menuCommunity.addEventListener("click", function(event){
      event.stopPropagation();
      communityCategory.style.display = communityCategory.style.display === "block" ? "none" : "block";
      menuCommunity.classList.toggle("active");
      bookCategory.style.display = "none"; // 다른 메뉴 닫기
      menuBook.classList.remove("active");
    });

    // 검색 버튼 클릭 시 아이콘과 인풋 표시
    searchSwichBtn.addEventListener("click", function(event){ // 변수명 수정
      event.stopPropagation();
      if(searchInput.style.display === "none" || searchInput.style.display === ""){
        searchText.style.display = "none"; // "SEARCH" 숨김
        searchImgIcon.style.display = "inline"; // 검색 아이콘 표시
        searchInput.style.display = "inline-block"; // 검색 입력창 표시
        searchInput.focus();
      }
    });
    	
    // 화면 클릭 시 메뉴와 검색창 닫기
    document.addEventListener("click", function(event){
      if (!bookCategory.contains(event.target) && !menuBook.contains(event.target)){
        bookCategory.style.display = "none";
        menuBook.classList.remove("active");
      }
      if (!communityCategory.contains(event.target) && !menuCommunity.contains(event.target)){
        communityCategory.style.display = "none";
        menuCommunity.classList.remove("active");
      }
      if (!searchInput.contains(event.target) && !menuSearch.contains(event.target)){
        searchText.style.display = "inline"; // "SEARCH" 다시 표시
        searchImgIcon.style.display = "none"; // 검색 아이콘 숨김
        searchInput.style.display = "none"; // 검색 입력창 숨김
      }
    });

    //모달열기
    document.getElementById("menuLogin").onclick = function (){
	    console.log("로그인 버튼 클릭됨!");
	    document.getElementById("loginModal").classList.add("show");
    };
    
    //모달 닫기 (배경 클릭 or X버튼)
    window.addEventListener("click", function (event){
      if (event.target.id === "loginModal" || event.target.id === "closeLoginModal"){
        document.getElementById("loginModal").classList.remove("show");
      }
    });
   
    //모달내 LOGIN&GUEST선택창
    document.getElementById("login").addEventListener("click", function (){
   	  document.getElementById("loginMain").style.display = "block";
   	  document.getElementById("guestMain").style.display = "none";
   	  this.classList.add("active");
   	  document.getElementById("guest").classList.remove("active");
   	});

    document.getElementById("guest").addEventListener("click", function (){
   	  document.getElementById("loginMain").style.display = "none";
   	  document.getElementById("guestMain").style.display = "block";
   	  this.classList.add("active");
   	  document.getElementById("login").classList.remove("active");
    });
   
    //모달 내 로그인 버튼 클릭 시 입력 확인
    document.getElementById("loginBtn").addEventListener("click", function (event){
      var loginId = document.getElementById("loginId").value;
      var loginPw = document.getElementById("loginPw").value;

      if(!loginId || !loginPw){
        alert("아이디와 비밀번호를 입력해주세요.");
        return;
      }

      var idPattern = /^[a-z0-9_.+-]+$/;
      if(!idPattern.test(loginId)){
        alert("아이디는 소문자 영어, 특수문자(_ . + -), 숫자만 사용할 수 있습니다");
        return;
      }

      if(loginPw.length < 6){
        alert("비밀번호는 6자 이상이어야 합니다.");
        return;
      }

      // 로그인 성공 예시
      if(loginPw !== loginPw){
        alert("로그인에 실패하셨습니다.");
      }else{
        // 비밀번호가 올바른 경우 로그인 성공 처리
      }
    });
  }
  </script>
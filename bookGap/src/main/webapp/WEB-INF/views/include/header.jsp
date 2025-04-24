<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
				<div> <a href="./index.html"><img id="menuLogoImg" src="<%=request.getContextPath()%>/resources/img/logo.png"></a></div>
			</div>

      <!-- 메뉴2 -->
			<div id="menu2">
        <!--0221지은 추가시작-->
				<div id="menuSearch" class="menuItem">
        <!--0221지은 추가끝-->
          <span id="searchSwichBtn">
              <span id="searchText">SEARCH</span>
          </span>
          <input type="text" id="searchInput" placeholder="검색어 입력...">
          <span id="searchImgIcon">
            <img id="searchImg" src="<%=request.getContextPath()%>/resources/img/search.png">
          </span>
      </div>
        <!--0221지은 추가시작-->
				<div id="menuLogin" class="menuItem">
          <a href="./login.html"><img id="loginImg" src="<%=request.getContextPath()%>/resources/img/login.png"></a>
        </div>
        <div id="menuMypage" class="menuItem">
          <a href="./mypage.html"><img id="mypageImg" src="<%=request.getContextPath()%>/resources/img/edit.png"></a>
        </div>
				<div id="menuCart" class="menuItem">
          <a href="./cart.html"><img id="cartImg" src="<%=request.getContextPath()%>/resources/img/cart.png"></a>
          <span id="cart-count">0</span>
        </div>
        <!--0221지은 추가끝-->
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
      <a href="./list.html">공지사항</a>
      <!--0223지은 추가시작-->
      <a href="./qnaList.html">Q&A</a>
      <!--0223지은 추가끝-->
    </div>

		<div id="menuHr"><hr></div>
	</header>
  <script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
  
  <script>
    function initHeaderEvents() {
    // 변수 선언
    const menuBook = document.getElementById("menuBook");
    const menuCommunity = document.getElementById("menuCommunity");
    const bookCategory = document.getElementById("bookCategory");
    const communityCategory = document.getElementById("communityCategory");
    const searchInput = document.getElementById("searchInput");
    const searchText = document.getElementById("searchText");
    const searchImgIcon = document.getElementById("searchImgIcon");
    const searchSwichBtn = document.getElementById("searchSwichBtn"); // 오타 수정

    // BOOK 버튼 클릭 시 카테고리 메뉴 토글
    menuBook.addEventListener("click", function(event) {
      event.stopPropagation();
      bookCategory.style.display = bookCategory.style.display === "block" ? "none" : "block";
      menuBook.classList.toggle("active");
      communityCategory.style.display = "none"; // 다른 메뉴 닫기
      menuCommunity.classList.remove("active");
    });

    // COMMUNITY 버튼 클릭 시 커뮤니티 메뉴 토글
    menuCommunity.addEventListener("click", function(event) {
      event.stopPropagation();
      communityCategory.style.display = communityCategory.style.display === "block" ? "none" : "block";
      menuCommunity.classList.toggle("active");
      bookCategory.style.display = "none"; // 다른 메뉴 닫기
      menuBook.classList.remove("active");
    });

    // 검색 버튼 클릭 시 아이콘과 인풋 표시
    searchSwichBtn.addEventListener("click", function(event) { // 변수명 수정
      event.stopPropagation();
      if (searchInput.style.display === "none" || searchInput.style.display === "") {
        searchText.style.display = "none"; // "SEARCH" 숨김
        searchImgIcon.style.display = "inline"; // 검색 아이콘 표시
        searchInput.style.display = "inline-block"; // 검색 입력창 표시
        searchInput.focus();
      }
    });

    // 화면 클릭 시 메뉴와 검색창 닫기
    document.addEventListener("click", function(event) {
      if (!bookCategory.contains(event.target) && !menuBook.contains(event.target)) {
        bookCategory.style.display = "none";
        menuBook.classList.remove("active");
      }
      if (!communityCategory.contains(event.target) && !menuCommunity.contains(event.target)) {
        communityCategory.style.display = "none";
        menuCommunity.classList.remove("active");
      }
      if (!searchInput.contains(event.target) && !menuSearch.contains(event.target)) {
        searchText.style.display = "inline"; // "SEARCH" 다시 표시
        searchImgIcon.style.display = "none"; // 검색 아이콘 숨김
        searchInput.style.display = "none"; // 검색 입력창 숨김
      }
    });
  }
  </script>
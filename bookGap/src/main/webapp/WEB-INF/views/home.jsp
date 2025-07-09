<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<style>
	#navMenu {
  width: 100%;
  height: auto;
}

#new {
  margin-top: 3%;
  margin-bottom: 4.8%;
  text-align: center;
  font-size: 25px;
}

/* 전체 슬라이드 컨테이너 */
#bookList {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  padding: 0 40px;
  box-sizing: border-box;
}

/* 화살표 영역 */
#leftPointer, #rightPointer {
  width: 40px;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

#leftPointerImg, #rightPointerImg {
  width: 28px;
  height: 28px;
}

/* 슬라이드 하나 */
.bookSlide {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 슬라이드 내부 도서 리스트 (3권씩) */
.bookRow {
  display: flex;
  justify-content: space-evenly;
  align-items: flex-start;
  gap: 40px;
  width: 100%;
  max-width: 1000px;
  margin: 0 auto;
}

/* 개별 도서 */
.newBook {
  width: 30%;
  text-align: center;
  padding: 10px;
}

/* 도서 이미지 */
.newBook img {
  width: 100%;
  aspect-ratio: 3 / 4.3;  /* 책 세로 비율 */
  object-fit: contain;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

/* 제목, 가격 */
.bookName {
  margin-top: 8px;
  font-size: 18px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.bookPrice {
  margin-top: 8px;
  font-size: 14px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 가격 강조 */
.bookPrice {
  font-weight: bold;
  color: #333;
}

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<nav>
		<div id="navMenu">
			<div id="new">NEW</div>
			<div id="bookList">
				<div id="leftPointer"><img id="leftPointerImg" src="<%=request.getContextPath()%>/resources/img/icon/left.png"></div>
				
				<!-- 슬라이드 목록 -->
				<div id="newBookSlidesWrapper">
				  <c:forEach var="row" begin="0" end="${fn:length(newBooks) - 1}" step="3">
				    <div class="bookSlide" style="display: none;">
				      <div class="bookRow" style="display: flex; justify-content: space-evenly;">
				        <c:forEach var="offset" begin="0" end="2">
				          <c:if test="${row + offset < fn:length(newBooks)}">
				            <c:set var="book" value="${newBooks[row + offset]}" />
				            <div class="newBook" style="width: 30%; text-align: center;">
				              	 <a href="<c:url value='/product/bookView.do?isbn=${book.isbn}' />">
							    	<img src="${book.image}" style="width: 80%; height: 90%;" />
							     </a>
							    <div class="bookName">${book.title}</div>
							    <div class="bookPrice">${book.discount}원</div>
				            </div>
				          </c:if>
				        </c:forEach>
				      </div>
				    </div>
				  </c:forEach>
				</div>
				
				<div id="rightPointer"><img id="rightPointerImg" src="<%=request.getContextPath()%>/resources/img/icon/right.png"></div>
			</div>
		</div>
		<br><br>
	</nav>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	
<script>
let currentSlide = 0;
let slides = [];

function showSlide(index) {
  slides.forEach((slide, i) => {
    slide.style.display = i === index ? 'block' : 'none';
  });
}

document.addEventListener("DOMContentLoaded", function () {
  slides = Array.from(document.querySelectorAll(".bookSlide"));
  showSlide(currentSlide);

  document.getElementById("rightPointerImg").addEventListener("click", () => {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
  });

  document.getElementById("leftPointerImg").addEventListener("click", () => {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
  });

  // 장바구니 수량 갱신
  updateCartCount();
  if (typeof initHeaderEvents === "function") {
    initHeaderEvents();
  }

  // ▶ 제목에서 괄호 시작 후 삭제
  document.querySelectorAll(".bookName").forEach(el => {
    const text = el.textContent;
    const index = text.indexOf("(");
    if (index !== -1) {
      el.textContent = text.substring(0, index).trim();
    }
  });
});

function updateCartCount() {
  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
  let cartCount = cartItems.length;
  let cartCountElement = document.getElementById("cart-count");
  if (cartCountElement) {
    cartCountElement.textContent = cartCount;
    cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
  }
}
</script>
</body>
</html>

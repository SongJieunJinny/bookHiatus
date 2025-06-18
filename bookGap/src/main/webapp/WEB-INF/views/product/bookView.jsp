<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bookView</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/bookView.css?v=2"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<section>
		<div id="bookView">
          <div class="bookPart">   
            <div class="bookItem">
              <a href="#"><img src="${bookDetail.image}" alt="${bookDetail.title}"></a>
            </div>
            <div class="bookInfo">
              <div id="bookTitle" name="title">${bookDetail.title}</div>
							<div id="bookDiscount" name="discount">가격: ${bookDetail.discount}원</div>
							<div id="bookAuthor" name="author"> 저자: ${bookDetail.author}</div>
							<div id="bookPublisher" name="publisher">출판사: ${bookDetail.publisher}</div>
							<div id="bookPubdate" name="pubdate">출간일: ${bookDetail.pubdate}</div>
							<div id="bookIsbn" name="isbn">ISBN: ${bookDetail.isbn}</div>
							<div>배송비 : 3,000원 (50,000원 이상 구매 시 무료)<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제주 및 도서 산간 3,000원 추가 </div>
							<div id="bookOrderCheck">
							<div id="bookTitle1" name="title">${bookDetail.title}</div>
							<div id="bookQuantity">
								<div class="quantity">
									<button class="minus">−</button>
									<input type="text" value="1" class="num">
									<button class="plus">+</button>
								</div>
								<div id="totalPrice" name="TOTAL-PRICE">26,000원</div>
								</div>
							</div>
							<div id="bookCheckBtn">
								<div id="bookChartBtn">
									<button >장바구니</button>
								</div>
								<div id="bookOrderBtn">
									<button >바로구매</button>
								</div>
							</div>
						</div>
					</div> 
				</div>
				<div id="bookDetails">
					<c:if test="${not empty bookDetail.bookImgUrl}">
					  <div id="bookImgS">
					    <div id="bookDetailsImgs">
					      <img src="${bookDetail.bookImgUrl}" alt="${bookDetail.title}" >
					    </div>
					  </div>
					</c:if>
					<div id="bookDescription">
						<c:if test="${not empty bookDetail.description}">
						  <div style="margin-top: 50px;" class="book-section">
						    <strong>책 소개</strong>
						    <div  id="descriptionText" class="collapsible-text"><c:out value="${bookDetail.description}" escapeXml="false" /></div>
						    <button class="toggle-btn" data-target="descriptionText">
						    </button>
						  </div>
						</c:if>
						
						<c:if test="${not empty bookDetail.bookIndex}">
						  <div style="margin-top: 30px;" class="book-section">
						    <strong>목차</strong>
						    <div id="bookIndexText" class="collapsible-text"><c:out value="${bookDetail.bookIndex}" escapeXml="false" /></div>
						    <button class="toggle-btn" data-target="bookIndexText" >
						    </button>
						  </div>
						</c:if>
						
						<c:if test="${not empty bookDetail.publisherBookReview}">
						  <div style="margin-top: 30px;" class="book-section">
						    <strong>출판사 서평</strong>
						   <div id="publisherBookReviewText" class="collapsible-text"><c:out value="${bookDetail.publisherBookReview}" escapeXml="false" /></div>
						    <button class="toggle-btn" data-target="publisherBookReviewText">
						    </button>
						  </div>
						</c:if>
					</div>
				</div>
				<div id="bookComments">
					<div id="commentLayout">
						<div id="commentTitle">전체리뷰(3)</div>
					</div>
					<div id="review">
						<div id="bookComment">
							<h2>리뷰</h2>
							<form onsubmit="return validateReviewForm(this)">
								<div class="bookCommentBox">
									<span class="star">★★★★★
										<span>★★★★★</span>
										<input type="range" oninput="drawStar(this)" value="0" step="1" min="0" max="5" name="rating">
									</span>
									<div>
										<textarea class="reviewComment" placeholder="&nbsp;리뷰를 입력해주세요" name="content"></textarea>
									</div>
									<div class="bookCommentButton">
										<button>등록</button>
									</div>
								</div>
							</form>
							<div class="reviewBox">
								<div>
									<div class="reviewIdBox">
										<div class="reviewId">qortmddn***</div>
										<div style="color: gray; margin-top: 1%;">|</div>
										<div class="reviewRdate">2024-12-02</div>
										<div class="reviewLike">
											<span>🤍</span>
											<input type="checkbox" onclick="toggleLike(this)">
										</div>
									</div>
									<div>
										<span class="star1">★★★★★
											<span> ★★★★★</span>
											<input type="range" class="reviewStar" value="3" step="1" min="0" max="5" disabled>
										</span>
									</div>
									<!-- 기존 리뷰 내용 -->
									<div class="reviewContent">
										<textarea class="reviewContent" readonly="readonly">리뷰내용입니다.</textarea>
										<div class="reviewOptions">
											<span class="optionsToggle" onclick="toggleOptions(this)">⋯</span>
											<div class="optionsMenu">
												<button onclick="editReview(this)">수정</button>
												<button onclick="deleteReview(this)">삭제</button>
												<button onclick="reportReview(this)">신고</button>
											</div>
											<div class="editButtons">
												<button onclick="saveReview(this)">수정완료</button>
												<button onclick="cancelEdit(this)">취소</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="paging">
								<ul class="pagination">
									<li class="disabled"><a href="#">«</a></li>
									<li class="active"><a href="#">1</a></li>
									<li><a href="#">2</a></li>
									<li><a href="#">3</a></li>
									<li><a href="#">4</a></li>
									<li><a href="#">5</a></li>
									<li><a href="#">»</a></li>
								</ul>
							</div>                        
						</div>
					</div>
				</div>
	</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount(); // 장바구니 개수 업데이트
   initHeaderEvents();
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

//책 상세페이지에서 장바구니 버튼 클릭 시 실행
document.addEventListener("click", function (event) {
	if (event.target.closest("#bookChartBtn")) {
			event.preventDefault();

			// 로컬 스토리지에서 기존 장바구니 데이터 가져오기
			let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

			// 추가할 책 정보
			let newItem = {
					id: "${bookDetail.isbn}", // 책의 고유 ID
					title: "${bookDetail.title}",
					price: 26000,
					quantity: 1
			};

			// 기존 장바구니에 동일한 책이 있는지 확인
			let existingItem = cartItems.find(item => item.id === newItem.id);

			if (existingItem) {
					// 같은 책이 이미 있으면 수량만 증가
					existingItem.quantity += 1;
			} else {
					// 장바구니에 없으면 새로운 아이템 추가
					cartItems.push(newItem);
			}

			// 업데이트된 장바구니 데이터를 다시 localStorage에 저장
			localStorage.setItem("cartItems", JSON.stringify(cartItems));

			// 장바구니 개수 업데이트
			updateCartCount();

			// 사용자에게 장바구니 이동 여부 확인
			const goToCart = confirm("장바구니로 이동하시겠습니까?");
			if (goToCart) {
					window.location.href = "<%= request.getContextPath() %>/cart.do";
			}
		}
});

document.addEventListener("click", function (event) {
	if (event.target.closest("#bookOrderBtn")) {
			event.preventDefault();

			const goToCart = confirm("로그인 페이지로 이동하시겠습니까?");
			if (goToCart) {
					window.location.href = "<%= request.getContextPath() %>/login.do";
			}	
	}
});
</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
	  const contextPath = '<%= request.getContextPath() %>';

	  document.querySelectorAll(".toggle-btn").forEach(function (btn) {
	    const targetId = btn.getAttribute("data-target");
	    const target = document.getElementById(targetId);

	    if (!target) return;
	    if (target.scrollHeight <= 160) {
	      btn.style.display = "none";
	      return;
	    }

	    setToggleButton(btn, false, contextPath);

	    btn.addEventListener("click", function () {
	    	  const isExpanded = target.classList.contains("expanded");
	    	  target.classList.toggle("expanded");
	    	  setToggleButton(btn, !isExpanded, contextPath);

	    	  if (isExpanded) {
	    	    // 접기인 경우 → transitionend 이벤트 기다렸다가 scrollIntoView 실행
	    	    const onTransitionEnd = () => {
	    	      target.removeEventListener("transitionend", onTransitionEnd);

	    	      // 한 프레임 쉬고 실행 (레이아웃 안정화)
	    	      requestAnimationFrame(() => {
	    	        btn.scrollIntoView({ behavior: "smooth", block: "center" });
	    	      });
	    	    };

	    	    target.addEventListener("transitionend", onTransitionEnd);
	    	  }
	    	});
	  });

	  function setToggleButton(button, isExpanded, contextPath) {
	    button.innerHTML = "";

	    const label = document.createElement("span");
	    label.textContent = isExpanded ? "접기" : "펼쳐보기";
	    label.style.display = "inline-block";
	    label.style.textAlign = "center";
	    button.appendChild(label);

	    const iconImg = document.createElement("img");
	    iconImg.src = contextPath + "/resources/img/icon/" + (isExpanded ? "collapse" : "expand") + ".png";
	    iconImg.width = 18;
	    iconImg.height = 10;
	    iconImg.style.verticalAlign = "middle";
	    button.appendChild(iconImg);
	  }
	});
</script>
<script>
document.addEventListener("DOMContentLoaded", function() {
		const minusBtn = document.querySelector(".minus");
		const plusBtn = document.querySelector(".plus");
		const numInput = document.querySelector(".num");
		const totalPrice = document.getElementById("totalPrice");

		const unitPrice = 23000; // 개당 가격

		// 총 금액 업데이트 함수
		function updateTotalPrice() {
				let quantity = parseInt(numInput.value);
				totalPrice.textContent = (unitPrice * quantity).toLocaleString() + "원"; // 천 단위 콤마 추가
		}

		// 숫자 감소 기능
		minusBtn.addEventListener("click", function() {
				let currentValue = parseInt(numInput.value);
				if (currentValue > 1) { // 최소값 제한
						numInput.value = currentValue - 1;
						updateTotalPrice();
				}
		});

		// 숫자 증가 기능
		plusBtn.addEventListener("click", function() {
				let currentValue = parseInt(numInput.value);
				numInput.value = currentValue + 1;
				updateTotalPrice();
		});

		// 숫자 입력 필드 직접 수정 시 숫자만 입력 가능하도록 처리
		numInput.addEventListener("input", function() {
				this.value = this.value.replace(/[^0-9]/g, ''); // 숫자만 허용
				if (this.value === "" || parseInt(this.value) < 1) {
						this.value = 1; // 최소값 제한
				}
				updateTotalPrice();
		});

		// 초기 총 금액 설정
		updateTotalPrice();
});

function validateReviewForm(form) {
		const content = form.querySelector('textarea[name="content"]').value.trim();
		const rating = form.querySelector('input[name="rating"]').value;

		// 리뷰 내용이 비어 있는 경우
		if (content === "") {
				alert("리뷰 내용을 입력해 주세요.");
				return false;  // 폼 제출 중단
		}

		// 별점이 0인 경우
		if (rating == 0) {
				const confirmSubmit = confirm("별점을 등록하지 않으시겠습니까?");
				if (!confirmSubmit) {
						return false;  // 폼 제출 중단
				}
		}

		return true;  // 폼 제출 진행
}

document.addEventListener("DOMContentLoaded", function () {
		drawStarInit(); // 페이지 로드 시 별점 초기화
});
	// JAVASCRIPT CODE
const drawStar = (target) => {
		$(target).parent().find("span").css("width",`${target.value * 20}%`);
//document.querySelector(`.star span`).style.width = `${target.value * 20}%`;
}

function drawStarInit(){
		$(".reviewStar").each(function(){
				const value = $(this).val(); // 각 input의 value를 가져옴
				$(this).parent().find("span").css("width", `${value * 20}%`);
		});
}

function drawStarInit() {
		$(".reviewStar").each(function () {
				const value = $(this).val(); // 각 input의 value를 가져옴
				console.log(`Initializing star width: ${value * 20}%`); // 디버깅용
				$(this).parent().find("span").css("width", `${value * 20}%`);
		});
}

function toggleLike(target) {
		$(target).parent().toggleClass("active");
		const span = $(target).siblings("span");
		if ($(target).parent().hasClass("active")) {
				span.text("❤️");
		} else {
				span.text("🤍");
		}
}

function toggleOptions(element) {
		let menu = element.nextElementSibling;
		if (menu.style.display === "block") {
				menu.style.display = "none";
		} else {
				// 다른 열린 메뉴 닫기
				document.querySelectorAll(".optionsMenu").forEach(menu => menu.style.display = "none");
				menu.style.display = "block";
		}
}

// 수정 기능 (예제)
function editReview(button) {
		alert("수정 기능이 실행됩니다!");
}

// 삭제 기능 (예제)
function deleteReview(button) {
		if (confirm("정말 삭제하시겠습니까?")) {
				alert("삭제되었습니다.");
		}
}

// 신고 기능 (예제)
function reportReview(button) {
		alert("신고가 접수되었습니다.");
}

function editReview(button) {
		let reviewBox = button.closest('.reviewBox');
		let reviewContent = reviewBox.querySelector('.reviewContent textarea');
		let reviewRating = reviewBox.querySelector('.reviewStar');
		let optionsMenu = button.closest('.optionsMenu');
		let editButtons = reviewBox.querySelector('.editButtons');

		// 기존 값 저장 (취소 시 복구)
		reviewContent.dataset.originalText = reviewContent.value;
		reviewRating.dataset.originalValue = reviewRating.value;

		// 수정 가능하도록 설정
		reviewContent.removeAttribute('readonly');
		reviewRating.removeAttribute('disabled');
		reviewRating.style.pointerEvents = "auto"; 

		// ⭐ 슬라이더 변경 시 UI 업데이트
		reviewRating.addEventListener("input", function () {
				drawStar(reviewRating);
		});

		// 옵션 메뉴 숨기기
		optionsMenu.style.display = "none";

		// 수정 완료 & 취소 버튼 표시
		editButtons.style.display = "block";
}

function saveReview(button) {
		let reviewBox = button.closest('.reviewBox');
		let reviewContent = reviewBox.querySelector('.reviewContent textarea');
		let reviewRating = reviewBox.querySelector('.reviewStar');
		let optionsMenu = reviewBox.querySelector('.optionsMenu');
		let editButtons = reviewBox.querySelector('.editButtons');

		//  변경된 값 저장
		let newContent = reviewContent.value;
		let newRating = reviewRating.value;

		console.log(`새 리뷰 내용: ${newContent}`);
		console.log(`새 별점: ${newRating}`);

		//  수정 완료 후 다시 비활성화
		reviewContent.setAttribute('readonly', 'readonly');
		reviewRating.setAttribute('disabled', 'disabled');
		reviewRating.style.pointerEvents = "none";

		//  UI 업데이트
		drawStar(reviewRating);

		// 옵션 메뉴 다시 보이기
		optionsMenu.style.display = "block";

		// 수정 완료 & 취소 버튼 숨기기
		editButtons.style.display = "none";
}

function cancelEdit(button) {
		let reviewBox = button.closest('.reviewBox');
		let reviewContent = reviewBox.querySelector('.reviewContent textarea');
		let reviewRating = reviewBox.querySelector('.reviewStar');
		let optionsMenu = reviewBox.querySelector('.optionsMenu');
		let editButtons = reviewBox.querySelector('.editButtons');

		//  원래 값으로 복구
		reviewContent.value = reviewContent.dataset.originalText;
		reviewRating.value = reviewRating.dataset.originalValue;

		// 수정 취소 후 다시 비활성화
		reviewContent.setAttribute('readonly', 'readonly');
		reviewRating.setAttribute('disabled', 'disabled');
		reviewRating.style.pointerEvents = "none";

		//  기존 별점 값 UI에 반영
		drawStar(reviewRating);

		// 옵션 메뉴 다시 보이기
		optionsMenu.style.display = "block";

		// 수정 완료 & 취소 버튼 숨기기
		editButtons.style.display = "none";
}
</script>
</body>
</html>
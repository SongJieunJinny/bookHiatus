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
	<c:choose>
	  <c:when test="${not empty bookDetail.discount and bookDetail.discount > 0}">
	    <c:set var="bookPrice" value="${bookDetail.discount}" />
	  </c:when>
	  <c:otherwise>
	    <c:set var="bookPrice" value="0" />
	  </c:otherwise>
	</c:choose>
	<section>
		<div id="bookView">
			<div class="bookPart">   
				<div class="bookItem">
					<a href="#"><img src="${bookDetail.image}" alt="${bookDetail.title}"></a>
				</div>
				<div class="bookInfo">
	        <div id="bookTitle"><c:out value="${fn:replace(bookDetail.title, '(', '<br>(')}" escapeXml="false"/></div>
	        <div id="bookDiscount">가격: <fmt:formatNumber value="${bookDetail.discount > 0 ? bookDetail.discount : 0}" type="number"/>원</div>
	        <div id="bookAuthor">저자: ${bookDetail.author}</div>
	        <div id="bookPublisher">출판사: ${bookDetail.publisher}</div>
	        <div id="bookPubdate">출간일: ${bookDetail.pubdate}</div>
	        <div id="bookIsbn">ISBN: ${bookDetail.isbn}</div>
					<div>배송비 : 3,000원 (50,000원 이상 구매 시 무료)<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제주 및 도서 산간 3,000원 추가 </div>
					<div id="bookOrderCheck">
						<div id="bookTitle1"><c:out value="${fn:replace(bookDetail.title, '(', '<br>(')}" escapeXml="false"/></div>
						<div id="bookQuantity">
							<div class="quantity">
								<button class="minus">−</button>
								<input type="text" value="1" class="num">
								<button class="plus">+</button>
							</div>
							<div id="totalPrice">26,000원</div>
						</div>
					</div>
					<div id="bookCheckBtn">
						<div>
							<button  id="bookChartBtn">장바구니</button>
						</div>
						<div>
							<button id="bookOrderBtn">바로구매</button>
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
						<div id="descriptionText" class="collapsible-text"><c:out value="${bookDetail.description}" escapeXml="false" /></div>
						<button class="toggle-btn" data-target="descriptionText"></button>
					</div>
				</c:if>
				
				<c:if test="${not empty bookDetail.bookIndex}">
					<div style="margin-top: 30px;" class="book-section">
						<strong>목차</strong>
						<div id="bookIndexText" class="collapsible-text"><c:out value="${bookDetail.bookIndex}" escapeXml="false" /></div>
						<button class="toggle-btn" data-target="bookIndexText" ></button>
					</div>
				</c:if>
				
				<c:if test="${not empty bookDetail.publisherBookReview}">
					<div style="margin-top: 30px;" class="book-section">
						<strong>출판사 서평</strong>
						<div id="publisherBookReviewText" class="collapsible-text"><c:out value="${bookDetail.publisherBookReview}" escapeXml="false" /></div>
						<button class="toggle-btn" data-target="publisherBookReviewText"></button>
					</div>
				</c:if>				
			</div>
		</div>		
<script type="text/javascript">
let isbn = "${bookDetail.isbn}";
let userId = '<sec:authentication property="name" />';
let userRole = '<sec:authentication property="authorities" htmlEscape="false" />';

$(document).ready(function() {
  loadComment(isbn);
     
  // 메뉴 버튼 이벤트 초기화
  $(document).on('click', '.reviewOptions', function(event) {
	  event.stopPropagation(); // 이벤트 전파 방지
	  let commentNo = $(this).data("reviewBox");
	  
	  // 모든 메뉴 숨김
	  $(".optionsMenu").hide(); 
	  // 현재 메뉴 토글
	  $("#optionsMenu" + commentNo).toggle();
	});

  // 문서의 다른 곳 클릭하면 모든 메뉴 숨김
  $(document).click(function() {
  	$(".optionsMenu").hide();
  });

  // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
  $(document).on('click', '.optionsMenu', function(event) {
  	event.stopPropagation();
  });
});

//두번째 변수 생략시 1로 들어감
function loadComment(isbn,page = 1) {
  $.ajax({
    url: "<%= request.getContextPath()%>/comment/loadComment.do",
    type: "GET",
    data: { isbn: isbn , cnowpage:page },
    success : function(data) { 
  	  let html = "";
  	  let roles = userRole.split(',').map(s => s.trim());
  	  
			for(let cvo of data.clist){
				console.log("🔎 cvo.userId =", cvo.userId); // 서버 응답값
				html +=`<div id="reviewBox\${cvo.commentNo}" class="reviewBox">
									<div class="reviewIdBox">
										<div class="reviewId">\${cvo.userId}</div>
										<div class="reviewIdRdate">|</div>
										<div class="reviewRdate">\${cvo.formattedCommentRdate}</div>
										<div class="reviewLikeStar">
											<div class="reviewLike ${cvo.lovedByLoginUser ? 'active' : ''}">
												<label>
												  <input type="checkbox" class="reviewLikeInput"
					                      ${cvo.lovedByLoginUser ? "checked" : ""}
					                      onclick="toggleLove(${cvo.commentNo}, '${cvo.isbn}', '${userId}', this)" />
					                <span>🤍</span>
												</label>
											</div>
											<div class="starBox">
	                      <label class="starLabel">
	                        <input type="range" class="reviewStar"
	                               min="0" max="5" step="1"
	                               value="${cvo.commentRating}"
	                               disabled oninput="drawStar(this)" />
	                        <div class="starsOverlay"></div>
	                      </label>
	                    </div>
										</div>
									</div>
									<div id="contentContainer\${cvo.commentNo}" class="contentContainer">
										<div class="reviewContent">\${cvo.commentContent}</div>`;
									if (roles.includes("ROLE_ADMIN") || (cvo.userId && cvo.userId.trim() === userId.trim())) {
						html +=`<div class="reviewOptions" data-review-box="\${cvo.commentNo}">⋯
								      <div id="optionsMenu\${cvo.commentNo}" class="optionsMenu">
								        <button class="editReviewButton" data-commentNo="${cvo.commentNo}">수정</button>
								        <button class="deleteReviewButton" data-commentNo="${cvo.commentNo}">삭제</button>
								        <button class="reportReviewButton" data-commentNo="${cvo.commentNo}">신고</button>
								      </div>
								    </div>`;
										}
					html +=`</div>
								</div>`;
			}
			if(data.cpaging){
				paging = data.cpaging;
				html += `<div class="pagination">`;
				if(paging.startPage > 1){
					html += `<a class="paging-link" data-page="\${paging.startPage - 1}">&lt;</a>`;
				} 
				for(let cnt = paging.startPage; cnt <= paging.endPage; cnt++){
					if(paging.nowPage == cnt){
						html += `<a id="default" style="color:#FF5722; cursor:default;">\${cnt }</a>`;
					}else{
						html += `<a class="paging-link" data-page="\${cnt}">\${cnt}</a>`;
					}
				}	
				if(paging.endPage < paging.lastPage){
					html += `<a class="paging-link" data-page="\${paging.endPage + 1}">&gt;</a>`;
				}
				html += `</div>`;
			}
			      		$(".comment-list").html(html);
			      		// 금빛 별점 반영
								$(".reviewStar").each(function () {
								  drawStar(this);
								});
					      // 페이징 링크에 이벤트 바인딩
					      $(".paging-link").click(function(e) {
						        e.preventDefault();
						        let page = $(this).data("page");
						        loadComment(isbn, page);
					      });
							},
		error: function(xhr, status, error) {
						console.error("AJAX Error:", status, error);  // AJAX 오류 상태 및 에러 메시지 출력
						alert("댓글 로딩 중 오류가 발생했습니다.");
					 }
	});
}
function drawStar(el) {
  const overlay = el.nextElementSibling;
  const value = parseInt(el.value, 10);
  if (overlay && overlay.classList.contains("starsOverlay")) {
    overlay.style.setProperty('--rating', value >= 0 ? value : 0);
  }
}
</script>
		<sec:authorize access="isAuthenticated()">
			<div id="bookComments">
				<div id="commentLayout">
					<div id="commentTitle">
						전체리뷰
							<c:if test="${bookDetail.commentCount > 0}">
								<span style="color:#FF5722;">(${bookDetail.commentCount})</span>
							</c:if>
					</div>
				</div>
				<div id="review">
					<div id="bookComment">
						<h2>리뷰작성</h2>
						<form onsubmit="event.preventDefault(); commentInsert(${bookDetail.bookNo}, ${bookDetail.isbn}); return false;">
							<div class="bookCommentBox">
								<div class="commentBoxHeader">
									<!-- 좋아요 -->
									<div class="reviewLike">
									  <label>
									    <input type="checkbox" class="reviewLikeInput" />
									    <span>🤍</span>
									  </label>
									</div>
									<!-- 별점 -->
							    <div class="starBox">
							      <label class="starLabel">
							        <input type="range" class="reviewStar" min="0" max="5" step="1" value="3" name="rating" oninput="drawStar(this)" />
							        <div class="starsOverlay"></div>
							      </label>
							    </div>
						    </div>
						    <!-- 댓글 -->
						    <textarea class="reviewComment" placeholder="리뷰를 입력해주세요" name="content"></textarea>
						    <!-- 등록 버튼 -->
						    <button class="bookCommentButton" type="submit">등록</button>
							</div>
						</form>
						<!-- 댓글 목록 출력 시작 -->
						<div class="comment-list"></div>
					</div>
				</div>
			</div>
		</sec:authorize>
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
  if (!Array.isArray(cartItems)) {
    cartItems = Object.values(cartItems).filter(item => typeof item === 'object');
  }

  const cartCount = cartItems.length;
  const cartCountElement = document.getElementById("cart-count");

  if (cartCountElement) {
    cartCountElement.textContent = cartCount;
    cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
  }
}

document.addEventListener("DOMContentLoaded", function() {
	const minusBtn = document.querySelector(".minus");
	const plusBtn = document.querySelector(".plus");
	const numInput = document.querySelector(".num");
	const totalPrice = document.getElementById("totalPrice");

	const unitPrice = ${bookDetail.discount}; // 개당 가격

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

//책 상세페이지에서 장바구니 버튼 클릭 시 실행
document.addEventListener("click", function (event) {
  if (event.target.closest("#bookChartBtn")) {
  	event.preventDefault();

	  let quantity = parseInt(document.querySelector(".num").value) || 1;
	
	  let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	  if (!Array.isArray(cartItems)) {
	    cartItems = Object.values(cartItems).filter(item => typeof item === 'object');
	  }

	  let newItem = {
	    id: "${bookDetail.isbn}",
	    title: "${bookDetail.title}",
	    price: Number("${bookPrice}"),
	    image: "${bookDetail.image}",
	    quantity: quantity
	  };
	
	  console.log("현재 장바구니 (before push):", cartItems);
	  console.log("추가하려는 아이템:", newItem);
	
	  let existingItem = cartItems.find(item => item.id === newItem.id);
	  if (existingItem) {
	    existingItem.quantity += quantity;
	  } else {
	    cartItems.push(newItem);
	  }
	
	  localStorage.setItem("cartItems", JSON.stringify(cartItems));
	  console.log("저장된 로컬스토리지:", localStorage.getItem("cartItems"));
	
	  updateCartCount(); // 장바구니 개수 갱신
	
	  const goToCart = confirm("장바구니 페이지로 이동하시겠습니까?");
	  if (goToCart) {
	    window.location.href = "<%= request.getContextPath() %>/product/cart.do";
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
<!-- Comment -->
<script type="text/javascript">
$(document).ready(function() {
	// 별점 클릭
  $(".reviewStar").each(function () {
	  drawStar(this);
	});
  // 수정 버튼 클릭
  $(document).on('click', '.editReviewButton', function() {
    const commentNo = $(this).data("commentNo");  // 클릭한 버튼에서 commentNo 가져오기
    editReview(commentNo);  // 수정 함수 호출
  });
  // 삭제 버튼 클릭
  $(document).on('click', '.deleteReviewButton', function() {
    const commentNo = $(this).data("commentNo");  // 클릭한 버튼에서 commentNo 가져오기
    deleteReview(commentNo);  // 삭제 함수 호출
  });
  //신고 버튼 클릭
  $(document).on('click', '.reportReviewButton', function() {
	  const commentNo = $(this).data("commentNo");  // 클릭한 버튼에서 commentNo 가져오기
	  reportReview(commentNo);  // 수정 함수 호출
	});
});

function toggleOptions(element) {
  let menu = element.nextElementSibling;
  if (menu.style.display === "block") {
    menu.style.display = "none";
  } else {
    document.querySelectorAll(".optionsMenu").forEach(menu => menu.style.display = "none");
    menu.style.display = "block";
  }
}

function editReview(commentNo) {
	  const commentElement = $("#reviewBox" + commentNo);
	  const currentText = commentElement.find(".reviewContent").text().trim();
	  const currentRating = commentElement.find(".reviewStar").val();
	  const currentLikeChecked = commentElement.find(".reviewLikeInput").is(":checked");

	  const inputElement = $(`<div class="reviewBox editMode" id="editBox-${commentNo}">
												      <div class="reviewIdBox">
												      	<div class="reviewLikeStar">
													        <div class="reviewLike ${currentLikeChecked ? 'active' : ''}">
													          <label>
													            <input class="reviewLikeInput" type="checkbox" ${currentLikeChecked ? "checked" : ""}>
													            <span>🤍</span>
													          </label>
													        </div>
													        <div class="starBox">
															      <label class="starLabel">
															        <input type="range" class="reviewStar" value="${currentRating}" step="1" min="0" max="5" name="rating" oninput="drawStar(this)">
															        <div class="starsOverlay"></div>
															      </label>
															    </div>
														    </div>
												      </div>
												      <div class="contentContainer">
												        <textarea class="reviewComment">${currentText}</textarea>
												        <div class="editButtons">
												          <button class="saveReview">수정완료</button>
												          <button class="cancelEdit">취소</button>
												        </div>
												      </div>
												    </div>`);

	  // 기존 댓글 요소를 숨기고, 수정용 폼 삽입
	  commentElement.hide().after(inputElement);
	  
	  inputElement.find(".reviewStar").each(function () {
		    drawStar(this);
		});
	  
	  // 수정 완료 버튼 클릭
	  inputElement.find(".saveReview").on("click", function (e) {
	    e.preventDefault();

	  const newText = inputElement.find(".reviewComment").val().trim();
	  const newRating = inputElement.find(".reviewStar").val();
	  const newLiked = inputElement.find(".reviewLikeInput").is(":checked");
	    
	  saveComment(commentNo, newText, newRating, newLiked);
	  });
	  
	  inputElement.find(".cancelEdit").on("click", function () {
	    inputElement.remove();
	    commentElement.show();
	  });
	}

	function saveComment(commentNo, newText, newRating, newLiked) {
	  $.ajax({
	    url: "<%= request.getContextPath()%>/comment/modify.do",
	    type: "POST",
	    data: { commentNo, commentContent: newText },
	    success: function (result) {
					       if(result === "Success"){
					         alert("댓글이 성공적으로 수정되었습니다.");
					         loadComment(isbn);
					         // 별점 수정 요청
					         $.ajax({ url: "<%= request.getContextPath()%>/comment/updateRating.do",
								            type: "POST",
								            data: { commentNo, rating: newRating, isbn } });
					         // 좋아요 토글 처리
					         $.ajax({ url: "<%= request.getContextPath()%>/comment/toggleLove.do",
														type: "POST",
														data: { commentNo, userId, isbn } });
					       }else{
					         alert("댓글 수정에 실패했습니다. 다시 시도해주세요.");
					         // 원래 요소 복원
					         inputElement.remove();
					         commentElement.show();
					       }
					     },
	    error: function (xhr, status, error) {
				       console.error("댓글 수정 오류:", status, error);
				       alert("서버 오류로 인해 댓글을 수정할 수 없습니다.");
				       inputElement.remove();
				       commentElement.show();
				     }
	  });
	}
	
function commentInsert(bookNo, isbn) {
	const userId = '${pageContext.request.userPrincipal.name}';
	const content = $('textarea.reviewComment').val();
	const rating = $('.reviewStar').val();
	const liked = $('.reviewLikeInput').is(':checked');
	
	if (!userId || userId === 'null') {
    alert("로그인 후 댓글을 작성할 수 있습니다.");
    return;
  }

  if (!content.trim()) {
    alert("리뷰 내용을 입력해주세요.");
    return;
  }

  $.ajax({
    url : "<%= request.getContextPath()%>/comment/write.do",
    type : "POST",
    data : { bookNo: bookNo,
        		 isbn: isbn,
    				 userId : userId,
    				 commentContent: content },  
    success : function (result){
				        if(result === "Success"){
				            alert("댓글이 등록되었습니다.");
				            $(".reviewComment").val("");
				            loadComment(isbn);
					          // 별점 저장 (댓글 저장 성공 후)
										$.ajax({ url: '<%= request.getContextPath()%>/comment/saveRating.do',
														 type: 'POST',
														 data: { isbn, rating, commentNo: -1 } });
										// 좋아요 저장
										if(liked){
											$.ajax({ url: '<%= request.getContextPath()%>/comment/toggleLove.do',
															 type: 'POST',
															 data: { isbn, userId, commentNo: -1 } });
										}
					      }else{
					        alert("등록에 실패했습니다.");
					      }
					    },
    error : function(){
      alert("서버 통신 오류가 발생했습니다.");
    }
  });
}

function deleteReview(commentNo){
	$.ajax({
		url : "<%= request.getContextPath()%>/comment/delete.do",
		type : "POST",
		data : {commentNo : commentNo},
		success : function(result){
								if(result === "Success"){
									loadComment(isbn);
									alert("댓글이 삭제 되었습니다.");
								}else{
									alert("댓글 삭제에 실패하였습니다.");
								}
							},
							,
		error: function(xhr, status, error){
						alert("삭제 요청 중 오류 발생");
						inputElement.remove();
					  commentElement.show();
					}
	});
}

$(document).ready(function() {
  var commentNo = $("#commentNo").val();  // 댓글 번호
  var isbn = $("#isbn").val();  // ISBN

  $(".star").on("click", function() {
    var rating = $(this).data("value");
    
    $.ajax({
	    url: '<%= request.getContextPath()%>/comment/saveRating.do',
	    type: 'POST',
	    data: { commentNo: commentNo, 
	    				rating: rating, 
	    				isbn: isbn },
	    success: function(response) {
				         if(response === "Success") {
				           alert("별점이 저장되었습니다.");
				         }else{
				           alert(response);
				         }
	    				 }
    });
  });
});

function toggleLove(commentNo, isbn, userId, checkbox) {
  const loved = checkbox.checked;

  $.ajax({
    url: "<%= request.getContextPath()%>/comment/toggleLove.do",
    method: "POST",
    data: { commentNo: commentNo,
			      userId: userId,
			      isbn: isbn },
    success: function(result){
				       if(result === "liked"){
				         $(checkbox).closest(".reviewLike").addClass("active");
				       }else if(result === "unliked"){
				         $(checkbox).closest(".reviewLike").removeClass("active");
				       }else{
				         alert("하트 처리 실패!");
				         checkbox.checked = !loved;
				       }
				     },
    error: function(){
			       alert("서버 오류 발생!");
			       checkbox.checked = !loved;
			     }
  });
}
</script>
</body>
</html>
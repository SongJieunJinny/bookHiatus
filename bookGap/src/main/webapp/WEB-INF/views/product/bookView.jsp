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
							<button id="bookOrderBtn" type="button" data-isbn="${bookDetail.isbn}">바로구매</button>
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

$(document).ready(function () {
  loadComment(isbn);
     
	//옵션 메뉴 토글
  $(document).on('click', '.reviewOptions', function (e) {
    e.stopPropagation();
    let commentNo = $(this).data("reviewBox");
    $(".optionsMenu").hide();
    $("#optionsMenu" + commentNo).toggle();
  });

  // 문서의 다른 곳 클릭하면 모든 메뉴 숨김
  $(document).click(() => $(".optionsMenu").hide());

  // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
  $(document).on('click', '.optionsMenu', e => e.stopPropagation());
  
  // 등록 폼 제출 처리
  $("#commentForm").on("submit", function (e) {
    e.preventDefault();
    commentInsert();
  });
  
  // 수정 버튼
  $(document).on('click', '.editReviewButton', function () {
    editReview($(this).data("commentno"));
  });
	// 삭제 버튼
  $(document).on('click', '.deleteReviewButton', function () {
    deleteReview($(this).data("commentno"));
  });
	// 신고 버튼
  $(document).on('click', '.reportReviewButton', function () {
    reportReview($(this).data("commentno"));
  });
  
  //[수정 없음] 댓글 목록의 '좋아요' 체크박스 변경 이벤트
  $(document).on("change", "div.comment-list .reviewLikeInput", function () {
    const commentNo = $(this).data("commentno");
    // 작성 폼의 좋아요가 아닌, 목록의 좋아요만 toggleLove 호출
	  if (commentNo) {
        toggleLove(commentNo, isbn, userId, this);
    }
  });

  // [UI 로직] 좋아요 체크 시 하트 색상 변경
  $(document).on("change", ".reviewLikeInput", function () {
    $(this).closest(".reviewLike").toggleClass("active", this.checked);
  });
});

function drawStar(el) {
  if (!el) return;
  const overlay = el.parentNode?.querySelector('.starsOverlay');
  const value = parseInt(el.value, 10) || 0;
  if (overlay) {
    requestAnimationFrame(() => {
      overlay.style.setProperty('--rating', value);
    });
  }
}

//두번째 변수 생략시 1로 들어감
function loadComment(isbn, page = 1) {
	console.log(`🚀 loadComment 호출됨: isbn = '${isbn}', page = ${page}`);
	
	if (!isbn) {
    console.error("🚨 ISBN 값이 비어있어 댓글을 로드할 수 없습니다.");
    return; 
  }
	
  $.ajax({
    url: "<%= request.getContextPath()%>/comment/loadComment.do",
    type: "GET",
    data: "isbn=" + encodeURIComponent(isbn) + "&cnowpage=" + page,
    dataType: "json",
    success : function(data) { 
    	console.log("✅ loadComment 응답 성공:", data);
    	console.log("📨 댓글 응답 전체:", data);            // 전체 응답 보기
    	console.log("🧩 첫 댓글 lovedByLoginUser:", data.commentList[0]?.lovedByLoginUser);
    	console.log("⭐ 첫 댓글 commentRating:", data.commentList[0]?.commentRating);

    	const commentList = $(".comment-list");
        commentList.empty();
        let html = "";
        const cleanedUserRole = userRole.replace(/[\[\]]/g, '');
        let roles = cleanedUserRole.split(',').map(s => s.trim());
        console.log("Cleaned roles Array:", roles);
        
        if (data.commentList && data.commentList.length > 0) {
          for (let cvo of data.commentList) {
        	  const isLiked = cvo.likeCount > 0;
        	  const isCheckedByMe = cvo.lovedByLoginUser;
        	  const canInteract = roles.includes("ROLE_ADMIN") || (cvo.userId && cvo.userId.trim() === userId.trim());
        	  
            html += `<div id="reviewBox\${cvo.commentNo}" class="reviewBox">
                       <div class="reviewIdBox">
                         <div class="reviewId">\${cvo.userId}</div>
                         <div class="reviewIdRdate">|</div>
                         <div class="reviewRdate">\${cvo.formattedCommentRdate}</div>
                         <div class="reviewLikeStar">
                           <div class="reviewLike \${isLiked ? 'active' : ''}">
                             <label>
                               <input type="checkbox" class="reviewLikeInput" data-commentno="\${cvo.commentNo}" \${isCheckedByMe ? 'checked' : ''} \${!canInteract ? 'disabled' : ''} />
                               <span class="heartSymbol">♥</span>
                             </label>
                           </div>
                           <div class="starBox">
                             <label class="starLabel">
                               <input type="range" class="reviewStar" min="0" max="5" step="1" value="\${cvo.commentRating || 0}" disabled />
                               <div class="starsOverlay"></div>
                             </label>
                           </div>
                         </div>
                       </div>
                       <div id="contentContainer\${cvo.commentNo}" class="contentContainer">
                         <div class="reviewContent">\${cvo.commentContent}</div>`;
			         if (canInteract) {
			         html += `<div class="reviewOptions" data-review-box="\${cvo.commentNo}">⋯
			                    <div id="optionsMenu\${cvo.commentNo}" class="optionsMenu">
			                      <button class="editReviewButton" data-commentno="\${cvo.commentNo}">수정</button>
			                      <button class="reportReviewButton" data-commentno="\${cvo.commentNo}">신고</button>
			                      <button class="deleteReviewButton" data-commentno="\${cvo.commentNo}">삭제</button>
			                    </div>
			                  </div>`;
			     }
            html += `</div></div>`;
          }
        } else {
          html = "<div class='no-comments' style='text-align:center; padding: 20px; color: #888;'>작성된 리뷰가 없습니다.</div>";
        }

        if (data.paging && data.commentList && data.commentList.length > 0) {
          let paging = data.paging;
          html += `<div class="pagination">`;
          if (paging.startPage > 1) {
            html += `<a class="paging-link" href="#" data-page="\${paging.startPage - 1}"><</a>`;
          } 
          for (let cnt = paging.startPage; cnt <= paging.endPage; cnt++) {
            if (paging.nowPage == cnt) {
              html += `<a id="default" style="color:#FF5722; cursor:default;">\${cnt}</a>`;
            } else {
              html += `<a class="paging-link" href="#" data-page="\${cnt}">\${cnt}</a>`;
            }
          }	
          if (paging.endPage < paging.lastPage) {
            html += `<a class="paging-link" href="#" data-page="\${paging.endPage + 1}">></a>`;
          }
          html += `</div>`;
        }
			
				// 댓글 출력
	  		commentList.html(html);
	  		
	  		// 별점/좋아요 UI 동기화
	      $(".reviewStar").each(function () { requestAnimationFrame(() => drawStar(this)); });

	      // 페이징 링크에 이벤트 바인딩
	      $(".paging-link").click(function(e) {
	    	  e.preventDefault();
          loadComment(isbn, $(this).data("page"));
        });
		},
		error: function(xhr, status, error){
						 console.error(`AJAX Error: Status ${xhr.status} - ${error}`);  // AJAX 오류 상태 및 에러 메시지 출력
						 alert("댓글 로딩 중 오류가 발생했습니다. 개발자 도구(F12)의 콘솔을 확인해주세요.");
						 console.error("🚨 서버 응답 내용:", xhr.responseText); 
					 }
	});
}

function commentInsert() {
  const content = $('textarea.reviewComment').val();
  const rating = $('#ratingInput').val(); // 정확한 별점 input에서 가져옴
  const liked = $('#commentForm .reviewLikeInput').is(':checked');
	
  if (!userId || userId === 'anonymousUser') {
    alert("로그인 후 댓글을 작성할 수 있습니다.");
    if(confirm("로그인 페이지로 이동하시겠습니까?")) {
      window.location.href = "<%= request.getContextPath() %>/login.do";
    }
    return;
  }

  if (!content.trim()) {
    alert("리뷰 내용을 입력해주세요.");
    return;
  }
  
  const commentData = { isbn: isbn,
									      commentContent: content,
									      commentRating: rating,
									      commentLiked: liked };

  console.log("📝 댓글 작성 요청 데이터:", commentData); // 전송 전 데이터 확인

  $.ajax({
    url : "<%= request.getContextPath()%>/comment/write.do",
    type : "POST",
    data : commentData,  
    success : function(res){
					    	if (res === "Success") {
						      alert("댓글이 성공적으로 등록되었습니다.");
						      // UI 초기화
						      $('textarea.reviewComment').val("");
					        $('#commentForm .reviewLikeInput').prop('checked', false).closest('.reviewLike').removeClass('active');
					        $('#ratingInput').val(0);
					        drawStar($('#ratingInput')[0]);
						
						      loadComment(isbn); // 댓글 목록 새로고침
				    		}else{
			    	    	alert("댓글 등록에 실패했습니다: " + res);
			    	  	}
					  	},
    error : function(xhr){
      				alert("서버 통신 오류가 발생했습니다. (" + xhr.status + ")");
    				}
  });
}

function editReview(commentNo) {
	const commentElement = $("#reviewBox" + commentNo);
  const contentElement = commentElement.find(".reviewContent");
  const ratingValue = commentElement.find(".reviewStar").val() || 0;
  const isLiked = commentElement.find(".reviewLikeInput").is(":checked");

  const editFormHtml = `<div class="reviewEditBox">
												  <div class="reviewIdEditBox">
												  	<div class="reviewLike \${isLiked ? 'active' : ''}">
										          <label>
										          	<input type="checkbox" class="reviewLikeInput" \${isLiked ? 'checked' : ''} />
										          	<span class="heartSymbol">♥</span>
										          </label>
											      </div>
											      <div class="starBox">
											        <label class="starLabel">
											          <input type="range" class="reviewStar" min="0" max="5" step="1" value="\${ratingValue}" oninput="drawStar(this)" />
											          <div class="starsOverlay"></div>
										          </label>
										        </div>
										      </div>
										      <div class="editTextareaWrap">
										        <textarea class="reviewCommentEdit">\${contentElement.text().trim()}</textarea>
										      </div>
										      <div class="editButtonGroup">
										        <button class="saveEditBtn">수정완료</button>
										        <button class="cancelEditBtn">취소</button>
										      </div>
										    </div>`;
	
	const inputElement = $(editFormHtml);
	
	commentElement.hide().after(inputElement);
	drawStar(inputElement.find(".reviewStar")[0]);

	// 취소 버튼
  inputElement.find(".cancelEditBtn").on("click", function () {
	  inputElement.remove();
    commentElement.show();
  });
	
	//'수정완료' 버튼 클릭
  inputElement.find(".saveEditBtn").on("click", function () {
	  const newText = inputElement.find(".reviewCommentEdit").val().trim();
    const newRating = inputElement.find(".reviewStar").val();
    const newLiked = inputElement.find(".reviewLikeInput").is(":checked");

    if(!newText){
      alert("리뷰 내용을 입력해주세요.");
      return;
    }
    
    const modifiedData = { commentNo: commentNo,
							             isbn: isbn,
							             commentContent: newText,
							             commentRating: newRating,
							             commentLiked: newLiked };
    
    console.log("📦 댓글 수정 요청 데이터:", modifiedData);
  
    $.ajax({
      url: "<%= request.getContextPath()%>/comment/modify.do",
      type: "POST",
      data: modifiedData,
      success: function(res){
				    	   if(res === "Success"){
	             	   alert("댓글이 수정되었습니다.");
	                 loadComment(isbn);  // 수정 후 목록 전체 새로고침
	               }else{
	                 alert("댓글 수정에 실패했습니다: " + res);  // 실패 시 수정 폼을 그대로 두어 다시 시도할 수 있게 함
	               }
	             },
      error: function(){
               alert("서버 오류로 인해 수정에 실패했습니다.");
      			 }
    });
  });
}
	
function deleteReview(commentNo){
	$.ajax({
		url : "<%= request.getContextPath()%>/comment/delete.do",
		type : "POST",
		data : {commentNo},
		success : function(result){
								if(result === "Success"){
									alert("댓글이 삭제 되었습니다.");
									loadComment(isbn);
								}else{
									alert("댓글 삭제에 실패하였습니다." + result);
								}
							},
		error: function(){
						alert("삭제 요청 중 오류 발생");
					 }
	});
}

function toggleLove(commentNo, isbn, userId, checkbox){
	console.log("💌 toggleLove 전송:", { commentNo, userId, isbn });

	if(!userId || userId === 'anonymousUser'){
    alert("로그인 후 이용해주세요.");
    checkbox.checked = !checkbox.checked; // 체크박스 원상 복구
    $(checkbox).closest(".reviewLike").toggleClass("active", checkbox.checked);
    return;
  }

  $.ajax({
    url: "<%= request.getContextPath()%>/comment/toggleLove.do",
    method: "POST",
    data: { commentNo, userId, isbn },
    success: function(result){
				    	 if(result === "liked"){
				          }else if(result === "unliked"){
				          }else{
				            alert("좋아요 처리에 실패했습니다.");
				            checkbox.checked = !checkbox.checked; // 원상 복구
				            $(checkbox).closest(".reviewLike").toggleClass("active", checkbox.checked);
				          }
				     },
    error: function(){
			       alert("서버 오류 발생!");
			       checkbox.checked = !checkbox.checked; // 원상 복구
			       $(checkbox).closest(".reviewLike").toggleClass("active", checkbox.checked);
			     }
  });
}
</script>
<sec:authorize access="isAuthenticated()">
	<div id="bookComments">
		<div id="commentLayout">
			<div id="commentTitle">
				전체리뷰
				<c:if test="${not empty bookDetail.commentCount && bookDetail.commentCount > 0}">
          <span style="color:#FF5722;">(${bookDetail.commentCount})</span>
        </c:if>
			</div>
		</div>
		<div id="review">
			<div id="bookComment">
				<h2>리뷰작성</h2>
				<form id="commentForm">
					<div class="bookCommentBox">
						<div class="commentBoxHeader">
							<!-- 좋아요 -->
							<div class="reviewLike">
							  <label>
							    <input type="checkbox" class="reviewLikeInput"  name="commentLiked" />
							    <span class="heartSymbol">♥</span>
							  </label>
							</div>
							<!-- 별점 -->
					    <div class="starBox">
					      <label class="starLabel">
					        <input type="range" class="reviewStar" id="ratingInput" min="0" max="5" step="1" value="0" name="commentRating" oninput="drawStar(this)" />
					        <div class="starsOverlay"></div>
					      </label>
					    </div>
				    </div>
				    <!-- 댓글 -->
				    <textarea class="reviewComment" placeholder="리뷰를 입력해주세요" name="commentContent"></textarea>
				    <!-- 등록 버튼 -->
				    <div class="form-actions">
				    	<button class="bookCommentButton" type="submit">등록</button>
				    </div>
					</div>
				</form>
				<!-- 댓글 목록 출력 시작 -->
				<div class="comment-list"></div>
			</div>
		</div>
	</div>
</sec:authorize>
<sec:authorize access="!isAuthenticated()">
  <div id="bookComments" style="text-align: center; padding: 40px; border-top: 1px solid #eee;">
    <p>리뷰를 작성하시려면 <a href="#" id="openLoginModal" style="color: #FF5722; text-decoration: underline;">로그인</a>이 필요합니다.</p>
    <div class="comment-list"></div> <!-- 비로그인 사용자도 댓글 목록은 볼 수 있도록 -->
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

$(document).ready(function() {

  // --- 장바구니 버튼 클릭 이벤트 ---
  $("#bookChartBtn").on("click", function(event) {
    event.preventDefault();

    let quantity = parseInt($(".num").val()) || 1;
    let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
    if (!Array.isArray(cartItems)) {
        cartItems = Object.values(cartItems).filter(item => typeof item === 'object');
    }

    const newItem = { id: "${bookDetail.isbn}",
							        title: "${bookDetail.title}",
							        price: Number("${bookPrice}"),
							        image: "${bookDetail.image}",
							        quantity: quantity };

    let existingItem = cartItems.find(item => item.id === newItem.id);
    if(existingItem){
      existingItem.quantity += quantity;
    }else{
      cartItems.push(newItem);
    }

    localStorage.setItem("cartItems", JSON.stringify(cartItems));
    updateCartCount();

    if (confirm("장바구니 페이지로 이동하시겠습니까?")) {
      window.location.href = "<%= request.getContextPath() %>/product/cart.do";
    }
  });

});
</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
  const openLoginModalLink = document.getElementById('openLoginModal');
  const loginModal = document.getElementById('loginModal');
  const closeButton = document.getElementById('closeLoginModal');
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
	
  if(openLoginModalLink){
    openLoginModalLink.addEventListener('click', function(event) {
      event.preventDefault();
      if(loginModal){
    	  loginModal.classList.add('show');
      }
    });
  }
  
  if(closeButton){
    closeButton.addEventListener('click', function(){
    	if(loginModal){
        loginModal.classList.remove('show');
      }
    });
  }
  
  if(loginModal){
	  window.addEventListener('click', function(event) {
	    if(event.target == loginModal){
	      loginModal.classList.remove('show');
	    }
	  });
  }
});

$(document).ready(function() {
	$("#bookOrderBtn").on("click", function(event) {
	  event.preventDefault(); // 페이지 이동을 잠시 막습니다.
	  
	  const userId = '<sec:authentication property="name"/>'; 

	  if(!userId || userId === 'anonymousUser'){
	    alert("로그인 후 이용 가능합니다.");
	    
	    const loginModal = document.getElementById('loginModal');
	    
	    if(loginModal){
	      loginModal.classList.add('show');
	    }
	    return;
	  }
	
	  const isbn = $(this).data("isbn");
	  const quantity = $(".num").val();
	  if (!isbn || !quantity || parseInt(quantity) < 1) {
	      alert("오류: 상품 정보나 수량을 가져올 수 없습니다. 페이지를 새로고침 해주세요.");
	      return; // 값이 없으면 여기서 실행을 멈춥니다.
	  }
	  const contextPath = '<%= request.getContextPath() %>';
	  
	  window.location.href = contextPath + "/order/orderMain.do?isbn=" + isbn + "&quantity=" + quantity;
	});
});
</script>
</body>
</html>
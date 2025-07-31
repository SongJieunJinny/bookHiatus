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
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/book/bookView.css"/>
</head>
<body>
<sec:authorize access="isAuthenticated()">
  <script>const isLoggedIn = true;</script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
	<c:choose>
	  <c:when test="${not empty bookDetail.discount and bookDetail.discount > 0}">
	    <c:set var="bookPrice" value="${bookDetail.discount}" />
	  </c:when>
	  <c:otherwise>
	    <c:set var="bookPrice" value="0" />
	  </c:otherwise>
	</c:choose>
	
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
				<div id="bookStatusMessage">
			    <c:choose>
		        <c:when test="${bookDetail.bookState == 0}">
	            <div >품절되었습니다.</div>
		        </c:when>
		        <c:when test="${bookDetail.bookStock <= 0}">
	            <div >재고가 없습니다.</div>
		        </c:when>
			    </c:choose>
				</div>
				
				<div id="bookCheckBtn">
			    <c:choose>
		        <c:when test="${bookDetail.bookState == 0 || bookDetail.bookStock <= 0}">
	            <div>
                <button id="bookChartBtn" disabled style="background-color: #ccc; cursor: not-allowed;">장바구니</button>
	            </div>
	            <div>
                <button id="bookOrderBtn" type="button" disabled style="background-color: #ccc; cursor: not-allowed;">바로구매</button>
	            </div>
	          </c:when>
	          <c:otherwise>
	            <div>
                <button id="bookChartBtn">장바구니</button>
	            </div>
	            <div>
                <button id="bookOrderBtn" type="button" data-isbn="${bookDetail.isbn}">바로구매</button>
	            </div>
		        </c:otherwise>
			    </c:choose>
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
		<div id="bookComments">
		<div id="commentLayout">
			<div id="commentTitle">
				전체리뷰
				<c:if test="${not empty bookDetail.commentCount && bookDetail.commentCount > 0}">
          <span style="color:#FF5722;">(${bookDetail.commentCount})</span>
        </c:if>
			</div>
		</div>
		<sec:authorize access="isAuthenticated()">
			<div id="review">
				<div id="bookComment">
					<h2>리뷰작성</h2>
					<form id="commentForm">
						<div class="bookCommentBox">
							<div class="commentBoxHeader">
								<div class="reviewLike"><!-- 좋아요 -->
								  <label>
								    <input type="checkbox" class="reviewLikeInput"  name="commentLiked" />
								    <span class="heartSymbol">♥</span>
								  </label>
								</div>
								<div class="starBox"><!-- 별점 -->
						      <label class="starLabel">
						        <input type="range" class="reviewStar" id="ratingInput" min="0" max="5" step="1" value="0" name="commentRating" oninput="drawStar(this)" />
						        <div class="starsOverlay"></div>
						      </label>
						    </div>
					    </div>
					    <textarea class="reviewComment" placeholder="리뷰를 입력해주세요" name="commentContent"></textarea><!-- 댓글 -->
					    <div class="form-actions"><!-- 등록 버튼 -->
						    <button class="bookCommentButton" type="submit">등록</button>
					    </div>
						</div>
					</form>
				</div>
			</div>
		</sec:authorize>
		<sec:authorize access="!isAuthenticated()">
	    <div style="text-align: center; padding: 40px; border-top: 1px solid #eee;">
	      <p>리뷰를 작성하시려면 <a href="#" id="openLoginModal" style="color: #FF5722; text-decoration: underline;">로그인</a>이 필요합니다.</p>
	    </div>
		</sec:authorize>
		<%-- 댓글 목록은 로그인 여부와 관계없이 표시 --%>
		<div class="comment-list"></div>
	</div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script type="text/javascript">
const BOOK_ISBN = "${bookDetail.isbn}";
const userId = '<sec:authentication property="name" />';
const userRole = '<sec:authentication property="authorities" htmlEscape="false" />';
const contextPath = '<%= request.getContextPath() %>';

$(document).ready(function() {

  updateCartCount(); 
  if (typeof initHeaderEvents === "function") {
    initHeaderEvents(); // header.jsp에 있을 가능성 있는 함수
  }
  if (isLoggedIn) {
    syncLocalCartToDB(); // 로그인 시 동기화
  }

  // 댓글 로딩
  if(BOOK_ISBN){
    console.log("loadComment 호출 전 BOOK_ISBN =", BOOK_ISBN);
    loadComment(BOOK_ISBN);
  }else{
    console.error("🚨 BOOK_ISBN이 비어 있어 댓글을 불러올 수 없습니다.");
  }

  // 옵션 메뉴 토글
  $(document).on('click', '.reviewOptions', function(e){
    e.stopPropagation();
    let commentNo = $(this).data("reviewBox");
    $(".optionsMenu").hide();
    $("#optionsMenu" + commentNo).toggle();
  });
  $(document).click(() => $(".optionsMenu").hide());
  $(document).on('click', '.optionsMenu', e => e.stopPropagation());

  // 댓글 작성
  $("#commentForm").on("submit", function(e){
    e.preventDefault();
    commentInsert();
  });

  // 수정, 삭제, 신고 버튼
  $(document).on('click', '.editReviewButton', function(){
    editReview($(this).data("commentno"));
  });
  $(document).on('click', '.deleteReviewButton', function(){
    deleteReview($(this).data("commentno"));
  });
  $(document).on('click', '.reportReviewButton', function(){
    reportReview($(this).data("commentno"));
  });

  // 좋아요 체크
  $(document).on("change", "div.comment-list .reviewLikeInput", function(){
    const commentNo = $(this).data("commentno");
    if (commentNo) {
      toggleLove(commentNo, BOOK_ISBN, userId, this);
    }
  });
  $(document).on("change", ".reviewLikeInput", function(){
    $(this).closest(".reviewLike").toggleClass("active", this.checked);
  });

  // 장바구니 버튼
  $("#bookChartBtn").on("click", function(){
    const quantity = parseInt($(".num").val()) || 1;
    const title = "${bookDetail.title}";
    const price = ${bookDetail.discount};
    const image = "${bookDetail.image}";
    const bookNo = ${bookDetail.bookNo};

    if(!userId || userId === 'anonymousUser'){
      // 비회원 로컬스토리지
      let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
      const existing = cartItems.find(item => item.bookNo === bookNo || item.id === BOOK_ISBN);
      if (existing) {
        if(!confirm("이미 장바구니에 있는 도서입니다. 수량을 추가하시겠습니까?")){
          return;
        }
        existing.quantity += quantity;
      }else{
        cartItems.push({ id: BOOK_ISBN, bookNo, title, price, image, quantity });
      }
      localStorage.setItem("cartItems", JSON.stringify(cartItems));
      updateCartCount();
      alert("장바구니에 담았습니다.");
      if(confirm("장바구니 페이지로 이동하시겠습니까?")){
        window.location.href = contextPath + "/product/cart.do";
      }
      return;
    }

    $.get(contextPath + "/product/getCartCount.do",
      { bookNo: bookNo, userId: userId },
      function(existingCount) {
        const finalCount = (parseInt(existingCount) || 0) + quantity;
        $.ajax({ url: contextPath + "/product/addOrUpdateCart.do",
			           type: "POST",
			           contentType: "application/json",
			           data: JSON.stringify({ userId: userId, bookNo: parseInt(bookNo, 10), count: finalCount }),
			           success: function(res){
								            if (res === "DB_OK"){
								              alert("장바구니에 새 도서를 추가했습니다.");
								            }else if(res === "EXISTING_UPDATED"){
								              alert("장바구니 수량이 갱신되었습니다.");
								            }else{
								              alert("장바구니 처리 실패: " + res);
								            }
								            updateCartCount();
								            if(confirm("장바구니 페이지로 이동하시겠습니까?")){
								              window.location.href = contextPath + "/product/cart.do";
								            }
								          },
			           error: function(){
							            alert("서버 오류로 장바구니 저장에 실패했습니다.");
							          }
        });
      });
  });

  // 바로구매 버튼
  $("#bookOrderBtn").on("click", function(event){
    event.preventDefault();
    if(!userId || userId === 'anonymousUser'){
      alert("로그인 후 이용 가능합니다.");
      const loginModal = document.getElementById('loginModal');
      if (loginModal) loginModal.classList.add('show');
      return false;
    }

    const quantity = $(".num").val();
    if(!BOOK_ISBN || !quantity || parseInt(quantity) < 1){
      alert("오류: 상품 정보나 수량을 가져올 수 없습니다.");
      return false;
    }

    const targetUrl = contextPath + "/order/orderMain.do?isbn=" +
                      encodeURIComponent(BOOK_ISBN) + "&quantity=" +
                      encodeURIComponent(quantity);
    console.log("이동할 URL:", targetUrl);
    window.location.href = targetUrl;
  });
  
  const minusBtn = document.querySelector(".minus");
  const plusBtn = document.querySelector(".plus");
  const numInput = document.querySelector(".num");
  const totalPrice = document.getElementById("totalPrice");

  // null 체크 추가: 버튼이 있을 때만 로직 실행
  if(minusBtn && plusBtn && numInput && totalPrice) {
    const unitPrice = ${bookDetail.discount != null ? bookDetail.discount : 0};
    const maxStock = ${bookDetail.bookStock != null ? bookDetail.bookStock : 0};

    const updateTotalPrice = () => {
	    let qty = parseInt(numInput.value) || 1;
	    if (qty < 1) qty = 1;
	    if(maxStock > 0 && qty > maxStock) qty = maxStock;
	    numInput.value = qty;
	    totalPrice.textContent = (unitPrice * qty).toLocaleString() + "원";
	  };

	  minusBtn.addEventListener("click", () => {
	    if(parseInt(numInput.value) > 1){
	      numInput.value = parseInt(numInput.value) - 1;
	      updateTotalPrice();
	    }
	  });

	  plusBtn.addEventListener("click", () => {
	    const current = parseInt(numInput.value) || 1;
	    if(current < maxStock){
	      numInput.value = current + 1;
	      updateTotalPrice();
	    }else{
	    	alert("도서는 최대 " + maxStock + "권까지 구매 가능합니다.");
	    }
	  });

	  numInput.addEventListener("input", () => {
	    numInput.value = numInput.value.replace(/[^0-9]/g, '');
	    let value = parseInt(numInput.value) || 1;
	    if (value < 1) value = 1;
	    if (maxStock > 0 && value > maxStock) {
	      alert("도서는 최대 " + maxStock + "권까지 구매 가능합니다.");
	      value = maxStock;
	    }
	    numInput.value = value;
	    updateTotalPrice();
	  });

  	updateTotalPrice();
  	
  }
  
  const openLoginModalLink = document.getElementById('openLoginModal');
  const loginModal = document.getElementById('loginModal');
  const closeButton = document.getElementById('closeLoginModal');
  
  const setToggleButton = (button, isExpanded, contextPath) => {
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
  };

  document.querySelectorAll(".toggle-btn").forEach(function (btn) {
    const targetId = btn.getAttribute("data-target");
	  const target = document.getElementById(targetId);
	  if (!target) return;
	  if (target.scrollHeight <= 160) {
	    btn.style.display = "none";
	    return;
	  }
	  setToggleButton(btn, false, contextPath);
	  btn.addEventListener("click", function(){
      const isExpanded = target.classList.contains("expanded");
	    target.classList.toggle("expanded");
	    setToggleButton(btn, !isExpanded, contextPath);
	  });
  });

  if (openLoginModalLink) {
	  openLoginModalLink.addEventListener('click', function(event){
	    event.preventDefault();
	    if (loginModal) loginModal.classList.add('show');
	  });
  }
  if (closeButton) {
	  closeButton.addEventListener('click', function(){
	    if (loginModal) loginModal.classList.remove('show');
	  });
  }
  if (loginModal) {
	  window.addEventListener('click', function(event){
	    if (event.target == loginModal) {
	      loginModal.classList.remove('show');
	      }
	  });
  }
  
});

//두번째 변수 생략시 1로 들어감
function loadComment(isbn, page = 1) {
	if (!BOOK_ISBN) {
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
  
  const commentData = { BOOK_ISBN: isbn,
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
    		                   BOOK_ISBN: isbn,
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

function toggleLove(commentNo, BOOK_ISBN, userId, checkbox){
	console.log("💌 toggleLove 전송:", { commentNo, userId, BOOK_ISBN });

	if(!userId || userId === 'anonymousUser'){
    alert("로그인 후 이용해주세요.");
    checkbox.checked = !checkbox.checked; // 체크박스 원상 복구
    $(checkbox).closest(".reviewLike").toggleClass("active", checkbox.checked);
    return;
  }

  $.ajax({
    url: "<%= request.getContextPath()%>/comment/toggleLove.do",
    method: "POST",
    data: { commentNo, userId, BOOK_ISBN },
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

//비회원 장바구니 로컬스토리지 가져오기
function getCartItemsFromLocalStorage() {
  const raw = localStorage.getItem("cartItems");
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : Object.values(parsed).filter(i => typeof i === 'object');
  } catch (e) {
    console.error("localStorage 파싱 오류", e);
    return [];
  }
}

// 장바구니 개수 업데이트 (bookView.jsp에서는 카운트만 갱신)
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

// 로그인 시 로컬 장바구니를 DB로 동기화 (bookView에서는 카운트만 업데이트)
function syncLocalCartToDB() {
  const localItems = getCartItemsFromLocalStorage();
  if (!localItems.length) {
    fetchCartCountFromDB(); // DB에서 카운트 가져오기
    return;
  }
  const payload = localItems
    .filter(i => (i.quantity || i.count || 1) > 0)
    .map(i => ({
      userId: i.userId || '',
      bookNo: i.bookNo,
      count: i.quantity || i.count || 1
    }));

  return $.ajax({
    url: contextPath + "/product/syncCart.do",
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify(payload),
    success: function () {
      console.log("장바구니 동기화 완료");
      localStorage.removeItem("cartItems");
      fetchCartCountFromDB(); // 동기화 후 DB 기준으로 다시 카운트 가져오기
    },
    error: function (xhr) {
      console.error("동기화 실패:", xhr.responseText);
    }
  });
}

function fetchCartCountFromDB() {
  $.get(contextPath + "/product/getCartCount.do", function(count) {
    const cartCountElement = document.getElementById("cart-count");
    if (cartCountElement) {
      cartCountElement.textContent = count;
      cartCountElement.style.visibility = count > 0 ? "visible" : "hidden";
    }
  });
}

</script>
</body>
</html>
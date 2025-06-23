<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>eventView</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/event.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<div id="navEvent">
      <div id="eventHead">
        <div id="event">EVENT</div>
      </div>
      <div id="eventMid">
        <div id="eventViewTable">
          <div id="titleViewDiv">
            <div id="titleView">${vo.boardTitle}</div>
          </div>
          <div id="writeRrdateViewDiv">
            <span id="writerView">${vo.userId}</span>
            <span id="rdateView">
            	<fmt:formatDate value="${vo.boardRdate}" pattern="yyyy-MM-dd" />
            </span>
          </div>
          <div id="contentViewDiv">
            <div id="contentView">${vo.boardContent}</div>
          </div>
        </div><br>
				<div id="eventViewBtn">
					<!-- 어드민 -->
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_ADMIN'}">
				    <form id="eventViewwriteForm" name="deletefrm" action="eventDelete.do" method="post">
				      <input type="hidden" name="boardNo" value="${vo.boardNo}">
				      <button id="modifyView" onclick="return confirmModify();">수정하기</button>&nbsp;&nbsp;&nbsp;
				      <button id="deleteView" onclick="return confirmDelete();">삭제하기</button>
				    </form>
				  </c:if>
					<!-- 모두가 -->
				  <a href="<%= request.getContextPath() %>/eventList.do?boardType=3">    
					  <button id="listView">목록으로</button>
					</a>
				</div>
			</div>
		<script>
			let boardNo = "";
			let boardType = "";
			let userId = '<sec:authentication property="name" />';
			let userRole = '<sec:authentication property="authorities" htmlEscape="false" />';
			
			console.log("✅ userId:", userId);
			console.log("✅ userRole:", userRole);
			
			$(document).ready(function() {
				boardNo = ${vo.boardNo};
				boardType = ${vo.boardType};
				
				console.log(boardNo);
		    loadComment(boardNo);
		       
		    // 메뉴 버튼 이벤트 초기화
		    $(document).on('click', '.eventOptions', function(event) {
		     event.stopPropagation(); // 이벤트 전파 방지
		     let eCommentNo = $(this).data("eventBox");
		     $(".eventOptionsMenu").hide(); // 다른 메뉴 숨김
		     $("#eventOptionsMenu" + eCommentNo).toggle(); // 현재 메뉴 토글
		    });
		
		    // 문서의 다른 곳 클릭하면 모든 메뉴 숨김
		    $(document).click(function() {
		    	$(".eventOptionsMenu").hide();
		    });
		
		    // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
		    $(document).on('click', '.eventOptionsMenu', function(event) {
		    	event.stopPropagation();
		    });
			});
			
			//두번째 변수 생략시 1로 들어감
			function loadComment(boardNo,page = 1) {
				const boardWriter = '${vo.userId}'; 
				console.log("📥 loadComment 호출됨: boardNo =", boardNo, "page =", page); 
				
		    $.ajax({
		      url: "<%= request.getContextPath()%>/eComment/loadComment.do",
		      type: "get",
		      data: { boardNo: boardNo , cnowpage:page },
		      success : function(data) { 
							    	  let html = "";
						for(ecvo of data.clist){
							html +=`<div id="eventBox\${ecvo.eCommentNo}" class="eventBox">
												<div class="eventIdBox">
													<div class="eventId">\${ecvo.userId}</div>
													<div style="color: gray; font-size: 15px; margin-top: 0.2%; margin-left: 1%; margin-right: 1%;">|</div>
													<div class="eventRdate">\${ecvo.formattedECommentRdate}</div>
												</div>
												<div id="commentContentContainer\${ecvo.eCommentNo}" class="eventContainer">
													<div class="eventContentArea">\${ecvo.eCommentContent}</div>`;
								if(userRole.includes("ROLE_ADMIN") || (ecvo.userId && ecvo.userId.trim() === userId.trim())){
									html +=`<div class="eventOptions" data-event-box="\${ecvo.eCommentNo}">⋯
											      <div id="eventOptionsMenu\${ecvo.eCommentNo}" class="eventOptionsMenu">
											        <button onclick="commentUpdate(\${ecvo.eCommentNo})">수정</button>
											        <button onclick="commentDel(\${ecvo.eCommentNo})">삭제</button>
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
						      
								      // 페이징 링크에 이벤트 바인딩
								      $(".paging-link").click(function(e) {
									        e.preventDefault();
									        let page = $(this).data("page");
									        loadComment(boardNo, page);
								      });
										},
					error: function(xhr, status, error) {
									console.error("AJAX Error:", status, error);  // AJAX 오류 상태 및 에러 메시지 출력
									alert("댓글 로딩 중 오류가 발생했습니다.");
								 }
				});
			}
			
			function commentInsert(boardNo,boardType){
				
			  $.ajax({
			    url : "<%= request.getContextPath()%>/eComment/write.do",
			    type : "post",
			    data : { boardNo : boardNo,
						       boardType : boardType,
				      		 eCommentContent : $("#eventCommentContent").val() },
			    success : function (result){
								      if(result === "Success"){
								        alert("댓글이 등록되었습니다.");
								        $("#eventCommentContent").val(""); 
								        loadComment(boardNo);
								      }else{
								        alert("등록에 실패했습니다.");
								      }
								    },
			    error : function(){
			      alert("서버 통신 오류가 발생했습니다.");
			    }
			  });
			}
			
			function commentUpdate(eCommentNo){
				
				const commentElement = $("#eventBox" + eCommentNo);
				const currentText = $("#commentContent" + eCommentNo).text().trim();
				const inputElement = $(`<div id="eventCommentContentBox">
																		<textarea id="eventCommentContent-\${eCommentNo}" class="eventCommentContent" name="eCommentContent">\${currentText}</textarea>
																		<div id="eventCommentButtonBox">
																			<button class="save-btn">수정완료</button>
																			<button class="cancel-btn">취소</button>
																		</div>
																	</div>`);
				  
				commentElement.replaceWith(inputElement);
			  
				inputElement.find(".cancel-btn").on("click", function (e) {
					e.preventDefault();
					inputElement.replaceWith(commentElement); 
				});
			
				inputElement.find(".save-btn").on("click", function (e) {
					e.preventDefault();
			    	
					const newText = inputElement.find(`#eventCommentContent-\${eCommentNo}`).val(); 
			
			    if(newText && newText !== currentText) {
			    	saveComment(eCommentNo, newText, inputElement, commentElement); 
			    }else{
			    	alert("댓글 내용이 비어있거나 변경되지 않았습니다.");
			    }
				});
			}
			
			function saveComment(eCommentNo, newText, inputElement,commentElement){
				
				const originalElement = commentElement.text(inputElement.val().trim());
				
				$.ajax({
					url : "<%= request.getContextPath()%>/eComment/modify.do",
					type : "post",
					data : { eCommentNo : eCommentNo,
									 eCommentContent : newText,
									 userId : userId },
					success : function(result){
											if(result === "Success"){
												const updatedElement = $("#commentContent" + eCommentNo).text(newText);
				            		inputElement.replaceWith(updatedElement);
				            		loadComment(boardNo);
											}else{
												inputElement.replaceWith(originalElement);
												alert("댓글 수정에 실패하였습니다.");
											}
										},
					error: function () {
									alert("서버 오류로 인해 수정에 실패했습니다.");
			      			inputElement.replaceWith(originalElement);
			    			 }
				});
			}
			
			function commentDel(eCommentNo){
				$.ajax({
					url : "<%= request.getContextPath()%>/eComment/delete.do",
					type : "post",
					data : {eCommentNo : eCommentNo},
					success : function(result){
											if(result === "Success"){
												loadComment(boardNo);
												alert("댓글이 삭제 되었습니다.");
											}else{
												alert("댓글 삭제에 실패하였습니다.");
											}
										}
				});
			}
		</script>
			<sec:authorize access="isAuthenticated()">
				<div id="eventEnd">
			    <div id="eventComments">
			      <div id="commentLayout">
			        <div id="eventCommentTitle">
			        	EVENT<a href="eventView.do?boardNo=${eventVo.boardNo}&boardType=3">${eventVo.boardTitle}
		          		<c:if test="${eventVo.eCommentCount > 0}">
										<span style="color:#FF5722;">(${eventVo.eCommentCount})</span>
									</c:if>
								</a>
			        </div>
			      </div>
			      <div id="reviewView">
			        <div id="eventComment">
			          <h2>&nbsp;EVENT</h2>
			          <div id="eventCommentContentBox">
			            <textarea id="eventCommentContent" name="eCommentContent"></textarea>
			            <div id="eventCommentButtonBox">
			              <button id="eventCommentButton" onclick="commentInsert(${vo.boardNo},${vo.boardType});">등록</button>
			            </div>
			          </div>
								<!-- 댓글 목록 출력 시작 -->
								<div class="comment-list">
								</div>
		          	<!-- 댓글 목록 출력 끝 -->
			        </div>
			      </div>
			    </div>
			    <!-- 댓글 입력란 종료 -->
				</div>
			</sec:authorize>
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
	</script>
		<script>
  function confirmDelete() {
    let isConfirmed = confirm("정말 삭제하시겠습니까?"); 
    if (isConfirmed) {
      document.deletefrm.submit(); // 삭제 요청 실행
    }
  }
	</script>
  <script>
	$(document).ready(function() {		
		$('#modifyView').click(function() {
			  window.location.href = '<%=request.getContextPath()%>/eventModify.do';
		});
	});
	</script>
</body>
</html>
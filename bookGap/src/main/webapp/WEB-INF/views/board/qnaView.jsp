<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>qnaView</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/qna.css"/>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
  	<div id="navQna">
      <div id="qna">QnA</div>
      <div id="qnaMid">
        <div id="qnaViewTable">
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
				<div id="qnaViewBtn">
					<!-- 글쓴이랑 어드민이랑 -->
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username eq vo.userId || 
				               sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_ADMIN'}">
				    <form name="deletefrm" action="qnaDelete.do" method="post">
				      <input type="hidden" name="boardNo" value="${vo.boardNo}">
				      <button id="writeView" onclick="return confirmDelete();">삭제하기</button>&nbsp;&nbsp;&nbsp;
				    </form>
				  </c:if>
					<!-- 글쓴이만 -->
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username eq vo.userId}">
				    <a href="qnaModify.do?boardNo=${vo.boardNo}" style="text-decoration: none;">
				      <button id="modifyView">수정하기</button>
				    </a>
				  </c:if>
					<!-- 모두가 -->
				  <a href="<%= request.getContextPath() %>/qnaList.do?boardType=2">    
					  <button id="listView">목록으로</button>
					</a>
				</div>
				<br>
			</div>
	<sec:authentication var="loginUser" property="principal" />
  <script type="text/javascript">
		let boardNo = "";
		let boardType = "";
	  let userId = '${loginUser.username}';
	  let userRole = '${loginUser.authorities}';
	  console.log("✅ 로그인된 사용자 ID:", userId);
	  console.log("✅ 로그인된 사용자 권한:", userRole);
	  
		$(document).ready(function() {
			boardNo = ${vo.boardNo};
			boardType = ${vo.boardType};
			
			console.log(boardNo);
	    loadComment(boardNo);
	       
	    // 메뉴 버튼 이벤트 초기화
	    $(document).on('click', '.qnaOptions', function(event) {
	     event.stopPropagation(); // 이벤트 전파 방지
	     let qCommentNo = $(this).data("qnaBox");
	     $(".qnaOptionsMenu").hide(); // 다른 메뉴 숨김
	     $("#qnaOptionsMenu" + qCommentNo).toggle(); // 현재 메뉴 토글
	    });
	
	    // 문서의 다른 곳 클릭하면 모든 메뉴 숨김
	    $(document).click(function() {
	    	$(".qnaOptionsMenu").hide();
	    });
	
	    // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
	    $(document).on('click', '.qnaOptionsMenu', function(event) {
	    	event.stopPropagation();
	    });
		});

		//두번째 변수 생략시 1로 들어감
		function loadComment(boardNo,page = 1) {
			const boardWriter = '${vo.userId}'; 
			console.log("📥 loadComment 호출됨: boardNo =", boardNo, "page =", page); 
			
	    $.ajax({
	      url: "<%= request.getContextPath()%>/qComment/loadComment.do",
	      type: "get",
	      data: { boardNo: boardNo , cnowpage:page },
	      success : function(data) { 
						    	  let html = "";
										for(qcvo of data.clist){
											html +=`<div id="qnaBox\${qcvo.qCommentNo}" class="qnaBox">
																<div class="qnaIdBox">
																	<div class="qnaId">\${qcvo.userId}</div>
																	<div style="color: gray; font-size: 15px; margin-top: 0.2%; margin-left: 1%; margin-right: 1%;">|</div>
																	<div class="qnaRdate">\${qcvo.formattedQCommentRdate}</div>
																</div>
																<div id="commentContentContainer\${qcvo.qCommentNo}" class="qnaContainer">
																	<div class="qnaContentArea">\${qcvo.qCommentContent}</div>`;
	if(qcvo.userId &&(qcvo.userId.trim() === userId.trim() || userRole.includes("ROLE_ADMIN"))){
													html +=`<div class="qnaOptions" data-qna-box="\${qcvo.qCommentNo}">⋯
															      <div id="qnaOptionsMenu\${qcvo.qCommentNo}" class="qnaOptionsMenu">
															        <button onclick="commentUpdate(\${qcvo.qCommentNo})">수정</button>
															        <button onclick="commentDel(\${qcvo.qCommentNo})">삭제</button>
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
			
			if (!(userId === '${vo.userId}' || userRole.includes("ROLE_ADMIN"))) {
		    alert("댓글 작성 권한이 없습니다.");
		    return;
		  }
			
		  $.ajax({
		    url : "<%= request.getContextPath()%>/qComment/write.do",
		    type : "post",
		    data : { boardNo : boardNo,
					       boardType : boardType,
					       userId : userId,
			      		 qCommentContent : $("#qnaCommentContent").val() },
		    success : function (result){
							      if(result === "Success"){
							        alert("댓글이 등록되었습니다.");
							        $("#qnaCommentContent").val(""); 
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
		
		function commentUpdate(qCommentNo){
			
		  const commentElement = $("#qnaBox" + qCommentNo);
		  const currentText = $("#commentContent" + qCommentNo).text().trim();
		  
		  const inputElement = $(`<div id="qnaCommentContentBox">
																<textarea id="qnaCommentContent-\${qCommentNo}" class="qnaCommentContent" name="qCommentContent">\${currentText}</textarea>
																<div id="qnaCommentButtonBox">
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
		    	
					const newText = inputElement.find(`#qnaCommentContent-\${qCommentNo}`).val(); 
		
		    	if(newText && newText !== currentText) {
		      	saveComment(qCommentNo, newText, inputElement, commentElement); 
		    	}else{
		      	alert("댓글 내용이 비어있거나 변경되지 않았습니다.");
		    	}
		  	});
		}
		
		function saveComment(qCommentNo, newText, inputElement,commentElement){
			
			const originalElement = commentElement.text(inputElement.val().trim());
			
			$.ajax({
				url : "<%= request.getContextPath()%>/qComment/modify.do",
				type : "post",
				data : { qCommentNo : qCommentNo,
								 qCommentContent : newText,
								 userId : userId },
				success : function(result){
										if(result === "Success"){
											const updatedElement = $("#commentContent" + qCommentNo).text(newText);
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
		
		function commentDel(qCommentNo){
			$.ajax({
				url : "<%= request.getContextPath()%>/qComment/delete.do",
				type : "post",
				data : {qCommentNo : qCommentNo},
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
  			<c:if test="${loginUser.username eq vo.userId or fn:contains(loginUser.authorities, 'ROLE_ADMIN')}">         
					<!-- 댓글 입력란 시작 -->
				  <div id="qnaEnd">
				    <div id="qnaComments">
				      <div id="commentLayout">
				        <div id="qnaCommentTitle">
				        	QnA
				        </div>
				      </div>
				      <div id="reviewView">
				        <div id="qnaComment">
				          <h2>&nbsp;QnA</h2>
				          <div id="qnaCommentContentBox">
				            <textarea id="qnaCommentContent" name="qCommentContent"></textarea>
				          </div>
				            <div id="qnaCommentButtonBox">
				              <button id="qnaCommentButton" onclick="commentInsert(${vo.boardNo},${vo.boardType});">등록</button>
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
			  </c:if>
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
			  window.location.href = '<%=request.getContextPath()%>/qnaModify.do';
		});
	});
	</script>
</body>
</html>
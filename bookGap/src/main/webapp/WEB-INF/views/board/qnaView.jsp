<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
      <div id="qnaHead">
        <div id="qna">QnA</div>
      </div>
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
				
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username eq vo.userId || 
				               sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.userAuthority eq 'ROLE_ADMIN'}">
				    <form id="qnaViewwriteForm" name="deletefrm" action="qnaDelete.do" method="post" style="display: inline-flex;">
				      <input type="hidden" name="boardNo" value="${vo.boardNo}">
				      <button id="writeView" onclick="return confirmDelete();">삭제하기</button>&nbsp;&nbsp;&nbsp;
				    </form>
				  </c:if>
				
				  <c:if test="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username eq vo.userId}">
				    <a href="qnaModify.do?boardNo=${vo.boardNo}" style="text-decoration: none;">
				      <button id="modifyView">수정하기</button>
				    </a>&nbsp;&nbsp;&nbsp;
				  </c:if>
				
				  <a href="<%= request.getContextPath() %>/qnaList.do?boardType=2">    
					  <button id="listView">목록으로</button>
					</a>
				
				</div>
      </div>
      
     <!-- 댓글라인 -->
      <div id="qnaEnd">
        <div id="qnaComments">
          <div id="commentLayout">
            <div id="qnaCommentTitle">QnA(1)</div>
          </div>
          <div id="reviewView">
            <div id="qnaComment">
              <h2>&nbsp;QnA</h2>
              <form onsubmit="return qnaContentForm(this)">
                <div id="qnaCommentContentBox">
                  <textarea id="qnaCommentContent" name="content"></textarea>
                  <div id="qnaCommentButtonBox">
                    <button id="qnaCommentButton">등록</button>
                  </div>
                </div>
              </form>
              <div class="qnaBox">
                <div class="qnaIdBox">
                  <div class="qnaId">관리자</div>
                  <div style="color: gray; font-size: 15px; margin-top: 0.2%; margin-left: 1%; margin-right: 1%;">|</div>
                  <div class="qnaRdate">2024-01-26</div>
                </div>
                <!-- 기존 리뷰 내용 -->
                <div class="qnaContainer">
                  <textarea class="qnaContentArea">설 연휴는 택배사 휴무기간이라 설 연휴가 끝난 후 부터 발송시작이 됩니다.
                  </textarea>
                  <div class="qnaOptions">
                    <span class="qnaOptionsToggle" onclick="toggleOptions(this)">⋯</span>
                    <div class="qnaOptionsMenu">
                      <button onclick="qnaOptionModify(this)">수정</button>
                      <button onclick="qnaOptionDelete(this)">삭제</button>
                    </div>
                  </div>
                  <div class="qnaEditButtons">
                    <button onclick="qnaEditCompl(this)">수정완료</button>
                    <button onclick="qnaEditCancel(this)">취소</button>
                  </div>
                </div>
              </div>
            </div>                        
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
	<script>
	// QNA 댓글 ...토글 버튼 클릭 이벤트 (옵션 메뉴 열기/닫기)
	function toggleOptions(element) {
    let menu = element.nextElementSibling;
    if (menu.style.display === "block") {
        menu.style.display = "none";
    } else {
        // 다른 열린 메뉴 닫기
        document.querySelectorAll(".qnaOptionsMenu").forEach(menu => menu.style.display = "none");
        menu.style.display = "block";
    }
	}

	// 수정 기능 (예제)
	function qnaOptionModify(button) {
            alert("수정 기능이 실행됩니다!");
        }

        // 삭제 기능 (예제)
        function qnaOptionDelete(button) {
            if (confirm("정말 삭제하시겠습니까?")) {
                alert("삭제되었습니다.");
            }
        }

// QNA 수정 버튼 클릭 이벤트
function qnaOptionModify(button) {
    let qnaBox = button.closest('.qnaBox');
    let qnaContentArea = qnaBox.querySelector('.qnaContainer textarea');
    let qnaOptionsMenu = qnaBox.querySelector('.qnaOptionsMenu');
    let qnaEditButtons = qnaBox.querySelector('.qnaEditButtons');

    // 기존 값 저장 (취소 시 복구)
    qnaContentArea.dataset.originalText = qnaContentArea.value;

    // 수정 가능하도록 설정
    qnaContentArea.removeAttribute('readonly');

    // 옵션 메뉴 숨기기
    qnaOptionsMenu.style.display = "none";

    // 수정 완료 & 취소 버튼 표시
    $(qnaEditButtons).fadeIn();
}

// 수정 완료 버튼 클릭 이벤트
function qnaEditCompl(button) {
    let qnaBox = button.closest('.qnaBox');
    let qnaContentArea = qnaBox.querySelector('.qnaContainer textarea');
    let qnaOptionsMenu = qnaBox.querySelector('.qnaOptionsMenu');
    let qnaEditButtons = qnaBox.querySelector('.qnaEditButtons');

    // 변경된 값 저장
    let newContent = qnaContentArea.value;
    console.log(`새 리뷰 내용: ${newContent}`);

    // 수정 완료 후 다시 읽기 전용 설정
    qnaContentArea.setAttribute('readonly', 'readonly');

    // 옵션 메뉴 다시 보이기
    qnaOptionsMenu.style.display = "block";

    // 수정 완료 & 취소 버튼 숨기기
    $(qnaEditButtons).fadeOut();
}

// 수정 취소 버튼 클릭 이벤트
function qnaEditCancel(button) {
    let qnaBox = button.closest('.qnaBox');
    let qnaContentArea = qnaBox.querySelector('.qnaContainer textarea');
    let qnaOptionsMenu = qnaBox.querySelector('.qnaOptionsMenu');
    let qnaEditButtons = qnaBox.querySelector('.qnaEditButtons');

    // 원래 값으로 복구
    qnaContentArea.value = qnaContentArea.dataset.originalText;

    // 수정 취소 후 다시 읽기 전용 설정
    qnaContentArea.setAttribute('readonly', 'readonly');

    // 옵션 메뉴 다시 보이기
    qnaOptionsMenu.style.display = "block";

    // 수정 완료 & 취소 버튼 숨기기
    $(qnaEditButtons).fadeOut();
}
	</script>
</body>
</html>
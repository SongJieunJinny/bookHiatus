<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>eventWrite</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/board/event.css"/>
	
	<style>
      /* 책 선택 영역을 위한 추가 스타일 */
      #searchBookBtn {
          border: 1px solid #333; background-color: #fff; color: #333;
          font-size: 16px; border-radius: 8px; cursor: pointer;
          padding: 10px 15px; margin-left: 1%;
      }
      #searchBookBtn:hover { background-color: #f0f0f0; }
      #selectedBookArea {
          display: flex; align-items: center; gap: 15px;
          margin-left: 20px; font-size: 16px;
      }
      #selectedBookArea img { width: 50px; border: 1px solid #ddd; }
  </style>
	
</head>
<body>
<sec:authorize access="isAuthenticated()">
  <script>
    const isLoggedIn = true;
  </script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
  <jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="eventMain">
      <div id="event">EVENT</div>
      <form action="eventWriteOk.do" method="POST">
	      <div id="eventWrite">
		      <div id="eventWriteTable">
			      <div id="eventWriteTitleTable">
			        <div id="title">제목</div>
			        <input id="boardTypeEventWriteOkForm" type="hidden" name="boardType" value="3">
			        <input id="titleMemo" type="text" name="boardTitle">
			      </div>
			      
			      <div id="eventWriteBookTable" style="display: flex; align-items: center; justify-content: center; width:100%; margin: 0 0 3% 0;">
              <div id="title">도서</div>
              <!-- 1. 서버로 선택된 책의 BOOK_NO를 전송할 숨겨진 input -->
              <input type="hidden" name="bookNo" id="selectedBookNo">
              <div style="width: 70%; display: flex; align-items: center; margin-left: 1%;">
                <!-- 2. 책 검색 팝업을 띄울 버튼 -->
                <button type="button" id="searchBookBtn">📚 연관 도서 검색</button>
                <!-- 3. 선택된 책 정보가 표시될 영역 -->
                <div id="selectedBookArea">선택된 도서가 없습니다.</div>
              </div>
            </div>
			      
		        <div id="eventWriteContentTable">
		          <div id="content">내용</div>
		          <textarea id="contentMemo" name="boardContent"></textarea>
		        </div>
		      </div>
	    	</div>
	    	<div id="eventButtonDiv">
	        <button id="eventWriteButton" type="submit">등록하기</button>&nbsp;&nbsp;&nbsp;
	        <button id="resetButton" type="button">취소하기</button>
	    	</div>
    	</form>
    </div>
  </section>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  
<script>
// 장바구니 개수 업데이트 함수
$(document).ready(function() {
  updateCartCount(); // 장바구니 개수 업데이트
  initHeaderEvents();
  
  //취소하기 버튼 클릭 시 목록으로 이동
  $('#resetButton').click(function() {
	  window.location.href = '<%=request.getContextPath()%>/eventList.do';
	});
  
  $("#searchBookBtn").on("click", function() {
	  const popupUrl = "<%= request.getContextPath() %>/popup/bookPopup.do";
    const width = 600;
    const height = 700;
    const left = (window.screen.width / 2) - (width / 2); 
    const top = (window.screen.height / 2) - (height / 2);
    
    console.log("팝업을 엽니다:", popupUrl);
    
    window.open(popupUrl, "bookPopup", `width=${width},height=${height},left=${left},top=${top}`);
  });
});
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer-when-downgrade">
<title>bookPopup</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; padding: 15px; margin: 0; }
  h1 { font-size: 1.5em; border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-top: 0; }
  .search-bar { display: flex; gap: 5px; }
  #keyword { flex-grow: 1; padding: 8px; font-size: 1em; border: 1px solid #ccc; border-radius: 4px; }
  #searchBtn { padding: 8px 15px; font-size: 1em; cursor: pointer; border: 1px solid black; background-color: black; color: white; border-radius: 4px; }
  #results { margin-top: 15px; }
  .result-item { display: flex; align-items: center; padding: 10px; border-bottom: 1px solid #eee; }
  .result-item img { width: 40px; margin-right: 15px; border: 1px solid #eee; }
  .result-item .info { flex-grow: 1; }
  .result-item .info .title { font-weight: bold; }
  .result-item .info .author { font-size: 0.9em; color: #555; }
  .result-item button { padding: 5px 10px; cursor: pointer; }
  .select-btn { border: 1px solid #ccc; border-radius: 4px; font-size: 0.9em; color: black; }
</style>
</head>
<body>
  <h1>도서 검색</h1>
  <div class="search-bar">
    <input type="text" id="keyword" placeholder="책 제목 또는 저자로 검색">
    <button type="button" id="searchBtn">검색</button>
  </div>
  <hr>
  <div id="results">검색어를 입력 후 검색 버튼을 눌러주세요.</div>
	<script>
	$(document).ready(function() {
    function performSearch() {
	    const keyword = $("#keyword").val();
	    if(!keyword || keyword.trim() === ''){ alert("검색어를 입력해주세요.");
        																		 return; }
	
	    $("#results").html("검색 중입니다...");
	    
	    $.ajax({ url: "<%= request.getContextPath() %>/api/searchBooks.do",
			         type: "GET",
			         data: { keyword: keyword },
							 success: function(bookList) {
			        	 
			            console.log("  - AJAX 요청 성공! 서버 응답:", bookList);
			            const resultsDiv = $("#results");
			            resultsDiv.empty();
			
			            if(!bookList || bookList.length === 0){ resultsDiv.html("검색 결과가 없습니다.");
																						              return; }
			
			            bookList.forEach(function(book) { const itemDiv = $('<div class="result-item"></div>');
																			              const img = $('<img alt="표지">');
																			              const infoDiv = $('<div class="info"><div class="title"></div><div class="author"></div></div>');
																			              const selectBtn = $('<button type="button" class="select-btn">선택</button>');
																			
																			              img.attr('src', book.bookImgUrl); 
																			
																			              infoDiv.find('.title').text(book.title);
																			              infoDiv.find('.author').text(book.author);
																			
																			              selectBtn.data('book-no', book.bookNo);
																			              selectBtn.data('book-title', book.title);
																			              selectBtn.data('book-img', book.bookImgUrl);
																			
																			              itemDiv.append(img).append(infoDiv).append(selectBtn);
																			
																			              resultsDiv.append(itemDiv); });
      },
							 error: function(xhr, status, error) {
            						console.error("  - AJAX 요청 실패! 상태:", status, "오류:", error);
            						$("#results").html("검색 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        							}
	    });
	  }
	
		$("#searchBtn").on("click", performSearch);
		$("#keyword").on("keypress", function(e) { if(e.which === 13){ performSearch(); } });
	
		$(document).on("click", ".select-btn", function() {
	    const bookNo = $(this).data("book-no");
	    const bookTitle = $(this).data("book-title");
	    const bookImg = $(this).data("book-img");
	    
	    opener.document.getElementById('selectedBookNo').value = bookNo;
	    opener.document.getElementById('selectedBookArea').innerHTML = `<img src="${bookImg}" alt="표지"> <span>${bookTitle}</span>`;
	    
	    window.close();
	  });
	});
	</script>
</body>
</html>
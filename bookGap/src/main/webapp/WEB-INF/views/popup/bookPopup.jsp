<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer-when-downgrade">
<title>도서 검색</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<style>
    /* ... (스타일은 그대로 유지) ... */
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
        if (!keyword || keyword.trim() === '') {
            alert("검색어를 입력해주세요.");
            return;
        }

        $("#results").html("검색 중입니다...");
        
        $.ajax({
            url: "<%= request.getContextPath() %>/api/searchBooks.do",
            type: "GET",
            data: { keyword: keyword },
            success: function(bookList) {
                console.log("  - AJAX 요청 성공! 서버 응답:", bookList);
                const resultsDiv = $("#results");
                resultsDiv.empty();

                if (!bookList || bookList.length === 0) {
                    resultsDiv.html("검색 결과가 없습니다.");
                    return;
                }

                // ▼▼▼ [최종 수정] 이 부분을 완전히 교체합니다. ▼▼▼
                bookList.forEach(function(book) {
                    // 1. 각 요소를 jQuery 객체로 미리 만듭니다.
                    const itemDiv = $('<div class="result-item"></div>');
                    const img = $('<img alt="표지">');
                    const infoDiv = $('<div class="info"><div class="title"></div><div class="author"></div></div>');
                    const selectBtn = $('<button type="button" class="select-btn">선택</button>');

                    // 2. 이미지 소스(src)를 .attr()을 이용해 설정합니다. (가장 안정적인 방식)
                    img.attr('src', book.bookImgUrl); 
                    
                    // 3. 텍스트와 데이터를 각 요소에 채워 넣습니다.
                    infoDiv.find('.title').text(book.title);
                    infoDiv.find('.author').text(book.author);
                    
                    selectBtn.data('book-no', book.bookNo);
                    selectBtn.data('book-title', book.title);
                    selectBtn.data('book-img', book.bookImgUrl);
                    
                    // 4. 조립된 요소들을 부모 div에 추가합니다.
                    itemDiv.append(img).append(infoDiv).append(selectBtn);
                    
                    // 5. 완성된 아이템을 결과 영역에 추가합니다.
                    resultsDiv.append(itemDiv);
                });
                // ▲▲▲ [최종 수정] 여기까지 교체 ▲▲▲
            },
            error: function(xhr, status, error) {
                console.error("  - AJAX 요청 실패! 상태:", status, "오류:", error);
                $("#results").html("검색 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            }
        });
    }

    $("#searchBtn").on("click", performSearch);
    $("#keyword").on("keypress", function(e) {
        if (e.which === 13) {
            performSearch();
        }
    });

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
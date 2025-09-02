<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>bookSearch</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; padding: 15px; }
    h1 { font-size: 1.5em; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
    #keyword { padding: 8px; width: 300px; font-size: 1em; border: 1px solid #ccc; border-radius: 4px; }
    #searchBtn { padding: 8px 15px; font-size: 1em; cursor: pointer; border: 1px solid #007bff; background-color: #007bff; color: white; border-radius: 4px; }
    #results { margin-top: 15px; }
    .result-item { display: flex; align-items: center; padding: 10px; border-bottom: 1px solid #eee; }
    .result-item img { width: 40px; margin-right: 15px; border: 1px solid #eee; }
    .result-item span { flex-grow: 1; } /* 텍스트 영역이 남은 공간을 모두 차지하도록 */
    .result-item button { padding: 5px 10px; cursor: pointer; }
</style>
</head>
<body>
  <h1>도서 검색</h1>
  <input type="text" id="keyword" placeholder="책 제목 또는 저자로 검색">
  <button type="button" id="searchBtn">검색</button>
  <hr>
  <div id="results">검색어를 입력 후 검색 버튼을 눌러주세요.</div>

<script>
$(document).ready(function() {

    // 검색 함수
    function performSearch() {
        const keyword = $("#keyword").val();
        if (!keyword || keyword.trim() === '') {
            alert("검색어를 입력해주세요.");
            return;
        }

        $("#results").html("검색 중입니다..."); // 사용자에게 로딩 상태 알림

        $.ajax({
            // [수정] ContextPath를 추가하고 Controller의 매핑 주소(.do)를 정확하게 입력
            url: "<%= request.getContextPath() %>/api/searchBooks.do",
            type: "GET",
            data: { keyword: keyword },
            success: function(bookList) {
                $("#results").empty(); // 이전 결과 지우기

                if (bookList.length === 0) {
                    $("#results").html("검색 결과가 없습니다.");
                    return;
                }

                bookList.forEach(function(book) {
                    // [수정] success 콜백 함수 내에서는 JSP EL과 충돌 위험이 없으므로,
                    //       JavaScript 템플릿 리터럴을 바로 사용하는 것이 더 깔끔합니다.
                    let bookHtml = `
                        <div class="result-item">
                            <img src="${book.bookImgUrl}" alt="표지">
                            <span><strong>${book.title}</strong> (${book.author})</span>
                            <button type="button" class="select-btn" 
                                    data-book-no="${book.bookNo}"
                                    data-book-title="${book.title}"
                                    data-book-img="${book.bookImgUrl}">선택</button>
                        </div>
                    `;
                    $("#results").append(bookHtml);
                });
            },
            // [추가] 에러 처리 로직
            error: function(xhr, status, error) {
                $("#results").html("오류가 발생했습니다. 다시 시도해주세요.");
                console.error("AJAX Error:", status, error);
            }
        });
    }

    // '검색' 버튼 클릭 시 AJAX로 책 목록 요청
    $("#searchBtn").on("click", performSearch);

    // Enter 키를 눌러도 검색이 되도록 처리
    $("#keyword").on("keypress", function(e) {
        if (e.which === 13) { // 13 is the keycode for Enter
            performSearch();
        }
    });

    // 동적으로 생성된 '선택' 버튼에 대한 이벤트 처리 (이 부분은 완벽합니다!)
    $(document).on("click", ".select-btn", function() {
        const bookNo = $(this).data("book-no");
        const bookTitle = $(this).data("book-title");
        const bookImg = $(this).data("book-img");
      
        // 부모창(글쓰기 페이지)의 요소를 찾아서 값을 넣어줌
        const selectedArea = opener.document.getElementById('selectedBookArea');
        opener.document.getElementById('selectedBookNo').value = bookNo;
        selectedArea.innerHTML = `<img src="${bookImg}" alt="표지"> <span>${bookTitle}</span>`;
      
        // 현재 팝업창을 닫음
        window.close();
    });

});
</script>
</body>
</html>
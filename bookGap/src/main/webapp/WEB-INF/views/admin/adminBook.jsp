<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>adminBook</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<style>
#datatablesSimple {
 width: 100%;
 table-layout: auto;  /* 기존 fixed → auto로 변경 */
 border-collapse: collapse;
}

 #datatablesSimple th, #datatablesSimple td {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.card-body {
  overflow-x: auto;
}
.adminIndexStyle {
	color: black;
}
  #datatablesSimple th:nth-child(1),
  #datatablesSimple td:nth-child(1) {
    width: 70px;
  }
  #datatablesSimple th:nth-child(2),
  #datatablesSimple td:nth-child(2) {
    width: 80px;
  }
   #datatablesSimple th:nth-child(3),
  #datatablesSimple td:nth-child(3) {
    width: 430px;
  }
   #datatablesSimple th:nth-child(4),
  #datatablesSimple td:nth-child(4) {
    width: 120px;
  }
  #datatablesSimple th:nth-child(5),
  #datatablesSimple td:nth-child(5) {
    width: 110px;
  }
   #datatablesSimple th:nth-child(6),
  #datatablesSimple td:nth-child(6) {
    width: 150px;
  }
  #datatablesSimple th:nth-child(7),
  #datatablesSimple td:nth-child(7) {
    width: 90px;
  }
  /* 상품번호(판매번호) 너비 줄이기 */
  #datatablesSimple th:nth-child(8),
  #datatablesSimple td:nth-child(8) {
    width: 110px;
  }
  /* 숨길 열 선택 (예: 5번역가, 9발행일, 11~15 기타 상세) */
  #datatablesSimple td:nth-child(9),
  #datatablesSimple th:nth-child(9),
  #datatablesSimple td:nth-child(10),
  #datatablesSimple th:nth-child(10),
  #datatablesSimple td:nth-child(11),
  #datatablesSimple th:nth-child(11),
  #datatablesSimple td:nth-child(12),
  #datatablesSimple th:nth-child(12),
  #datatablesSimple td:nth-child(13),
  #datatablesSimple th:nth-child(13),
  #datatablesSimple td:nth-child(14),
  #datatablesSimple th:nth-child(14),
  #datatablesSimple td:nth-child(15),
  #datatablesSimple th:nth-child(15)
  {
    display: none;
  }
</style>
</head>
<body class="sb-nav-fixed">
		<jsp:include page="/WEB-INF/views/include/adminHeader.jsp" />
				<div id="layoutSidenav">
					<div id="layoutSidenav_nav">
						<nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
							<div class="sb-sidenav-menu">
								<!--nav삽입-->
								<jsp:include page="/WEB-INF/views/include/adminNav.jsp" />
							</div>
							<div class="sb-sidenav-footer">
								<div class="small">BOOK틈 관리자페이지</div>
								admin
							</div>
						</nav>
					</div>
	        <div id="layoutSidenav_content">
          <main>
              <div class="container-fluid px-4">
                  <h1 class="mt-4">도서 관리</h1>
                  <ol class="breadcrumb mb-4">
                      <li class="breadcrumb-item"><a class="adminIndexStyle"  href="${pageContext.request.contextPath}/admin/adminIndex.do">Dashboard</a></li>
                      <li class="breadcrumb-item active">도서 관리</li>
                  </ol>
                  <div class="card mb-4">
                      <div class="card-body">
                        <h5 class="card-title fw-semibold mb-4">도서 등록</h5>
                        <button class="btn btn-dark mb-3" id="toggleFormBtn">도서 등록</button>
                        <div id="bookFormContainer" style="display: none;">
                          <div class="card p-3">
                            <form id="bookForm">
                              <div class="mb-3">
                              	<input type="hidden" id="bookNo" name="bookNo">
                              	<label class="form-label">도서검색 </label>
                              	<input type="search" class="form-control" id=searchValue  placeholder="도서명을 입력하세요">
                                <label class="form-label">도서명</label>
                                <input type="text" id="title" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">저자</label>
                                <input type="text" id="author" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">번역가</label>
                                <input type="text" id="bookTrans" class="form-control">
                              </div>
                              <div class="mb-3">
                                <label class="form-label">출판사</label>
                                <input type="text" id="publisher" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">ISBN</label>
                                <input type="text" id="isbn" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">가격 (₩)</label>
                                <input type="number" id="discount" class="form-control" min="0" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">책 소개</label>
                                <textarea id="description" class="form-control" rows="3"></textarea>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">카테고리</label>
                                <select id="bookCategory" class="form-select">
                                  <option value="인문학">인문학</option>
                                  <option value="철학">철학</option>
                                  <option value="언어학">언어학</option>
                                  <option value="미학">미학</option>
                                  <option value="종교학">종교학</option>
                                  <option value="윤리학">윤리학</option>
                                  <option value="심리학">심리학</option>
                                </select>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">도서 발행일</label>
                                <input type="date" id="pubdate" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">도서정보링크</label>
                                <input type="text" id="link" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">도서상세이미지URL</label>
                                <input type="text" id="bookImgUrl" class="form-control" required>
                              </div>
                               <div class="mb-3">
                                <label class="form-label">책 목차 </label>
                                <textarea id="bookIndex" class="form-control" rows="10"></textarea>
                              </div>
                               <div class="mb-3">
                                <label class="form-label">출판사 서평 </label>
                                <textarea id="publisherBookReview" class="form-control" rows="10"></textarea>
                              </div>
                              <button type="button" class="btn btn-dark" id="saveBook">등록</button>
                              <button type="button" class="btn btn-secondary" id="cancelForm">취소</button>
                            </form>
                          </div>
                        </div>
                      </div>
                  </div>
                  <div class="card mb-4">
                      <div class="card-header">
                          <i class="fas fa-table me-1"></i>
                         도서 리스트
                      </div>
                      <div class="card-body">
                          <table id="datatablesSimple">
                              <thead>
                                  <tr>
                                    <th>상품번호</th>
								    <th>카테고리</th>
								    <th>도서명</th>
								    <th>저자</th>
								    <th>출판사</th>
								    <th>ISBN</th>
								    <th>가격 (₩)</th>
								    <th>관리</th>
								    <th style="display:none;">번역가</th>
								    <th style="display:none;" >발행일</th>
								    <th style="display:none;" >책소개</th>
								    <th style="display:none;" >링크</th>
								    <th style="display:none;" >이미지URL</th>
								    <th style="display:none;" >목차</th>
								    <th style="display:none;" >서평</th>
                                  </tr>
                              </thead>
                              <tbody>
								<c:forEach items="${getAllBooks}" var="vo">
								  <tr
								    data-book-no="${vo.bookNo}"
								    data-book-category="${vo.bookCategory}"
								    data-title="${vo.title}"
								    data-author="${vo.author}"
								    data-book-trans="${vo.bookTrans}"
								    data-publisher="${vo.publisher}"
								    data-isbn="${vo.isbn}"
								    data-discount="${vo.discount}"
								    data-pubdate="${vo.pubdate}"
								    data-description="${vo.description}"
								    data-link="${vo.link}"
								    data-book-img-url="${vo.bookImgUrl}"
								    data-book-index="${vo.bookIndex}"
								    data-publisher-book-review="${vo.publisherBookReview}"
								  >
								    <td>${vo.bookNo}</td>
								    <td>${vo.bookCategory}</td>
								    <td>${vo.title}</td>
								    <td>${vo.author}</td>
								    <td>${vo.publisher}</td>
								    <td>${vo.isbn}</td>
								    <td>${vo.discount}원</td>
								    <td>
								      <button class="btn btn-warning btn-sm editBook">수정</button>
								      <button class="btn btn-danger btn-sm deleteBook">삭제</button>
								    </td>
								    <td style="display:none;" >${vo.bookTrans}</td>
								    <td style="display:none;" >${vo.pubdate}</td>
								    <td style="display:none;" >${vo.description}</td>
								    <td style="display:none;" >${vo.link}</td>
								    <td style="display:none;" >${vo.bookImgUrl}</td>
								    <td style="display:none;" >${vo.bookIndex}</td>
								    <td style="display:none;">${vo.publisherBookReview}</td>
								  </tr>
								</c:forEach>
                              </tbody>
                          </table>
                      </div>
                  </div>
              </div>
          </main>
         <jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
        </div>
      </div>
		<script>
		  document.getElementById("searchValue").addEventListener("change", function () {
		    const keyword = this.value.trim();
		    if (!keyword) return;
		
		    fetch("${pageContext.request.contextPath}/api/books/search", {
		      method: "POST",
		      headers: { "Content-Type": "application/x-www-form-urlencoded" },
		      body: "title=" + encodeURIComponent(keyword)
		    })
		    .then(async res => {
		      const contentType = res.headers.get("content-type");
		      if (!res.ok || !contentType || !contentType.includes("application/json")) {
		        const text = await res.text();
		        throw new Error("JSON 응답이 아닙니다: " + text);
		      }
		      return res.json();
		    })
		    .then(data => {
		      console.log("전체 응답 구조:", data);
		      if (data && !data.error) {
		        const cleanTitle = data.title?.replace(/<[^>]*>/g, "") || "";
		        document.getElementById("title").value = cleanTitle;
		        document.getElementById("author").value = data.author || "";
		        document.getElementById("publisher").value = data.publisher || "";
		        document.getElementById("isbn").value = data.isbn?.split(" ")[0] || "";
		        document.getElementById("discount").value = data.discount || "";
		        document.getElementById("description").value = data.description || "";
				document.getElementById("link").value = data.link || "";
		        const pubdateInput = document.getElementById("pubdate");
		        let rawDate = (data.pubdate || '').toString().replace(/[^\d]/g, ''); // 숫자만 남기기
		        console.log("정제된 rawDate:", rawDate);
		
		        if (pubdateInput && /^\d{8}$/.test(rawDate)) {
		          const year = parseInt(rawDate.slice(0, 4), 10);
		          const month = parseInt(rawDate.slice(4, 6), 10);
		          const day = parseInt(rawDate.slice(6, 8), 10);
		
		          const dateObj = new Date(year, month - 1, day); // JS는 월 0부터 시작
		          if (!isNaN(dateObj.getTime())) {
		            const formattedDate = dateObj.toISOString().split('T')[0];
		            console.log("formattedDate:", formattedDate);
		            pubdateInput.value = formattedDate;
		          } else {
		            console.warn("날짜 객체 생성 실패:", year, month, day);
		            pubdateInput.value = '';
		          }
		        } else {
		          console.warn("날짜 포맷 오류 또는 값 없음:", rawDate);
		          pubdateInput.value = '';
		        }
		      }
		    })
		    .catch(err => {
		      console.error("도서 검색 실패:", err);
		      alert("도서 검색 중 오류가 발생했습니다.");
		    });
		  });
		</script>
		<script>
			$(document).ready(function() {
				
			    $('#toggleFormBtn').click(function() {
			      $('#bookFormContainer').show();
			      $(this).hide();
			    });
				
			    // 등록
			    $('#saveBook').click(function() {
			      const formData = {
			    		  bookTrans: $('#bookTrans').val(),
			    		  isbn: $('#isbn').val(),
			    		  bookCategory: $('#bookCategory').val(),
			    		  bookImgUrl: $('#bookImgUrl').val(),
			    		  bookIndex: $('#bookIndex').val(),
			    		  publisherBookReview: $('#publisherBookReview').val()
			    		  
			      };
	
			      $.ajax({
			        url: '${pageContext.request.contextPath}/admin/books/bookInsert',
			        type: 'POST',
			        data: formData,
			        success: function(response) {
			          alert('도서 등록되었습니다. ');
			          location.reload();
			          //loadBookList();
			          $('#bookForm')[0].reset();
			          $('#bookFormContainer').hide();
			          $('#toggleFormBtn').show();
			          $('#saveBook').show();
			          $('#updateBook').remove();
			        },
			        error: function(xhr) {
			            alert(xhr.responseText || '도서 등록에  실패하셨습니다. ');
			        }
			      });
			    });
			    

			    // 수정 버튼 클릭 시 폼에 데이터 채우기
				$(document).on('click', '.editBook', function () {
				  const row = $(this).closest('tr');
				  
				  // 각 td에서 직접 데이터 추출
				  const tds = row.find('td');
				  $('#bookNo').val(tds.eq(0).text().trim());
				  $('#bookCategory').val(tds.eq(1).text().trim());
				  $('#title').val(tds.eq(2).text().trim());
				  $('#author').val(tds.eq(3).text().trim());
				  $('#publisher').val(tds.eq(4).text().trim());
				  $('#isbn').val(tds.eq(5).text().trim());
				  $('#discount').val(tds.eq(6).text().replace('원', '').trim());
				  
				  $('#bookTrans').val(row.find('td').eq(8).text().trim());
				  $('#pubdate').val(row.find('td').eq(9).text().trim());
				  $('#description').val(row.find('td').eq(10).text().trim());
				  $('#link').val(row.find('td').eq(11).text().trim());
				  $('#bookImgUrl').val(row.find('td').eq(12).text().trim());
				  $('#bookIndex').val(row.find('td').eq(13).text().trim());
				  $('#publisherBookReview').val(row.find('td').eq(14).text().trim());
				
				  // 폼 표시
				  $('#bookFormContainer').show();
				  $('#toggleFormBtn').hide();
				  $('#saveBook').hide();
				
				  if (!$('#updateBook').length) {
				    $('<button type="button" class="btn btn-warning" id="updateBook">수정 완료</button>').insertAfter('#saveBook');
				  }
				});
			    // 수정 완료
			    $(document).on('click', '#updateBook', function() {
			      const formData = {
			    	bookNo: $('#bookNo').val(),
			        bookTrans: $('#bookTrans').val(),
			        isbn: $('#isbn').val(),
			        bookCategory: $('#bookCategory').val(),
		    		bookImgUrl: $('#bookImgUrl').val(),
		    		bookIndex: $('#bookIndex').val(),
		    		publisherBookReview: $('#publisherBookReview').val()
			      };
	
			      $.ajax({
			        url: '${pageContext.request.contextPath}/admin/books/bookUpdate',
			        type: 'POST',
			        data: formData,
			        success: function(response) {
			          alert('도서가 수정되었습니다. ');
			          location.reload();
			        },
			        error: function() {
			          alert('도서 수정에 실패하셨습니다. ');
			        }
			      });
			    });
	
			    // 삭제 버튼 클릭 시
			    $(document).on('click', '.deleteBook', function() {
			      const row = $(this).closest('tr');
			      const bookNo = row.find('td:eq(9)').text();
	
			      if (confirm("정말 삭제하시겠습니까?")) {
			        $.ajax({
			          url: '${pageContext.request.contextPath}/admin/books/bookDelete',
			          type: 'POST',
			          data: { bookNo: bookNo },
			          success: function(response) {
			            alert('도서가 삭제되었습니다. ');
			            location.reload();
			          },
			          error: function() {
			            alert('도서를 삭제하는데 실패하셨습니다. ');
			          }
			        });
			      }
			    });
	
			    $('#cancelForm').click(function() {
			      $('#bookFormContainer').hide();
			      $('#toggleFormBtn').show();
			      $('#saveBook').show();
			      $('#updateBook').remove();
			      $('#bookForm')[0].reset();
			    });
			  });
		</script>
		<script>
			document.addEventListener("DOMContentLoaded", function () {
				  const table = new simpleDatatables.DataTable("#datatablesSimple", {
				    labels: {
				      perPage: "",
				      placeholder: "검색어 입력...",
				      noRows: "데이터가 없습니다.",
				      info: ""
				    }
				  });
				});
		</script>
		<script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
		<script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>
</body>
</html> 
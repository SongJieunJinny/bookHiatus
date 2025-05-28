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
    table-layout: fixed;  /* 컬럼 크기 고정 */
    border-collapse: collapse; /* 테두리 정렬 */
  }

  #datatablesSimple th, #datatablesSimple td {
    text-align: left;
    padding: 10px;
    border: 1px solid #ddd;
    white-space: nowrap;
    overflow: hidden;
  }
    .adminIndexStyle {
    	color: black;
    }
  #datatablesSimple th:nth-child(1),
  #datatablesSimple td:nth-child(1) {
    width: 230px;
  }
  /* 상품번호(판매번호) 너비 줄이기 */
  #datatablesSimple th:nth-child(11),
  #datatablesSimple td:nth-child(11) {
    width: 80px;
  }
  /* ISBN 너비 늘리기 */
  #datatablesSimple th:nth-child(5),
  #datatablesSimple td:nth-child(5) {
    width: 130px;
  }
  #datatablesSimple th:nth-child(12),
  #datatablesSimple td:nth-child(12) {
    width: 111px;
  }
  #datatablesSimple th:nth-child(10),
  #datatablesSimple td:nth-child(10) {
    width: 80px;
  }
   #datatablesSimple th:nth-child(9),
   #datatablesSimple td:nth-child(9) {
    width: 100px;
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
                                <input type="number" id="isbn" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">가격 (₩)</label>
                                <input type="number" id="discount" class="form-control" min="0" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">도서 상세 내용</label>
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
                                <label class="form-label">재고 수량</label>
                                <input type="number" id="bookStock" class="form-control" min="1" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">도서 발행일</label>
                                <input type="date" id="pubdate" class="form-control" required>
                              </div>
                              <div class="mb-3">
                                <label class="form-label">상품 상태</label>
                                <select id="bookState" class="form-select">
                                  <option value="0">품절</option>
                                  <option value="1">판매중</option>
                                </select>
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
                                    <th>도서명</th>
                                    <th>저자</th>
                                    <th>번역가</th>
                                    <th>출판사</th>
                                    <th>ISBN</th>
                                    <th>가격 (₩)</th>
                                    <th>카테고리</th>
                                    <th>재고 수량</th>
                                    <th>도서 발행일</th>
                                    <th>상품번호</th>
                                    <th>상품 상태</th>
                                    <th>관리</th>
                                  </tr>
                              </thead>
                              <tbody>
                              <c:forEach items="${getAllBooks}" var="vo">
                                  <tr>
                                      <td>${vo.title}</td>
                                      <td>${vo.author}</td>
                                      <td>${vo.bookTrans}</td>
                                      <td>${vo.publisher}</td>
                                      <td>${vo.isbn}</td>
                                      <td>${vo.discount}원 </td>
                                      <td>${vo.bookCategory}</td>
                                      <td>${vo.bookStock}</td>
                                      <td>${vo.pubdate}</td>
                                      <td>${vo.bookNo}</td>
                                      <td>
										  <c:choose>
										    <c:when test="${vo.bookState == 0}">품절</c:when>
										    <c:when test="${vo.bookState == 1}">판매중</c:when>
										    <c:otherwise>알 수 없음</c:otherwise>
										  </c:choose>
									   </td>
                                      <td> <button class="btn btn-warning btn-sm editBook">수정</button>
                								<button class="btn btn-danger btn-sm deleteBook">삭제</button></td>
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
			    		  bookStock: parseInt($('#bookStock').val()),
			    		  bookState: parseInt($('#bookState').val())
			      };
	
			      $.ajax({
			        url: '${pageContext.request.contextPath}/admin/books/bookInsert',
			        type: 'POST',
			        data: formData,
			        success: function(response) {
			          alert('등록 성공!');
			          location.reload();
			          //loadBookList();
			          $('#bookForm')[0].reset();
			          $('#bookFormContainer').hide();
			          $('#toggleFormBtn').show();
			          $('#saveBook').show();
			          $('#updateBook').remove();
			        },
			        error: function(xhr) {
			            alert(xhr.responseText || '도서 등록 실패!');
			        }
			      });
			    });
			    

			    // 수정 버튼 클릭 시 폼에 데이터 채우기
			    $(document).on('click', '.editBook', function() {
			      const row = $(this).closest('tr');
			      $('#title').val(row.find('td:eq(0)').text());
			      $('#author').val(row.find('td:eq(1)').text());
			      $('#bookTrans').val(row.find('td:eq(2)').text());
			      $('#publisher').val(row.find('td:eq(3)').text());
			      $('#isbn').val(row.find('td:eq(4)').text());
			      $('#discount').val(row.find('td:eq(5)').text().replace('₩', '').trim());
			      $('#bookCategory').val(row.find('td:eq(6)').text());
			      $('#bookStock').val(row.find('td:eq(7)').text());
			      $('#pubdate').val(row.find('td:eq(8)').text());
			      $('#bookNo').val(row.find('td:eq(9)').text());
			      $('#bookState').val(row.find('td:eq(10)').text() === '판매중' ? '1' : '0');
	
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
			        bookStock: parseInt($('#bookStock').val()),
		    		bookState: parseInt($('#bookState').val())
			      };
	
			      $.ajax({
			        url: '${pageContext.request.contextPath}/admin/books/bookUpdate',
			        type: 'POST',
			        data: formData,
			        success: function(response) {
			          alert('수정 성공!');
			          location.reload();
			        },
			        error: function() {
			          alert('수정 실패!');
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
			            alert('삭제 성공!');
			            location.reload();
			          },
			          error: function() {
			            alert('삭제 실패!');
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
			document.addEventListener("DOMContentLoaded", function() {
			    const table = new simpleDatatables.DataTable("#datatablesSimple", {
			      labels: {
			        perPage: "",  // 이 부분이 'entries per page' 문구를 담당
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
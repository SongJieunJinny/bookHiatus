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
        text-align: center;  /* 가운데 정렬 */
        border-collapse: collapse; /* 테두리 정렬 */
    }

    #datatablesSimple th, #datatablesSimple td {
        padding: 10px;
        border: 1px solid #ddd; /* 테두리 추가 */
        white-space: nowrap;  /* 텍스트 줄바꿈 방지 */
        overflow: hidden;
       
    }
    </style>
</head>
<body class="sb-nav-fixed">
			<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
				<!-- Navbar Brand-->
				<a class="blockquote" href="adminIndex.html">BOOK 틈</a>
				<!-- Sidebar Toggle-->
				<button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
				<!-- Navbar Search-->
				<form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
					<div class="input-group">
						<input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
						<button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
					</div>
				</form>
				<!-- Navbar-->
				<ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
						<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="#!">Settings</a></li>
							<li><a class="dropdown-item" href="#!">Activity Log</a></li>
							<li><hr class="dropdown-divider" /></li>
							<li><a class="dropdown-item" href="#!">Logout</a></li>
						</ul>
					</li>
				</ul>
			</nav>
			<div id="layoutSidenav">
				<div id="layoutSidenav_nav">
					<nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
						<div class="sb-sidenav-menu">
							<div class="nav">
								<div class="sb-sidenav-menu-heading">Core</div>
								<a class="nav-link" href="index.html">
									<div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
									INDEX
								</a>
								<div class="sb-sidenav-menu-heading">Interface</div>
								<a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
									<div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
									Layouts
									<div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
								</a>
								<div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
									<nav class="sb-sidenav-menu-nested nav">
										<a class="nav-link" href="layout-static.html">Shadow</a>
										<a class="nav-link" href="layout-sidenav-light.html">Light</a>
									</nav>
								</div>
								<a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
									<div class="sb-nav-link-icon"><i class="fas fa-book-open"></i></div>
									Pages
									<div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
								</a>
								<div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
									<nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
										<a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseAuth" aria-expanded="false" aria-controls="pagesCollapseAuth">
											Admin
											<div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
										</a>
										<div class="collapse" id="pagesCollapseAuth" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
											<nav class="sb-sidenav-menu-nested nav">
												<a class="nav-link" href="adminBook.html">Book</a>
												<a class="nav-link" href="register.html">Order</a>
												<a class="nav-link" href="teamPJT/index.html">User Info</a>
												<a class="nav-link" href="teamPJT/index.html">Guset Order Info</a>
                        <a class="nav-link" href="adminComplain.html">Complain</a>
											</nav>
										</div>
										<a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseError" aria-expanded="false" aria-controls="pagesCollapseError">
											Error
											<div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
										</a>
										<div class="collapse" id="pagesCollapseError" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
											<nav class="sb-sidenav-menu-nested nav">
												<a class="nav-link" href="401.html">401 Page</a>
												<a class="nav-link" href="404.html">404 Page</a>
												<a class="nav-link" href="500.html">500 Page</a>
											</nav>
										</div>
									</nav>
								</div>
								<div class="sb-sidenav-menu-heading">Addons</div>
								<a class="nav-link" href="charts.html">
									<div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
									Sales
								</a>
								<a class="nav-link" href="adminSchedule.html">
									<div class="sb-nav-link-icon"><i class="fas fa-table"></i></div>
									Schedule
								</a>
							</div>
						</div>
						<div class="sb-sidenav-footer">
							<div class="small">Logged in as:</div>
							Start Bootstrap
						</div>
					</nav>
				</div>
        <div id="layoutSidenav_content">
          <main>
              <div class="container-fluid px-4">
                  <h1 class="mt-4">도서 관리</h1>
                  <ol class="breadcrumb mb-4">
                      <li class="breadcrumb-item"><a href="index.html">Dashboard</a></li>
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
                                <label class="form-label">상품번호</label>
                                <input type="text" id="bookNo" class="form-control" required>
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
                              <tfoot>
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
                              </tfoot>
                              <tbody>
                                  <tr>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Garrett Winters</td>
                                      <td>Accountant</td>
                                      <td>Tokyo</td>
                                      <td>63</td>
                                      <td>2011/07/25</td>
                                      <td>$170,750</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Ashton Cox</td>
                                      <td>Junior Technical Author</td>
                                      <td>San Francisco</td>
                                      <td>66</td>
                                      <td>2009/01/12</td>
                                      <td>$86,000</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Cedric Kelly</td>
                                      <td>Senior Javascript Developer</td>
                                      <td>Edinburgh</td>
                                      <td>22</td>
                                      <td>2012/03/29</td>
                                      <td>$433,060</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Airi Satou</td>
                                      <td>Accountant</td>
                                      <td>Tokyo</td>
                                      <td>33</td>
                                      <td>2008/11/28</td>
                                      <td>$162,700</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Brielle Williamson</td>
                                      <td>Integration Specialist</td>
                                      <td>New York</td>
                                      <td>61</td>
                                      <td>2012/12/02</td>
                                      <td>$372,000</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                                  <tr>
                                      <td>Herrod Chandler</td>
                                      <td>Sales Assistant</td>
                                      <td>San Francisco</td>
                                      <td>59</td>
                                      <td>2012/08/06</td>
                                      <td>$137,500</td>
                                      <td>Tiger Nixon</td>
                                      <td>System Architect</td>
                                      <td>Edinburgh</td>
                                      <td>61</td>
                                      <td>2011/04/25</td>
                                      <td>$320,800</td>
                                  </tr>
                              </tbody>
                          </table>
                      </div>
                  </div>
              </div>
          </main>
          <footer class="py-4 bg-light mt-auto">
              <div class="container-fluid px-4">
                  <div class="d-flex align-items-center justify-content-between small">
                      <div class="text-muted">Copyright &copy; Your Website 2023</div>
                      <div>
                          <a href="#">Privacy Policy</a>
                          &middot;
                          <a href="#">Terms &amp; Conditions</a>
                      </div>
                  </div>
              </div>
          </footer>
        </div>
      </div>
      <script>
        document.addEventListener("DOMContentLoaded", function () {
          const toggleFormBtn = document.getElementById("toggleFormBtn");
          const bookFormContainer = document.getElementById("bookFormContainer");
          const bookForm = document.getElementById("bookForm");
          const saveBookBtn = document.getElementById("saveBook");
          const cancelFormBtn = document.getElementById("cancelForm");
          const bookTableBody = document.querySelector("#datatablesSimple tbody");

          // 1. "도서 추가" 버튼 클릭 시 입력 폼 표시/숨김 토글
          toggleFormBtn.addEventListener("click", function () {
            bookFormContainer.style.display = "block";
            toggleFormBtn.style.display = "none";
          });

          // 2. "등록" 버튼 클릭 시 테이블에 추가
          saveBookBtn.addEventListener("click", function () {
            const title = document.getElementById("title").value.trim();
            const author = document.getElementById("author").value.trim();
            const bookTrans = document.getElementById("bookTrans").value.trim();
            const publisher = document.getElementById("publisher").value.trim();
            const isbn = document.getElementById("isbn").value.trim();
            const discount = document.getElementById("discount").value.trim();
            const bookCategory = document.getElementById("bookCategory").value;
            const bookStock = document.getElementById("bookStock").value;
            const pubdate = document.getElementById("pubdate").value;
            const bookNo = document.getElementById("bookNo").value.trim();
            const bookState = document.getElementById("bookState").value;

            if (!title || !author || !publisher || !isbn || !discount || !bookStock || !pubdate || !bookNo) {
              alert("모든 필수 필드를 입력해주세요!");
              return;
            }

            const newRow = document.createElement("tr");
            newRow.innerHTML = `
              <td>${title}</td>
              <td>${author}</td>
              <td>${bookTrans || "N/A"}</td>
              <td>${publisher}</td>
              <td>${isbn}</td>
              <td>₩${discount}</td>
              <td>${bookCategory}</td>
              <td>${bookStock}</td>
              <td>${pubdate}</td>
              <td>${bookNo}</td>
              <td>${bookState == '1' ? '판매중' : '품절'}</td>
              <td>
                <button class="btn btn-warning btn-sm editBook">수정</button>
                <button class="btn btn-danger btn-sm deleteBook">삭제</button>
              </td>
            `;

            bookTableBody.appendChild(newRow);
            bookForm.reset();
            bookFormContainer.style.display = "none";
            toggleFormBtn.style.display = "block";
          });
          bookTableBody.addEventListener("click", function (event) {
            if (event.target.classList.contains("editBook")) {
              const row = event.target.closest("tr");

              // 테이블의 각 셀에서 값 가져오기
              const title = row.children[0].textContent;
              const author = row.children[1].textContent;
              const bookTrans = row.children[2].textContent === "N/A" ? "" : row.children[2].textContent;
              const publisher = row.children[3].textContent;
              const isbn = row.children[4].textContent;
              const discount = row.children[5].textContent.replace("₩", "").trim();
              const bookCategory = row.children[6].textContent;
              const bookStock = row.children[7].textContent;
              const pubdate = row.children[8].textContent;
              const bookNo = row.children[9].textContent;
              const bookState = row.children[10].textContent === '판매중' ? '1' : '0';

              // 폼에 값 채우기
              document.getElementById("title").value = title;
              document.getElementById("author").value = author;
              document.getElementById("bookTrans").value = bookTrans;
              document.getElementById("publisher").value = publisher;
              document.getElementById("isbn").value = isbn;
              document.getElementById("discount").value = discount;
              document.getElementById("bookCategory").value = bookCategory;
              document.getElementById("bookStock").value = bookStock;
              document.getElementById("pubdate").value = pubdate;
              document.getElementById("bookNo").value = bookNo;
              document.getElementById("bookState").value = bookState;

              // 폼 표시 및 수정 버튼 생성
              bookFormContainer.style.display = "block";
              toggleFormBtn.style.display = "none";

              // 기존 등록 버튼 숨기고 수정 버튼 추가
              saveBookBtn.style.display = "none";

              let updateBookBtn = document.getElementById("updateBook");
              if (!updateBookBtn) {
                updateBookBtn = document.createElement("button");
                updateBookBtn.id = "updateBook";
                updateBookBtn.className = "btn btn-warning";
                updateBookBtn.textContent = "수정 완료";
                bookForm.appendChild(updateBookBtn);
              }
              
              // 기존에 있던 이벤트 제거하고 새롭게 추가
              updateBookBtn.onclick = function () {
                row.children[0].textContent = document.getElementById("title").value;
                row.children[1].textContent = document.getElementById("author").value;
                row.children[2].textContent = document.getElementById("bookTrans").value || "N/A";
                row.children[3].textContent = document.getElementById("publisher").value;
                row.children[4].textContent = document.getElementById("isbn").value;
                row.children[5].textContent = "₩" + document.getElementById("discount").value;
                row.children[6].textContent = document.getElementById("bookCategory").value;
                row.children[7].textContent = document.getElementById("bookStock").value;
                row.children[8].textContent = document.getElementById("pubdate").value;
                row.children[9].textContent = document.getElementById("bookNo").value;
                row.children[10].textContent = document.getElementById("bookState").value == '1' ? '판매중' : '품절';

                // 폼 숨기기 및 초기화
                bookFormContainer.style.display = "none";
                toggleFormBtn.style.display = "block";
                saveBookBtn.style.display = "block";
                updateBookBtn.remove();
                bookForm.reset();
              };
            }
          });

          // 3. "취소" 버튼 클릭 시 폼 숨기기
          cancelFormBtn.addEventListener("click", function () {
            bookFormContainer.style.display = "none";
            toggleFormBtn.style.display = "block";
            bookForm.reset();
          });

          // 4. 삭제 기능 추가
          bookTableBody.addEventListener("click", function (event) {
            if (event.target.classList.contains("deleteBook")) {
              if (confirm("정말 삭제하시겠습니까?")) {
                event.target.closest("tr").remove();
              }
            }
          });
        });
      </script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
      <script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
      <script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>
    </body>
</html>
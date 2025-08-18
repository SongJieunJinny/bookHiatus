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
<title>adminInventoryManagement</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<style>
.datatable-selector {
	padding: 8px;
	width: 170%;
	margin-left: -10px;
	margin-bottom:10px;
	margin-right: 20px;
}
#datatablesSimple th:nth-child(1),
#datatablesSimple td:nth-child(1) {
	width: 120px; /* 원하는 너비로 조절 */
}
#datatablesSimple th:nth-child(5),
#datatablesSimple td:nth-child(5) {
	width: 120px; /* 원하는 너비로 조절 */
}
</style>
</head>
<body class="sb-nav-fixed">
	<!--header삽입-->
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
					<h1 class="mt-4">Inventory Management System</h1>
	          		<br>
					<div class="card mb-4">
						<div class="card-body">
							재고관리 페이지 
						</div>
					</div>
					<div class="card mb-4">
						<div class="card-header">
							<i class="fas fa-table me-1"></i>
							재고 목록 
						</div>
						<div class="card-body">
							<table id="datatablesSimple">
								<thead>
									<tr>
										<th>상품 번호 </th>
										<th>책 제목 </th>
										<th>isbn </th>
										<th>재고수량 </th>
										<th>상품상태 </th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${getInventoryManagementSelectAll}" var="vo">
									<tr data-book-no="${vo.bookNo}">
									    <td>${vo.bookNo}</td>
									    <td>${vo.title}</td>
									    <td>${vo.isbn}</td>
									    <td>
									        <input type="number" class="form-control form-control-sm stockInput" value="${vo.bookStock}" min="0">
									    </td>
									    <td>
									        <select class="form-select form-select-sm stateSelect">
									            <option value="1" ${vo.bookState == 1 ? 'selected' : ''}>판매중</option>
									            <option value="0" ${vo.bookState == 0 ? 'selected' : ''}>품절</option>
									        </select>
									    </td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
					</div>
				</div>
			</main>
			<!--footer 삽입-->
		 	<jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
		</div>
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>
<script>
	$(document).ready(function() {
	
		 // 재고 수량 변경 시
	    $(document).on('change', '.stockInput', function () {
	        const row = $(this).closest('tr');
	        const bookNo = row.find('td:eq(0)').text();
	        const stock = $(this).val();
	        const state = row.find('.stateSelect').val(); // 현재 상품상태 가져오기

	        if (!bookNo) {
	            alert('상품 번호가 올바르게 전달되지 않았습니다.');
	            return;
	        }

	        updateInventory(bookNo, stock, state);
	    });

	    // 상품 상태 변경 시
	    $(document).on('change', '.stateSelect', function () {
	        const row = $(this).closest('tr');
	        const bookNo = row.find('td:eq(0)').text();
	        const state = $(this).val();
	        const stock = row.find('.stockInput').val(); // 현재 재고 수량 가져오기

	        if (!bookNo) {
	            alert('상품 번호가 올바르게 전달되지 않았습니다.');
	            return;
	        }

	        updateInventory(bookNo, stock, state);
	    });

	    // Ajax 저장 함수
	    function updateInventory(bookNo, stock, state) {
	        $.ajax({
	            url: '${pageContext.request.contextPath}/admin/books/updateInventory',
	            type: 'POST',
	            data: {
	                bookNo: bookNo,
	                bookStock: stock,
	                bookState: state
	            },
	            success: function () {
	                console.log('재고 정보 저장 성공하셨습니다.');
	            },
	            error: function () {
	                alert('재고 정보 저장에 실패하셨습니다.');
	            }
	        });
	    }
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
</body>
</html>
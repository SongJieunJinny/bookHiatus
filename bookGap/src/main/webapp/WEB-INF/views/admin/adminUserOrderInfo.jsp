<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminUserOrderInfo</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<style>
	.orderModal {
		border: 1px solid black;
		display: none;
		position: fixed;
		z-index: 10;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		overflow: auto;
		background-color: rgba(0, 0, 0, 0.4);
	}
	.orderModalContent {
		background-color: #fefefe;
		margin: 8% auto;
		border: 1px solid #888;
		width: 100%;
		max-width: 300px;
		border-radius: 20px;
		text-align: center;
		padding: 30px 0;
		font-family: 'Arial', sans-serif;
	}
	.orderModalHeadTitle {
		font-size: 24px;
		font-weight: bold;
		margin-bottom: 25px;
	}
	.orderModalSection {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		padding-left: 15%;
		width: 100%;
	}
	.orderModalItemContainer {
		width: 85%;
		display: flex;
		justify-content: flex-start;
		align-items: center;
		margin: 12px 0;
	}
	.orderModalItemLabel {
		width: 35%;
		font-weight: bold;
		font-size: 14px;
	}
	.orderModalItemValue,
	.orderModalItemSelect {
		flex: 1;
		text-align: left;
		font-size: 14px;
		color: #333;
	}
	.orderModalItemSelect {
		padding: 6px;
		border: 1px solid #aaa;
		border-radius: 6px;
	}
	.orderModalFooter {
		display: flex;
		justify-content: center;
		gap: 15px;
		margin-top: 25px;
	}
	.orderModalButton {
		padding: 10px 20px;
		background-color: black;
		color: white;
		font-size: 16px;
		border-radius: 10px;
		border: none;
		cursor: pointer;
	}
	.orderModalButton:hover {
		background-color: #444;
	}
	#deliveryAddressText{
		margin-top:10px;
	}
	.modalOrderContainer{
		margin: 5% 1% 0% 1%;
	}
	.modalOrderInfoContainer{
		margin: 1% 2% 0% 1%;
	}
	.datatable-selector {
		padding: 8px;
		width: 170%;
		margin-left: -10px;
		margin-bottom:10px;
		margin-right: 20px;
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
					<h1 class="mt-4">User Order Info Management System</h1>
					<br>
					<div class="card mb-4">
						<div class="card-body">
							회원전용 주문 및 배송관리
						</div>
					</div>
					<div class="card mb-4">
						<div class="card-header">
							<i class="fas fa-table me-1"></i>
							회원 전용 주문 목록 
						</div>
						<div class="card-body">
							<table id="datatablesSimple">
								<thead>
									<tr>
										<th>주문 번호</th>
										<th>주문일</th>
										<th>주문 상태</th>
										<th>총 주문 금액</th>
										<th>배송 상태</th>
										<th>상세보기</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${orderList}">
										<tr>
											<td>${order.orderId}</td>
											<td>${order.orderDate}</td>
											<td>${order.orderStatus}</td>
											<td>${order.totalPrice}</td>
											<td>${order.userId}</td>
											<td>
											<button class="btn btn-sm btn-dark viewBtn" data-order-id="${order.orderId}">상세보기</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							 <!-- 주문 상세 모달 -->
							<div class="modal fade" id="orderModal" tabindex="-1" aria-labelledby="orderModalLabel" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered modal-lg">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title" id="orderModalLabel" style="margin-top: 1%; font-size: 24px; font-weight: bold;">주문 상세 정보</h5>
											<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
										</div>
										<div class="modal-body">
											<div class="modalOrderInfoContainer">
												<h6 class="fw-bold" style="text-align: center;">주문 정보</h6>
												<ul class="list-group mb-3">
													<li class="list-group-item">주문 번호 : <span id="orderNum"></span></li>
													<li class="list-group-item">주문일자 : 2025-04-07</li>
													<li class="list-group-item">결제 수단 : 카드</li>
													<li class="list-group-item">결제 상태 : 정상</li>
													<li class="list-group-item">
														주문 상태:
														<select class="form-select d-inline w-auto ms-2" id="orderStatus">
															<option>결제완료</option>
															<option>주문취소</option>
															<option>환불요청</option>
															<option>교환요청</option>
														</select>
													</li>
												</ul>
											</div>
											<div class="modalOrderContainer">
												<h6 class="fw-bold" style="text-align: center;">배송 정보</h6>
												<ul class="list-group mb-3">
													<li class="list-group-item">수령인 : 홍길동 / 010-1234-5678</li>
													<li class="list-group-item">주소 : 전주시 이젠로 190 302동 1001호</li>
													<li class="list-group-item">요청사항 : 문 앞에 놓아주세요</li>
													<li class="list-group-item">
														배송 상태 :
														<select class="form-select d-inline w-auto ms-2" id="deliveryStatus">
															<option>배송 준비</option>
															<option>배송 중</option>
															<option>배송 완료</option>
														</select>
													</li>
													<li class="list-group-item">
														택배사 :
														<input type="text" class="form-control d-inline w-50 ms-2" id="courier" value="CJ대한통운" />
													</li>
													<li class="list-group-item">
														송장번호 :
														<input type="text" class="form-control d-inline w-50 ms-2" id="invoice" value="123456789" />
													</li>
												</ul>
											</div>
											<div class="modalOrderContainer">
												<h6 class="fw-bold" style="text-align: center;">상품 정보</h6>
												<table class="table" style="border: 1px solid lightgrey; border-radius: 10px; ">
													<thead>
														<tr>
															<th>상품명</th>
															<th>수량</th>
															<th>가격</th>
															<th>옵션</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>고흐로 읽는 심리 수업</td>
															<td>2</td>
															<td>25,000원</td>
															<td>블랙</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div class="modalOrderContainer">
												<h6 class="fw-bold" style="text-align: center;">총 결제 내역</h6>
												<ul class="list-group mb-3">
													<li class="list-group-item">상품 합계 : 50,000원</li>
													<li class="list-group-item">배송비 : 3,000원</li>
													<li class="list-group-item">할인 : -5,000원</li>
													<li class="list-group-item">최종 결제 금액 : 48,000원</li>
												</ul>
												<div class="d-flex justify-content-end gap-2">
													<button class="btn btn-dark" id="saveOrder">저장</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
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
	$(document).ready(function () {
		  // 모달 관련 변수
		  let selectedRow = null;
		
		  // 상세보기 버튼 클릭 시
		  $(document).on("click", ".viewBtn", function () {
			  const orderId = $(this).data("order-id");
			
			  $.ajax({
			    url: "/admin/adminUserOrderInfo/getOrderDetail.do",
			    method: "GET",
			    data: { orderId: orderId },
			    success: function (result) {
			      // 주문 정보
			      $("#orderNum").text(result.orderId);
			      $("#orderStatus").val(result.orderStatus);
			      $("#deliveryStatus").val(result.deliveryStatus);
			      $("#courier").val(result.courier);
			      $("#invoice").val(result.invoice);
			      
			      // 수령인 정보
			      $(".modal-body li:contains('수령인')").html("수령인 : " + result.receiverName + " / " + result.receiverPhone);
			      $(".modal-body li:contains('주소')").html("주소 : " + result.receiverRoadAddress + " " + result.receiverDetailAddress);
			      $(".modal-body li:contains('요청사항')").html("요청사항 : " + (result.deliveryRequest || "-"));
			
			      // 상품 정보 테이블 바인딩
			      const productTable = $(".modalOrderContainer table tbody");
			      productTable.empty();
			      result.orderDetails.forEach(function (item) {
			        const row = `
			          <tr>
			            <td>${item.book.title}</td>
			            <td>${item.orderCount}</td>
			            <td>${item.orderPrice.toLocaleString()}원</td>
			            <td>${item.book.bookCategory}</td>
			          </tr>
			        `;
			        productTable.append(row);
			      });
			
			      // 결제 정보 (예시)
			      const total = result.totalPrice.toLocaleString();
			      $(".modalOrderContainer ul:contains('총 결제')").html(`
			        <li class="list-group-item">상품 합계 : ${total}원</li>
			        <li class="list-group-item">배송비 : 3,000원</li>
			        <li class="list-group-item">할인 : -0원</li>
			        <li class="list-group-item">최종 결제 금액 : ${total}원</li>
			      `);
			
			      const modal = new bootstrap.Modal($("#orderModal")[0]);
			      modal.show();
			    },
			    error: function () {
			      alert("주문 상세 정보를 불러오는 데 실패했습니다.");
			    }
			  });
			});
		
		  // 저장 버튼 클릭 시
		  $("#saveOrder").on("click", function () {
		    const orderStatus = $("#orderStatus").val();
		    const deliveryStatus = $("#deliveryStatus").val();
		    const courier = $("#courier").val();
		    const invoice = $("#invoice").val();
		
		    const orderNum = $("#orderNum").text();
		
		    // 테이블에 반영
		    if (selectedRow) {
		      selectedRow.find("td").eq(2).text(orderStatus);   // 주문 상태
		      selectedRow.find("td").eq(4).text(deliveryStatus); // 배송 상태
		    }
		
		    alert(`저장되었습니다.\n주문번호: ${orderNum}\n주문상태: ${orderStatus}\n배송상태: ${deliveryStatus}\n택배사: ${courier}\n송장번호: ${invoice}`);
		
		    // 모달 닫기
		    const modalInstance = bootstrap.Modal.getInstance($("#orderModal")[0]);
		    modalInstance.hide();
		  });
		
		  // simple-datatables 초기화 (선택사항)
		  // const dataTable = new simpleDatatables.DataTable("#datatablesSimple");
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

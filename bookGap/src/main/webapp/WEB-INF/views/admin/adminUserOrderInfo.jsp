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
										<th>주문자 </th>
										<th>상세보기</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${orderList}">
										<tr>
											<td>${order.orderId}</td>
											<td>${order.orderDate}</td>
											<td>
												 <c:choose>
										          <c:when test="${order.orderStatus == 1}">배송 준비중</c:when>
										          <c:when test="${order.orderStatus == 2}">배송중</c:when>
										          <c:when test="${order.orderStatus == 3}">배송완료</c:when>
										          <c:when test="${order.orderStatus == 4}">주문취소</c:when>
										          <c:when test="${order.orderStatus == 5}">교환/반품</c:when>
										          <c:otherwise>알 수 없음</c:otherwise>
										        </c:choose>
											</td>
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
							      <!-- 모달 헤더 -->
							      <div class="modal-header">
							        <h5 class="modal-title fw-bold" id="orderModalLabel">주문 상세 정보</h5>
							        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
							      </div>
							
							      <!-- 모달 본문 -->
							      <div class="modal-body">
							        <!-- 주문 정보 -->
							        <h6 class="fw-bold">주문 정보</h6>
							        <ul class="list-group mb-3" id="orderInfoList">
							          <!-- Ajax로 동적 바인딩됨 -->
							        </ul>
							
							        <!-- 배송 정보 -->
							        <h6 class="fw-bold">배송 정보</h6>
							        <ul class="list-group mb-3" id="deliveryInfo">
							          <!-- Ajax로 동적 바인딩됨 -->
							        </ul>
							
							        <!-- 상품 정보 -->
							        <h6 class="fw-bold">상품 정보</h6>
							        <table class="table mb-3" style="border: 1px solid lightgrey; border-radius: 10px;">
							          <thead>
							            <tr>
							              <th>상품명</th>
							              <th>수량</th>
							              <th>가격</th>
							              <th>옵션</th>
							            </tr>
							          </thead>
							          <tbody id="productTable">
							            <!-- Ajax로 동적 바인딩됨 -->
							          </tbody>
							        </table>
							
							        <!-- 결제 내역 -->
							        <h6 class="fw-bold">총 결제 내역</h6>
							        <ul class="list-group mb-3" id="paymentSummaryList">
							          <!-- Ajax로 동적 바인딩됨 -->
							        </ul>
							      </div>
							
							      <!-- 모달 푸터 -->
							      <div class="modal-footer">
							        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							        <button type="button" class="btn btn-dark" id="saveOrder">저장</button>
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
		
		$(document).on("click", ".viewBtn", function () {
			  const orderId = $(this).data("order-id");
			  $.ajax({
			  url: "<%=request.getContextPath()%>/admin/adminUserOrderInfo/getOrderDetail.do",
			  method: "GET",
			  data: { orderId },
			  success: function (result) {
			  const paymentMethodMap = { 1: 'Toss', 2: 'KakaoPay' };
			  const paymentStatusMap = { 1: '결제 중', 2: '결제 승인', 3: '결제 취소' };
			  const paymentMethodText = paymentMethodMap[result.payment?.paymentMethod] || '기타';
			  const paymentStatusText = paymentStatusMap[result.payment?.status] || '알 수 없음';
			  const total = result.totalPrice || 0;
		        //배송비 조건 처리
		        let shippingFee = 3000;
		        if (total >= 50000) {
		          shippingFee = 0;
		        }
		        const discount = 0;
		        const finalPrice = total + shippingFee - discount;


			  const orderInfo =
				    '<li class="list-group-item">주문 번호: ' + (result.orderId ?? '-') + '</li>' +
				    '<li class="list-group-item">주문일자: ' + (result.formattedOrderDate || '-') + '</li>' +
				    '<li class="list-group-item">결제 수단: ' + paymentMethodText + '</li>' +
				    '<li class="list-group-item">' +
				    '결제 상태 :' +
				    '<select class="form-select d-inline w-auto ms-2" id="paymentStatus">' +
				      '<option value="1"' + (result.payment?.status == 1 ? ' selected' : '') + '>결제중</option>' +
				      '<option value="2"' + (result.payment?.status == 2 ? ' selected' : '') + '>결제승인</option>' +
				      '<option value="3"' + (result.payment?.status == 3 ? ' selected' : '') + '>결제취소</option>' +
				    '</select>' +
				    '</li>' +
				    '<li class="list-group-item">' +
				    '주문 상태 :' +
				    '<select class="form-select d-inline w-auto ms-2" id="orderStatus">' +
				      '<option value="1"' + (result.orderStatus == 1 ? ' selected' : '') + '>배송 준비중</option>' +
				      '<option value="2"' + (result.orderStatus == 2 ? ' selected' : '') + '>배송 중</option>' +
				      '<option value="3"' + (result.orderStatus == 3 ? ' selected' : '') + '>배송 완료</option>' +
				      '<option value="4"' + (result.orderStatus == 4 ? ' selected' : '') + '>주문 취소</option>' +
				      '<option value="5"' + (result.orderStatus == 5 ? ' selected' : '') + '>교환/반품</option>' +
				    '</select>' +
				    '</li>';

			  const deliveryInfo =
				  '<li class="list-group-item">수령인: ' + (result.receiverName || '-') + ' / ' + (result.receiverPhone || '-') + '</li>' +
				  '<li class="list-group-item">주소: ' + (result.receiverRoadAddress || '-') + ' ' + (result.receiverDetailAddress || '') + '</li>' +
				  '<li class="list-group-item">요청사항: ' + (result.deliveryRequest || '-') + '</li>' +
				  '<li class="list-group-item">' +
				    '배송 상태 :' +
				    '<select class="form-select d-inline w-auto ms-2" id="deliveryStatus">' +
				      '<option' + (result.orderStatus == 1 ? ' selected' : '') + '>배송 준비</option>' +
				      '<option' + (result.orderStatus == 2 ? ' selected' : '') + '>배송 중</option>' +
				      '<option' + (result.orderStatus == 3 ? ' selected' : '') + '>배송 완료</option>' +
				    '</select>' +
				  '</li>' +
				  '<li class="list-group-item">' +
				    '택배사 :' +
				    '<input type="text" class="form-control d-inline w-50 ms-2" id="courier" value="' + (result.courier || '') + '" />' +
				  '</li>' +
				  '<li class="list-group-item">' +
				    '송장번호 :' +
				    '<input type="text" class="form-control d-inline w-50 ms-2" id="invoice" value="' + (result.invoice || '') + '" />' +
				  '</li>';
				  
		        const productTable = $("#productTable");
		        productTable.empty();

		        if (result.orderDetails && result.orderDetails.length > 0) {
		          result.orderDetails.forEach(function (item) {
		            const price = Number(item.orderPrice || 0);
		            const row =
		              '<tr>' +
		              '<td>' + (item.book?.title || '-') + '</td>' +
		              '<td>' + (item.orderCount ?? 0) + '</td>' +
		              '<td>' + price.toLocaleString() + '원</td>' +
		              '<td>' + (item.book?.bookCategory || '-') + '</td>' +
		              '</tr>';
		            productTable.append(row);
		          });
		        } else {
		          productTable.append('<tr><td colspan="4">상품 정보 없음</td></tr>');
		        }

		        const paymentSummaryList =
		          '<li class="list-group-item">상품 합계 : ' + total.toLocaleString() + '원</li>' +
		          '<li class="list-group-item">배송비 : ' + shippingFee.toLocaleString() + '원</li>' +
		          '<li class="list-group-item">할인 : -' + discount.toLocaleString() + '원</li>' +
		          '<li class="list-group-item">최종 결제 금액 : ' + finalPrice.toLocaleString() + '원</li>';

		        $("#orderInfoList").html(orderInfo);
		        $("#deliveryInfo").html(deliveryInfo);
		        $("#paymentSummaryList").html(paymentSummaryList);

		        new bootstrap.Modal($("#orderModal")[0]).show();
		      },
		      error: function () {
		        alert("주문 상세 정보를 불러오는 데 실패했습니다.");
		      }
		    });
		  });
		  // 저장 버튼 클릭 시
		$("#saveOrder").on("click", function () {
			 
			  const orderId = Number($("#orderModal").data("orderId"));
			
			  const orderStatus   = Number($("#orderStatus").val());      // 주문 상태
			  const paymentStatus = Number($("#paymentStatus").val());    // 결제 상태
			  const courier       = ($("#courier").val() || "").trim();   // 택배사
			  const invoice       = ($("#invoice").val() || "").trim();   // 송장번호
			  const deliveryStatus = $("#deliveryStatus").val();          // UI표시용(서버 미전송)
			
			  if (!orderId) {
			    alert("주문 번호를 확인할 수 없습니다.");
			    return;
			  }
			
			  // (선택) 상태 전이 검증 예시: 배송 중/완료로 바꾸려면 송장 필수
			  if ((orderStatus === 2 || orderStatus === 3) && (!courier || !invoice)) {
			    alert("배송 중/완료 상태로 변경하려면 택배사와 송장번호가 필요합니다.");
			    return;
			  }
			
			  // (선택) 송장번호 간단 유효성 - 영문/숫자만
			  if (invoice && /[^a-zA-Z0-9]/.test(invoice)) {
			    alert("송장번호는 영문/숫자만 입력 가능합니다.");
			    return;
			  }
			
			  const csrfHeader = $("meta[name='_csrf_header']").attr("content");
			  const csrfToken  = $("meta[name='_csrf']").attr("content");
			
			  // 버튼 중복 클릭 방지
			  const $btn = $(this).prop("disabled", true);
			
			  $.ajax({
			    url: "<%=request.getContextPath()%>/admin/adminUserOrderInfo/updateUserOrder.do",
			    method: "POST",
			    contentType: "application/json; charset=UTF-8",
			    data: JSON.stringify({
			      orderId,
			      orderStatus,
			      paymentStatus,
			      courier: courier || null,
			      invoice: invoice || null
			    }),
			    beforeSend: function(xhr){
			      if (csrfHeader && csrfToken) xhr.setRequestHeader(csrfHeader, csrfToken);
			    },
			    success: function (res) {
			      // 서버가 "success" 문자열을 주거나 {success:true}를 줘도 대응
			      const ok = (res === "success") || (typeof res === "object" && res?.success);
			      if (!ok) {
			        alert("업데이트 실패");
			        return;
			      }
			
			      // 테이블 상태 텍스트 갱신
			      const orderStatusTextMap = {1:"배송 준비중",2:"배송 중",3:"배송 완료",4:"주문 취소",5:"교환/반품"};
			      if (selectedRow) {
			        selectedRow.find("td").eq(2).text(orderStatusTextMap[orderStatus] || "-");
			      }
			
			      alert("저장되었습니다.");
			      const modalInstance = bootstrap.Modal.getInstance($("#orderModal")[0]);
			      modalInstance.hide();
			    },
			    error: function () {
			      alert("업데이트에 실패했습니다. 다시 시도해 주세요.");
			    },
			    complete: function() {
			      $btn.prop("disabled", false);
			    }
			  });
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

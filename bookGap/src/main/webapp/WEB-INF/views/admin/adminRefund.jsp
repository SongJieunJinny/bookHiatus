<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminRefund</title>
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
					<h1 class="mt-4">Refund Management System</h1>
					<br>
					<div class="card mb-4">
						<div class="card-body">
							환불 관리 페이지 
						</div>
					</div>
					<div class="card mb-4">
						<div class="card-header">
							<i class="fas fa-table me-1"></i>
							환불 목록 
						</div>
						<div class="card-body">
							<table id="datatablesSimple">
								<thead>
									<tr>
										<th>환불 번호</th>
										<th>환불 신청일 </th>
										<th>환불 상태</th>
										<th>환불 사유 </th>
										<th>주문자 </th>
										<th>상세보기</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="order" items="${orderList}">
										<tr>
											<td>${order.refundNo}</td>
											<td>${order.createdAt}</td>
											<td>
												 <c:choose>
										          <c:when test="${order.refundStatus == 1}">환불 요청</c:when>
										          <c:when test="${order.refundStatus == 2}">처리 중</c:when>
										          <c:when test="${order.refundStatus == 3}">환불 완료</c:when>
										          <c:when test="${order.refundStatus == 4}">거절</c:when>
										          <c:otherwise>알 수 없음</c:otherwise>
										        </c:choose>
											</td>
											<td>${order.refundReason}</td>
											<td>${order.userId != null ? order.userId : order.guestId}</td>
											<td>
											<button class="btn btn-sm btn-dark viewBtn" data-refund-no="${order.refundNo}">상세보기</button>
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
							        <h5 class="modal-title fw-bold" id="orderModalLabel">환불 상세 정보</h5>
							        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
							      </div>
							
							      <!-- 모달 본문 -->
							      <div class="modal-body">
							        
							       <h6 class="fw-bold">환불 정보</h6>
										<ul class="list-group mb-3" id="refundInfoList">
										  <li class="list-group-item">환불 번호: ${order.refundNo}</li>
										  <li class="list-group-item">환불 사유: ${order.refundReason}</li>
										  <li class="list-group-item">이메일: ${order.refundMail}</li>
										  <li class="list-group-item">환불 상태:
										    <select class="form-select d-inline w-auto ms-2" id="refundStatus">
										      <option value="1">환불 요청</option>
										      <option value="2">처리 중</option>
										      <option value="3">환불 완료</option>
										      <option value="4">거절</option>
										    </select>
										  </li>
										</ul>
							
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
$(function () {
  let selectedRow = null;

  // 상세보기 버튼
  $(document).on("click", ".viewBtn", function () {
    selectedRow = $(this).closest("tr");
    const refundNo = $(this).data("refund-no"); // 환불번호로 변경
    $.ajax({
      url: "<%=request.getContextPath()%>/admin/adminRefund/getRefundDetail.do",
      method: "GET",
      data: { refundNo }, // refundNo 전달
      success: function (result) {
        // 모달에 환불번호 보관
        $("#orderModal").data("refundNo", refundNo);

        const refundStatus = Number(result?.refundStatus || 1);

        // 환불 정보 블록 렌더링
        const refundInfoHtml =
          '<li class="list-group-item">환불 번호: ' + (result?.refundNo ?? '-') + '</li>' +
          '<li class="list-group-item">신청일시: ' + (result?.createdAt ?? '-') + '</li>' +
          '<li class="list-group-item">주문 번호: ' + (result?.orderId ?? '-') + '</li>' +
          '<li class="list-group-item">이메일: ' + (result?.refundMail ?? '-') + '</li>' +
          '<li class="list-group-item">환불 사유:<div class="mt-2" style="white-space:pre-wrap">' + (result?.refundReason ?? '-') + '</div></li>' +
          '<li class="list-group-item">환불 상태: ' +
            '<select class="form-select d-inline w-auto ms-2" id="refundStatus">' +
              '<option value="1" ' + (refundStatus===1?'selected':'') + '>환불 요청</option>' +
              '<option value="2" ' + (refundStatus===2?'selected':'') + '>처리 중</option>' +
              '<option value="3" ' + (refundStatus===3?'selected':'') + '>환불 완료</option>' +
              '<option value="4" ' + (refundStatus===4?'selected':'') + '>거절</option>' +
            '</select>' +
          '</li>';

        $("#refundInfoList").html(refundInfoHtml);

        // 증빙 이미지 렌더링
        $("#refundImageContainer").remove(); // 중복 삽입 방지
        const imageFile = result?.refundImage;
        let imageHtml = '<div class="text-muted">증빙 이미지가 없습니다.</div>';
        if (imageFile) {
          // 로컬 정적 매핑(예: /uploads/refund/**) 사용 시
          const imgUrl = "<%=request.getContextPath()%>/uploads/refund/" + imageFile;
          imageHtml =
            '<a href="'+imgUrl+'" target="_blank" rel="noopener">' +
              '<img src="'+imgUrl+'" alt="환불 증빙 이미지" ' +
              'style="max-width:180px;height:auto;border:1px solid #ddd;border-radius:8px"/>' +
            '</a>';
        }
        $("#refundInfoList").after('<div id="refundImageContainer" class="mb-3">'+imageHtml+'</div>');

        
        const productTable = $("#productTable");
        if (productTable.length) {
          productTable.empty();
          if (result?.orderDetails?.length) {
            result.orderDetails.forEach(function (item) {
              productTable.append(
                '<tr>' +
                  '<td>' + (item.book?.title ?? '-') + '</td>' +
                  '<td>' + (item.orderCount ?? 0) + '</td>' +
                  '<td>' + (Number(item.orderPrice||0)).toLocaleString() + '원</td>' +
                  '<td>' + (item.book?.bookCategory ?? '-') + '</td>' +
                '</tr>'
              );
            });
          } else {
            productTable.append('<tr><td colspan="4">상품 정보 없음</td></tr>');
          }
        }

        new bootstrap.Modal($("#orderModal")[0]).show();
      },
      error: function () {
        alert("환불 상세 정보를 불러오지 못했습니다.");
      }
    });
  });

  // 저장(환불 상태 업데이트)
  $("#saveOrder").on("click", function () {
    const refundNo = $("#orderModal").data("refundNo");
    if (!refundNo) { alert("환불 번호를 확인할 수 없습니다."); return; }

    const refundStatus = Number($("#refundStatus").val());

    const csrfHeader = $("meta[name='_csrf_header']").attr("content");
    const csrfToken  = $("meta[name='_csrf']").attr("content");

    const $btn = $(this).prop("disabled", true);

    $.ajax({
      url: "<%=request.getContextPath()%>/admin/adminRefund/updateRefundStatus.do",
      method: "POST",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({ refundNo, refundStatus }), // 환불 상태만 전송
      beforeSend: function (xhr) {
        if (csrfHeader && csrfToken) xhr.setRequestHeader(csrfHeader, csrfToken);
      },
      success: function (res) {
        const ok = (res === "success") || (typeof res === "object" && res?.success);
        if (!ok) { alert("업데이트 실패"); return; }

        // 목록 테이블 환불 상태 텍스트 갱신 (3번째 컬럼)
        if (selectedRow) {
          const textMap = {1:"환불 요청", 2:"처리 중", 3:"환불 완료", 4:"거절"};
          selectedRow.find("td").eq(2).text(textMap[refundStatus] || "-");
        }

        alert("저장되었습니다.");
        bootstrap.Modal.getInstance($("#orderModal")[0]).hide();
      },
      error: function () {
        alert("업데이트에 실패했습니다. 다시 시도해 주세요.");
      },
      complete: function () { $btn.prop("disabled", false); }
    });
  });

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
</body>
</html>

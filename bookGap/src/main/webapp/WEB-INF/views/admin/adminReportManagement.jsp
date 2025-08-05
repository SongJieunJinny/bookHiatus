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
<title>Report Management System</title>
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
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
		width: 80%;
		max-width: 400px;
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
	.modalGuestOrder{
		display: flex;
		margin-bottom: -3%;
    }
	.modalGuestOrderContainer{
		width: 100%;
    }
	.modalGuestOrderInfo,
	.modalGuestOrderProductInfo,
	.modalGuestOrderPayment {
		padding: 3% 3% 0% 3%;
    }
	.datatable-selector {
		padding: 8px;
		width: 170%;
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
						<h1 class="mt-4">Report Management System</h1>
						<br>
						<div class="card mb-4">
							<div class="card-body">
								신고 관리 
							</div>
						</div>
						<div class="card mb-4">
							<div class="card-header">
								<i class="fas fa-table me-1"></i>
								Report Management System Table
							</div>
							<div class="card-body">
								<form method="get" action="${pageContext.request.contextPath}/admin/adminReportManagement.do" class="mb-3">
									<select name="filterStatus" class="form-select w-25 d-inline">
										<option value="">전체</option>
										<option value="접수됨" ${selectedStatus == '접수됨' ? 'selected' : ''}>접수됨</option>
										<option value="처리중" ${selectedStatus == '처리중' ? 'selected' : ''}>처리중</option>
										<option value="처리완료" ${selectedStatus == '처리완료' ? 'selected' : ''}>처리완료</option>
										<option value="반려됨" ${selectedStatus == '반려됨' ? 'selected' : ''}>반려됨</option>
									</select>
									<button class="btn btn-outline-dark" type="submit">필터</button>
								</form>
								<table id="datatablesSimple">
									<thead>
										<tr>
											<th>댓글번호</th>
											<th>댓글 내용</th>
											<th>책 제목</th>
											<th>신고 횟수</th>
											<th>마지막 신고일</th>
											<th>처리 상태</th>
											<th>댓글 상태</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${reportSummaryList}" var="report">
											<tr>
												<td>${report.commentNo}</td>
												<td>${report.commentContent}</td>
												<td>${report.bookName}</td>
												<td>${report.reportCount}</td>
												<td>${report.lastReportDate}</td>
												<td>
													<c:choose>
														<c:when test="${report.status == '접수됨'}">접수됨</c:when>
														<c:when test="${report.status == '처리중'}">처리중</c:when>
														<c:when test="${report.status == '처리완료'}">처리완료</c:when>
														<c:when test="${report.status == '반려됨'}">반려됨</c:when>
														<c:otherwise>미확인</c:otherwise>
													</c:choose>
												</td>
												 <td>
													<c:choose>
														<c:when test="${report.commentState == 1}">활성화</c:when>
														<c:when test="${report.commentState == 2}">비활성화</c:when>
														<c:otherwise>알수없음</c:otherwise>
													</c:choose>
												</td>
												<td><button class="btn btn-sm btn-dark viewBtn" data-commentno="${report.commentNo}">상세보기 </button></td>
											</tr>
										</c:forEach>
									</tbody>
									</table>
								 <!-- 주문 상세 모달 -->
								<div class="modal fade" id="complainModal" tabindex="-1">
									<div class="modal-dialog modal-lg">
										<div class="modal-content p-4">
											<h5 class="fw-bold mb-3">댓글 신고 상세</h5>
											<input type="hidden" id="modalComplainNo">
											<p><strong>댓글 번호:</strong> <span id="modalCommentNo"></span></p>
											<p><strong>댓글 내용:</strong> <span id="modalCommentContent"></span></p>
											<p><strong>책 제목:</strong> <span id="modalBookName"></span></p>
								
											<div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
												<table class="table table-bordered text-center align-middle">
													<thead class="table-light">
														<tr>
															<th>신고자</th>
															<th>유형</th>
															<th>일시</th>
															<th>처리 상태</th>
															<th>메모</th>
														</tr>
													</thead>
													<tbody id="reportDetailBody">
													</tbody>
												</table>
											</div>
											<div class="text-center mt-3" id="pagination"></div>
											<div class="mb-3">
												<label for="commentState" class="form-label">댓글 상태</label>
												<select id="commentState" class="form-select">
													<option value="1">활성화</option>
													<option value="2">비활성화</option>
												</select>
											</div>
								
											<div class="text-end">
												<button class="btn btn-dark" onclick="saveComplain()">저장</button>
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

// 신고 유형 숫자를 한글로 변환
const complainTypeMap = {
  1: "욕설/비방",
  2: "스팸",
  3: "음란물"
};

function mapType(type) {
  return complainTypeMap[parseInt(type)] || "기타";
}
//페이징 관련 전역 변수
let fullList = [];
let currentPage = 1;
const pageSize = 5;

  // 상세 보기 버튼 클릭 시 신고 정보 불러오기
// 상세보기 버튼 클릭 시
$(document).on("click", ".viewBtn", function () {
  const id = $(this).data("commentno");

  $.ajax({
    url: "<%=request.getContextPath()%>/admin/getComplainDetail.do",
    type: "GET",
    data: { commentNo: id },
    success: function (data) {
      const main = data.main;
      fullList = data.complainList;
      currentPage = 1;

      // 모달 기본 정보 설정
      $("#modalCommentNo").text(main.commentNo);
      $("#modalCommentContent").text(main.commentContent);
      $("#modalBookName").text(main.bookName);
      $("#commentState").val(main.commentState);

      // 첫 페이지 렌더링
      renderReportDetailPage(currentPage);

      // 모달 열기
      new bootstrap.Modal($("#complainModal")[0]).show();
    },
    error: function () {
      alert("데이터를 불러오는 중 오류가 발생했습니다.");
    }
  });
});
  
function renderReportDetailPage(page) {
	console.log("fullList", fullList);
	console.log("총 페이지 수:", Math.ceil(fullList.length / pageSize));
	  const start = (page - 1) * pageSize;
	  const end = start + pageSize;
	  const pageList = fullList.slice(start, end);

	  const reportDetailBody = $("#reportDetailBody");
	  reportDetailBody.empty();

	  pageList.forEach(item => {
	    const formattedDate = new Date(item.reportDate).toLocaleString();
	    const processNote = item.processNote || "메모 없음";

	    const tr = document.createElement('tr');

	    const tdUserId = document.createElement('td');
	    tdUserId.textContent = item.userId;
	    tr.appendChild(tdUserId);

	    const tdComplainType = document.createElement('td');
	    tdComplainType.textContent = item.complainTypeText;
	    tr.appendChild(tdComplainType);

	    const tdReportDate = document.createElement('td');
	    tdReportDate.textContent = formattedDate;
	    tr.appendChild(tdReportDate);

	    const tdStatus = document.createElement('td');
	    const select = document.createElement('select');
	    select.classList.add("form-select", "form-select-sm", "complain-status");
	    select.setAttribute("data-complainno", item.complainNo);

	    ["접수됨", "처리중", "처리완료", "반려됨"].forEach(status => {
	      const option = document.createElement('option');
	      option.value = status;
	      option.textContent = status;
	      if (item.status === status) option.selected = true;
	      select.appendChild(option);
	    });

	    tdStatus.appendChild(select);
	    tr.appendChild(tdStatus);

	    const tdProcessNote = document.createElement('td');
	    const textarea = document.createElement('textarea');
	    textarea.classList.add("form-control", "form-control-sm", "complain-note");
	    textarea.setAttribute("data-complainno", item.complainNo);
	    textarea.value = item.processNote || "";
	    tdProcessNote.appendChild(textarea);
	    tr.appendChild(tdProcessNote);

	    reportDetailBody.append(tr);
	  });

	  renderPagination();
	}
function renderPagination() {
	  const pagination = $("#pagination");
	  pagination.empty();
	
	  const totalPages = Math.ceil(fullList.length / pageSize);
	  if (totalPages <= 1) return;
	
	  const prevBtn = $('<button class="btn btn-outline-secondary btn-sm mx-1">&laquo; 이전</button>');
	  prevBtn.prop('disabled', currentPage === 1);
	  prevBtn.on("click", () => {
	    if (currentPage > 1) {
	      currentPage--;
	      renderReportDetailPage(currentPage);
	    }
	  });
	  pagination.append(prevBtn);
	
	  for (let i = 1; i <= totalPages; i++) {
	    const btn = $('<button class="btn btn-outline-dark btn-sm mx-1"></button>').text(i);
	    if (i === currentPage) {
	      btn.removeClass("btn-outline-dark").addClass("btn-dark text-white");
	    }
	    btn.on("click", () => {
	      currentPage = i;
	      renderReportDetailPage(currentPage);
	    });
	    pagination.append(btn);
	  }
	
	  const nextBtn = $('<button class="btn btn-outline-secondary btn-sm mx-1">다음 &raquo;</button>');
	  nextBtn.prop('disabled', currentPage === totalPages);
	  nextBtn.on("click", () => {
	    if (currentPage < totalPages) {
	      currentPage++;
	      renderReportDetailPage(currentPage);
	    }
	  });
	  pagination.append(nextBtn);
	}

  // 신고 저장 처리
  function saveComplain() {
    const commentNo = $("#modalCommentNo").text();
    const commentState = $("#commentState").val();

    const complainList = [];
    $(".complain-status").each(function () {
      const complainNo = $(this).data("complainno");
      const status = $(this).val();
      const processNote = $(`.complain-note[data-complainno='${complainNo}']`).val();

      complainList.push({
        complainNo: complainNo,
        status: status,
        processNote: processNote
      });
    });

    $.ajax({
      url: "<%=request.getContextPath()%>/admin/updateComplainStatus.do",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        commentNo: commentNo,
        commentState: commentState,
        complainList: complainList
      }),
      success: function () {
        alert("저장이 완료되었습니다. ");
        location.reload();
      },
      error: function () {
        alert("저장 중 오류가 발생했습니다.");
      }
    });
  }

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
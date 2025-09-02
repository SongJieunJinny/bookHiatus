<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>adminIndex</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
							<h1 class="mt-4">Pages</h1>
							<br>
							<div class="row">
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">도서관리 </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminBook.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
								    <div class="card bg-secondary text-white mb-4">
								        <div class="card-body">추천 도서 관리</div>
								        <div class="card-footer d-flex align-items-center justify-content-between">
								            <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminRecommendBooks.do">View Details</a>
								            <div class="small text-white"><i class="fas fa-angle-right"></i></div>
								        </div>
								    </div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">재고관리 </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminInventoryManagement.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">회원관리 </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminUserInfo.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">비회원주문관리 </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminGuestOrderInfo.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">회원주문관리 </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminUserOrderInfo.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">환불 관리  </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminRefund.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">신고관리  </div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminReportManagement.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xl-6">
									<div class="card mb-4">
										<div class="card-header">
											<i class="fas fa-chart-area me-1"></i>
											Sales
										</div>
										<div class="card-body"><canvas id="salesChart" width="100%" height="40"></canvas></div>
									</div>
								</div>
								<div class="col-xl-6">
									<div class="card mb-4">
										<div class="card-header">
											<i class="fas fa-chart-bar me-1"></i>
											Schedule
										</div>
										<div class="card-body"><canvas id="scheduleChart" width="100%" height="40"></canvas></div>
									</div>
								</div>
							</div>	
						</div>
					</main>
					<jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
					<!--footer 삽입-->
				</div>
			</div>
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
			<script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
			<script>
				  const salesLabels = [
				    <c:forEach var="s" items="${dailyStats}" varStatus="i">
				      "${s.sales_date}"<c:if test="${!i.last}">,</c:if>
				    </c:forEach>
				  ];
				  const salesData = [
				    <c:forEach var="s" items="${dailyStats}" varStatus="i">
				      ${s.total_revenue}<c:if test="${!i.last}">,</c:if>
				    </c:forEach>
				  ];

				  // 일정 (요일별)
				  const scheduleLabels = [
				    <c:forEach var="d" items="${scheduleStats}" varStatus="i">
				      "${d.weekday}"<c:if test="${!i.last}">,</c:if>
				    </c:forEach>
				  ];
				  const scheduleData = [
				    <c:forEach var="d" items="${scheduleStats}" varStatus="i">
				      ${d.count}<c:if test="${!i.last}">,</c:if>
				    </c:forEach>
				  ];
			
			    const _salesLabels = (salesLabels && salesLabels.length) ? salesLabels : [];
			    const _salesData   = (salesData && salesData.length) ? salesData.map(Number) : [];
			    const _schedLabels = (scheduleLabels && scheduleLabels.length) ? scheduleLabels : [];
			    const _schedData   = (scheduleData && scheduleData.length) ? scheduleData.map(Number) : [];
			</script>
			</script>
			
			<script>
			    document.addEventListener("DOMContentLoaded", function () {
			    	const salesEl = document.getElementById("salesChart");
			        if (salesEl) {
			          new Chart(salesEl, {
			            type: 'line',
			            data: {
			              labels: _salesLabels,   // 일자
			              datasets: [{
			                label: '매출액',
			                data: _salesData,     // 매출액
			                borderColor: '#4e73df',
			                backgroundColor: 'rgba(78, 115, 223, 0.08)',
			                tension: 0.3,
			                fill: true
			              }]
			            },
			            options: {
			              scales: {
			                y: {
			                  ticks: {
			                    callback: v => v.toLocaleString() + '원' // 숫자 포맷팅
			                  }
			                }
			              }
			            }
			          });
			        }
			
			      const schedEl = document.getElementById("scheduleChart");
			      if (schedEl) {
			        new Chart(schedEl, {
			          type: 'bar',
			          data: {
			            labels: _schedLabels,   // 요일
			            datasets: [{
			              label: '일정 개수',
			              data: _schedData,     // 일정 건수
			              backgroundColor: [
			            	  '#6c757d', // 어두운 회색
			            	  '#adb5bd', // 중간 회색
			            	  '#ced4da', // 밝은 회색
			            	  '#dee2e6', // 더 밝은 회색
			            	  '#e9ecef', // 거의 흰색에 가까운 회색
			            	  '#f8f9fa', // 매우 연한 회색
			            	  '#495057'  // 딥 그레이
			            	]
			            }]
			          },
			          options: {
			            scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
			          }
			        });
			      }
			    });
			</script>
		</body>
</html> 
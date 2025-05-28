<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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
										<div class="card-body">Book</div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminBook.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">Order</div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminOrder.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">User Info</div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminUserInfo.do">View Details</a>
											<div class="small text-white"><i class="fas fa-angle-right"></i></div>
										</div>
									</div>
								</div>
								<div class="col-xl-3 col-md-6">
									<div class="card bg-secondary text-white mb-4">
										<div class="card-body">Guset Order Info</div>
										<div class="card-footer d-flex align-items-center justify-content-between">
											<a class="small text-white stretched-link" href="${pageContext.request.contextPath}/admin/adminGusetOrderInfo.do">View Details</a>
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
										<div class="card-body"><canvas id="myAreaChart" width="100%" height="40"></canvas></div>
									</div>
								</div>
								<div class="col-xl-6">
									<div class="card mb-4">
										<div class="card-header">
											<i class="fas fa-chart-bar me-1"></i>
											Schedule
										</div>
										<div class="card-body"><canvas id="myBarChart" width="100%" height="40"></canvas></div>
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
			<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
			<script src="<%=request.getContextPath()%>/resources/assets/demo/chart-area-demo.js"></script>
			<script src="<%=request.getContextPath()%>/resources/assets/demo/chart-bar-demo.js"></script>
		</body>
</html> 
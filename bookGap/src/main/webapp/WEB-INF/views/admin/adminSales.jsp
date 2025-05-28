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
<title>adminSales</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="/WEB-INF/views/include/adminHeader.jsp" />
    <div id="layoutSidenav">
      <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
          <div class="sb-sidenav-menu">
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
            <h1 class="mt-4">Sales</h1>
            <ol class="breadcrumb mb-4">
              <li class="breadcrumb-item"><a href="index.html">INDEX</a></li>
              <li class="breadcrumb-item active">Sales</li>
            </ol>
            <div class="card mb-4">
              <div class="card-body">매출관리 차트</div>
            </div>
            <!-- Line Chart -->
            <div class="card mb-4">
              <div class="card-header"><i class="fas fa-chart-area me-1"></i>Daily Sales (Line)</div>
              <div class="card-body"><canvas id="dailyRevenueChart" width="100%" height="30"></canvas></div>
            </div>
            <!-- Bar & Pie Charts -->
            <div class="row">
              <div class="col-lg-6">
                <div class="card mb-4">
                  <div class="card-header"><i class="fas fa-chart-bar me-1"></i>Bar Sales</div>
                  <div class="card-body"><canvas id="revenueBarChart" width="100%" height="50"></canvas></div>
                </div>
              </div>
              <div class="col-lg-6">
                <div class="card mb-4">
                  <div class="card-header"><i class="fas fa-chart-pie me-1"></i>Pie Sales</div>
                  <div class="card-body"><canvas id="salesPieChart" width="100%" height="50"></canvas></div>
                </div>
              </div>
            </div>
            <!-- Sales Log Table -->
            <div class="card mb-5">
              <div class="card-header"><i class="fas fa-table me-1"></i>판매 로그</div>
              <div class="card-body p-0">
                <table class="table table-bordered mb-0">
                  <thead class="table-light">
                    <tr>
                      <th>도서명</th>
                      <th>판매 수량</th>
                      <th>총 매출</th>
                      <th>판매일</th>
                    </tr>
                  </thead>
                  <tbody id="salesLogTable"></tbody>
                </table>
              </div>
            </div>
          </div>
        </main>
       <jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
      </div>
    </div>
    <!-- 차트 및 데이터 렌더링 -->
    <script>
			// 📦 하드코딩된 샘플 데이터
			const bookSales = [
				{ title: "작은 책방 이야기", sales: 120, revenue: 180000 },
				{ title: "고양이 산문집", sales: 90, revenue: 135000 },
				{ title: "하루를 닮은 책", sales: 60, revenue: 108000 },
				{ title: "조용한 숲의 대화", sales: 70, revenue: 112000 },
				{ title: "밤하늘 수첩", sales: 50, revenue: 90000 },
				{ title: "커피향과 책갈피", sales: 80, revenue: 144000 },
			];
	
			const dailyStats = [
				{ date: "2025-04-01", revenue: 12000 },
				{ date: "2025-04-02", revenue: 18000 },
				{ date: "2025-04-03", revenue: 22000 },
				{ date: "2025-04-04", revenue: 15000 },
				{ date: "2025-04-05", revenue: 11000 },
				{ date: "2025-04-06", revenue: 17000 },
				{ date: "2025-04-07", revenue: 20000 },
			];
	
			const salesLogs = [
				{ title: "작은 책방 이야기", sales: 5, revenue: 7500, date: "2025-04-07" },
				{ title: "고양이 산문집", sales: 3, revenue: 4500, date: "2025-04-07" },
				{ title: "하루를 닮은 책", sales: 4, revenue: 7200, date: "2025-04-06" },
				{ title: "조용한 숲의 대화", sales: 2, revenue: 3200, date: "2025-04-06" },
				{ title: "밤하늘 수첩", sales: 3, revenue: 5400, date: "2025-04-05" },
				{ title: "커피향과 책갈피", sales: 4, revenue: 7200, date: "2025-04-05" },
				{ title: "작은 책방 이야기", sales: 6, revenue: 9000, date: "2025-04-04" },
				{ title: "고양이 산문집", sales: 4, revenue: 6000, date: "2025-04-03" },
				{ title: "하루를 닮은 책", sales: 2, revenue: 3600, date: "2025-04-02" },
				{ title: "조용한 숲의 대화", sales: 3, revenue: 4800, date: "2025-04-01" },
			];
	
			// 📊 차트 렌더링
			document.addEventListener("DOMContentLoaded", function () {
				const titles = bookSales.map(b => b.title);
				const revenues = bookSales.map(b => b.revenue);
				const salesCounts = bookSales.map(b => b.sales);
	
				// Bar Chart
				new Chart(document.getElementById("revenueBarChart"), {
					type: "bar",
					data: {
						labels: titles,
						datasets: [{
							label: "총매출 (원)",
							backgroundColor: "#4e73df",
							data: revenues,
						}]
					},
					options: {
						scales: {
							y: {
								beginAtZero: true,
								ticks: {
									callback: val => val.toLocaleString() + "원"
								}
							}
						}
					}
				});
	
				// Pie Chart
				new Chart(document.getElementById("salesPieChart"), {
					type: "pie",
					data: {
						labels: titles,
						datasets: [{
							data: salesCounts,
							backgroundColor: ["#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b", "#858796", "#fd7e14"]
						}]
					}
				});
	
				// Line Chart
				new Chart(document.getElementById("dailyRevenueChart"), {
					type: "line",
					data: {
						labels: dailyStats.map(d => d.date),
						datasets: [{
							label: "일일 매출 (원)",
							data: dailyStats.map(d => d.revenue),
							fill: false,
							borderColor: "#e74a3b",
							tension: 0.3
						}]
					},
					options: {
						scales: {
							y: {
								ticks: {
									callback: val => val.toLocaleString() + "원"
								}
							}
						}
					}
				});
	
				// 판매 로그 테이블
				const tableBody = document.getElementById("salesLogTable");
				salesLogs.forEach(log => {
					tableBody.innerHTML += `
						<tr>
							<td>${log.title}</td>
							<td>${log.sales}권</td>
							<td>${log.revenue.toLocaleString()}원</td>
							<td>${log.date}</td>
						</tr>
					`;
				});
			});
		</script>
  </body>
</html>
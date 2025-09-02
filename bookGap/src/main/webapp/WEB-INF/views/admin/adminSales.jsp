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
<style>
a{color: black;}
</style>
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
                  <div class="card-body"><canvas id="revenueBarChart" width="100%" height=" 400px"></canvas></div>
                </div>
              </div>
              <div class="col-lg-6">
                <div class="card mb-4">
                  <div class="card-header"><i class="fas fa-chart-pie me-1"></i>Pie Sales</div>
                  <div class="card-body"><canvas id="salesPieChart" width="100%" height=" 400px"></canvas></div>
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
                  <tbody id="salesLogTable">
                  	<c:forEach var="log" items="${salesLogs}">
	                  <tr>
	                    <td>${log.title}</td>
	                    <td>${log.sales}권</td>
	                    <td>${log.revenue}원</td> 
	                    <td>${log.date}</td>
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
    <!-- 차트 및 데이터 렌더링 -->
<script>
  const bookSales = [
    <c:forEach var="book" items="${bookStats}" varStatus="i">
      {
        title: "${book.title}",
        sales: ${book.sales},
        revenue: ${book.revenue}
      }<c:if test="${!i.last}">,</c:if>
    </c:forEach>
  ];

  const dailyStats = [
    <c:forEach var="day" items="${dailyStats}" varStatus="i">
      {
        date: "${day.sales_date}",
        revenue: ${day.total_revenue}
      }<c:if test="${!i.last}">,</c:if>
    </c:forEach>
  ];

  document.addEventListener("DOMContentLoaded", function () {
	const titles = bookSales.map(b => b.title.split('(')[0].trim());
    const revenues = bookSales.map(b => b.revenue);
    const salesCounts = bookSales.map(b => b.sales);

    // Bar Chart
    new Chart(document.getElementById("revenueBarChart"), {
      type: "bar",
      data: {
        labels: titles,
        datasets: [{
          label: "총매출 (원)",
          backgroundColor: [
        	  '#6c757d', // 어두운 회색
        	  '#adb5bd', // 중간 회색
        	  '#ced4da', // 밝은 회색
        	  '#dee2e6', // 더 밝은 회색
        	  '#e9ecef', // 거의 흰색에 가까운 회색
        	  '#f8f9fa', // 매우 연한 회색
        	  '#495057'  // 딥 그레이
        	],
          data: revenues
        }]
      },
      options: {
    	maintainAspectRatio: false,
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
          backgroundColor: [
        	  "#A8DADC",  // 민트 파스텔
        	  "#FBC4AB",  // 살구 파스텔
        	  "#FFCAD4",  // 연핑크
        	  "#CDB4DB",  // 연보라
        	  "#B5EAD7",  // 연녹색
        	  "#FFF1BD"   // 연노랑
        	]
        }]
      },
      options: {
    	    maintainAspectRatio: false,
    	    responsive: true
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
  });
</script>
</body>
</html>
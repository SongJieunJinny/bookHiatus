<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="nav">
  <div class="sb-sidenav-menu-heading">Core</div>
  <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminIndex.do">
    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
    INDEX
  </a>
  <div class="sb-sidenav-menu-heading">Admin</div>
  <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
    <div class="sb-nav-link-icon"><i class="fas fa-book-open"></i></div>
    Pages
    <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
  </a>
  <div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
    <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminBook.do">Book</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminOrder.do">Order</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminUserInfo.do">User Info</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminGuestOrderInfo.do">Guset Order Info</a>
      <div class="collapse" id="pagesCollapseAuth" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages"></div>
      <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseError" aria-expanded="false" aria-controls="pagesCollapseError">
        Error
        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
      </a>
      <div class="collapse" id="pagesCollapseError" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
        <nav class="sb-sidenav-menu-nested nav">
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/err401.do">401 Page</a>
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/err404.do">404 Page</a>
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/err500.do">500 Page</a>
        </nav>
      </div>
    </nav>
  </div>
  <div class="sb-sidenav-menu-heading">Addons</div>
  <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminSales.do">
    <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
    Sales
  </a>
  <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminSchedule.do">
    <div class="sb-nav-link-icon"><i class="fas fa-table"></i></div>
    Schedule
  </a>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
  <!-- Brand -->
  <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/admin/adminIndex.do">BOOK 틈</a>

  <!-- 오른쪽 영역 -->
  <ul class="navbar-nav ms-auto me-3">
    <li class="nav-item d-flex align-items-center text-white-50 me-3">
      <i class="fas fa-user fa-fw me-2"></i>
      <span>
        <sec:authentication property="principal.username"/>
        <small class="text-secondary"> (admin)</small>
      </span>
    </li>
    <li class="nav-item">
      <form method="post" action="${pageContext.request.contextPath}/logout.do" class="mb-0">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <button type="submit" class="btn btn-outline-light btn-sm">Logout</button>
      </form>
    </li>
  </ul>
</nav>
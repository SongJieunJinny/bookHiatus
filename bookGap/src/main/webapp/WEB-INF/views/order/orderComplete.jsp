<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderComplete</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<style>
  /* 컨테이너 */
  section {
    max-width: 960px;
    margin: 24px auto 80px;
    padding: 0 16px;
  }

  /* 타이틀들 */
  h2 {
    font-size: 22px;
    font-weight: 800;
    margin: 0 0 18px;
    text-align: center;
  }
  h3 {
    font-size: 16px;
    font-weight: 700;
    margin: 28px 0 12px;
  }

  /* 공통 카드 */
  .oc-card {
    background: #fff;
    border: 1px solid #eaeaea;
    border-radius: 14px;
    box-shadow: 0 2px 10px rgba(0,0,0,.04);
    padding: 16px 18px;
    margin-bottom: 14px;
  }

  /* 결제 정보 */
  .oc-summary ul { margin: 0; padding-left: 18px; }
  .oc-badge {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 999px;
    border: 1px solid #e5e5e5;
    font-size: 12px;
    line-height: 18px;
    vertical-align: middle;
  }

  /* 상품 목록 */
  .oc-items { list-style: none; margin: 0; padding: 0; }
  .oc-item {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    padding: 12px 0;
    border-bottom: 1px dashed #e9e9e9;
  }
  .oc-item:last-child { border-bottom: 0; }

  .oc-thumb {
    width: 80px; height: 120px; flex: 0 0 80px;
    overflow: hidden; border-radius: 8px; border: 1px solid #eee;
    box-shadow: 0 2px 6px rgba(0,0,0,.06);
    background: #f8f8f8;
  }
  .oc-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }

  .oc-info { flex: 1; }
  .oc-title {
    font-weight: 700; margin: 2px 0 6px; line-height: 1.35;
  }
  .oc-meta {
    font-size: 13px; color: #666;
  }

  /* 배송지 */
  .oc-address ul { margin: 0; padding-left: 18px; }

  /* 하단 링크 */
.oc-actions {
  margin-top: 22px;
  text-align: center; /* 버튼 자체를 가운데로 */
}

.oc-home {
  display: inline-block;
  padding: 10px 14px;
  border-radius: 10px;
  border: 1px solid #ddd;
  text-decoration: none;
  font-weight: 600;
  color: #333; /* 글씨색 추가 추천 */
  transition: all 0.2s ease-in-out;
}

.oc-home:hover {
  box-shadow: 0 2px 8px rgba(0,0,0,.07);
  background-color: #f9f9f9; /* hover 시 배경색 살짝 */
}
  /* 반응형 */
  @media (max-width: 560px) {
    .oc-item { gap: 12px; }
    .oc-thumb { width: 68px; height: 100px; flex-basis: 68px; }
  }
</style>
</head>
<body>
<sec:authorize access="isAuthenticated()">
  <script>
    const isLoggedIn = true;
  </script>
</sec:authorize>
<sec:authorize access="isAnonymous()">
  <script>const isLoggedIn = false;</script>
</sec:authorize>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
  <h2>주문이 성공적으로 완료되었습니다!</h2>

  <div class="oc-card oc-summary">
    <h3>결제 정보</h3>
    <ul>
      <li>결제 수단:
        <span class="oc-badge">
          <c:choose>
            <c:when test="${payment.paymentMethod == 1}">토스페이</c:when>
            <c:when test="${payment.paymentMethod == 2}">카카오페이</c:when>
            <c:otherwise>기타</c:otherwise>
          </c:choose>
        </span>
      </li>
      <li>결제 금액: <fmt:formatNumber value="${payment.amount}" pattern="#,###" /> 원</li>
    </ul>
  </div>

  <div class="oc-card">
    <h3>주문한 상품</h3>
    <ul class="oc-items">
      <li >주문 번호: ${order.orderKey}</li>
      <c:forEach var="item" items="${order.orderDetails}">
        <li class="oc-item">
          <div class="oc-thumb">
            <img src="${item.book.image}" alt="${item.book.title}">
          </div>
          <div class="oc-info">
            <div class="oc-title">${item.book.title}</div>
            <div class="oc-meta">${item.orderCount}권</div>
          </div>
        </li>
      </c:forEach>
    </ul>
  </div>

  <div class="oc-card oc-address">
    <h3>배송지 정보</h3>
    <ul>
      <li>받는 분: ${order.receiverName}</li>
      <li>연락처: ${order.receiverPhone}</li>
      <li>주소: [${order.receiverPostCode}] ${order.receiverRoadAddress} ${order.receiverDetailAddress}</li>
    </ul>
  </div>

  <div class="oc-actions">
    <a class="oc-home" href="<c:url value='/' />">메인으로 돌아가기</a>
  </div>
</section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
// 장바구니 개수 업데이트 함수
  $(document).ready(function() {
	updateCartCount(); // 장바구니 개수 업데이트
	initHeaderEvents();
  });

</script>
</body>
</html>
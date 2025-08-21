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
</head>
<body>
    <h2>주문이 성공적으로 완료되었습니다!</h2>

    <h3>결제 정보</h3>
    <ul>
        <li>결제 번호: ${payment.paymentNo}</li>
        <li>결제 수단: 
            <c:choose>
                <c:when test="${payment.paymentMethod == 1}">토스페이</c:when>
                <c:when test="${payment.paymentMethod == 2}">카카오페이</c:when>
                <c:otherwise>기타</c:otherwise>
            </c:choose>
        </li>
        <li>결제 금액: <fmt:formatNumber value="${payment.amount}" pattern="#,###" /> 원</li>
    </ul>

    <h3>주문한 상품</h3>
    <ul>
        <c:forEach var="item" items="${order.items}">
            <li>${item.book.title} - ${item.quantity}권</li>
        </c:forEach>
    </ul>

    <h3>배송지 정보</h3>
    <ul>
        <li>받는 분: ${address.userName}</li>
        <li>연락처: ${address.userPhone}</li>
        <li>주소: [${address.postCode}] ${address.roadAddress} ${address.detailAddress}</li>
    </ul>

    <br>
    <a href="<c:url value='/' />">메인으로 돌아가기</a>
</body>
</html>
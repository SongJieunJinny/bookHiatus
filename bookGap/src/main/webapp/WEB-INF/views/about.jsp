<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>about</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<style>
section {
	width: 90%;
	margin: 5% auto;
	height: auto;
}
.BookStore{
    display: flex;
}
.BookStoreName{
	font-family: Arial, sans-serif;
	margin-top: 3%;
	margin-bottom: 1%;
	text-align: center;
	font-size: 25px;	
}
.BookStoreNameLine{
    border-top: solid 4px #ccc;
    width: 11%;
    margin-left: 44.5%;
}
.BookStoreIntroduction{
    width: 50%;
    font-family: Arial, sans-serif;
    margin-top: 8%;
    margin-left: auto;
    margin-right: auto; 
    text-align: center; 
}
.BookStoreIntroduction h2{
    font-size: 25px;
    text-align: center;
    margin-bottom: 7%;     
}
.BookStoreIntroduction span {
    display: block; 
    margin-bottom: 10px; 
    line-height: 1.6; 
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<section>
<div class="BookStoreName">북틈 소개</div>
     <div class="BookStoreNameLine"></div>
		<div class="BookStore">
	       <div id="map" style="width: 40%; height: 400px; margin-top: 10%; margin-bottom: 10%; margin-left: 5%;"></div>
			<div class="BookStoreIntroduction">
		    <h2>"책 속에서 발견하는 작은 틈, 그곳에서 시작되는 이야기"</h2>
		    <span>책은 생각의 틈을 만들어 줍니다. 그리고 우리는 그 틈에서 새로운 시선과 가능성을 발견합니다. </span>
		    <span>저희 북틈은 조용하지만 깊이 있는 이야기들이 머무는 공간입니다.</span>
		    <span>바쁜 일상 속에서 잠시 멈추고 사색하며, 책을 통해 질문하고 길을 찾을 수 있도록 돕는 곳.</span>
		    <span>책과 책 사이, 그리고 삶과 삶 사이의 작은 틈에서 당신만의 시간을 발견해 보세요.</span>
			</div>
		</div>
</section>
 <jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
 // 장바구니 개수 업데이트 함수
 $(document).ready(function() {
  updateCartCount(); // 장바구니 개수 업데이트
   initHeaderEvents();
 });
 
function updateCartCount() {
	let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
	let cartCount = cartItems.length;
	let cartCountElement = document.getElementById("cart-count");

	if (cartCountElement) {
			cartCountElement.textContent = cartCount;
			cartCountElement.style.visibility = cartCount > 0 ? "visible" : "hidden";
	}
}
</script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=56c7bb3d435c0c4f0d2b67bfa7d4407e&libraries=services"></script>
<script>
function loadMap() {
    console.log("카카오 API 로드 완료!");

    var mapContainer = document.getElementById('map');
    if (!mapContainer) {
        console.error(" #map 요소를 찾을 수 없습니다.");
        return;
    }

    var mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 제주도 좌표
        level: 3
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var markerPosition = new kakao.maps.LatLng(33.450701, 126.570667);
    var marker = new kakao.maps.Marker({ position: markerPosition });
    marker.setMap(map);
    
    console.log("지도 로딩 완료!");
}
document.addEventListener("DOMContentLoaded", function () {
    console.log("카카오 API 스크립트 로드 시작...");
    loadMap();
});
  </script>
</body>
</html>
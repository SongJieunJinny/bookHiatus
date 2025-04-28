<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<link href="<%=request.getContextPath()%>/resources/css/index.css" type="text/css" rel="stylesheet">
	<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
	<style>
		#navMenu{
			width: 100%;
			height: 70%;
		}
		#new{
			margin-top: 3%;
			margin-bottom: 5%;
			text-align: center;
			font-size: 25px;
		}
		#bookList{
			width: 100%;
			height: 50%;
			display:flex;
			justify-content: space-evenly;
			align-items: center;
		}
		#leftPointer{
			width: 20%;
			height: 20%;
			display: flex;
			justify-content: flex-end;
		}
		#leftPointerImg{
			width: 20%;
			height: 20%;
			cursor: pointer;
		}
		#rightPointer{
			width: 20%;
			height: 20%;
			display: flex;
			justify-content: flex-start;
		}
		#rightPointerImg{
			width: 20%;
			height: 20%;
			cursor: pointer;
		}
		#newBookList{
			width: 100%;
			margin-left: 5%;
			margin-right: 5%;
			display:flex;
			justify-content: space-evenly;
			align-items: center;
		}
		#newBook1{
			width: 50%;
			height: 30%;
			margin-left: 5%;
			margin-right: 5%;
		}
		#newBookImg1{
			width: 100%;
			height: 100%;
		}
		#newBookAlt1{
			text-align: center;
			margin-top: 2%;
			margin-bottom: 7%;
		}
		#newBook2{
			width: 50%;
			height: 30%;
			margin-left: 5%;
			margin-right: 5%;
		}
		#newBookImg2{
			width: 100%;
			height: 100%;
		}
		#newBookAlt2{
			text-align: center;
			margin-top: 2%;
			margin-bottom: 7%;
		}
		#newBook3{
			width: 50%;
			height: 30%;
			margin-left: 5%;
			margin-right: 5%;
		}
		#newBookImg3{
			width: 100%;
			height: 100%;
		}
		#newBookAlt3{
			text-align: center;
			margin-top: 2%;
			margin-bottom: 7%;
		}
	</style>
</head>
<body>
	<div id="header"></div>
	<nav>
		<div id="navMenu">
			<div id="new">NEW</div>
			<div id="bookList">
				<div id="leftPointer"><img id="leftPointerImg" src="<%=request.getContextPath()%>/resources/img/left.png"></div>
				<div id="newBookList">
					<div id="newBook1">
						<div id="bookBack">
						<img id="newBookImg1" src="<%=request.getContextPath()%>/resources/img/문화이론.jpg">
						</div>
						<div id="newBookAlt1">
							<div id="bookName1">문화이론</div>
							<div id="bookPrice1">29,800</div>
						</div>
					</div>
					<div id="newBook2">
						<div id="bookBack">
						<img id="newBookImg2" src="<%=request.getContextPath()%>/resources/img/고흐로읽는심리수업.jpg">
						</div>
						<div id="newBookAlt2">
							<div id="bookName2">고흐로 읽는 심리수업</div>
							<div id="bookPrice2">23,000</div>
						</div>
					</div>
					<div id="newBook3">
						<div id="bookBack">
						<img id="newBookImg3" src="<%=request.getContextPath()%>/resources/img/필사는도끼다.jpg">
						</div>
						<div id="newBookAlt3">
							<div id="bookName3">필사는 도끼다</div>
							<div id="bookPrice3">22,000</div>
						</div>
					</div>
				</div>
				<div id="rightPointer"><img id="rightPointerImg" src="<%=request.getContextPath()%>/resources/img/right.png"></div>
			</div>
		</div>
		<br><br>
	</nav>
	<div id="footer"></div>
	<script>
		$(document).ready(function () {
			// 헤더 & 푸터 로드
			$("#header").load("<%= request.getContextPath() %>/include/header", function () {
				updateCartCount(); // 장바구니 개수 업데이트
				initHeaderEvents();		
			});
			$("#footer").load("<%= request.getContextPath() %>/include/footer");
		});

		// 장바구니 개수 업데이트 함수
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
	<script>
		const contextPath = "<%= request.getContextPath() %>";
		const books = [
    		[
		        { imgSrc: contextPath + "/resources/img/문화이론.jpg", name: "문화이론", price: "29,800" },
		        { imgSrc: contextPath + "/resources/img/고흐로읽는심리수업.jpg", name: "고흐로 읽는 심리수업", price: "23,000" },
		        { imgSrc: contextPath + "/resources/img/필사는도끼다.jpg", name: "필사는 도끼다", price: "22,000" }
    		],
			[
				{imgSrc: contextPath + "/resources/img/군주론인생공부.jpg", name: "군주론 인생공부", price: "18,500"},
				{imgSrc: contextPath + "/resources/img/더인간적인건축.jpg", name: "더 인간적인 건축", price: "30,000"},
				{imgSrc: contextPath + "/resources/img/마흔에읽는쇼펜하우어.jpg", name: "마흔에 읽는 쇼펜하우어", price: "17,000"}
			],
			[
				{imgSrc: contextPath + "/resources/img/초역논어.jpg", name: "초역논어", price: "17,800"},
				{imgSrc: contextPath + "/resources/img/사피엔스.jpg", name: "사피엔스", price: "26,800"},
				{imgSrc: contextPath + "/resources/img/초역부처의말.jpg", name: "초역부처의 말", price: "17,800"}
			]
		];
	
	let currentIndex = 0;

	document.getElementById("rightPointerImg").onclick = () => changeBooks(1);
	document.getElementById("leftPointerImg").onclick = () => changeBooks(-1);

	function changeBooks(direction) {
			currentIndex = (currentIndex + direction + books.length) % books.length;

			document.getElementById("newBookImg1").src = books[currentIndex][0].imgSrc;
			document.getElementById("bookName1").innerText = books[currentIndex][0].name;
			document.getElementById("bookPrice1").innerText = books[currentIndex][0].price;

			document.getElementById("newBookImg2").src = books[currentIndex][1].imgSrc;
			document.getElementById("bookName2").innerText = books[currentIndex][1].name;
			document.getElementById("bookPrice2").innerText = books[currentIndex][1].price;

			document.getElementById("newBookImg3").src = books[currentIndex][2].imgSrc;
			document.getElementById("bookName3").innerText = books[currentIndex][2].name;
			document.getElementById("bookPrice3").innerText = books[currentIndex][2].price;

			const newBookList = document.getElementById("newBookList");
			newBookList.style.transition = 'transform 0.5s ease';
			newBookList.style.transform = 'translateX(-100%)';

			setTimeout(() => {
					newBookList.style.transition = 'none';
					newBookList.style.transform = 'translateX(0)';
					setTimeout(() => {
							newBookList.style.transition = 'transform 0.5s ease';
					}, 0);
			}, 500);
		}
	</script>	
</body>
</html>

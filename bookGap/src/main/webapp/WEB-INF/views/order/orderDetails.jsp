<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderDetails</title>
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/index.css"/>
<style>
#navOrderDetails{
  width: 100%;
  height: 70%;
}
#orderDetailsHead{
  width: 100%;
  height: 20%;
}
#orderDetailsDiv{
  margin-top: 3%;
  margin-bottom: 2%;
  margin-left: 3.5%;
  text-align: center;
  font-size: 25px;
  display: flex;
  justify-items: center;
  justify-content: center;
}
#orderDetailsDiv a:link {
  color : black;
  text-decoration: none;
}
#orderDetailsDiv a:visited {
  color : black;
  text-decoration: none;
}
#orderDetailsDiv a:hover {
  color : black;
  border: 1px;
  text-decoration: underline;
  font-weight:bold;
}
#orderDetailsDiv a:active  {
  color : black;
  border: 1px;
  text-decoration: underline;
  font-weight:bold;
}
#orderDetailsMid{
  width: 60%;
  height: 40%;
  display: flex;
  margin-left: 20%;
  align-items: center;
  flex-direction: column;
}
.orderDetailsDivLine{
  width: 100.15%;
  border-bottom: solid 7px;
  border-color: black;
  font-size: 20px;
  font-family: Arial, sans-serif;   
}
.orderDetailsDiv{
  width: 100%;
  height: auto;
  margin-bottom: 2%;
  border: 1px solid black;
  display: flex;
  justify-content: space-evenly;
  padding-top: 1%;
  padding-bottom: 1%;
}
.orderWeekButton{
  border: 1px solid black;
  background-color: white;
  color: black;
  cursor: pointer;
  font-size: 18px;
  padding: 2%;
  width: 100%;
}
.orderDateInfo{
  display: flex;
  justify-content: space-evenly;
  font-size: 18px;
  margin: 1%;
}
.orderDate{
  border: 1px solid black;
  background-color: white;
  font-size: 15px;
  text-align: center;
  width: 100%;
  padding-right: 1%;
}
.orderDateSign{
  color: black;
  font-size: larger;
}
.orderDateButton{
  border: 1px solid black;
  border-radius: 10px;
  background-color: black;
  color: white;
  cursor: pointer;
  width: 120%;
  font-size: 18px;
}

.orderMsg{
  font-size: 18px;
}
#orderDetailsEnd{
  width: 60%;
  height: 30%;
  margin-left: 20%;
  margin-right: 20%;
  margin-bottom: 2%;
  margin-top: 1%;
  display: flex;
  justify-content: center;
  flex-direction: column;
}
.orderPayComplDiv{
  width: 100%;
  height: auto;
  border: 1px solid black;
  margin-bottom: 5%;
  display: flex;
  align-items: center; /* 세로 중앙 정렬 */
  padding: 1%;
  font-size: 17px;
}
.orderPayComplImg{
  width: 10%;
  height: 10%;
  margin-left: 3%;
  margin: 0% 2% 0% 2%; /*위쪽 오른쪽 아래쪽 왼쪽*/
  padding: 0%;
}
.orderPayCompl{
  width: 100%;
  display: flex;
}
.orderPayComplInfoDiv1{
  width: 100%;
  display: flex;
  flex-direction: column;
  margin: 2%;
}
.orderPayComplInfo{
  margin: 0.5%;
}
.orderPayDate{
  margin: 0.5%;
}
.orderPayComplInfoDiv2{
  font-size: 20px;
  color: gray;
  display: flex;
  width: 30%;
  align-items: center;
}
.orderPayComplInfo2{
  width: 100%;
  margin-bottom: 25%;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
  list-style: none;
  padding: 0;
  margin-bottom: 3%;
}
.pagination li {
  margin: 0 5px;
}
.pagination a {
  text-decoration: none;
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
  color: #333;
  font-size: 16px;
  transition: 0.3s ease;
  background-color: #f8f8f8;
}
.pagination a:hover {
  background-color: black;
  color: white;
  border-color: black;
}
.pagination .active a {
  background-color: black;
  color: white;
  border-color: black;
}
.pagination .disabled a {
  color: #ccc;
  cursor: not-allowed;
  background-color: #f0f0f0;
  border-color: #ddd;
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
  <section>
    <div id="navOrderDetails">
      <div id="orderDetailsHead">
        <div id="orderDetailsDiv">
          <div id="myInfo"><a href="<%=request.getContextPath()%>/user/mypageInfo.do">My Info</a></div>
	          &nbsp;&nbsp;<div>|</div>&nbsp;&nbsp;
          <div id="orderDetails"><a href="<%=request.getContextPath()%>/order/orderDetails.do">Order Details</a></div>
        </div>
      </div>
      <div id="orderDetailsMid">
        <div class="orderDetailsDivLine"></div>
        <div class="orderDetailsDiv">
          <div class="orderDateInfo">
            <input class="orderWeekButton" type="button" value="오늘">
            <input class="orderWeekButton" type="button" value="1주일 ">
            <input class="orderWeekButton" type="button" value="1개월">
            <input class="orderWeekButton" type="button" value="3개월">
          </div>
          <div class="orderDateInfo">
            <input class="orderDate" id="orderDateStart" type="date">
            &nbsp;<div class="orderDateSign">～</div>&nbsp;
            <input class="orderDate" id="orderDateLast" type="date">
            &nbsp;&nbsp;&nbsp;
            <input class="orderDateButton" type="button" value="조회">
          </div>                      
        </div>
        <div class="orderMsg">취소신청은 배송완료일 기준 7일 까지 가능합니다.</div>
      </div>
      <div id="orderDetailsEnd">
        <!--주문내용1-->
        <div class="orderPayComplDiv">
          <img class="orderPayComplImg" src="인생의의미.jpg">
          <div class="orderPayCompl">
            <div class="orderPayComplInfoDiv1">
              <div class="orderPayDate">2025-03-20</div>
              <div class="orderPayComplInfo">[인문]인생의 의미 | 1부 </div>
              <div class="orderPayComplInfo">토마스 힐란드 에릭센 저자  |  이영래 번역  |  더퀘스트 출판</div>
              <div class="orderPayComplInfo">18,800원 + 배송비 3,000원 = 21,800원</div>
            </div>
            <div class="orderPayComplInfoDiv2">
              <div class="orderPayComplInfo2">배송완료</div>
            </div>
          </div>                        
        </div>
        <!--주문내용2-->
        <div class="orderPayComplDiv">
          <img class="orderPayComplImg" src="더인간적인건축.jpg">
          <div class="orderPayCompl">
            <div class="orderPayComplInfoDiv1">
              <div class="orderPayDate">2025-03-01</div>
              <div class="orderPayComplInfo">[인문]더 인간적인 건축 | 1부 </div>
              <div class="orderPayComplInfo">토마스 헤더윅 저자  |  알에이치코리아 출판</div>
              <div class="orderPayComplInfo">30,000원 + 배송비 3,000원 = 33,000원</div>
            </div>
            <div class="orderPayComplInfoDiv2">
              <div class="orderPayComplInfo2">배송완료</div>
            </div>
          </div>                        
        </div>
        <!--주문내용3-->
        <div class="orderPayComplDiv">
          <img class="orderPayComplImg" src="소년이온다.jpg">
          <div class="orderPayCompl">
            <div class="orderPayComplInfoDiv1">
              <div class="orderPayDate">2024-12-14</div>
              <div class="orderPayComplInfo">[소설]소년이 온다 | 1부 </div>
              <div class="orderPayComplInfo">한강 저자  |  한강 출판</div>
              <div class="orderPayComplInfo">15,000원 + 배송비 3,000원 = 18,000원</div>
            </div>
            <div class="orderPayComplInfoDiv2">
              <div class="orderPayComplInfo2">배송완료</div>
            </div>
          </div>                        
        </div>
        <!--페이징-->
        <div class="paging">
          <ul class="pagination">
              <li class="disabled"><a href="#">«</a></li>
              <li class="active"><a href="#">1</a></li>
              <li><a href="#">2</a></li>
              <li><a href="#">3</a></li>
              <li><a href="#">4</a></li>
              <li><a href="#">5</a></li>
              <li><a href="#">»</a></li>
          </ul>
        </div> 
      </div>
    </div>
  </section>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script>
   $(document).ready(function () {
		updateCartCount(); // 장바구니 개수 업데이트
		initHeaderEvents();		
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
    $(document).ready(function () {
      // 페이지 로드 시 모든 주문 내용을 숨기기
      $(".orderPayComplDiv").hide();
      function updateDateRange(value) {
        let today = new Date();
        let startDate = new Date(today.getTime()); // 새로운 객체 복사

        if (value === "오늘") {
          startDate = new Date(today.getTime());
        } else if (value === "1주일") {
          startDate.setDate(today.getDate() - 7);
        } else if (value === "1개월") {
          startDate.setMonth(today.getMonth() - 1);
        } else if (value === "3개월") {
          startDate.setMonth(today.getMonth() - 3);
        }

        let todayStr = today.toISOString().split("T")[0];
        let startDateStr = startDate.toISOString().split("T")[0];

        console.log("클릭된 버튼:", value);
        console.log("시작 날짜:", startDateStr);
        console.log("오늘 날짜:", todayStr);

        $("#orderDateStart").val(startDateStr);
        $("#orderDateLast").val(todayStr);
      }

      $(".orderWeekButton").hover(
        function () {
          $(this).css("background-color", "black").css("color", "white");
        },
        function () {
          if (!$(this).hasClass("selected")) {
            $(this).css("background-color", "white").css("color", "black");
          }
        }
      );

      $(".orderWeekButton").click(function () {
        $(".orderWeekButton")
          .removeClass("selected")
          .css("background-color", "white")
          .css("color", "black");
        $(this).addClass("selected").css("background-color", "black").css("color", "white");

        updateDateRange($(this).val());
      });

      // 페이지 로드시 날짜 자동 설정 안 함
      $("#orderDateStart").val("");
      $("#orderDateLast").val("");

      // 조회 버튼 클릭 이벤트
      $(".orderDateButton").click(function () {
        let startDate = new Date($("#orderDateStart").val());
        let endDate = new Date($("#orderDateLast").val());

        console.log("조회 시작 날짜:", startDate);
        console.log("조회 종료 날짜:", endDate);

        // 모든 주문 내용을 숨기기
        $(".orderPayComplDiv").hide();

        // 날짜 범위에 맞는 주문 내용만 표시
        $(".orderPayComplDiv").each(function () {
          let orderDate = new Date($(this).find(".orderPayDate").text());
          console.log("주문 날짜:", orderDate);

          // orderPayDate가 범위 내에 있으면 표시
          if (orderDate >= startDate && orderDate <= endDate) {
            $(this).show();
          }
        });
      });
    });
  </script>
</body>
</html>
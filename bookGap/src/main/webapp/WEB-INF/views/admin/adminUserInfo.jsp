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
<title>adminUserInfo</title>
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
 <style>
      .userInfoModal{
	        border: 1px solid black;
	        display: none;
	        position: fixed;
	        z-index: 1;
	        left: 0;
	        top: 0;
	        width: 100%;
	        height: 100%;
	        overflow: auto;
	        background-color: rgba(0,0,0,0.4);
      }
      .userInfoModalContent {
	        background-color: #fefefe;
	        margin: 8% auto;
	        border: 1px solid #888;
	        width: 80%;
			height: 100%;
	        max-width: 400px;
			max-height: 520px;
	        border-radius: 20px;
	        text-align: center;
	        padding-bottom: 2%;
      }
      .userInfoModalHead{
        	width: 100%;
      }
      .userInfoModalHeadTitle{
	       	 width: 100%;
	         text-align: center;
	       	 font-size: 24px;
	       	 font-weight: bold;
      }
      .userInfoModalSection{
	        width: 100%;
	        display: flex;
	        flex-direction: column;
      }
      .userInfoModalItemContainer{
		   width: 100%;
	       display: flex;
	       justify-content: flex-start;
	       margin: 3% 0% 0% 18%;
	       align-items: center;
      }
      .userInfoModalItemInput{
        	margin-left: 3%;
      }
      .userInfoModalItemCheckbox{
       	 	margin: 2% 1% 1% 3%;
      }
      .userInfoModalFooter{
	       width: 100%;
	       display: flex;
	       flex-direction: column;
      }
      .userInfoModalItemInputContainer{
        	margin-top: 5%;
      }
      .userInfoModalItemInputLine{
	        border: 1px solid black;
	        border-radius: 10px;
	        width: 70%;
	        margin-left: 15%;
      }
      .userInfoModalItemInputNote{
        	border-bottom: 1px solid black; 
			margin-bottom: 1px;
      }
		.userInfoModalItemInputText{
			width: 95%;
			border: none;
  			outline: none;
			resize: none;
			padding-left: 1%;
    		font-size: 10px;
    		margin-left: 2%;
		}
		.userInfoModalItemText{
			padding: 4px 8px;
			display: inline-block;
			border: 1px solid transparent;
			cursor: pointer;
			margin-left: 1%;
		}
		.userInfoModalItemText:hover {
			border: 1px solid #ccc;
			background-color: #f9f9f9;
		}
		.userInfoModalItemInput{
			padding: 4px 8px;
    		font-size: 1em;
		}
		.userInfoModalItemButtonContainer{
			display: flex;
			align-items: center;
			justify-content: center;
		}
		.userInfoModalItemButton{
			width: 15%;
			padding: 1%;
			margin: 3%;
			background-color: black;
			border-radius: 10px;
			margin: 3%;
			color: white;
			font-size: 18px;
		}
		.userInfoModalItemCloseButton{
			width: 15%;
			padding: 1%;
			margin: 3%;
			background-color: black;
			border-radius: 10px;
			margin: 3%;
			color: white;
			font-size: 18px;
		}
		.datatable-selector {
			padding: 8px;
			width: 170%;
			margin-bottom:10px;
			margin-right: 20px;
		}
			#datatablesSimple th:nth-child(4),
			#datatablesSimple td:nth-child(4) {
			  width: 200px; /* 원하는 너비로 조절 */
			}
			#datatablesSimple th:nth-child(5),
			#datatablesSimple td:nth-child(5) {
			  width: 150px; /* 원하는 너비로 조절 */
			}
			#datatablesSimple th:nth-child(6),
			#datatablesSimple td:nth-child(6) {
			  width: 150px; /* 원하는 너비로 조절 */
			}
			#datatablesSimple th:nth-child(7),
			#datatablesSimple td:nth-child(7) {
			  width: 250px; /* 원하는 너비로 조절 */
			}
    </style>
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
					<h1 class="mt-4">User Info Management System </h1>
	          <br>
					<div class="card mb-4">
						<div class="card-body">
							회원정보 관리 페이지
						</div>
					</div>
					<div class="card mb-4">
						<div class="card-header">
							<i class="fas fa-table me-1"></i>
							회원 목록 
						</div>
						<div class="card-body">
							<table id="datatablesSimple">
								<thead>
									<tr>
										<th>ID</th>
										<th>NAME</th>
										<th>PHONE</th>
										<th>E-MAIL</th>
										<th>Enabled</th>
										<th>JOIN DATE</th>
										<th>NOTE</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${getAllUser}" var="vo">
									<tr>
										<td>${vo.userId} </td>
										<td>${vo.userName }</td>
										<td>${vo.userPhone }</td>
										<td>${vo.userEmail }</td>
										<td>
											 <c:choose>
											    <c:when test="${vo.userEnabled}">활성화</c:when>
											    <c:otherwise>비활성화</c:otherwise>
											  </c:choose>
										</td>
										<td>${vo.userJoinDate}</td>
										<td>${vo.note}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
				             <!--회원정보 모달창-->
				             <div class="userInfoModal" id="userInfoModal">
				               <div class="userInfoModalContent">
				                 <br><br>
				                 <div class="userInfoModalHead">
				                   <div class="userInfoModalHeadTitle">User Info</div>
				                 </div>
				                 <div class="userInfoModalSection">
				                   <!--모달 ID Container -->
				                   <div class="userInfoModalItemContainer">
				                     <div class="userInfoModalItem">ID : </div>
													<!-- 표시용 텍스트 -->
										<span class="userInfoModalItemText" data-field="id"> user01 </span>
													<!-- 실제 input (초기에 숨겨짐) -->
				                     <input id="userInfoModalIdInput" class="userInfoModalItemInput" data-field="id" type="text" style="display:none;">
				                   </div>
				                   <!--모달 Name Container -->
				                   <div class="userInfoModalItemContainer">
				                     <div class="userInfoModalItem">NAME : </div>
				                     <!-- 표시용 텍스트 -->
										<span class="userInfoModalItemText" data-field="name"> 유저일 </span>
													<!-- 실제 input (초기에 숨겨짐) -->
				                     <input id="userInfoModalNameInput" class="userInfoModalItemInput" data-field="name" type="text" style="display:none;">
				                   </div>
				                   <!--모달 Phone Container -->
				                   <div class="userInfoModalItemContainer">
				                     <div class="userInfoModalItem">PHONE : </div>
				                     <!-- 표시용 텍스트 -->
										<span class="userInfoModalItemText" data-field="phone"> 010-0000-0001 </span>
													<!-- 실제 input (초기에 숨겨짐) -->
				                     <input id="userInfoModalPhoneInput" class="userInfoModalItemInput" data-field="phone" type="text" style="display:none;">
				                   </div>
				                   <!--모달 Email Container -->
				                   <div class="userInfoModalItemContainer">
				                     <div class="userInfoModalItem">E-MAIL : </div>
				                     <!-- 표시용 텍스트 -->
										<span class="userInfoModalItemText" data-field="email"> user01@user.com </span>
													<!-- 실제 input (초기에 숨겨짐) -->
				                     <input id="userInfoModalEmailInput" class="userInfoModalItemInput" data-field="email" type="text" style="display:none;">
				                   </div>
				                   <!--모달 State Container -->
				                   <div class="userInfoModalItemContainer">
				                     <div class="userInfoModalItem">ENABLED : </div>
				                     <label style="width: 20%; padding-left: 2%;">
										<input id="userInfoModalStateInput1" class="userInfoModalItemCheckbox" type="radio" name="state" > 활성화 
									</label>&nbsp;
				                     <label style="width: 25%;">
										<input id="userInfoModalStateInput2" class="userInfoModalItemCheckbox" type="radio" name="state"> 비활성화 
									</label>
				                   </div>
				                   <!--모달 Joindate Container -->
				                   <div class="userInfoModalItemContainer">
									  <div class="userInfoModalItem">JOIN DATE : </div>
									  <!-- 표시용 텍스트 -->
									 	 <span class="userInfoModalItemText" data-field="joindate"></span>
									  <!-- 실제 input (초기에 숨겨짐) -->
									  <input id="userInfoModalDateInput" class="userInfoModalItemInput" data-field="joindate" type="date" style="display:none;">
									</div>
				                 <div class="userInfoModalFooter">
                   <!--모달 Note Container -->
			                      <div class="userInfoModalItemInputContainer">
			                        <div class="userInfoModalItemInputLine">
			                          <div class="userInfoModalItemInputNote">
			                          NOTE
			                          	</div>
										<textarea id="userInfoModalNoteInput" class="userInfoModalItemInputText"></textarea>
			                      	</div>
			                      </div>
				                      <div class="userInfoModalItemButtonContainer">
				                        <button class="userInfoModalItemButton" id="userInfoModalItemButton" onclick="applyChange()">적용</button><br>
				                        <button class="userInfoModalItemCloseButton" onclick="closeModal()">닫기</button>
                   						</div>
                 					</div>
             					</div>
             				</div>
						</div>
					</div>
				</div>
			</main>
			<!--footer 삽입-->
		 	<jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
		</div>
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>
 <script>
      let selectedRow = null;

      $(document).ready(function () {
        // 테이블 행 클릭 시 모달 열기
        $('#datatablesSimple tbody').on('click', 'tr', function () {
          selectedRow = this; // 현재 클릭한 행 저장
          openModal(); // 모달 열기
        });
      
				// 모달 닫기 버튼
				$('.userInfoModalItemCloseButton').click(() => {
					$('#userInfoModal').hide();
				});

				// 텍스트 클릭 → input 전환
				document.querySelectorAll('.userInfoModalItemText').forEach(span => {
					span.addEventListener('click', () => {
						const field = span.dataset.field;
						const input = document.querySelector(`.userInfoModalItemInput[data-field="${field}"]`);

						input.value = span.innerText.trim();
						span.style.display = 'none';
						input.style.display = 'inline-block';
						input.focus();
					});
				});

				// input에서 포커스 아웃 → 텍스트로 복귀
				document.querySelectorAll('.userInfoModalItemInput').forEach(input => {
					input.addEventListener('blur', () => {
						const field = input.dataset.field;
						const span = document.querySelector(`.userInfoModalItemText[data-field="${field}"]`);

						span.innerText = input.value.trim();
						input.style.display = 'none';
						span.style.display = 'inline-block';
					});
				});

				// 모달 외부 클릭 시 닫기
				document.getElementById('userInfoModal').addEventListener('click', function (e) {
					const modalContent = document.querySelector('.userInfoModalContent');
					if (!modalContent.contains(e.target)) {
						closeModal();
					}
				});
			});

			// 모달 열기
			function openModal() {
		        if (!selectedRow) return;
		
		        const cells = selectedRow.querySelectorAll('td');
		
		        document.querySelector('.userInfoModalItemText[data-field="id"]').innerText = cells[0].innerText;
		        document.querySelector('.userInfoModalItemText[data-field="name"]').innerText = cells[1].innerText;
		        document.querySelector('.userInfoModalItemText[data-field="phone"]').innerText = cells[2].innerText;
		        document.querySelector('.userInfoModalItemText[data-field="email"]').innerText = cells[3].innerText;

		        if (cells[4].innerText.trim() === '활성화') {
		          document.getElementById('userInfoModalStateInput1').checked = true;
		        } else {
		          document.getElementById('userInfoModalStateInput2').checked = true;
		        }
		        document.querySelector('.userInfoModalItemText[data-field="joindate"]').innerText = cells[5].innerText;
		        document.getElementById('userInfoModalNoteInput').value = cells[6].innerText;

		        document.querySelectorAll('.userInfoModalItemInput').forEach(input => input.style.display = 'none');
		        document.querySelectorAll('.userInfoModalItemText').forEach(span => span.style.display = 'inline-block');

		        document.getElementById('userInfoModal').style.display = 'flex';
		      }
		
			function applyChange() {
				  if (!selectedRow) return;

				  const user = {
				    userId: document.querySelector('.userInfoModalItemText[data-field="id"]').innerText.trim(),
				    userName: document.querySelector('.userInfoModalItemText[data-field="name"]').innerText.trim(),
				    userPhone: document.querySelector('.userInfoModalItemText[data-field="phone"]').innerText.trim(),
				    userEmail: document.querySelector('.userInfoModalItemText[data-field="email"]').innerText.trim(),
				    userEnabled: document.querySelector('#userInfoModalStateInput1').checked,
				    userJoinDate: document.querySelector('.userInfoModalItemText[data-field="joindate"]').innerText.trim(),
				    note: document.querySelector('#userInfoModalNoteInput').value.trim()
				  };

				  $.ajax({
				    url: '<%=request.getContextPath()%>/admin/updateUser',
				    type: 'POST',
				    contentType: 'application/json',
				    data: JSON.stringify(user),
				    success: function(response) {
				      alert("유저 정보가 성공적으로 수정되었습니다.");
				      const cells = selectedRow.querySelectorAll('td');
				      cells[1].innerText = user.userName;
				      cells[2].innerText = user.userPhone;
				      cells[3].innerText = user.userEmail;
				      cells[4].innerText = user.userEnabled ? "활성화" : "비활성화";
				      cells[6].innerText = user.note;
				      closeModal();
				    },
				    error: function(xhr, status, error) {
				      alert("업데이트 실패: " + xhr.responseText);
				    }
				  });
				}

			// 모달 닫기
			function closeModal() {
				document.getElementById('userInfoModal').style.display = 'none';
			}
 </script>
 <script>
 window.addEventListener('DOMContentLoaded', () => {
	  const label = document.querySelector('.datatable-dropdown label');
	  if (label) {
	    const childNodes = Array.from(label.childNodes);
	    childNodes.forEach(node => {
	      if (node.nodeType === Node.TEXT_NODE) {
	        node.textContent = ''; // 텍스트만 제거
	      }
	    });
	  }
	});
 </script>
 <script>
	document.addEventListener("DOMContentLoaded", function() {
	    const table = new simpleDatatables.DataTable("#datatablesSimple", {
	      labels: {
	        perPage: "",  // 이 부분이 'entries per page' 문구를 담당
	        placeholder: "검색어 입력...",
	        noRows: "데이터가 없습니다.",
	        info: ""
	      }
	    });
	  });
</script>
</body>
</html>
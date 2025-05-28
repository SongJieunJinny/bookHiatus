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
<title>adminSchedule</title>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<style>
    #datatablesSimple {
        width: 100%;
        table-layout: fixed;  /* 컬럼 크기 고정 */
        text-align: center;  /* 가운데 정렬 */
        border-collapse: collapse; /* 테두리 정렬 */
    }

    #datatablesSimple th, #datatablesSimple td {
        padding: 10px;
        border: 1px solid #ddd; /* 테두리 추가 */
        white-space: nowrap;  /* 텍스트 줄바꿈 방지 */
        overflow: hidden;
        text-overflow: ellipsis;  /* 긴 텍스트 ... 처리 */
    }
    .adminIndexStyle {
    	color: black;
    }
    </style>
</head>
<body class="sb-nav-fixed">
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
			                  <h1 class="mt-4">일정 관리</h1>
			                  <ol class="breadcrumb mb-4">
			                      <li class="breadcrumb-item"><a class="adminIndexStyle"  href="${pageContext.request.contextPath}/admin/adminIndex.do">Dashboard</a></li>
			                      <li class="breadcrumb-item active">일정 관리</li>
			                  </ol>
			                  <div class="card mb-4">
			                      <div class="card-body">
			                        <h5 class="card-title fw-semibold mb-4">일정 등록</h5>
			                        <div id="calendar"></div>
			                      </div>
			                  </div>
			              	</div>
			          	</main>
		         	<jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
		        </div>
      		</div>
		      <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
		        <div class="modal-dialog">
		          <div class="modal-content">
		            <div class="modal-header">
		              <h5 class="modal-title" id="eventModalLabel">일정 관리</h5>
		              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		            </div>
		            <div class="modal-body">
		              <input type="hidden" id="event-id">
		      
		              <!-- 일정 제목 -->
		              <label for="event-title" class="form-label">일정 제목</label>
		              <input type="text" id="event-title" class="form-control" placeholder="일정 제목을 입력하세요">
		      
		              <!-- 일정 타입 선택 -->
		              <label for="event-color" class="form-label mt-3">일정 색상</label>
		              <input type="color" id="event-color" class="form-control form-control-color" value="#0d6efd" title="색상 선택">
		      
		              <!-- 시작일/종료일 입력 -->
		              <label for="event-start" class="form-label mt-3">시작일</label>
		              <input type="datetime-local" id="event-start" class="form-control">
		              <label for="event-end" class="form-label mt-3">종료일</label>
		              <input type="datetime-local" id="event-end" class="form-control">
		            </div>
		            <div class="modal-footer">
		              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
		              <button type="button" class="btn btn-dark" id="save-event">저장</button>
		              <button type="button" class="btn btn-danger" id="delete-event" style="display:none;">삭제</button>
		            </div>
		          </div>
		        </div>
		      </div>
		    </div> 
		    <!-- https://fullcalendar.io 에서 참조 -->
		    <!-- https://develop-cat.tistory.com/3 참조 --> 
		    <!-- https://kyurasi.tistory.com/entry/달력-뷰-만들기-fullcalendar-사용하기-일정-달력-만들기-캘린더-만들기 참조 -->  
      <script>
         document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("calendar");
            var calendar = new FullCalendar.Calendar(calendarEl, {
              headerToolbar: {
                left: "prevYear,prev,next,nextYear today",
                center: "title",
                right: "addEventButton dayGridMonth,timeGridWeek,timeGridDay"
              },
              customButtons: { //버튼 추가
                addEventButton: {
                  text: "일정추가",
                  click: function () {
                    openEventModal();
                  }
                }
              },
              selectable: true, //selectable, editable: 드래그로 일정 생성 및 수정 가능
              editable: true,
              navLinks: true,//날짜 클릭 시 → 해당 날짜로 이동 요일 이름 클릭 시 → 해당 요일의 주간 보기로 이동
              select: function (info) {
                openEventModal(info.startStr, info.endStr);
              },
              eventClick: function (info) {
                openEventModal(info.event.startStr, info.event.endStr, info.event);
              }
            });
            calendar.render();

            function openEventModal(start, end, event = null) {
              const modal = new bootstrap.Modal(document.getElementById("eventModal"));

              // 초기화
              document.getElementById("event-id").value = event ? event.id : "";
              document.getElementById("event-title").value = event ? event.title : "";
              document.getElementById("event-color").value = event ? (event.backgroundColor || "#0d6efd") : "#0d6efd";
              document.getElementById("event-start").value = start ? new Date(start).toISOString().slice(0, 16) : "";
              document.getElementById("event-end").value = end ? new Date(end).toISOString().slice(0, 16) : "";
              document.getElementById("delete-event").style.display = event ? "inline-block" : "none";

              modal.show();

              document.getElementById("save-event").onclick = function () {
                let title = document.getElementById("event-title").value;
                let color = document.getElementById("event-color").value;
                let startDate = document.getElementById("event-start").value;
                let endDate = document.getElementById("event-end").value;

                if (title && startDate) {
                  if (event) {
                    event.setProp("title", title);
                    event.setStart(startDate);
                    event.setEnd(endDate);
                    event.setProp("backgroundColor", color);
                    event.setProp("borderColor", color);
                  } else {
                    calendar.addEvent({
                      title: title,
                      start: startDate,
                      end: endDate,
                      backgroundColor: color,
                      borderColor: color,
                      allDay: false
                    });
                  }
                }
                modal.hide();
              };

              document.getElementById("delete-event").onclick = function () {
                if (event) {
                  event.remove();
                }
                modal.hide();
              };
            }
          });
      </script>
      <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js'></script>
      <script src='https://cdn.jsdelivr.net/npm/fullcalendar/daygrid@6.1.17/index.global.min.js'></script>
      <script src='https://cdn.jsdelivr.net/npm/fullcalendar/timegrid@6.1.17/index.global.min.js'></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
      <script src="<%=request.getContextPath()%>/resources/js/scripts.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
       <script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>
    </body>
</html>
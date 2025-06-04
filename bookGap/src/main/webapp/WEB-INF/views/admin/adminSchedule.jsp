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
   a{
   	color:black;
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
        const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
        	timeZone: 'local',
            initialView: 'dayGridMonth',
            headerToolbar: {   left: "prevYear,prev,next,nextYear today",
    	      center: "title",
    	      right: "addEventButton dayGridMonth,timeGridWeek,timeGridDay" },
            customButtons: {
                addEventButton: {
                    text: '일정 추가',
                    click: function () { openEventModal(); }
                }
            },
            selectable: true,
    	    editable: true,
    	    navLinks: true,
            eventSources: [
                {
                    url: '${pageContext.request.contextPath}/admin/schedule/list.do',
                    method: 'GET',
                    failure: function() { alert('일정을 불러오는데 실패했습니다.'); }
                }
            ],
            select: function(info) { openEventModal(info.startStr, info.endStr); },
            eventClick: function(info) { openEventModal(info.event.startStr, info.event.endStr, info.event); }
        });
        calendar.render();

        function openEventModal(start, end, event = null) {
            const modal = new bootstrap.Modal(document.getElementById("eventModal"));

            const toLocalDatetime = (dateStr) => {
                if (!dateStr) return "";
                const local = new Date(dateStr);
                // local datetime-local 형식으로 변환
                return new Date(local.getTime() - local.getTimezoneOffset() * 60000)
                    .toISOString().slice(0, 16);
            };

            document.getElementById("event-id").value = event ? event.id : "";
            document.getElementById("event-title").value = event ? event.title : "";
            document.getElementById("event-color").value = event ? event.backgroundColor : "#0d6efd";
            document.getElementById("event-start").value = toLocalDatetime(start);
            document.getElementById("event-end").value = toLocalDatetime(end);
            document.getElementById("delete-event").style.display = event ? "inline-block" : "none";
            modal.show();
        }

        document.getElementById("save-event").onclick = function () {
            const data = {
                scheduleId: document.getElementById("event-id").value,
                title: document.getElementById("event-title").value,
                startDate: document.getElementById("event-start").value,
                endDate: document.getElementById("event-end").value,
                color: document.getElementById("event-color").value
            };
            fetch(data.scheduleId ? '${pageContext.request.contextPath}/admin/schedule/update.do' : '${pageContext.request.contextPath}/admin/schedule/insert.do', {
                method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data)
            }).then(() => { calendar.refetchEvents(); alert("일정이 등록되었습니다. "); });
        };

        document.getElementById("delete-event").onclick = function () {
            const id = document.getElementById("event-id").value;
            fetch('${pageContext.request.contextPath}/admin/schedule/delete.do?scheduleId=' + id, { method: 'POST' }).then(() => {
                calendar.refetchEvents(); alert("일정이 삭제되었습니다. ");
            });
        };
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
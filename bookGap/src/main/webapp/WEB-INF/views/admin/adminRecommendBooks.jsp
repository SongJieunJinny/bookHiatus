<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<title>추천 도서 관리</title>
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet" />
<script src="<%=request.getContextPath()%>/resources/js/jquery-3.7.1.js"></script>
<style>
.datatable-selector {
		padding: 8px;
		width: 170%;
		margin-bottom:10px;
		margin-right: 20px;
}
#datatablesSimple th, #datatablesSimple td {
    text-align: center;
    vertical-align: middle;
}
#filterButtons button { margin: 5px;
 }
#customTypeInput {
    margin-top: 10px;
}
</style>
</head>
<body class="sb-nav-fixed">
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/include/adminHeader.jsp" />
    <div id="layoutSidenav">
        <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                <div class="sb-sidenav-menu">
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
                    <!-- 페이지 제목 -->
                    <h1 class="mt-4">Recommend Book Management System</h1>
                    <br>
                    <!-- 상단 카드 (간단 설명) -->
                    <div class="card mb-4">
                        <div class="card-body">
                            추천 도서 관리 페이지 
                        </div>
                    </div>
                    <!-- 추천 도서 테이블 -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-table me-1"></i>
                            추천 도서 목록
                        </div>
                        <div class="card-body">
                            <!-- 필터 버튼 -->
                            <div id="filterButtons" class="mb-3">
							    <button class="btn btn-outline-primary" onclick="filterType('')">전체</button>
							    <c:forEach var="type" items="${recommendTypes}">
							        <c:set var="btnClass" value="${typeColorMap[type] != null ? typeColorMap[type] : 'btn-outline-secondary'}" />
							        <button class="btn ${btnClass}" onclick="filterType('${type}')">${type}</button>
							    </c:forEach>
							    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">추천 도서 추가</button>
							</div>

                            <table id="datatablesSimple" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>도서 번호</th>
                                        <th>제목</th>
                                        <th>추천 타입</th>
                                        <th>추천 사유</th>
                                        <th>삭제</th>
                                    </tr>
                                </thead>
                              <tbody>
                                   <c:forEach items="${recommendBooks}" var="vo">
									  <tr>
									    <td>
									      ${vo.bookNo}
									      <input type="hidden" class="oldRecommendType" value="${vo.recommendType != null ? vo.recommendType : 'BASIC'}" />
									    </td>
									    <td>${vo.title}</td>
									    <td>
										  <select class="recommendType form-select form-select-sm">
											  <c:forEach var="type" items="${recommendTypes}">
											    <option value="${type}" ${type eq vo.recommendType ? 'selected' : ''}>${type}</option>
											  </c:forEach>
											  <option value="custom">직접 입력</option>
										  </select>
										<input type="text" class="form-control customRecommendType mt-1" placeholder="추천 타입 직접 입력" style="display: none;" value="" />
										</td>
									    <td>
									      <input type="text" class="form-control recommendComment" value="${vo.recommendComment}" />
									    </td>
									    <td>
									      <button class="btn btn-danger btn-sm btnDelete">삭제</button>
									    </td>
									  </tr>
									</c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="/WEB-INF/views/include/adminFooter.jsp" />
        </div>
    </div>
    <!-- Modal -->
		<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <form id="addForm">
		        <div class="modal-header">
		          <h5 class="modal-title" id="addModalLabel">추천 도서 등록</h5>
		          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
		        </div>
		        <div class="modal-body">
		          <div class="mb-3">
		            <label for="addBookNo" class="form-label">도서 번호</label>
		            <input type="number" class="form-control" id="addBookNo" required>
		          </div>
		          <div class="mb-3">
		            <label for="addType" class="form-label">추천 타입</label>
						<select id="addType" class="form-select" required>
						  <option value="BASIC">BASIC</option>
						  <option value="SEASON">SEASON</option>
						  <option value="THEME">THEME</option>
						  <option value="custom">직접 입력</option> <!-- 새로운 옵션 -->
						</select>
						<!-- 직접 입력 필드 (초기에는 숨김 처리) -->
						<input type="text" id="customTypeInput" maxlength="50" placeholder="추천 타입 (최대 50자)" class="form-control mt-2"
						       placeholder="새로운 추천 타입을 입력하세요" style="display: none;" />
		          </div>
		          <div class="mb-3">
		            <label for="addComment" class="form-label">추천 사유</label>
		            <textarea class="form-control" id="addComment" rows="3" placeholder="추천 이유를 입력하세요"></textarea>
		          </div>
		        </div>
		        <div class="modal-footer">
		          <button type="submit" class="btn btn-primary">등록</button>
		          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
		        </div>
		      </form>
		    </div>
		  </div>
		</div>

<!-- Bootstrap & DataTables -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/resources/js/datatables-simple-demo.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const table = new simpleDatatables.DataTable("#datatablesSimple", {
        labels: {
            perPage: "",
            placeholder: "검색어 입력...",
            noRows: "추천 도서가 없습니다.",
            info: ""
        }
    });
});

// 필터 기능
function filterType(type){
  window.location.href =
    '${pageContext.request.contextPath}/admin/adminRecommendBooks.do?recommendType=' + encodeURIComponent(type || '');
}

$(document).ready(function(){
    // 도서 추가
    $('#addForm').on('submit', function(e){
        e.preventDefault();

        const bookNo = $('#addBookNo').val().trim();
        let recommendType = $('#addType').val();
        const customType = $('#customTypeInput').val().trim();
        const recommendComment = $('#addComment').val().trim();

        if (recommendType === 'custom') {
            if (!customType) {
                alert('추천 타입을 입력해주세요.');
                return;
            }
            recommendType = customType;
        }

        if (!bookNo || !recommendType) {
            alert('도서번호와 추천타입은 필수입니다.');
            return;
        }

        $.post('${pageContext.request.contextPath}/admin/recommend/add.do', {
            bookNo: bookNo,
            recommendType: recommendType,
            recommendComment: recommendComment
        }, function(){
            alert('추천 도서가 추가되었습니다.');
            $('#addModal').modal('hide');
            location.reload();
        }).fail(function(xhr){
            alert('추가 실패: ' + xhr.responseText);
        });
    });

    // 모달에서 직접입력 선택 시 input 표시
    $('#addType').on('change', function () {
        if ($(this).val() === 'custom') {
            $('#customTypeInput').show();
        } else {
            $('#customTypeInput').hide().val('');
        }
    });

    // 모달에서 입력한 추천타입을 select에 추가
    $('#customTypeInput').on('change', function () {
        const customVal = $(this).val().trim();
        const select = $('#addType');

        if (customVal !== '') {
            const exists = select.find('option').filter(function() {
                return $(this).val() === customVal;
            }).length > 0;

            if (!exists) {
                select.append($('<option>', {
                    value: customVal,
                    text: customVal
                }));
            }

            select.val(customVal);
        }
    });

    // 테이블 select에서 '직접 입력' 선택 시 input 표시
	 $(document).on('change', '.recommendType', function () {
	    const row = $(this).closest('tr');
	    const selectedVal = $(this).val();
	    const input = row.find('.customRecommendType');
	
	    if (selectedVal === 'custom') {
	        input.val('').show().focus(); // 여기서도 초기화
	    } else {
	        input.hide().val('');
	    }
	});
	
	// 테이블에서 custom 입력 시 자동 추가 및 선택
	$(document).on('input', '.customRecommendType', function () {
	    const row = $(this).closest('tr');
	    const customVal = $(this).val().trim();
	    const select = row.find('.recommendType');
	
	    if (customVal !== '') {
	        const exists = select.find('option').filter(function () {
	            return $(this).val() === customVal;
	        }).length > 0;
	
	        if (!exists) {
	            select.append($('<option>', {
	                value: customVal,
	                text: customVal
	            }));
	        }
	
	        //  여기서는 자동 선택만, 이벤트 트리거는 제거!
	        select.val(customVal);
	    }
	});


	// select, comment input은 change로 처리
	$(document).on('change', '.recommendType, .recommendComment', function () {
	    handleUpdate($(this).closest('tr'));
	});

	// customRecommendType은 blur 또는 Enter에서만 처리
	$(document).on('blur', '.customRecommendType', function () {
	    handleUpdate($(this).closest('tr'));
	});
	$(document).on('keyup', '.customRecommendType', function (e) {
	    if (e.key === 'Enter') {
	        e.preventDefault();         // 폼 제출 방지
	        $(this).blur();             // blur 이벤트 강제 발생
	    }
	});

	$(document).on('keyup', '.customRecommendType', function (e) {
	    if (e.key === 'Enter') {
	        handleUpdate($(this).closest('tr'));
	    }
	});

	function handleUpdate(row) {
	    const bookNo = row.find('td:eq(0)').text().trim();
	    const oldRecommendType = row.find('.oldRecommendType').val();
	    const selectVal = row.find('.recommendType').val();
	    const customVal = row.find('.customRecommendType').val().trim();
	    const recommendComment = row.find('.recommendComment').val();

	    let recommendType = '';

	    if (selectVal === 'custom') {
	        if (customVal === '') {
	            // 입력 안 되었을 경우 업데이트 하지 않음
	            return;
	        }
	        recommendType = customVal;
	    } else {
	        recommendType = selectVal;
	    }

	    if (!bookNo || !recommendType || !oldRecommendType) {
	        alert('필수값 누락!');
	        return;
	    }

	    $.post('${pageContext.request.contextPath}/admin/recommend/update.do', {
	        bookNo: bookNo,
	        oldRecommendType: oldRecommendType,
	        recommendType: recommendType,
	        recommendComment: recommendComment
	    }).done(function () {
	        row.find('.oldRecommendType').val(recommendType);
	        alert('추천 도서가 성공적으로 업데이트되었습니다.');
	    }).fail(function (xhr) {
	        alert('업데이트 실패\n' + xhr.responseText);
	    });
	}

    // 도서 삭제
    $('.btnDelete').click(function(){
        const row = $(this).closest('tr');
        const bookNo = row.find('td:eq(0)').text();
        const recommendType = row.find('.recommendType').val();

        if(confirm('정말 삭제하시겠습니까?')){
            $.post('${pageContext.request.contextPath}/admin/recommend/delete.do',
                { bookNo: bookNo, recommendType: recommendType },
                function(){ row.remove(); alert('삭제 완료'); }
            ).fail(function(){ alert('삭제 실패'); });
        }
    });
});
</script>
</body>
</html>
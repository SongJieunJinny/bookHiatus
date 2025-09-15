# bookHiatus

## 📑 목차

- [프로젝트 진행기간](#프로젝트-진행기간)
- [개요](#개요)
- [주요기능](#주요기능)
- [기술 및 컨벤션](#기술-및-컨벤션) 
- [트러블슈팅](#트러블슈팅)
- [개발환경](#개발환경)
- [ERD](#erd)
- [프로젝트 파일 구조](#프로젝트-파일-구조)
- [명세서 API Reference](#명세서-api-reference)
- [서비스화면](#서비스화면)
- [팀원(역할/깃계정)](#팀원역할깃계정)

--- 

## 📌개요
- 온라인 독립서점 웹서비스로, 사용자·비회원 주문/결제, 도서 검색·상세·장바구니, 게시판(공지/Q&A/이벤트) 등 커머스 핵심 흐름을 end-to-end로 구현.
- Spring MVC + MyBatis + MySQL 기반 백엔드와 JSP/jQuery/Bootstrap UI, Spring Security 인증/인가, 외부 연동(Naver Book, Kakao 로그인, KakaoPay·TossPay 결제)을 통합.
- 비회원은 UUID 기반 주문키로 안전하게 조회하고, 배송 시작 전/후를 기준으로 취소·환불을 분기 처리하여 보안성 강화.
- 관리자 콘솔에서는 도서/추천/재고/주문·환불/신고/매출·일정 관리와 대시보드 차트를 제공해 운영 효율성을 중시.
  
--- 
## 📝주요기능

- 사용자 기능: 도서 목록/상세, 리뷰, 장바구니·주문
- 관리자 기능: 도서/추천/재고/주문·배송/환불/신고/매출/일정/회원 관리
- 대시보드 및 통계 시각화 제공
- [상세](../../wiki/상세)
  
--- 

## ⚙️ 기술 및 컨벤션
### 🧑‍💻 사용자 영역 (User-facing)
- JSP + JSTL(c:), Spring Security 태그(sec:) 기반 뷰 렌더링
- jQuery Ajax 통신으로 비동기 처리 (로그인/회원가입/주문/댓글 등)
- 회원 비밀번호: BCryptPasswordEncoder 단방향 암호화
- ROLE_USER / ROLE_ADMIN 권한 기반 접근 제어

### 🛠 관리자 영역 (Admin)
- Bootstrap 5 관리자 레이아웃 (SB Admin)
- jQuery + simple-datatables (리스트/검색/페이징)
- Chart.js (매출·통계 시각화), FullCalendar (일정 관리)
- Ajax 요청 컨벤션: /admin/도메인/액션 (/admin/books/bookInsert)
- 응답 포맷: {success:true, data:...} 구조 통일

### 🧩 공통 레이아웃
- adminHeader.jsp, adminNav.jsp, adminFooter.jsp로 모듈화
- header.jsp, footer.jsp (사용자 영역 공통 레이아웃)
- err401.jsp, err404.jsp, err500.jsp 에러 페이지 분리

### 🌐 외부 연동
- Naver Book API: 도서 등록 자동화 (관리자 페이지 검색 → 자동 입력)
- KakaoPay / TossPayments API: 결제 승인·취소·환불 처리
- Kakao 로그인 API: 카카오간편로그인 
- API Key/Secret 값은 환경변수·properties 파일로 분리 관리

### 🎨 UX / UI 컨벤션
- 데이터 검증: 송장번호 영숫자, 배송상태 전이 조건(배송중→완료) 필수 검증
- 금액: toLocaleString("ko-KR") / 날짜: Date.toLocaleString("ko-KR")
- 반응형 CSS (@media) 적용 — PC·Tablet·Mobile 대응
- 공통 스크립트 함수화 (updateCartCount(), normalizeCartItems())
- Mapper XML 네임스페이스 규칙: 도메인Mapper (예: BookMapper, OrderMapper)

### 🏗 아키텍처 & DB 설계
- 계층 구조: Controller → Service → DAO → MyBatis Mapper → DB
- VO 클래스 일관된 네이밍(*VO)
- DB 정규화 및 FK 관계 명확화
- 작성일(BOARD_RDATE) vs 수정일(BOARD_UDATE) 분리 관리
- 비회원 주문: UUID 기반 orderKey 발급 → 이메일 + orderKey 조합 조회

### 🔄 운영 & 유지보수
- contextPath 기반 리소스 참조 (<c:url>, ${pageContext.request.contextPath})
- InventoryScheduler (5분 주기) → 도서 재고 상태 자동 갱신
- 공통 에러 처리: ControllerAdvice or try-catch 기반 JSON 응답 일관성 유지
  
--- 
## 🐞트러블슈팅

- [회원,비회원 결제로직 혼재문제](../../wiki/회원,비회원-결제로직-혼재문제)
- [비회원 주문키(orderKey) 관리 UX](../../wiki/비회원-주문키(orderKey)-관리-UX).
- [주문취소(Cancel) vs 환불(Refund) 흐름 모호성](../../wiki/주문취소(Cancel)-vs-환불(Refund)-흐름-모호성)
- [장바구니 안정화: 카운트 일원화 · 동기화 순서 보장 · 데이터 정규화 ](../../wiki/장바구니-안정화)
- [카카오 로그아웃 흐름의 꼬임과 잔여 세션/쿠키가 남음 문제](../../wiki/카카오-로그아웃-흐름의-꼬임과-잔여-세션/쿠키가-남음-문제)
  
--- 

## 💻개발환경

- JDK 1.8, MySQL 8.0, TOMCAT 9.0, SPRING FRAMEWORK 4.3.3.RELEASE, SPRING SECURITY 3.2.10.RELEASE, MyBatis 3.4.1
- JAVA8, HTML5, CSS3, JSP4, JavaScript, jQuery, Ajax
- SpringToolSuite 4, Visual Studio Code, ERMaster, MySQL (Workbench 8.0),GitHub, Notion
  
--- 

## 🔗ERD

```mermaid
erDiagram
  USER {
    varchar USER_ID PK
    varchar USER_PW
    int USER_ENABLED
    varchar USER_AUTHORITY
    tinyint USER_STATE
    varchar USER_NAME
    date USER_JOIN_DATE
    varchar USER_PHONE
    varchar USER_EMAIL
    int COMPLAIN_NO
    text NOTE
    tinyint CAN_COMMENT
    varchar KAKAO_ID
    varchar OAUTH_PROVIDER
  }

  USER_ADDRESS {
    int USER_ADDRESS_ID PK
    varchar USER_ID FK
    varchar ADDRESS_NAME
    varchar POST_CODE
    varchar ROAD_ADDRESS
    varchar DETAIL_ADDRESS
    tinyint IS_DEFAULT
    varchar USER_NAME
    varchar USER_PHONE
  }

  GUEST {
    varchar GUEST_ID PK
    varchar GUEST_NAME
    varchar GUEST_PHONE
    varchar GUEST_EMAIL
    timestamp GUEST_CREATED_AT
  }

  GUEST_ADDRESS {
    int GUEST_POST_CODE
    varchar GUEST_ROAD_ADDRESS
    varchar GUEST_DETAIL_ADDRESS
    varchar GUEST_ID PK
  }

  PRODUCT_API {
    varchar isbn PK
    varchar title
    int discount
    date pubdate
    varchar publisher
    varchar author
    text description
    varchar image
    varchar link
  }

  BOOK {
    int BOOK_NO PK
    timestamp BOOK_RDATE
    varchar BOOK_TRANS
    int BOOK_STOCK
    tinyint BOOK_STATE
    varchar BOOK_CATEGORY
    varchar isbn FK
    varchar BOOK_IMGURL
    text BOOK_INDEX
    text PUBLISHER_BOOK_REVIEW
  }

  BOARD {
    int BOARD_NO PK
    varchar BOARD_TITLE
    text BOARD_CONTENT
    int BOARD_HIT
    tinyint BOARD_STATE
    datetime BOARD_RDATE
    tinyint BOARD_TYPE
    varchar USER_ID FK
    int BOOK_NO FK
  }

  ATTACH {
    int ATTACH_NO PK
    varchar ATTACH_NAME
    varchar FAKE_ATTACH_NAME
    int BOARD_NO FK
    int BOOK_NO FK
  }

  ORDERS {
    int ORDER_ID PK
    timestamp ORDER_DATE
    tinyint ORDER_STATUS
    int TOTAL_PRICE
    tinyint ORDER_TYPE
    varchar USER_ID
    varchar GUEST_ID FK
    varchar RECEIVER_NAME
    varchar RECEIVER_PHONE
    varchar RECEIVER_POST_CODE
    varchar RECEIVER_ROAD_ADDRESS
    varchar RECEIVER_DETAIL_ADDRESS
    varchar DELIVERY_REQUEST
    varchar ORDER_PASSWORD
    int USER_ADDRESS_ID FK
    varchar COURIER
    varchar INVOICE
    tinyint REFUND_STATUS
    varchar ORDER_KEY  "unique"
  }

  ORDER_DETAIL {
    int ORDER_DETAIL_NO PK
    int ORDER_COUNT
    int ORDER_PRICE
    tinyint REFUND_CHECK
    int BOOK_NO FK
    int ORDER_ID FK
  }

  PAYMENTS {
    int PAYMENT_NO PK
    decimal amount
    tinyint payment_method
    tinyint status
    timestamp created_at
    int ORDER_ID FK
    varchar USER_ID
    varchar GUEST_ID FK
  }

  PAYMENT_LOGS {
    int LOG_ID PK
    int PAYMENT_NO FK
    varchar LOG_MESSAGE
    timestamp CREATED_AT
  }

  REFUND {
    int REFUND_NO PK
    int ORDER_ID FK
    int PAYMENT_NO FK
    text REFUND_REASON
    tinyint REFUND_STATUS
    timestamp CREATED_AT
  }

  COMMENT {
    int COMMENT_NO PK
    text COMMENT_CONTENT
    tinyint COMMENT_STATE
    date COMMENT_RDATE
    varchar USER_ID
    int BOOK_NO FK
    varchar isbn FK
  }

  COMMENT_RATING {
    int RATING_NO PK
    int COMMENT_NO FK
    varchar USER_ID FK
    int RATING
    varchar isbn FK
  }

  LOVE {
    int LOVE_NO PK
    int COMMENT_NO FK
    varchar USER_ID
    varchar isbn FK
  }

  COMPLAIN {
    int COMPLAIN_NO PK
    int COMMENT_NO FK
    varchar USER_ID FK
    tinyint COMPLAIN_TYPE
    timestamp REPORT_DATE
    varchar STATUS
    text PROCESS_NOTE
  }

  ECOMMENT {
    int ECOMMENT_NO PK
    text ECOMMENT_CONTENT
    tinyint ECOMMENT_STATE
    date ECOMMENT_RDATE
    int BOARD_NO FK
    varchar USER_ID FK
  }

  QCOMMENT {
    int QCOMMENT_NO PK
    text QCOMMENT_CONTENT
    tinyint QCOMMENT_STATE
    date QCOMMENT_RDATE
    int BOARD_NO FK
    varchar USER_ID FK
  }

  RECOMMEND_BOOK {
    int BOOK_NO
    varchar RECOMMEND_TYPE
    timestamp RECOMMEND_DATE
    text RECOMMEND_COMMENT
  }

  SCHEDULE {
    int SCHEDULE_ID PK
    varchar TITLE
    datetime START_DATE
    datetime END_DATE
    varchar COLOR
    text CONTENT
    timestamp CREATED_AT
  }

  %% =========================
  %% RELATIONSHIPS
  %% =========================
  USER ||--o{ USER_ADDRESS : has
  GUEST ||--|| GUEST_ADDRESS : has

  PRODUCT_API ||--o{ BOOK : by_isbn
  BOOK ||--o{ BOARD : referenced_by
  USER ||--o{ BOARD : writes

  BOARD ||--o{ ATTACH : has
  BOOK ||--o{ ATTACH : has

  USER ||--o{ ORDERS : places
  GUEST ||--o{ ORDERS : places
  USER_ADDRESS ||--o{ ORDERS : ship_to

  ORDERS ||--|{ ORDER_DETAIL : contains
  BOOK ||--o{ ORDER_DETAIL : ordered

  ORDERS ||--|| PAYMENTS : paid_by  "1:1 via ORDER_ID"
  GUEST ||--o{ PAYMENTS : payer
  PAYMENTS ||--o{ PAYMENT_LOGS : logs
  ORDERS ||--o{ REFUND : has
  PAYMENTS ||--o{ REFUND : refunded

  BOOK ||--o{ COMMENT : commented
  USER ||--o{ COMMENT : writes
  BOOK ||--o{ COMMENT_RATING : rated
  USER ||--o{ COMMENT_RATING : rates
  COMMENT ||--o{ COMMENT_RATING : has

  COMMENT ||--o{ LOVE : liked_by
  BOOK ||--o{ LOVE : on_isbn
  USER ||--o{ LOVE : likes

  COMMENT ||--o{ COMPLAIN : reported
  USER ||--o{ COMPLAIN : files

  BOARD ||--o{ ECOMMENT : event_comments
  USER ||--o{ ECOMMENT : writes
  BOARD ||--o{ QCOMMENT : qna_comments
  USER ||--o{ QCOMMENT : writes

  BOOK ||--o{ RECOMMEND_BOOK : recommended  "composite (BOOK_NO, TYPE)"



```


---
## 📂프로젝트 파일 구조


### BackEnd (Java + Spring)

```text
src/
├─ main/
│ ├─ java/
│ │ ├─ com/
│ │ │ ├─ bookGap/
│ │ │ │ ├─ config/
│ │ │ │ │ ├─ AppConfig.java
│ │ │ │ ├─ controller/
│ │ │ │ │ ├─ AboutController.java
│ │ │ │ │ ├─ AddressController.java
│ │ │ │ │ ├─ AdminBookController.java
│ │ │ │ │ ├─ AdminIndexController.java
│ │ │ │ │ ├─ AdminInventoryManagementController.java
│ │ │ │ │ ├─ AdminOrderController.java
│ │ │ │ │ ├─ AdminRecommendController.java
│ │ │ │ │ ├─ AdminReportManagementController.java
│ │ │ │ │ ├─ AdminSalesController.java
│ │ │ │ │ ├─ AdminScheduleController.java
│ │ │ │ │ ├─ AdminUserInfoController.java
│ │ │ │ │ ├─ BookController.java
│ │ │ │ │ ├─ BoardController.java
│ │ │ │ │ ├─ CartController.java
│ │ │ │ │ ├─ ChoiceController.java
│ │ │ │ │ ├─ CommentController.java
│ │ │ │ │ ├─ CommentLoveController.java
│ │ │ │ │ ├─ CommentRatingController.java
│ │ │ │ │ ├─ ECommentController.java
│ │ │ │ │ ├─ GlobalModelAttribute.java
│ │ │ │ │ ├─ GuestController.java
│ │ │ │ │ ├─ HeaderController.java
│ │ │ │ │ ├─ HomeController.java
│ │ │ │ │ ├─ KakaoLoginController.java
│ │ │ │ │ ├─ MypageController.java
│ │ │ │ │ ├─ OrderController.java
│ │ │ │ │ ├─ PaymentController.java
│ │ │ │ │ ├─ ProductApiController.java
│ │ │ │ │ ├─ QCommentController.java
│ │ │ │ │ ├─ RefundController.java
│ │ │ │ │ ├─ SearchController.java
│ │ │ │ │ ├─ UserController.java
│ │ │ │ │ └─ adminRefundController.java
│ │ │ │ ├─ dao/
│ │ │ │ │ ├─ AddressDAO.java
│ │ │ │ │ ├─ AdminBookDAO.java
│ │ │ │ │ ├─ AdminOrderDAO.java
│ │ │ │ │ ├─ AdminRefundDAO.java
│ │ │ │ │ ├─ AdminSalesDAO.java
│ │ │ │ │ ├─ AdminScheduleDAO.java
│ │ │ │ │ ├─ BookDAO.java
│ │ │ │ │ ├─ BoardDAO.java
│ │ │ │ │ ├─ CartDAO.java
│ │ │ │ │ ├─ CommentDAO.java
│ │ │ │ │ ├─ CommentLoveDAO.java
│ │ │ │ │ ├─ CommentRatingDAO.java
│ │ │ │ │ ├─ ComplainDAO.java
│ │ │ │ │ ├─ ECommentDAO.java
│ │ │ │ │ ├─ GuestDAO.java
│ │ │ │ │ ├─ MypageDAO.java
│ │ │ │ │ ├─ OrderDAO.java
│ │ │ │ │ ├─ PaymentDAO.java
│ │ │ │ │ ├─ ProductApiDAO.java
│ │ │ │ │ ├─ QCommentDAO.java
│ │ │ │ │ ├─ RecommendBookDAO.java
│ │ │ │ │ ├─ RefundDAO.java
│ │ │ │ │ └─ UserDAO.java
│ │ │ │ ├─ filter/
│ │ │ │ │ ├─ LoggingFilter.java
│ │ │ │ ├─ scheduler/
│ │ │ │ │ ├─ InventoryScheduler.java
│ │ │ │ ├─ service/
│ │ │ │ │ ├─ AddressService.java
│ │ │ │ │ ├─ AddressServiceImpl.java
│ │ │ │ │ ├─ AdminBookService.java
│ │ │ │ │ ├─ AdminBookServiceImpl.java
│ │ │ │ │ ├─ AdminOrderInfoService.java
│ │ │ │ │ ├─ AdminOrderInfoServiceImpl.java
│ │ │ │ │ ├─ AdminRefundService.java
│ │ │ │ │ ├─ AdminRefundServiceImpl.java
│ │ │ │ │ ├─ AdminSalesService.java
│ │ │ │ │ ├─ AdminSalesServiceImpl.java
│ │ │ │ │ ├─ AdminScheduleService.java
│ │ │ │ │ ├─ AdminScheduleServiceImpl.java
│ │ │ │ │ ├─ AdminUserInfoService.java
│ │ │ │ │ ├─ AdminUserInfoServiceImpl.java
│ │ │ │ │ ├─ BoardService.java
│ │ │ │ │ ├─ BoardServiceImpl.java
│ │ │ │ │ ├─ BookService.java
│ │ │ │ │ ├─ BookServiceImpl.java
│ │ │ │ │ ├─ CartService.java
│ │ │ │ │ ├─ CartServiceImpl.java
│ │ │ │ │ ├─ CommentLoveService.java
│ │ │ │ │ ├─ CommentLoveServiceImpl.java
│ │ │ │ │ ├─ CommentRatingService.java
│ │ │ │ │ ├─ CommentRatingServiceImpl.java
│ │ │ │ │ ├─ CommentService.java
│ │ │ │ │ ├─ CommentServiceImpl.java
│ │ │ │ │ ├─ ComplainService.java
│ │ │ │ │ ├─ ComplainServiceImpl.java
│ │ │ │ │ ├─ ECommentService.java
│ │ │ │ │ ├─ ECommentServiceImpl.java
│ │ │ │ │ ├─ GuestService.java
│ │ │ │ │ ├─ GuestServiceImpl.java
│ │ │ │ │ ├─ KakaoUserDetails.java
│ │ │ │ │ ├─ MypageService.java
│ │ │ │ │ ├─ MypageServiceImpl.java
│ │ │ │ │ ├─ OrderService.java
│ │ │ │ │ ├─ OrderServiceImpl.java
│ │ │ │ │ ├─ PaymentService.java
│ │ │ │ │ ├─ PaymentServiceImpl.java
│ │ │ │ │ ├─ ProductApiService.java
│ │ │ │ │ ├─ ProductApiServiceImpl.java
│ │ │ │ │ ├─ QCommentService.java
│ │ │ │ │ ├─ QCommentServiceImpl.java
│ │ │ │ │ ├─ RecommendBookService.java
│ │ │ │ │ ├─ RecommendBookServiceImpl.java
│ │ │ │ │ ├─ RefundService.java
│ │ │ │ │ ├─ RefundServiceImpl.java
│ │ │ │ │ ├─ UserAuthenticationService.java
│ │ │ │ │ ├─ UserDeniedHandler.java
│ │ │ │ │ ├─ UserLoginFailureHandler.java
│ │ │ │ │ ├─ UserLoginSuccessHandler.java
│ │ │ │ │ ├─ UserService.java
│ │ │ │ │ └─ UserServiceImpl.java
│ │ │ │ ├─ util/
│ │ │ │ │ ├─ PagingUtil.java
│ │ │ │ │ └─ StringUtils.java
│ │ │ │ └─ vo/
│ │ │ │ ├─ AdminOrderUpdateRequestVO.java
│ │ │ │ ├─ BoardVO.java
│ │ │ │ ├─ BookVO.java
│ │ │ │ ├─ CartVO.java
│ │ │ │ ├─ CommentLoveVO.java
│ │ │ │ ├─ CommentRatingVO.java
│ │ │ │ ├─ CommentVO.java
│ │ │ │ ├─ ComplainSummaryVO.java
│ │ │ │ ├─ ComplainVO.java
│ │ │ │ ├─ ECommentVO.java
│ │ │ │ ├─ GuestVO.java
│ │ │ │ ├─ KakaoPayCancelVO.java
│ │ │ │ ├─ KakaoPayRequestVO.java
│ │ │ │ ├─ MypageVO.java
│ │ │ │ ├─ NaverBookResponse.java
│ │ │ │ ├─ OrderDetailVO.java
│ │ │ │ ├─ OrderItemVO.java
│ │ │ │ ├─ OrderVO.java
│ │ │ │ ├─ PaymentVO.java
│ │ │ │ ├─ ProductApiVO.java
│ │ │ │ ├─ QCommentVO.java
│ │ │ │ ├─ RecommendBookVO.java
│ │ │ │ ├─ RefundUpdateRequestVO.java
│ │ │ │ ├─ RefundVO.java
│ │ │ │ ├─ SalesVO.java
│ │ │ │ ├─ ScheduleVO.java
│ │ │ │ ├─ SearchVO.java
│ │ │ │ ├─ TossCancelVO.java
│ │ │ │ ├─ TossRequestVO.java
│ │ │ │ ├─ UserAddressVO.java
│ │ │ │ ├─ UserInfoVO.java
│ │ │ │ ├─ UserVO.java
│ │ │ │ └─ ComplainVO.java
├─ test/
│ └─ java/
```

### FrontEnd (JSP + Static Resources)

```text
src/
├─ main/
│ ├─ webapp/
│ │ ├─ WEB-INF/
│ │ │ ├─ views/
│ │ │ │ ├─ about.jsp
│ │ │ │ ├─ admin/
│ │ │ │ │ ├─ adminBook.jsp
│ │ │ │ │ ├─ adminGuestOrderInfo.jsp
│ │ │ │ │ ├─ adminIndex.jsp
│ │ │ │ │ ├─ adminInventoryManagement.jsp
│ │ │ │ │ ├─ adminRefund.jsp
│ │ │ │ │ ├─ adminReportManagement.jsp
│ │ │ │ │ ├─ adminSales.jsp
│ │ │ │ │ ├─ adminSchedule.jsp
│ │ │ │ │ ├─ adminUserInfo.jsp
│ │ │ │ │ ├─ adminUserOrderInfo.jsp
│ │ │ │ │ ├─ err401.jsp
│ │ │ │ │ ├─ err404.jsp
│ │ │ │ │ └─ err500.jsp
│ │ │ │ ├─ board/
│ │ │ │ │ ├─ eventList.jsp
│ │ │ │ │ ├─ eventModify.jsp
│ │ │ │ │ ├─ eventView.jsp
│ │ │ │ │ ├─ eventWrite.jsp
│ │ │ │ │ ├─ noticeList.jsp
│ │ │ │ │ ├─ noticeModify.jsp
│ │ │ │ │ ├─ noticeView.jsp
│ │ │ │ │ ├─ noticeWrite.jsp
│ │ │ │ │ ├─ qnaList.jsp
│ │ │ │ │ ├─ qnaModify.jsp
│ │ │ │ │ ├─ qnaView.jsp
│ │ │ │ │ └─ qnaWrite.jsp
│ │ │ │ ├─ choice/
│ │ │ │ │ └─ choiceList.jsp
│ │ │ │ ├─ guest/
│ │ │ │ │ ├─ guestOrder.jsp
│ │ │ │ │ ├─ guestOrderDetailsView.jsp
│ │ │ │ │ └─ guestOrderInfo.jsp
│ │ │ │ ├─ include/
│ │ │ │ │ ├─ adminFooter.jsp
│ │ │ │ │ ├─ adminHeader.jsp
│ │ │ │ │ ├─ adminNav.jsp
│ │ │ │ │ ├─ footer.jsp
│ │ │ │ │ └─ header.jsp
│ │ │ │ ├─ order/
│ │ │ │ │ ├─ myOrder.jsp
│ │ │ │ │ ├─ orderComplete.jsp
│ │ │ │ │ ├─ orderDetailsView.jsp
│ │ │ │ │ └─ orderMain.jsp
│ │ │ │ ├─ product/
│ │ │ │ │ ├─ bookList.jsp
│ │ │ │ │ ├─ bookSearch.jsp
│ │ │ │ │ ├─ bookView.jsp
│ │ │ │ │ └─ cart.jsp
│ │ │ │ ├─ user/
│ │ │ │ │ ├─ deleteMembership.jsp
│ │ │ │ │ ├─ findPw.jsp
│ │ │ │ │ ├─ join.jsp
│ │ │ │ │ ├─ mypage.jsp
│ │ │ │ │ └─ mypageInfo.jsp
│ │ │ │ ├─ home.jsp
│ │ │ │ └─ popup/
│ │ │ │ └─ bookSearch.jsp
│ │ ├─ resources/
│ │ │ ├─ assets/
│ │ │ │ ├─ demo/
│ │ │ │ │ ├─ chart-area-demo.js
│ │ │ │ │ ├─ chart-bar-demo.js
│ │ │ │ │ ├─ chart-pie-demo.js
│ │ │ │ │ └─ datatables-demo.js
│ │ │ │ └─ img/
│ │ │ │ ├─ ._error-404-monochrome.svg
│ │ │ │ └─ error-404-monochrome.svg
│ │ │ ├─ css/
│ │ │ │ ├─ book/
│ │ │ │ │ ├─ bookList.css
│ │ │ │ │ ├─ bookSearch.css
│ │ │ │ │ ├─ bookView.css
│ │ │ │ │ ├─ cart.css
│ │ │ │ │ └─ order.css
│ │ │ │ ├─ board/
│ │ │ │ │ ├─ event.css
│ │ │ │ │ ├─ notice.css
│ │ │ │ │ └─ qna.css
│ │ │ │ ├─ guest/
│ │ │ │ │ └─ guest.css
│ │ │ │ ├─ user/
│ │ │ │ │ ├─ findPw.css
│ │ │ │ │ ├─ join.css
│ │ │ │ │ ├─ login.css
│ │ │ │ │ └─ mypage.css
│ │ │ │ ├─ index.css
│ │ │ │ └─ styles.css
│ │ │ ├─ img/
│ │ │ │ ├─ icon/
│ │ │ │ │ ├─ address.png
│ │ │ │ │ ├─ cart.png
│ │ │ │ │ ├─ collapse.png
│ │ │ │ │ ├─ date.png
│ │ │ │ │ ├─ edit.png
│ │ │ │ │ ├─ expand.png
│ │ │ │ │ ├─ heart.png
│ │ │ │ │ ├─ left.png
│ │ │ │ │ ├─ login.png
│ │ │ │ │ ├─ logo.png
│ │ │ │ │ ├─ marker.png
│ │ │ │ │ ├─ menu-dot.png
│ │ │ │ │ ├─ right.png
│ │ │ │ │ ├─ search.png
│ │ │ │ │ └─ setting.png
│ │ │ │ ├─ kakaopay.jpg
│ │ │ │ └─ tosspay.png
│ │ │ ├─ js/
│ │ │ │ ├─ cart-utils.js
│ │ │ │ ├─ datatables-simple-demo.js
│ │ │ │ ├─ jquery-3.7.1.js
│ │ │ │ └─ scripts.js


```

### Config / Meta (Settings, Build, Mapper & Spring Config)

```text
. (project root)
├─ pom.xml
├─ project_structure.txt
├─ .classpath
├─ .project
├─ .settings/
│ ├─ .jsdtscope
│ ├─ org.eclipse.jdt.core.prefs
│ ├─ org.eclipse.jst.j2ee.ejb.annotations.xdoclet.prefs
│ ├─ org.eclipse.ltk.core.refactoring.prefs
│ ├─ org.eclipse.wst.common.component
│ ├─ org.eclipse.wst.common.project.facet.core.xml
│ ├─ org.eclipse.wst.jsdt.ui.superType.container
│ ├─ org.eclipse.wst.jsdt.ui.superType.name
│ ├─ org.eclipse.wst.validation.prefs
│ └─ org.springframework.ide.eclipse.xml.namespaces.prefs
├─ build/
│ ├─ classes
src/
├─ main/
│ ├─ resources/
│ │ ├─ log4j.xml
│ │ ├─ mappers/
│ │ │ ├─ AddressMapper.xml
│ │ │ ├─ AdminOrderMapper.xml
│ │ │ ├─ AdminRefundMapper.xml
│ │ │ ├─ AdminScheduleMapper.xml
│ │ │ ├─ BoardMapper.xml
│ │ │ ├─ BookMapper.xml
│ │ │ ├─ CartMapper.xml
│ │ │ ├─ CommentLoveMapper.xml
│ │ │ ├─ CommentMapper.xml
│ │ │ ├─ CommentRatingMapper.xml
│ │ │ ├─ ComplainMapper.xml
│ │ │ ├─ ECommentMapper.xml
│ │ │ ├─ GuestMapper.xml
│ │ │ ├─ MypageMapper.xml
│ │ │ ├─ OrderMapper.xml
│ │ │ ├─ PaymentMapper.xml
│ │ │ ├─ ProductApiMapper.xml
│ │ │ ├─ QCommentMapper.xml
│ │ │ ├─ RecommendBookMapper.xml
│ │ │ ├─ RefundMapper.xml
│ │ │ ├─ SalesMapper.xml
│ │ │ └─ UserMapper.xml
│ │ ├─ mybatis_config.xml
│ ├─ webapp/
│ │ ├─ META-INF/
│ │ │ └─ MANIFEST.MF
│ │ ├─ WEB-INF/
│ │ │ ├─ lib/
│ │ │ ├─ spring/
│ │ │ │ ├─ appServlet/
│ │ │ │ │ └─ servlet-context.xml
│ │ │ │ ├─ root-context.xml
│ │ │ │ └─ security/
│ │ │ │ └─ security-context.xml

```
--- 

## 📖명세서 API Reference
- [API Reference](../../wiki/API-Reference)

--- 

## 서비스화면


--- 

## 👤 Team Members (역할/깃계정)

| Name   | Role                | GitHub | Main Modules | One-liner | Detail |
|--------|---------------------|--------|--------------|-----------|--------|
| 김상화 | Full-stack Developer | [@gimsanghwa](https://github.com/kimsanghw) | 사용자 기능(목록/상세/장바구니/추천/소개), **관리자 기능(도서/추천/재고/주문·배송/환불/신고/매출/일정/회원)**, 대시보드/차트 | “사용자 경험부터 운영 도구까지 전 과정 구현” | **북틈 소개 페이지**: Kakao 지도 API(`dapi.kakao.com/v2/maps/sdk.js`)를 이용해 서점 위치 및 소개 페이지 구현 <br>- **도서 관리 (운영자)**: Naver Book API + Spring Scheduler 연동 → 최신 도서 검색·등록 및 DB 저장 후 사용자 페이지에서 활용 가능 <br>- **사용자 기능 (도서/장바구니)**: 도서 목록·상세 페이지 CRUD / 비로그인 사용자는 LocalStorage 기반 장바구니, 로그인 시 DB와 동기화 처리 <br>- **소셜 로그인/로그아웃**: Kakao 간편 로그인 API를 이용한 OAuth2 인증 처리, Spring Security 기반 권한 관리(ROLE_USER_KAKAO). 로그아웃은 `https://kapi.kakao.com/v1/user/logout` API와 세션/쿠키 동기화 처리 <br>- **결제/환불 시스템**: KakaoPay / Toss Payments API를 운영자 페이지에 연동, 환불 처리 시 PG사 API 호출과 동시에 ORDERS·PAYMENTS·REFUND DB 동기화. 관리자 환불 관리 페이지에서 실시간 처리 가능 <br>- **이벤트/일정 관리**: FullCalendar.js 기반 관리자 전용 일정/이벤트 관리 모듈 구축 <br>- **매출 분석/시각화**: Chart.js 기반 매출 차트(막대/원형) 구현 → 관리자 대시보드에서 일별 매출 시각화. Simple-DataTables와 결합하여 도서별 판매 현황·일별 매출을 직관적으로 파악 가능  |
| 송지은 | Full-stack Developer | [@SongJieunJinny](https://github.com/SongJieunJinny) | **회원/비회원 인증 및 주문/결제**, 게시판 시스템 | “전체적인 회원,비회원 사용자 작동 과정 구현” | - **[회원 인증 시스템 (Spring Security)]** 회원가입: BCryptPasswordEncoder를 이용한 비밀번호 단방향 암호화 적용, 로그인/권한: Spring Security를 통한 인증(Authentication) 및 인가(Authorization) 관리, ROLE_USER, ROLE_ADMIN에 따른 접근 제어 구현, 비밀번호 찾기: JavaMailSender와 Naver SMTP 서버를 연동하여, 이메일로 인증번호를 발송하고 검증하는 기능 구현.<br> - **[비회원 주문 시스템(보안 강화)]** 고유 주문키 발급: 비회원 주문 시 UUID를 기반으로 예측 불가능한 고유 주문키(ORDER_KEY)를 생성하여 DB에 저장, 안전한 주문 조회: 이메일과 비밀번호 대신, 고유 주문키와 주문자 이메일의 조합으로만 조회가 가능하도록 설계하여 개인정보 노출 및 데이터 조회 충돌 문제를 원천적으로 해결.<br> - **[게시판 시스템]** 3종 게시판 구현: 공지사항, Q&A, 이벤트 목적의 게시판 CRUD 기능 구현, 이벤트-상품 연동: 관리자가 이벤트 게시글 작성 시 AJAX 기반의 팝업창을 통해 등록된 상품(Book)을 검색하고 연동하는 CMS 기능 개발. |

---


# bookHiatus

## 📑 목차

- [프로젝트 진행기간](#프로젝트-진행기간)
- [프로젝트 개요](#프로젝트-개요)
- [주요기능](#주요기능)
- [아키텍처 및 기술 상세](#아키텍처-및-기술-상세) 
- [트러블슈팅](#트러블슈팅)
- [개발환경](#개발환경)
- [ERD](#erd)
- [프로젝트 파일 구조](#프로젝트-파일-구조)
- [명세서 API Reference](#명세서-api-reference)
- [서비스화면](#서비스화면)
- [팀원(역할/깃계정)](#팀원역할깃계정)

--- 

## 📌프로젝트 개요
### "BookHiatus": Spring Framework 기반의 온라인 독립서점 서비스
온라인 독립서점의 전체 상거래 흐름을 End-to-End로 설계하고 구현한 풀스택 웹 프로젝트입니다. 단순 기능 구현을 넘어, 안정적인 서비스 운영과 사용자 중심의 UX 설계를 목표로 개발을 진행했습니다.

### ✨ 핵심 특징 및 구현 내용 ✨
#### 1. E-Commerce 핵심 기능 완전 구현
 - **회원/비회원 시스템**: Spring Security를 통한 역할 기반(ROLE_USER, ROLE_ADMIN) 접근 제어를 구현했으며, 비회원은 UUID 기반의 고유 주문키를 발급하여 개인정보 노출 없이 안전하게 주문을 조회할 수 있도록 설계했습니다.
 - **장바구니 자동 동기화**: 사용자의 로그인 상태가 변경될 때, **Local Storage에 임시 저장된 장바구니와 DB의 장바구니 데이터를 자동으로 병합**하여 일관된 쇼핑 경험을 제공합니다.
#### 2. 안전한 결제 및 환불/취소 정책
 - **외부 API 연동**: KakaoPay, TossPayments API를 연동하여 실제와 동일한 결제 흐름을 구현했습니다.
 - **상태 기반 분기 처리**: 주문의 **배송 상태(orderStatus)를 기준**으로, 배송 시작 전에는 사용자가 직접 '주문 취소'를, 배송 시작 후에는 '환불 신청'을 하도록 로직을 분기하여 데이터의 정합성과 운영 안정성을 확보했습니다.
#### 3. 효율적인 운영을 위한 관리자 콘솔
 - **통합 CMS 및 운영 관리**: 도서(Naver API 연동)/재고/주문/환불/신고 등 서비스 운영에 필요한 모든 데이터를 관리하는 콘솔을 구축했습니다.
 - **데이터 시각화 대시보드**: Chart.js를 활용하여 일별/월별 매출 데이터를 시각화함으로써, 운영자가 서비스 현황을 직관적으로 파악하고 의사결정을 내릴 수 있도록 지원합니다.

--- 

## 📝주요기능

- 사용자 기능: 도서·조회/검색/주문/배송·취소/환불/게시판·CRUD/댓글 좋아요·별점기능등,
- 관리자 기능: 도서/추천/재고/주문·배송/환불/신고/매출/일정/회원 관리,
- 대시보드 및 통계 시각화 제공
- [상세](../../wiki/상세)
  
--- 

## 🛠️ 아키텍처 및 기술 상세
### 🏗️백엔드 아키텍처(Backend Architecture)
- **계층형 구조 (Layered Architecture)**: **Controller - Service - DAO - Mapper 구조**를 채택하여 각 계층의 역할을 명확히 분리하고 코드의 결합도를 낮췄습니다.
- **인증/인가 (Authentication & Authorization)**: Spring Security를 사용하여 **폼 기반 로그인**과 **소셜 로그인(Kakao)**을 통합 관리했습니다. ROLE_USER, ROLE_ADMIN 권한에 따라 URL 접근과 서비스 메서드 호출을 제어하여 보안을 강화했습니다.
- **데이터 영속성 (Persistence)**: MyBatis를 사용하여 SQL 문을 XML에 분리함으로써 코드와 쿼리의 유지보수성을 높였습니다. mybatis-config.xml에서 VO 별칭(typeAliases)을 설정하여 코드 가독성을 확보했습니다.
- **비동기 처리 (Asynchronous Task)**: Spring Scheduler를 이용해 **5분마다 도서 재고 상태를 자동으로 갱신**하는 백그라운드 작업을 구현했습니다.
- **공통 예외 처리**: @ControllerAdvice를 활용하여 프로젝트 전역에서 발생하는 예외를 한 곳에서 처리하고, 일관된 오류 응답을 반환하도록 설계했습니다.

### 🎨프론트엔드(Frontend)
- **뷰 템플릿**: JSP와 JSTL, Spring Security Taglib을 사용하여 동적인 웹 페이지를 렌더링했습니다.
- **비동기 통신**: jQuery Ajax를 프로젝트의 모든 CUD(생성, 수정, 삭제) 기능에 적용하여 **SPA(Single Page Application)와 유사한 사용자 경험**을 제공했습니다.
- **UI 라이브러리**: Bootstrap 5를 기본 레이아웃으로 사용하고, **simple-datatables**, **Chart.js**, **FullCalendar.js** 등의 라이브러리를 커스터마이징하여 관리자 페이지의 복잡한 UI를 효율적으로 구현했습니다.
- **모듈화 및 일관성**: 모든 페이지는 **header.jsp**, **footer.jsp** 등의 공통 레이아웃을 include하여 중복을 최소화했으며, contextPath 기반의 경로 설정으로 이식성을 높였습니다.

### 🌐외부 API 연동(External APIs)
- Naver Book API, KakaoPay, TossPayments, Daum Postcode 등 다양한 외부 API를 연동했습니다.
- **보안**: 모든 API Key와 Secret 값은 Git 저장소에 노출되지 않도록 **.properties 파일로 분리하여 관리**하고, .gitignore에 등록하여 보안을 확보했습니다.

### 📝개발 컨벤션(Conventions)
- **Git & GitHub**: main 브랜치를 중심으로 각자 기능별 브랜치에서 작업 후 Pull Request를 통해 코드 리뷰를 진행하는 **GitHub Flow** 전략을 사용했습니다.
- **커밋 메시지**: Type: Subject (예: Feat: 로그인 기능 추가, Fix: 장바구니 카운트 버그 수정) 형식으로 커밋 메시지를 통일하여 히스토리 가독성을 높였습니다.
- **코딩 스타일**: Google Java Style Guide를 기준으로 변수명(camelCase), 클래스명(PascalCase), 상수(SNAKE_CASE) 등의 네이밍 컨벤션을 준수했습니다.
- **API 설계**: 관리자 API는 **/admin/{도메인}/{액션}** 형식으로 URI를 통일했으며, Ajax 응답은 **{success: boolean, data: ...}** 구조로 통일하여 프론트엔드에서의 처리를 용이하게 했습니다.
  
--- 

## 🐞트러블슈팅

- [회원,비회원 결제로직 혼재문제](../../wiki/회원,비회원-결제로직-혼재문제)
- [비회원 주문키(orderKey) 관리 UX](../../wiki/비회원-주문키(orderKey)-관리-UX).
- [주문취소(Cancel) vs 환불(Refund) 흐름 모호성](../../wiki/주문취소(Cancel)-vs-환불(Refund)-흐름-모호성)
- [장바구니 안정화: 카운트 일원화 · 동기화 순서 보장 · 데이터 정규화 ](../../wiki/장바구니-안정화)
- [카카오 로그아웃 흐름의 꼬임과 잔여 세션/쿠키가 남음 문제](../../wiki/카카오-로그아웃-흐름의-꼬임과-잔여-세션-쿠키가-남음-문제)
  
--- 

## 💻개발환경
### Backend
- JDK 1.8 / JAVA 8
- Spring Framework 4.3.3.RELEASE
- Spring Security 3.2.10.RELEASE
- MyBatis 3.4.1

### Frontend
- HTML5 / CSS3 / JavaScript
- JSP 4 / Ajax
- jQuery

### Database & Server
- MySQL 8.0
- Apache Tomcat 9.0
 
### Tools & Collaboration
- Spring Tool Suite 4 (STS)
- Visual Studio Code
- MySQL Workbench 8.0
- ERMaster
- Git & GitHub
- Notion
  
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

## 📽️서비스화면
-장바구니 담기/삭제 흐름
![장바구니 데모](./images/cartMove.gif)

-회원 주문 흐름
![회원 주문 데모](./images/User_payGIF.gif)

-회원 환불확인 흐름
![회원 환불확인 데모](./images/User_refund.gif)

-회원 주문취소 흐름
![회원 주문취소 데모](./images/tosspay_cancle.gif)

-비회원 주문취소/환불 흐름
![비회원 주문취소 데모](./images/Guest_refundGIF.gif)

-관리자 주문배송 관리 흐름
![관리자 주문배송 관리  데모](./images/adminOrderS_optimized.gif)

-관리자 환불/댓글신고 관리 흐름
<video src="https://github.com/SongJieunJinny/bookHiatus/raw/main/images/output.mp4" autoplay loop muted playsinline width="600"></video>


--- 

## 👤 Team Members (역할/깃계정)

| Name   | Role                | GitHub | Main Modules | One-liner | Detail |
|--------|---------------------|--------|--------------|-----------|--------|
| 김상화 | Full-stack Developer | [@gimsanghwa](https://github.com/kimsanghw) | 사용자 기능(목록/상세/장바구니/추천/소개), **관리자 기능(도서/추천/재고/주문·배송/환불/신고/매출/일정/회원)**, 대시보드/차트 | “사용자 경험부터 운영 도구까지 전 과정 구현” | **북틈 소개 페이지**: Kakao 지도 API(`dapi.kakao.com/v2/maps/sdk.js`)를 이용해 서점 위치 및 소개 페이지 구현 <br>- **도서 관리 (운영자)**: Naver Book API + Spring Scheduler 연동 → 최신 도서 검색·등록 및 DB 저장 후 사용자 페이지에서 활용 가능 <br>- **사용자 기능 (도서/장바구니)**: 도서 목록·상세 페이지 CRUD / 비로그인 사용자는 LocalStorage 기반 장바구니, 로그인 시 DB와 동기화 처리 <br>- **소셜 로그인/로그아웃**: Kakao 간편 로그인 API를 이용한 OAuth2 인증 처리, Spring Security 기반 권한 관리(ROLE_USER_KAKAO). 로그아웃은 `https://kapi.kakao.com/v1/user/logout` API와 세션/쿠키 동기화 처리 <br>- **결제/환불 시스템**: KakaoPay / Toss Payments API를 운영자 페이지에 연동, 환불 처리 시 PG사 API 호출과 동시에 ORDERS·PAYMENTS·REFUND DB 동기화. 관리자 환불 관리 페이지에서 실시간 처리 가능 <br>- **이벤트/일정 관리**: FullCalendar.js 기반 관리자 전용 일정/이벤트 관리 모듈 구축 <br>- **매출 분석/시각화**: Chart.js 기반 매출 차트(막대/원형) 구현 → 관리자 대시보드에서 일별 매출 시각화. Simple-DataTables와 결합하여 도서별 판매 현황·일별 매출을 직관적으로 파악 가능  |
| 송지은 | Full-stack Developer | [@SongJieunJinny](https://github.com/SongJieunJinny) | **회원/비회원 인증 및 주문내역및확인/결제/취소·환불**, 게시판(공지/EVENT/Q&A)CRUD 및 댓글좋아요/별점기능 시스템 | “신뢰도 높은 서비스의 기반이 되는 회원/비회원 시스템과 커뮤니티 기능을 설계하고 구현” | **[회원 인증 시스템]** **-가입/로그인:** 회원가입 시 `Daum Postcode API`를 연동하여 주소 입력 편의성 향상/ `BCryptPasswordEncoder`로 비밀번호 암호화. 또한 `Spring Security`의 인증 및 권한부여 프로세스를 기반으로 `ROLE_USER`/`ROLE_ADMIN` 권한별 접근 제어 구현. **-비밀번호 찾기:** `JavaMailSender`와 Naver SMTP 서버를 연동하여, 이메일로 발송된 인증번호를 검증하는 방식으로 보안성이 강한 비밀번호 재설정 기능을 개발.<br> **[비회원 주문 시스템]** **-고유 주문키 발급:** 비회원 주문 시 `UUID`를 기반으로 예측 불가능한 고유 주문키(ORDER_KEY)를 생성하여, URL 추측을 통한 무단 주문 조회를 원천적으로 차단. **-안전한 주문 조회:** 이메일과 주문 비밀번호 대신, 고유 주문키와 주문자 이메일의 조합으로만 조회가 가능하도록 설계 → 개인정보 노출 및 데이터 조회 충돌 문제 해결.<br> **[주문 관리 및 취소/환불 플로우]** **-주문내역/상세조회:** 회원은 마이페이지에서, 비회원은 주문키 기반으로 자신의 주문 목록과 상세 내역, 배송 상태를 추적할 수 있도록 구현. **-상태 기반 분기 처리:** `주문 상태(orderStatus)`를 기준으로, '배송준비중'일 때는 '주문 취소' 요청, '배송중' 이후에는 '환불 신청' 요청으로 UI와 백엔드 로직을 분리해 데이터의 정합성 확보.<br> **[결제 시스템]** **-API 명세 기반 구현:** `KakaoPay`와 `TossPayments`의 테스트 API를 분석하여, 결제 준비(Ready) 및 최종 승인(Confirm)에 필요한 모든 파라미터와 HTTP 요청/응답 규격을 구현. **-UI/UX 흐름 설계:** 사용자가 결제 수단을 선택하면 해당 PG사(결제 대행사)의 결제창으로 리다이렉트되고, 결제 완료 후 성공/실패/취소 여부에 따라 지정된 콜백(Callback) URL로 돌아와 사용자에게 명확한 결과를 보여주는 전체 프론트엔드 흐름을 개발 진행. **-데이터 동기화:** 테스트 결제 승인이 완료되는 즉시, `PAYMENTS` 테이블에 결제 정보를 기록하고 `ORDERS` 테이블의 상태를 업데이트하여, 실제 결제와 동일한 방식의 데이터 처리 로직을 구현.<br> **[게시판 & 리뷰 시스템]** **-게시판 3종 (CRUD):** 공지, Q&A, EVENT 목적의 게시판 3종에 대한 전체 CRUD 기능을 구현. **-댓글리뷰/상호작용:** 사용자가 등록된 상품(Book)에 대해 `좋아요`를 누르거나, `별점`을 남기고, 상품에 대한 리뷰를 하며 서로 `사용자간 상호작용 기능 기대`. **-이벤트-상품 연동:** 관리자가 EVENT 게시글 작성 시, `Ajax` 기반의 팝업창을 통해 등록된 상품(Book)을 검색해 게시글에 동적으로 연동하는 CMS(콘텐츠 관리 시스템) 기능을 구현.|

---


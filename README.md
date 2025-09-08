# bookHiatus

## 📑 목차

- [프로젝트 진행기간](#프로젝트-진행기간)
- [개요](#개요)
- [주요기능](#주요기능)
- [트러블슈팅](#트러블슈팅)
- [기술스택](#기술스택)
- [ERD](#erd)
- [프로젝트 파일 구조](#프로젝트-파일-구조)
- [명세서 API Reference](#명세서-api-reference)
- [서비스화면](#서비스화면)
- [팀원(역할/깃계정)](#팀원역할깃계정)


--- 
## ERD

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
## 프로젝트 파일 구조


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

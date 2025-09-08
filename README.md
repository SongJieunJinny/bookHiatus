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

## 개요
- Spring Framework와 MyBatis를 기반으로, 네이버 도서 API와 연동하여 상품 DB를 자동으로 구축한 온라인 도서 쇼핑몰입니다.
- Toss 및 Kakao페이 API를 연동하여 회원과 비회원 모두를 위한 실시간 결제와 환불 시스템을 구현했습니다.
- 또한, 관리자가 등록된 상품과 연관된 이벤트 게시글을 손쉽게 생성할 수 있는 사용자 친화적인 콘텐츠 관리(CMS) 기능을 제공합니다.
  
--- 
## 주요기능

- 사용자 기능: 도서 목록/상세, 리뷰, 장바구니·주문
- 관리자 기능: 도서/추천/재고/주문·배송/환불/신고/매출/일정/회원 관리
- 대시보드 및 통계 시각화 제공
- [상세](../../wiki/상세)
  
--- 

## 기술 및 컨벤션
- **사용자 영역(User-facing)**: JSP, JSTL(`c:`), Spring Security Tags(`sec:`), jQuery(Ajax)
- **관리자 영역(Admin)**: **Bootstrap 5 기반 관리자 레이아웃** + jQuery + simple-datatables + Chart.js + FullCalendar
- **공통 레이아웃**: `adminHeader.jsp`, `adminNav.jsp`, `adminFooter.jsp`
- **외부 연동**: Naver Book 검색 API(도서 등록 자동화), Toss/KakaoPay 결제취소 API(환불 처리)
- **UX 강화**: 데이터 검증(송장 영숫자, 배송상태 전이 조건), 금액·날짜 포맷(`toLocaleString`, `Date.toLocaleString("ko-KR")`), 반응형 테이블, 차트 시각화
  
--- 
## 트러블슈팅

# 트러블슈팅 심화 정리
다음 3가지는 이번 장바구니 페이지의 핵심 안정화 포인트입니다.

- **A. `updateCartCount()`는 한 곳에서만 정의/사용**
- **B. 로그인 시 `동기화 → 서버재조회 → 렌더 → 카운트` 순서 보장**
- **C. `normalizeCartItems`의 죽은 코드 제거**

---

## A) `updateCartCount()`는 한 곳에서만 정의/사용

### 문제 배경
- 페이지/헤더/별도 스크립트에 **중복 정의**되거나, 담기/삭제 시 **제각각 직접 갱신**하면서
  헤더 `#cart-count`와 본문 타이틀(예: `#cartCountTitle`) 숫자가 **엇갈림**.
- 헤더와 본문에 **ID 중복**(`cart-count`)이 있으면 또 어긋남.

### ✅ 해결 원칙
- **하나의 함수**에서 로그인/비로그인 **분기 포함**해 **표시 요소 2곳**(헤더·본문)을 동시에 갱신.
- **호출 지점 표준화**: 초기 진입 / 렌더 직후 / 추가·삭제·수량 변경 직후 / 동기화 완료 직후.
- **ID 중복 금지**: 헤더는 `#cart-count`만, 본문은 `#cartCountTitle`(또는 하나로 통일)만.

### ⛔ Before (흩어진 갱신)
```js
// 1) 어떤 곳은 로컬 길이로
$("#cart-count").text((JSON.parse(localStorage.getItem("cartItems"))||[]).length);

// 2) 어떤 곳은 서버 카운트로
$.get(contextPath + "/product/getCartCount.do", function (count) {
  $("#cart-count").text(parseInt(count,10)||0);
});

// 3) 담기/삭제 핸들러에서 각자 직접 텍스트 변경(호출 누락/중복 발생)

```

### ✅ After (단일 함수 + 표준 호출)
```js
function updateCartCount() {
  const elHeader = document.getElementById("cart-count");     // 헤더
  const elTitle  = document.getElementById("cartCountTitle"); // 본문
  if (!elHeader && !elTitle) return;

  if (typeof isLoggedIn !== "undefined" && isLoggedIn) {
    $.get(contextPath + "/product/getCartCount.do", function(count) {
      const n = parseInt(count, 10) || 0;
      if (elHeader) {
        elHeader.textContent = n;
        elHeader.style.visibility = n > 0 ? "visible" : "hidden";
      }
      if (elTitle) elTitle.textContent = "장바구니(" + n + ")";
    }).fail(function(err){
      console.error("장바구니 개수 불러오기 실패", err);
    });
  } else {
    let items = JSON.parse(localStorage.getItem("cartItems")) || [];
    if (!Array.isArray(items)) items = Object.values(items).filter(o => typeof o === 'object');
    const n = items.length;
    if (elHeader) {
      elHeader.textContent = n;
      elHeader.style.visibility = n > 0 ? "visible" : "hidden";
    }
    if (elTitle) elTitle.textContent = "장바구니(" + n + ")";
  }
}

// 표준 호출 지점
$(document).ready(function(){
  updateCartCount();         // 초기
});
renderCartItems(); updateCartCount(); // 렌더 직후
// 담기/삭제/수량 변경/동기화 완료 직후에도 동일 함수 호출
체크리스트
 updateCartCount()는 한 곳에서만 정의/사용.
 헤더: #cart-count 1개, 본문: #cartCountTitle 1개(중복/혼용 금지).
 렌더·삭제·수량 변경·동기화 완료 후마다 updateCartCount() 호출.
 B) 로그인 시 동기화 → 서버재조회 → 렌더 → 카운트 순서 보장
문제 배경
로그인 직후 로컬→서버 동기화가 끝나기 전에 렌더/카운트를 먼저 실행 → 값이 깜빡이거나 뒤늦게 변경.
핵심 해결 원칙
반드시 아래 순서 고정:
syncLocalCartToDB()
fetchAndUpdateCart() (서버 최신 데이터 재조회)
renderCartItems()
updateCartCount() / updateCartMessage()
```
### 체크리스트
- updateCartCount()는 한 곳에서만 정의/사용(공통 스크립트).
- 헤더 #cart-count 1개, 본문 #cartCountTitle 1개(중복/혼용 금지).
- 렌더·삭제·수량 변경·동기화 완료 후마다 updateCartCount() 호출.

## B) 로그인 시 동기화 → 서버재조회 → 렌더 → 카운트 순서 보장
### 문제 배경
- 로그인 직후 로컬→서버 동기화가 끝나기 전에 렌더/카운트를 먼저 실행 → 값이 깜빡이거나 뒤늦게 변경.

### 핵심 해결 원칙
- syncLocalCartToDB()
- fetchAndUpdateCart() (서버 최신 데이터 재조회)
- renderCartItems()
- updateCartCount() / updateCartMessage()

###  ⛔ Before (순서 뒤섞임)
```js
$(document).ready(function () {
  renderCartItems();
  updateCartCount();
  if (isLoggedIn) {
    syncLocalCartToDB();      // 나중에 동기화 → 값이 뒤늦게 바뀜
    fetchAndUpdateCart();
  }
});
```
### ✅ After (체이닝으로 순서 보장)
```js
$(document).ready(function () {
  if (isLoggedIn) {
    $.when(syncLocalCartToDB())                    // 1) 로컬 → 서버 동기화
      .always(function () {
        return $.get(contextPath + "/product/getCartByUser.do"); // 2) 서버 최신 데이터 조회
      })
      .done(function (data) {
        dbCartItems = Array.isArray(data) ? data : [];
        renderCartItems();                         // 3) 렌더
      })
      .always(function () {
        updateCartCount();                         // 4) 카운트/메시지
        updateCartMessage();
      });
  } else {
    renderCartItems();
    updateCartCount();
    updateCartMessage();
  }
});
```

### C) normalizeCartItems 죽은 코드 제거
### 문제 배경
- return 이후에 LocalStorage 재파싱 블록이 남아 있어, 실제로는 절대 실행되지 않는 죽은 코드가 포함.
- 가독성/유지보수성 저하 및 오해 유발.
### Before (조기 return 아래 죽은 코드)
```js
function normalizeCartItems(items) {
    const merged = {};
    items.forEach(item => {
        const key = item.bookNo || item.isbn || item.id;
        const quantity = Number(item.quantity || item.count || 1);

        if (quantity < 1) return; // 0개는 렌더링 안 함

        if (!merged[key]) {
            merged[key] = { ...item, quantity: quantity };
        } else {
            merged[key].quantity += quantity;
        }
    });
    return Object.values(merged);
    
  const raw = localStorage.getItem("cartItems");
  let cartItems = [];
  try {
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) {
      cartItems = parsed;
    } else if (typeof parsed === 'object' && parsed !== null) {
      cartItems = Object.values(parsed).filter(item => typeof item === 'object');
    }
  } catch (e) {
     console.error("localStorage 파싱 오류", e);
  }
  return cartItems;

}
```
### After (합산 로직만 유지)
```js
function normalizeCartItems(items) {
  const merged = {};
  items.forEach(item => {
    const key = item.bookNo || item.isbn || item.id;
    const quantity = Number(item.quantity || item.count || 1);
    if (!key || quantity < 1) return;      // 키 없거나 0 이하는 스킵
    if (!merged[key]) merged[key] = { ...item, quantity };
    else merged[key].quantity += quantity; // 중복 항목 수량 합산
  });
  return Object.values(merged);
}
```
--- 

## 개발환경

- JDK 1.8, MySQL 8.0, TOMCAT 9.0, SPRING FRAMEWORK 4.3.3.RELEASE, SPRING SECURITY 3.2.10.RELEASE, MyBatis 3.4.1
- JAVA8, HTML5, CSS3, JSP4, JavaScript, jQuery, Ajax
- SpringToolSuite 4, Visual Studio Code, ERMaster, MySQL (Workbench 8.0),GitHub, Notion
  
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

## 👤 Team Members (역할/깃계정)

| Name   | Role                | GitHub | Main Modules | One-liner | Detail |
|--------|---------------------|--------|--------------|-----------|--------|
| 김상화 | Full-stack Developer | [@gimsanghwa](https://github.com/kimsanghw) | 사용자 기능(목록/상세/장바구니/추천/소개), **관리자 기능(도서/추천/재고/주문·배송/환불/신고/매출/일정/회원)**, 대시보드/차트 | “사용자 경험부터 운영 도구까지 전 과정 구현” | - **Front-end**: JSP + jQuery, Bootstrap 기반 UI/UX 개발<br>- **Back-end**: Spring MVC + MyBatis + MySQL, API 연동(Naver Book, Kakao, TossPay)<br>- **운영자 기능**: 환불·신고 처리 자동화, 재고/주문 관리, 매출 차트 시각화<br>- **보안/인증**: Spring Security 적용(로그인/접근 제어), Kakao 소셜 로그인 |
| 송지은## Config / Meta (Settings, Build, Mapper & Spring Config)

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

## 👤 Team Members (역할/깃계정)

| Name   | Role                | GitHub | Main Modules | One-liner | Detail |
|--------|---------------------|--------|--------------|-----------|--------|
| 김상화 | Full-stack Developer | [@gimsanghwa](https://github.com/kimsanghw) | 사용자 기능(목록/상세/장바구니/추천/소개), **관리자 기능(도서/추천/재고/주문·배송/환불/신고/매출/일정/회원)**, 대시보드/차트 | “사용자 경험부터 운영 도구까지 전 과정 구현” | - **Front-end**: JSP + jQuery, Bootstrap 기반 UI/UX 개발<br>- **Back-end**: Spring MVC + MyBatis + MySQL, API 연동(Naver Book, Kakao, TossPay)<br>- **운영자 기능**: 환불·신고 처리 자동화, 재고/주문 관리, 매출 차트 시각화<br>- **보안/인증**: Spring Security 적용(로그인/접근 제어), Kakao 소셜 로그인 |
| 송지은 | Full-stack Developer | [@SongJieunJinny](https://github.com/SongJieunJinny) | 게시판(공지사항, Q&A, 이벤트) 개설 및 검색 기능 등, **회원 기능: 회원가입 /Spring Security 기반 로그인 /마이페이지(주문 내역, 정보 수정) /Naver Mail API 연동 비밀번호 찾기**, **비회원 기능: 고유 주문키(UUID)를 발급하여 조회하는 안전한 비회원 주문/조회 시스템**, 공통 기능: 회원/비회원 Toss Payments, Kakao Pay API 연동 결제 및 환불 처리 | “전체적인 회원,비회원 사용자 작동 과정 구현” | - **Front-end**: JSP + jQuery, Bootstrap 기반 UI/UX 개발<br>- **Back-end**: Spring MVC + MyBatis + MySQL, API 연동(Naver Mail (SMTP), Kakao, TossPay)<br>- **회원 기능 상세**: Spring Security를 통한 인증/인가 관리 및 BCrypt를 이용한 비밀번호 암호화 처리, 회원별 주문 목록 조회 및 페이징, 상품별 주문 및 배송상태 확인 기능 구현 <br>- **비회원 기능 상세**: 주문 시 UUID 기반의 고유 주문키를 발급하고, 결제 완료 페이지에서 사용자에게 명확히 안내, 조회 시 이메일/비밀번호 대신 주문키를 기본 식별자로 사용하여 개인정보 노출 및 데이터 충돌 문제 해결 |




---


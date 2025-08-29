package com.bookGap.service;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.bookGap.dao.OrderDAO;
import com.bookGap.dao.PaymentDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.GuestVO;
import com.bookGap.vo.KakaoPayCancelVO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossCancelVO;
import com.bookGap.vo.TossRequestVO;
import com.bookGap.vo.UserAddressVO;

@Service
public class PaymentServiceImpl implements PaymentService{

  @Autowired private PaymentDAO paymentDAO;
  @Autowired private OrderDAO orderDAO;
  @Autowired private GuestService guestService;
  @Autowired private RestTemplate restTemplate;
  
  private static final String TOSS_API_HOST = "https://api.tosspayments.com";
  private static final String TOSS_SECRET_KEY = "test_sk_6BYq7GWPVv97k2edaZ6n3NE5vbo1";

  @Override
  public void insertPayment(PaymentVO paymentVO) {
    paymentDAO.insertPayment(paymentVO);
  }

  @Override
  public void updatePaymentStatus(int paymentNo, int status) {
    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("paymentNo", paymentNo);
    paramMap.put("status", status);
    paymentDAO.updatePaymentStatus(paramMap);
  }

  //카카오페이
  @Override
  public void insertKakaoRequest(KakaoPayRequestVO kakaoPayRequestVO) {
    paymentDAO.insertKakaoRequest(kakaoPayRequestVO);
  }

  @Override
  public void updateKakaoTid(KakaoPayRequestVO kakaoPayRequestVO) {
    paymentDAO.updateKakaoTid(kakaoPayRequestVO);
  }

  @Override
  public KakaoPayRequestVO findKakaoRequestByPaymentNo(int paymentNo) {
    return paymentDAO.findKakaoRequestByPaymentNo(paymentNo);
  }

  @Override
  public void insertKakaoCancel(KakaoPayCancelVO kakaoPayCancelVO) {
    paymentDAO.insertKakaoCancel(kakaoPayCancelVO);
  }

  //토스페이
  @Override
  public void insertTossRequest(TossRequestVO tossRequestVO) {
    paymentDAO.insertTossRequest(tossRequestVO);
  }

  @Override
  public void updateTossPaymentKey(TossRequestVO tossRequestVO) {
    paymentDAO.updateTossPaymentKey(tossRequestVO);
  }

  @Override
  public TossRequestVO findTossRequestByPaymentNo(int paymentNo) {
    return paymentDAO.findTossRequestByPaymentNo(paymentNo);
  }

  @Override
  public void insertTossCancel(TossCancelVO tossCancelVO) {
    paymentDAO.insertTossCancel(tossCancelVO);
  }
  
  @Override
  public PaymentVO getPaymentByNo(int paymentNo) {
      return paymentDAO.getPaymentByNo(paymentNo);
  }
  
  @Override
  public PaymentVO selectPaymentByRefundNo(int refundNo) {
      return paymentDAO.selectPaymentByRefundNo(refundNo);
  }

  @Override
  public KakaoPayRequestVO selectKakaoRequest(int paymentNo) {
      return paymentDAO.selectKakaoRequest(paymentNo);
  }

  @Override
  @Transactional
  public Map<String, Object> prepareAndCreateTossOrder(Map<String, Object> orderData, Principal principal, HttpServletRequest request) throws Exception {
    
    OrderVO newOrder = new OrderVO();
    String customerKey;
    String customerName;

    // --- 1. 주문자/배송지 정보 설정 ---
    if (principal != null) { // 회원일 경우
      String userId = principal.getName();
      customerKey = userId;
      Integer userAddressId = (Integer) orderData.get("userAddressId");
      UserAddressVO address = orderDAO.findAddressByUserAddressId(userAddressId);
      if (address == null || !address.getUserId().equals(userId)) {
          throw new Exception("유효하지 않거나 소유권이 없는 배송지입니다.");
      }
      newOrder.setUserId(userId);
      newOrder.setOrderType(1);
      newOrder.setUserAddressId(userAddressId);
      customerName = address.getUserName();
      newOrder.setReceiverName(address.getUserName());
      newOrder.setReceiverPhone(address.getUserPhone());
      newOrder.setReceiverPostCode(address.getPostCode());
      newOrder.setReceiverRoadAddress(address.getRoadAddress());
      newOrder.setReceiverDetailAddress(address.getDetailAddress());
    } else { // 비회원일 경우
      String guestEmail = (String) orderData.get("guestEmail");
      GuestVO guest = guestService.getGuestByEmail(guestEmail);
      String guestId;
      if (guest == null) {
        guest = new GuestVO();
        guestId = "G-" + System.currentTimeMillis();
        guest.setGuestId(guestId);
        guest.setGuestName((String) orderData.get("guestName"));
        guest.setGuestPhone((String) orderData.get("guestPhone"));
        guest.setGuestEmail(guestEmail);
        guestService.registerGuest(guest);
        } else {
          guestId = guest.getGuestId();
        }
      customerKey = guestId;
      customerName = (String) orderData.get("guestName");
      newOrder.setOrderType(2);
      newOrder.setGuestId(guestId);
      newOrder.setOrderPassword((String) orderData.get("orderPassword"));
      newOrder.setReceiverName((String) orderData.get("receiverName"));
      newOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
      newOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
      newOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
      newOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    }
    newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    newOrder.setOrderStatus(1);
    
    // --- 2. 가격 계산 및 검증 (이제 회원/비회원 모두 동일하게 처리) ---
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");
    List<String> isbnList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      isbnList.add((String) item.get("isbn"));
    }
    List<BookVO> booksInDb = orderDAO.selectBooksByIsbnList(isbnList);

    int serverCalculatedTotalPrice = 0;
    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      int quantity = (Integer) item.get("quantity");
      BookVO book = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn)).findFirst().orElseThrow(() -> new Exception("DB에 없는 상품 주문 시도: " + isbn));
      serverCalculatedTotalPrice += book.getProductInfo().getDiscount() * quantity;
    }
    serverCalculatedTotalPrice += (serverCalculatedTotalPrice >= 50000 ? 0 : 3000);

    if (serverCalculatedTotalPrice != (Integer) orderData.get("totalPrice")) {
      throw new Exception("가격 정보가 일치하지 않습니다.");
    }
    newOrder.setTotalPrice(serverCalculatedTotalPrice);

    // --- 3. 주문(ORDERS) 정보 DB 저장 ---
    orderDAO.insertOrder(newOrder);
    int orderId = newOrder.getOrderId();

    // --- 4. ★ (핵심!) 주문 상세(ORDER_DETAIL) 정보 저장 및 재고 업데이트 ★ ---
    List<OrderDetailVO> detailList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      int quantity = (Integer) item.get("quantity");
      BookVO currentBook = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn)).findFirst().get();

      if (!orderDAO.updateBookStock(isbn, quantity)) {
        throw new Exception("재고가 부족합니다: " + currentBook.getProductInfo().getTitle());
      }
      
      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(orderId);
      d.setBookNo(currentBook.getBookNo());
      d.setOrderCount(quantity);
      d.setOrderPrice(currentBook.getProductInfo().getDiscount());
      d.setRefundCheck(0);
      detailList.add(d);
    }
    if (!detailList.isEmpty()) {
      orderDAO.insertOrderDetailList(detailList);
    }

    // --- 5. 결제 대기(PAYMENTS) 정보 DB 저장 ---
    PaymentVO payment = new PaymentVO();
    payment.setOrderId(orderId);
    payment.setAmount(new BigDecimal(newOrder.getTotalPrice()));
    payment.setStatus(1);
    payment.setPaymentMethod(1);
    if (principal != null) payment.setUserId(principal.getName());
    else payment.setGuestId(customerKey);
    paymentDAO.insertPayment(payment);
    int paymentNo = payment.getPaymentNo();

    // --- 6. 프론트엔드 응답 생성 ---
    Map<String, Object> response = new HashMap<>();
    response.put("status", "SUCCESS");
    response.put("paymentNo", paymentNo);
    response.put("customerKey", customerKey);
    response.put("customerName", customerName);
    response.put("amount", newOrder.getTotalPrice());
    response.put("orderName", (String) orderData.get("orderName"));

    return response;
  }

  @Override
  @Transactional
  public PaymentVO confirmTossPayment(String paymentKey, String tossOrderId, Long amount) throws Exception {
  
    int paymentNo = Integer.parseInt(tossOrderId.split("_")[1]);
    PaymentVO payment = paymentDAO.getPaymentByNo(paymentNo);

    if (payment.getAmount().compareTo(new BigDecimal(amount)) != 0) {
      System.err.println("### 금액 불일치! DB: " + payment.getAmount() + ", 토스: " + amount);
      throw new Exception("결제 금액이 위조되었습니다. 관리자에게 문의하세요.");
    }

    // 1. HTTP 요청 헤더를 만듭니다. (인증 정보 포함)
    HttpHeaders headers = new HttpHeaders();
    String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
    headers.set("Authorization", "Basic " + encodedAuth);
    headers.setContentType(MediaType.APPLICATION_JSON);

    // 2. HTTP 요청 본문(body)을 만듭니다. (토스가 요구하는 정보)
    Map<String, Object> params = new HashMap<>();
    params.put("paymentKey", paymentKey);
    params.put("orderId", tossOrderId);
    params.put("amount", amount);

    // 3. 헤더와 본문을 합쳐서 HTTP 요청 객체를 생성합니다.
    HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);

    // 4. RestTemplate을 사용해 토스 서버에 POST 요청을 보내고, 그 응답(ResponseEntity)을 받습니다.
    ResponseEntity<String> response = restTemplate.postForEntity(
      TOSS_API_HOST + "/v1/payments/confirm", // 요청 보낼 주소
      requestEntity,                         // 보낼 데이터 (헤더 + 본문)
      String.class                           // 응답은 문자열(JSON) 형태로 받음
    );

    if(response.getStatusCode().is2xxSuccessful()){
      // 승인 성공 시, DB 상태를 '결제 완료'로 변경
      Map<String, Object> updateParams = new HashMap<>();
      updateParams.put("paymentNo", paymentNo);
      updateParams.put("status", 2); // 2: 결제승인
      paymentDAO.updatePaymentStatus(updateParams);
    
      // TOSS_REQUESTS 테이블에 최종 paymentKey 저장
      TossRequestVO tossRequest = new TossRequestVO();
      tossRequest.setPaymentNo(paymentNo);
      tossRequest.setPaymentKey(paymentKey);
      paymentDAO.updateTossPaymentKey(tossRequest);

      return payment;
    }else{
      throw new Exception("토스 결제 최종 승인에 실패했습니다. 응답 코드: " + response.getStatusCode());
    }
  }

}
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
  public Map<String, Object> prepareAndCreateTossOrder(Map<String, Object> orderData,
                                                       Principal principal,
                                                       HttpServletRequest request) throws Exception {
    Map<String,Object> resp = new HashMap<>();
    OrderVO newOrder = null;

    String customerKey, customerName;
    Integer orderId = (Integer) orderData.get("orderId");

    String baseUrl = request.getScheme() + "://" + request.getServerName()
        + ((request.getServerPort()==80||request.getServerPort()==443)?"":":"+request.getServerPort())
        + request.getContextPath();
    String successUrl = baseUrl + "/payment/success";
    String failUrl    = baseUrl + "/payment/fail";

    if (orderId == null) {
      if (principal != null) throw new Exception("회원 주문 생성 오류: orderId 누락");

      // 게스트 식별
      String guestEmail = (String) orderData.get("guestEmail");
      String guestNameIn = (String) orderData.get("guestName");
      String guestPhoneIn = (String) orderData.get("guestPhone");
      if (guestEmail==null||guestNameIn==null||guestPhoneIn==null) throw new Exception("비회원 필수 정보 누락");

      GuestVO guest = guestService.getGuestByEmail(guestEmail);
      String guestId;
      if (guest == null) {
        guestId = "G-" + System.currentTimeMillis();
        guest = new GuestVO();
        guest.setGuestId(guestId);
        guest.setGuestName(guestNameIn);
        guest.setGuestPhone(guestPhoneIn);
        guest.setGuestEmail(guestEmail);
        guestService.registerGuest(guest);
      } else guestId = guest.getGuestId();
      customerKey = guestId; customerName = guestNameIn;

      // 금액 검증
      @SuppressWarnings("unchecked")
      List<Map<String,Object>> items = (List<Map<String,Object>>) orderData.get("orderItems");
      if (items==null || items.isEmpty()) throw new Exception("주문 상품 없음");

      List<String> isbnList = new ArrayList<>();
      for (Map<String,Object> it : items) isbnList.add((String) it.get("isbn"));
      List<BookVO> books = orderDAO.selectBooksByIsbnList(isbnList);

      int total = 0;
      for (Map<String,Object> it : items) {
        String isbn = (String) it.get("isbn");
        int qty = ((Number)it.get("quantity")).intValue();
        BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst()
                .orElseThrow(() -> new Exception("DB에 없는 상품: " + isbn));
        total += b.getProductInfo().getDiscount() * qty;
      }
      total += (total >= 50000 ? 0 : 3000);
      int clientTotal = ((Number)orderData.get("totalPrice")).intValue();
      if (total != clientTotal) throw new Exception("가격 정보 불일치");

      // 주문 저장 (ORDER_KEY 필수)
      newOrder = new OrderVO();
      newOrder.setOrderType(2);
      newOrder.setGuestId(customerKey);
      newOrder.setOrderPassword((String) orderData.get("orderPassword"));
      newOrder.setReceiverName((String) orderData.get("receiverName"));
      newOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
      newOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
      newOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
      newOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
      newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
      newOrder.setOrderStatus(1);
      newOrder.setTotalPrice(total);
      newOrder.setOrderKey("ODR_" + java.util.UUID.randomUUID().toString().replace("-", ""));
      orderDAO.insertOrder(newOrder);
      orderId = newOrder.getOrderId();

      // 상세 + 재고
      List<OrderDetailVO> ds = new ArrayList<>();
      for (Map<String,Object> it : items) {
        String isbn = (String) it.get("isbn");
        int qty = ((Number)it.get("quantity")).intValue();
        BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst().get();
        if (!orderDAO.updateBookStock(isbn, qty)) throw new Exception("재고 부족: " + b.getProductInfo().getTitle());
        OrderDetailVO d = new OrderDetailVO();
        d.setOrderId(orderId); d.setBookNo(b.getBookNo()); d.setOrderCount(qty);
        d.setOrderPrice(b.getProductInfo().getDiscount()); d.setRefundCheck(0);
        ds.add(d);
      }
      if (!ds.isEmpty()) orderDAO.insertOrderDetailList(ds);

    } else {
      customerKey = (principal != null) ? principal.getName() : "UNKNOWN";
      customerName = (String) orderData.getOrDefault("customerName", "고객");
    }

    int finalTotal = (newOrder != null) ? newOrder.getTotalPrice()
                                        : orderDAO.getOrderById(orderId).getTotalPrice();

    PaymentVO p = new PaymentVO();
    p.setOrderId(orderId);
    p.setAmount(new java.math.BigDecimal(finalTotal));
    p.setStatus(1);
    p.setPaymentMethod(1);
    if (principal != null) p.setUserId(principal.getName()); else p.setGuestId(customerKey);
    paymentDAO.insertPayment(p);

    int paymentNo = p.getPaymentNo();
    String unifiedOrderId = "BG_" + paymentNo;

    TossRequestVO tr = new TossRequestVO();
    tr.setPaymentNo(paymentNo);
    tr.setCustomerKey(customerKey);
    tr.setOrderName((String) orderData.get("orderName"));
    tr.setSuccessUrl(baseUrl + "/payment/success");
    tr.setFailUrl(baseUrl + "/payment/fail");
    tr.setOrderId(unifiedOrderId);
    tr.setAmount(finalTotal);
    paymentDAO.insertTossRequest(tr);

    Map<String,Object> out = new HashMap<>();
    out.put("status","SUCCESS");
    out.put("paymentNo", paymentNo);
    out.put("orderId", unifiedOrderId);
    out.put("customerKey", customerKey);
    out.put("customerName", customerName);
    out.put("amount", finalTotal);
    out.put("orderName", (String) orderData.get("orderName"));
    return out;
  }

  @Override
  @Transactional
  public PaymentVO confirmTossPayment(String paymentKey, String tossOrderId, Long amount) throws Exception {
      if (tossOrderId == null || !tossOrderId.startsWith("BG_")) {
        throw new Exception("잘못된 주문 ID 형식: " + tossOrderId);
    }
    final int paymentNo;
    try {
        paymentNo = Integer.parseInt(tossOrderId.substring(3)); // "BG_" 이후 숫자
    } catch (NumberFormatException e) {
        throw new Exception("결제번호 파싱 실패: " + tossOrderId);
    }

    // 2) 결제 금액 검증
    PaymentVO payment = paymentDAO.getPaymentByNo(paymentNo);
    if (payment == null) throw new Exception("결제 내역 없음: " + paymentNo);
    if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.valueOf(amount)) != 0) {
        throw new Exception("금액 불일치");
    }

    // 3) 토스 승인 요청
    HttpHeaders headers = new HttpHeaders();
    String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
    headers.set("Authorization", "Basic " + encodedAuth);
    headers.setContentType(MediaType.APPLICATION_JSON);
    Map<String, Object> params = new HashMap<>();
    params.put("paymentKey", paymentKey);
    params.put("orderId", tossOrderId);        // "BG_" + paymentNo
    params.put("amount", amount);

    HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);
    ResponseEntity<String> response = restTemplate.postForEntity(
              TOSS_API_HOST + "/v1/payments/confirm",
              requestEntity,
              String.class
      );

    if (!response.getStatusCode().is2xxSuccessful()) {
      throw new Exception("토스 결제 최종 승인 실패: " + response.getStatusCode());
    }

    // 4) DB 반영
    Map<String, Object> updateParams = new HashMap<>();
    updateParams.put("paymentNo", paymentNo);
    updateParams.put("status", 2); // 결제 완료
    paymentDAO.updatePaymentStatus(updateParams);

    TossRequestVO tossRequest = new TossRequestVO();
    tossRequest.setPaymentNo(paymentNo);
    tossRequest.setPaymentKey(paymentKey);
    paymentDAO.updateTossPaymentKey(tossRequest);

    return payment;
  }

}
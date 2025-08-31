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
  public Map<String, Object> prepareAndCreateTossOrder(Map<String, Object> orderData, Principal principal,
                                                       HttpServletRequest request) throws Exception {

    // 1. 주문 ID 유효성 검사 (가장 중요한 입력값)
    Integer orderId = (Integer) orderData.get("orderId");
    if (orderId == null) { throw new IllegalArgumentException("결제를 준비하려면 주문 ID(orderId)가 반드시 필요합니다."); }

    // 2. DB에서 주문 정보 조회 (회원/비회원 모두 조회)
    OrderVO order = orderDAO.getOrderById(orderId);
    if(order == null){
      order = orderDAO.getGuestOrderByOrderId(orderId); // 비회원 주문도 확인
      if(order == null){ throw new Exception("존재하지 않는 주문입니다: " + orderId); }
    }

    // 3. 결제에 필요한 주요 정보 설정
    final int finalTotal = order.getTotalPrice();
    String customerKey;
    String customerName;

    if(order.getOrderType() == 1){ // 회원 주문의 경우
      customerKey = order.getUserId();
      customerName = order.getReceiverName(); // DB에 저장된 수령인 이름 사용
    }else{ // 비회원 주문의 경우
      customerKey = order.getGuestId();
      customerName = order.getReceiverName(); // DB에 저장된 비회원 수령인 이름 사용
    }

    // 4. PAYMENTS 테이블에 결제 대기 정보 INSERT
    PaymentVO p = new PaymentVO();
    p.setOrderId(orderId);
    p.setAmount(new java.math.BigDecimal(finalTotal));
    p.setStatus(1);        // 1: 결제 대기
    p.setPaymentMethod(1); // 1: TossPay
    
    // 주문 타입에 따라 userId 또는 guestId 설정
    if(order.getOrderType() == 1){
      p.setUserId(customerKey);
    }else{
      p.setGuestId(customerKey);
    }
    
    paymentDAO.insertPayment(p);
    int paymentNo = p.getPaymentNo(); // DB에서 생성된 PK (payment_no)

    String unifiedOrderId = "BG_" + String.format("%06d", paymentNo);

    // 5. TOSS_REQUESTS 테이블에 결제 요청 정보 INSERT
    String baseUrl = request.getScheme() + "://" + request.getServerName()
        + ((request.getServerPort()==80||request.getServerPort()==443)?"":":"+request.getServerPort())
        + request.getContextPath();

    TossRequestVO tr = new TossRequestVO();
    tr.setPaymentNo(paymentNo);
    tr.setCustomerKey(customerKey);
    tr.setOrderName((String) orderData.get("orderName")); // 프론트에서 정제된 상품명
    tr.setSuccessUrl(baseUrl + "/payment/success");
    tr.setFailUrl(baseUrl + "/payment/fail");
    tr.setOrderId(unifiedOrderId);
    tr.setAmount(finalTotal);
    paymentDAO.insertTossRequest(tr);

    // 6. 프론트엔드(JavaScript)로 보낼 최종 응답 데이터 구성
    Map<String, Object> responseMap = new HashMap<>();
    responseMap.put("status", "SUCCESS");
    responseMap.put("orderId", unifiedOrderId); // Toss Payments SDK에 전달할 고유 ID
    responseMap.put("amount", finalTotal);
    responseMap.put("customerKey", customerKey);
    responseMap.put("customerName", customerName);
    responseMap.put("orderName", (String) orderData.get("orderName"));

    return responseMap;
  }

  @Override
  @Transactional
  public PaymentVO confirmTossPayment(String paymentKey, String tossOrderId, Long amount) throws Exception {
    if (tossOrderId == null || !tossOrderId.startsWith("BG_")) { throw new Exception("잘못된 주문 ID 형식: " + tossOrderId); }
    
    final int paymentNo;
    
    try{
      paymentNo = Integer.parseInt(tossOrderId.substring(3)); // "BG_" 이후 숫자
    }catch(NumberFormatException e) {
      throw new Exception("결제번호 파싱 실패: " + tossOrderId);
    }

    // 결제 금액 검증
    PaymentVO payment = paymentDAO.getPaymentByNo(paymentNo);
    if (payment == null) throw new Exception("결제 내역 없음: " + paymentNo);
    if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.valueOf(amount)) != 0) {
        throw new Exception("금액 불일치");
    }

    // 토스 승인 요청
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

    if(!response.getStatusCode().is2xxSuccessful()){
      throw new Exception("토스 결제 최종 승인 실패: " + response.getStatusCode());
    }

    // DB 반영
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
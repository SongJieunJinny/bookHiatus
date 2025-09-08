package com.bookGap.service;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Base64;
import java.util.HashMap;
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
import com.bookGap.vo.KakaoPayCancelVO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossCancelVO;
import com.bookGap.vo.TossRequestVO;

@Service
public class PaymentServiceImpl implements PaymentService{

  @Autowired private PaymentDAO paymentDAO;
  @Autowired private OrderDAO orderDAO;
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
  
  @Override
  public void logPayment(int paymentNo, String message) {
    paymentDAO.insertPaymentLog(paymentNo, message);
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

    Object orderIdObj = orderData.get("orderId");
    if(orderIdObj == null){ throw new IllegalArgumentException("결제를 준비하려면 주문 ID(orderId)가 반드시 필요합니다."); }

    int numericOrderId = ((Number) orderIdObj).intValue();
    
    OrderVO order;
    if(principal != null){ 
      order = orderDAO.getOrderById(numericOrderId);
    }else{ 
      order = orderDAO.getGuestOrderByOrderId(numericOrderId);
    }

    if(order == null){ throw new Exception("DB에서 해당 주문 정보(orderId: " + numericOrderId + ")를 찾을 수 없습니다."); }

    final int finalTotal = order.getTotalPrice();
    final String customerKey;
    final String customerName;

    if(order.getOrderType() == 1){ // 회원 주문
      customerKey = order.getUserId();
      customerName = order.getReceiverName();
    }else{ // 비회원 주문
      customerKey = order.getGuestId();
      customerName = order.getReceiverName();
    }

    if(customerKey == null || customerKey.trim().isEmpty()){ throw new IllegalStateException("주문 정보(orderId: " + numericOrderId + ")에 고객 식별자(userId/guestId)가 없습니다."); }

    PaymentVO p = new PaymentVO();
    p.setOrderId(numericOrderId); // 여기에는 변환된 숫자 ID를 사용합니다.
    p.setAmount(new java.math.BigDecimal(finalTotal));
    p.setStatus(1);        // 1: 결제 대기
    p.setPaymentMethod(1); // 1: TossPay
    
    if(order.getOrderType() == 1){
      p.setUserId(customerKey);
    }else{
      p.setGuestId(customerKey);
    }
    paymentDAO.insertPayment(p);
    int paymentNo = p.getPaymentNo();
    
    logPayment(paymentNo, "[TOSS][PREPARE] 결제 레코드 생성, amount=" + finalTotal);

    // 토스페이 정책에 맞는 orderId 생성 (6자 이상 보장)
    String unifiedOrderId = "BG_" + String.format("%06d", paymentNo);

    // TOSS_REQUESTS 테이블에 결제 요청 정보 INSERT
    String baseUrl = request.getScheme() + "://" + request.getServerName()
        + ((request.getServerPort() == 80 || request.getServerPort() == 443) ? "" : ":" + request.getServerPort())
        + request.getContextPath();

    TossRequestVO tr = new TossRequestVO();
    tr.setPaymentNo(paymentNo);
    tr.setCustomerKey(customerKey);
    tr.setOrderName((String) orderData.get("orderName"));
    tr.setSuccessUrl(baseUrl + "/payment/success");
    tr.setFailUrl(baseUrl + "/payment/fail");
    tr.setOrderId(unifiedOrderId);
    tr.setAmount(finalTotal);
    paymentDAO.insertTossRequest(tr);
    
    logPayment(paymentNo, "[TOSS][PREPARE] TOSS_REQUESTS 저장, orderId=" + unifiedOrderId);

    // 프론트엔드로 응답 반환
    Map<String, Object> responseMap = new HashMap<>();
    responseMap.put("status", "SUCCESS");
    responseMap.put("orderId", unifiedOrderId);
    responseMap.put("amount", finalTotal);
    responseMap.put("customerKey", customerKey);
    responseMap.put("customerName", customerName);
    responseMap.put("orderName", (String) orderData.get("orderName"));

    return responseMap;
  }

  @Override
  @Transactional
  public PaymentVO confirmTossPayment(String paymentKey, String tossOrderId, Long amount) throws Exception {
    if(tossOrderId == null || !tossOrderId.startsWith("BG_")){ throw new Exception("잘못된 주문 ID 형식: " + tossOrderId); }
    
    final int paymentNo;
    
    try{
      paymentNo = Integer.parseInt(tossOrderId.substring(3)); // "BG_" 이후 숫자
    }catch(NumberFormatException e){
      throw new Exception("결제번호 파싱 실패: " + tossOrderId);
    }

    // 결제 금액 검증
    PaymentVO payment = paymentDAO.getPaymentByNo(paymentNo);
    if (payment == null) throw new Exception("결제 내역 없음: " + paymentNo);
    if(payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.valueOf(amount)) != 0){ throw new Exception("금액 불일치"); }

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

    if(!response.getStatusCode().is2xxSuccessful()){ throw new Exception("토스 결제 최종 승인 실패: " + response.getStatusCode()); }

    // DB 반영
    Map<String, Object> updateParams = new HashMap<>();
    updateParams.put("paymentNo", paymentNo);
    updateParams.put("status", 2); // 결제 완료
    paymentDAO.updatePaymentStatus(updateParams);
    

    TossRequestVO tossRequest = new TossRequestVO();
    tossRequest.setPaymentNo(paymentNo);
    tossRequest.setPaymentKey(paymentKey);
    paymentDAO.updateTossPaymentKey(tossRequest);
    
    logPayment(paymentNo, "[TOSS][CONFIRM] 승인 완료, paymentKey=" + paymentKey + ", amount=" + amount);

    return payment;
  }

}
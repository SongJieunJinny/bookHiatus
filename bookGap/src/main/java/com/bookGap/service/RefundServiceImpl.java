package com.bookGap.service;

import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType; 
import org.springframework.http.ResponseEntity; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.bookGap.dao.OrderDAO;
import com.bookGap.dao.PaymentDAO;
import com.bookGap.dao.RefundDAO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.RefundVO;
import com.bookGap.vo.TossRequestVO;

@Service
public class RefundServiceImpl implements RefundService{
  
  @Autowired public RefundDAO refundDAO;
  @Autowired private OrderDAO orderDAO;
  @Autowired private PaymentDAO paymentDAO;
  @Autowired private RestTemplate restTemplate;
  
  @Value("${kakao.admin-key}")
  private String kakaoAdminKey;
  @Value("${toss.secret-key}")
  private String tossSecretKey;
  @Value("${kakao.cid}")
  private String kakaoCid;

  @Override
  @Transactional(rollbackFor = Exception.class)
  public void applyRefundAndUpdateStatus(RefundVO refundVO) {
    int insertResult = refundDAO.applyRefund(refundVO);
    if (insertResult == 0) {
      throw new RuntimeException("환불 정보 삽입(INSERT)에 실패했습니다.");
    }

    refundDAO.updateRefundStatusToRequest(refundVO.getOrderId());
  }
  
  /* 환불 신청 내역을 고객 화면에서 조회(주문번호 기준) */
  @Override
  public List<RefundVO> getRefundListByOrderId(int orderId) {
    return refundDAO.selectRefundListByOrderId(orderId);
  }
  
  /* 주문ID + 결제ID 기준 환불 조회 */
  @Override
  public RefundVO getRefundByOrderAndPayment(int orderId, int paymentNo) {
    Map<String, Object> params = new HashMap<>();
    params.put("orderId", orderId);
    params.put("paymentNo", paymentNo);
    return refundDAO.getRefundByOrderAndPayment(params);
  }

  @Override
  public void updateRefundStatusToRequest(int orderId) {
    refundDAO.updateRefundStatusToRequest(orderId);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public void processImmediateCancelByUser(RefundVO refundVO, Principal principal) throws Exception {
      if (principal == null) throw new SecurityException("로그인이 필요한 기능입니다.");

      String userId = principal.getName();
      int orderId = refundVO.getOrderId();

      OrderVO order = orderDAO.getOrderById(orderId);
      if (order == null) throw new IllegalArgumentException("존재하지 않는 주문입니다.");
      if (!userId.equals(order.getUserId())) throw new SecurityException("주문을 취소할 권한이 없습니다.");

      if (order.getOrderStatus() != 1) {
          throw new IllegalStateException("배송 준비중인 주문만 즉시 취소할 수 있습니다.");
      }

      int paymentNo = (order.getPayment() != null) ? order.getPayment().getPaymentNo() : refundVO.getPaymentNo();
      PaymentVO payment = paymentDAO.getPaymentByNo(paymentNo);
      if (payment == null) throw new IllegalStateException("결제 정보를 찾을 수 없습니다.");

      if (payment.getPaymentMethod() == 1) { // Toss
          TossRequestVO tossReq = paymentDAO.findTossRequestByPaymentNo(payment.getPaymentNo());
          if (tossReq == null || tossReq.getPaymentKey() == null) throw new IllegalStateException("토스 결제키(paymentKey)가 없습니다.");
          
          callTossPaymentCancelApi(tossReq.getPaymentKey(), refundVO.getRefundReason());
          
      } else if (payment.getPaymentMethod() == 2) { // Kakao
          KakaoPayRequestVO kakaoReq = paymentDAO.findKakaoRequestByPaymentNo(payment.getPaymentNo());
          if (kakaoReq == null || kakaoReq.getTid() == null) throw new IllegalStateException("카카오 거래ID(TID)가 없습니다.");
          
          callKakaoPaymentCancelApi(kakaoReq.getTid(), payment.getAmount().intValue(), refundVO.getRefundReason());

      } else {
          throw new IllegalArgumentException("알 수 없는 결제 수단입니다.");
      }

      orderDAO.updateOrderStatus(orderId, 4);
      orderDAO.updateOrderRefundStatus(orderId, 3);
      
      Map<String, Object> paymentParams = new HashMap<>();
      paymentParams.put("paymentNo", payment.getPaymentNo());
      paymentParams.put("status", 3);
      paymentDAO.updatePaymentStatus(paymentParams);
      
      refundVO.setRefundStatus(3);
      refundDAO.applyRefund(refundVO);
  }
  
  private void callTossPaymentCancelApi(String paymentKey, String reason) throws Exception {
    HttpHeaders headers = new HttpHeaders();
    String encodedAuth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));
    headers.set("Authorization", "Basic " + encodedAuth);
    headers.setContentType(MediaType.APPLICATION_JSON);

    Map<String, Object> params = new HashMap<>();
    params.put("cancelReason", reason);

    HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);
    String url = "https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel";
    
    ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);
    
    if (!response.getStatusCode().is2xxSuccessful()) {
        throw new Exception("토스페이먼츠 취소 API 호출 실패: " + response.getBody());
    }
}
  
  private void callKakaoPaymentCancelApi(String tid, int amount, String reason) throws Exception {
    Map<String, Object> params = new HashMap<>();
    params.put("cid", kakaoCid);
    params.put("tid", tid);
    params.put("cancel_amount", amount);
    params.put("cancel_tax_free_amount", 0);
    params.put("cancel_reason", reason);

    HttpHeaders headers = new HttpHeaders();
    headers.set("Authorization", "SECRET_KEY " + kakaoAdminKey); 
    headers.setContentType(MediaType.APPLICATION_JSON);

    HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);
    String url = "https://open-api.kakaopay.com/online/v1/payment/cancel";
    
    ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);
    
    if (!response.getStatusCode().is2xxSuccessful()) {
        throw new Exception("카카오페이 취소 API 호출 실패: " + response.getBody());
    }
}
}
package com.bookGap.service;

import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.bookGap.vo.KakaoPayCancelVO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossCancelVO;
import com.bookGap.vo.TossRequestVO;

public interface PaymentService {
  //공통 결제
  public void insertPayment(PaymentVO paymentVO);
  public void updatePaymentStatus(int paymentNo, int status);

  // 카카오페이
  public void insertKakaoRequest(KakaoPayRequestVO kakaoPayRequestVO);
  public void updateKakaoTid(KakaoPayRequestVO kakaoPayRequestVO);
  public KakaoPayRequestVO findKakaoRequestByPaymentNo(int paymentNo);
  public void insertKakaoCancel(KakaoPayCancelVO kakaoPayCancelVO);

  // 토스페이
  public void insertTossRequest(TossRequestVO tossRequestVO);
  public void updateTossPaymentKey(TossRequestVO tossRequestVO);
  public TossRequestVO findTossRequestByPaymentNo(int paymentNo);
  public void insertTossCancel(TossCancelVO tossCancelVO);
  PaymentVO getPaymentByNo(int paymentNo);
  
  
  PaymentVO selectPaymentByRefundNo(int refundNo);
  KakaoPayRequestVO selectKakaoRequest(int paymentNo);
  
  //토스 결제 준비를 위해 주문과 결제 대기 정보를 한번에 생성
  Map<String, Object> prepareAndCreateTossOrder(Map<String, Object> orderData, Principal principal, HttpServletRequest request) throws Exception;
  
  //토스 결제 성공 시, 최종 승인 및 DB 상태를 업데이트
  PaymentVO confirmTossPayment(String paymentKey, String tossOrderId, Long amount) throws Exception;
  
 
}
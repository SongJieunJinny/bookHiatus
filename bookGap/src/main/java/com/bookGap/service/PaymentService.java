package com.bookGap.service;

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
}
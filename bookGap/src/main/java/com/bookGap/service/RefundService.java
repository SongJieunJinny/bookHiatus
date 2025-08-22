package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.RefundVO;

public interface RefundService {
  
  /* 환불 신청 */
  public int applyRefund(RefundVO refundVO);

  /* 환불 신청 내역을 고객 화면에서 조회 */
  public List<RefundVO> getRefundListByOrderId(int orderId);
  
  /* 주문ID + 결제ID 기준 환불 조회 */
  public RefundVO getRefundByOrderAndPayment(int orderId, int paymentNo);

}

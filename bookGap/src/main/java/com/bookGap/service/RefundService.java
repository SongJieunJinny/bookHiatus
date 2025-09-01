package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.RefundVO;

public interface RefundService {
  
  /* 환불 신청과 주문 상태 업데이트를 하나의 트랜잭션으로 처리 */
  public void applyRefundAndUpdateStatus(RefundVO refundVO);
  
  /* 환불 신청 내역을 고객 화면에서 조회(주문번호 기준) */
  public List<RefundVO> getRefundListByOrderId(int orderId);

  /* 주문ID + 결제ID 기준 환불 조회 */
  public RefundVO getRefundByOrderAndPayment(int orderId, int paymentNo);
  
  /* 환불 신청 시 ORDERS 테이블 REFUND_STATUS = 1 로 변경 */
  public void updateRefundStatusToRequest(int orderId);

}
package com.bookGap.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.RefundDAO;
import com.bookGap.vo.RefundVO;

@Service
public class RefundServiceImpl implements RefundService{
  
  @Autowired public RefundDAO refundDAO;

  @Override
  @Transactional(rollbackFor = Exception.class) // 4. 트랜잭션 적용
  public void applyRefundAndUpdateStatus(RefundVO refundVO) {
    // 첫 번째 DB 작업: REFUND 테이블에 삽입
    int insertResult = refundDAO.applyRefund(refundVO);
    
    // 삽입이 실패하면 예외를 발생시켜 롤백
    if (insertResult == 0) {
        throw new RuntimeException("환불 정보 삽입에 실패했습니다. (OrderId: " + refundVO.getOrderId() + ")");
    }
    
    // 두 번째 DB 작업: ORDERS 테이블의 상태 업데이트
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

}
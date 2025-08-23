package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.RefundVO;

@Repository
public class RefundDAO {
  
  @Autowired
  private  SqlSession sqlSession;
  
  private final static String name_space = "com.bookGap.mapper.refundMapper.";

  /* 환불 신청 */
  public int applyRefund(RefundVO refundVO) {
    return sqlSession.insert(name_space + "applyRefund", refundVO);
  }
  
  /* 환불 신청 내역을 고객 화면에서 조회 */
  public List<RefundVO> selectRefundListByOrderId(int orderId) {
    return sqlSession.selectList(name_space + "selectRefundListByOrderId", orderId);
  }
  
  /* 주문ID + 결제ID 기준 환불 조회 */
  public RefundVO getRefundByOrderAndPayment(int orderId, int paymentNo) {
    Map<String, Object> param = new HashMap<>();
    param.put("orderId", orderId);
    param.put("paymentNo", paymentNo);
    return sqlSession.selectOne(name_space + "getRefundByOrderAndPayment", param);
  }

}

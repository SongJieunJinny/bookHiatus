package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.RefundDAO;
import com.bookGap.vo.RefundVO;

@Service
public class RefundServiceImpl implements RefundService{
  
  @Autowired public RefundDAO refundDAO;

  @Override
  public int applyRefund(RefundVO refundVO) {
    return refundDAO.applyRefund(refundVO);
  }
  
  @Override
  public List<RefundVO> getRefundListByOrderId(int orderId) {
    return refundDAO.selectRefundListByOrderId(orderId);
  }
  
  @Override
  public RefundVO getRefundByOrderAndPayment(int orderId, int paymentNo) {
    return refundDAO.getRefundByOrderAndPayment(orderId, paymentNo);
  }
}
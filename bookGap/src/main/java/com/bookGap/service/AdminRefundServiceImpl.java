package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.AdminRefundDAO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.RefundUpdateRequestVO;
import com.bookGap.vo.RefundVO;


@Service
public class AdminRefundServiceImpl implements AdminRefundService {
	
	 @Autowired
	 private AdminRefundDAO adminRefundDAO;
	 
	 
	 @Override
	  public List<RefundVO> getAllRefunds() {
	    return adminRefundDAO.selectAllRefunds();
	  }

	 @Override
	 public RefundVO getRefundDetail(int refundNo) {
	   RefundVO vo = adminRefundDAO.getRefundDetail(refundNo);

	   if (vo != null && vo.getOrderId() != null) {
	     List<OrderDetailVO> details = adminRefundDAO.getOrderDetailsByOrderId(vo.getOrderId());
	     vo.setOrderDetails(details); // 상품 정보 주입
	   }

	   return vo;
	 }

	  @Override
	  @Transactional
	  public int updateRefundStatusAndSyncOrder(int refundNo, int refundStatus) {
	    RefundUpdateRequestVO req = new RefundUpdateRequestVO();
	    req.setRefundNo(refundNo);
	    req.setRefundStatus(refundStatus);

	    int a = adminRefundDAO.updateRefundStatus(req);
	    int b = adminRefundDAO.updateOrderRefundStatusByRefundNo(req);
	    int c = 1;

	    // 환불 완료(3)인 경우 주문 상태를 5(교환/반품)로 맞춤
	    if (refundStatus == 3) {
	      c = adminRefundDAO.updateOrderStatusToReturnedByRefundNo(refundNo);
	    }
	    // 모두 성공했는지 간단 체크 (실서비스에선 영향행 수 검증 로직 강화 권장)
	    return (a > 0 && b > 0 && c > 0) ? 1 : 0;
	  }

}

package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.RefundUpdateRequestVO;
import com.bookGap.vo.RefundVO;

@Repository
public class AdminRefundDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	 private final String namespace = "com.bookGap.mapper.adminRefundMapper";
	 
	  // 목록
	  public List<RefundVO> selectAllRefunds() {
	    return sqlSession.selectList(namespace + ".selectAllRefunds");
	  }

	  // 상세
	  public RefundVO getRefundDetail(int refundNo) {
	    return sqlSession.selectOne(namespace + ".getRefundDetail", refundNo);
	  }

	  // 주문 상세(상품 라인업)
	  public List<OrderDetailVO> getOrderDetailsByOrderId(int orderId) {
	    return sqlSession.selectList(namespace + ".getOrderDetailsByOrderId", orderId);
	  }

	  // REFUND 상태 업데이트
	  public int updateRefundStatus(RefundUpdateRequestVO req) {
	    return sqlSession.update(namespace + ".updateRefundStatus", req);
	  }

	  // ORDERS.REFUND_STATUS 동기화
	  public int updateOrderRefundStatusByRefundNo(RefundUpdateRequestVO req) {
	    return sqlSession.update(namespace + ".updateOrderRefundStatusByRefundNo", req);
	  }

	  // 환불완료 시 ORDERS.ORDER_STATUS = 5
	  public int updateOrderStatusToReturnedByRefundNo(int refundNo) {
		    return sqlSession.update(namespace + ".updateOrderStatusToReturnedByRefundNo", refundNo);
		  }
}

package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.AdminOrderUpdateRequestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;

@Repository
public class AdminOrderDAO {
	@Autowired
	private SqlSession sqlSession;
	
	private final String namespace = "com.bookGap.mapper.AdminOrderMapper";
	
	public List<OrderVO> selectAllUserOrders() {
		  return sqlSession.selectList(namespace + ".selectAllUserOrders");
	  
	}
	
    public OrderVO getOrderInfoById(int orderId) {
        return sqlSession.selectOne(namespace + ".getOrderInfoById", orderId);
    }

    // 주문 번호로 주문 상세 항목(도서 목록) 조회
    public List<OrderDetailVO> getOrderDetailsByOrderId(int orderId) {
        return sqlSession.selectList(namespace + ".getOrderDetailsByOrderId", orderId);
    }
	
    public OrderVO getOrderInfoWithPayment(int orderId) {
        return sqlSession.selectOne(namespace + ".getOrderInfoWithPayment", orderId);
    }
    
    public int updateUserOrder(AdminOrderUpdateRequestVO req) {
        return sqlSession.update(namespace + ".updateUserOrder", req);
    }

    public int updateUserPaymentStatus(AdminOrderUpdateRequestVO req) {
        return sqlSession.update(namespace + ".updateUserPaymentStatus", req);
    }
    
 // 비회원 주문 목록 조회
    public List<OrderVO> selectAllGuestOrders() {
        return sqlSession.selectList(namespace + ".selectAllGuestOrders");
    }

    // 비회원 주문 상세 (결제 포함)
    public OrderVO getGuestOrderInfoWithPayment(int orderId) {
        return sqlSession.selectOne(namespace + ".getGuestOrderInfoWithPayment", orderId);
    }

    // 비회원 주문 상태 업데이트
    public int updateGuestOrder(AdminOrderUpdateRequestVO req) {
        return sqlSession.update(namespace + ".updateGuestOrder", req);
    }

    // 비회원 결제 상태 업데이트
    public int updateGuestPaymentStatus(AdminOrderUpdateRequestVO req) {
        return sqlSession.update(namespace + ".updateGuestPaymentStatus", req);
    }

}

package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@Repository
public class OrderDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private static final String NS = "com.bookGap.mapper.orderMapper.";

  //====== 주문 관련 ======
  public void insertOrder(OrderVO vo) {
    sqlSession.insert(NS + "insertOrder", vo);
  }

  public void insertOrderDetail(OrderDetailVO vo) {
    sqlSession.insert(NS + "insertOrderDetail", vo);
  }

  public void insertOrderDetailList(List<OrderDetailVO> list) {
    sqlSession.insert(NS + "insertOrderDetailList", list);
  }
  
  public boolean updateBookStock(String isbn, int quantity) {
    Map<String, Object> p = new HashMap<>();
    p.put("isbn", isbn);
    p.put("quantity", quantity);
    int updated = sqlSession.update(NS + "updateBookStock", p);
    return updated > 0;
  }

  public void addAddress(UserAddressVO address) {
    sqlSession.insert(NS + "addAddress", address);
  }

  public void deleteAddress(int userAddressId) {
    sqlSession.delete(NS + "deleteAddress", userAddressId);
  }

  public UserAddressVO findAddressByUserAddressId(int userAddressId) {
	return sqlSession.selectOne(NS + "findAddressByUserAddressId", userAddressId);
  }

  public UserAddressVO findDefaultAddressByUserId(String userId) {
	return sqlSession.selectOne(NS + "findDefaultAddressByUserId", userId);
  }
  
  public List<UserAddressVO> findAddressListByUserId(String userId) {
	return sqlSession.selectList(NS + "findAddressListByUserId", userId);
  }

  public BookVO findBookByIsbn(String isbn) {
    return sqlSession.selectOne(NS + "findBookByIsbn", isbn);
  }

  public List<BookVO> selectBooksByIsbnList(List<String> isbnList) {
    return sqlSession.selectList(NS + "selectBooksByIsbnList", isbnList);
  }

  //페이징
  public List<OrderVO> getOrdersPaging(String userId, int start, int perPage, String startDate, String endDate) {
    Map<String, Object> p = new HashMap<>();
    p.put("userId", userId);
    p.put("start", start);
    p.put("perPage", perPage);
    p.put("startDate", startDate);
    p.put("endDate", endDate);
    return sqlSession.selectList(NS + "getOrdersPaging", p);
  }

  //회원 단건 주문조회
  public OrderVO getOrderById(int orderId) {
    return sqlSession.selectOne(NS + "getOrderById", orderId);
  }
  
  //회원 주문 조회
  public List<OrderVO> getOrdersByUserId(String userId) {
    return sqlSession.selectList(NS + "getOrdersByUserId", userId);
  }
  
  //비회원 단건 주문조회
  public OrderVO getGuestOrderByOrderId(int orderId) {
	return sqlSession.selectOne(NS + "getGuestOrderByOrderId", orderId);
  }
  
  //비회원 주문 전체 조회
  public OrderVO findGuestOrderByKey(String orderKey) {
    return sqlSession.selectOne(NS + "findGuestOrderByKey", orderKey);
  }

  //전체 카운트 메서드
  public int getTotalOrderCount(String userId, String startDate, String endDate) {
    Map<String, Object> p = new HashMap<>();
    p.put("userId", userId);
    p.put("startDate", startDate);
    p.put("endDate", endDate);
    return sqlSession.selectOne(NS + "getTotalOrderCount", p);
  }
  
  /* 주문 취소하기" 버튼을 눌렀을 때 실행 */
  public void updateOrderRefundStatus(int orderId, int status) {
    Map<String, Object> params = new HashMap<>();
    params.put("orderId", orderId);
    params.put("status", status);
    sqlSession.update(NS + "updateOrderRefundStatus", params); 
  }
  
  /* 주문의 주 상태(ORDER_STATUS)를 업데이트 */
  public void updateOrderStatus(int orderId, int status) {
    Map<String, Object> params = new HashMap<>();
    params.put("orderId", orderId);
    params.put("status", status);
    sqlSession.update(NS + "updateOrderStatus", params);
  }

}
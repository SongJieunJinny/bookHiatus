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

  //회원 주문 조회
  public List<OrderVO> getOrdersByUserId(String userId) {
      return sqlSession.selectList(NS + "getOrdersByUserId", userId);
  }

  public int getTotalOrderCount(String userId) {
      return sqlSession.selectOne(NS + "getTotalOrderCount", userId);
  }
  
  //페이징
  public List<OrderVO> getOrdersPaging(String userId, int start, int perPage) {
      Map<String, Object> p = new HashMap<>();
      p.put("userId", userId);
      p.put("start", start);
      p.put("perPage", perPage);
      return sqlSession.selectList(NS + "getOrdersPaging", p);
  }

  public BookVO findBookByIsbn(String isbn) {
    return sqlSession.selectOne(NS + "findBookByIsbn", isbn);
  }

  public List<BookVO> selectBooksByIsbnList(List<String> isbnList) {
    return sqlSession.selectList(NS + "selectBooksByIsbnList", isbnList);
  }

  public UserAddressVO findDefaultAddressByUserId(String userId) {
    return sqlSession.selectOne(NS + "findDefaultAddressByUserId", userId);
  }

  public List<UserAddressVO> findAddressListByUserId(String userId) {
    return sqlSession.selectList(NS + "findAddressListByUserId", userId);
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

  public boolean updateBookStock(String isbn, int quantity) {
    Map<String, Object> p = new HashMap<>();
    p.put("isbn", isbn);
    p.put("quantity", quantity);
    int updated = sqlSession.update(NS + "updateBookStock", p);
    return updated > 0;
  }
  
<<<<<<< HEAD
  //비회원 주문 조회
  public List<OrderVO> findGuestOrdersByPasswordAndEmail(String orderPassword, String guestEmail) {
    Map<String, Object> p = new HashMap<>();
    p.put("orderPassword", orderPassword);
    p.put("guestEmail", guestEmail);
    return sqlSession.selectList(NS + "findGuestOrdersByPasswordAndEmail", p);
}
=======
  public OrderVO getOrderById(int orderId) {
      return sqlSession.selectOne(NS + "getOrderById", orderId);
  }

  public UserAddressVO getAddressByOrderId(int orderId) {
      return sqlSession.selectOne(NS+ "getAddressByOrderId", orderId);
  }
>>>>>>> branch 'main' of https://github.com/SongJieunJinny/bookHiatus.git

}
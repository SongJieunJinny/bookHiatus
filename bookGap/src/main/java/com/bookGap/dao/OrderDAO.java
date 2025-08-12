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
  
  private final String name_space = "com.bookGap.mapper.orderMapper.";
  
  public void insertOrder(OrderVO orderVO) {
    sqlSession.insert(name_space + "insertOrder", orderVO);
  }
  
  public void insertOrderDetail(OrderDetailVO orderDetailVO) {
    sqlSession.insert(name_space + "insertOrderDetail", orderDetailVO);
  }
  
  public void insertOrderDetailList(List<OrderDetailVO> orderDetailVOList) {
    sqlSession.insert(name_space + "insertOrderDetailList", orderDetailVOList);
  }
  
  public List<OrderVO> getOrdersByUserId(String userId) {
    return sqlSession.selectList(name_space + "getOrdersByUserId", userId);
  }
  
  public BookVO findBookByIsbn(String isbn) {
    return sqlSession.selectOne(name_space + "findBookByIsbn", isbn);
  }
  
  public List<BookVO> selectBooksByIsbnList(List<String> isbnList) {
    return sqlSession.selectList(name_space + "selectBooksByIsbnList", isbnList);
  }
  
  public UserAddressVO findDefaultAddressByUserId(String userId) {
    return sqlSession.selectOne(name_space + "findDefaultAddressByUserId", userId);
  }
  
  public List<UserAddressVO> findAddressListByUserId(String userId) {
    return sqlSession.selectList(name_space + "findAddressListByUserId", userId);
  }
  
  public void addAddress(UserAddressVO address) {
    sqlSession.insert(name_space + "addAddress", address);
  }
  
  public void deleteAddress(int userAddressId) {
    sqlSession.delete(name_space + "deleteAddress", userAddressId);
  }

  public UserAddressVO findAddressByUserAddressId(int userAddressId) {
    return sqlSession.selectOne(name_space + "findAddressByUserAddressId", userAddressId);
  }

  public boolean updateBookStock(String isbn, int quantity) {
    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("isbn", isbn);
    paramMap.put("quantity", quantity);

    int updatedRows = sqlSession.update(name_space + "updateBookStock", paramMap);

    return updatedRows > 0;
  }
}
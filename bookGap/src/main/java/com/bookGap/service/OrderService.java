package com.bookGap.service;

import java.util.List;
import java.util.Map;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

public interface OrderService {
  //주문 관련
  public void placeOrder(OrderVO order, List<OrderDetailVO> details);
  
  public OrderVO createGuestOrder(Map<String, Object> orderData) throws Exception; 
  
  public List<OrderVO> getOrdersByUser(String userId);

  // 상품 관련
  public BookVO getBookByIsbn(String isbn);
  public List<BookVO> getBooksByIsbnList(List<String> isbnList);

  // 주소 관련
  public UserAddressVO getDefaultAddress(String userId);
  public List<UserAddressVO> getAddressList(String userId);
  public void registerAddress(UserAddressVO address);
  public void removeAddress(int userAddressId);

  public UserAddressVO findAddressByUserAddressId(int userAddressId);
  public boolean updateBookStock(String isbn, int quantity);
  
  public int createOrderWithDetails(Map<String, Object> orderData) throws IllegalStateException;
  
  public Map<String, Object> createGuestOrderWithDetails(Map<String, Object> orderData) throws Exception;

}
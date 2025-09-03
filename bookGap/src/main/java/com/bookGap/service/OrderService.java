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
  
  //회원 주문 조회
  public List<OrderVO> getOrdersByUserId(String userId);
  public List<OrderVO> getOrdersPaging(String userId, int start, int perPage);
  public int getTotalOrderCount(String userId);

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
  
  //회원 단건 주문 조회
  public OrderVO getOrderById(int orderId);

  //비회원 단건 주문 조회
  public OrderVO getGuestOrderByOrderId(int orderId);
  
  //비회원 단건 조회 인증
  public List<OrderVO> findGuestOrdersByPasswordAndEmail(String orderPassword, String guestEmail);
  //사용자 주문취소 업데이트 
  public  void updateOrderStatus(int orderId, int status);
  
}
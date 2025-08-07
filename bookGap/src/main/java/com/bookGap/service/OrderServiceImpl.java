package com.bookGap.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.GuestDAO;
import com.bookGap.dao.OrderDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.GuestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@Service
public class OrderServiceImpl implements OrderService {
  
  @Autowired
  private OrderDAO orderDAO;
  
  @Autowired
  private GuestDAO guestDAO;

  @Transactional
  @Override
  public void placeOrder(OrderVO order, List<OrderDetailVO> details) {
    orderDAO.insertOrder(order); // orderId 생성됨

    for (OrderDetailVO detail : details) {
      detail.setOrderId(order.getOrderId()); // FK 설정
    }
    orderDAO.insertOrderDetailList(details);
  }
  
  @Override
  @Transactional
  public OrderVO createGuestOrder(Map<String, Object> orderData) throws Exception {
      // 비회원 생성 로직 동일 (생략)

      OrderVO newOrder = new OrderVO();
      // set guestId, 주소 등은 동일하게 설정

      orderDAO.insertOrder(newOrder); // 주문 등록

      // 복수 상품 처리
      List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("items");
      List<OrderDetailVO> detailList = new ArrayList<>();

      for (Map<String, Object> item : items) {
          OrderDetailVO detail = new OrderDetailVO();
          detail.setOrderId(newOrder.getOrderId());
          detail.setBookNo((Integer) item.get("bookNo"));
          detail.setOrderCount((Integer) item.get("quantity"));
          detail.setOrderPrice((Integer) item.get("priceAtPurchase"));
          detail.setRefundCheck(2);
          detailList.add(detail);
      }

      orderDAO.insertOrderDetailList(detailList);
      return newOrder;
  }
  
  @Override
  public List<OrderVO> getOrdersByUser(String userId) {
      return orderDAO.getOrdersByUserId(userId);
  }

  @Override
  public BookVO getBookByIsbn(String isbn) {
      return orderDAO.findBookByIsbn(isbn);
  }

  @Override
  public List<BookVO> getBooksByIsbnList(List<String> isbnList) {
      return orderDAO.selectBooksByIsbnList(isbnList);
  }

  @Override
  public UserAddressVO getDefaultAddress(String userId) {
      return orderDAO.findDefaultAddressByUserId(userId);
  }

  @Override
  public List<UserAddressVO> getAddressList(String userId) {
      return orderDAO.findAddressListByUserId(userId);
  }

  @Override
  public void registerAddress(UserAddressVO address) {
      orderDAO.addAddress(address);
  }

  @Override
  public void removeAddress(int userAddressId) {
      orderDAO.deleteAddress(userAddressId);
  }

}
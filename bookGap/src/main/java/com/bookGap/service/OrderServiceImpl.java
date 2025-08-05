package com.bookGap.service;

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
  
  @Transactional
  @Override
  public OrderVO createGuestOrder(Map<String, Object> orderData) throws Exception {
  
    // --- 단계 1: Map에서 데이터를 꺼내 Guest 정보 처리 ---
    // Map에서 데이터를 꺼낼 때는 "Key 이름"으로 꺼내고, 원래 데이터 타입으로 형변환 해줍니다.
    String ordererEmail = (String) orderData.get("ordererEmail");

    GuestVO guest = guestDAO.findGuestByEmail(ordererEmail);
    String guestId;

    if (guest == null) {
      guestId = "guest_" + UUID.randomUUID().toString().substring(0, 8);
      
      GuestVO newGuest = new GuestVO();
      newGuest.setGuestId(guestId);
      newGuest.setGuestName((String) orderData.get("ordererName"));
      newGuest.setGuestPhone((String) orderData.get("ordererPhone"));
      newGuest.setGuestEmail(ordererEmail);
      
      guestDAO.insertGuest(newGuest);
    } else {
      guestId = guest.getGuestId();
    }

    // --- 단계 2: Map에서 데이터를 꺼내 Order 정보 처리 ---
    OrderVO newOrder = new OrderVO();
    newOrder.setGuestId(guestId);
    newOrder.setOrderType(2); // 비회원 타입
    newOrder.setOrderStatus(1); // 배송 준비중

    // Map에서 배송지 정보, 결제 정보 등을 모두 꺼내서 세팅합니다.
    newOrder.setTotalPrice((Integer) orderData.get("totalPrice"));
    newOrder.setReceiverName((String) orderData.get("receiverName"));
    newOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
    newOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    newOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    newOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    newOrder.setOrderPassword((String) orderData.get("orderPassword")); // TODO: 암호화 필요
    
    orderDAO.insertOrder(newOrder); // DB에 저장! (orderId 자동 생성됨)

    // --- 단계 3: Map에서 데이터를 꺼내 OrderDetail 정보 처리 ---
    OrderDetailVO detail = new OrderDetailVO();
    detail.setOrderId(newOrder.getOrderId());
    detail.setBookNo((Integer) orderData.get("bookNo"));
    detail.setOrderCount((Integer) orderData.get("quantity"));
    detail.setOrderPrice((Integer) orderData.get("priceAtPurchase"));
    detail.setRefundCheck(2);
    
    orderDAO.insertOrderDetail(detail);

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
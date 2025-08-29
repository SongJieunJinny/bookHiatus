package com.bookGap.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.OrderDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.GuestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@Service
public class OrderServiceImpl implements OrderService {
  
  @Autowired private OrderDAO orderDAO;
  @Autowired private GuestService guestService; 

  @Transactional
  @Override
  public void placeOrder(OrderVO order, List<OrderDetailVO> details) {
    orderDAO.insertOrder(order); // PK 생성
    for (OrderDetailVO detail : details) {
      detail.setOrderId(order.getOrderId()); // FK 세팅
      orderDAO.insertOrderDetail(detail);
    }
  }
  
  @Transactional
  @Override
  public OrderVO createGuestOrder(Map<String, Object> orderData) throws Exception {
    OrderVO newOrder = new OrderVO();
    orderDAO.insertOrder(newOrder);

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("items");
    List<OrderDetailVO> detailList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(newOrder.getOrderId());
      d.setBookNo((Integer) item.get("bookNo"));
      d.setOrderCount((Integer) item.get("quantity"));
      d.setOrderPrice((Integer) item.get("priceAtPurchase"));
      d.setRefundCheck(1); // 기본값: 환불 없음
      detailList.add(d);
    }
    orderDAO.insertOrderDetailList(detailList);
    return newOrder;
  }
  
  @Override
  public List<OrderVO> getOrdersByUserId(String userId) {
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

  @Override
  public UserAddressVO findAddressByUserAddressId(int userAddressId) {
    return orderDAO.findAddressByUserAddressId(userAddressId);
  }

  @Override
  public boolean updateBookStock(String isbn, int quantity) {
    return orderDAO.updateBookStock(isbn, quantity);
  }
  
  @Override
  @Transactional
  public int createOrderWithDetails(Map<String, Object> orderData) throws IllegalStateException {
    String userId = (String) orderData.get("userId");
    Integer userAddressId = (Integer) orderData.get("userAddressId");
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");

    UserAddressVO deliveryAddress = orderDAO.findAddressByUserAddressId(userAddressId);
    if(deliveryAddress == null){
      throw new IllegalStateException("선택된 배송지 정보를 찾을 수 없습니다. (ID: " + userAddressId + ")");
    }

    int serverCalculatedTotalPrice = 0;
    List<String> isbnList = new ArrayList<>();
    for (Map<String, Object> item : items) isbnList.add((String) item.get("isbn"));

    List<BookVO> booksInDb = orderDAO.selectBooksByIsbnList(isbnList);

    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");
      BookVO book = booksInDb.stream()
                    .filter(b -> b.getIsbn().equals(isbn))
                    .findFirst()
                    .orElseThrow(() -> new IllegalStateException("주문 처리 중 상품 정보를 찾을 수 없습니다: " + isbn));
      serverCalculatedTotalPrice += book.getProductInfo().getDiscount() * quantity;
    }

    serverCalculatedTotalPrice += (Integer) orderData.get("deliveryFee");
    if(serverCalculatedTotalPrice != (Integer) orderData.get("totalPrice")){
      System.out.println("WARN: 가격 검증 불일치. 서버:" + serverCalculatedTotalPrice +", 클라이언트:" + orderData.get("totalPrice"));
    }

    OrderVO newOrder = new OrderVO();
    newOrder.setUserId(userId);
    newOrder.setUserAddressId(userAddressId);
    newOrder.setTotalPrice(serverCalculatedTotalPrice);
    newOrder.setOrderStatus(1);
    newOrder.setOrderType(1);
    newOrder.setReceiverName(deliveryAddress.getUserName());
    newOrder.setReceiverPhone(deliveryAddress.getUserPhone());
    newOrder.setReceiverPostCode(deliveryAddress.getPostCode());
    newOrder.setReceiverRoadAddress(deliveryAddress.getRoadAddress());
    newOrder.setReceiverDetailAddress(deliveryAddress.getDetailAddress());
    newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    orderDAO.insertOrder(newOrder);
    int newOrderId = newOrder.getOrderId();

    List<OrderDetailVO> orderDetailList = new ArrayList<>();
    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");
      BookVO currentBook = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn)).findFirst().get();

      if(!orderDAO.updateBookStock(isbn, quantity)){
        throw new IllegalStateException("재고가 부족합니다: " + currentBook.getProductInfo().getTitle());
      }

      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(newOrderId);
      d.setBookNo(currentBook.getBookNo());
      d.setOrderCount(quantity);
      d.setOrderPrice(currentBook.getProductInfo().getDiscount());
      d.setRefundCheck(0);
      orderDetailList.add(d);
    }
    if (!orderDetailList.isEmpty()) orderDAO.insertOrderDetailList(orderDetailList);

    return newOrderId;
  }

  @Override
  @Transactional
  public Map<String, Object> createGuestOrderWithDetails(Map<String, Object> orderData) throws Exception {
    String guestEmail = (String) orderData.get("guestEmail");
    String guestName  = (String) orderData.get("guestName");
    String guestPhone = (String) orderData.get("guestPhone");

    if (guestEmail == null || guestName == null || guestPhone == null) {
      throw new IllegalStateException("비회원 주문 생성 시 필수 정보(이름/전화/이메일)가 누락되었습니다.");
    }

    // 1. 게스트 등록 or 기존 정보 사용
    GuestVO guest = guestService.getGuestByEmail(guestEmail);
    String guestId;
    if(guest == null){
      guestId = "G-" + System.currentTimeMillis();
      guest = new GuestVO();
      guest.setGuestId(guestId);
      guest.setGuestName(guestName);
      guest.setGuestPhone(guestPhone);
      guest.setGuestEmail(guestEmail);
      guestService.registerGuest(guest);
    }else{
      guestId = guest.getGuestId();
    }

    // 2. 주문 생성
    OrderVO newOrder = new OrderVO();
    newOrder.setOrderType(2);  // 비회원
    newOrder.setGuestId(guestId);
    newOrder.setOrderPassword((String) orderData.get("orderPassword"));
    newOrder.setReceiverName((String) orderData.get("receiverName"));
    newOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
    newOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    newOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    newOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    newOrder.setOrderStatus(1);

    // 3. 금액 검증
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");

    List<String> isbnList = new ArrayList<>();
    for (Map<String, Object> item : items) isbnList.add((String) item.get("isbn"));
    List<BookVO> booksInDb = orderDAO.selectBooksByIsbnList(isbnList);

    int serverCalculatedTotalPrice = 0;
    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      int quantity = (Integer) item.get("quantity");
      BookVO book = booksInDb.stream()
          .filter(b -> b.getIsbn().equals(isbn))
          .findFirst()
          .orElseThrow(() -> new IllegalStateException("상품 없음: " + isbn));
      serverCalculatedTotalPrice += book.getProductInfo().getDiscount() * quantity;
    }
    serverCalculatedTotalPrice += (serverCalculatedTotalPrice >= 50000 ? 0 : 3000);

    newOrder.setTotalPrice(serverCalculatedTotalPrice);
    
    // 4. 주문 저장
    orderDAO.insertOrder(newOrder);
    int orderId = newOrder.getOrderId();
    
    // 5. 주문 상세 저장 + 재고 차감
    List<OrderDetailVO> orderDetailList = new ArrayList<>();
    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      int quantity = (Integer) item.get("quantity");
      BookVO currentBook = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn)).findFirst().get();

      if(!orderDAO.updateBookStock(isbn, quantity)){
        throw new IllegalStateException("재고 부족: " + currentBook.getProductInfo().getTitle());
      }

      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(orderId);
      d.setBookNo(currentBook.getBookNo());
      d.setOrderCount(quantity);
      d.setOrderPrice(currentBook.getProductInfo().getDiscount());
      d.setRefundCheck(0);
      orderDetailList.add(d);
    }
    orderDAO.insertOrderDetailList(orderDetailList);

    // 6. 반환값
    Map<String, Object> result = new HashMap<>();
    result.put("orderId", orderId);
    result.put("guestId", guestId);
    result.put("orderName", orderData.get("orderName"));
    result.put("totalPrice", serverCalculatedTotalPrice);
    return result;
  }
  
  @Override
  public int getTotalOrderCount(String userId) {
    return orderDAO.getTotalOrderCount(userId);
  }

  @Override
  public List<OrderVO> getOrdersPaging(String userId, int start, int perPage) {
    return orderDAO.getOrdersPaging(userId, start, perPage);
  }

  @Override
  public List<OrderVO> findGuestOrdersByPasswordAndEmail(String orderPassword, String guestEmail) {
    return orderDAO.findGuestOrdersByPasswordAndEmail(orderPassword, guestEmail);
  }
  
  @Override
  public OrderVO getOrderById(int orderId) {
    return orderDAO.getOrderById(orderId);
  }

  @Override
  public OrderVO getGuestOrderByOrderId(int orderId) {
	  return orderDAO.getGuestOrderByOrderId(orderId);
  }

}
package com.bookGap.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
    orderDAO.insertOrder(order); // orderId 생성됨

    for(OrderDetailVO detail : details){
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

    for(Map<String, Object> item : items){
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
    List<OrderVO> rawOrderList = orderDAO.getOrdersByUserId(userId);

    Map<Integer, OrderVO> ordersMap = new LinkedHashMap<>();

    for(OrderVO orderItem : rawOrderList){
      OrderVO existingOrder = ordersMap.get(orderItem.getOrderId());
      
      if(existingOrder == null){
        ordersMap.put(orderItem.getOrderId(), orderItem);
      }else{
        existingOrder.getOrderDetails().add(orderItem.getOrderDetails().get(0));
      }
    }
    return new ArrayList<>(ordersMap.values());
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

    // --- 1. 프론트엔드에서 넘어온 핵심 데이터 추출 ---
    String userId = (String) orderData.get("userId");
    Integer userAddressId = (Integer) orderData.get("userAddressId");
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");

    // --- 2. 배송지 정보 조회 ---
    // 이 쿼리는 USER_ADDRESS 테이블과 USER 테이블을 JOIN해서
    // 주소 정보 + 받는 사람(user)의 이름/연락처를 UserAddressVO에 모두 담아옵니다.
    UserAddressVO deliveryAddress = orderDAO.findAddressByUserAddressId(userAddressId);
    
    // 만약 deliveryAddress 자체가 null이라면, 배송지 ID가 잘못된 것이므로 예외를 발생시킵니다.
    if (deliveryAddress == null) {
      throw new IllegalStateException("선택된 배송지 정보를 찾을 수 없습니다. (ID: " + userAddressId + ")");
    }
    
    // --- 3. 서버 측에서 주문 총액 재계산 (보안 강화) ---
    int serverCalculatedTotalPrice = 0;
    List<String> isbnList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      isbnList.add((String) item.get("isbn"));
    }

    // 주문하려는 상품들의 최신 정보를 DB에서 다시 가져옴
    List<BookVO> booksInDb = orderDAO.selectBooksByIsbnList(isbnList);
    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");
      
      BookVO book = booksInDb.stream()
                      .filter(b -> b.getIsbn().equals(isbn))
                      .findFirst()
                      .orElseThrow(() -> new IllegalStateException("주문 처리 중 상품 정보를 찾을 수 없습니다: " + isbn));
      
      serverCalculatedTotalPrice += book.getDiscount() * quantity;
    }

    serverCalculatedTotalPrice += (Integer) orderData.get("deliveryFee");
    
    // 프론트엔드에서 계산한 금액과 서버에서 계산한 금액이 다를 경우, 경고 로그를 남김
    if (serverCalculatedTotalPrice != (Integer) orderData.get("totalPrice")) {
       System.out.println("WARN: 가격 검증 불일치. 서버 계산가:" + serverCalculatedTotalPrice + ", 클라이언트 전달가:" + orderData.get("totalPrice"));
    }


    // --- 4. ORDERS 테이블에 저장할 OrderVO 객체 조립 ---
    OrderVO newOrder = new OrderVO();
    
    // 회원 정보 및 기본 주문 정보 설정
    newOrder.setUserId(userId);
    newOrder.setUserAddressId(userAddressId); 
    newOrder.setTotalPrice(serverCalculatedTotalPrice); // 반드시 서버에서 계산한 금액을 사용
    newOrder.setOrderStatus(1); // 1: 결제대기
    newOrder.setOrderType(1);   // 1: 회원 주문
    // newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest")); // JSP에 deliveryRequest input이 있다면 추가

    // 수신자 정보 설정
    String receiverName = deliveryAddress.getUserName();
    String receiverPhone = deliveryAddress.getUserPhone();
    
    // 수신자 정보 유효성 검사 (안전장치)
    if (receiverName == null || receiverName.trim().isEmpty()) {
        throw new IllegalStateException("배송지(" + userAddressId + ")에 연결된 사용자의 이름 정보가 없습니다.");
    }
    if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
        throw new IllegalStateException("배송지(" + userAddressId + ")에 연결된 사용자의 연락처 정보가 없습니다.");
    }
    newOrder.setReceiverName(receiverName);
    newOrder.setReceiverPhone(receiverPhone);
    newOrder.setReceiverPostCode(deliveryAddress.getPostCode());
    newOrder.setReceiverRoadAddress(deliveryAddress.getRoadAddress());
    newOrder.setReceiverDetailAddress(deliveryAddress.getDetailAddress());
    
    // --- 5. ORDERS 테이블에 저장 ---
    // 모든 정보가 완벽하게 채워진 후에 DB에 INSERT를 실행합니다.
    orderDAO.insertOrder(newOrder); 
    int newOrderId = newOrder.getOrderId(); // MyBatis의 useGeneratedKeys 덕분에 newOrder 객체에 id가 채워짐


    // --- 6. 재고 확인/감소 및 ORDER_DETAIL 테이블에 저장 ---
    List<OrderDetailVO> orderDetailList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");

      // DB에서 조회해둔 상품 목록에서 현재 상품 정보를 다시 찾음
      BookVO currentBook = booksInDb.stream()
                              .filter(b -> b.getIsbn().equals(isbn))
                              .findFirst().get();
      
      // DAO를 호출하여 재고 감소 시도
      boolean stockUpdated = orderDAO.updateBookStock(isbn, quantity);
      if (!stockUpdated) {
        // 재고 감소가 실패하면(0 rows updated), 거래 전체를 롤백시키기 위해 예외를 발생시킴
        throw new IllegalStateException("재고가 부족합니다: " + currentBook.getTitle());
      }

      // ORDER_DETAIL VO 생성 및 값 설정
      OrderDetailVO detail = new OrderDetailVO();
      detail.setOrderId(newOrderId);
      detail.setBookNo(currentBook.getBookNo());
      detail.setOrderCount(quantity);
      detail.setOrderPrice(currentBook.getDiscount());
      detail.setRefundCheck(0);
      
      orderDetailList.add(detail);
    }

    // 조립된 주문 상세 목록(상품 목록)을 DB에 한 번에 INSERT
    if (!orderDetailList.isEmpty()) {
      orderDAO.insertOrderDetailList(orderDetailList);
    }
    
    // --- 7. 최종적으로 생성된 주문 ID를 Controller로 반환 ---
    return newOrderId;
  }
  
  @Override
  @Transactional
  public Map<String, Object> createGuestOrderWithDetails(Map<String, Object> orderData) throws Exception {

    String guestEmail = (String) orderData.get("ordererEmail");
    GuestVO guest = guestService.getGuestByEmail(guestEmail);
    String guestId;
    
    if(guest == null){
      guest = new GuestVO();
      guestId = "G-" + System.currentTimeMillis();
      guest.setGuestId(guestId);
      guest.setGuestName((String) orderData.get("ordererName"));
      guest.setGuestPhone((String) orderData.get("ordererPhone"));
      guest.setGuestEmail(guestEmail);
      guestService.registerGuest(guest);
    }else{
      guestId = guest.getGuestId();
    }

    // --- 2. 서버 측에서 주문 총액 재계산 (회원 로직과 거의 동일) ---
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");
    int serverCalculatedTotalPrice = 0;
    List<String> isbnList = new ArrayList<>();
    for(Map<String, Object> item : items){
      // JSP에서 보낸 데이터의 key가 'isbn'인지 확인해야 합니다.
      isbnList.add((String) item.get("isbn")); 
    }
    List<BookVO> booksInDb = orderDAO.selectBooksByIsbnList(isbnList);

    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");
      BookVO book = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn))
                                      .findFirst()
                                      .orElseThrow(() -> new IllegalStateException("상품 정보를 찾을 수 없습니다: " + isbn));
      serverCalculatedTotalPrice += book.getDiscount() * quantity;
    }
    serverCalculatedTotalPrice += (serverCalculatedTotalPrice >= 50000 ? 0 : 3000); // 배송비 계산

    // --- 3. ORDERS 테이블에 들어갈 OrderVO 객체 조립 및 저장 ---
    OrderVO guestOrder = new OrderVO();
    
    // 비회원 정보 설정
    guestOrder.setGuestId(guestId);
    guestOrder.setOrderPassword((String) orderData.get("orderPassword"));

    // 공통 정보 설정
    guestOrder.setTotalPrice(serverCalculatedTotalPrice);
    guestOrder.setOrderStatus(1); // 1: 결제대기
    guestOrder.setOrderType(2);   // 2: 비회원 주문

    // 수신자 정보 설정 (Map에서 직접 가져옴)
    guestOrder.setReceiverName((String) orderData.get("receiverName"));
    guestOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
    guestOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    guestOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    guestOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    guestOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));

    // DAO를 호출하여 ORDERS 테이블에 INSERT
    orderDAO.insertOrder(guestOrder); 
    int newOrderId = guestOrder.getOrderId(); // 생성된 주문 ID

    // --- 4. 재고 확인 및 감소, 그리고 ORDER_DETAIL 테이블에 저장 ---
    List<OrderDetailVO> orderDetailList = new ArrayList<>();
    for(Map<String, Object> item : items){
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");

      BookVO currentBook = booksInDb.stream().filter(b -> b.getIsbn().equals(isbn))
                                             .findFirst().get();
      
      boolean stockUpdated = orderDAO.updateBookStock(isbn, quantity);
      if(!stockUpdated){
        throw new IllegalStateException("재고가 부족합니다: " + currentBook.getTitle());
      }

      OrderDetailVO detail = new OrderDetailVO();
      detail.setOrderId(newOrderId);
      detail.setBookNo(currentBook.getBookNo());
      detail.setOrderCount(quantity);
      detail.setOrderPrice(currentBook.getDiscount());
      detail.setRefundCheck(0); // 0: 환불/교환 없음
      
      orderDetailList.add(detail);
    }
    orderDAO.insertOrderDetailList(orderDetailList);
    
    Map<String, Object> result = new HashMap<>();
    result.put("orderId", newOrderId);
    result.put("guestId", guestId); 
    
    return result;
  }

}
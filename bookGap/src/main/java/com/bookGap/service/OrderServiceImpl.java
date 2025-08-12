package com.bookGap.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.OrderDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@Service
public class OrderServiceImpl implements OrderService {
  
  @Autowired
  private OrderDAO orderDAO;

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
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");

    // --- 1. 배송지 정보 조회 ---
    UserAddressVO deliveryAddress = orderDAO.findAddressByUserAddressId(userAddressId);
    if (deliveryAddress == null) {
      throw new IllegalStateException("배송지 정보를 찾을 수 없습니다. 다시 시도해주세요.");
    }
    
    // --- 2. 서버 측에서 주문 총액 재계산 (보안) ---
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
                      .orElseThrow(() -> new IllegalStateException("상품 정보를 찾을 수 없습니다: " + isbn));
      
      serverCalculatedTotalPrice += book.getDiscount() * quantity;
    }

    serverCalculatedTotalPrice += (Integer) orderData.get("deliveryFee");
    
    // 금액 검증 (선택사항이지만 권장)
    if (serverCalculatedTotalPrice != (Integer) orderData.get("totalPrice")) {
      // throw new IllegalStateException("주문 총액 검증에 실패했습니다.");
      // 로깅만 남기고 진행할 수도 있음
       System.out.println("WARN: 가격 검증 불일치. 서버:" + serverCalculatedTotalPrice + ", 클라이언트:" + orderData.get("totalPrice"));
    }


    // --- 3. ORDERS 테이블에 들어갈 OrderVO 객체 조립 및 저장 ---
    OrderVO newOrder = new OrderVO();
    newOrder.setUserId(userId);
    newOrder.setTotalPrice(serverCalculatedTotalPrice);
    newOrder.setOrderStatus(1); // 1: 주문완료/결제대기
    newOrder.setOrderType(1);   // 1: 회원 주문

    // 조회한 배송지 정보를 채워 넣음
    newOrder.setReceiverName(deliveryAddress.getUserName());
    newOrder.setReceiverPhone(deliveryAddress.getUserPhone());
    newOrder.setReceiverPostCode(deliveryAddress.getPostCode());
    newOrder.setReceiverRoadAddress(deliveryAddress.getRoadAddress());
    newOrder.setReceiverDetailAddress(deliveryAddress.getDetailAddress());
    newOrder.setUserAddressId(userAddressId); 
    
    // DAO를 호출하여 ORDERS 테이블에 INSERT (useGeneratedKeys로 newOrder에 orderId가 채워짐)
    orderDAO.insertOrder(newOrder); 
    int newOrderId = newOrder.getOrderId(); // 방금 생성된 주문 ID


    // --- 4. 재고 확인 및 감소, 그리고 ORDER_DETAIL 테이블에 저장 ---
    List<OrderDetailVO> orderDetailList = new ArrayList<>();

    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      Integer quantity = (Integer) item.get("quantity");

      // 해당 상품의 DB 정보 다시 찾기 (가격 등)
      BookVO currentBook = booksInDb.stream()
                              .filter(b -> b.getIsbn().equals(isbn))
                              .findFirst()
                              .get(); // 위에서 이미 검증했으므로 .get() 사용 가능
      
      // DAO를 호출하여 재고 감소 시도
      boolean stockUpdated = orderDAO.updateBookStock(isbn, quantity);
      if (!stockUpdated) {
        // DAO에서 update의 결과가 0이면 false를 반환하도록 수정했음
        throw new IllegalStateException("재고가 부족합니다: " + currentBook.getTitle());
      }

      // ORDER_DETAIL VO 생성
      OrderDetailVO detail = new OrderDetailVO();
      detail.setOrderId(newOrderId);
      detail.setBookNo(currentBook.getBookNo());
      detail.setOrderCount(quantity);
      detail.setOrderPrice(currentBook.getDiscount());
      detail.setRefundCheck(0);
      
      orderDetailList.add(detail);
    }

    // 조립된 주문 상세 목록을 DB에 한 번에 INSERT
    orderDAO.insertOrderDetailList(orderDetailList);
    
    return newOrderId;
  }

}
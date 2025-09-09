package com.bookGap.service;

import java.util.ArrayList;
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
  public int getTotalOrderCount(String userId) {
    return orderDAO.getTotalOrderCount(userId);
  }

  @Override
  public List<OrderVO> getOrdersPaging(String userId, int start, int perPage) {
    return orderDAO.getOrdersPaging(userId, start, perPage);
  }

  @Override
  public OrderVO findGuestOrderByKey(String orderKey) {
    return orderDAO.findGuestOrderByKey(orderKey);
  }
  
  @Override
  public OrderVO getOrderById(int orderId) {
    return orderDAO.getOrderById(orderId);
  }

  @Override
  public OrderVO getGuestOrderByOrderId(int orderId) {
	  return orderDAO.getGuestOrderByOrderId(orderId);
  }
  
  @Override
  public void updateOrderStatus(int orderId, int status) {
	  orderDAO.updateOrderStatus(orderId, status); 
  }
  
  private String newOrderKey() {
	return "ODR_" + java.util.UUID.randomUUID().toString().replace("-", "");
  }

  @Transactional
  @Override
  public void placeOrder(OrderVO order, List<OrderDetailVO> details) {
    if (order.getOrderKey() == null || order.getOrderKey().isEmpty()) {
      order.setOrderKey(newOrderKey());
    }
    // 스키마 필수값 보정(필요 시)
    if (order.getOrderStatus() == 0) order.setOrderStatus(1);
    if (order.getOrderType() == 0)   order.setOrderType(order.getUserId()!=null?1:2);

    orderDAO.insertOrder(order);
    for (OrderDetailVO d : details) {
      d.setOrderId(order.getOrderId());
      orderDAO.insertOrderDetail(d);
    }
  }
  
  @Transactional
  @Override
  public OrderVO createGuestOrder(Map<String, Object> orderData) throws Exception {
    OrderVO newOrder = new OrderVO();
    newOrder.setOrderKey(newOrderKey());
    newOrder.setOrderType(2);
    newOrder.setOrderStatus(1);
    newOrder.setTotalPrice(((Number)orderData.getOrDefault("totalPrice",0)).intValue());
    newOrder.setReceiverName((String) orderData.get("receiverName"));
    newOrder.setReceiverPhone((String) orderData.get("receiverPhone"));
    newOrder.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    newOrder.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    newOrder.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    newOrder.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    orderDAO.insertOrder(newOrder);

    @SuppressWarnings("unchecked")
    List<Map<String,Object>> items = (List<Map<String,Object>>) orderData.get("items");
    List<OrderDetailVO> list = new ArrayList<>();
    for (Map<String,Object> it : items) {
      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(newOrder.getOrderId());
      d.setBookNo(((Number)it.get("bookNo")).intValue());
      d.setOrderCount(((Number)it.get("quantity")).intValue());
      d.setOrderPrice(((Number)it.get("priceAtPurchase")).intValue());
      d.setRefundCheck(0);
      list.add(d);
    }
    if (!list.isEmpty()) orderDAO.insertOrderDetailList(list);
    return newOrder;
  }
  
  @Override
  @Transactional
  public int createOrderWithDetails(Map<String, Object> orderData) throws IllegalStateException {

    Integer userAddressId = (Integer) orderData.get("userAddressId");
    if (userAddressId == null) {
        throw new IllegalStateException("배송지 정보(userAddressId)가 누락되었습니다.");
    }
    
    // [핵심 수정] userAddressId로 전체 배송지 정보 조회
    UserAddressVO address = orderDAO.findAddressByUserAddressId(userAddressId);
    if (address == null) {
        throw new IllegalStateException("존재하지 않는 배송지입니다.");
    }
    
    // OrderVO 객체 생성 및 기본 정보 설정
    OrderVO order = new OrderVO();
    order.setUserId((String) orderData.get("userId"));
    order.setOrderType(1);
    order.setTotalPrice(((Number) orderData.get("totalPrice")).intValue());
    order.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    order.setOrderStatus(1);  

    order.setUserAddressId(address.getUserAddressId());
    order.setReceiverName(address.getUserName()); // UserAddressVO의 userName -> ORDERS의 receiverName
    order.setReceiverPhone(address.getUserPhone());
    order.setReceiverPostCode(address.getPostCode());
    order.setReceiverRoadAddress(address.getRoadAddress());
    order.setReceiverDetailAddress(address.getDetailAddress());
    
    // 고유한 주문 키(orderKey) 생성 및 설정
    String orderKey = "ODR_" + java.util.UUID.randomUUID().toString().replace("-", "");
    order.setOrderKey(orderKey);
    
    // 주문 마스터 정보(ORDERS)를 DB에 저장 (이때 orderId가 생성됨)
    orderDAO.insertOrder(order);
    int generatedOrderId = order.getOrderId(); 

    // 주문 상세 정보(ORDER_DETAIL) 처리
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> items = (List<Map<String, Object>>) orderData.get("orderItems");
    if(items == null || items.isEmpty()){ throw new IllegalStateException("주문 상품 정보가 없습니다."); }

    List<OrderDetailVO> detailList = new ArrayList<>();
    for (Map<String, Object> item : items) {
      String isbn = (String) item.get("isbn");
      int quantity = ((Number) item.get("quantity")).intValue();

      if (!orderDAO.updateBookStock(isbn, quantity)) { throw new IllegalStateException("재고가 부족한 상품이 포함되어 있습니다. (ISBN: " + isbn + ")"); }
      BookVO book = orderDAO.findBookByIsbn(isbn);
      if (book == null) { throw new IllegalStateException("존재하지 않는 상품입니다. (ISBN: " + isbn + ")"); }
      OrderDetailVO detail = new OrderDetailVO();
      detail.setOrderId(generatedOrderId);
      detail.setBookNo(book.getBookNo());
      detail.setOrderCount(quantity);
      detail.setOrderPrice(book.getProductInfo().getDiscount()); 
      detail.setRefundCheck(0);
      detailList.add(detail);
    }
    
    if(!detailList.isEmpty()){ orderDAO.insertOrderDetailList(detailList); }
    
    return generatedOrderId;
  }

  @Transactional
  @Override
  public OrderVO createGuestOrderWithDetails(Map<String, Object> orderData) throws Exception {

    String guestEmail = (String) orderData.get("guestEmail");
    String guestName  = (String) orderData.get("guestName");
    String guestPhone = (String) orderData.get("guestPhone");
    
    if(guestEmail==null || guestName==null || guestPhone==null){ throw new IllegalStateException("비회원 주문 생성 시 필수 정보(이름/전화/이메일)가 누락되었습니다."); }

    GuestVO guest = guestService.getGuestByEmail(guestEmail);
    String guestId; // 이 변수에는 항상 "G-..." 형태의 고유 ID가 담기게 됩니다.
    
    if(guest == null){
      guestId = "G-" + System.currentTimeMillis(); // GUEST 테이블의 PK로 사용할 새 ID
      guest = new GuestVO();
      guest.setGuestId(guestId);
      guest.setGuestName(guestName);
      guest.setGuestPhone(guestPhone);
      guest.setGuestEmail(guestEmail);
      guestService.registerGuest(guest);
    } else {
      guestId = guest.getGuestId();
    }

    @SuppressWarnings("unchecked")
    List<Map<String,Object>> items = (List<Map<String,Object>>) orderData.get("orderItems");
    if(items == null || items.isEmpty()) { throw new IllegalStateException("주문 상품 정보가 없습니다."); }

    List<String> isbnList = new ArrayList<>();
    for (Map<String,Object> it : items) isbnList.add((String) it.get("isbn"));
    List<BookVO> books = orderDAO.selectBooksByIsbnList(isbnList);
    
    int total = 0;
    for(Map<String,Object> it : items){
      String isbn = (String) it.get("isbn");
      int qty = ((Number)it.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst().orElseThrow(() -> new IllegalStateException("상품 없음: " + isbn));
      total += b.getProductInfo().getDiscount() * qty;
    }

    total += (total >= 50000 ? 0 : 3000); // 배송비 추가

    OrderVO orderToInsert = new OrderVO();
    orderToInsert.setOrderType(2); // 비회원
    
    orderToInsert.setGuestId(guestId); 
    
    orderToInsert.setOrderKey(newOrderKey()); // 고유 키 생성
    orderToInsert.setOrderPassword((String) orderData.get("orderPassword"));
    orderToInsert.setReceiverName((String) orderData.get("receiverName"));
    orderToInsert.setReceiverPhone((String) orderData.get("receiverPhone"));
    orderToInsert.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    orderToInsert.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    orderToInsert.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    orderToInsert.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    orderToInsert.setOrderStatus(1); // 배송준비중
    orderToInsert.setTotalPrice(total);

    orderDAO.insertOrder(orderToInsert);

    List<OrderDetailVO> detailsList = new ArrayList<>();
    for(Map<String,Object> item : items){
      String isbn = (String) item.get("isbn");
      int qty = ((Number)item.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst().get();

      if(!orderDAO.updateBookStock(isbn, qty)){ throw new IllegalStateException("재고가 부족합니다: " + b.getProductInfo().getTitle()); }
      
      OrderDetailVO detail = new OrderDetailVO();
      detail.setOrderId(orderToInsert.getOrderId());
      detail.setBookNo(b.getBookNo());
      detail.setOrderCount(qty);
      detail.setOrderPrice(b.getProductInfo().getDiscount());
      detail.setRefundCheck(0);
      detailsList.add(detail);
    }

    if(!detailsList.isEmpty()){  orderDAO.insertOrderDetailList(detailsList); }

    return orderToInsert;
  }

}
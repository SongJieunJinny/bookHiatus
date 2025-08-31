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
  
  @Transactional
  @Override
  public int createOrderWithDetails(Map<String,Object> orderData) {
    String userId = (String) orderData.get("userId");
    Integer userAddressId = (Integer) orderData.get("userAddressId");
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> items = (List<Map<String,Object>>) orderData.get("orderItems");

    UserAddressVO addr = orderDAO.findAddressByUserAddressId(userAddressId);
    if (addr == null) throw new IllegalStateException("선택된 배송지 정보를 찾을 수 없습니다. (ID: " + userAddressId + ")");

    int total = 0;
    List<String> isbnList = new ArrayList<>();
    for (Map<String,Object> it : items) isbnList.add((String) it.get("isbn"));
    List<BookVO> books = orderDAO.selectBooksByIsbnList(isbnList);
    for (Map<String,Object> it : items) {
      String isbn = (String) it.get("isbn");
      int qty = ((Number)it.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst()
              .orElseThrow(() -> new IllegalStateException("주문 처리 중 상품 정보를 찾을 수 없습니다: " + isbn));
      total += b.getProductInfo().getDiscount() * qty;
    }
    total += ((Number)orderData.get("deliveryFee")).intValue();

    OrderVO o = new OrderVO();
    o.setUserId(userId);
    o.setUserAddressId(userAddressId);
    o.setOrderKey(newOrderKey());
    o.setTotalPrice(total);
    o.setOrderStatus(1);
    o.setOrderType(1);
    o.setReceiverName(addr.getUserName());
    o.setReceiverPhone(addr.getUserPhone());
    o.setReceiverPostCode(addr.getPostCode());
    o.setReceiverRoadAddress(addr.getRoadAddress());
    o.setReceiverDetailAddress(addr.getDetailAddress());
    o.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    orderDAO.insertOrder(o);

    List<OrderDetailVO> ds = new ArrayList<>();
    for (Map<String,Object> it : items) {
      String isbn = (String) it.get("isbn");
      int qty = ((Number)it.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst().get();
      if (!orderDAO.updateBookStock(isbn, qty)) {
        throw new IllegalStateException("재고가 부족합니다: " + b.getProductInfo().getTitle());
      }
      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(o.getOrderId());
      d.setBookNo(b.getBookNo());
      d.setOrderCount(qty);
      d.setOrderPrice(b.getProductInfo().getDiscount());
      d.setRefundCheck(0);
      ds.add(d);
    }
    if (!ds.isEmpty()) orderDAO.insertOrderDetailList(ds);
    return o.getOrderId();
  }

  @Transactional
  @Override
  public Map<String,Object> createGuestOrderWithDetails(Map<String,Object> orderData) throws Exception {
    String guestEmail = (String) orderData.get("guestEmail");
    String guestName  = (String) orderData.get("guestName");
    String guestPhone = (String) orderData.get("guestPhone");
    if (guestEmail==null || guestName==null || guestPhone==null) {
      throw new IllegalStateException("비회원 주문 생성 시 필수 정보(이름/전화/이메일)가 누락되었습니다.");
    }

    GuestVO guest = guestService.getGuestByEmail(guestEmail);
    String guestId;
    if (guest == null) {
      guestId = "G-" + System.currentTimeMillis();
      guest = new GuestVO();
      guest.setGuestId(guestId);
      guest.setGuestName(guestName);
      guest.setGuestPhone(guestPhone);
      guest.setGuestEmail(guestEmail);
      guestService.registerGuest(guest);
    } else guestId = guest.getGuestId();

    @SuppressWarnings("unchecked")
    List<Map<String,Object>> items = (List<Map<String,Object>>) orderData.get("orderItems");
    List<String> isbnList = new ArrayList<>();
    for (Map<String,Object> it : items) isbnList.add((String) it.get("isbn"));
    List<BookVO> books = orderDAO.selectBooksByIsbnList(isbnList);

    int total = 0;
    for (Map<String,Object> it : items) {
      String isbn = (String) it.get("isbn");
      int qty = ((Number)it.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst()
              .orElseThrow(() -> new IllegalStateException("상품 없음: " + isbn));
      total += b.getProductInfo().getDiscount() * qty;
    }
    total += (total >= 50000 ? 0 : 3000);

    OrderVO o = new OrderVO();
    o.setOrderType(2);
    o.setGuestId(guestId);
    o.setOrderKey(newOrderKey());
    o.setOrderPassword((String) orderData.get("orderPassword"));
    o.setReceiverName((String) orderData.get("receiverName"));
    o.setReceiverPhone((String) orderData.get("receiverPhone"));
    o.setReceiverPostCode((String) orderData.get("receiverPostCode"));
    o.setReceiverRoadAddress((String) orderData.get("receiverRoadAddress"));
    o.setReceiverDetailAddress((String) orderData.get("receiverDetailAddress"));
    o.setDeliveryRequest((String) orderData.get("deliveryRequest"));
    o.setOrderStatus(1);
    o.setTotalPrice(total);
    orderDAO.insertOrder(o);

    List<OrderDetailVO> ds = new ArrayList<>();
    for (Map<String,Object> it : items) {
      String isbn = (String) it.get("isbn");
      int qty = ((Number)it.get("quantity")).intValue();
      BookVO b = books.stream().filter(v->v.getIsbn().equals(isbn)).findFirst().get();
      if (!orderDAO.updateBookStock(isbn, qty)) {
        throw new IllegalStateException("재고 부족: " + b.getProductInfo().getTitle());
      }
      OrderDetailVO d = new OrderDetailVO();
      d.setOrderId(o.getOrderId());
      d.setBookNo(b.getBookNo());
      d.setOrderCount(qty);
      d.setOrderPrice(b.getProductInfo().getDiscount());
      d.setRefundCheck(0);
      ds.add(d);
    }
    if (!ds.isEmpty()) orderDAO.insertOrderDetailList(ds);

    Map<String,Object> result = new HashMap<>();
    result.put("orderId", o.getOrderId());
    result.put("guestId", guestId);
    result.put("orderKey", o.getOrderKey());
    result.put("orderName", orderData.get("orderName"));
    result.put("totalPrice", total);
    return result;
  }

}
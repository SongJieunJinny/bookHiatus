package com.bookGap.vo;

import java.sql.Timestamp;
import java.util.List;

public class OrderVO {
  private int orderId; //주문 번호
  private Timestamp orderDate; //주문 내용
  private int orderStatus;  //주문상태(1 배송준비중,2 배송중,3 배송완료, 4 배송취소, 5 교환/반품)
  private int totalPrice;  //총주문금액
  private int orderType;  //주문타입(1 회원, 2비회원)
  private String userId; //아이디
  private String guestId;  //비회원아이디
  private Integer cartNo;   //장바구니번호
  
  /* JSP 출력용 */
  private int displayNo;
  private String formattedOrderDate;
  private List<OrderDetailVO> orderDetails;
  
  public List<OrderDetailVO> getOrderDetails() {
    return orderDetails;
  }
  public void setOrderDetails(List<OrderDetailVO> orderDetails) {
    this.orderDetails = orderDetails;
  }
  public int getOrderId() {
    return orderId;
  }
  public void setOrderId(int orderId) {
    this.orderId = orderId;
  }
  public Timestamp getOrderDate() {
    return orderDate;
  }
  public void setOrderDate(Timestamp orderDate) {
    this.orderDate = orderDate;
  }
  public int getOrderStatus() {
    return orderStatus;
  }
  public void setOrderStatus(int orderStatus) {
    this.orderStatus = orderStatus;
  }
  public int getTotalPrice() {
    return totalPrice;
  }
  public void setTotalPrice(int totalPrice) {
    this.totalPrice = totalPrice;
  }
  public int getOrderType() {
    return orderType;
  }
  public void setOrderType(int orderType) {
    this.orderType = orderType;
  }
  public String getUserId() {
    return userId;
  }
  public void setUserId(String userId) {
    this.userId = userId;
  }
  public String getGuestId() {
    return guestId;
  }
  public void setGuestId(String guestId) {
    this.guestId = guestId;
  }
  public Integer getCartNo() {
    return cartNo;
  }
  public void setCartNo(Integer cartNo) {
    this.cartNo = cartNo;
  }
  public int getDisplayNo() {
    return displayNo;
  }
  public void setDisplayNo(int displayNo) {
    this.displayNo = displayNo;
  }
  public String getFormattedOrderDate() {
    return formattedOrderDate;
  }
  public void setFormattedOrderDate(String formattedOrderDate) {
    this.formattedOrderDate = formattedOrderDate;
  }
  
}
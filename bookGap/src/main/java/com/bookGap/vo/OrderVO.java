package com.bookGap.vo;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class OrderVO {
  private int orderId;
  private Timestamp orderDate;
  private int orderStatus;
  private int totalPrice;
  private int orderType;
  private String userId;
  private String guestId;
  private int cartNo;
  private int userAddressId;
  private String receiverName;
  private String receiverPhone;
  private String receiverPostCode;
  private String receiverRoadAddress;
  private String receiverDetailAddress;
  private String deliveryRequest;
  private String orderPassword;
  private List<OrderDetailVO> orderDetails;
  
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
  public int getCartNo() {
    return cartNo;
  }
  public void setCartNo(int cartNo) {
    this.cartNo = cartNo;
  }
  public int getUserAddressId() {
    return userAddressId;
  }
  public void setUserAddressId(int userAddressId) {
    this.userAddressId = userAddressId;
  }
  public String getReceiverName() {
    return receiverName;
  }
  public void setReceiverName(String receiverName) {
    this.receiverName = receiverName;
  }
  public String getReceiverPhone() {
    return receiverPhone;
  }
  public void setReceiverPhone(String receiverPhone) {
    this.receiverPhone = receiverPhone;
  }
  public String getReceiverPostCode() {
    return receiverPostCode;
  }
  public void setReceiverPostCode(String receiverPostCode) {
    this.receiverPostCode = receiverPostCode;
  }
  public String getReceiverRoadAddress() {
    return receiverRoadAddress;
  }
  public void setReceiverRoadAddress(String receiverRoadAddress) {
    this.receiverRoadAddress = receiverRoadAddress;
  }
  public String getReceiverDetailAddress() {
    return receiverDetailAddress;
  }
  public void setReceiverDetailAddress(String receiverDetailAddress) {
    this.receiverDetailAddress = receiverDetailAddress;
  }
  public String getDeliveryRequest() {
    return deliveryRequest;
  }
  public void setDeliveryRequest(String deliveryRequest) {
    this.deliveryRequest = deliveryRequest;
  }
  public String getOrderPassword() {
    return orderPassword;
  }
  public void setOrderPassword(String orderPassword) {
    this.orderPassword = orderPassword;
  }
  public List<OrderDetailVO> getOrderDetails() {
    return orderDetails;
  }
  public void setOrderDetails(List<OrderDetailVO> orderDetails) {
    this.orderDetails = orderDetails;
  }
  
}
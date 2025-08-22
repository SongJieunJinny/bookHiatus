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
  private PaymentVO payment; 
  private String courier; // 택배사
  private String invoice; // 송장번호

  //===================== 게스트주문필요 필드 =====================
  private String guestName;
  private String guestPhone;
  private String guestEmail;
  
  // ===================== equals/hashCode: orderId 기준 =====================
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof OrderVO)) return false;
    OrderVO other = (OrderVO) o;
    return this.orderId == other.orderId;
  }

  @Override
  public int hashCode() {
    return Integer.hashCode(orderId);
  }
  
  //===================== 편의 메서드 =====================
  public String getFormattedOrderDate() {
    if (orderDate == null) return "-";
    return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(orderDate);
  }

  public String getOrderStatusText() {
    switch (orderStatus) {
      case 1: return "배송 준비중";
      case 2: return "배송 중";
      case 3: return "배송 완료";
      case 4: return "주문 취소";
      case 5: return "교환/반품";
      default: return "-";
    }
  }

  //===================== getter&setter =====================
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

  public PaymentVO getPayment() {
    return payment;
  }

  public void setPayment(PaymentVO payment) {
    this.payment = payment;
  }

  public String getGuestName() {
    return guestName;
  }

  public void setGuestName(String guestName) {
    this.guestName = guestName;
  }

  public String getGuestPhone() {
    return guestPhone;
  }

  public void setGuestPhone(String guestPhone) {
    this.guestPhone = guestPhone;
  }

  public String getGuestEmail() {
    return guestEmail;
  }

  public void setGuestEmail(String guestEmail) {
    this.guestEmail = guestEmail;
  }

public String getCourier() {
	return courier;
}

public void setCourier(String courier) {
	this.courier = courier;
}

public String getInvoice() {
	return invoice;
}

public void setInvoice(String invoice) {
	this.invoice = invoice;
}
  
  
}
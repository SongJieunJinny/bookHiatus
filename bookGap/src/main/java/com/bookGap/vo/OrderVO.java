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
  private int userAddressId; 

  private String receiverName;            // 수취인 이름
  private String receiverPhone;           // 수취인 연락처
  private String receiverPostCode;        // 수취인 우편번호
  private String receiverRoadAddress;     // 수취인 도로명주소
  private String receiverDetailAddress;   // 수취인 상세주소
  private String deliveryRequest;         // 배송 요청사항
  private String orderPassword;           // 비회원 주문 조회용 비밀번호

  /* --- JSP 출력용 (기존 필드) --- */
  private int displayNo;
  private String formattedOrderDate;
  private List<OrderDetailVO> orderDetails;
  private PaymentVO payment; 
  
  
  public PaymentVO getPayment() {
	return payment;
}

public void setPayment(PaymentVO payment) {
	this.payment = payment;
}

public List<OrderDetailVO> getOrderDetails() {
    return orderDetails;
  }
  
  public int getUserAddressId() {
    return userAddressId;
  }
  public void setUserAddressId(int userAddressId) {
    this.userAddressId = userAddressId;
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
	    if (orderDate == null) return "-";
	    return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(orderDate);
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

}
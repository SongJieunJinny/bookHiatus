package com.bookGap.vo;

import java.sql.Timestamp;

public class RefundVO {
  
  private int refundNo;          // 환불번호
  private int orderId;           // 주문ID
  private int paymentNo;         // 결제ID
  private String refundReason;   // 환불사유
  private String refundMail;     // 이메일
  private int refundStatus;      // 환불상태(1 요청, 2 처리중, 3 완료, 4 거절)
  private Timestamp createdAt;   // 신청일시
  
  
  private String userId;         // ORDERS.USER_ID
  private String guestId;        // ORDERS.GUEST_ID
  private Integer orderStatus;   // ORDERS.ORDER_STATUS
  private Integer paymentMethod; // PAYMENTS.PAYMENT_METHOD
  private Integer paymentStatus; // PAYMENTS.STATUS

  public String getRefundStatusText() {
    switch (refundStatus) {
      case 1: return "환불 요청";
      case 2: return "처리 중";
      case 3: return "환불 완료";
      case 4: return "거절";
      default: return "-";
    }
  }
  
  //getter / setter
  
  
  public int getRefundNo() {
    return refundNo;
  }
  public void setRefundNo(int refundNo) {
    this.refundNo = refundNo;
  }
  public int getOrderId() {
    return orderId;
  }
  public void setOrderId(int orderId) {
    this.orderId = orderId;
  }
  public int getPaymentNo() {
    return paymentNo;
  }
  public void setPaymentNo(int paymentNo) {
    this.paymentNo = paymentNo;
  }
  public String getRefundReason() {
    return refundReason;
  }
  public void setRefundReason(String refundReason) {
    this.refundReason = refundReason;
  }
  public String getRefundMail() {
    return refundMail;
  }
  public void setRefundMail(String refundMail) {
    this.refundMail = refundMail;
  }
  public int getRefundStatus() {
    return refundStatus;
  }
  public void setRefundStatus(int refundStatus) {
    this.refundStatus = refundStatus;
  }
  public Timestamp getCreatedAt() {
    return createdAt;
  }
  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
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

  public Integer getOrderStatus() {
    return orderStatus;
  }

  public void setOrderStatus(Integer orderStatus) {
    this.orderStatus = orderStatus;
  }

  public Integer getPaymentMethod() {
    return paymentMethod;
  }

  public void setPaymentMethod(Integer paymentMethod) {
    this.paymentMethod = paymentMethod;
  }

  public Integer getPaymentStatus() {
    return paymentStatus;
  }

  public void setPaymentStatus(Integer paymentStatus) {
    this.paymentStatus = paymentStatus;
  }
  
  
  
  
}
package com.bookGap.vo;

import java.sql.Timestamp;

public class RefundVO {
  
  private int refundNo;          // 환불번호
  private int orderId;           // 주문ID
  private int paymentNo;         // 결제ID
  private String refundReason;   // 환불사유
  private String refundImage;    // 환불사유사진
  private String refundMail;     // 이메일
  private int refundStatus;      // 환불상태(1 요청, 2 처리중, 3 완료, 4 거절)
  private Timestamp createdAt;   // 신청일시
  
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
  public String getRefundImage() {
    return refundImage;
  }
  public void setRefundImage(String refundImage) {
    this.refundImage = refundImage;
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
  
}
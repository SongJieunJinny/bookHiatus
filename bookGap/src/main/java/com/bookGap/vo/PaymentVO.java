package com.bookGap.vo;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PaymentVO {
  private int paymentNo;  //결제ID
  private BigDecimal amount;  //결제금액
  private int paymentMethod;  //결제수단(1 toss, 2 kakaopay)
  private int status;  //결제상태(1 결제중,2 결제승인,3 결제취소)
  private Timestamp createdAt;  //결제요청시간
  private int orderId;  //주문 번호
  private String userId;  //회원아이디
  private String guestId;  //비회원아이디
  
  public int getPaymentNo() {
    return paymentNo;
  }
  public void setPaymentNo(int paymentNo) {
    this.paymentNo = paymentNo;
  }
  public BigDecimal getAmount() {
    return amount;
  }
  public void setAmount(BigDecimal amount) {
    this.amount = amount;
  }
  public int getPaymentMethod() {
    return paymentMethod;
  }
  public void setPaymentMethod(int paymentMethod) {
    this.paymentMethod = paymentMethod;
  }
  public int getStatus() {
    return status;
  }
  public void setStatus(int status) {
    this.status = status;
  }
  public Timestamp getCreatedAt() {
    return createdAt;
  }
  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }
  public int getOrderId() {
    return orderId;
  }
  public void setOrderId(int orderId) {
    this.orderId = orderId;
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
  
}
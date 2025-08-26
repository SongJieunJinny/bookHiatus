package com.bookGap.vo;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PaymentVO {
  private int paymentNo;  //결제ID
  private BigDecimal amount;  //결제금액
  private Integer paymentMethod;  //결제수단(1 toss, 2 kakaopay)
  private int status;  //결제상태(1 결제중,2 결제승인,3 결제취소)
  private Timestamp createdAt;  //결제요청시간
  private int orderId;  //주문 번호
  private String userId;  //회원아이디
  private String guestId;  //비회원아이디
  
  /** 결제상태 한글 변환 */
  public String getStatusText() {
    switch (status) {
      case 1: return "결제중";
      case 2: return "결제승인";
      case 3: return "결제취소";
      default: return "알수없음";
    }
  }
  
  /** 결제수단 한글 변환 */
  public String getPaymentMethodText() {
    switch (paymentMethod) {
      case 1: return "토스";
      case 2: return "카카오페이";
      default: return "기타";
    }
  }
  
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
  public Integer getPaymentMethod() {
    return paymentMethod;
  }
  public void setPaymentMethod(Integer paymentMethod) {
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
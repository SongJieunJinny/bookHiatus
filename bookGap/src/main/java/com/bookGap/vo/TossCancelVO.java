package com.bookGap.vo;

public class TossCancelVO {
  private int paymentNo;  //결제ID
  private String paymentKey;  //결제승인키
  private String cancelReason;  //결제취소이유
  
  public int getPaymentNo() {
    return paymentNo;
  }
  public void setPaymentNo(int paymentNo) {
    this.paymentNo = paymentNo;
  }
  public String getPaymentKey() {
    return paymentKey;
  }
  public void setPaymentKey(String paymentKey) {
    this.paymentKey = paymentKey;
  }
  public String getCancelReason() {
    return cancelReason;
  }
  public void setCancelReason(String cancelReason) {
    this.cancelReason = cancelReason;
  }

}
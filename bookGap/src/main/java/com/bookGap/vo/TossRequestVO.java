package com.bookGap.vo;

public class TossRequestVO {
  private int paymentNo;  //결제ID
  private String customerKey;  //고객식별키
  private String orderName;  //상품명
  private String successUrl;  //결제성공URL
  private String failUrl;  //결제실패URL
  private String paymentKey;  //결제승인키
  private String orderId;  //토스 orderId
  private int amount;  //결제금액
  
  public int getPaymentNo() {
    return paymentNo;
  }
  public void setPaymentNo(int paymentNo) {
    this.paymentNo = paymentNo;
  }
  public String getCustomerKey() {
    return customerKey;
  }
  public void setCustomerKey(String customerKey) {
    this.customerKey = customerKey;
  }
  public String getOrderName() {
    return orderName;
  }
  public void setOrderName(String orderName) {
    this.orderName = orderName;
  }
  public String getSuccessUrl() {
    return successUrl;
  }
  public void setSuccessUrl(String successUrl) {
    this.successUrl = successUrl;
  }
  public String getFailUrl() {
    return failUrl;
  }
  public void setFailUrl(String failUrl) {
    this.failUrl = failUrl;
  }
  public String getPaymentKey() {
    return paymentKey;
  }
  public void setPaymentKey(String paymentKey) {
    this.paymentKey = paymentKey;
  }
  public String getOrderId() {
	return orderId;
  }
  public void setOrderId(String orderId) {
	this.orderId = orderId;
  }
  public int getAmount() {
	return amount;
  }
  public void setAmount(int amount) {
	this.amount = amount;
  }

}
package com.bookGap.vo;

public class RefundVO {
  
  private int refundNo;           // 환불번호
  private String refundReason;    // 환불사유
  private String refundImage;     // 환불사유사진
  private String refundMail;      // 이메일
  private int orderDetailNo;      // 주문상세번호
  
  public int getRefundNo() {
    return refundNo;
  }
  public void setRefundNo(int refundNo) {
    this.refundNo = refundNo;
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
  public int getOrderDetailNo() {
    return orderDetailNo;
  }
  public void setOrderDetailNo(int orderDetailNo) {
    this.orderDetailNo = orderDetailNo;
  }

}
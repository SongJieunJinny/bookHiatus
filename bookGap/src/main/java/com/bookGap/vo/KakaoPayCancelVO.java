package com.bookGap.vo;

public class KakaoPayCancelVO {
  private int paymentNo;  //결제ID
  private String cid;  //가맹점코드
  private String tid;  //결제고유번호
  private int cancelAmount;  //결제취소금액
  private int cancelTaxFree;  //결제취소비과세금액
  private String cancelReason;  //결제취소이유
  
  public int getPaymentNo() {
    return paymentNo;
  }
  public void setPaymentNo(int paymentNo) {
    this.paymentNo = paymentNo;
  }
  public String getCid() {
    return cid;
  }
  public void setCid(String cid) {
    this.cid = cid;
  }
  public String getTid() {
    return tid;
  }
  public void setTid(String tid) {
    this.tid = tid;
  }
  public int getCancelAmount() {
    return cancelAmount;
  }
  public void setCancelAmount(int cancelAmount) {
    this.cancelAmount = cancelAmount;
  }
  public int getCancelTaxFree() {
    return cancelTaxFree;
  }
  public void setCancelTaxFree(int cancelTaxFree) {
    this.cancelTaxFree = cancelTaxFree;
  }
  public String getCancelReason() {
    return cancelReason;
  }
  public void setCancelReason(String cancelReason) {
    this.cancelReason = cancelReason;
  }
  
}
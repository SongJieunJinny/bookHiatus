package com.bookGap.vo;

public class KakaoPayRequestVO {
  private int paymentNo;  //결제ID
  private String cid;  //가맹점코드
  private String partnerOrderId;  //가맹점주문번호
  private String partnerUserId;  //가맹점회원ID
  private String itemName;  //상품명
  private int quantity;  //수량
  private int totalAmount;  //총결제금액
  private int taxFreeAmount;  //비과세금액
  private String approvalUrl;  //결제승인URL
  private String cancelUrl;  //결제취소URL
  private String failUrl;  //결제실패URL
  private String tid;  //결제고유번호
  private String pgToken;  //승인요청시필요
  
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
  public String getPartnerOrderId() {
    return partnerOrderId;
  }
  public void setPartnerOrderId(String partnerOrderId) {
    this.partnerOrderId = partnerOrderId;
  }
  public String getPartnerUserId() {
    return partnerUserId;
  }
  public void setPartnerUserId(String partnerUserId) {
    this.partnerUserId = partnerUserId;
  }
  public String getItemName() {
    return itemName;
  }
  public void setItemName(String itemName) {
    this.itemName = itemName;
  }
  public int getQuantity() {
    return quantity;
  }
  public void setQuantity(int quantity) {
    this.quantity = quantity;
  }
  public int getTotalAmount() {
    return totalAmount;
  }
  public void setTotalAmount(int totalAmount) {
    this.totalAmount = totalAmount;
  }
  public int getTaxFreeAmount() {
    return taxFreeAmount;
  }
  public void setTaxFreeAmount(int taxFreeAmount) {
    this.taxFreeAmount = taxFreeAmount;
  }
  public String getApprovalUrl() {
    return approvalUrl;
  }
  public void setApprovalUrl(String approvalUrl) {
    this.approvalUrl = approvalUrl;
  }
  public String getCancelUrl() {
    return cancelUrl;
  }
  public void setCancelUrl(String cancelUrl) {
    this.cancelUrl = cancelUrl;
  }
  public String getFailUrl() {
    return failUrl;
  }
  public void setFailUrl(String failUrl) {
    this.failUrl = failUrl;
  }
  public String getTid() {
    return tid;
  }
  public void setTid(String tid) {
    this.tid = tid;
  }
  public String getPgToken() {
    return pgToken;
  }
  public void setPgToken(String pgToken) {
    this.pgToken = pgToken;
  }
  
}
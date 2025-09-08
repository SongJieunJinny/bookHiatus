package com.bookGap.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonAlias;

public class KakaoPayRequestVO {
  
  // JSON 데이터와 관련 없는 필드는 그대로 둡니다.
  private int paymentNo;
  private String cid;
  private String approvalUrl;
  private String cancelUrl;
  private String failUrl;
  private String tid;
  private String pgToken;
  
  @JsonAlias({"order_id"})
  private String orderId;
  
  // --- JSON으로 받는 필드들에 @JsonProperty 어노테이션 추가 ---

  // JSON의 "partner_order_id" 값을 이 필드(partnerOrderId)에 매핑
  @JsonProperty("partner_order_id")
  private String partnerOrderId;

  // JSON의 "partner_user_id" 값을 이 필드(partnerUserId)에 매핑
  @JsonProperty("partner_user_id")
  private String partnerUserId;

  // JSON의 "item_name" 값을 이 필드(itemName)에 매핑
  @JsonProperty("item_name")
  private String itemName;

  // JSON의 "quantity" 값을 이 필드(quantity)에 매핑
  @JsonProperty("quantity")
  private int quantity;

  // JSON의 "total_amount" 값을 이 필드(totalAmount)에 매핑
  @JsonProperty("total_amount")
  private int totalAmount;

  // JSON의 "tax_free_amount" 값을 이 필드(taxFreeAmount)에 매핑
  @JsonProperty("tax_free_amount")
  private int taxFreeAmount;

  
  // --- 이하 Getter & Setter (기존과 동일) ---

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
  
  public String getOrderId(){ return orderId; }
  public void setOrderId(String orderId){ this.orderId = orderId; }
}
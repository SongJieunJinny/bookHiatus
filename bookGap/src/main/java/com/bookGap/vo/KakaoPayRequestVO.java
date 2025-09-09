package com.bookGap.vo;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

public class KakaoPayRequestVO {

  // 클라이언트 → 서버 입력
  private Long orderId;        // 회원 주문
  private String orderKey;     // 비회원 주문(ODR_xxx)

  /** 유연 입력: "orderId" 또는 "order_id"로 들어오는 값을 처리 */
  @JsonProperty("orderId")
  @JsonAlias({"order_id"})
  public void setOrderIdFlexible(String v){
    if (v == null || v.isBlank()) return;
    if (v.startsWith("ODR_")) {         // 비회원
      this.orderKey = v;
      this.orderId = null;
    } else {                            // 회원
      this.orderId = Long.valueOf(v);
    }
  }

  /** 내부에서만 사용할 순수 Long 세터. 역직렬화에서는 무시 */
  @JsonProperty(access = JsonProperty.Access.READ_ONLY)
  public void setOrderId(Long orderId){ this.orderId = orderId; }

  @JsonProperty("orderKey")
  public void setOrderKey(String orderKey){ this.orderKey = orderKey; }

  public Long getOrderId(){ return orderId; }
  public String getOrderKey(){ return orderKey; }

  // 내부/카카오 요청 저장용
  private int paymentNo;
  private String cid;
  private String approvalUrl;
  private String cancelUrl;
  private String failUrl;
  private String tid;
  private String pgToken;

  // 카카오 API 전송용(서버에서 채움)
  @JsonProperty("partner_order_id")
  private String partnerOrderId;
  @JsonProperty("partner_user_id")
  private String partnerUserId;
  @JsonProperty("item_name")
  private String itemName;
  @JsonProperty("quantity")
  private int quantity;
  @JsonProperty("total_amount")
  private int totalAmount;
  @JsonProperty("tax_free_amount")
  private int taxFreeAmount;

  // getters/setters (기타)
  public int getPaymentNo() { return paymentNo; }
  public void setPaymentNo(int paymentNo) { this.paymentNo = paymentNo; }
  public String getCid() { return cid; }
  public void setCid(String cid) { this.cid = cid; }
  public String getApprovalUrl() { return approvalUrl; }
  public void setApprovalUrl(String approvalUrl) { this.approvalUrl = approvalUrl; }
  public String getCancelUrl() { return cancelUrl; }
  public void setCancelUrl(String cancelUrl) { this.cancelUrl = cancelUrl; }
  public String getFailUrl() { return failUrl; }
  public void setFailUrl(String failUrl) { this.failUrl = failUrl; }
  public String getTid() { return tid; }
  public void setTid(String tid) { this.tid = tid; }
  public String getPgToken() { return pgToken; }
  public void setPgToken(String pgToken) { this.pgToken = pgToken; }

  public String getPartnerOrderId() { return partnerOrderId; }
  public void setPartnerOrderId(String partnerOrderId) { this.partnerOrderId = partnerOrderId; }
  public String getPartnerUserId() { return partnerUserId; }
  public void setPartnerUserId(String partnerUserId) { this.partnerUserId = partnerUserId; }
  public String getItemName() { return itemName; }
  public void setItemName(String itemName) { this.itemName = itemName; }
  public int getQuantity() { return quantity; }
  public void setQuantity(int quantity) { this.quantity = quantity; }
  public int getTotalAmount() { return totalAmount; }
  public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
  public int getTaxFreeAmount() { return taxFreeAmount; }
  public void setTaxFreeAmount(int taxFreeAmount) { this.taxFreeAmount = taxFreeAmount; }
}
package com.bookGap.vo;

public class OrderDetailVO {
  private int orderDetailNo;      // 주문상세번호 (PK)
  private int orderCount;         // 수량
  private int orderPrice;         // 가격 (할인가가 적용된 개당 가격)
  private int refundCheck;        // 환불가능여부 (1:Y, 2:N)
  private int bookNo;             // 상품번호 (FK)
  private int orderId;            // 주문ID (FK)
  
  private BookVO book; 
  
  public BookVO getBook() {
    return book;
  }
  public void setBook(BookVO book) {
    this.book = book;
  }  
  public int getOrderDetailNo() {
    return orderDetailNo;
  }
  public void setOrderDetailNo(int orderDetailNo) {
    this.orderDetailNo = orderDetailNo;
  }
  public int getOrderCount() {
    return orderCount;
  }
  public void setOrderCount(int orderCount) {
    this.orderCount = orderCount;
  }
  public int getOrderPrice() {
    return orderPrice;
  }
  public void setOrderPrice(int orderPrice) {
    this.orderPrice = orderPrice;
  }
  public int getRefundCheck() {
    return refundCheck;
  }
  public void setRefundCheck(int refundCheck) {
    this.refundCheck = refundCheck;
  }
  public int getBookNo() {
    return bookNo;
  }
  public void setBookNo(int bookNo) {
    this.bookNo = bookNo;
  }
  public int getOrderId() {
    return orderId;
  }
  public void setOrderId(int orderId) {
    this.orderId = orderId;
  }

}
package com.bookGap.vo;

import lombok.Data;

@Data
public class OrderDetailVO {
  private int orderDetailNo;
  private int orderCount;
  private int orderPrice;
  private int refundCheck;
  private int bookNo;
  private int orderId;
  private BookVO book;
  
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
  public BookVO getBook() {
    return book;
  }
  public void setBook(BookVO book) {
    this.book = book;
  }
  
}
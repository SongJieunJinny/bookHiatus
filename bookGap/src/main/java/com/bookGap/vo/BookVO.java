package com.bookGap.vo;

import lombok.Data;

@Data
public class BookVO {
  private int bookNo;
  private String bookRdate;
  private String bookTrans;
  private int bookStock;
  private String bookState;         // 프로젝트 현행 타입 유지
  private String bookCategory;
  private String isbn;
  private String bookImgUrl;
  private String bookIndex;
  private String publisherBookReview;

  private int commentCount;

  // 외부 API 응답 포함
  private ProductApiVO productInfo;
	
  public int getBookNo() {
    return bookNo;
  }

  public void setBookNo(int bookNo) {
    this.bookNo = bookNo;
  }

  public String getBookRdate() {
    return bookRdate;
  }

  public void setBookRdate(String bookRdate) {
    this.bookRdate = bookRdate;
  }

  public String getBookTrans() {
    return bookTrans;
  }

  public void setBookTrans(String bookTrans) {
    this.bookTrans = bookTrans;
  }

  public int getBookStock() {
    return bookStock;
  }

  public void setBookStock(int bookStock) {
    this.bookStock = bookStock;
  }

  public String getBookState() {
    return bookState;
  }

  public void setBookState(String bookState) {
    this.bookState = bookState;
  }

  public String getBookCategory() {
    return bookCategory;
  }

  public void setBookCategory(String bookCategory) {
    this.bookCategory = bookCategory;
  }

  public String getIsbn() {
    return isbn;
  }

  public void setIsbn(String isbn) {
    this.isbn = isbn;
  }

  public String getBookImgUrl() {
    return bookImgUrl;
  }

  public void setBookImgUrl(String bookImgUrl) {
    this.bookImgUrl = bookImgUrl;
  }

  public String getBookIndex() {
    return bookIndex;
  }

  public void setBookIndex(String bookIndex) {
    this.bookIndex = bookIndex;
  }

  public String getPublisherBookReview() {
    return publisherBookReview;
  }

  public void setPublisherBookReview(String publisherBookReview) {
    this.publisherBookReview = publisherBookReview;
  }

  public int getCommentCount() {
    return commentCount;
  }

  public void setCommentCount(int commentCount) {
    this.commentCount = commentCount;
  }

  public ProductApiVO getProductInfo() {
    return productInfo;
  }

  public void setProductInfo(ProductApiVO productInfo) {
    this.productInfo = productInfo;
  }
  
  public String  getImage()     { return productInfo != null ? productInfo.getImage() : null; }
  public String  getTitle()     { return productInfo != null ? productInfo.getTitle() : null; }
  public String  getAuthor()    { return productInfo != null ? productInfo.getAuthor() : null; }
  public String  getPublisher() { return productInfo != null ? productInfo.getPublisher() : null; }
  public Integer getDiscount()  { return productInfo != null ? productInfo.getDiscount() : null; }
  public String  getDescription() { return productInfo != null ? productInfo.getDescription() : null; }
  public String  getPubdate()     { return productInfo != null ? productInfo.getPubdate()     : null; }
  public String  getLink()        { return productInfo != null ? productInfo.getLink()        : null; }
  
  @Override
  public String toString() {
    return "BookVO [bookNo=" + bookNo + ", bookRdate=" + bookRdate + ", bookTrans=" + bookTrans + ", bookStock="
        + bookStock + ", bookState=" + bookState + ", bookCategory=" + bookCategory + ", isbn=" + isbn + ", bookImgUrl="
        + bookImgUrl + ", bookIndex=" + bookIndex + ", publisherBookReview=" + publisherBookReview + ", commentCount="
        + commentCount + ", productInfo=" + productInfo + "]";
  }

}
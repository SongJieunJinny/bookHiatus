package com.bookGap.vo;

public class BookVO extends ProductApiVO {
	private int bookNo;
  private String bookRdate;
  private String bookTrans;
  private int bookStock;
  private int bookState;
  private String bookCategory;
  private String isbn;
  private String bookImgUrl;
	private String bookIndex;
	private String publisherBookReview;
	private String commentCount; 
	 private String title;
	 
	 
  public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
public String getCommentCount() {
    return commentCount;
  }
  public void setCommentCount(String commentCount) {
    this.commentCount = commentCount;
  }
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
	public int getBookState() {
		return bookState;
	}
	public void setBookState(int bookState) {
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
	  
	@Override
	public String toString() {
	    return "BookVO{" +
	            "bookNo=" + bookNo +
	            ", bookRdate='" + bookRdate + '\'' +
	            ", bookTrans='" + bookTrans + '\'' +
	            ", bookStock=" + bookStock +
	            ", bookState=" + bookState +
	            ", bookCategory='" + bookCategory + '\'' +
	            ", isbn='" + isbn + '\'' +
	            ", bookImgUrl='" + bookImgUrl + '\'' +
	            ", bookIndex='" + bookIndex + '\'' +
	            ", publisherBookReview='" + publisherBookReview + '\'' +
	            ", commentCount='" + commentCount + '\'' +
	            '}';
	}

}
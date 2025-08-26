package com.bookGap.vo;

import lombok.Data;

@Data
public class BookVO {
  private int bookNo;
  private String bookRdate;
  private String bookTrans;
  private int bookStock;
  private int bookState;         // 프로젝트 현행 타입 유지
  private String bookCategory;
  private String isbn;
  private String bookImgUrl;
  private String bookIndex;
  private String publisherBookReview;
  private int commentCount;
  private String title;
  private String author;
  private String publisher;
  private Integer discount;
  private String description;
  private String pubdate;
  private String link;
  private String image;
  

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
  public void setTitle(String title) {
    this.title = title;
  }
  
  public String getImage() {
	    return image != null ? image : (productInfo != null ? productInfo.getImage() : null);
	}

	public String getTitle() {
	    return title != null ? title : (productInfo != null ? productInfo.getTitle() : null);
	}

	public String getAuthor() {
	    return author != null ? author : (productInfo != null ? productInfo.getAuthor() : null);
	}

	public String getPublisher() {
	    return publisher != null ? publisher : (productInfo != null ? productInfo.getPublisher() : null);
	}

	public Integer getDiscount() {
	    return discount != null ? discount : (productInfo != null ? productInfo.getDiscount() : null);
	}

	public String getDescription() {
	    return description != null ? description : (productInfo != null ? productInfo.getDescription() : null);
	}

	public String getPubdate() {
	    return pubdate != null ? pubdate : (productInfo != null ? productInfo.getPubdate() : null);
	}

	public String getLink() {
	    return link != null ? link : (productInfo != null ? productInfo.getLink() : null);
	}
  
  @Override
  public String toString() {
    return "BookVO [bookNo=" + bookNo + ", bookRdate=" + bookRdate + ", bookTrans=" + bookTrans + ", bookStock="
        + bookStock + ", bookState=" + bookState + ", bookCategory=" + bookCategory + ", isbn=" + isbn + ", bookImgUrl="
        + bookImgUrl + ", bookIndex=" + bookIndex + ", publisherBookReview=" + publisherBookReview + ", commentCount="
        + commentCount + ", title=" + title + ", productInfo=" + productInfo + "]";
  }
public void setImage(String image) {
	this.image = image;
}
  

}

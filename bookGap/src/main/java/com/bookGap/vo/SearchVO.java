package com.bookGap.vo;

import com.bookGap.util.PagingUtil;

public class SearchVO extends PagingUtil {
	/* search */
	private String searchType; //검색조건
	private String searchValue; //검색내용
	private String category;
	

	/* USER TABLE */
	private String userId; //아이디
	
	/* BOARD TABLE */
	private int boardNo;
	private String boardTitle; //게시글제목
	private Integer boardType; 
	
	/* PRODUCT_API TABLE */
	private String title; //책제목
	private String publisher; //출판사
	private String author; //저자
	
	/* BOOK TABLE */
	private String book_trans; //번역가 
	
	/* Comment TABLE */
	private int commentType; //게시글종류(BOOK, QNA)
	
	/*COMMENT TABLE*/
	private int bookNo;
	 private String isbn; 
	 
	
	
	public String getIsbn() {
    return isbn;
  }
  public void setIsbn(String isbn) {
    this.isbn = isbn;
  }
  public int getBookNo() {
		return bookNo;
	}
	public void setBookNo(int bookNo) {
		this.bookNo = bookNo;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getSearchValue() {
		return searchValue;
	}
	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getBoardTitle() {
		return boardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}
	public Integer getBoardType() {
		return boardType;
	}
	public void setBoardType(Integer boardType) {
		this.boardType = boardType;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
 public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getBook_trans() {
		return book_trans;
	}
	public void setBook_trans(String book_trans) {
		this.book_trans = book_trans;
	}
	public int getCommentType() {
		return commentType;
	}
	public void setCommentType(int commentType) {
		this.commentType = commentType;
	}
}
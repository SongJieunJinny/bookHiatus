package com.bookGap.vo;

public class SearchVO {
	/* search */
	private String search_type; //검색조건
	private String search_value; //검색내용
	
	/* USER TABLE */
	private String userId; //아이디
	
	/* BOARD TABLE */
	private String boardTitle; //게시글제목
	
	/* PRODUCT_API TABLE */
	private String title; //책제목
	private String publisher; //출판사
	private String author; //저자
	
	/* BOOK TABLE */
	private String book_trans; //번역가

	
	public String getSearch_type() {
		return search_type;
	}

	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}

	public String getSearch_value() {
		return search_value;
	}

	public void setSearch_value(String search_value) {
		this.search_value = search_value;
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
}

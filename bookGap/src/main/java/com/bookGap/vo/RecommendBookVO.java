package com.bookGap.vo;

public class RecommendBookVO {
	
	private int bookNo;
    private String isbn;
    private String title;
    private String image;
    private int discount;

    private String recommendType;   // BASIC, SEASON, THEME
    private String oldRecommendType;
    private String recommendComment;
	public int getBookNo() {
		return bookNo;
	}
	public void setBookNo(int bookNo) {
		this.bookNo = bookNo;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public int getDiscount() {
		return discount;
	}
	public void setDiscount(int discount) {
		this.discount = discount;
	}
	public String getRecommendType() {
		return recommendType;
	}
	public void setRecommendType(String recommendType) {
		this.recommendType = recommendType;
	}
	public String getOldRecommendType() {
		return oldRecommendType;
	}
	public void setOldRecommendType(String oldRecommendType) {
		this.oldRecommendType = oldRecommendType;
	}
	public String getRecommendComment() {
		return recommendComment;
	}
	public void setRecommendComment(String recommendComment) {
		this.recommendComment = recommendComment;
	}
    
	
	
}

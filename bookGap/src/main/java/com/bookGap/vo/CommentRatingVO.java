package com.bookGap.vo;

public class CommentRatingVO {
  private int ratingNo;      // 별점 번호
  private int commentNo;     // 댓글 번호
  private String userId;     // 사용자 ID
  private int rating;        // 별점
  private String isbn;       // ISBN (책 정보)
  
  public int getRatingNo() {
    return ratingNo;
  }
  public void setRatingNo(int ratingNo) {
    this.ratingNo = ratingNo;
  }
  public int getCommentNo() {
    return commentNo;
  }
  public void setCommentNo(int commentNo) {
    this.commentNo = commentNo;
  }
  public String getUserId() {
    return userId;
  }
  public void setUserId(String userId) {
    this.userId = userId;
  }
  public int getRating() {
    return rating;
  }
  public void setRating(int rating) {
    this.rating = rating;
  }
  public String getIsbn() {
    return isbn;
  }
  public void setIsbn(String isbn) {
    this.isbn = isbn;
  }
  
}

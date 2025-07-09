package com.bookGap.vo;

public class CommentLoveVO {
  private int loveNo;      // 별점 번호
  private int commentNo;     // 댓글 번호
  private String userId;     // 사용자 ID
  private String isbn;       // ISBN (책 정보)
  
  public int getLoveNo() {
    return loveNo;
  }
  public void setLoveNo(int loveNo) {
    this.loveNo = loveNo;
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
  public String getIsbn() {
    return isbn;
  }
  public void setIsbn(String isbn) {
    this.isbn = isbn;
  }
  
}

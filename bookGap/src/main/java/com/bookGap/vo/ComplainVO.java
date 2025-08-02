package com.bookGap.vo;

public class ComplainVO {
  private int complainNo;
  private int commentNo;
  private String userId;
  private String complainType;
  
  public int getComplainNo() {
    return complainNo;
  }
  public void setComplainNo(int complainNo) {
    this.complainNo = complainNo;
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
  public String getComplainType() {
    return complainType;
  }
  public void setComplainType(String complainType) {
    this.complainType = complainType;
  }
  
}
package com.bookGap.vo;

public class CommentVO extends UserInfoVO {
	
	private int commentNo; //댓글 번호
	private String commentContent; //댓글 내용
	private String commentState; //댓글 활성화여부(1활성화, 2비활성화)
	private java.sql.Date commentRdate;//댓글 등록일자
	private String userId; //아이디
	private int bookNo; //상품번호
	private String isbn;
	
	/* JSP 출력용 */
  private int displayNo;
	private String formattedCommentRdate;
	
	// 🔻 JOIN 쿼리 결과를 담을 필드 2개 추가 🔻
	private boolean lovedByLoginUser;  // 로그인 유저의 좋아요 여부를 담을 필드
	private int commentRating;  // 로그인 유저가 매긴 별점을 담을 필드
	private int likeCount;


  public int getLikeCount() {
    return likeCount;
  }
  public void setLikeCount(int likeCount) {
    this.likeCount = likeCount;
  }
	public boolean isLovedByLoginUser() {
	  return lovedByLoginUser; 
	}
	public void setLovedByLoginUser(boolean lovedByLoginUser) { 
	  this.lovedByLoginUser = lovedByLoginUser; 
	}
	public int getDisplayNo() {
		return displayNo;
	}
	public void setDisplayNo(int displayNo) {
		this.displayNo = displayNo;
	}
	public int getCommentRating() {
    return commentRating;
	}
	public void setCommentRating(int commentRating) {
    this.commentRating = commentRating;
  }
	public int getCommentNo() {
		return commentNo;
	}
	public void setCommentNo(int commentNo) {
		this.commentNo = commentNo;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCommentState() {
		return commentState;
	}
	public void setCommentState(String commentState) {
		this.commentState = commentState;
	}
	public java.sql.Date getCommentRdate() {
		return commentRdate;
	}
	public void setCommentRdate(java.sql.Date commentRdate) {
		this.commentRdate = commentRdate;
	}
	public String getFormattedCommentRdate() {
		return formattedCommentRdate;
	}
	public void setFormattedCommentRdate(String formattedCommentRdate) {
		this.formattedCommentRdate = formattedCommentRdate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
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

}
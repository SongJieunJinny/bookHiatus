package com.bookGap.vo;

public class CommentVO extends UserInfoVO{
	
	private int commentNo; //댓글 번호
	private String commentContent; //댓글 내용
	private String commentState; //댓글 활성화여부(1활성화, 2비활성화)
	private java.sql.Timestamp commentRdate;//댓글 등록일자
	private String commentRating; //별점
	private int boardNo; //게시글번호
	private String userId; //아이디
	private int bookNo; //책번호
	
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
	public java.sql.Timestamp getCommentRdate() {
		return commentRdate;
	}
	public void setCommentRdate(java.sql.Timestamp commentRdate) {
		this.commentRdate = commentRdate;
	}
	public String getCommentRating() {
		return commentRating;
	}
	public void setCommentRating(String commentRating) {
		this.commentRating = commentRating;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
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
	
}

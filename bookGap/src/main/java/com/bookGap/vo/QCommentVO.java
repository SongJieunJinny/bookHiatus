package com.bookGap.vo;

public class QCommentVO extends UserInfoVO{

	/* board list에 보이는 displayNo */
	private int displayNo;
	
	private int qCommentNo; //댓글 번호
	private String qCommentContent; //댓글 내용
	private String qCommentState; //댓글 활성화여부(1활성화, 2비활성화)
	private java.sql.Timestamp qCommentRdate;//댓글 등록일자
	private String formattedQCommentRdate;
	private int boardNo; //게시글번호
	private String userId; //아이디
	
	public int getDisplayNo() {
		return displayNo;
	}
	public void setDisplayNo(int displayNo) {
		this.displayNo = displayNo;
	}
	public int getqCommentNo() {
		return qCommentNo;
	}
	public void setqCommentNo(int qCommentNo) {
		this.qCommentNo = qCommentNo;
	}
	public String getqCommentContent() {
		return qCommentContent;
	}
	public void setqCommentContent(String qCommentContent) {
		this.qCommentContent = qCommentContent;
	}
	public String getqCommentState() {
		return qCommentState;
	}
	public void setqCommentState(String qCommentState) {
		this.qCommentState = qCommentState;
	}
	public java.sql.Timestamp getqCommentRdate() {
		return qCommentRdate;
	}
	public void setqCommentRdate(java.sql.Timestamp qCommentRdate) {
		this.qCommentRdate = qCommentRdate;
	}
	public String getFormattedQCommentRdate() {
		return formattedQCommentRdate;
	}
	public void setFormattedQCommentRdate(String formattedQCommentRdate) {
		this.formattedQCommentRdate = formattedQCommentRdate;
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
	
}

package com.bookGap.vo;

public class ECommentVO extends UserInfoVO {

	/* board list에 보이는 displayNo */
	private int displayNo;
	
	private int eCommentNo; //댓글 번호
	private String eCommentContent; //댓글 내용
	private String eCommentState; //댓글 활성화여부(1활성화, 2비활성화)
	private java.sql.Timestamp eCommentRdate;//댓글 등록일자
	private String formattedECommentRdate;
	private int boardNo; //게시글번호
	private String userId; //아이디
	
	public int getDisplayNo() {
		return displayNo;
	}
	public void setDisplayNo(int displayNo) {
		this.displayNo = displayNo;
	}
	public int geteCommentNo() {
		return eCommentNo;
	}
	public void seteCommentNo(int eCommentNo) {
		this.eCommentNo = eCommentNo;
	}
	public String geteCommentContent() {
		return eCommentContent;
	}
	public void seteCommentContent(String eCommentContent) {
		this.eCommentContent = eCommentContent;
	}
	public String geteCommentState() {
		return eCommentState;
	}
	public void seteCommentState(String eCommentState) {
		this.eCommentState = eCommentState;
	}
	public java.sql.Timestamp geteCommentRdate() {
		return eCommentRdate;
	}
	public void seteCommentRdate(java.sql.Timestamp eCommentRdate) {
		this.eCommentRdate = eCommentRdate;
	}
	public String getFormattedECommentRdate() {
		return formattedECommentRdate;
	}
	public void setFormattedECommentRdate(String formattedECommentRdate) {
		this.formattedECommentRdate = formattedECommentRdate;
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
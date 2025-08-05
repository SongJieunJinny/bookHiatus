package com.bookGap.vo;

import java.sql.Timestamp;

public class ComplainVO {
	private int complainNo;
	private int commentNo;
	private String userId;
	private String complainType;
	private Timestamp reportDate;
	private String status;
	private String processNote;
	private String commentContent;
	private String bookName;
	private int commentState;
	private String complainTypeText;
	
	
  

	public String getComplainTypeText() {
		return complainTypeText;
	}
	public void setComplainTypeText(String complainTypeText) {
		this.complainTypeText = complainTypeText;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public int getCommentState() {
		return commentState;
	}
	public void setCommentState(int commentState) {
		this.commentState = commentState;
	}
	public Timestamp getReportDate() {
		return reportDate;
	}
	public void setReportDate(Timestamp reportDate) {
		this.reportDate = reportDate;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getProcessNote() {
		return processNote;
	}
	public void setProcessNote(String processNote) {
		this.processNote = processNote;
	}
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
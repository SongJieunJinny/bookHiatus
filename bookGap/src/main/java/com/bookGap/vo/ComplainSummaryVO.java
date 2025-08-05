package com.bookGap.vo;

import java.sql.Timestamp;

public class ComplainSummaryVO  {
	private int complainNo;
	private String commentContent;
	private int commentState;
	private int reportCount;
	private Timestamp lastReportDate;
	private String reportTypes;
	private int commentNo;
	private String bookName;
	private String status;
	
	
	
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public int getCommentState() {
		return commentState;
	}
	public void setCommentState(int commentState) {
		this.commentState = commentState;
	}
	public int getReportCount() {
		return reportCount;
	}
	public void setReportCount(int reportCount) {
		this.reportCount = reportCount;
	}
	public Timestamp getLastReportDate() {
		return lastReportDate;
	}
	public void setLastReportDate(Timestamp lastReportDate) {
		this.lastReportDate = lastReportDate;
	}
	public String getReportTypes() {
		return reportTypes;
	}
	public void setReportTypes(String reportTypes) {
		this.reportTypes = reportTypes;
	}
	

}

package com.bookGap.vo;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ScheduleVO {
	private int scheduleId;    // 일정 ID (PK)
    private String title;      // 일정 제목
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
    private Timestamp startDate;  // 일정 시작일시 (DATETIME)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
    private Timestamp endDate;    // 일정 종료일시 (DATETIME)
    private String color;      // 일정 색상 (HEX 코드)
    private String content;    // 일정 설명
    private String createdAt;  // 생성일시 (TIMESTAMP)
    private String updatedAt;  // 수정일시 (TIMESTAMP)
    
	public int getScheduleId() {
		return scheduleId;
	}
	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	public Timestamp getStartDate() {
		return startDate;
	}
	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}
	public Timestamp getEndDate() {
		return endDate;
	}
	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}

	
	@Override
	public String toString() {
	    return "ScheduleVO{" +
	            "scheduleId=" + scheduleId +
	            ", title='" + title + '\'' +
	            ", startDate='" + startDate + '\'' +
	            ", endDate='" + endDate + '\'' +
	            ", color='" + color + '\'' +
	            ", content='" + content + '\'' +
	            ", createdAt='" + createdAt + '\'' +
	            ", updatedAt='" + updatedAt + '\'' +
	            '}';
	}
}

package com.bookGap.vo;

import java.util.Date;

public class BoardVO {
	/* user 테이블 */
	private String userId; //아이디
	
	/* board list에 보이는 displayNo */
	private int displayNo;
	
	/* board 테이블 */
	private int boardNo; //게시글번호
	private String boardTitle; //게시글제목
	private String boardContent; //게시글내용
	private int boardHit; //조회수
	private int boardState; //활성화여부(1활성화, 2비활성화)
	private Date boardRdate; //등록일자
	private String formattedBoardRdate;
	private int boardType; //게시글종류(NOTICE, BOOK)
	
	/* attach 테이블 */
	private int attachNo; //파일번호
	private String attachName; //파일이름
	private String fakeAttachName; //변경된파일이름
	
	/* comment 테이블 */
	private int commentNo; //댓글번호
	private String commentContent; //댓글내용
	private String commentState; //활성화여부(1활성화, 2비활성화)
	private Date commentRdate; //등록일자
	private int commentRating; //별점
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getBoardTitle() {
		return boardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}
	public String getBoardContent() {
		return boardContent;
	}
	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}
	public int getBoardHit() {
		return boardHit;
	}
	public void setBoardHit(int boardHit) {
		this.boardHit = boardHit;
	}
	public int getBoardState() {
		return boardState;
	}
	public void setBoardState(int boardState) {
		this.boardState = boardState;
	}
	public Date getBoardRdate() {
		return boardRdate;
	}
	public void setBoardRdate(Date boardRdate) {
		this.boardRdate = boardRdate;
	}
	public int getBoardType() {
		return boardType;
	}
	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}
	public int getAttachNo() {
		return attachNo;
	}
	public void setAttachNo(int attachNo) {
		this.attachNo = attachNo;
	}
	public String getAttachName() {
		return attachName;
	}
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	public String getFakeAttachName() {
		return fakeAttachName;
	}
	public void setFakeAttachName(String fakeAttachName) {
		this.fakeAttachName = fakeAttachName;
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
	public Date getCommentRdate() {
		return commentRdate;
	}
	public void setCommentRdate(Date commentRdate) {
		this.commentRdate = commentRdate;
	}
	public int getCommentRating() {
		return commentRating;
	}
	public void setCommentRating(int commentRating) {
		this.commentRating = commentRating;
	}
	public String getFormattedBoardRdate() {
		return formattedBoardRdate;
	}
	public void setFormattedBoardRdate(String formattedBoardRdate) {
		this.formattedBoardRdate = formattedBoardRdate;
	}
	public int getDisplayNo() {
		return displayNo;
	}
	public void setDisplayNo(int displayNo) {
		this.displayNo = displayNo;
	}
	
}
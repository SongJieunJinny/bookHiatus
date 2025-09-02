package com.bookGap.vo;

import java.sql.Timestamp;

public class BoardVO extends UserInfoVO{
	private int boardNo; //게시글번호
	private String boardTitle; //게시글제목
	private String boardContent; //게시글내용
	private int boardHit; //조회수
	private int boardState; //활성화여부(1활성화, 2비활성화)
	private Timestamp boardRdate;//등록일자
	private String formattedBoardRdate;
	private int boardType; //게시글종류(NOTICE, QnA, EVENT)
	private String userId; //아이디 

	/* board list에 보이는 displayNo */
  private int displayNo;
  
	/* qcomment 테이블 */
	private int qCommentNo; //댓글번호
	private String qCommentContent; //댓글내용
	private String qCommentState; //활성화여부(1활성화, 2비활성화)
	private Timestamp qCommentRdate; //등록일자
	private int qCommentCount; //댓글 갯수
	
	/* ecomment 테이블 */
	private int eCommentNo; //댓글번호
	private String eCommentContent; //댓글내용
	private String eCommentState; //활성화여부(1활성화, 2비활성화)
	private Timestamp eCommentRdate; //등록일자
	private int eCommentCount; //댓글 갯수
	 
  /* attach 테이블 */
  private int attachNo; //파일번호
  private String attachName; //파일이름
  private String fakeAttachName; //변경된파일이름
  
  /* book 테이블 */
  private Integer bookNo;
  private String bookImgUrl; // 책 이미지 URL
  private String bookTitle;  // 책 제목 (JOIN 결과)
  private String bookAuthor; 

	/* ------------------------getter&setter----------------------------- */
	
	public Integer getBookNo() {
    return bookNo;
  }

  public void setBookNo(Integer bookNo) {
    this.bookNo = bookNo;
  }

  public String getBookImgUrl() {
    return bookImgUrl;
  }

  public void setBookImgUrl(String bookImgUrl) {
    this.bookImgUrl = bookImgUrl;
  }
  
	public String getBookTitle() {
    return bookTitle;
  }

  public void setBookTitle(String bookTitle) {
    this.bookTitle = bookTitle;
  }
  
  public String getBookAuthor() {
    return bookAuthor;
  }

  public void setBookAuthor(String bookAuthor) {
    this.bookAuthor = bookAuthor;
  }

  public int getDisplayNo() {
		return displayNo;
	}

	public void setDisplayNo(int displayNo) {
		this.displayNo = displayNo;
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

	public Timestamp getBoardRdate() {
		return boardRdate;
	}

	public void setBoardRdate(Timestamp boardRdate) {
		this.boardRdate = boardRdate;
	}

	public String getFormattedBoardRdate() {
		return formattedBoardRdate;
	}

	public void setFormattedBoardRdate(String formattedBoardRdate) {
		this.formattedBoardRdate = formattedBoardRdate;
	}

	public int getBoardType() {
		return boardType;
	}

	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	public Timestamp getqCommentRdate() {
		return qCommentRdate;
	}

	public void setqCommentRdate(Timestamp qCommentRdate) {
		this.qCommentRdate = qCommentRdate;
	}

	public int getqCommentCount() {
		return qCommentCount;
	}

	public void setqCommentCount(int qCommentCount) {
		this.qCommentCount = qCommentCount;
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

	public Timestamp geteCommentRdate() {
		return eCommentRdate;
	}

	public void seteCommentRdate(Timestamp eCommentRdate) {
		this.eCommentRdate = eCommentRdate;
	}

	public int geteCommentCount() {
		return eCommentCount;
	}

	public void seteCommentCount(int eCommentCount) {
		this.eCommentCount = eCommentCount;
	}
}
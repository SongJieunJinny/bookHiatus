package com.bookGap.vo;

public class UserInfoVO {
	private String USER_ID; //아이디
	private String USER_PW; //비밀번호
	private boolean USER_ENABLED; //활성화여부(1활성화, 2비활성화)
	private String USER_AUTHORITY; //권한
	private int USER_STATE; //가입여부(1 가입상태, 2 탈퇴상태)
	private String USER_NAME; //이름
	private String USER_JOIN_DATE; //가입일
	private String USER_PHONE; //연락처
	private String USER_EMAIL; //이메일
	private int COMPLAIN_NO; //신고번호
	private String BEFORE_PW; //비밀번호 암호화 전
	
	
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getUSER_PW() {
		return USER_PW;
	}
	public void setUSER_PW(String uSER_PW) {
		USER_PW = uSER_PW;
	}
	public boolean isUSER_ENABLED() {
		return USER_ENABLED;
	}
	public void setUSER_ENABLED(boolean uSER_ENABLED) {
		USER_ENABLED = uSER_ENABLED;
	}
	public String getUSER_AUTHORITY() {
		return USER_AUTHORITY;
	}
	public void setUSER_AUTHORITY(String uSER_AUTHORITY) {
		USER_AUTHORITY = uSER_AUTHORITY;
	}
	public int getUSER_STATE() {
		return USER_STATE;
	}
	public void setUSER_STATE(int uSER_STATE) {
		USER_STATE = uSER_STATE;
	}
	public String getUSER_NAME() {
		return USER_NAME;
	}
	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}
	public String getUSER_JOIN_DATE() {
		return USER_JOIN_DATE;
	}
	public void setUSER_JOIN_DATE(String uSER_JOIN_DATE) {
		USER_JOIN_DATE = uSER_JOIN_DATE;
	}
	public String getUSER_PHONE() {
		return USER_PHONE;
	}
	public void setUSER_PHONE(String uSER_PHONE) {
		USER_PHONE = uSER_PHONE;
	}
	public String getUSER_EMAIL() {
		return USER_EMAIL;
	}
	public void setUSER_EMAIL(String uSER_EMAIL) {
		USER_EMAIL = uSER_EMAIL;
	}
	public int getCOMPLAIN_NO() {
		return COMPLAIN_NO;
	}
	public void setCOMPLAIN_NO(int cOMPLAIN_NO) {
		COMPLAIN_NO = cOMPLAIN_NO;
	}
	public String getBEFORE_PW() {
		return BEFORE_PW;
	}
	public void setBEFORE_PW(String bEFORE_PW) {
		BEFORE_PW = bEFORE_PW;
	}
	
	
}

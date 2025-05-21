package com.bookGap.vo;

public class UserInfoVO {
	private String userId; //아이디
	private String userPw; //비밀번호
	private boolean userEnabled; //활성화여부(1활성화, 2비활성화)
	private String userAuthority; //권한
	private int userState; //가입여부(1 가입상태, 2 탈퇴상태)
	private String userName; //이름
	private String userJoinDate; //가입일
	private String userPhone; //연락처
	private String userEmail; //이메일
	private int complainNo; //신고번호
	private String beforePw; //비밀번호 암호화 전
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public boolean isUserEnabled() {
		return userEnabled;
	}
	public void setUserEnabled(boolean userEnabled) {
		this.userEnabled = userEnabled;
	}
	public String getUserAuthority() {
		return userAuthority;
	}
	public void setUserAuthority(String userAuthority) {
		this.userAuthority = userAuthority;
	}
	public int getUserState() {
		return userState;
	}
	public void setUserState(int userState) {
		this.userState = userState;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserJoinDate() {
		return userJoinDate;
	}
	public void setUserJoinDate(String userJoinDate) {
		this.userJoinDate = userJoinDate;
	}
	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public int getComplainNo() {
		return complainNo;
	}
	public void setComplainNo(int complainNo) {
		this.complainNo = complainNo;
	}
	public String getBeforePw() {
		return beforePw;
	}
	public void setBeforePw(String beforePw) {
		this.beforePw = beforePw;
	}
}

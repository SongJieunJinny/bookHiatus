package com.bookGap.vo;

public class MypageVO {
	private String userId; //아이디
	private String userPw; //비밀번호
	private String userName; //이름
	private String userPhone; //연락처
	private String userEmail; //이메일
	private int userState; //가입여부(1 가입상태, 2 탈퇴상태)
	private String userJoinDate; //가입일
	private int postCode; //배송지주소(우편번호)
	private String roadAddress; //배송지주소(도로명주소)
	private String detailAddress; //배송지주소(상세주소)
	private String oauthProvider; // 로그인 제공자
	private String kakaoId;   
	 
	public String getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(String kakaoId) {
		this.kakaoId = kakaoId;
	}

	public String getOauthProvider() {
		return oauthProvider;
	}

	public void setOauthProvider(String oauthProvider) {
		this.oauthProvider = oauthProvider;
	}

	@Override
	public String toString() {
		return "MypageVO [userId=" + userId + ", userPw=" + userPw + ", userName=" + userName + ", userPhone="
				+ userPhone + ", userEmail=" + userEmail + ", userState=" + userState + ", userJoinDate=" + userJoinDate
				+ ", postCode=" + postCode + ", roadAddress=" + roadAddress + ", detailAddress=" + detailAddress + "]";
	}

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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

	public int getUserState() {
		return userState;
	}

	public void setUserState(int userState) {
		this.userState = userState;
	}

	public String getUserJoinDate() {
		return userJoinDate;
	}

	public void setUserJoinDate(String userJoinDate) {
		this.userJoinDate = userJoinDate;
	}

	public int getPostCode() {
		return postCode;
	}

	public void setPostCode(int postCode) {
		this.postCode = postCode;
	}

	public String getRoadAddress() {
		return roadAddress;
	}

	public void setRoadAddress(String roadAddress) {
		this.roadAddress = roadAddress;
	}

	public String getDetailAddress() {
		return detailAddress;
	}

	public void setDetailAddress(String detailAddress) {
		this.detailAddress = detailAddress;
	}
	
}

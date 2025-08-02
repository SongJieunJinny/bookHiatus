package com.bookGap.vo;

public class UserAddressVO {
  private int userAddressId;
  private String addressName;
  private String postCode;
  private String roadAddress;
  private String detailAddress;
  private int isDefault;
  private String userId;
  private String userName; // 받는 사람 이름
  private String userPhone;    // 받는 사람 연락처
  
  public int getUserAddressId() {
    return userAddressId;
  }
  public void setUserAddressId(int userAddressId) {
    this.userAddressId = userAddressId;
  }
  public String getAddressName() {
    return addressName;
  }
  public void setAddressName(String addressName) {
    this.addressName = addressName;
  }
  public String getPostCode() {
    return postCode;
  }
  public void setPostCode(String postCode) {
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
  public int getIsDefault() {
    return isDefault;
  }
  public void setIsDefault(int isDefault) {
    this.isDefault = isDefault;
  }
  public String getUserId() {
    return userId;
  }
  public void setUserId(String userId) {
    this.userId = userId;
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
  
  
}
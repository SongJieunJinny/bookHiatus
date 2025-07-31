package com.bookGap.vo;

import java.time.LocalDateTime;

public class GuestVO {
  private String guestId;  //비회원 아이디
  private String guestName;  //비회원 이름
  private String guestPhone;  //비회원 번호
  private String guestEmail;  //비회원 이메일
  private LocalDateTime guestCreatedAt;  //비회원 생성일자
  private String guestPostCode;  //비회원 우편번호
  private String guestRoadAddress;  //비회원 도로명주소
  private String guestDetailAddress;  //비회원 상세주소
  
  public String getGuestId() {
    return guestId;
  }
  public void setGuestId(String guestId) {
    this.guestId = guestId;
  }
  public String getGuestName() {
    return guestName;
  }
  public void setGuestName(String guestName) {
    this.guestName = guestName;
  }
  public String getGuestPhone() {
    return guestPhone;
  }
  public void setGuestPhone(String guestPhone) {
    this.guestPhone = guestPhone;
  }
  public String getGuestEmail() {
    return guestEmail;
  }
  public void setGuestEmail(String guestEmail) {
    this.guestEmail = guestEmail;
  }
  public LocalDateTime getGuestCreatedAt() {
    return guestCreatedAt;
  }
  public void setGuestCreatedAt(LocalDateTime guestCreatedAt) {
    this.guestCreatedAt = guestCreatedAt;
  }
  public String getGuestPostCode() {
    return guestPostCode;
  }
  public void setGuestPostCode(String guestPostCode) {
    this.guestPostCode = guestPostCode;
  }
  public String getGuestRoadAddress() {
    return guestRoadAddress;
  }
  public void setGuestRoadAddress(String guestRoadAddress) {
    this.guestRoadAddress = guestRoadAddress;
  }
  public String getGuestDetailAddress() {
    return guestDetailAddress;
  }
  public void setGuestDetailAddress(String guestDetailAddress) {
    this.guestDetailAddress = guestDetailAddress;
  }
  
}
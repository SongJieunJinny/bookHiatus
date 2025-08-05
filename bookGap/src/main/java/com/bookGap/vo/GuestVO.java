package com.bookGap.vo;

import java.time.LocalDateTime;

public class GuestVO {
  private String guestId;  //비회원 아이디
  private String guestName;  //비회원 이름
  private String guestPhone;  //비회원 번호
  private String guestEmail;  //비회원 이메일
  private LocalDateTime guestCreatedAt;  //비회원 생성일자
  
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
  
}
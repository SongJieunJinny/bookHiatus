package com.bookGap.service;

import com.bookGap.vo.GuestVO;

public interface GuestService {

  public void registerGuest(GuestVO guestVO);
  
  public GuestVO getGuestByEmail(String email);
  
  public void updateGuestInfo(GuestVO guestVO);

}

package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.GuestDAO;
import com.bookGap.vo.GuestVO;

@Service
public class GuestServiceImpl implements GuestService {

  @Autowired public GuestDAO guestDAO;

  @Override
  public void registerGuest(GuestVO guestVO) {
    if (guestVO.getGuestName() == null || guestVO.getGuestPhone() == null || guestVO.getGuestEmail() == null) {
      throw new IllegalArgumentException("비회원 정보(이름/전화/이메일)가 누락되었습니다.");
    }
    guestDAO.insertGuest(guestVO);
  }

  @Override
  public GuestVO getGuestByEmail(String email) {
    return guestDAO.findGuestByEmail(email);
  }
  
  @Override
  public void updateGuestInfo(GuestVO guestVO) {
    guestDAO.updateGuestInfo(guestVO);
  }

}

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
    guestDAO.insertGuest(guestVO);
  }

  @Override
  public GuestVO getGuestByEmail(String email) {
    return guestDAO.findGuestByEmail(email);
  }

}

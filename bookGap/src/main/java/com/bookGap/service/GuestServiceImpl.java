package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.GuestDAO;
import com.bookGap.vo.GuestVO;

@Service
public class GuestServiceImpl implements GuestService {

  @Autowired
  public GuestDAO guestDAO;

  @Override
  @Transactional
  public void registerGuest(GuestVO guest) {
    guestDAO.insertGuest(guest);
    guestDAO.insertGuestAddress(guest);
  }
}

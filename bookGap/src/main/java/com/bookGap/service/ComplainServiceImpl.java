package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.ComplainDAO;
import com.bookGap.vo.ComplainVO;

@Service
public class ComplainServiceImpl implements ComplainService{

  @Autowired
  public ComplainDAO complainDAO;

  @Override
  public boolean countComplain(ComplainVO complainVO) {
    return complainDAO.countComplain(complainVO) > 0;
  }

  @Override
  public void insertComplain(ComplainVO complainVO) {
    complainDAO.insertComplain(complainVO);
  }
}

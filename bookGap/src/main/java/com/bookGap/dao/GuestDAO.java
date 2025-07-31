package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.GuestVO;

@Repository
public class GuestDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.guestMapper.";
  
  public void insertGuest(GuestVO guest) {
    sqlSession.insert(name_space + "insertGuest", guest);
  }

  public void insertGuestAddress(GuestVO guest) {
    sqlSession.insert(name_space + "insertGuestAddress", guest);
  }

}
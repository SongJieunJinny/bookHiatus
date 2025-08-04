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
  
  // 게스트 정보 저장
  public void insertGuest(GuestVO guestVO) {
      sqlSession.insert(name_space + "insertGuest", guestVO);
  }

  // 이메일로 게스트 정보 조회
  public GuestVO findGuestByEmail(String email) {
      return sqlSession.selectOne(name_space + "findGuestByEmail", email);
  }

}
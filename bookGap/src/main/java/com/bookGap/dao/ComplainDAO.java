package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.ComplainVO;

@Repository
public class ComplainDAO {

  @Autowired 
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.complainMapper.";
  
//특정 댓글에 대해 해당 유저가 신고했는지 확인
  public int countComplain(ComplainVO complainVO) {
    return sqlSession.selectOne(name_space + "countComplain", complainVO);
  }

  // 새로운 신고 등록
  public void insertComplain(ComplainVO complainVO) {
    sqlSession.insert(name_space + "insertComplain", complainVO);
  }

}
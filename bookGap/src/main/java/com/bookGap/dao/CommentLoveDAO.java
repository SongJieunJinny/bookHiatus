package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CommentLoveVO;

@Repository
public class CommentLoveDAO {
  
  @Autowired 
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.commentLoveMapper.";
  
  public boolean isLovedByUser(CommentLoveVO vo) {
    return sqlSession.selectOne(name_space+"isLovedByUser",vo);
  }
  
  public int insertLove(CommentLoveVO vo) {
    return sqlSession.insert(name_space + "insertLove", vo);
  }
  
  public int deleteLove(CommentLoveVO vo) {
    return sqlSession.delete(name_space+"deleteLove",vo);
  }

}

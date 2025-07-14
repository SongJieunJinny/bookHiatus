package com.bookGap.dao;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CommentRatingVO;

@Repository
public class CommentRatingDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.commentRatingMapper.";
  
  public int insertRating(CommentRatingVO vo) {
    return sqlSession.insert(name_space + "insertRating", vo);
  }

  public int updateRating(CommentRatingVO vo) {
    return sqlSession.update(name_space + "updateRating", vo);
  }

  public int upsertRating(CommentRatingVO vo) {
    return sqlSession.insert(name_space + "upsertRating", vo);
  }

  public CommentRatingVO selectUserRating(int commentNo, String isbn, String userId) {
    HashMap<String, Object> param = new HashMap<>();
    param.put("commentNo", commentNo);
    param.put("isbn", isbn);
    param.put("userId", userId);
    return sqlSession.selectOne(name_space + "selectUserRating", param);
  }

}
package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CommentRatingVO;

@Repository
public class CommentRatingDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.commentRatingMapper.";
  
  //댓글 별점 저장
  public int insertRating(CommentRatingVO vo) {
    return sqlSession.insert(name_space+"insertRating", vo);
  }
  
  //댓글 별점 수정
  public int updateRating(CommentRatingVO vo) {
    return sqlSession.update(name_space+"updateRating", vo);
  }

  // 댓글 별점 조회
  public List<CommentRatingVO> getRatingByCommentNo(int commentNo, String isbn) {
    return sqlSession.selectList(name_space+"getRatingByCommentNo", 
      new HashMap<String, Object>() {{
        put("commentNo", commentNo);
        put("isbn", isbn);
        }});
  }

  // 사용자가 해당 댓글에 별점을 남겼는지 확인
  public int checkRatingExist(int commentNo, String userId, String isbn) {
    return sqlSession.selectOne(name_space+"checkRatingExist", 
      new HashMap<String, Object>() {{
        put("commentNo", commentNo);
        put("userId", userId);
        put("isbn", isbn);
        }});
  }
}
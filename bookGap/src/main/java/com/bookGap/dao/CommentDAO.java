package com.bookGap.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CommentVO;

@Repository
public class CommentDAO {
	
	@Autowired 
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.commentMapper.";

  public List<CommentVO> getCommentListWithDetails(Map<String, Object> params) {
    // selectList는 결과가 여러 개일 때 사용합니다.
    return sqlSession.selectList(name_space + "getCommentListWithDetails", params);
  }

  public int selectTotal(String isbn) {
    // selectOne은 결과가 단 하나의 행(row)일 때 사용.
    return sqlSession.selectOne(name_space + "selectTotal", isbn);
  }

  public int insert(CommentVO vo) {
    return sqlSession.insert(name_space + "insert", vo);
  }

  public CommentVO selectOne(int commentNo) {
    return sqlSession.selectOne(name_space + "selectOne", commentNo);
  }

  public int update(CommentVO vo) {
    return sqlSession.update(name_space + "update", vo);
  }

  public int changeState(int commentNo) {
    return sqlSession.update(name_space + "changeState", commentNo);
  }
}
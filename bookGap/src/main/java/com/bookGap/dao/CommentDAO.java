package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CommentVO;
import com.bookGap.vo.SearchVO;

@Repository
public class CommentDAO {
	
	@Autowired 
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.commentMapper.";

	public List<CommentVO> clist(SearchVO searchVO){
		return sqlSession.selectList(name_space+"clist",searchVO);
	}
	
	public int total(SearchVO searchVO) {
		return sqlSession.selectOne(name_space+"selectTotal",searchVO);
	}
	
	public int insert(CommentVO vo) {
		return sqlSession.insert(name_space+"insert", vo);
	}
	
	public CommentVO selectOne(int commentNo) {
		return sqlSession.selectOne(name_space+"selectOne", commentNo);
	}
	
	public int changeState(int commentNo) {
		return sqlSession.update(name_space+"changeState",commentNo);
	}
	
	public int update(CommentVO vo) {
		return sqlSession.update(name_space+"update", vo);
	}
	
	public String getBookWriterId(int bookNo){
		return sqlSession.selectOne(name_space+"getBookWriterId", bookNo);
	}
}
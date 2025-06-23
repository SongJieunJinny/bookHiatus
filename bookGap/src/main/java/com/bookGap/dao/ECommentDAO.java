package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.ECommentVO;
import com.bookGap.vo.SearchVO;

@Repository
public class ECommentDAO {
	
	@Autowired 
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.eCommentMapper.";
	
	public List<ECommentVO> clist(SearchVO searchVO){
		return sqlSession.selectList(name_space+"clist",searchVO);
	}
	
	public int total(SearchVO searchVO) {
		return sqlSession.selectOne(name_space+"selectTotal",searchVO);
	}
	
	public int insert(ECommentVO vo) {
		return sqlSession.insert(name_space+"insert", vo);
	}
	
	public ECommentVO selectOne(int eCommentNo) {
		return sqlSession.selectOne(name_space+"selectOne", eCommentNo);
	}
	
	public int changeState(int eCommentNo) {
		return sqlSession.update(name_space+"changeState",eCommentNo);
	}
	
	public int update(ECommentVO vo) {
		return sqlSession.update(name_space+"update", vo);
	}
	
	public String getBoardWriterId(int boardNo){
		return sqlSession.selectOne(name_space+"getBoardWriterId", boardNo);
	}

}
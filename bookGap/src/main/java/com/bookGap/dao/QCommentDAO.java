package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.QCommentVO;
import com.bookGap.vo.SearchVO;

@Repository
public class QCommentDAO {
	
	@Autowired 
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.qCommentMapper.";
	
	public List<QCommentVO> clist(SearchVO searchVO){
		return sqlSession.selectList(name_space+"clist",searchVO);
	}
	
	public int total(SearchVO searchVO) {
		return sqlSession.selectOne(name_space+"selectTotal",searchVO);
	}
	
	public int insert(QCommentVO vo) {
		return sqlSession.insert(name_space+"insert", vo);
	}
	
	public QCommentVO selectOne(int qCommentNo) {
		return sqlSession.selectOne(name_space+"selectOne", qCommentNo);
	}
	
	public int changeState(int qCommentNo) {
		return sqlSession.update(name_space+"changeState",qCommentNo);
	}
	
	public int update(QCommentVO vo) {
		return sqlSession.update(name_space+"update", vo);
	}

}
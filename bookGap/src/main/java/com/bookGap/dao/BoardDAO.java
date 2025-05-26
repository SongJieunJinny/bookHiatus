package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

@Repository
public class BoardDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.boardMapper.";
	
	public List<BoardVO> list(SearchVO searchVO){
		return sqlSession.selectList(name_space+"noticeList",searchVO);
	}
	
	public int noticeInsert(BoardVO boardVO) {
		return sqlSession.insert(name_space+"noticeInsert", boardVO);
	}
	
	public BoardVO selectOne(int boardNo) {
		return sqlSession.selectOne(name_space+"selectOne", boardNo);
	}

    public int update(BoardVO boardNo) {
		return sqlSession.update(name_space+"update", boardNo);
	}
}

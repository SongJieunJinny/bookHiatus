package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.BoardDAO;
import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

@Service
public class BoardServiceImpl implements BoardService{
	
	@Autowired
	public BoardDAO boardDAO;

	@Override
	public List<BoardVO> list(SearchVO searchVO) {
		return boardDAO.list(searchVO);
	}

	@Override
	public int noticeInsert(BoardVO boardVO) {
		return boardDAO.noticeInsert(boardVO);
	}

	@Override
	public BoardVO selectOne(int boardNo) {
		return boardDAO.selectOne(boardNo);
	}

	@Override
	public int update(BoardVO boardNo) {
		return boardDAO.update(boardNo);
	}

}

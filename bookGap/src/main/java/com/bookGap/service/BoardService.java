package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

public interface BoardService {
	
	public List<BoardVO> list(SearchVO searchVO); 
	
	public int boardListSearch(SearchVO searchVO);
	
	public int insert(BoardVO boardVO);
	
	public BoardVO selectOne(int boardNo);
	
	public int updateHit(int boardNo);
	
	public int update(BoardVO boardNo);
	
	public int changeState(int boardNo);
	
	public List<BoardVO> qnaList(SearchVO searchVO);
	
	public List<BoardVO> eventList(SearchVO searchVO);

}

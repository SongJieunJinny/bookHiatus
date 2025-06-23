package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.ECommentVO;
import com.bookGap.vo.SearchVO;

public interface ECommentService {
	
	public List<ECommentVO> clist(SearchVO searchVO);
	
	public int selectTotal(SearchVO searchVO);
	
	public int insert(ECommentVO vo);
	
	public ECommentVO selectOne(int eCommentNo);
	
	public int changeState(int eCommentNo);
	
	public int update(ECommentVO vo);
	
	public String getBoardWriterId(int boardNo);

}
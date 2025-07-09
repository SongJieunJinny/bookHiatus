package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.CommentVO;
import com.bookGap.vo.SearchVO;

public interface CommentService {
	
	public List<CommentVO> clist(SearchVO searchVO);
	
	public int selectTotal(SearchVO searchVO);
	
	public int insert(CommentVO vo);
	
	public CommentVO selectOne(int commentNo);
	
	public int changeState(int commentNo);
	
	public int update(CommentVO vo);
	
	public String getBookWriterId(String isbn);

	public CommentVO selectIsbn(String isbn);

}
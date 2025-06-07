package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.QCommentVO;
import com.bookGap.vo.SearchVO;

public interface QCommentService {
	
	public List<QCommentVO> clist(SearchVO searchVO);
	
	public int selectTotal(SearchVO searchVO);
	
	public int insert(QCommentVO vo);
	
	public QCommentVO selectOne(int qCommentNo);
	
	public int changeState(int qCommentNo);
	
	public int update(QCommentVO vo);
}

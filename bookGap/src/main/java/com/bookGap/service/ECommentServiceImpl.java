package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.ECommentDAO;
import com.bookGap.vo.ECommentVO;
import com.bookGap.vo.SearchVO;

@Service
public class ECommentServiceImpl implements ECommentService{
	
	@Autowired
	public ECommentDAO eCommentDAO;

	@Override
	public List<ECommentVO> clist(SearchVO searchVO) {
		return eCommentDAO.clist(searchVO);
	}

	@Override
	public int selectTotal(SearchVO searchVO) {
		return eCommentDAO.total(searchVO);
	}

	@Override
	public int insert(ECommentVO vo) {
		return eCommentDAO.insert(vo);
	}

	@Override
	public ECommentVO selectOne(int eCommentNo) {
		return eCommentDAO.selectOne(eCommentNo);
	}

	@Override
	public int changeState(int eCommentNo) {
		return eCommentDAO.changeState(eCommentNo);
	}

	@Override
	public int update(ECommentVO vo) {
		return eCommentDAO.update(vo);
	}

	@Override
	public String getBoardWriterId(int boardNo) {
		return eCommentDAO.getBoardWriterId(boardNo);
	}

}
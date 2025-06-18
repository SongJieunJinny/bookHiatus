package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.QCommentDAO;
import com.bookGap.vo.QCommentVO;
import com.bookGap.vo.SearchVO;

@Service
public class QCommentServiceImpl implements QCommentService{

	@Autowired
	public QCommentDAO qCommentDAO;

	@Override
	public List<QCommentVO> clist(SearchVO searchVO) {
		return qCommentDAO.clist(searchVO);
	}

	@Override
	public int selectTotal(SearchVO searchVO) {
		return qCommentDAO.total(searchVO);
	}

	@Override
	public int insert(QCommentVO vo) {
		return qCommentDAO.insert(vo);
	}

	@Override
	public QCommentVO selectOne(int qCommentNo) {
		return qCommentDAO.selectOne(qCommentNo);
	}

	@Override
	public int changeState(int qCommentNo) {
		return qCommentDAO.changeState(qCommentNo);
	}	

	@Override
	public int update(QCommentVO vo) {
		return qCommentDAO.update(vo);
	}

	@Override
	public String getBoardWriterId(int boardNo) {
		return qCommentDAO.getBoardWriterId(boardNo);
	}
}
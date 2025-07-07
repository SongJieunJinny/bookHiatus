package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.CommentDAO;
import com.bookGap.vo.CommentVO;
import com.bookGap.vo.SearchVO;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	public CommentDAO commentDAO;

	@Override
	public List<CommentVO> clist(SearchVO searchVO) {
		return commentDAO.clist(searchVO);
	}

	@Override
	public int selectTotal(SearchVO searchVO) {
		return commentDAO.total(searchVO);
	}

	@Override
	public int insert(CommentVO vo) {
		return commentDAO.insert(vo);
	}

	@Override
	public CommentVO selectOne(int commentNo) {
		return commentDAO.selectOne(commentNo);
	}

	@Override
	public int changeState(int commentNo) {
		return commentDAO.changeState(commentNo);
	}

	@Override
	public int update(CommentVO vo) {
		return commentDAO.update(vo);
	}

	@Override
	public String getBookWriterId(String isbn) {
		return commentDAO.getBookWriterId(isbn);
	}
	
  @Override
  public CommentVO selectIsbn(String isbn) {
    return commentDAO.selectIsbn(isbn);
  }

}
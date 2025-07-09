package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.CommentLoveDAO;
import com.bookGap.vo.CommentLoveVO;

@Service
public class CommentLoveServiceImpl implements CommentLoveService{
  
  @Autowired
  private CommentLoveDAO commentLoveDAO;

  @Override
  public boolean isLovedByUser(CommentLoveVO vo) {
    return commentLoveDAO.isLovedByUser(vo);
  }

  @Override
  public int insertLove(CommentLoveVO vo) {
    return commentLoveDAO.insertLove(vo);
  }

  @Override
  public int deleteLove(CommentLoveVO vo) {
    return commentLoveDAO.deleteLove(vo);
  }
}
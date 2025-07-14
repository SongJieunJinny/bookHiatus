package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.CommentRatingDAO;
import com.bookGap.vo.CommentRatingVO;

@Service
public class CommentRatingServiceImpl implements CommentRatingService{

  @Autowired
  private CommentRatingDAO commentRatingDAO;

  @Override
  public String saveRating(CommentRatingVO vo) {
    int result = commentRatingDAO.insertRating(vo);
    return result > 0 ? "Success" : "Fail";
  }

  @Override
  public String updateRating(CommentRatingVO vo) {
    int result = commentRatingDAO.updateRating(vo);
    return result > 0 ? "Success" : "Fail";
  }

  @Override
  public String upsertRating(CommentRatingVO vo) {
    int result = commentRatingDAO.upsertRating(vo);
    return result > 0 ? "Success" : "Fail";
  }

  @Override
  public CommentRatingVO getUserRating(int commentNo, String isbn, String userId) {
    return commentRatingDAO.selectUserRating(commentNo, isbn, userId);
  }

}
package com.bookGap.service;

import java.util.List;

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
    int existingRating = commentRatingDAO.checkRatingExist(vo.getCommentNo(), vo.getUserId(), vo.getIsbn());
    if (existingRating > 0) {
        return "이미 별점을 남겼습니다.";  // 이미 평가한 경우
    }
    int result = commentRatingDAO.insertRating(vo);
    return result > 0 ? "Success" : "Fail";
  }

  @Override
  public String updateRating(CommentRatingVO vo) {
    int result = commentRatingDAO.updateRating(vo);
    return result > 0 ? "Success" : "Fail";
  }

  @Override
  public List<CommentRatingVO> getRatingsByCommentNo(int commentNo, String isbn) {
    return commentRatingDAO.getRatingByCommentNo(commentNo, isbn);
  }
}

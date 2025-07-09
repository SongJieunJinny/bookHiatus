package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.CommentRatingVO;

public interface CommentRatingService {
  
  public String saveRating(CommentRatingVO vo);
  
  public String updateRating(CommentRatingVO vo);

  public List<CommentRatingVO> getRatingsByCommentNo(int commentNo, String isbn);
}

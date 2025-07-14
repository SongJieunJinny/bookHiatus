package com.bookGap.service;

import com.bookGap.vo.CommentRatingVO;

public interface CommentRatingService {
  
  public String saveRating(CommentRatingVO vo);  // 별점 등록
  
  public String updateRating(CommentRatingVO vo);  //별점 수정

  public String upsertRating(CommentRatingVO vo);  //별점없으면 추가
  
  public CommentRatingVO getUserRating(int commentNo, String isbn, String userId); // 유저의 별점 조회


}

package com.bookGap.service;

import com.bookGap.vo.CommentLoveVO;

public interface CommentLoveService {
  
  public boolean isLovedByUser(CommentLoveVO vo);
  
  public int insertLove(CommentLoveVO vo);
  
  public int deleteLove(CommentLoveVO vo);

}
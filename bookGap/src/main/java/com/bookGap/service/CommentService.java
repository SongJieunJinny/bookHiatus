package com.bookGap.service;

import java.util.Map;

import com.bookGap.vo.CommentVO;

public interface CommentService {
	
  Map<String, Object> getCommentList(String isbn, String loginUserId, int cnowpage);
  
  void writeComment(CommentVO commentVO, int rating, boolean liked);
  
  void modifyComment(CommentVO commentVO, int rating, boolean liked);
  
  void deleteComment(int commentNo, String loginUserId, boolean isAdmin) throws IllegalAccessException;
  
  CommentVO selectOne(int commentNo);

}
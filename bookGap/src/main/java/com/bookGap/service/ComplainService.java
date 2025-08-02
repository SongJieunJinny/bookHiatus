package com.bookGap.service;

import com.bookGap.vo.ComplainVO;

public interface ComplainService {
  
  //유저가 특정 댓글을 신고했는지 여부 반환
  public boolean countComplain(ComplainVO complainVO);

  // 신고 접수
  public void insertComplain(ComplainVO complainVO);

}

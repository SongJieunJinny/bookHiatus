package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.ComplainSummaryVO;
import com.bookGap.vo.ComplainVO;

public interface ComplainService {
  
  //유저가 특정 댓글을 신고했는지 여부 반환
  public boolean countComplain(ComplainVO complainVO);

  // 신고 접수
  public void insertComplain(ComplainVO complainVO);
  
  public  ComplainVO getComplainDetail(int complainNo);
  public  void updateComplainStatus(ComplainVO vo);
  public  void updateCommentState(ComplainVO vo);
  public  List<ComplainSummaryVO> getReportSummary();
  public List<ComplainVO> getComplainListByCommentNo(int commentNo);
  public List<ComplainSummaryVO> getReportSummaryByStatus(String status);

}

package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.ComplainDAO;
import com.bookGap.vo.ComplainSummaryVO;
import com.bookGap.vo.ComplainVO;

@Service
public class ComplainServiceImpl implements ComplainService{

  @Autowired
  public ComplainDAO complainDAO;

  @Override
  public boolean countComplain(ComplainVO complainVO) {
    return complainDAO.countComplain(complainVO) > 0;
  }

  @Override
  public void insertComplain(ComplainVO complainVO) {
    complainDAO.insertComplain(complainVO);
  }

  @Override
  public ComplainVO getComplainDetail(int complainNo) {
      return complainDAO.selectComplainDetail(complainNo);
  }

  @Override
  public void updateComplainStatus(ComplainVO vo) {
      complainDAO.updateComplainStatus(vo);
  }
  
  @Override
  public void updateCommentState(ComplainVO vo) {
      complainDAO.updateCommentState(vo);
  }
  
  @Override
  public List<ComplainSummaryVO> getReportSummary() {
	    return complainDAO.selectReportSummary();
	}
  @Override
  public List<ComplainVO> getComplainListByCommentNo(int commentNo) {
      return complainDAO.selectComplainListByCommentNo(commentNo);
  }

  @Override
  public List<ComplainSummaryVO> getReportSummaryByStatus(String status) {
      return complainDAO.selectReportSummaryByStatus(status);
  }
}

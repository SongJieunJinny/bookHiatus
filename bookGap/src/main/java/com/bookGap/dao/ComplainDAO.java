package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.ComplainSummaryVO;
import com.bookGap.vo.ComplainVO;

@Repository
public class ComplainDAO {

  @Autowired 
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.complainMapper.";
  
//특정 댓글에 대해 해당 유저가 신고했는지 확인
  public int countComplain(ComplainVO complainVO) {
    return sqlSession.selectOne(name_space + "countComplain", complainVO);
  }

  // 새로운 신고 등록
  public void insertComplain(ComplainVO complainVO) {
    sqlSession.insert(name_space + "insertComplain", complainVO);
  }
  
  public ComplainVO selectComplainDetail(int complainNo) {
      return sqlSession.selectOne(name_space+ "selectComplainDetail", complainNo);
  }

  public int updateComplainStatus(ComplainVO vo) {
      return sqlSession.update(name_space + "updateComplainStatus", vo);
  }
  
  public void updateCommentState(ComplainVO vo) {
	    sqlSession.update(name_space + "updateCommentState", vo);
	}
  
  public List<ComplainSummaryVO> selectReportSummary() {
	    return sqlSession.selectList(name_space + "selectReportSummary");
	}
  public List<ComplainVO> selectComplainListByCommentNo(int commentNo) {
	    return sqlSession.selectList(name_space + "selectComplainListByCommentNo", commentNo);
	}

	public List<ComplainSummaryVO> selectReportSummaryByStatus(String status) {
	    return sqlSession.selectList(name_space + "selectReportSummaryByStatus", status);
	}

}
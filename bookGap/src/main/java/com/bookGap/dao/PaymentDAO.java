package com.bookGap.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.KakaoPayCancelVO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossCancelVO;
import com.bookGap.vo.TossRequestVO;

@Repository
public class PaymentDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private final String namespace = "com.bookGap.mapper.paymentMapper.";
  
  //공통 결제
  public void insertPayment(PaymentVO paymentVO) {
    sqlSession.insert(namespace + "insertPayment", paymentVO);
 }

  public void updatePaymentStatus(Map<String, Object> paramMap) {
    sqlSession.update(namespace + "updatePaymentStatus", paramMap);
  }

  // ========== 카카오페이 ==========
  public void insertKakaoRequest(KakaoPayRequestVO kakaoPayRequestVO) {
    sqlSession.insert(namespace + "insertKakaoRequest", kakaoPayRequestVO);
  }

  public void updateKakaoTid(KakaoPayRequestVO kakaoPayRequestVO) {
    sqlSession.update(namespace + "updateKakaoTid", kakaoPayRequestVO);
  }

  public KakaoPayRequestVO findKakaoRequestByPaymentNo(int paymentNo) {
    return sqlSession.selectOne(namespace + "findKakaoRequestByPaymentNo", paymentNo);
  }

  public void insertKakaoCancel(KakaoPayCancelVO kakaoPayCancelVO) {
    sqlSession.insert(namespace + "insertKakaoCancel", kakaoPayCancelVO);
  }

  // ========== 토스페이먼츠 ==========
  public void insertTossRequest(TossRequestVO tossRequestVO) {
    sqlSession.insert(namespace + "insertTossRequest", tossRequestVO);
  }

  public void updateTossPaymentKey(TossRequestVO tossRequestVO) {
    sqlSession.update(namespace + "updateTossPaymentKey", tossRequestVO);
  }

  public TossRequestVO findTossRequestByPaymentNo(int paymentNo) {
    return sqlSession.selectOne(namespace + "findTossRequestByPaymentNo", paymentNo);
  }

  public void insertTossCancel(TossCancelVO tossCancelVO) {
    sqlSession.insert(namespace + "insertTossCancel", tossCancelVO);
  }
  
  public PaymentVO getPaymentByNo(int paymentNo) {
	    return sqlSession.selectOne(namespace + "getPaymentByNo", paymentNo);
	}
}
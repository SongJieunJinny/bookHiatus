package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.RecommendBookVO;
import com.bookGap.vo.SearchVO;

@Repository
public class RecommendBookDAO {

    @Autowired
    private SqlSession sqlSession;

    private final String namespace = "com.bookGap.mapper.recommendBookMapper.";

    // 추천 도서 목록 (페이징)
    public List<RecommendBookVO> selectRecommendBooks(SearchVO vo) {
        return sqlSession.selectList(namespace + "selectRecommendBooks", vo);
    }

    // 추천 도서 개수 (페이징용)
    public int getRecommendBookTotalCount(SearchVO vo) {
        return sqlSession.selectOne(namespace + "getRecommendBookTotalCount", vo);
    }

    // 추천 도서 등록
    public void insertRecommendBook(RecommendBookVO vo) {
        sqlSession.insert(namespace + "insertRecommendBook", vo);
    }

    // 추천 도서 삭제
    public void deleteRecommendBook(int bookNo, String recommendType) {
        RecommendBookVO vo = new RecommendBookVO();
        vo.setBookNo(bookNo);
        vo.setRecommendType(recommendType);
        sqlSession.delete(namespace + "deleteRecommendBook", vo);
    }
    // 추천 도서 정보 업데이트 (추천 타입/사유 변경)
    public void updateRecommendBook(RecommendBookVO vo) {
        sqlSession.update(namespace + "updateRecommendBook", vo);
    }
}
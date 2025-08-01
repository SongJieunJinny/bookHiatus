package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.RecommendBookDAO;
import com.bookGap.vo.RecommendBookVO;
import com.bookGap.vo.SearchVO;

@Service
public class RecommendBookServiceImpl implements RecommendBookService  {
	@Autowired
    private RecommendBookDAO recommendBookDAO;

    @Override
    public List<RecommendBookVO> getRecommendBooks(SearchVO vo) {
        return recommendBookDAO.selectRecommendBooks(vo);
    }

    @Override
    public int getTotalRecommendBooks(SearchVO vo) {
        return recommendBookDAO.getRecommendBookTotalCount(vo);
    }

    @Override
    public void addRecommendBook(RecommendBookVO vo) {
        recommendBookDAO.insertRecommendBook(vo);
    }

    @Override
    public void removeRecommendBook(int bookNo, String recommendType) {
        recommendBookDAO.deleteRecommendBook(bookNo, recommendType);
    }
    
    @Override
    public void updateRecommendBook(RecommendBookVO vo) {
        recommendBookDAO.updateRecommendBook(vo);
    }
    
    @Override
    public List<String> getAllRecommendTypes() {
        return recommendBookDAO.getAllRecommendTypes();
    }

}

package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.RecommendBookVO;
import com.bookGap.vo.SearchVO;

public interface RecommendBookService {
	List<RecommendBookVO> getRecommendBooks(SearchVO vo);
    int getTotalRecommendBooks(SearchVO vo);

    void addRecommendBook(RecommendBookVO vo);
    void removeRecommendBook(int bookNo, String recommendType);
    void updateRecommendBook(RecommendBookVO vo);
    List<String> getAllRecommendTypes();

}

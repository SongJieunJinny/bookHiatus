package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.BookService;
import com.bookGap.service.RecommendBookService;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.RecommendBookVO;
import com.bookGap.vo.SearchVO;

@Controller
public class ChoiceController {
	
	  @Autowired
	    public RecommendBookService recommendBookService;

	    @RequestMapping(value = "choice/choiceList.do", method = RequestMethod.GET)
	    public String choiceList(@RequestParam(value = "nowpage", required = false, defaultValue = "1") int nowpage,
	                             @RequestParam(value = "recommendType", required = false, defaultValue = "") String recommendType,
	                             SearchVO searchVO,
	                             Model model) {

	        // 페이징 및 추천 타입 설정
	        searchVO.setNowPage(nowpage);
	        searchVO.setPerPage(5);
	        searchVO.setRecommendType(recommendType);

	        // 전체 추천 도서 개수 가져오기
	        int total = recommendBookService.getTotalRecommendBooks(searchVO);
	        searchVO.setTotal(total);

	        // 페이징 계산
	        searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
	        searchVO.calcLastPage(total, searchVO.getPerPage());
	        searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());

	        // 추천 도서 목록 가져오기
	        List<RecommendBookVO> selectBookList = recommendBookService.getRecommendBooks(searchVO);

	        // 뷰로 데이터 전달
	        model.addAttribute("selectBookList", selectBookList);
	        model.addAttribute("paging", searchVO);
	        model.addAttribute("recommendType", recommendType);

	        return "choice/choiceList";
	    }
}

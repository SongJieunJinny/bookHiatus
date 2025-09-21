package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.RecommendBookService;
import com.bookGap.vo.RecommendBookVO;
import com.bookGap.vo.SearchVO;

@Controller
public class AdminRecommendController {

    @Autowired
    private RecommendBookService recommendBookService;

    // 추천 도서 리스트 (필터링 포함)
    @GetMapping("/admin/adminRecommendBooks.do")
    public String adminRecommendBooks(@RequestParam(value = "recommendType", required = false, defaultValue = "") String recommendType,
                       @RequestParam(value = "nowpage", required = false, defaultValue = "1") int nowpage,
                       SearchVO searchVO,
                       Model model) {

        searchVO.setNowPage(nowpage);
        searchVO.setPerPage(10);
        searchVO.setRecommendType(recommendType); // 필터 조건 추가

        int total = recommendBookService.getTotalRecommendBooks(searchVO);
        searchVO.setTotal(total);
        searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
        searchVO.calcLastPage(total, searchVO.getPerPage());
        searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());

        List<RecommendBookVO> recommendBooks = recommendBookService.getRecommendBooks(searchVO);
        List<String> recommendTypes = recommendBookService.getAllRecommendTypes();

        model.addAttribute("recommendBooks", recommendBooks);
        model.addAttribute("paging", searchVO);
        model.addAttribute("recommendType", recommendType); // 필터 상태 유지
        model.addAttribute("recommendTypes", recommendTypes);

        return "admin/adminRecommendBooks";
    }

    // 추천 도서 등록 (Upsert)
    @PostMapping("/admin/recommend/add.do")
    @ResponseBody
    public String add(@RequestParam int bookNo,
			                      @RequestParam(defaultValue = "BASIC") String recommendType,
			                      @RequestParam(defaultValue = "") String recommendComment) {
    	
    	recommendType = recommendType.trim();  // 공백 제거
    	    if (recommendType.isEmpty()) {
    	        return "추천 타입이 유효하지 않습니다.";
    	    }
    	
        RecommendBookVO vo = new RecommendBookVO();
        vo.setBookNo(bookNo);
        vo.setRecommendType(recommendType);
        vo.setRecommendComment(recommendComment);
        recommendBookService.addRecommendBook(vo);
        return "success";
    }

    // 추천 도서 삭제
    @PostMapping("/admin/recommend/delete.do")
    @ResponseBody
    public String delete(@RequestParam int bookNo, @RequestParam String recommendType) {
        recommendBookService.removeRecommendBook(bookNo, recommendType);
        return "success";
    }

    @PostMapping("/admin/recommend/update.do")
    @ResponseBody
    public String update(@RequestParam int bookNo,
                         @RequestParam String oldRecommendType,
                         @RequestParam String recommendType,
                         @RequestParam String recommendComment) {
        RecommendBookVO vo = new RecommendBookVO();
        vo.setBookNo(bookNo);
        vo.setOldRecommendType(oldRecommendType);
        vo.setRecommendType(recommendType);
        vo.setRecommendComment(recommendComment); //  중요
        recommendBookService.updateRecommendBook(vo);
        return "success";
    }
}

package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bookGap.service.BookService;
import com.bookGap.vo.SearchVO;
import com.bookGap.vo.ProductApiVO;

@Controller
public class SearchController {
  
  @Autowired public BookService bookService; 

  @RequestMapping("/product/bookSearch.do")
  public String searchBooks(@ModelAttribute("searchVO") SearchVO searchVO, Model model) {
    
    if (searchVO.getSearchValue() == null || searchVO.getSearchValue().trim().isEmpty()) {
        model.addAttribute("error", "검색어를 입력해주세요.");
        return "search/bookSearch";
    }

    int perPage = 10;
    int nowPage = searchVO.getNowPage() == 0 ? 1 : searchVO.getNowPage();
    int start = (nowPage - 1) * perPage;

    searchVO.setPerPage(perPage);
    searchVO.setNowPage(nowPage);
    searchVO.setStart(start);

    int total = bookService.getBookTotalCountByKeyword(searchVO);
    searchVO.setTotal(total);
    
    List<ProductApiVO> bookList = bookService.searchBooksByKeyword(searchVO);
    
    model.addAttribute("bookList", bookList);            // 검색된 책 목록
    model.addAttribute("paging", searchVO);               // 페이지 정보
    model.addAttribute("searchKeyword", searchVO.getSearchValue()); // 검색어를 화면에 표시하기 위함 JSP에서 '${searchKeyword}'로 검색어 표시

    return "product/bookSearch";
  }

}
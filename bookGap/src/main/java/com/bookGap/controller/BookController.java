package com.bookGap.controller;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.BookService;
import com.bookGap.service.ProductApiService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

@Controller
public class BookController {
	@Autowired
	public BookService bookService;
	
	@RequestMapping(value = "product/bookList.do", method = RequestMethod.GET)
	public String bookList(@RequestParam(required = false) String category,
	                       @RequestParam(value = "nowpage", required = false, defaultValue = "1") int nowpage,
	                       SearchVO searchVO,
	                       Model model) {

	    searchVO.setNowPage(nowpage);
	    searchVO.setPerPage(15); // 페이지당 항목 수
	    searchVO.setCategory(category); // 카테고리 필터용 (SearchVO에 추가 필요)
	    
	    
	    System.out.println("Current Page: " + nowpage);
	    System.out.println("Per Page: " + searchVO.getPerPage());
	    System.out.println("Category: " + category);
	    // 전체 개수 조회
	    int total = (category != null && !category.isEmpty())
	                ? bookService.getTotalByCategory(searchVO)
	                : bookService.getTotalBookCount(searchVO);
	    System.out.println("Total books: " + total);
	    searchVO.setTotal(total);
	    searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
	    searchVO.calcLastPage(total, searchVO.getPerPage());
	    searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());
	    System.out.println("Start Index: " + searchVO.getStart());
	    System.out.println("End Index: " + searchVO.getEnd());

	    // 책 목록 조회 (카테고리 필터 여부에 따라)
	    List<ProductApiVO> selectBookList;
	    if (category != null && !category.isEmpty()) {
	    	
	        selectBookList = bookService.getBooksByCategoryPaging(searchVO);
	    } else {
	    	
	        selectBookList = bookService.getBooksPaging(searchVO);
	    }
	    
	    System.out.println("Books returned: " + (selectBookList != null ? selectBookList.size() : 0));
	    if (selectBookList != null) {
	        for (ProductApiVO vo : selectBookList) {
	            System.out.println(" - " + vo.getTitle());
	        }
	    }
 
	    List<String> categories = bookService.getDistinctCategories();

	    model.addAttribute("selectBookList", selectBookList);
	    model.addAttribute("bookCategories", categories);
	    model.addAttribute("paging", searchVO);
	    model.addAttribute("searchType", searchVO.getSearchType());
	    model.addAttribute("searchValue", searchVO.getSearchValue());
	    model.addAttribute("category", category); // 선택된 카테고리 유지용

	    return "product/bookList";
	}
	
	@RequestMapping(value = "/product/bookView.do", method = RequestMethod.GET)
	public String bookDetail(@RequestParam("isbn") String isbn, Model model) {
		BookVO bookDetail = bookService.getBookDetailByIsbn(isbn);
	    List<String> categories = bookService.getDistinctCategories();
	    
	    model.addAttribute("bookCategories", categories);
	    model.addAttribute("bookDetail", bookDetail);
	    return "product/bookView"; // 해당 JSP 파일명
	}

	

}

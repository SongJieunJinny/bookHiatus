package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.BookService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

@Controller
public class BookController {
	@Autowired
	public BookService bookService; 
	
	@GetMapping("product/bookList.do")
	public String bookList(@RequestParam(required = false) String category,
	                       @RequestParam(value = "nowpage", required = false, defaultValue = "1") int nowpage,
	                       @RequestParam(value = "sort", required = false, defaultValue = "recent") String sort,
	                       SearchVO searchVO,
	                       Model model) {

	    // 1) category 정규화 (빈문자 → null)
	    if (category != null && category.trim().isEmpty()) {
	        category = null;
	    }

	    // 2) 기본 페이징 파라미터
	    searchVO.setNowPage(nowpage);
	    searchVO.setPerPage(15);
	    searchVO.setCategory(category);
	    searchVO.setSort(sort);

	    int total;
	    List<ProductApiVO> selectBookList;

	    // 3) 정렬 분기
	    if ("popular".equalsIgnoreCase(sort)) {
	        // 인기 정렬: 전체/카테고리 인기 모두 여기서 처리
	        total = bookService.getPopularTotalCount(searchVO);   // ★ 인기 기준 total
	        searchVO.setTotal(total);
	        searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
	        searchVO.calcLastPage(total, searchVO.getPerPage());
	        searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());

	        selectBookList = bookService.getPopularBooks(searchVO); // ★ 인기 목록
	    } else {
	        // 최신 정렬: 카테고리 여부에 따라 total과 목록 분리
	        total = (category != null)
	                ? bookService.getTotalByCategory(searchVO)
	                : bookService.getTotalBookCount(searchVO);

	        searchVO.setTotal(total);
	        searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
	        searchVO.calcLastPage(total, searchVO.getPerPage());
	        searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());

	        selectBookList = (category != null)
	                ? bookService.getBooksByCategoryPaging(searchVO)
	                : bookService.getBooksPaging(searchVO);
	    }

	    // 4) 공통 모델 세팅
	    List<String> categories = bookService.getDistinctCategories();

	    model.addAttribute("selectBookList", selectBookList);
	    model.addAttribute("bookCategories", categories);
	    model.addAttribute("paging", searchVO);
	    model.addAttribute("searchType", searchVO.getSearchType());
	    model.addAttribute("searchValue", searchVO.getSearchValue());
	    model.addAttribute("category", category); // null이면 JSP에서 '모든 책'로 표시
	    model.addAttribute("sort", sort);

	    return "product/bookList";
	}
	
	@GetMapping("/product/bookView.do")
	public String bookDetail(@RequestParam("isbn") String isbn, Model model) {
	    isbn = isbn.trim();

	    BookVO bookDetail = bookService.getBookDetailByIsbn(isbn);
	    List<String> categories = bookService.getDistinctCategories();

	    model.addAttribute("bookCategories", categories);
	    model.addAttribute("bookDetail", bookDetail);

	    return "product/bookView"; // 해당 JSP 파일명
	}

}
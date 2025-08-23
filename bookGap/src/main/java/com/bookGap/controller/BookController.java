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
	                       SearchVO searchVO,
	                       Model model) {

	    searchVO.setNowPage(nowpage);
	    searchVO.setPerPage(15); // 페이지당 항목 수
	    searchVO.setCategory(category); // 카테고리 필터용

	    //System.out.println("Current Page: " + nowpage);
	    //System.out.println("Per Page: " + searchVO.getPerPage());
	    //System.out.println("Category: " + category);

	    int total = (category != null && !category.isEmpty())
	                ? bookService.getTotalByCategory(searchVO)
	                : bookService.getTotalBookCount(searchVO);
	    //System.out.println("Total books: " + total);

	    searchVO.setTotal(total);
	    searchVO.calcStartEnd(nowpage, searchVO.getPerPage());
	    searchVO.calcLastPage(total, searchVO.getPerPage());
	    searchVO.calcStartEndPage(nowpage, searchVO.getCntPage());

	    //System.out.println("Start Index: " + searchVO.getStart());
	    //System.out.println("End Index: " + searchVO.getEnd());

	    List<ProductApiVO> selectBookList = (category != null && !category.isEmpty())
	        ? bookService.getBooksByCategoryPaging(searchVO)
	        : bookService.getBooksPaging(searchVO);

	    //System.out.println("Books returned: " + (selectBookList != null ? selectBookList.size() : 0));
	    if (selectBookList != null) {
	        for (ProductApiVO vo : selectBookList) {
	            //System.out.println(" - " + vo.getTitle());
	        }
	    }

	    List<String> categories = bookService.getDistinctCategories();

	    model.addAttribute("selectBookList", selectBookList);
	    model.addAttribute("bookCategories", categories);
	    model.addAttribute("paging", searchVO);
	    model.addAttribute("searchType", searchVO.getSearchType());
	    model.addAttribute("searchValue", searchVO.getSearchValue());
	    model.addAttribute("category", category);

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
package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookGap.service.AdminBookService;
import com.bookGap.vo.BookVO;

@Controller
public class AdminBookController {
	@Autowired
    private AdminBookService adminBookService;
	// 도서 등록 처리 
	@PostMapping("/admin/books/bookInsert")
    @ResponseBody
    public ResponseEntity<String> insertBook(
    		@RequestParam("bookTrans") String bookTrans,
    		@RequestParam("isbn") String isbn,
    	    @RequestParam("bookCategory") String bookCategory,
    	    @RequestParam("bookImgUrl") String bookImgUrl, 
    	    @RequestParam("bookIndex") String bookIndex,
    	    @RequestParam("publisherBookReview") String publisherBookReview ) {

        // ISBN 존재 확인
        if (!adminBookService.isIsbnExists(isbn)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("해당 ISBN은 존재하지 않습니다. 먼저 상품 검색을 진행해주세요.");
        }

        // BookVO 생성 및 값 설정
        BookVO bookVO = new BookVO();
        bookVO.setBookTrans(bookTrans);
        bookVO.setIsbn(isbn);
        bookVO.setBookCategory(bookCategory);
        bookVO.setBookImgUrl(bookImgUrl);
        bookVO.setBookIndex(bookIndex);
        bookVO.setPublisherBookReview(publisherBookReview);

        // 등록
        adminBookService.insertBook(bookVO);
        return ResponseEntity.ok("도서가 성공적으로 등록되었습니다!");
    }
    // 도서 수정 처리
    @PostMapping("/admin/books/bookUpdate")
    public String updateBook(BookVO bookVO) {
    	adminBookService.updateBook(bookVO);
        return "redirect:/admin/adminBook.do";
    }

    // 도서 삭제 처리
    @PostMapping("/admin/books/bookDelete")
    public String deleteBook(@RequestParam("bookNo") int bookNo) {
    	adminBookService.deleteBook(bookNo);
        return "redirect:/admin/adminBook.do";
    }
    
    @GetMapping("/admin/adminBook.do")
	public String adminBook(Model model) {
		
		List<BookVO> getAllBooks = adminBookService.getAllBooks();
		
		model.addAttribute("getAllBooks",getAllBooks);
	
		return "admin/adminBook";
	}
	
}

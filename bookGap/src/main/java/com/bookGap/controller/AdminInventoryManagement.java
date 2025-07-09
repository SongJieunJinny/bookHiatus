package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminBookService;
import com.bookGap.vo.BookVO;

@Controller
public class AdminInventoryManagement {
	
	@Autowired
    private AdminBookService adminBookService;
	
	@PostMapping("/admin/books/updateInventory")
	@ResponseBody
	public ResponseEntity<String> updateInventory(
	    @RequestParam int bookNo,
	    @RequestParam(required = false) Integer bookStock,
	    @RequestParam(required = false) Integer bookState) {
		 System.out.println("bookNo: " + bookNo);
		    System.out.println("bookStock: " + bookStock);
		    System.out.println("bookState: " + bookState);
		
		if (bookNo <= 0 || (bookStock != null && bookStock < 0) || (bookState != null && (bookState < 0 || bookState > 1))) {
	        return ResponseEntity.badRequest().body("잘못된 요청입니다.");
	    }

	    BookVO vo = new BookVO();
	    vo.setBookNo(bookNo);
	    if (bookStock != null) vo.setBookStock(bookStock);
	    if (bookState != null) vo.setBookState(bookState);

	    adminBookService.updateInventory(vo);
	    return ResponseEntity.ok("success");
	}

}

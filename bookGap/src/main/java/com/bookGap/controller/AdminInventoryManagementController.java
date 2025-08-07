package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.BookService;
import com.bookGap.vo.BookVO;

@Controller
public class AdminInventoryManagementController {
	
	@Autowired
    private AdminBookService adminBookService;
	@Autowired
	public BookService bookService;
	
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
	
	
	@GetMapping("admin/adminInventoryManagement.do")
	public String adminInventoryManagement(Model model) {
	    List<BookVO> getInventoryManagementSelectAll = adminBookService.adminInventoryManagementSelectAll();
	    model.addAttribute("getInventoryManagementSelectAll", getInventoryManagementSelectAll);
	    return "admin/adminInventoryManagement";
	}

}

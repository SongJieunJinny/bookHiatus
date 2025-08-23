package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.BookService;
import com.bookGap.vo.ProductApiVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	@Autowired
	public BookService bookService;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
    List<ProductApiVO> newBooks = bookService.getNewBooks();
    model.addAttribute("newBooks", newBooks); // JSP는 ${book.image}, ${book.title} 그대로 사용 가능
    return "home";
	}
	
}

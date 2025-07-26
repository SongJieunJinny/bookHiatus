package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.BookService;

@Controller
public class CartController {
	@Autowired
	public BookService bookService;
	@RequestMapping(value = "/product/cart.do", method = RequestMethod.GET)
	public String cart() {
		
	    return "product/cart"; // 해당 JSP 파일명
	} 

}
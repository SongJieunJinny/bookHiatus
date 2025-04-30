package com.bookGap.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class adminIndexController {
	
	@RequestMapping(value = "admin/adminIndex.do", method = RequestMethod.GET)
	public String adminIndex() {
	
		return "admin/adminIndex";
	}
	
	@RequestMapping(value = "admin/adminBook.do", method = RequestMethod.GET)
	public String adminBook() {
	
		return "admin/adminBook";
	}
} 

package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.BookService;

@Controller
public class AboutController {
	@Autowired
	public BookService bookService;
	@RequestMapping(value = "/about.do", method = RequestMethod.GET)
	public String about() {
		
		return "about";
	}

}

package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.bookGap.service.BookService;

@ControllerAdvice
public class GlobalModelAttribute {
	@Autowired
    private BookService bookService;

    @ModelAttribute("bookCategories")
    public List<String> addBookCategories() {
        return bookService.getDistinctCategories();
    }

}

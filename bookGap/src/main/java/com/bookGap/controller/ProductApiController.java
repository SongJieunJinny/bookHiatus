package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.ProductApiService;

@Controller
public class ProductApiController {
	
	@Autowired
	public ProductApiService productApiService;
	
	@GetMapping("/fetchBooksByCategory")
    public String fetchBooksByCategory() {
        // 예시로 categoryId는 URL에서 입력받음
        productApiService.fetchAndStoreBooksByCategory();
        return "수집 완료";
    }
	 

}
